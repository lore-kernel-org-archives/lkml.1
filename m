Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbZHUQMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbZHUQMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 12:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932430AbZHUQMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 12:12:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51833 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbZHUQM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 12:12:29 -0400
Date: Fri, 21 Aug 2009 18:12:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Shane Wang <shane.wang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Subject: Re: [PATCH] intel_txt: fix the build errors of intel_txt patch on
	non-X86 platforms
Message-ID: <20090821161204.GB17731@elte.hu>
References: <4A4ACA66.2000706@intel.com> <20090817154055.GA12985@elte.hu> <20090817155348.GA2254@elte.hu> <037F493892196B458CD3E193E8EBAD4F01EC3AB3B2@pdsmsx502.ccr.corp.intel.com> <20090820161038.GA29994@basil.fritz.box> <4A8E9B3C.5070604@intel.com> <20090821135050.GA30346@elte.hu> <4A8EBBF6.3020505@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8EBBF6.3020505@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Shane Wang <shane.wang@intel.com> wrote:

> Hi
>
> Forget the previous patch. I misundertood Andi's comments. It should be 
> this one. Please comment.
>
> Thanks.
> Shane
>
>
> ---
>  arch/x86/Kconfig              |    4 +++
>  drivers/acpi/acpica/hwsleep.c |    2 -
>  drivers/pci/dmar.c            |    2 -
>  drivers/pci/intel-iommu.c     |    2 -
>  include/linux/tboot.h         |   35 ++++++++++++++++++++++++++++++++
>  init/main.c                   |    2 -
>  kernel/cpu.c                  |    2 -
>  security/Kconfig              |    2 -
>  8 files changed, 45 insertions(+), 6 deletions(-)
>
> Signed-off-by: Shane Wang <shane.wang@intel.com>
>
>
> diff -r e5406357eaf2 arch/x86/Kconfig
> --- a/arch/x86/Kconfig	Thu Aug 20 21:10:50 2009 -0700
> +++ b/arch/x86/Kconfig	Thu Aug 20 21:15:32 2009 -0700
> @@ -179,6 +179,10 @@ config ARCH_SUPPORTS_OPTIMIZED_INLINING
>
>  config ARCH_SUPPORTS_DEBUG_PAGEALLOC
>  	def_bool y
> +
> +config ARCH_HAS_INTEL_TXT
> +	def_bool y
> +	depends on EXPERIMENTAL && DMAR && ACPI
>
>  # Use the generic interrupt handling code in kernel/irq/:
>  config GENERIC_HARDIRQS
> diff -r e5406357eaf2 drivers/acpi/acpica/hwsleep.c
> --- a/drivers/acpi/acpica/hwsleep.c	Thu Aug 20 21:10:50 2009 -0700
> +++ b/drivers/acpi/acpica/hwsleep.c	Thu Aug 20 21:15:32 2009 -0700
> @@ -45,7 +45,7 @@
>  #include <acpi/acpi.h>
>  #include "accommon.h"
>  #include "actables.h"
> -#include <asm/tboot.h>
> +#include <linux/tboot.h>
>
>  #define _COMPONENT          ACPI_HARDWARE
>  ACPI_MODULE_NAME("hwsleep")
> diff -r e5406357eaf2 drivers/pci/dmar.c
> --- a/drivers/pci/dmar.c	Thu Aug 20 21:10:50 2009 -0700
> +++ b/drivers/pci/dmar.c	Thu Aug 20 21:15:32 2009 -0700
> @@ -33,7 +33,7 @@
>  #include <linux/timer.h>
>  #include <linux/irq.h>
>  #include <linux/interrupt.h>
> -#include <asm/tboot.h>
> +#include <linux/tboot.h>
>
>  #undef PREFIX
>  #define PREFIX "DMAR:"
> diff -r e5406357eaf2 drivers/pci/intel-iommu.c
> --- a/drivers/pci/intel-iommu.c	Thu Aug 20 21:10:50 2009 -0700
> +++ b/drivers/pci/intel-iommu.c	Thu Aug 20 21:15:32 2009 -0700
> @@ -37,8 +37,8 @@
>  #include <linux/iommu.h>
>  #include <linux/intel-iommu.h>
>  #include <linux/sysdev.h>
> +#include <linux/tboot.h>
>  #include <asm/cacheflush.h>
> -#include <asm/tboot.h>
>  #include <asm/iommu.h>
>  #include "pci.h"
>
> diff -r e5406357eaf2 include/linux/tboot.h
> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/include/linux/tboot.h	Thu Aug 20 21:15:32 2009 -0700
> @@ -0,0 +1,35 @@
> +/*
> + * Copyright (c) 2006-2009, Intel Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> + *
> + */
> +
> +#ifndef _LINUX_TBOOT_H
> +#define _LINUX_TBOOT_H
> +
> +#ifdef CONFIG_ARCH_HAS_INTEL_TXT
> +#include <asm/tboot.h>
> +#else
> +
> +#define tboot_sleep(sleep_state, pm1a_control, pm1b_control)	\
> +					do { } while (0)
> +#define tboot_get_dmar_table(dmar_tbl)	(dmar_tbl)
> +#define tboot_force_iommu()		0
> +#define tboot_create_trampoline()	do { } while (0)
> +#define tboot_wait_for_aps(num_aps)	0
> +
> +#endif /* !CONFIG_ARCH_HAS_INTEL_TXT */

