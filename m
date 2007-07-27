Return-Path: <linux-kernel-owner+w=401wt.eu-S1765499AbXG0TPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765499AbXG0TPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761854AbXG0TO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:14:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:60180 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757763AbXG0TO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:14:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,590,1175497200"; 
   d="scan'208";a="110735165"
Date: Fri, 27 Jul 2007 12:09:06 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch] sched: introduce SD_BALANCE_FORK for ht/mc/smp domains
Message-ID: <20070727190906.GA10033@linux-os.sc.intel.com>
References: <20070726183225.GJ3318@linux-os.sc.intel.com> <20070726221830.GA4113@elte.hu> <20070726223455.GK3318@linux-os.sc.intel.com> <20070727012214.GB13939@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070727012214.GB13939@wotan.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 03:22:14AM +0200, Nick Piggin wrote:
> On Thu, Jul 26, 2007 at 03:34:56PM -0700, Suresh B wrote:
> > On Fri, Jul 27, 2007 at 12:18:30AM +0200, Ingo Molnar wrote:
> > > 
> > > * Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:
> > > 
> > > > Introduce SD_BALANCE_FORK for HT/MC/SMP domains.
> > > > 
> > > > For HT/MC, as caches are shared, SD_BALANCE_FORK is the right thing to 
> > > > do. Given that NUMA domain already has this flag and the scheduler 
> > > > currently doesn't have the concept of running threads belonging to a 
> > > > process as close as possible(i.e., forking may keep close, but 
> > > > periodic balance later will likely take them far away), introduce 
> > > > SD_BALANCE_FORK for SMP domain too.
> > > > 
> > > > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > > 
> > > i'm not opposed to this fundamentally, but it would be nice to better 
> > > map the effects of this change: do you have any particular workload 
> > > under which you've tested this and under which you've seen it makes a 
> > > difference? I'd expect this to improve fork-intense half-idle workloads 
> > > perhaps - things like a make -j3 on a 4-core CPU.
> > 
> > They might be doing more exec's and probably covered by exec balance.
> > 
> > There was a small pthread test case which was calculating the time to create
> > all the threads and how much time each thread took to start running. It
> > appeared as if the threads ran sequentially one after another on a DP system
> > with four cores leading to this SD_BALANCE_FORK observation.
> 
> If it helps throughput in a non-trivial microbenchmark it would be
> helpful.

We are planning to collect some data with this.

> I'm not against it either really, but keep in mind that it
> can make fork more expensive and less scalable; the reason we do it
> for the NUMA domain is because today we're basically screwed WRT
> existing working set if we have to migrage processes over nodes. It
> is really important to try to minimise that any way we possibly can.
> 
> When (if) we get NUMA page replication and automatic migration going,
> I will be looking at whether we can make NUMA migration more
> aggressive (and potentially remove SD_BALANCE_FORK). Not that either
> replication or migration help with kernel allocations, nor are they
> cheap, so NUMA placement will always be worth spending more cycles
> on to get right.

I agree. Perhaps we can set it only for ht/mc domains.

thanks,
suresh
