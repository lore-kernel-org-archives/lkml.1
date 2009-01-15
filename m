Return-Path: <linux-kernel-owner+w=401wt.eu-S1762932AbZAOIsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762932AbZAOIsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 03:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbZAOIr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 03:47:56 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:38407 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752205AbZAOIr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 03:47:56 -0500
Date: Thu, 15 Jan 2009 19:47:50 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH crypto -v4 1/2] AES-NI: Add support to access
	underlying blkcipher under cryptd ablkcipher
Message-ID: <20090115084750.GA32239@gondor.apana.org.au>
References: <1232008113.5937.199.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232008113.5937.199.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 04:28:33PM +0800, Huang Ying wrote:
>
> +	tfm = crypto_alloc_ablkcipher(cryptd_alg_name, type, mask);
> +	BUG_ON(crypto_ablkcipher_tfm(tfm)->__crt_alg->cra_module !=
> +	       THIS_MODULE);

You need to check whether tfm is an error before dereferencing it.
Also it's probably better to free the tfm and return an error rather
than invoking BUG.

> --- a/include/crypto/algapi.h
> +++ b/include/crypto/algapi.h

Please create a new file for this, e.g., include/crypto/cryptd.h.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
