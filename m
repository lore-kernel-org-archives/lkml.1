Return-Path: <linux-kernel-owner+w=401wt.eu-S1760351AbYFZVDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351AbYFZVDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 17:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbYFZVD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 17:03:28 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:38262 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbYFZVD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 17:03:27 -0400
Date: Fri, 27 Jun 2008 02:30:25 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
Message-ID: <20080626210025.GB26167@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20080625191100.GI21892@dirshya.in.ibm.com> <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com> <4863DB29.1020304@firstfloor.org> <20080626185254.GA12416@dirshya.in.ibm.com> <4863F93C.9040102@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4863F93C.9040102@firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 10:17:00PM +0200, Andi Kleen wrote:
> Vaidyanathan Srinivasan wrote:
> > System management software and workload monitoring and managing
> > software can potentially control the tunable on behalf of the
> > applications for best overall power savings and performance.
> 
> Does it have the needed information for that? e.g. real time information
> on what the system does? I don't think anybody is in a better position
> to control that than the kernel.

Some workload managers already do that - they provision cpu and memory
resources based on request rates and response times. Such software is
in a better position to make a decision whether they can live with
reduced performance due to power saving mode or not. The point I am
making is the the kernel doesn't have any notion of transactional
performance - so if an administrator wants to run unimportant
transactions on a slower but low-power system, he/she should have
the option of doing so.

> > Applications with conflicting goals should resolve among themselves.
> 
> That sounds wrong to me. Negotiating between conflicting requirements
> from different applications is something that kernels are supposed
> to do.

Agreed. However that is a difficult problem to solve and not the
intention of this idea. Global power setting is a simple first step.
I don't think we have a good understanding of cases where conflicting
power requirements from multiple applications need to be addressed.
We will have to look at that when the issue arises.

> > In a small-scale datacenters, peak and off-peak hour settings can be
> > potentially done through simple cron jobs.  
> 
> Is there any real drawback from only controlling it through nice levels?

In a system with more than a couple of sockets, it is more beneficial
(power-wise) to pack all work in to a small number of processors
and let the other processors go to very low power sleep. Compared 
to running tasks slowly and spreading them all over the processors.

> Anyways I think the main thing I object to in your proposal is that
> your tunable is system global, not per process. I'm also not
> sure if a tunable is really a good idea and if the kernel couldn't
> do a better job.

While it would be nice to have a per process tunable, I am not sure
we are ready for that yet. A global setting is easy to implement
and we have immediate use for it. The kernel already does a decent
job conservatively - by packing one task per core in a package
when sched_mc_power_savings=1 is set. Any further packing may affect 
performance and should not therefore be the default behavior.

Thanks
Dipankar
