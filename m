Return-Path: <linux-kernel-owner+w=401wt.eu-S1759252AbYFZS3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbYFZS3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbYFZS3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:29:41 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:39711 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752305AbYFZS3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:29:40 -0400
Date: Fri, 27 Jun 2008 00:01:33 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
Message-ID: <20080626183133.GN21892@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Dipankar Sarma <dipankar@in.ibm.com>,
	Andi Kleen <andi@firstfloor.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
References: <20080625191100.GI21892@dirshya.in.ibm.com> <87k5gcqpbm.fsf@basil.nowhere.org> <20080626150100.GA26167@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080626150100.GA26167@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dipankar Sarma <dipankar@in.ibm.com> [2008-06-26 20:31:00]:

> On Thu, Jun 26, 2008 at 03:49:01PM +0200, Andi Kleen wrote:
> > Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> writes:
> > >
> > > The idea being proposed is to enhance the tunable with varied degrees
> > > of consolidation that can work best for different workload
> > > characteristics.  echo 2 > /sys/.../sched_mc_power_savings could
> > > enable more aggressive consolidation than the default.
> > 
> > It would be better to fix the single power saving default to work
> > better with bursty workloads too than to add more tunables. Tunables
> > are basically "we give up, let's push the problem to the user"
> > which is not nice. I suspect a lot of users won't even know if their
> > workloads are bursty or not.  Or they might have workloads which
> > are both bursty and not bursty.
> > 
> > Or did you try that and failed?
> 
> I think we have a reasonable default with sched_mc_power_savings=1.
> Beyond that it hard to figure out how much work you can group together
> and run in a small number of physical CPU packages. The approach
> we are taking is to let system administrators decide what level
> of power savings they want. If they want power savings at the cost
> of performance, they should be able to do so using a higher
> value of sched_mc_power_savings. If they see that they can pack
> more work without affecting their transaction time, they should
> be able to adjust the level of packing. Beyond a sane default,
> it is hard to do this inside the kernel.

Hi Andi,

Aggressive grouping and consolidation may hurt performance to some
extent depending on the workload. The default setting could have least
performance impact and moderate power savings.  We certainly need
user/application input on how much 'potential' performance hit the
application is willing to take in order to save considerable power
under low system utilisation.  As Dipankar has mentioned, the proposed
idea is to use sched_mc_power_savings as a power-savings and
performance trade-off tunable parameter.

We tried to tweak wakeup logic to move tasks to one package at idle,
it works great at idle, but could potentially cause too much redundant
load balancing at certain system utilisation.  Every technique used to
consolidate tasks has its benefits at particular utilisation level and
also depends on nature of workload.  I agree that we should avoid
tunable as far as possible, but we still need make the changes
available to community so that we can compare the different methods
across various workloads and system configuration.  One of the
settings in the tunable can very well be 'let the kernel decide what
is best'

--Vaidy

