Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbYFZUJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbYFZUJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 16:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYFZUJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 16:09:26 -0400
Received: from brmea-mail-1.Sun.COM ([192.18.98.31]:53575 "EHLO
	brmea-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbYFZUJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 16:09:25 -0400
X-Greylist: delayed 1775 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jun 2008 16:09:23 EDT
Date: Thu, 26 Jun 2008 15:37:06 -0400
From: David Collier-Brown <davecb@Sun.COM>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
In-reply-to: <20080626185254.GA12416@dirshya.in.ibm.com>
To: svaidy@linux.vnet.ibm.com
Cc: Andi Kleen <andi@firstfloor.org>, balbir@linux.vnet.ibm.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dipankar Sarma <dipankar@in.ibm.com>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Reply-to: davecb@Sun.COM
Message-id: <4863EFE2.6050505@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <20080625191100.GI21892@dirshya.in.ibm.com>
 <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com>
 <4863DB29.1020304@firstfloor.org> <20080626185254.GA12416@dirshya.in.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vaidyanathan Srinivasan wrote:
> * Andi Kleen <andi@firstfloor.org> [2008-06-26 20:08:41]:
> 
> 
>>>A user could be an application and certain applications can predict their
>>>workload.
>>
>>So you expect the applications to run suid root and change a sysctl?
>>And what happens when two applications run that do that and they have differing
>>requirements? Will they fight over the sysctl?

There are cases where Oracle does this, to ensure the (critical!) log writer
isn't starved by cpu-hungry query optimizer processes...


> System management software and workload monitoring and managing
> software can potentially control the tunable on behalf of the
> applications for best overall power savings and performance.
> 
> Applications with conflicting goals should resolve among themselves.
> The application with highest performance requirement should win.  The
> power QoS framework set_acceptable_latency() ensures that the lowest
> latency set across the system wins.  This tunable can also be based on
> the similar approach.

This is what the IBM zOS "WLM" does: a godlike service runs, records
the delays of workloads on the system, and then adjusts tuning 
parameters to speed up processes which are running slower than their
service levels call for, taking the resources from processes which
are running faster than service agreements require.

Look for goal-directed resource management and "workload manager" in 
Redbooks. Better, ask some of the IBM folks here (;-))


>>>For example, a database, a file indexer, etc can predict their workload.
>>
>>
>>A file indexer should run with a high nice level and low priority would ideally always
>>prefer power saving. But it doesn't currently. Perhaps it should?
> 
> 
> Power management settings affect the entire system.  It may not be
> based on per application priority or nice value.  However if the
> priority of all the applications currently running in the system
> indicate power savings, then the kernel can goto more aggressive power
> saving state.
> 
> 
>>>Policies are best known in user land and the best controlled from there.
>>>Consider a case where the end user might select a performance based policy or a
>>>policy to aggressively save power (during peak tariff times). With
>>
>>How many users are going to do that? Seems like a unrealistic case to me.

It's just another policy you could have in your workload management
set: a friend and I were discussing that just the other day!

> System management software should do this.  Certainly manual
> intervention to change these settings will not be popular.  Given the
> trends in virtualisation and modular systems, most datacenters will
> use some form of systems management software and infrastructure that
> is empowered to make policy based decisions on provisioning and
> systems configuration.
> 
> In a small-scale datacenters, peak and off-peak hour settings can be
> potentially done through simple cron jobs.  
> 
> --Vaidy
-

--dave
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
(905) 943-1983, cell: (647) 833-9377, (800) 555-9786 x56583
bridge: (877) 385-4099 code: 506 9191#
