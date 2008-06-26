Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbYFZVh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbYFZVh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 17:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbYFZVhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 17:37:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38011 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbYFZVhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 17:37:13 -0400
Message-ID: <48640C04.9020600@firstfloor.org>
Date: Thu, 26 Jun 2008 23:37:08 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: dipankar@in.ibm.com
CC: balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
References: <20080625191100.GI21892@dirshya.in.ibm.com> <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com> <4863DB29.1020304@firstfloor.org> <20080626185254.GA12416@dirshya.in.ibm.com> <4863F93C.9040102@firstfloor.org> <20080626210025.GB26167@in.ibm.com>
In-Reply-To: <20080626210025.GB26167@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dipankar Sarma wrote:

> Some workload managers already do that - they provision cpu and memory
> resources based on request rates and response times. Such software is
> in a better position to make a decision whether they can live with
> reduced performance due to power saving mode or not. The point I am
> making is the the kernel doesn't have any notion of transactional
> performance 

The kernel definitely knows about burstiness vs non burstiness at least
(although it currently has no long term memory for that). Does it need
more than that for this? Anyways if nice levels were used that is not
even needed, because it's ok to run niced processes slower.

And your workload manager could just nice processes. It should probably
do that anyways to tell ondemand you don't need full frequency.

- so if an administrator wants to run unimportant
> transactions on a slower but low-power system, he/she should have
> the option of doing so.
> 
>>> Applications with conflicting goals should resolve among themselves.
>> That sounds wrong to me. Negotiating between conflicting requirements
>> from different applications is something that kernels are supposed
>> to do.
> 
> Agreed. However that is a difficult problem to solve and not the
> intention of this idea. Global power setting is a simple first step.
> I don't think we have a good understanding of cases where conflicting

Always the guy who needs the most performance wins? And if only
niced processes are running it's ok to be slower.

It would be similar to nice levels. In fact nice levels could be probably
used directly (similar to how ionice coopts them too)

Or another case that already uses it is cpufreq/ondemand: when only niced
processes run the CPU is not cranked up to the highest frequency.

I don't see why that information couldn't be used by the load balancer
either to optimize socket use for power. Ok except that the load balancer
is already very tricky. But still would be probably better to have some more
complex code that does DTRT automatically than another tunable.

>>> In a small-scale datacenters, peak and off-peak hour settings can be
>>> potentially done through simple cron jobs.  
>> Is there any real drawback from only controlling it through nice levels?
> 
> In a system with more than a couple of sockets, it is more beneficial
> (power-wise) to pack all work in to a small number of processors
> and let the other processors go to very low power sleep. Compared 
> to running tasks slowly and spreading them all over the processors.

You answered a different question?

> While it would be nice to have a per process tunable, I am not sure
> we are ready for that yet. 

Can you please elaborate what you think is missing?

-Andi
