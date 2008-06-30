Return-Path: <linux-kernel-owner+w=401wt.eu-S1762709AbYF3QOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762709AbYF3QOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 12:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756812AbYF3QOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 12:14:41 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34824 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756429AbYF3QOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 12:14:40 -0400
Date: Mon, 30 Jun 2008 21:40:14 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
Message-ID: <20080630161014.GD17123@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20080625191100.GI21892@dirshya.in.ibm.com> <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com> <4863DB29.1020304@firstfloor.org> <20080626185254.GA12416@dirshya.in.ibm.com> <4863F93C.9040102@firstfloor.org> <20080626210025.GB26167@in.ibm.com> <48640C04.9020600@firstfloor.org> <20080627045401.GC26167@in.ibm.com> <48649EBA.5010403@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48649EBA.5010403@firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 10:03:06AM +0200, Andi Kleen wrote:
> Dipankar Sarma wrote:
> > On Thu, Jun 26, 2008 at 11:37:08PM +0200, Andi Kleen wrote:
> >> Dipankar Sarma wrote:
> >>
> > The current usage of this we are looking requires system-wide
> > settings. That means nicing every process running on the system.
> > That seems a little messy. 
> 
> Is it less messy than the letting applications negotiate
> for the best policy by themselves as someone else suggested on the thread?

I don't think letting applications negotiate among
themselves is a good idea. The kernel should do that.

> > Secondly, even if you nice the processes
> > they are still going to be spread all over the CPU packages
> > running at lower frequencies due to nice. 
> 
> My point was that this could be fixed and you could use nice
> (or another per process parameter if you prefer)
> as an input to load balancer decisions.

Agreed. A variation of this that allows tasks to indicate
their CPU power requirement, is something that we experimented
with long ago. There are some difficult issues that need to be
sorted out if this is to be effective -

1. For some applications, like xmms, it is easy to predict. For
   commercial workloads - like a database, it is hard to get
   it right.

2. Conflicting power requirements are hard to resolve. Grouping
   of tasks based on various combinations of power requirement
   is complex.

3. Setting global policy is expensive - you have to loop through
   all the tasks in the system.

> > We are talking about a different optimization here - something
> > that will give more benefits in powersave mode when you have large
> > systems.
> 
> Yes it's a different optimization (although the over all theme -- power saving
> -- is the same), but is there a real reason it cannot be driven from the
> same per process heuristics instead of your ugly global sysctl?

See the issues #1 and #2 above. Apart from that, what we discovered
was that server admins really want a global settings at the moment.
Any finer granularity than that would be a waste for them at the
moment. No one really is looking at running php+mysql at one powernice
and tomcat in another level *in the same server*.


> My point was just that the heuristics
> used by one power saving mechanism (ondemand) could be used
> for the other too (socket grouping) -- and it would be certainly
> a far saner interface than a global sysctl!.

Per-task settings was the first thing we looked at when we
started out. I think we should experiment with it and see
if we can come up with a simple implementation that handles
conflicting requirements well. If this can also handle global
system power settings without having to loop through all the
tasks in the system, I am OK with it.


Thanks
Dipankar
