Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbYD2OHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbYD2OHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbYD2OHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:07:44 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:40725 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750837AbYD2OHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:07:43 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: julia@diku.dk (Julia Lawall)
Subject: Re: [PATCH] crypto: Correct kzalloc error test
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Organization: Core
In-Reply-To: <Pine.LNX.4.58.0804291536220.1185@pc-041.diku.dk>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1JqqUc-0005Rg-00@gondolin.me.apana.org.au>
Date: Tue, 29 Apr 2008 22:07:38 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Normally, kzalloc returns NULL or a valid pointer value, not a value to be
> tested using IS_ERR.

Ouch :)

> diff -u -p  a/crypto/cryptd.c b/crypto/cryptd.c
> --- a/crypto/cryptd.c   2008-04-16 13:27:56.000000000 +0200
> +++ b/crypto/cryptd.c   2008-04-29 15:29:54.000000000 +0200
> @@ -190,7 +190,7 @@ static struct crypto_instance *cryptd_al
>        int err;
> 
>        inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
> -       if (IS_ERR(inst))
> +       if (!inst)
>                goto out;

However, this function is expected to return an ERR_PTR so you'll
need set it to ENOMEM first.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
