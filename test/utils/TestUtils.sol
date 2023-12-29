// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.23;

import { Test } from "../../lib/forge-std/src/Test.sol";

import { DigestHelper } from "./DigestHelper.sol";

contract TestUtils is Test {
    function _makeKey(string memory name) internal returns (uint256 privateKey) {
        (, privateKey) = makeAddrAndKey(name);
    }

    function _getCollateralUpdateSignature(
        address minterGateway,
        address minter,
        uint256 collateral,
        uint256[] memory retrievalIds,
        bytes32 metadataHash,
        uint256 timestamp,
        uint256 privateKey
    ) internal view returns (bytes memory) {
        return
            _getSignature(
                DigestHelper.getUpdateCollateralDigest(
                    minterGateway,
                    minter,
                    collateral,
                    retrievalIds,
                    metadataHash,
                    timestamp
                ),
                privateKey
            );
    }

    function _getCollateralUpdateShortSignature(
        address minterGateway,
        address minter,
        uint256 collateral,
        uint256[] memory retrievalIds,
        bytes32 metadataHash,
        uint256 timestamp,
        uint256 privateKey
    ) internal view returns (bytes memory) {
        return
            _getShortSignature(
                DigestHelper.getUpdateCollateralDigest(
                    minterGateway,
                    minter,
                    collateral,
                    retrievalIds,
                    metadataHash,
                    timestamp
                ),
                privateKey
            );
    }

    function _getSignature(bytes32 digest, uint256 privateKey) internal pure returns (bytes memory) {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);

        return abi.encodePacked(r, s, v);
    }

    function _getShortSignature(bytes32 digest, uint256 privateKey) internal pure returns (bytes memory) {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);

        bytes32 vs = s;

        if (v == 28) {
            // then left-most bit of s has to be flipped to 1 to get vs
            vs = s | bytes32(uint256(1) << 255);
        }

        return abi.encodePacked(r, vs);
    }
}