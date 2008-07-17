Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbYGQLEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbYGQLEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 07:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYGQLEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 07:04:16 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4719 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbYGQLEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 07:04:15 -0400
Date: Thu, 17 Jul 2008 07:04:05 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [PATCH] prng; bring prng into better alignment with specification
Message-ID: <20080717110405.GC17892@hmsendeavour.rdu.redhat.com>
References: <20080716203200.GB1648@hmsreliant.think-freely.org> <20080717074856.GB23621@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717074856.GB23621@gondor.apana.org.au>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 03:48:56PM +0800, Herbert Xu wrote:
> On Wed, Jul 16, 2008 at 04:32:00PM -0400, Neil Horman wrote:
> >  Bring prng into better alignment with specificaion:
> >     
> >  - Convert to using Generic AES 128 bit cipher
> >  - Convert DT to be a non-shifted counter, increasing counter period
> >     
> >  Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> Applied to cryptodev-2.6.
> >
> > @@ -325,17 +306,13 @@ int reset_prng_context(struct prng_context *ctx,
> >  		       unsigned char *V, unsigned char *DT)
> >  	int ret;
> > -	int iv_len;
> >  	int rc = -EFAULT;
> >  	unsigned char *prng_key;
> > -	unsigned char *prng_iv;
> >  	spin_lock(&ctx->prng_lock);
> >  	ctx->flags |= PRNG_NEED_RESET;
> >  
> >  	prng_key = (key != NULL) ? key : (unsigned char *)DEFAULT_PRNG_KEY;
> >  
> > -	prng_iv = iv ? iv : (unsigned char *)DEFAULT_PRNG_IV;
> 
> We can now kill the iv parameter too.
> 
Yeah, I was trying to decide if I should remove that or not, in the event we
wanted to support alternate [blk]ciphers in the future for the cprng.  As I
think about it, I don't think its a big deal to nix.  I'll get rid of it
shortly.

Thanks
Neil

> Thanks,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

-- 
/***************************************************
 *Neil Horman
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
