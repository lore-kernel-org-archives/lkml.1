Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbXINTP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbXINTP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 15:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbXINTPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 15:15:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:23095 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466AbXINTPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 15:15:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,256,1186383600"; 
   d="scan'208";a="307096553"
Date: Fri, 14 Sep 2007 12:15:11 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Mel Gorman <mel@skynet.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew.R.wilcox@intel.com
Subject: Re: tbench regression - Why process scheduler has impact on tbench and why small per-cpu slab (SLUB) cache creates the scenario?
Message-ID: <20070914191511.GC6078@linux-os.sc.intel.com>
References: <1188953218.26438.34.camel@ymzhang> <200709100810.46341.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709101201140.24491@schroedinger.engr.sgi.com> <200709110117.57387.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709111314190.25781@schroedinger.engr.sgi.com> <20070913060432.GB6078@linux-os.sc.intel.com> <Pine.LNX.4.64.0709131055430.8859@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709131055430.8859@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

On Thu, Sep 13, 2007 at 11:03:53AM -0700, Christoph Lameter wrote:
> On Wed, 12 Sep 2007, Siddha, Suresh B wrote:
> 
> > Christoph, Not sure if you are referring to me or not here. But our
> > tests(atleast on with the database workloads) approx 1.5 months or so back
> > showed that on ia64 slub was on par with slab and on x86_64, slub was 9% down.
> > And after changing the slub min order and max order, slub perf on x86_64 is
> > down approx 3.5% or so compared to slab.
> 
> No, I was referring to another talk that I had at the OLS with Corey 
> Gough. I keep getting confusing information from Intel. Last I heard was 

Please don't go with informal talks and discussions. Please demand the numbers
and make decisions, conclusions based on those numbers. AFAIK, we haven't
posted confusing numbers so far.

> that IA64 had a regression and x86_64 was fine (but they were not allowed 
> to tell me details). Would you please straighten out your story and give 
> me details?

Numbers I posted in the previous e-mail is the only story we have so far.

> AFAIK the two of us discussed some issues related to object handover 
> between processors that cause cache line bouncing and I sent you a 
> patchset for testing but I did not get any feedback. The patches that were 

Sorry, These systems are huge and limited. We are raising the priority
with the performance team to do the latest slub patch testing.

> discussed are now in mm.
>
> > While I don't rule out large sized allocations like PAGE_SIZE, I am mostly
> > certain that the critical allocations in this workload are not PAGE_SIZE
> > based.  Mostly they are in the range less than 300-500 bytes or so.
> > 
> > Any changes in the recent slub which takes the pressure away from the page
> > allocator especially for smaller page sized architectures? If so, we can
> > redo some of the experiments. Looking at this thread, it doesn't sound like?
> 
> Its too late for 2.6.23. But we can certainly do things for .24. Could you 
> please test the patches queued up in Andrew's tree? In particular the page 
> allocator pass through and the per cpu structures optimizations?

We are trying to get the latest data with 2.6.23-rc4-mm1 with and without
slub. Is this good enough?

> 
> There is more work out of tree to optimize the fastpath that is mostly 
> driven by Mathieu Desnoyers. I hope to get that into mm in the next weeks 
> but I do not think that it is going to be available before .25.
> 
> The work of Matheiu also has implications for the page allocator. We may 
> be able to significantly speed up the fastpath there as well.

Ok. Atleast till all the regressions addressed and all these patches well
tested, we shouldn't do away with slab from mainline anytime soon.

Other than us, who else are you banking on for analysing slub? Do
you have any numbers that you can share, which show where slub
is good or bad...

thanks,
suresh
