Return-Path: <linux-kernel-owner+w=401wt.eu-S935085AbZLGNkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935085AbZLGNkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:40:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935042AbZLGNkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:40:14 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46357 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934845AbZLGNkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:40:13 -0500
Date: Mon, 7 Dec 2009 14:40:13 +0100
From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Sergey Mironov <ierton@gmail.com>
Subject: Re: [PATCH] geode: PTR_ERR return of wrong pointer in
 fallback_init_cip()
Message-ID: <20091207134012.GA21388@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
References: <4B1D02F7.2020505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4B1D02F7.2020505@gmail.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roel Kluin | 2009-12-07 14:28:23 [+0100]:

>Return the PTR_ERR of the correct pointer.
>
>Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>---
> drivers/crypto/geode-aes.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
>index 4801162..12cf864 100644
>--- a/drivers/crypto/geode-aes.c
>+++ b/drivers/crypto/geode-aes.c
>@@ -263,7 +263,7 @@ static int fallback_init_cip(struct crypto_tfm *tfm)
> 
> 	if (IS_ERR(op->fallback.cip)) {
> 		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
>-		return PTR_ERR(op->fallback.blk);
>+		return PTR_ERR(op->fallback.cip);
> 	}

This is correct however you missed one spot a few lines above that one.
Sergey Mironov sent a patch a while ago unfortunatelly a mangled one and
he hasn't resent it yet.
Could you please look at [0] for the missing spot? If you had fun fixing
that one, I've a made a similar mistake in s390's driver [1]. If not
please say so.

> 
> 	return 0;

[0] http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg03883.html
[1] http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg03888.html

Sebastian
