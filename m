Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbZCPMLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbZCPMLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 08:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZCPMLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 08:11:25 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38325 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbZCPMLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 08:11:24 -0400
Date: Mon, 16 Mar 2009 12:11:22 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <npiggin@suse.de>
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
Message-ID: <20090316121122.GC6382@csn.ul.ie>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <20090316114555.GB30802@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090316114555.GB30802@wotan.suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 12:45:55PM +0100, Nick Piggin wrote:
> On Mon, Mar 16, 2009 at 09:45:55AM +0000, Mel Gorman wrote:
> > Here is V3 of an attempt to cleanup and optimise the page allocator and should
> > be ready for general testing. The page allocator is now faster (16%
> > reduced time overall for kernbench on one machine) and it has a smaller cache
> > footprint (16.5% less L1 cache misses and 19.5% less L2 cache misses for
> > kernbench on one machine). The text footprint has unfortunately increased,
> > largely due to the introduction of a form of lazy buddy merging mechanism
> > that avoids cache misses by postponing buddy merging until a high-order
> > allocation needs it.
> 
> BTW. I would feel better about this if it gets merged in stages, with
> functional changes split out, and also code optimisations and omore
> obvious performace improvements split out and preferably merged first.
> 

The ordering of the patches was such that least-controversial stuff is
at the start of the patchset. The intention was to be able to select a
cut-off point and say "that's enough for now"

> At a very quick glance, the first 25 or so patches should go in first,
> and that gives a much better base to compare subsequent functional
> changes with.

That's reasonable. I've requeued tests for the patchset up to 25 to see what
that looks like. There is also a part of a later patch that reduces how much
time is spent with interrupts disabled. I should split that out and move it
back to within the cut-off point as something that is "obviously good".

> Patch 18 for example is really significant, and should
> almost be 2.6.29/-stable material IMO.
> 

My impression was that -stable was only for functional regressions where
as this is really a performance thing.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
