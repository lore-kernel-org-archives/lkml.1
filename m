Return-Path: <linux-kernel-owner+w=401wt.eu-S1759402AbZBZXVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbZBZXVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 18:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbZBZXUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 18:20:53 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33988 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbZBZXUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 18:20:52 -0500
Date: Thu, 26 Feb 2009 23:20:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: karl@hiramoto.org, chohnstaedt@innominate.com,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] ixp4xx_crypto panic with fragmented packets in scatterlist
Message-ID: <20090226232025.GE5811@n2100.arm.linux.org.uk>
References: <20090226095552.GB5811@n2100.arm.linux.org.uk> <20090226121043.GA13749@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226121043.GA13749@gondor.apana.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 08:10:43PM +0800, Herbert Xu wrote:
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> >
> > We can't merge this until _all_ of ARM has been fixed for walking
> > scatterlist chains.
> 
> Right, this is definitely not the way to fix this bug.  Because
> even if ARM completely supported chaining, you still have to fix
> all the other architectures as well.

I don't think you can use chained scatterlists unless the architecture
supports it.  It's not a case that you have to flatten the chaining
before passing it over to the arch - it seems you're not allowed to
create a chained scatterlist in the first place:

static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
                            struct scatterlist *sgl)
{
#ifndef ARCH_HAS_SG_CHAIN
        BUG();
#endif
