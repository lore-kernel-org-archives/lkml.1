Return-Path: <linux-kernel-owner+w=401wt.eu-S1760937AbZJIPHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760937AbZJIPHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 11:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757975AbZJIPHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 11:07:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:46176 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757950AbZJIPHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 11:07:38 -0400
Date: Fri, 9 Oct 2009 17:07:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [trivial PATCH] fix typo in nmi.c of apic
In-Reply-To: <3877989d0909102303m31066b01he38e8a295995c430@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.0910091706350.19284@wotan.suse.de>
References: <3877989d0909102303m31066b01he38e8a295995c430@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009, Luming Yu wrote:

> I came across x86/kernel/apic/nmi.c and found several typo.
> It's trivial in terms of doing nothing on changing execution logic.
> 
> Please review. If make sense, please apply.

Hi,

I'd rather go this through x86 tree. Adding Ingo.

> Ps. The patch is enclosed in attachment. The inline one
> is c&p of it for reading.
> 
> 
> Thanks,
> Luming
> 
> Signed-off-by: Yu Luming <luming.yu@intel.com>
> 
>  nmi.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
> index b3025b4..9ff1f6d 100644
> --- a/arch/x86/kernel/apic/nmi.c
> +++ b/arch/x86/kernel/apic/nmi.c
> @@ -121,7 +121,7 @@ static void report_broken_nmi(int cpu, unsigned
> int *prev_nmi_count)
>  	atomic_dec(&nmi_active);
>  }
> 
> -static void __acpi_nmi_disable(void *__unused)
> +static void __apic_nmi_disable(void *__unused)
>  {
>  	apic_write(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
>  }
> @@ -178,7 +178,7 @@ error:
>  	if (nmi_watchdog == NMI_IO_APIC) {
>  		if (!timer_through_8259)
>  			disable_8259A_irq(0);
> -		on_each_cpu(__acpi_nmi_disable, NULL, 1);
> +		on_each_cpu(__apic_nmi_disable, NULL, 1);
>  	}
> 
>  #ifdef CONFIG_X86_32
> @@ -276,7 +276,7 @@ late_initcall(init_lapic_nmi_sysfs);
> 
>  #endif	/* CONFIG_PM */
> 
> -static void __acpi_nmi_enable(void *__unused)
> +static void __apic_nmi_enable(void *__unused)
>  {
>  	apic_write(APIC_LVT0, APIC_DM_NMI);
>  }
> @@ -284,19 +284,19 @@ static void __acpi_nmi_enable(void *__unused)
>  /*
>   * Enable timer based NMIs on all CPUs:
>   */
> -void acpi_nmi_enable(void)
> +void apic_nmi_enable(void)
>  {
>  	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
> -		on_each_cpu(__acpi_nmi_enable, NULL, 1);
> +		on_each_cpu(__apic_nmi_enable, NULL, 1);
>  }
> 
>  /*
>   * Disable timer based NMIs on all CPUs:
>   */
> -void acpi_nmi_disable(void)
> +void apic_nmi_disable(void)
>  {
>  	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
> -		on_each_cpu(__acpi_nmi_disable, NULL, 1);
> +		on_each_cpu(__apic_nmi_disable, NULL, 1);
>  }
> 
>  /*
> @@ -341,7 +341,7 @@ void stop_apic_nmi_watchdog(void *unused)
>  	if (nmi_watchdog == NMI_LOCAL_APIC)
>  		lapic_watchdog_stop();
>  	else
> -		__acpi_nmi_disable(NULL);
> +		__apic_nmi_disable(NULL);
>  	__get_cpu_var(wd_enabled) = 0;
>  	atomic_dec(&nmi_active);
>  }
> @@ -472,7 +472,7 @@ static void enable_ioapic_nmi_watchdog_single(void *unused)
>  {
>  	__get_cpu_var(wd_enabled) = 1;
>  	atomic_inc(&nmi_active);
> -	__acpi_nmi_enable(NULL);
> +	__apic_nmi_enable(NULL);
>  }
> 
>  static void enable_ioapic_nmi_watchdog(void)
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
