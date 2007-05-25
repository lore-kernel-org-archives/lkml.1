Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbXEYHvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbXEYHvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbXEYHva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:51:30 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53656 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbXEYHv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:51:29 -0400
Date: Fri, 25 May 2007 13:29:36 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, efault@gmx.de, kernel@kolivas.org,
       containers@lists.osdl.org, ckrm-tech@lists.sourceforge.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       pwil3058@bigpond.net.au, tingy@cs.umass.edu, tong.n.li@intel.com,
       wli@holomorphy.com, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070525075936.GE6157@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070523164859.GA6595@in.ibm.com> <20070523183252.GB6253@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523183252.GB6253@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 08:32:52PM +0200, Ingo Molnar wrote:
> > Here's an attempt to extend CFS (v13) to be fair at a group level, 
> > rather than just at task level. The patch is in a very premature state 
> > (passes simple tests, smp load balance not supported yet) at this 
> > point. I am sending it out early to know if this is a good direction 
> > to proceed.
> 
> cool patch! :-)

Thanks!

> > 1. This patch reuses CFS core to achieve fairness at group level also.
> > 
> >    To make this possible, CFS core has been abstracted to deal with 
> >    generic schedulable "entities" (tasks, users etc).
> 
> yeah, i like this alot.
> 
> The "struct sched_entity" abstraction looks very clean, and that's the 
> main thing that matters: it allows for a design that will only cost us 
> performance if group scheduling is desired.
> 
> If you could do a -v14 port and at least add minimal SMP support: i.e. 
> it shouldnt crash on SMP, but otherwise no extra load-balancing logic is 
> needed for the first cut - then i could try to pick all these core 
> changes up for -v15. (I'll let you know about any other thoughts/details 
> when i do the integration.)

Sure ..I will work on a -v14 port. I would like to target for something which:

1. doesn't break performance/functionality of existing CFS scheduler
  -if- CONFIG_FAIR_USER_SCHEDULER is disabled. This also means load
  balance should work as it works today when the config option is
  disabled.

  Do you recommend a set of tests that I need to run to ensure there
  is no regression? I know that there is a bunch of scheduler
  tests floating around on lkml ..Just need to dig to them (or if
  someone has all these tests handy on a website, I will download from
  that site!)

2. Provides fairness at group (user) level at the cost of missing load
   balance functionaility (missing until I get around to work on it that
   is).

> kernel builds dont really push scheduling micro-costs, rather try 
> something like 'hackbench.c' to measure that. (kernel builds are of 
> course one of our primary benchmarks.)

sure i will try that on my next version.

-- 
Regards,
vatsa
