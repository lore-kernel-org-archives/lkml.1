Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbZFAJdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbZFAJdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZFAJc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:32:56 -0400
Received: from sh.osrg.net ([192.16.179.4]:49251 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621AbZFAJcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:32:55 -0400
Date: Mon, 1 Jun 2009 18:32:44 +0900
To: rmk+lkml@arm.linux.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, arnd@arndb.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090601092259.GB5550@flint.arm.linux.org.uk>
References: <20090601082943.GA5550@flint.arm.linux.org.uk>
	<20090601181723U.fujita.tomonori@lab.ntt.co.jp>
	<20090601092259.GB5550@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090601183323V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 01 Jun 2009 18:32:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009 10:22:59 +0100
Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> On Mon, Jun 01, 2009 at 06:16:56PM +0900, FUJITA Tomonori wrote:
> > On Mon, 1 Jun 2009 09:29:43 +0100
> > Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> > 
> > > On Mon, Jun 01, 2009 at 05:08:09PM +0900, FUJITA Tomonori wrote:
> > > > This adds a version of the dma-mapping API to asm-generic that can be
> > > > used by most architectures that only need a linear mapping.
> > > 
> > > It depends what is meant by "linear mapping".
> > > 
> > > If that's just a way of saying "all that needs to be done for the
> > > DMA streaming APIs is to flush the cache" then the vast majority of
> > > ARMs fall into that category.
> > 
> > I guess that his definition is 'no dynamic remapping'.
> 
> ... which as I say is what ARM does for the streaming mappings.

Ok, then we agree.


> > > The DMA bounce code is a broken design concept that really needs to
> > > be put to death.
> > 
> > You are talking about arch/arm/common/dmabounce.c? If so, it sounds
> > more interesting (to me at least). It's kinda swiotlb per device,
> > right? What you want to do for arch/arm/common/dmabounce.c?
> 
> Yes.
> 
> It's a nasty hack which leads to OOMs on various platforms since it
> causes additional memory pressure from parts of the kernel which we
> don't expect, and also causes additional difficulty with allocating
> and freeing DMA memory from IRQ context.  There's an unsolved bug in
> the kernel bugzilla for this which I see no hope of ever being resolved.
> 
> I _really_ wish that dmabounce never existed.  It's a right royal
> pain in the preverbial.

Can ARM replace the dmabounce with swiotlb?
