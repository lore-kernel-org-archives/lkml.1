Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbXLDI12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbXLDI12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 03:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbXLDI1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 03:27:20 -0500
Received: from brick.kernel.dk ([87.55.233.238]:23225 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbXLDI1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 03:27:19 -0500
Date: Tue, 4 Dec 2007 09:25:11 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jan Glauber <jang@linux.vnet.ibm.com>,
       linux-crypto <linux-crypto@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: HMAC broken on s390
Message-ID: <20071204082511.GC23294@kernel.dk>
References: <1196688700.4799.5.camel@localhost.localdomain> <20071203220900.GA8573@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203220900.GA8573@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04 2007, Herbert Xu wrote:
> On Mon, Dec 03, 2007 at 02:31:40PM +0100, Jan Glauber wrote:
> > Hi Herbert,
> > 
> > commit 788fefa33b0b50581585925c53c230a36af35d0e in cryptodev breaks hmac
> > on s390 du to the usage of sg_chain():
> > 
> > static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
> >                             struct scatterlist *sgl)
> > {
> > #ifndef ARCH_HAS_SG_CHAIN
> >         BUG();
> > #endif
> > 
> > ARCH_HAS_SG_CHAIN is false for s390 (and also for some other arch's).
> > 
> > What should we do with this?
> 
> Looks like we took a step backwards because the chaining I had
> before worked on all architectures :)
> 
> I suppose either we'll have to do our own chaining again or implement
> it for all architectures.  I'll look into this.

You should continue to do your own chaining if it's a requirement for
the driver/layer to function, until we get rid of ARCH_HAS_SG_CHAIN.
That'll happen when all archs are converted.

So don't rely on scatterlist helping you with chaining just yet, sorry.

-- 
Jens Axboe

