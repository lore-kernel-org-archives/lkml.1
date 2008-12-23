Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbYLWBqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbYLWBqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 20:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbYLWBqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 20:46:31 -0500
Received: from relay1.sgi.com ([192.48.179.29]:45928 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753837AbYLWBqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 20:46:30 -0500
Message-ID: <495042F2.5080503@sgi.com>
Date: Mon, 22 Dec 2008 17:46:26 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: use logical apicid in x2apic_cluster's x2apic_cpu_mask_to_apicid_and()
References: <20081223013327.GA29686@linux-os.sc.intel.com>
In-Reply-To: <20081223013327.GA29686@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: x86: use logical apicid in x2apic_cluster's x2apic_cpu_mask_to_apicid_and()
> 
> These commits:
> 
> 	commit 95d313cf1c1ecedc8bec5727b09bdacbf67dfc45
> 	Author: Mike Travis <travis@sgi.com>
> 	Date:   Tue Dec 16 17:33:54 2008 -0800
> 
> 	    x86: Add cpu_mask_to_apicid_and
> 
> and
> 	commit 6eeb7c5a99434596c5953a95baa17d2f085664e3
> 	Author: Mike Travis <travis@sgi.com>
> 	Date:   Tue Dec 16 17:33:55 2008 -0800
> 
> 	    x86: update add-cpu_mask_to_apicid_and to use struct cpumask*
> 
> broke interrupt delivery on x2apic platforms.  As x2apic cluster mode uses
> logical delivery mode, we need to use logical apicid instead of physical apicid
> in x2apic_cpu_mask_to_apicid_and()
> 
> Impact: fixes the broken interrupt delivery issue on generic x2apic platforms.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Thanks Suresh for catching this!  You can add my

Acked-by: Mike Travis <travis@sgi.com>

> ---
> 
> Index: tip/arch/x86/kernel/genx2apic_cluster.c
> ===================================================================
> --- tip.orig/arch/x86/kernel/genx2apic_cluster.c	2008-12-22 17:15:38.000000000 -0800
> +++ tip/arch/x86/kernel/genx2apic_cluster.c	2008-12-22 17:16:17.000000000 -0800
> @@ -114,7 +114,7 @@
>  	int cpu;
>  
>  	/*
> -	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
> +	 * We're using fixed IRQ delivery, can only return one logical APIC ID.
>  	 * May as well be the first.
>  	 */
>  	cpu = cpumask_first(cpumask);
> @@ -130,14 +130,14 @@
>  	int cpu;
>  
>  	/*
> -	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
> +	 * We're using fixed IRQ delivery, can only return one logical APIC ID.
>  	 * May as well be the first.
>  	 */
>  	for_each_cpu_and(cpu, cpumask, andmask)
>  		if (cpumask_test_cpu(cpu, cpu_online_mask))
>  			break;
>  	if (cpu < nr_cpu_ids)
> -		return per_cpu(x86_cpu_to_apicid, cpu);
> +		return per_cpu(x86_cpu_to_logical_apicid, cpu);
>  	return BAD_APICID;
>  }
>  

