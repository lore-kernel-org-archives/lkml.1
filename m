Return-Path: <linux-kernel-owner+w=401wt.eu-S933568AbXHNUvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568AbXHNUvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 16:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759642AbXHNUve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 16:51:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36742 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753009AbXHNUvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 16:51:32 -0400
Date: Tue, 14 Aug 2007 13:50:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH -mm] Fix some section mismatch warnings
Message-Id: <20070814135035.cb8e3aac.akpm@linux-foundation.org>
In-Reply-To: <46BC661E.9000006@googlemail.com>
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<46BC3CB1.2090503@googlemail.com>
	<46BC5C1D.50205@googlemail.com>
	<46BC661E.9000006@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 15:20:30 +0200
Gabriel C <nix.or.die@googlemail.com> wrote:

> Gabriel C wrote:
> > Some new section mismatch warnings:
> > 
> > ...
> > 
> >   MODPOST vmlinux.o
> > WARNING: vmlinux.o(.text+0x17e): Section mismatch: reference to .init.text:initialize_secondary (between 'is386' and 'check_x87')
> > WARNING: vmlinux.o(.text+0x183): Section mismatch: reference to .init.text:start_kernel (between 'is386' and 'check_x87')
> > WARNING: vmlinux.o(.text+0x8c82): Section mismatch: reference to .init.text:register_cpu (between 'arch_register_cpu' and 'alternatives_smp_switch')
> > WARNING: vmlinux.o(.text+0x984d): Section mismatch: reference to .init.data:disable_pse (between 'identify_cpu' and 'identify_secondary_cpu')
> > WARNING: vmlinux.o(.text+0xac59): Section mismatch: reference to .init.text:calibrate_delay (between 'init_cyrix' and 'init_nsc')
> > WARNING: vmlinux.o(.text+0xb4ac): Section mismatch: reference to .init.text:select_idle_routine (between 'init_intel' and 'init_intel_cacheinfo')
> > WARNING: vmlinux.o(.text+0xe49c): Section mismatch: reference to .init.data:cpu_idle_tasks (between 'do_boot_cpu' and 'do_warm_boot_cpu')
> > WARNING: vmlinux.o(.text+0xe881): Section mismatch: reference to .init.data:cpu_idle_tasks (between 'do_boot_cpu' and 'do_warm_boot_cpu')
> > WARNING: vmlinux.o(.text+0xecd8): Section mismatch: reference to .init.data:smp_b_stepping (between 'smp_store_cpu_info' and '__cpu_die')
> > WARNING: vmlinux.o(.text+0xecdd): Section mismatch: reference to .init.data:smp_b_stepping (between 'smp_store_cpu_info' and '__cpu_die')
> > WARNING: vmlinux.o(.text+0xf055): Section mismatch: reference to .init.text:setup_local_APIC (between 'start_secondary' and 'check_tsc_warp')
> > WARNING: vmlinux.o(.text+0xf05f): Section mismatch: reference to .init.text:calibrate_delay (between 'start_secondary' and 'check_tsc_warp')
> > WARNING: vmlinux.o(.text+0xf08e): Section mismatch: reference to .init.text:setup_secondary_APIC_clock (between 'start_secondary' and 'check_tsc_warp')
> > WARNING: vmlinux.o(.text+0x1fe6e): Section mismatch: reference to .init.text:idle_regs (between 'fork_idle' and '__put_task_struct')
> > WARNING: vmlinux.o(.text+0x2717a): Section mismatch: reference to .init.data:tvec_base_done.16336 (between 'timer_cpu_notify' and 'run_timer_softirq')
> > WARNING: vmlinux.o(.text+0x272df): Section mismatch: reference to .init.data:tvec_base_done.16336 (between 'timer_cpu_notify' and 'run_timer_softirq')
> > WARNING: vmlinux.o(.text+0x51df3): Section mismatch: reference to .init.text:start_cpu_timer (between 'vmstat_cpuup_callback' and 'refresh_cpu_vm_stats')
> > WARNING: vmlinux.o(.text+0xcac51): Section mismatch: reference to .init.text:pcibios_fixup_bus (between 'pci_scan_child_bus' and 'pci_scan_bus_parented')
> > WARNING: vmlinux.o(.data+0x5480): Section mismatch: reference to .init.text:workqueue_cpu_callback (between 'workqueue_cpu_callback_nb.12121' and 'workqueue_mutex')
> > WARNING: vmlinux.o(.data+0x90c4): Section mismatch: reference to .init.text:cpu_callback (between 'cpu_callback_nb.18502' and 'shrinker_rwsem')
> > WARNING: vmlinux.o(.data+0x14d84): Section mismatch: reference to .init.text:pci_ite887x_init (between 'pci_serial_quirks' and 'serial_pci_tbl')
> > 
> > ...
> > 
> > 
> > config :
> > 
> > http://194.231.229.228/kernel/mm/2.6.23-rc2-mm2/randconfig-auto-5
> > 
> 
> 
> This patch fixes the .init.data ones
> 
> Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
> 
> ---
> 
> 
> diff -Nurp linux-2.6.23-rc2-mm2/arch/i386/kernel/setup.c linux-2.6.23-rc2-mm2-p/arch/i386/kernel/setup.c
> --- linux-2.6.23-rc2-mm2/arch/i386/kernel/setup.c	2007-08-10 15:05:26.000000000 +0200
> +++ linux-2.6.23-rc2-mm2-p/arch/i386/kernel/setup.c	2007-08-10 15:10:41.000000000 +0200
> @@ -68,7 +68,7 @@
>     address, and must not be in the .bss segment! */
>  unsigned long init_pg_tables_end __initdata = ~0UL;
>  
> -int disable_pse __devinitdata = 0;
> +int disable_pse __cpuinitdata = 0;
>  
>  /*
>   * Machine setup..
> diff -Nurp linux-2.6.23-rc2-mm2/arch/i386/kernel/smpboot.c linux-2.6.23-rc2-mm2-p/arch/i386/kernel/smpboot.c
> --- linux-2.6.23-rc2-mm2/arch/i386/kernel/smpboot.c	2007-08-10 15:05:26.000000000 +0200
> +++ linux-2.6.23-rc2-mm2-p/arch/i386/kernel/smpboot.c	2007-08-10 15:12:19.000000000 +0200
> @@ -60,7 +60,7 @@
>  #include <asm/mtrr.h>
>  
>  /* Set if we find a B stepping CPU */
> -static int __devinitdata smp_b_stepping;
> +static int __cpuinitdata smp_b_stepping;
>  
>  /* Number of siblings per CPU package */
>  int smp_num_siblings = 1;
> @@ -736,7 +736,7 @@ static inline int alloc_cpu_id(void)
>  }
>  
>  #ifdef CONFIG_HOTPLUG_CPU
> -static struct task_struct * __devinitdata cpu_idle_tasks[NR_CPUS];
> +static struct task_struct * __cpuinitdata cpu_idle_tasks[NR_CPUS];
>  static inline struct task_struct * alloc_idle_task(int cpu)
>  {
>  	struct task_struct *idle;
> diff -Nurp linux-2.6.23-rc2-mm2/kernel/timer.c linux-2.6.23-rc2-mm2-p/kernel/timer.c
> --- linux-2.6.23-rc2-mm2/kernel/timer.c	2007-08-10 15:05:34.000000000 +0200
> +++ linux-2.6.23-rc2-mm2-p/kernel/timer.c	2007-08-10 15:13:14.000000000 +0200
> @@ -1216,7 +1216,7 @@ static int __devinit init_timers_cpu(int
>  {
>  	int j;
>  	tvec_base_t *base;
> -	static char __devinitdata tvec_base_done[NR_CPUS];
> +	static char __cpuinitdata tvec_base_done[NR_CPUS];
>  
>  	if (!tvec_base_done[cpu]) {
>  		static char boot_done;

This patch causes more work than it should, really.

- it's not clear which of the above warnings this patch addresses

- there is no explanation telling us where these references come from

- the patch purports to fix three unrelated things.

So, ideally we'd have seen three separate patches, each one accompanied by
an explanation of why the warning arose and how it was fixed.

I'm left to pick through this lot wondering which bits are applicable to
mainline and whether I need to split it up or what.


I don't understand the init_timers_cpu() change.  tvec_base_done[] is
referred to only from init_timers_cpu(), and init_timers_cpu() is
__devinit?

