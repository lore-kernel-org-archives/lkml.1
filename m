Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111AbXFVUTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbXFVUTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 16:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbXFVUSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 16:18:49 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2311 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbXFVUSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 16:18:47 -0400
Date: Fri, 22 Jun 2007 21:18:17 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, Christoph Lameter <clameter@sgi.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
Message-ID: <20070622201817.GA21793@flint.arm.linux.org.uk>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com> <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com> <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 09:40:45AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 22 Jun 2007, Hugh Dickins wrote:
> >
> > On Thu, 21 Jun 2007, Christoph Lameter wrote:
> > 
> > > Maybe this will address the issue on ARM?
> > 
> > Looks like it would indeed address the immediate issue on ARM -
> > IF they've no particular reason to be using kmalloc there.
> 
> I think the right thing to do is do both of these things. I already 
> applied Hugh's patch - it seemed like a total nobrainer to do at this 
> stage in the 2.6.22 -rc series. But that doesn't mean that we should not 
> _also_ look at "flush_dcache_page()" users.

Note, however, that the use of flush_dcache_page() on allocations
derived from dma_alloc_coherent() is undefined and unpredictable.

dma_alloc_coherent() may return a remapped virtual address which
would be invalid for things like virt_to_page() to operate on.

So the fact that dma_alloc_coherent() returning something that was
kmalloc'd and then causing flush_dcache_page() to oops is actually
a sign that there's far deeper problems.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
