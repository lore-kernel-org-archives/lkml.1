Return-Path: <linux-kernel-owner+w=401wt.eu-S1761210AbZAOJXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761210AbZAOJXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbZAOJXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:23:21 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:57284 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751966AbZAOJXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:23:19 -0500
Date: Thu, 15 Jan 2009 20:23:14 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH crypto -v4 1/2] AES-NI: Add support to access underlying
	blkcipher under cryptd ablkcipher
Message-ID: <20090115092314.GA32559@gondor.apana.org.au>
References: <1232008113.5937.199.camel@yhuang-dev.sh.intel.com> <20090115084750.GA32239@gondor.apana.org.au> <1232011307.5937.204.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232011307.5937.204.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 05:21:47PM +0800, Huang Ying wrote:
> On Thu, 2009-01-15 at 16:47 +0800, Herbert Xu wrote:
> > On Thu, Jan 15, 2009 at 04:28:33PM +0800, Huang Ying wrote:
> > >
> > > +	tfm = crypto_alloc_ablkcipher(cryptd_alg_name, type, mask);
> > > +	BUG_ON(crypto_ablkcipher_tfm(tfm)->__crt_alg->cra_module !=
> > > +	       THIS_MODULE);
> > 
> > You need to check whether tfm is an error before dereferencing it.
> > Also it's probably better to free the tfm and return an error rather
> > than invoking BUG.
> 
> Why do we need this check? Someone else may register cryptd template?
> Which error number should be return? -EINVAL?

-ENOMEM for example.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
