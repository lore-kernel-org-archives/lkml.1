Return-Path: <linux-kernel-owner+w=401wt.eu-S1764696AbYD2Nie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764696AbYD2Nie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762859AbYD2NiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:38:23 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:46475 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757488AbYD2NiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:38:22 -0400
Date: Tue, 29 Apr 2008 15:38:15 +0200 (MEST)
From: Julia Lawall <julia@diku.dk>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: Correct kzalloc error test
Message-ID: <Pine.LNX.4.58.0804291536220.1185@pc-041.diku.dk>
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
+++ b/crypto/cryptd.c	2008-04-29 15:29:54.000000000 +0200
@@ -190,7 +190,7 @@ static struct crypto_instance *cryptd_al
 	int err;

 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
-	if (IS_ERR(inst))
+	if (!inst)
 		goto out;

 	err = -ENAMETOOLONG;
