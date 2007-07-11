Return-Path: <linux-kernel-owner+w=401wt.eu-S1762383AbXGKJml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762383AbXGKJml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758539AbXGKJmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:42:32 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:37524 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758142AbXGKJmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:42:31 -0400
Date: Wed, 11 Jul 2007 10:42:29 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
Message-ID: <20070711094229.GC7568@skynet.ie>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <Pine.LNX.4.64.0707101303450.22199@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707101303450.22199@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/07/07 13:09), Christoph Lameter didst pronounce:
> On Tue, 10 Jul 2007, Andrew Morton wrote:
> 
> > slub-exploit-page-mobility-to-increase-allocation-order.patch
> > slub-reduce-antifrag-max-order.patch
> > 
> >  These are slub changes which are dependent on Mel's stuff, and I have a note
> >  here that there were reports of page allocation failures with these.  What's
> >  up with that?
> 
> Those were fixed and all has been well since as far as I know.
> 

SLUB using high orders without page allocation failures do depend on
two very questionable patches that I brought to attention in my inital
merge mail. If grouping pages by mobility goes through, I'll be revisiting
that properly to make sure it can work without deadlocking ever under any
circumstances. Right now, it theoritically could livelock although I've
never been able to reproduce it.

The patches as they are will work for high-order allocations if you are
willing to wait and reclaim memory. The more stressful users need more
effort but it's already been shown that it can be made work with one
approach as the last few months in -mm have shown.

> >  Maybe I should just drop the 100-odd marginal-looking MM patches?  We're
> >  simply not showing compelling reasons for merging them and quite a lot of them
> >  are stuck in a 90% complete state.
> 
> As far as I can tell the antifrag patches are stable and are significantly 
> enhancing various aspects of the VM and also make it more reliable. SLUB 
> can use it to increase scalability. MM has been using order 3 allocs via 
> SLUB for months now without a problem. Without the antifrag patches order 
> 1 allocs could cause OOMs.
> 
> It opens the door for functionality that we wanted for a long time such a 
> memory unplug etc.

And I want to avoid a catch-22 here where the features that depend on
grouping pages by mobility have to exist before grouping pages by
mobility is pushed through.

I would like the patches to go through on the grounds that higher order
allocations can succeed. However, I am also happy to say that order-0
pages should be used as much as possible, that case should always be
made as fast as possible and the world must not end if a high-order
allocation fails.

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
