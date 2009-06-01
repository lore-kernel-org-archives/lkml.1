Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbZFAIId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbZFAIId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 04:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbZFAIIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 04:08:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:54845 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbZFAIIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:08:25 -0400
Date: Mon, 1 Jun 2009 17:08:09 +0900
To: rmk+lkml@arm.linux.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, arnd@arndb.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090601075114.GA29107@flint.arm.linux.org.uk>
References: <200905282104.55818.arnd@arndb.de>
	<20090601130319A.fujita.tomonori@lab.ntt.co.jp>
	<20090601075114.GA29107@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090601170847V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 01 Jun 2009 17:08:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009 08:51:14 +0100
Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> On Mon, Jun 01, 2009 at 01:02:42PM +0900, FUJITA Tomonori wrote:
> > Where can I find dma_coherent_dev?
> > 
> > I don't fancy this since this is architecture-specific stuff (not
> > generic things).
> 
> It _is_ very architecture specific.  The coherent-ness of devices hardly
> depends on the device itself.  Eg, PCI devices on x86 are coherent, but
> on ARM they aren't.
> 
> > > +static inline void
> > > +dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
> > > +		 enum dma_data_direction direction)
> > > +{
> > > +	debug_dma_unmap_page(dev, dma_addr, size, direction, true);
> 
> Future ARMs will need to do something on unmaps.
> 
> > > +static inline void
> > > +dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
> > > +			enum dma_data_direction direction)
> > > +{
> > > +	debug_dma_sync_single_for_cpu(dev, dma_handle, size, direction);
> > > +}
> > > +
> > > +static inline void
> > > +dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
> > > +			      unsigned long offset, size_t size,
> > > +			      enum dma_data_direction direction)
> > > +{
> > > +	debug_dma_sync_single_range_for_cpu(dev, dma_handle,
> > > +					    offset, size, direction);
> > > +}
> > 
> > This looks wrong. You put dma_coherent_dev hook in sync_*_for_device
> > but why you don't need it sync_*_for_cpu. It's architecture
> > specific. Some need both, some need either, and some need nothing.
> 
> If you're non-coherent, you need to implement the sync APIs.
> 
> > > +static inline int
> > > +dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
> > > +{
> > > +	return 0;
> 
> So mappings never fail?

Hmm, possibly, you might misunderstand what he is trying to do.

http://lkml.org/lkml/2009/5/28/393:

This adds a version of the dma-mapping API to asm-generic that can be
used by most architectures that only need a linear mapping.

=
The original thread is here (I'm not sure if we can have something
clean and useful like this header file):

http://lkml.org/lkml/2009/5/19/262


I think that ARM can't be an user of this (ARM needs more complicated
dma mapping stuff).
