Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbZBYOUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbZBYOUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 09:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZBYOUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 09:20:09 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:37269 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752960AbZBYOUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:20:08 -0500
Date: Wed, 25 Feb 2009 22:20:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
       Frank Seidel <frank@f-seidel.de>, akpm@linux-foundation.org,
       "David S. Miller" <davem@davemloft.net>, nhorman@tuxdriver.com,
       lho@amcc.com, kaber@trash.net, darrenrjenkins@gmail.com
Subject: Re: [PATCH][trivial] crypto: tcrypt - reduce stack size
Message-ID: <20090225142000.GA4136@gondor.apana.org.au>
References: <49A54C23.8090209@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A54C23.8090209@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 02:48:19PM +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> Applying kernel janitors todos (printk calls need KERN_*
> constants on linebeginnings, reduce stack footprint where
> possible) to tcrypts test_hash_speed (where stacks
> memory footprint was very high (on i386 1184 bytes to
> 292 now).
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  crypto/tcrypt.c |   29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
> 
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -396,26 +396,34 @@ static void test_hash_speed(const char *
>  	struct scatterlist sg[TVMEMSIZE];
>  	struct crypto_hash *tfm;
>  	struct hash_desc desc;
> -	char output[1024];

How about just making it static?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
