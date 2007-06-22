Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbXFVHBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbXFVHBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 03:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbXFVHB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 03:01:26 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4666 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbXFVHBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 03:01:25 -0400
Date: Fri, 22 Jun 2007 08:00:41 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
Message-ID: <20070622070041.GA18997@flint.arm.linux.org.uk>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com> <Pine.LNX.4.64.0706211759550.11554@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0706220513140.8870@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706220513140.8870@blonde.wat.veritas.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 05:26:33AM +0100, Hugh Dickins wrote:
> On Thu, 21 Jun 2007, Christoph Lameter wrote:
> > On Thu, 21 Jun 2007, Hugh Dickins wrote:
> > 
> > > > The oops seems to occur after a page unmapping using dma_unmap_page() followed
> > > > by a flush_dcache_page() (in at91mci_post_dma_read()).
> > 
> > Was the page allocated using slab calls?
> 
> You've found yes (in the ARM case).
> 
> > Well one may be better off allocating pages using the page allocator 
> > instead of the slab allocator. I removed these things from i386 but I did 
> > not check ARM.
> 
> They may or may not be: I think that's a matter to discuss with rmk.

The coherent case on ARM is broken in more ways, not only because
it uses kmalloc, but it also takes no notice of the DMA mask.

However, AT91 isn't a coherent ARM architecture, so arch_is_coherent()
should be false.  Therefore, we should never be allocating pages for
DMA from SLAB/SLUB for AT91 platforms.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
