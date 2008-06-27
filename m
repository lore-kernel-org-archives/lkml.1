Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbYF0IDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbYF0IDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 04:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbYF0IDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 04:03:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48090 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbYF0IDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 04:03:16 -0400
Message-ID: <48649EBA.5010403@firstfloor.org>
Date: Fri, 27 Jun 2008 10:03:06 +0200
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
References: <20080625191100.GI21892@dirshya.in.ibm.com> <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com> <4863DB29.1020304@firstfloor.org> <20080626185254.GA12416@dirshya.in.ibm.com> <4863F93C.9040102@firstfloor.org> <20080626210025.GB26167@in.ibm.com> <48640C04.9020600@firstfloor.org> <20080627045401.GC26167@in.ibm.com>
In-Reply-To: <20080627045401.GC26167@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dipankar Sarma wrote:
> On Thu, Jun 26, 2008 at 11:37:08PM +0200, Andi Kleen wrote:
>> Dipankar Sarma wrote:
>>
>>> Some workload managers already do that - they provision cpu and memory
>>> resources based on request rates and response times. Such software is
>>> in a better position to make a decision whether they can live with
>>> reduced performance due to power saving mode or not. The point I am
>>> making is the the kernel doesn't have any notion of transactional
>>> performance 
>> The kernel definitely knows about burstiness vs non burstiness at least
>> (although it currently has no long term memory for that). Does it need
>> more than that for this? Anyways if nice levels were used that is not
>> even needed, because it's ok to run niced processes slower.
>>
>> And your workload manager could just nice processes. It should probably
>> do that anyways to tell ondemand you don't need full frequency.
> 
> The current usage of this we are looking requires system-wide
> settings. That means nicing every process running on the system.
> That seems a little messy. 

Is it less messy than the letting applications negotiate
for the best policy by themselves as someone else suggested on the thread?

> Secondly, even if you nice the processes
> they are still going to be spread all over the CPU packages
> running at lower frequencies due to nice. 

My point was that this could be fixed and you could use nice
(or another per process parameter if you prefer)
as an input to load balancer decisions.

> Using nice, you can force lowering of frequency - but you can do that
> using userspace governor as well - no need to mess with process
> priorities.


> We are talking about a different optimization here - something
> that will give more benefits in powersave mode when you have large
> systems.

Yes it's a different optimization (although the over all theme -- power saving
-- is the same), but is there a real reason it cannot be driven from the
same per process heuristics instead of your ugly global sysctl?

>>>>> In a small-scale datacenters, peak and off-peak hour settings can be
>>>>> potentially done through simple cron jobs.  
>>>> Is there any real drawback from only controlling it through nice levels?
>>> In a system with more than a couple of sockets, it is more beneficial
>>> (power-wise) to pack all work in to a small number of processors
>>> and let the other processors go to very low power sleep. Compared 
>>> to running tasks slowly and spreading them all over the processors.
>> You answered a different question?
> 
> The point is that grouping tasks into small number of sockets is
> more effective than nicing which may still spread the tasks all
> over the sockets. 

Sorry you completely misunderstood me. I know the principle
behind the socket grouping.  And yes it's a different mechanism
from cpu frequency scaling.

My point was just that the heuristics
used by one power saving mechanism (ondemand) could be used
for the other too (socket grouping) -- and it would be certainly
a far saner interface than a global sysctl!.

-Andi
