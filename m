Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbZAIFud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbZAIFud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 00:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbZAIFuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 00:50:24 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:36915 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751765AbZAIFuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 00:50:23 -0500
Date: Fri, 9 Jan 2009 16:50:16 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH crypto 1/4] AES-NI: Move key_length in struct
	crypto_aes_ctx to be the last field
Message-ID: <20090109055016.GA13304@gondor.apana.org.au>
References: <1231120927.5937.26.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231120927.5937.26.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 10:02:07AM +0800, Huang Ying wrote:
> The Intel AES-NI AES acceleration instructions need key_enc, key_dec
> in struct crypto_aes_ctx to be 16 byte aligned, it make this easier to
> move key_length to be the last one.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Patch applied.
  
>  struct crypto_aes_ctx {
> -	u32 key_length;
>  	u32 key_enc[AES_MAX_KEYLENGTH_U32];
>  	u32 key_dec[AES_MAX_KEYLENGTH_U32];
> +	u32 key_length;
>  };

I added a comment here so people don't break this down the track.

+/*
+ * Please ensure that the first two fields are 16-byte aligned
+ * relative to the start of the structure, i.e., don't move them!
+ */

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
