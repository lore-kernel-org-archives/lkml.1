Return-Path: <linux-kernel-owner+w=401wt.eu-S1761241AbYFZPEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241AbYFZPEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760484AbYFZPDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:03:54 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48963 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118AbYFZPDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:03:51 -0400
Date: Thu, 26 Jun 2008 20:31:00 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, svaidy@linux.vnet.ibm.com,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
Message-ID: <20080626150100.GA26167@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20080625191100.GI21892@dirshya.in.ibm.com> <87k5gcqpbm.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k5gcqpbm.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 03:49:01PM +0200, Andi Kleen wrote:
> Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> writes:
> >
> > The idea being proposed is to enhance the tunable with varied degrees
> > of consolidation that can work best for different workload
> > characteristics.  echo 2 > /sys/.../sched_mc_power_savings could
> > enable more aggressive consolidation than the default.
> 
> It would be better to fix the single power saving default to work
> better with bursty workloads too than to add more tunables. Tunables
> are basically "we give up, let's push the problem to the user"
> which is not nice. I suspect a lot of users won't even know if their
> workloads are bursty or not.  Or they might have workloads which
> are both bursty and not bursty.
> 
> Or did you try that and failed?

I think we have a reasonable default with sched_mc_power_savings=1.
Beyond that it hard to figure out how much work you can group together
and run in a small number of physical CPU packages. The approach
we are taking is to let system administrators decide what level
of power savings they want. If they want power savings at the cost
of performance, they should be able to do so using a higher
value of sched_mc_power_savings. If they see that they can pack
more work without affecting their transaction time, they should
be able to adjust the level of packing. Beyond a sane default,
it is hard to do this inside the kernel.

Thanks
Dipankar
