Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbYF0EPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbYF0EPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 00:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbYF0EPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 00:15:30 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:33307 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751315AbYF0EPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 00:15:30 -0400
Message-ID: <4864695A.3030901@linux.vnet.ibm.com>
Date: Fri, 27 Jun 2008 09:45:22 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, svaidy@linux.vnet.ibm.com,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dipankar Sarma <dipankar@in.ibm.com>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
References: <20080625191100.GI21892@dirshya.in.ibm.com> <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com> <4863DB29.1020304@firstfloor.org>
In-Reply-To: <4863DB29.1020304@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> A user could be an application and certain applications can predict their
>> workload.
> 
> So you expect the applications to run suid root and change a sysctl?
> And what happens when two applications run that do that and they have differing
> requirements? Will they fight over the sysctl?
> 

We expect the system administrator to set an overall policy. The administrators
should have some flexibility in deciding how aggressive they want their power
savings to be

>> For example, a database, a file indexer, etc can predict their workload.
> 
> 
> A file indexer should run with a high nice level and low priority would ideally always
> prefer power saving. But it doesn't currently. Perhaps it should?
> 

Replace file indexer with a datawarehouse, What if I have several instances of
these workloads running in parallel? The administrator should be able to decide
when to consolidate for power and when to spread for performance.


>> Policies are best known in user land and the best controlled from there.
>> Consider a case where the end user might select a performance based policy or a
>> policy to aggressively save power (during peak tariff times). With
> 
> How many users are going to do that? Seems like a unrealistic case to me.

Two generic comments about the users part

1. The fact that we have sched_mc_power_savings is an indication that there are
users trying to use it for power savings
2. Users demand features, but they can only use them once we provide the tunables.

It might seem unrealistic for a one machine scenario, but consider a data center
hosting thousands of servers. Depending on the utilization, the administrator
might decide to use different policies for different servers.



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