If then these should be dummy inlines - but in any case, do you 
expect tboot to be used by non-x86 too?

> +#endif /* _LINUX_TBOOT_H */
> diff -r e5406357eaf2 init/main.c
> --- a/init/main.c	Thu Aug 20 21:10:50 2009 -0700
> +++ b/init/main.c	Thu Aug 20 21:15:32 2009 -0700
> @@ -68,12 +68,12 @@
>  #include <linux/async.h>
>  #include <linux/kmemcheck.h>
>  #include <linux/kmemtrace.h>
> +#include <linux/tboot.h>
>  #include <trace/boot.h>
>
>  #include <asm/io.h>
>  #include <asm/bugs.h>
>  #include <asm/setup.h>
> -#include <asm/tboot.h>
>  #include <asm/sections.h>
>  #include <asm/cacheflush.h>
>
> diff -r e5406357eaf2 kernel/cpu.c
> --- a/kernel/cpu.c	Thu Aug 20 21:10:50 2009 -0700
> +++ b/kernel/cpu.c	Thu Aug 20 21:15:32 2009 -0700
> @@ -14,7 +14,7 @@
>  #include <linux/kthread.h>
>  #include <linux/stop_machine.h>
>  #include <linux/mutex.h>
> -#include <asm/tboot.h>
> +#include <linux/tboot.h>
>
>  #ifdef CONFIG_SMP
>  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
> diff -r e5406357eaf2 security/Kconfig
> --- a/security/Kconfig	Thu Aug 20 21:10:50 2009 -0700
> +++ b/security/Kconfig	Thu Aug 20 21:15:32 2009 -0700
> @@ -131,7 +131,7 @@ config LSM_MMAP_MIN_ADDR
>
>  config INTEL_TXT
>  	bool "Enable Intel(R) Trusted Execution Technology (Intel(R) TXT)"
> -	depends on EXPERIMENTAL && X86 && DMAR && ACPI
> +	depends on ARCH_HAS_INTEL_TXT

Nit: what i suggested was HAVE_INTEL_TXT - that is the standard 
kbuild solution these days. (ARCH_HAS_* is legacy-ish)

>> This patch looks better, but i have to question why tboot 
>> modifies generic code at all.
>>
>> i've attached those generic-code changes below. The init/main.c 
>> one could sure be done in x86 arch init code, or via an initcall, 
>> right?
>
> As long as the page table is set up and the memory is initialized, 
> since the tboot code is only to set up 1:1 mapping page table for 
> later use. Do you mean setup_arch() in setup.c? I will try.

yes, something like that. (i have not checked the init dependencies, 
so other places might be more suitable - but setup_arch() definitely 
sounds good. You obviously want to unlock your hardware ASAP.)

>> Regarding kernel/cpu.c. Tthis code in tboot_wait_for_aps() looks  
>> suspicious:
>>
>> int tboot_wait_for_aps(int num_aps)
>> {
>>         unsigned long timeout;
>>
>>         if (!tboot_enabled())
>>                 return 0;
>>
>>         timeout = jiffies + AP_WAIT_TIMEOUT*HZ;
>>         while (atomic_read((atomic_t *)&tboot->num_in_wfs) != num_aps &&
>>                time_before(jiffies, timeout))
>>                 cpu_relax();
>>
>>         return time_before(jiffies, timeout) ? 0 : 1;
>> }
>>
>> the return code looks a bit racy - what if an AP came back just in the 
>> final moment. It should return whether num_in_wfs == num_aps.
>
> Yes;-) "return num_in_wfs == num_aps ? 1 : 0" should be better, right?

better yes - cleaner, not ;-)

jiffies loops are dubious anyway - what if this code ever gets 
called from an irqs-off section? If you want to break out then 
please use mdelay based loops and print a warning message if the 
code has to break out after the timeout and the APs have not 
hand-shaken with us properly.

>> But more importantly, why does this have to be done in generic code in 
>> kernel/smp.c? Why doesnt the x86 arch level bit of _cpu_down() check 
>> whether the CPU goes down. (or, if there's no proper signalling for 
>> that one in the tboot protocol - the _cpu_down() code in x86 could call 
>> tboot_wait_for_aps() if num_online_cpus() == 1 - no need to change 
>> generic code here.
>>
> Which c file do you mentioned about _cpu_down()? I only can find 
> _cpu_down() in kernel/cpu.c.

_cpu_down() is a thin wrapper and there's architecture code that 
does the real thing: __cpu_disable() / smp_ops.cpu_disable() on x86. 

Plus there's a CPU notifier chain action as well you can register to 
via the kernel/cpu.c APIs, and provide a CPU_DYING handler.

(I'd argue for the latter in this case, it's more generic and can 
stay local to the tboot code.)

	Ingo
