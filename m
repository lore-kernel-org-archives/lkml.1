Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYHDOSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYHDOSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbYHDOSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:18:31 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:60710 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754816AbYHDOS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:18:29 -0400
Date: Mon, 4 Aug 2008 22:18:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Austin Zhang <austin_zhang@linux.intel.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API.
Message-ID: <20080804141822.GB11415@gondor.apana.org.au>
References: <1217842507.20845.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217842507.20845.18.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 05:35:07AM -0400, Austin Zhang wrote:
>
> +static int crc32c_intel_cra_init(struct crypto_tfm *tfm)
> +{
> +	u32 *key = crypto_tfm_ctx(tfm);
> +
> +	*key = ~0;
> +
> +	tfm->crt_ahash.reqsize = sizeof(u32);
> +
> +	if (cpu_has_xmm4_2)
> +		return 0;
> +	else
> +		return -1;
> +}

This check needs to be moved to the module init function and
if it fails the module should not register the algorithm.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
