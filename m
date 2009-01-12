Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZALKny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZALKny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZALKnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:43:42 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:50980 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752143AbZALKnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:43:41 -0500
Date: Mon, 12 Jan 2009 21:43:35 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [RFC PATCH crypto 4/4] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Message-ID: <20090112104335.GA4942@gondor.apana.org.au>
References: <1231120947.5937.31.camel@yhuang-dev.sh.intel.com> <20090109070144.GA7358@gondor.apana.org.au> <1231743310.5937.107.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231743310.5937.107.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 02:55:10PM +0800, Huang Ying wrote:
>
> I use a "shell" cbc(aes) algorithm which chooses between
> cryptd(__cbc-aes-aesni) and __cbc-aes-aesni according to context. But
> the struct ablkcipher_request passed in can not be used for cryptd(*).
> This can be resolved by allocating another struct ablkcipher_request for
> cryptd(*) for each incoming struct ablkcipher_request. But is there any
> better solution?

You should include that other ablkcipher_request as part of the
context of your ablkcipher_request.

See for example how aead embeds it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
