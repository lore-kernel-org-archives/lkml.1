Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbZBRPxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbZBRPxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 10:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZBRPxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 10:53:25 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:57291 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751720AbZBRPxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:53:24 -0500
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Partial (de)compression Crypto API
Date: Wed, 18 Feb 2009 16:53:17 +0100
Message-Id: <1234972402-24298-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch series adds support for partial (de)compression to the
CRYPTO API, and modifies SquashFS 4 to use this:

  [1] crypto: compress - Add pcomp interface
  [2] crypto: testmgr - Add support for the pcomp interface
  [3] crypto: new zlib crypto module, using pcomp
  [4] crypto: testmgr - add zlib test
  [5] squashfs: Make SquashFS 4 use the new pcomp crypto interface

The patches are based on:
  linux-2.6.git + cryptodev-2.6.git + commit 3f683d61 ("crypto: api - Fix
  crypto_alloc_tfm/create_create_tfm return convention")

Changes since last version (2009-02-13):
  - Convert crypto_pcomp to a new-style crypto module, using crypto_alloc_tfm()
    instead of crypto_alloc_base()
  - Pass crypto_pcomp pointers instead of crypto_tfm pointers where appropriate
  - Use crypto_destroy_tfm() instead of crypto_free_tfm(), to take into account
    the offset info the slab object
  - Remove redundant check for CRYPTO_ALG_TYPE_PCOMPRESS in
    crypto_pcomp_init_tfm()
  - Use separate setup functions for compression and decompression
  - Sanitize naming to crypto_{,de}compress_{setup,init,update,final}()
  - Remove backwards-compatibility layer (export pcomp through comp), as
    requested by Herbert Xu
  - Create a new "zlib" pcomp module instead of modifying the existing
    "deflate" comp module 
  - Readd accidentally removed ".cra_module = THIS_MODULE", which allowed the
    zlib module to be rmmoded while it was in use
  - Fix the pcomp/testmgr dependency

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
