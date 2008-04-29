Return-Path: <linux-kernel-owner+w=401wt.eu-S932585AbYD2OWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585AbYD2OWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762226AbYD2OSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:18:14 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51559 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758334AbYD2OSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:18:11 -0400
Date: Tue, 29 Apr 2008 16:18:08 +0200 (MEST)
From: Julia Lawall <julia@diku.dk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [revised PATCH] crypto: Correct kzalloc error test
In-Reply-To: <E1JqqUc-0005Rg-00@gondolin.me.apana.org.au>
Message-ID: <Pine.LNX.4.58.0804291617210.1185@pc-041.diku.dk>
References: <E1JqqUc-0005Rg-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Normally, kzalloc returns NULL or a valid pointer value, not a value to be
tested using IS_ERR.

Signed-off-by: Julia Lawall <julia@diku.dk>
---
diff -u -p  a/crypto/cryptd.c b/crypto/cryptd.c
--- a/crypto/cryptd.c	2008-04-16 13:27:56.000000000 +0200
+++ b/crypto/cryptd.c	2008-04-29 16:13:10.000000000 +0200
@@ -190,8 +190,10 @@ static struct crypto_instance *cryptd_al
 	int err;

 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
-	if (IS_ERR(inst))
+	if (!inst) {
+		inst = ERR_PTR(-ENOMEM);
 		goto out;
+	}

 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
