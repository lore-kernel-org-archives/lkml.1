Return-Path: <linux-kernel-owner+w=401wt.eu-S1751825AbZIYAq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbZIYAq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 20:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZIYAq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 20:46:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:54514 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbZIYAq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 20:46:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,448,1249282800"; 
   d="scan'208";a="191451287"
Subject: Re: [PATCH] ACPI: Kill overly verbose "power state" log messages
From: ykzhao <yakui.zhao@intel.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <adapr9gypqz.fsf@cisco.com>
References: <adapr9gypqz.fsf@cisco.com>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Fri, 25 Sep 2009 08:46:37 +0800
Message-Id: <1253839597.3609.459.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 05:52 +0800, Roland Dreier wrote:
> I was recently lucky enough to get a 64-CPU system.  The processors
> actually have T-states, so my kernel log ends up with 64 lines like:
> 
>     ACPI: CPU0 (power states: C1[C1] C2[C3])
> 
> This is pretty useless clutter because this info is already available
> after boot from both /sys/devices/system/cpu/cpu*/cpuidle/state?/ as
> well as /proc/acpi/processor/CPU*/power.
> 
> So just delete the code that prints the throttling states in
> processor_idle.c.
It seems that it is unnecessary to delete the C-state info.
Thanks.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> ---
>  drivers/acpi/processor_idle.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index cc61a62..706eacf 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -1214,13 +1214,6 @@ int __cpuinit acpi_processor_power_init(struct acpi_processor *pr,
>  		acpi_processor_setup_cpuidle(pr);
>  		if (cpuidle_register_device(&pr->power.dev))
>  			return -EIO;
> -
> -		printk(KERN_INFO PREFIX "CPU%d (power states:", pr->id);
> -		for (i = 1; i <= pr->power.count; i++)
> -			if (pr->power.states[i].valid)
> -				printk(" C%d[C%d]", i,
> -				       pr->power.states[i].type);
> -		printk(")\n");
>  	}
>  #ifdef CONFIG_ACPI_PROCFS
>  	/* 'power' [R] */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

