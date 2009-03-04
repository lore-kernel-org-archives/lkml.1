Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbZCDLiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbZCDLiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZCDLii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:38:38 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:42771 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZCDLih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:38:37 -0500
Date: Wed, 4 Mar 2009 17:08:22 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Balbir Singh <balbir@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, efault@gmx.de,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] sched: Extend sched_mc/smt_power_savings
	framework
Message-ID: <20090304113822.GA31307@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090303114648.605.86920.stgit@sofia.in.ibm.com> <1236082917.5330.4195.camel@laptop> <20090303152504.GH4708@dirshya.in.ibm.com> <1236094110.5330.4733.camel@laptop> <20090304110643.GM4708@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304110643.GM4708@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 04:36:43PM +0530, Vaidyanathan Srinivasan wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-03-03 16:28:30]:
> 
> > On Tue, 2009-03-03 at 20:55 +0530, Vaidyanathan Srinivasan wrote:
> > >  
> > > > It would be good to mention something about how power usage is measured.
> > > 
> > > Power usage is measured by computing the energy consumed over the
> > > benchmark duration and then finding average power by dividing
> > > energy/time.  The relative power consumption is for the entire system.
> > 
> > Is this measured using an external (indepedent) power monitor, or
> > looking at system internal power usage stats?
> > 
> > Have you compared these two methods, if so, do they give comparable
> > results?
> 
> Since we are doing relative power comparison, the absolute power value
> and the method would not affect the results.
> 
> Your question is more relevant for SPECPower type of benchmarks where
> the score depends on the average power consumed and accuracy or method
> of measurement can affect the score.
> 
> > > > Furthermore, do we really need those separate mc/smt power savings
> > > > settings? -- It appears to me we ought to consolidate some of that and
> > > > provide a single knob to save power.
> > > 
> > > Yes, having one sched_power_savings will definitely help.  However,
> > > mapping the various combination of settings to a single knob that will
> > > provide consistent behavior across workloads and system configuration
> > > is a challenge.
> > 
> > Would it be an option to provide a single knob for users and have some
> > fine grained feature set for developing/debugging, much like we have
> > sched_features?
> 
> Yes, that will be very good.  Let me explore if sched_features can
> include the power saving attributes while the sched_power_savings can
> be a simple and coarse control for end-users.

Currently each of sched_smt_power_savings and sched_mc_power_savings
tunables can take the values (0, 1, 2).

However, based on the combinations of
(sched_smt_power_savings, sched_mc_power_savings) values,
the system can be in one of the 5 (and not 9) states mentioned below:
[in the increasing order of aggressiveness of the task consolidation]

0. { (0, 0) }
1. { (0, 1) }
2. { (0, 2) }
3. { (1, 0), (1, 1) }
4. { (1, 2), (2, 0), (2, 1), (2, 2)}

4 and 5 are because sched_smt_power_savings implies sched_mc_power_savings.

So, on a system that has multiple cores and multiple threads, the single
knob can take values (0, 1, 2, 3, 4).

On systems that have only multiple cores, the knob can take values
(0, 1, 2).

> --Vaidy

-- 
Thanks and Regards
gautham
