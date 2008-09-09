Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbYIIBWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbYIIBWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 21:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbYIIBUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 21:20:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:54241 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070AbYIIBUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 21:20:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,361,1217833200"; 
   d="scan'208";a="378115585"
Date: Mon, 8 Sep 2008 18:20:40 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [RFC PATCH v2 0/7] Tunable sched_mc_power_savings=n
Message-ID: <20080909012039.GO14481@linux-os.sc.intel.com>
References: <20080908131334.3221.61302.stgit@drishya.in.ibm.com> <1220880346.12278.17.camel@twins.programming.kicks-ass.net> <20080908134843.GA4053@dirshya.in.ibm.com> <1220882169.12278.23.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220882169.12278.23.camel@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 06:56:09AM -0700, Peter Zijlstra wrote:
> On Mon, 2008-09-08 at 19:18 +0530, Vaidyanathan Srinivasan wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> [2008-09-08 15:25:46]:
> >
> > > May I again ask to first clean up the current power saving code before
> > > stacking more on top of it?
> >
> > :) I understand that you have asked for two things with respect to the
> > current power save balance code:
> >
> > 1. Detailed documentation
> 
> Preferably in the form of in-code comments and code structure, this
> Documentation/* stuff always gets lost on me.

Peter, Almost every if() stmt/basic block  in the power savings code has
comments around it. And also power-savings code is 50 lines (mostly comments)
in 320 lines of that function.

> But I also prefer to get rid of that power savings tweak in
> cpu_coregroup_map().

Why? Based on the power vs perf, we wanted to construct topologies
differently. Reason for the complexity is, in some of the Intel cpu's,
while the cores share the same package they have different last level caches.
So for performance, we want to differentiate based on last level caches
and for power, we want to consolidate based on the package information.

> But above all, readable code ;-)
> 
> find_busiest_group() is the stuff of nightmares.

power-savings code is very small part of that nightmare :) That code
became complex over years with HT, smp-nice etc.

I haven't been following recent sched changes. I can take a look at it
and see what I can do to better organize find_busiest_group()

thanks,
suresh
