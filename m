Return-Path: <linux-kernel-owner+w=401wt.eu-S1759303AbZKYRGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbZKYRGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759292AbZKYRGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:06:22 -0500
Received: from mga07.intel.com ([143.182.124.22]:55746 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759280AbZKYRGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:06:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,287,1257148800"; 
   d="scan'208";a="215705013"
Date: Wed, 25 Nov 2009 19:42:27 -0500
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: [PATCH]crypto: Fix aesni algorithm implementation without test
Message-ID: <20091126004226.GA32230@youquan-linux.bj.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when load aesni-intel driver,kernel will report no test for some algorithm
with AES-NI. The strange information as following:

alg: No test for __aes-aesni (__driver-aes-aesni)
alg: No test for __ecb-aes-aesni (__driver-ecb-aes-aesni)
alg: No test for __cbc-aes-aesni (__driver-cbc-aes-aesni)
alg: No test for __ecb-aes-aesni (cryptd(__driver-ecb-aes-aesni)

crypto_alg's cra_name is use to descript algorithm itself, do not care the 
concrete implement. So this patch unify them and also can fix the algorithm
implementation without test. 

Signed-off-by: Youquan, Song <youquan.song@intel.com>
---

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 585edeb..455bbf3 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -161,7 +161,7 @@ static void __aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 }
 
 static struct crypto_alg __aesni_alg = {
-	.cra_name		= "__aes-aesni",
+	.cra_name		= "aes",
 	.cra_driver_name	= "__driver-aes-aesni",
 	.cra_priority		= 0,
 	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
@@ -230,7 +230,7 @@ static int ecb_decrypt(struct blkcipher_desc *desc,
 }
 
 static struct crypto_alg blk_ecb_alg = {
-	.cra_name		= "__ecb-aes-aesni",
+	.cra_name		= "ecb(aes)",
 	.cra_driver_name	= "__driver-ecb-aes-aesni",
 	.cra_priority		= 0,
 	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
@@ -300,7 +300,7 @@ static int cbc_decrypt(struct blkcipher_desc *desc,
 }
 
 static struct crypto_alg blk_cbc_alg = {
-	.cra_name		= "__cbc-aes-aesni",
+	.cra_name		= "cbc(aes)",
 	.cra_driver_name	= "__driver-cbc-aes-aesni",
 	.cra_priority		= 0,
 	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
