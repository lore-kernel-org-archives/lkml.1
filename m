Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbZCUK4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbZCUK4q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 06:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZCUK4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 06:56:35 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:45336 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbZCUK4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 06:56:34 -0400
Date: Sat, 21 Mar 2009 11:56:29 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Jan Glauber <jang@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: linux-next: Tree for March 20 - crypto crash on s390
Message-ID: <20090321115629.6e911679@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090321062605.GA14046@gondor.apana.org.au>
References: <20090320162800.24b0ad93.sfr@canb.auug.org.au>
	<20090320135912.53147d76@osiris.boeblingen.de.ibm.com>
	<20090321062605.GA14046@gondor.apana.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Mar 2009 14:26:05 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Fri, Mar 20, 2009 at 01:59:12PM +0100, Heiko Carstens wrote:
> >
> > gets called with an shash_desc where
> > 
> > bsize = crypto_shash_blocksize(desc->tfm);
> > 
> > results in bsize with zero.
> 
> Oops, this patch should fix it.
> 
> commit b24c94a0d65282dc466339390472d7539e1706c2
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Sat Mar 21 14:25:19 2009 +0800
> 
>     crypto: sha512-s390 - Add missing block size
>     
>     I missed the block size when converting sha512-s390 to shash.
>     
>     Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/arch/s390/crypto/sha512_s390.c b/arch/s390/crypto/sha512_s390.c
> index 420acf4..37b4236 100644
> --- a/arch/s390/crypto/sha512_s390.c
> +++ b/arch/s390/crypto/sha512_s390.c
> @@ -84,6 +84,7 @@ static struct shash_alg sha384_alg = {
>  		.cra_driver_name=	"sha384-s390",
>  		.cra_priority	=	CRYPT_S390_PRIORITY,
>  		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
> +		.cra_blocksize	=	SHA512_BLOCK_SIZE,

Yes, it does fix it. Thanks!

Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
