Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbZFOJFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbZFOJFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758465AbZFOJFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:05:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:51940 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759522AbZFOJFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:05:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,221,1243839600"; 
   d="scan'208";a="421862389"
Subject: [BUGFIX 3/3] crypto: Remove CRYPTO_TFM_REQ_MAY_SLEEP from fpu
 template
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain
Date: Mon, 15 Jun 2009 17:05:04 +0800
Message-Id: <1245056704.5320.351.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel_fpu_begin/end used preempt_disable/enable, so sleep should be
prevented between kernel_fpu_begin/end.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/crypto/fpu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/crypto/fpu.c
+++ b/arch/x86/crypto/fpu.c
@@ -48,7 +48,7 @@ static int crypto_fpu_encrypt(struct blk
 	struct blkcipher_desc desc = {
 		.tfm = child,
 		.info = desc_in->info,
-		.flags = desc_in->flags,
+		.flags = desc_in->flags & ~CRYPTO_TFM_REQ_MAY_SLEEP,
 	};
 
 	kernel_fpu_begin();
@@ -67,7 +67,7 @@ static int crypto_fpu_decrypt(struct blk
 	struct blkcipher_desc desc = {
 		.tfm = child,
 		.info = desc_in->info,
-		.flags = desc_in->flags,
+		.flags = desc_in->flags & ~CRYPTO_TFM_REQ_MAY_SLEEP,
 	};
 
 	kernel_fpu_begin();


