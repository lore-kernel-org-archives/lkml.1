Return-Path: <linux-kernel-owner+w=401wt.eu-S1764817AbXIMSEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764817AbXIMSEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 14:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbXIMSD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 14:03:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52508 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754309AbXIMSDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 14:03:55 -0400
Date: Thu, 13 Sep 2007 11:03:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Mel Gorman <mel@skynet.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: tbench regression - Why process scheduler has impact on tbench
 and why small per-cpu slab (SLUB) cache creates the scenario?
In-Reply-To: <20070913060432.GB6078@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0709131055430.8859@schroedinger.engr.sgi.com>
References: <1188953218.26438.34.camel@ymzhang> <200709100810.46341.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709101201140.24491@schroedinger.engr.sgi.com>
 <200709110117.57387.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709111314190.25781@schroedinger.engr.sgi.com>
 <20070913060432.GB6078@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007, Siddha, Suresh B wrote:

> Christoph, Not sure if you are referring to me or not here. But our
> tests(atleast on with the database workloads) approx 1.5 months or so back
> showed that on ia64 slub was on par with slab and on x86_64, slub was 9% down.
> And after changing the slub min order and max order, slub perf on x86_64 is
> down approx 3.5% or so compared to slab.

No, I was referring to another talk that I had at the OLS with Corey 
Gough. I keep getting confusing information from Intel. Last I heard was 
that IA64 had a regression and x86_64 was fine (but they were not allowed 
to tell me details). Would you please straighten out your story and give 
me details?

AFAIK the two of us discussed some issues related to object handover 
between processors that cause cache line bouncing and I sent you a 
patchset for testing but I did not get any feedback. The patches that were 
discussed are now in mm.

> While I don't rule out large sized allocations like PAGE_SIZE, I am mostly
> certain that the critical allocations in this workload are not PAGE_SIZE
> based.  Mostly they are in the range less than 300-500 bytes or so.
> 
> Any changes in the recent slub which takes the pressure away from the page
> allocator especially for smaller page sized architectures? If so, we can
> redo some of the experiments. Looking at this thread, it doesn't sound like?

Its too late for 2.6.23. But we can certainly do things for .24. Could you 
please test the patches queued up in Andrew's tree? In particular the page 
allocator pass through and the per cpu structures optimizations?

There is more work out of tree to optimize the fastpath that is mostly 
driven by Mathieu Desnoyers. I hope to get that into mm in the next weeks 
but I do not think that it is going to be available before .25.

The work of Matheiu also has implications for the page allocator. We may 
be able to significantly speed up the fastpath there as well.
