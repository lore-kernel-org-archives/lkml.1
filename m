Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbZAMCjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbZAMCjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 21:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbZAMCjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 21:39:45 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:50852 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753829AbZAMCjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 21:39:44 -0500
Date: Tue, 13 Jan 2009 13:39:38 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [RFC PATCH crypto 4/4] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Message-ID: <20090113023937.GA14460@gondor.apana.org.au>
References: <1231120947.5937.31.camel@yhuang-dev.sh.intel.com> <20090109070144.GA7358@gondor.apana.org.au> <1231743310.5937.107.camel@yhuang-dev.sh.intel.com> <20090112104335.GA4942@gondor.apana.org.au> <1231814053.5937.120.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231814053.5937.120.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 10:34:13AM +0800, Huang Ying wrote:
> 
> static void ablk_complete(struct crypto_async_request *req, int err)
> {
>         struct ablkcipher_request *ablk_req = ablkcipher_request_cast(req);
>         struct async_aes_req_ctx *req_ctx =
>                 ablk_aes_req_ctx(ablk_req, crypto_ablkcipher_reqtfm(ablk_req));

This is not guaranteed to work.  Your completion caller may be
called with a request pointer other than the one that you passed
to it.  The only thing we guarantee is that req->data has the
value that you set at the beginning.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
