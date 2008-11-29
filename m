Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbYK2Lhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbYK2Lhq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 06:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbYK2LhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 06:37:20 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:41492 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbYK2LhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 06:37:09 -0500
Message-ID: <493127DC.4020202@linux.vnet.ibm.com>
Date: Sat, 29 Nov 2008 17:00:36 +0530
From: Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Don't export sched_mc_power_savings in laptops
References: <1227957612-7000-1-git-send-email-mahesh@linux.vnet.ibm.com>
In-Reply-To: <1227957612-7000-1-git-send-email-mahesh@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mahesh Salgaonkar wrote:
>         Fix to prevent sched_mc_power_saving from being exported through sysfs
>         for multicore single socket (Laptop).
>     
>         CPU core map of the boot cpu should be equal to possible number
>         of cpus for single socket system.
>     
>         This fix has been developed at FOSS.in kernel workout.
>     
>         Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
>
> diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
> index 4850e4b..4adc830 100644
> --- a/arch/x86/include/asm/topology.h
> +++ b/arch/x86/include/asm/topology.h
> @@ -239,7 +239,7 @@ struct pci_bus;
>  void set_pci_bus_resources_arch_default(struct pci_bus *b);
>
>  #ifdef CONFIG_SMP
> -#define mc_capable()			(boot_cpu_data.x86_max_cores > 1)
> +#define mc_capable()	(cpus_weight(per_cpu(cpu_core_map,0)) != nr_cpu_ids)
>  #define smt_capable()			(smp_num_siblings > 1)
>  #endif
>
>   

The sched_mc_power_savings in sysfs does not help on single socket 
multicore laptops.
The above patch has been tested on dual core laptop and dual socket quad 
core intel processor based server.

Thanks,
-Mahesh.
