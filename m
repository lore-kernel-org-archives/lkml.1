Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbYF0Gss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbYF0Gss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 02:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbYF0Gsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 02:48:37 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:50982 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753096AbYF0Gsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 02:48:36 -0400
Date: Fri, 27 Jun 2008 12:20:21 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: David Collier-Brown <davecb@Sun.COM>
Cc: Andi Kleen <andi@firstfloor.org>, balbir@linux.vnet.ibm.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dipankar Sarma <dipankar@in.ibm.com>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
Message-ID: <20080627065021.GB14069@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: David Collier-Brown <davecb@Sun.COM>,
	Andi Kleen <andi@firstfloor.org>, balbir@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Dipankar Sarma <dipankar@in.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
References: <20080625191100.GI21892@dirshya.in.ibm.com> <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com> <4863DB29.1020304@firstfloor.org> <20080626185254.GA12416@dirshya.in.ibm.com> <4863EFE2.6050505@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4863EFE2.6050505@sun.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Collier-Brown <davecb@Sun.COM> [2008-06-26 15:37:06]:

> Vaidyanathan Srinivasan wrote:
>> * Andi Kleen <andi@firstfloor.org> [2008-06-26 20:08:41]:
>>
>>
>>>> A user could be an application and certain applications can predict their
>>>> workload.
>>>
>>> So you expect the applications to run suid root and change a sysctl?
>>> And what happens when two applications run that do that and they have differing
>>> requirements? Will they fight over the sysctl?
>
> There are cases where Oracle does this, to ensure the (critical!) log writer
> isn't starved by cpu-hungry query optimizer processes...

Good here is an example for the use-case we are proposing ;)

>
>
>> System management software and workload monitoring and managing
>> software can potentially control the tunable on behalf of the
>> applications for best overall power savings and performance.
>>
>> Applications with conflicting goals should resolve among themselves.
>> The application with highest performance requirement should win.  The
>> power QoS framework set_acceptable_latency() ensures that the lowest
>> latency set across the system wins.  This tunable can also be based on
>> the similar approach.
>
> This is what the IBM zOS "WLM" does: a godlike service runs, records
> the delays of workloads on the system, and then adjusts tuning  
> parameters to speed up processes which are running slower than their
> service levels call for, taking the resources from processes which
> are running faster than service agreements require.
>
> Look for goal-directed resource management and "workload manager" in  
> Redbooks. Better, ask some of the IBM folks here (;-))

This tunable can certainly be very useful for such WLM software.
However this can be useful in simple system deployment as well.  If
the purpose of the system and its workload characteristics are easily
determined and there is little runtime variation, then the
administrator can easily choose the correct tunable. 

>
>>>> For example, a database, a file indexer, etc can predict their workload.
>>>
>>>
>>> A file indexer should run with a high nice level and low priority would ideally always
>>> prefer power saving. But it doesn't currently. Perhaps it should?
>>
>>
>> Power management settings affect the entire system.  It may not be
>> based on per application priority or nice value.  However if the
>> priority of all the applications currently running in the system
>> indicate power savings, then the kernel can goto more aggressive power
>> saving state.
>>
>>
>>>> Policies are best known in user land and the best controlled from there.
>>>> Consider a case where the end user might select a performance based policy or a
>>>> policy to aggressively save power (during peak tariff times). With
>>>
>>> How many users are going to do that? Seems like a unrealistic case to me.
>
> It's just another policy you could have in your workload management
> set: a friend and I were discussing that just the other day!

Power policy across datacenter that takes into account customer
priority class and current cost of power (peak vs non peak time).

>> System management software should do this.  Certainly manual
>> intervention to change these settings will not be popular.  Given the
>> trends in virtualisation and modular systems, most datacenters will
>> use some form of systems management software and infrastructure that
>> is empowered to make policy based decisions on provisioning and
>> systems configuration.
>>
>> In a small-scale datacenters, peak and off-peak hour settings can be
>> potentially done through simple cron jobs.  
>>
>> --Vaidy
> -
>
> --dave
> -- 
> David Collier-Brown            | Always do right. This will gratify
> Sun Microsystems, Toronto      | some people and astonish the rest
> davecb@sun.com                 |                      -- Mark Twain
> (905) 943-1983, cell: (647) 833-9377, (800) 555-9786 x56583
> bridge: (877) 385-4099 code: 506 9191#
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
