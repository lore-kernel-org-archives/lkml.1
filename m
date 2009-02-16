Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbZBPPFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbZBPPFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 10:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZBPPEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 10:04:52 -0500
Received: from cmpxchg.org ([85.214.51.133]:49260 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbZBPPEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:04:51 -0500
Message-Id: <20090216144725.659631692@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Mon, 16 Feb 2009 15:29:28 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 2/8] crypto: use kzfree()
References: <20090216142926.440561506@cmpxchg.org>
Content-Disposition: inline; filename=crypto-use-kzfree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzfree() instead of memset() + kfree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/api.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/crypto/api.c
+++ b/crypto/api.c
@@ -569,20 +569,17 @@ EXPORT_SYMBOL_GPL(crypto_alloc_tfm);
 void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm)
 {
 	struct crypto_alg *alg;
-	int size;
 
 	if (unlikely(!mem))
 		return;
 
 	alg = tfm->__crt_alg;
-	size = ksize(mem);
 
 	if (!tfm->exit && alg->cra_exit)
 		alg->cra_exit(tfm);
 	crypto_exit_ops(tfm);
 	crypto_mod_put(alg);
-	memset(mem, 0, size);
-	kfree(mem);
+	kzfree(mem);
 }
 EXPORT_SYMBOL_GPL(crypto_destroy_tfm);
 


