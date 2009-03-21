Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbZCUG00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbZCUG00 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 02:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbZCUG0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 02:26:16 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:36654 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753355AbZCUG0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 02:26:15 -0400
Date: Sat, 21 Mar 2009 14:26:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Jan Glauber <jang@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: linux-next: Tree for March 20 - crypto crash on s390
Message-ID: <20090321062605.GA14046@gondor.apana.org.au>
References: <20090320162800.24b0ad93.sfr@canb.auug.org.au> <20090320135912.53147d76@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320135912.53147d76@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 01:59:12PM +0100, Heiko Carstens wrote:
>
> gets called with an shash_desc where
> 
> bsize = crypto_shash_blocksize(desc->tfm);
> 
> results in bsize with zero.

Oops, this patch should fix it.

commit b24c94a0d65282dc466339390472d7539e1706c2
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sat Mar 21 14:25:19 2009 +0800

    crypto: sha512-s390 - Add missing block size
    
    I missed the block size when converting sha512-s390 to shash.
    
    Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/s390/crypto/sha512_s390.c b/arch/s390/crypto/sha512_s390.c
index 420acf4..37b4236 100644
--- a/arch/s390/crypto/sha512_s390.c
+++ b/arch/s390/crypto/sha512_s390.c
@@ -84,6 +84,7 @@ static struct shash_alg sha384_alg = {
 		.cra_driver_name=	"sha384-s390",
 		.cra_priority	=	CRYPT_S390_PRIORITY,
 		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA512_BLOCK_SIZE,
 		.cra_ctxsize	=	sizeof(struct s390_sha_ctx),
 		.cra_module	=	THIS_MODULE,
 	}

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
