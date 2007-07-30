Return-Path: <linux-kernel-owner+w=401wt.eu-S967223AbXG3R7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967223AbXG3R7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965472AbXG3R71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:59:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:43657 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965089AbXG3R70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:59:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,199,1183359600"; 
   d="scan'208";a="272317843"
Date: Mon, 30 Jul 2007 10:53:27 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, npiggin@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch] sched: introduce SD_BALANCE_FORK for ht/mc/smp domains
Message-ID: <20070730175326.GC10033@linux-os.sc.intel.com>
References: <20070726183225.GJ3318@linux-os.sc.intel.com> <20070726221830.GA4113@elte.hu> <20070726223455.GK3318@linux-os.sc.intel.com> <20070729211644.GC6808@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729211644.GC6808@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 11:16:44PM +0200, Ingo Molnar wrote:
> 
> * Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:
> 
> > They might be doing more exec's and probably covered by exec balance.
> > 
> > There was a small pthread test case which was calculating the time to 
> > create all the threads and how much time each thread took to start 
> > running. It appeared as if the threads ran sequentially one after 
> > another on a DP system with four cores leading to this SD_BALANCE_FORK 
> > observation.
> 
> would be nice to dig out that testcase i suspect and quantify the 
> benefits of your patch.

That test case doesn't do much other than calculating the time taken for each
thread to start running. With this balance on fork patch, that small pthread
test case shows that all the threads now start almost at the same time on all
cores.

> Another workload which might perform better 
> would be linpack: it benefits from fast and immediate 'spreading' of 
> freshly forked threads.

My understanding is that linkpack doesn't do fork often(as such
difference might not be visible, but will take a look). We were planning
to test httperf or some other workloads which probably does fork more often.

thanks,
suresh
