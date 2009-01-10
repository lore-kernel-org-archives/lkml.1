Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbZAJKIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbZAJKIl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 05:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbZAJKIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 05:08:32 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:49857 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752837AbZAJKIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 05:08:31 -0500
Date: Sat, 10 Jan 2009 21:08:23 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [RFC PATCH crypto 4/4] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Message-ID: <20090110100823.GA22352@gondor.apana.org.au>
References: <1231120947.5937.31.camel@yhuang-dev.sh.intel.com> <20090109070144.GA7358@gondor.apana.org.au> <1231491273.5937.94.camel@yhuang-dev.sh.intel.com> <20090109091814.GA10881@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109091814.GA10881@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 08:18:14PM +1100, Herbert Xu wrote:
>
> Not at all, tfms are just "shell" objects and they were designed
> to be used in thie way.  Calling setkey twice is an issue but it's
> not a show-stopper.  We have the same problem in other places to
> so this something that we can potentially optimise.

Here's how we can solve the double setkey problem.  We can make
a new cryptd_alloc_ablkcipher interface that returns a cryptd
ablkcipher object.  Since it's cryptd specific we can then access
its underlying blkcipher object, which can be shared between the
cryptd object and the user of the cryptd object.  This way you
only need to do setkey on the cryptd object and it'll get set
on the underlying blkcipher automatically.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
