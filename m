Return-Path: <linux-kernel-owner+w=401wt.eu-S1422850AbXCBEWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422850AbXCBEWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 23:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422851AbXCBEWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 23:22:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422850AbXCBEWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 23:22:05 -0500
Date: Fri, 2 Mar 2007 05:21:49 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@engr.sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       mingo@elte.hu, jschopp@austin.ibm.com, arjan@infradead.org,
       torvalds@linux-foundation.org, mbligh@mbligh.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related patches
Message-ID: <20070302042149.GB15867@wotan.suse.de>
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org> <Pine.LNX.4.64.0703011854540.5530@schroedinger.engr.sgi.com> <20070302035751.GA15867@wotan.suse.de> <Pine.LNX.4.64.0703012001260.5548@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703012001260.5548@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 08:06:25PM -0800, Christoph Lameter wrote:
> On Fri, 2 Mar 2007, Nick Piggin wrote:
> 
> > > I would say that anti-frag / defrag enables memory unplug.
> > 
> > Well that really depends. If you want to have any sort of guaranteed
> > amount of unplugging or shrinking (or hugepage allocating), then antifrag
> > doesn't work because it is a heuristic.
> 
> We would need additional measures such as real defrag and make more 
> structure movable.
> 
> > One thing that worries me about anti-fragmentation is that people might
> > actually start _using_ higher order pages in the kernel. Then fragmentation
> > comes back, and it's worse because now it is not just the fringe hugepage or
> > unplug users (who can anyway work around the fragmentation by allocating
> > from reserve zones).
> 
> Yes, we (SGI) need exactly that: Use of higher order pages in the kernel 
> in order to reduce overhead of managing page structs for large I/O and 
> large memory applications. We need appropriate measures to deal with the 
> fragmentation problem.

I don't understand why, out of any architecture, ia64 would have to hack
around this in software :(

> > > Thats a value judgement that I doubt. Zone based balancing is bad and has 
> > > been repeatedly patched up so that it works with the usual loads.
> > 
> > Shouldn't we fix it instead of deciding it is broken and add another layer
> > on top that supposedly does better balancing?
> 
> We need to reduce the real hardware zones as much as possible. Most high 
> performance architectures have no need for additional DMA zones f.e. and
> do not have to deal with the complexities that arise there.

And then you want to add something else on top of them?

> > But just because zones are hardware _now_ doesn't mean they have to stay
> > that way. The upshot is that a lot of work for zones is already there.
> 
> Well you cannot get there without the nodes. The control of memory 
> allocations with user space support etc only comes with the nodes.
> 
> > > A. moveable/unmovable
> > > B. DMA restrictions
> > > C. container assignment.
> > 
> > There are alternatives to adding a new layer of virtual zones. We could try
> > using zones, enven.
> 
> No merge them to one thing and handle them as one. No difference between 
> zones and nodes anymore.
>  
> > zones aren't perfect right now, but they are quite similar to what you
> > want (ie. blocks of memory). I think we should first try to generalise what
> > we have rather than adding another layer.
> 
> Yes that would mean merging nodes and zones. So "nones".

Yes, this is what Andrew just said. But you then wanted to add virtual zones
or something on top. I just don't understand why. You agree that merging
nodes and zones is a good idea. Did I miss the important post where some
bright person discovered why merging zones and "virtual zones" is a bad
idea?

