Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbYLAGum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbYLAGum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 01:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbYLAGue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 01:50:34 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:50317 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbYLAGue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 01:50:34 -0500
Message-ID: <49338933.1030401@linux.vnet.ibm.com>
Date: Mon, 01 Dec 2008 12:20:27 +0530
From: Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, svaidy@linux.vnet.ibm.com
Subject: Re: [PATCH] Don't export sched_mc_power_savings in laptops
References: <1227957612-7000-1-git-send-email-mahesh@linux.vnet.ibm.com> <20081130174034.GA28614@elte.hu>
In-Reply-To: <20081130174034.GA28614@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com> wrote:
>
>   
>>         Fix to prevent sched_mc_power_saving from being exported through sysfs
>>         for multicore single socket (Laptop).
>>     
>>         CPU core map of the boot cpu should be equal to possible number
>>         of cpus for single socket system.
>>     
>>         This fix has been developed at FOSS.in kernel workout.
>>     
>>         Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
>>
>> diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
>> index 4850e4b..4adc830 100644
>> --- a/arch/x86/include/asm/topology.h
>> +++ b/arch/x86/include/asm/topology.h
>> @@ -239,7 +239,7 @@ struct pci_bus;
>>  void set_pci_bus_resources_arch_default(struct pci_bus *b);
>>  
>>  #ifdef CONFIG_SMP
>> -#define mc_capable()			(boot_cpu_data.x86_max_cores > 1)
>> +#define mc_capable()	(cpus_weight(per_cpu(cpu_core_map,0)) != nr_cpu_ids)
>>     
>
> hm, dunno. sched_mc_power_savings should have no effect on single-socket 
> systems, right? So the knob should have no effect.
>
> 	Ingo
>   
Hi Ingo,

Yes, it will not have any effect but it enables additional code path 
leading to an
overhead in case of single-socket system. This overhead is only if
"sched_mc_power_savings = 1", however we are still leaving it to zero 
(default) and
preventing user space from turning it on by mistake.

Thanks,
-Mahesh.


