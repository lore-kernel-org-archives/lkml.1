Return-Path: <linux-kernel-owner+w=401wt.eu-S1030889AbXDJQm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030889AbXDJQm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031103AbXDJQm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:42:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:6887 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031104AbXDJQm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:42:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,390,1170662400"; 
   d="scan'208"; a="225006341:sNHT37548672"
Date: Tue, 10 Apr 2007 09:40:54 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, akpm@linux-foundation.org,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: align rq to cacheline boundary
Message-ID: <20070410164054.GI3948@linux-os.sc.intel.com>
References: <20070409180853.GC3948@linux-os.sc.intel.com> <20070410062421.GA23274@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410062421.GA23274@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 08:24:22AM +0200, Ingo Molnar wrote:
> 
> * Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:
> 
> > Align the per cpu runqueue to the cacheline boundary. This will 
> > minimize the number of cachelines touched during remote wakeup.
> 
> > -static DEFINE_PER_CPU(struct rq, runqueues);
> > +static DEFINE_PER_CPU(struct rq, runqueues) ____cacheline_aligned_in_smp;
> 
> ouch!! Now how did _that_ slip through. The runqueues had been 
> cacheline-aligned for ages. Or at least, they were supposed to be.

perhaps the per_cpu definition gave the impression of cacheline aligned too..

> 
> could you see any improvement in profiles or workloads with this patch 
> applied? (just curious - it's an obviously right fix)

We have seen 0.5% perf improvement on database workload on a 2 node setup.
0.5% is a very good improvement for this workload.

thanks,
suresh
