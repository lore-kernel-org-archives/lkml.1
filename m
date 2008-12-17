Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756240AbYLQQm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbYLQQm0 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbYLQQmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:42:01 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:65181 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751411AbYLQQmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:42:00 -0500
Message-Id: <20081217163634.998961917@vixen.sonytel.be>
User-Agent: quilt/0.46-1
Date: Wed, 17 Dec 2008 17:36:35 +0100
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH/RFC 0/8] Partial decompression API
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series adds support for partial (de)compression to the
CRYPTO API, and modifies SquashFS 4 to use this:
  [1] crypto: testmgr - Correct comment about deflate parameters
  [2] crypto: compress - Add pcomp interface
  [3] crypto: testmgr - Add support for the pcomp interface
  [4] crypto: api - Add type init function to crypto_tfm
  [5] crypto: api - Export pcomp through comp
  [6] crypto: deflate - switch to pcomp
  [7] crypto: testmgr - swith deflate test to pcomp
  [8] squashfs: Make SquashFS 4 use the new pcomp crypto interface

All patches are relative to cryptodev-2.6.git, except for the last one, which
is relative to squashfs-2.6.git.

The first patch is independent and can be applied immediately, but I included
it in this series to avoid rejects.

The backwards-compatibility layer has been tested with IPComp and UBIFS.

Changes since last version (2008-11-24):
  - Add a new "pcomp" crypto interface, instead of modifying the existing
    "comp" interface, with a compatibility layer,
  - Modify the existing "deflate" module, instead of adding a new "zlib"
    module,
  - Add support for the configuration of (de)compression parameters,
  - Separate allocation for compression and decompression, to avoid memory
    wastage.

Thanks for your comments!

 crypto/Makefile              |    2 
 crypto/api.c                 |   35 +++-
 crypto/deflate.c             |  342 +++++++++++++++++++++++++++++++------------
 crypto/internal.h            |    8 +
 crypto/pcompress.c           |  187 +++++++++++++++++++++++
 crypto/proc.c                |    3 
 crypto/testmgr.c             |  170 +++++++++++++++++++++
 crypto/testmgr.h             |   34 +++-
 fs/Kconfig                   |    3 
 fs/squashfs/block.c          |   67 +++++---
 fs/squashfs/squashfs_fs_sb.h |    2 
 fs/squashfs/super.c          |   32 +++-
 include/linux/crypto.h       |  169 ++++++++++++++++++++-
 13 files changed, 917 insertions(+), 137 deletions(-)

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010

