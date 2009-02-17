Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbZBQToy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbZBQToy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbZBQTn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:43:57 -0500
Received: from cmpxchg.org ([85.214.51.133]:38478 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626AbZBQTn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:43:57 -0500
Message-Id: <20090217184135.837159784@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Tue, 17 Feb 2009 19:26:17 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 2/7] crypto: use kzfree()
References: <20090217182615.897042724@cmpxchg.org>
Content-Disposition: inline; filename=crypto-use-kzfree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzfree() instead of memset() + kfree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
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
 


