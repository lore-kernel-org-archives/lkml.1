Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbYK0Ko5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbYK0Ko5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYK0KdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:33:18 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:62921 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbYK0Kc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:32:28 -0500
Message-Id: <20081127103139.240275996@de.ibm.com>
References: <20081127103020.528516828@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Nov 2008 11:31:01 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 41/60] convert cpacf printks to pr_xxx macros.
Content-Disposition: inline; filename=156-kmsg-cpacf.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Glauber <jang@linux.vnet.ibm.com>

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/crypto/aes_s390.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

Index: quilt-2.6/arch/s390/crypto/aes_s390.c
===================================================================
--- quilt-2.6.orig/arch/s390/crypto/aes_s390.c
+++ quilt-2.6/arch/s390/crypto/aes_s390.c
@@ -17,6 +17,9 @@
  *
  */
 
+#define KMSG_COMPONENT "aes_s390"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <linux/err.h>
@@ -169,7 +172,8 @@ static int fallback_init_cip(struct cryp
 			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
 
 	if (IS_ERR(sctx->fallback.cip)) {
-		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
+		pr_err("Allocating AES fallback algorithm %s failed\n",
+		       name);
 		return PTR_ERR(sctx->fallback.blk);
 	}
 
@@ -349,7 +353,8 @@ static int fallback_init_blk(struct cryp
 			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
 
 	if (IS_ERR(sctx->fallback.blk)) {
-		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
+		pr_err("Allocating AES fallback algorithm %s failed\n",
+		       name);
 		return PTR_ERR(sctx->fallback.blk);
 	}
 
@@ -515,9 +520,8 @@ static int __init aes_s390_init(void)
 
 	/* z9 109 and z9 BC/EC only support 128 bit key length */
 	if (keylen_flag == AES_KEYLEN_128)
-		printk(KERN_INFO
-		       "aes_s390: hardware acceleration only available for "
-		       "128 bit keys\n");
+		pr_info("AES hardware acceleration is only available for"
+			" 128-bit keys\n");
 
 	ret = crypto_register_alg(&aes_alg);
 	if (ret)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

