Return-Path: <linux-kernel-owner+w=401wt.eu-S1759839AbXFVQnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839AbXFVQnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 12:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbXFVQnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 12:43:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54416 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758541AbXFVQnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 12:43:13 -0400
Date: Fri, 22 Jun 2007 09:40:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
cc: Christoph Lameter <clameter@sgi.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
Message-ID: <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 22 Jun 2007, Hugh Dickins wrote:
>
> On Thu, 21 Jun 2007, Christoph Lameter wrote:
> 
> > Maybe this will address the issue on ARM?
> 
> Looks like it would indeed address the immediate issue on ARM -
> IF they've no particular reason to be using kmalloc there.

I think the right thing to do is do both of these things. I already 
applied Hugh's patch - it seemed like a total nobrainer to do at this 
stage in the 2.6.22 -rc series. But that doesn't mean that we should not 
_also_ look at "flush_dcache_page()" users.

I do think that even just the name (the ".._page()" part) makes it obvious 
that it was designed for page-level allocations, not kmalloc(). So I think 
Christoph's patch makes sense in that context.

At the same time, I do think that the whole notion of flushing the D$ is 
certainly something that makes sense for kmalloc() allocations also, and 
maybe people do actually do small DMA allocations and Christophs patch 
would break that.

End result: for 2.6.22, I think the patch from Hugh that I already applied 
is the right thing. 

But as to 2.6.23 and onward.. I dunno.

		Linus
