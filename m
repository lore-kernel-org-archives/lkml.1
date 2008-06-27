Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbYF0E51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbYF0E51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 00:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbYF0E5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 00:57:19 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41119 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbYF0E5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 00:57:18 -0400
Date: Fri, 27 Jun 2008 10:24:01 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
Message-ID: <20080627045401.GC26167@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20080625191100.GI21892@dirshya.in.ibm.com> <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com> <4863DB29.1020304@firstfloor.org> <20080626185254.GA12416@dirshya.in.ibm.com> <4863F93C.9040102@firstfloor.org> <20080626210025.GB26167@in.ibm.com> <48640C04.9020600@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48640C04.9020600@firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 11:37:08PM +0200, Andi Kleen wrote:
> Dipankar Sarma wrote:
> 
> > Some workload managers already do that - they provision cpu and memory
> > resources based on request rates and response times. Such software is
> > in a better position to make a decision whether they can live with
> > reduced performance due to power saving mode or not. The point I am
> > making is the the kernel doesn't have any notion of transactional
> > performance 
> 
> The kernel definitely knows about burstiness vs non burstiness at least
> (although it currently has no long term memory for that). Does it need
> more than that for this? Anyways if nice levels were used that is not
> even needed, because it's ok to run niced processes slower.
> 
> And your workload manager could just nice processes. It should probably
> do that anyways to tell ondemand you don't need full frequency.

The current usage of this we are looking requires system-wide
settings. That means nicing every process running on the system.
That seems a little messy. Secondly, even if you nice the processes
they are still going to be spread all over the CPU packages
running at lower frequencies due to nice. The point I am making
is that it is more effective to push work into smaller number
of cpu packages and let others go to low-power sleep state.

> > Agreed. However that is a difficult problem to solve and not the
> > intention of this idea. Global power setting is a simple first step.
> > I don't think we have a good understanding of cases where conflicting
> 
> Always the guy who needs the most performance wins? And if only
> niced processes are running it's ok to be slower.
> 
> It would be similar to nice levels. In fact nice levels could be probably
> used directly (similar to how ionice coopts them too)
> 
> Or another case that already uses it is cpufreq/ondemand: when only niced
> processes run the CPU is not cranked up to the highest frequency.

Using nice, you can force lowering of frequency - but you can do that
using userspace governor as well - no need to mess with process
priorities. We are talking about a different optimization here - something
that will give more benefits in powersave mode when you have large
systems.

> >>> In a small-scale datacenters, peak and off-peak hour settings can be
> >>> potentially done through simple cron jobs.  
> >> Is there any real drawback from only controlling it through nice levels?
> > 
> > In a system with more than a couple of sockets, it is more beneficial
> > (power-wise) to pack all work in to a small number of processors
> > and let the other processors go to very low power sleep. Compared 
> > to running tasks slowly and spreading them all over the processors.
> 
> You answered a different question?

The point is that grouping tasks into small number of sockets is
more effective than nicing which may still spread the tasks all
over the sockets. Think of this as light-weight CPU hotplug.
Something that can compact and expand CPU capacity fast and
extends an existing power management interface / logic.

Thanks
Dipankar

