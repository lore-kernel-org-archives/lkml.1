Return-Path: <linux-kernel-owner+w=401wt.eu-S935375AbXGZWk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935375AbXGZWk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 18:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763710AbXGZWkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 18:40:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:2526 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbXGZWkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 18:40:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,584,1175497200"; 
   d="scan'208";a="110395045"
Date: Thu, 26 Jul 2007 15:34:56 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, npiggin@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch] sched: introduce SD_BALANCE_FORK for ht/mc/smp domains
Message-ID: <20070726223455.GK3318@linux-os.sc.intel.com>
References: <20070726183225.GJ3318@linux-os.sc.intel.com> <20070726221830.GA4113@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726221830.GA4113@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 12:18:30AM +0200, Ingo Molnar wrote:
> 
> * Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:
> 
> > Introduce SD_BALANCE_FORK for HT/MC/SMP domains.
> > 
> > For HT/MC, as caches are shared, SD_BALANCE_FORK is the right thing to 
> > do. Given that NUMA domain already has this flag and the scheduler 
> > currently doesn't have the concept of running threads belonging to a 
> > process as close as possible(i.e., forking may keep close, but 
> > periodic balance later will likely take them far away), introduce 
> > SD_BALANCE_FORK for SMP domain too.
> > 
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> i'm not opposed to this fundamentally, but it would be nice to better 
> map the effects of this change: do you have any particular workload 
> under which you've tested this and under which you've seen it makes a 
> difference? I'd expect this to improve fork-intense half-idle workloads 
> perhaps - things like a make -j3 on a 4-core CPU.

They might be doing more exec's and probably covered by exec balance.

There was a small pthread test case which was calculating the time to create
all the threads and how much time each thread took to start running. It
appeared as if the threads ran sequentially one after another on a DP system
with four cores leading to this SD_BALANCE_FORK observation.

thanks,
suresh
