Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbZKITCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbZKITCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 14:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZKITCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 14:02:47 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:47200 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750863AbZKITCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 14:02:46 -0500
Date: Mon, 9 Nov 2009 14:02:50 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [BUGFIX -v2 for .32] crypto, gcm, fix another complete call in
	complete fuction
Message-ID: <20091109190250.GC9588@gondor.apana.org.au>
References: <1257751454.22519.2287.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257751454.22519.2287.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 03:24:14PM +0800, Huang Ying wrote:
> The flow of the complete function (xxx_done) in gcm.c is as follow:

Thanks the patch looks pretty good overall.

> -static void gcm_hash_final_done(struct crypto_async_request *areq,
> -				int err)
> +static void __gcm_hash_final_done(struct aead_request *req,
> +				  struct crypto_gcm_req_priv_ctx *pctx,
> +				  int err)

Just one nit though, do we really need to carry this pctx around
everywhere? It seems to me that it's always crypto_gcm_reqctx(req),
no?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
