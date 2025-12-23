// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
 * BX Token (BEP-20 compatible on BNB Smart Chain)
 * Name: BX Token
 * Symbol: BX
 * Decimals: 18
 * Total Supply: 5,000,000,000 BX
 */

contract BXToken {

    string public name = "BX Token";
    string public symbol = "BX";
    uint8 public decimals = 18;

    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(address initialOwner) {
        require(initialOwner != address(0), "Invalid owner");
        owner = initialOwner;
        totalSupply = 5_000_000_000 * 10 ** uint256(decimals);
        balances[initialOwner] = totalSupply;
        emit Transfer(address(0), initialOwner, totalSupply);
    }

    // -------- ERC20 Standard --------

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function allowance(address owner_, address spender) public view returns (uint256) {
        return allowances[owner_][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(allowances[from][msg.sender] >= amount, "Allowance exceeded");
        allowances[from][msg.sender] -= amount;
        _transfer(from, to, amount);
        return true;
    }

    // -------- Internal --------

    function _transfer(address from, address to, uint256 amount) internal {
        require(to != address(0), "Transfer to zero");
        require(balances[from] >= amount, "Balance too low");
        balances[from] -= amount;
        balances[to] += amount;
        emit Transfer(from, to, amount);
    }

    // -------- Owner Functions --------

    function burn(uint256 amount) external onlyOwner {
        require(balances[owner] >= amount, "Not enough balance");
        balances[owner] -= amount;
        totalSupply -= amount;
        emit Transfer(owner, address(0), amount);
    }
}
