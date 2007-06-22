Return-Path: <linux-kernel-owner+w=401wt.eu-S1759824AbXFVR1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824AbXFVR1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbXFVR0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:26:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36288 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751065AbXFVR0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:26:54 -0400
Date: Fri, 22 Jun 2007 10:26:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706221021540.16991@schroedinger.engr.sgi.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
 <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Linus Torvalds wrote:

> > Looks like it would indeed address the immediate issue on ARM -
> > IF they've no particular reason to be using kmalloc there.
> 
> I think the right thing to do is do both of these things. I already 
> applied Hugh's patch - it seemed like a total nobrainer to do at this 
> stage in the 2.6.22 -rc series. But that doesn't mean that we should not 
> _also_ look at "flush_dcache_page()" users.

Hugh's patch not address the complete issue. It only works right now 
because the size of the allocation is page size and fits right into a slab 
page. If debugging is enabled then the slab size will increase and the 
"pages" will be misaligned which will lead to other sorts of funky 
behavior. kmalloc allocations are only guaranteed to be aligned to 
ARCH_KMALLOC_MINALIGN which is 4 to 8 bytes. If one must have a 
page aligned entity out of a slab allocator then a custom slab needs to be 
created.
