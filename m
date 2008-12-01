Return-Path: <linux-kernel-owner+w=401wt.eu-S1751446AbYLAHpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbYLAHpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 02:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbYLAHpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 02:45:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43544 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbYLAHpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 02:45:08 -0500
Date: Mon, 1 Dec 2008 08:44:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, svaidy@linux.vnet.ibm.com
Subject: Re: [PATCH] Don't export sched_mc_power_savings in laptops
Message-ID: <20081201074447.GB27768@elte.hu>
References: <1227957612-7000-1-git-send-email-mahesh@linux.vnet.ibm.com> <20081130174034.GA28614@elte.hu> <49338933.1030401@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49338933.1030401@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com> wrote:

> Ingo Molnar wrote:
>> * Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com> wrote:
>>
>>   
>>>         Fix to prevent sched_mc_power_saving from being exported through sysfs
>>>         for multicore single socket (Laptop).
>>>             CPU core map of the boot cpu should be equal to possible 
>>> number
>>>         of cpus for single socket system.
>>>             This fix has been developed at FOSS.in kernel workout.
>>>             Signed-off-by: Mahesh Salgaonkar 
>>> <mahesh@linux.vnet.ibm.com>
>>>
>>> diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
>>> index 4850e4b..4adc830 100644
>>> --- a/arch/x86/include/asm/topology.h
>>> +++ b/arch/x86/include/asm/topology.h
>>> @@ -239,7 +239,7 @@ struct pci_bus;
>>>  void set_pci_bus_resources_arch_default(struct pci_bus *b);
>>>   #ifdef CONFIG_SMP
>>> -#define mc_capable()			(boot_cpu_data.x86_max_cores > 1)
>>> +#define mc_capable()	(cpus_weight(per_cpu(cpu_core_map,0)) != nr_cpu_ids)
>>>     
>>
>> hm, dunno. sched_mc_power_savings should have no effect on 
>> single-socket systems, right? So the knob should have no effect.
>>
>> 	Ingo
>>   
> Hi Ingo,
>
> Yes, it will not have any effect but it enables additional code path 
> leading to an overhead in case of single-socket system. This overhead 
> is only if "sched_mc_power_savings = 1", however we are still leaving 
> it to zero (default) and preventing user space from turning it on by 
> mistake.

okay, makes sense - i've applied it to tip/sched/urgent (for v2.6.28 
merge), thanks Mahesh!

	Ingo
