Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbZCPM2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbZCPM2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 08:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760557AbZCPM2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 08:28:14 -0400
Received: from mail.suse.de ([195.135.220.2]:54961 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760477AbZCPM2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 08:28:13 -0400
Date: Mon, 16 Mar 2009 13:28:06 +0100
From: Nick Piggin <npiggin@suse.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 00/35] Cleanup and optimise the page allocator V3
Message-ID: <20090316122806.GE30802@wotan.suse.de>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <20090316114555.GB30802@wotan.suse.de> <20090316121122.GC6382@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316121122.GC6382@csn.ul.ie>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 12:11:22PM +0000, Mel Gorman wrote:
> On Mon, Mar 16, 2009 at 12:45:55PM +0100, Nick Piggin wrote:
> > On Mon, Mar 16, 2009 at 09:45:55AM +0000, Mel Gorman wrote:
> > > Here is V3 of an attempt to cleanup and optimise the page allocator and should
> > > be ready for general testing. The page allocator is now faster (16%
> > > reduced time overall for kernbench on one machine) and it has a smaller cache
> > > footprint (16.5% less L1 cache misses and 19.5% less L2 cache misses for
> > > kernbench on one machine). The text footprint has unfortunately increased,
> > > largely due to the introduction of a form of lazy buddy merging mechanism
> > > that avoids cache misses by postponing buddy merging until a high-order
> > > allocation needs it.
> > 
> > BTW. I would feel better about this if it gets merged in stages, with
> > functional changes split out, and also code optimisations and omore
> > obvious performace improvements split out and preferably merged first.
> > 
> 
> The ordering of the patches was such that least-controversial stuff is
> at the start of the patchset. The intention was to be able to select a
> cut-off point and say "that's enough for now"
> 
> > At a very quick glance, the first 25 or so patches should go in first,
> > and that gives a much better base to compare subsequent functional
> > changes with.
> 
> That's reasonable. I've requeued tests for the patchset up to 25 to see what
> that looks like. There is also a part of a later patch that reduces how much
> time is spent with interrupts disabled. I should split that out and move it
> back to within the cut-off point as something that is "obviously good".

OK cool. It also means we can start getting benefit of some of them
sooner. I hope most of the obvious ones can be merged in 2.6.30.

 
> > Patch 18 for example is really significant, and should
> > almost be 2.6.29/-stable material IMO.
> > 
> 
> My impression was that -stable was only for functional regressions where
> as this is really a performance thing.

A performance regression like this in the core page allocator is a
pretty important problem. The fix is obvious. But maybe you're right.
