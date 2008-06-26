Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbYFZURZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbYFZURZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 16:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYFZURH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 16:17:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51848 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbYFZURG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 16:17:06 -0400
Message-ID: <4863F93C.9040102@firstfloor.org>
Date: Thu, 26 Jun 2008 22:17:00 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, balbir@linux.vnet.ibm.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dipankar Sarma <dipankar@in.ibm.com>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
References: <20080625191100.GI21892@dirshya.in.ibm.com> <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com> <4863DB29.1020304@firstfloor.org> <20080626185254.GA12416@dirshya.in.ibm.com>
In-Reply-To: <20080626185254.GA12416@dirshya.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vaidyanathan Srinivasan wrote:

Playing devil's advocate here.


> * Andi Kleen <andi@firstfloor.org> [2008-06-26 20:08:41]:
> 
>>> A user could be an application and certain applications can predict their
>>> workload.
>> So you expect the applications to run suid root and change a sysctl?
>> And what happens when two applications run that do that and they have differing
>> requirements? Will they fight over the sysctl?
> 
> System management software and workload monitoring and managing
> software can potentially control the tunable on behalf of the
> applications for best overall power savings and performance.

Does it have the needed information for that? e.g. real time information
on what the system does? I don't think anybody is in a better position
to control that than the kernel.

> Applications with conflicting goals should resolve among themselves.

That sounds wrong to me. Negotiating between conflicting requirements
from different applications is something that kernels are supposed
to do.

> The application with highest performance requirement should win.

That is right, but the kernel can do that based on nice levels
and possibly other information, can't it?


>  The
> power QoS framework set_acceptable_latency() ensures that the lowest
> latency set across the system wins.  

But that only helps kernel drivers, not user space, doesn't it?

> Power management settings affect the entire system.  It may not be
> based on per application priority or nice value.  However if the
> priority of all the applications currently running in the system
> indicate power savings, then the kernel can goto more aggressive power
> saving state.

That's what I meant yes. So if only the file system indexer is running
over night all niced it will run as power efficiently as possible.

> In a small-scale datacenters, peak and off-peak hour settings can be
> potentially done through simple cron jobs.  

Is there any real drawback from only controlling it through nice levels?

Anyways I think the main thing I object to in your proposal is that
your tunable is system global, not per process. I'm also not
sure if a tunable is really a good idea and if the kernel couldn't
do a better job.

-Andi
