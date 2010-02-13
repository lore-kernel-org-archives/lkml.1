Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab0BMS4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 13:56:18 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:56752 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab0BMS4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 13:56:15 -0500
Date: Sun, 14 Feb 2010 00:26:07 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>
Subject: Re: [patch] sched: fix SMT scheduler regression in
 find_busiest_queue()
Message-ID: <20100213185607.GF5882@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
 <20100213182748.GB5882@dirshya.in.ibm.com>
 <1266086376.2677.45.camel@sbs-t61>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1266086376.2677.45.camel@sbs-t61>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha <suresh.b.siddha@intel.com> [2010-02-13 10:39:36]:

> On Sat, 2010-02-13 at 11:27 -0700, Vaidyanathan Srinivasan wrote:
> > The fix that you have posted will solve the problem described.
> 
> Thanks. This SMT scheduler regression is critical for performance and
> would like Ingo/Peterz to push this to Linus as soon as possible. We can
> fix other known issues when we have patches ready and acceptable to
> everyone. Agree?

Yes, Agreed.
 
> > However we need to make sched_smt_powersavings also work by increasing
> > the group capacity and allowing two tasks to run in a core.
> 
> I don't think you saying that this patch breaks sched_smt_powersavings?
> If so, We need to address power-saving aspect differently. Atleast this
> is not as critical, as we don't have any customer who is using the
> smt/mc powersavings tunables.

Correct.  This patch does not break sched_smt_powersavings, additional
change in group capacity is needed.  More work is needed, but nothing
to hold against this fix.

We would want customers to start using powersavings tunables and make
them work reliably.  However, I agree that performance comes first :)

> > As Peter mentioned, SD_PREFER_SIBLING flag is meant to spread the work
> > across group at any sched domain so that the solution will work for
> > pre-Nehalem quad cores also.  But it still needs some work to get it
> > right.
> 
> Agree.
> 
> > The solution you have posted will not work for non-HT quad cores where
> > we want the tasks to be spread across cache domains for best
> > performance though not a severe performance regression as in the case
> > of Nehalem.
> 
> This is completely different issue from this patch and I started another
> thread for this.

Correct.  We can incrementally solve the balancing for different scenarios.

--Vaidy
