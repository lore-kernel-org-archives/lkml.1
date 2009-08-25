Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZHYJMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZHYJMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZHYJM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:12:28 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:50023 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbZHYJM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:12:27 -0400
Date: Tue, 25 Aug 2009 14:42:02 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH v4 2/5] sched: Record the current active power savings
	level
Message-ID: <20090825091202.GA4268@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090331104829.16414.11385.stgit@sofia.in.ibm.com> <20090331105022.16414.4304.stgit@sofia.in.ibm.com> <1251130165.7538.311.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251130165.7538.311.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 06:09:25PM +0200, Peter Zijlstra wrote:
> On Tue, 2009-03-31 at 16:20 +0530, Gautham R Shenoy wrote:
> > The existing load balancer code is dependent on the sched_mc_power_savings
> > variable. However, on multi-core + multi-threaded machines, these decisions
> > need to be dependent on the values of both sched_mc_power_savings and
> > sched_smt_power_savings.
> > 
> > Create a new variable named active_power_savings_level which is the
> > maximum of the sched_mc_power_savings and sched_smt_power_savings.
> > 
> > Record this value in a read mostly global variable at the time when the user
> > changes the value of sched_mc/smt_power_savings tunable, and use it for
> > load-balancing decisions instead of computing it everytime.
> 
> OK, so why keep these variables separate at all?

The power-savings load-balancing in the scheduler depends on two things.
1) The domain at which we want to perform power-aware load balance.

2) The aggressiveness with which we want to perfomr power-aware
load-balance.

The variables were kept seperate for 1) since a non-zero value at
sched_smt_power_savings would indicate that we want to perform
power-aware load balancing at level SD_LV_MC and a non-zero value of
sched_mc_power_savings would indicate that we want to perform
power-aware load balancing at level SD_LV_CPU.

However, if we can agree to do away with these multiple
sched_*_power_savings sysfs variables, and come up with a single tunable
with a reasonable set of values that can map to all relavent
combinations of power-aware-load balancing at the different energy
domains (cache-level, chip-level, node-level), then we can do away with
these separate variables.

-- 
Thanks and Regards
gautham
