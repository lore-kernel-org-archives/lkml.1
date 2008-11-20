Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbYKTFKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbYKTFKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 00:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYKTFKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 00:10:21 -0500
Received: from colo.lackof.org ([198.49.126.79]:58059 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbYKTFKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 00:10:18 -0500
Date: Wed, 19 Nov 2008 22:10:04 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       ink@jurassic.park.msu.ru, rmk@arm.linux.org.uk, starvik@axis.com,
       tony.luck@intel.com, takata@linux-m32r.org, ralf@linux-mips.org,
       grundler@parisc-linux.org, paulus@samba.org, schwidefsky@de.ibm.com,
       lethal@linux-sh.org, wli@holomorphy.com, davem@davemloft.net,
       jdike@addtoit.com, mingo@redhat.com
Subject: Re: [PATCH 1/2] cpumask: centralize cpu_online_map and
	cpu_possible_map
Message-ID: <20081120051004.GB6252@colo.lackof.org>
References: <200811200107.18162.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811200107.18162.rusty@rustcorp.com.au>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 01:07:16AM +1030, Rusty Russell wrote:
> (I'll be rinsing this through linux-next; testing feedback and even
> Acked-by's appreciated).
> 
> Each SMP arch defines these themselves.  Move them to a central
> location.
> 
> Twists:
> 1) Some archs (m32, parisc, s390) set possible_map to all 1, so we add a
>    CONFIG_INIT_ALL_POSSIBLE for this rather than break them.

Thank you. :)

For generic (kernel/cpu.c) and parisc bits:
Reviewed-by: Grant Grundler <grundler@parisc-linux.org>

thanks,
grant

> 2) mips and sparc32 '#define cpu_possible_map phys_cpu_present_map'.
>    Those archs simply have phys_cpu_present_map replaced everywhere.
> 
> 3) Alpha defined cpu_possible_map to cpu_present_map; this is tricky
>    so I just manipulate them both in sync.
> 
> 4) IA64, cris and m32r have gratuitous 'extern cpumask_t cpu_possible_map'
>    declarations.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Mike Travis <travis@sgi.com>
> Cc: ink@jurassic.park.msu.ru
> Cc: rmk@arm.linux.org.uk
> Cc: starvik@axis.com
> Cc: tony.luck@intel.com
> Cc: takata@linux-m32r.org
> Cc: ralf@linux-mips.org
> Cc: grundler@parisc-linux.org
> Cc: paulus@samba.org
> Cc: schwidefsky@de.ibm.com
> Cc: lethal@linux-sh.org
> Cc: wli@holomorphy.com
> Cc: davem@davemloft.net
> Cc: jdike@addtoit.com
> Cc: mingo@redhat.com
> ---
>  arch/alpha/include/asm/smp.h        |    1 -
>  arch/alpha/kernel/process.c         |    2 ++
>  arch/alpha/kernel/smp.c             |    7 ++-----
>  arch/arm/kernel/smp.c               |   10 ----------
>  arch/cris/arch-v32/kernel/smp.c     |    4 ----
>  arch/cris/include/asm/smp.h         |    1 -
>  arch/ia64/include/asm/smp.h         |    1 -
>  arch/ia64/kernel/smpboot.c          |    6 ------
>  arch/m32r/Kconfig                   |    1 +
>  arch/m32r/kernel/smpboot.c          |    6 ------
>  arch/mips/include/asm/smp.h         |    3 ---
>  arch/mips/kernel/smp-cmp.c          |    2 +-
>  arch/mips/kernel/smp-mt.c           |    2 +-
>  arch/mips/kernel/smp.c              |    7 +------
>  arch/mips/kernel/smtc.c             |    6 +++---
>  arch/mips/pmc-sierra/yosemite/smp.c |    6 +++---
>  arch/mips/sgi-ip27/ip27-smp.c       |    2 +-
>  arch/mips/sibyte/bcm1480/smp.c      |    8 ++++----
>  arch/mips/sibyte/sb1250/smp.c       |    8 ++++----
>  arch/parisc/Kconfig                 |    1 +
>  arch/parisc/kernel/smp.c            |   15 ---------------
>  arch/powerpc/kernel/smp.c           |    4 ----
>  arch/s390/Kconfig                   |    1 +
>  arch/s390/kernel/smp.c              |    6 ------
>  arch/sh/kernel/smp.c                |    6 ------
>  arch/sparc/include/asm/smp_32.h     |    2 --
>  arch/sparc/kernel/smp.c             |    6 ++----
>  arch/sparc/kernel/sparc_ksyms.c     |    4 ----
>  arch/sparc64/kernel/smp.c           |    4 ----
>  arch/um/kernel/smp.c                |    7 -------
>  arch/x86/kernel/smpboot.c           |    6 ------
>  arch/x86/mach-voyager/voyager_smp.c |    7 -------
>  include/asm-m32r/smp.h              |    2 --
>  init/Kconfig                        |    9 +++++++++
>  kernel/cpu.c                        |   11 ++++++-----
>  35 files changed, 42 insertions(+), 132 deletions(-)
> 
> diff -r c8ab7f6fc5e8 arch/alpha/include/asm/smp.h
> --- a/arch/alpha/include/asm/smp.h	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/alpha/include/asm/smp.h	Fri Oct 31 11:22:28 2008 +1100
> @@ -45,7 +45,6 @@ extern struct cpuinfo_alpha cpu_data[NR_
>  #define raw_smp_processor_id()	(current_thread_info()->cpu)
>  
>  extern int smp_num_cpus;
> -#define cpu_possible_map	cpu_present_map
>  
>  extern void arch_send_call_function_single_ipi(int cpu);
>  extern void arch_send_call_function_ipi(cpumask_t mask);
> diff -r c8ab7f6fc5e8 arch/alpha/kernel/process.c
> --- a/arch/alpha/kernel/process.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/alpha/kernel/process.c	Fri Oct 31 11:22:28 2008 +1100
> @@ -94,6 +94,7 @@ common_shutdown_1(void *generic_ptr)
>  		flags |= 0x00040000UL; /* "remain halted" */
>  		*pflags = flags;
>  		cpu_clear(cpuid, cpu_present_map);
> +		cpu_clear(cpuid, cpu_possible_map);
>  		halt();
>  	}
>  #endif
> @@ -120,6 +121,7 @@ common_shutdown_1(void *generic_ptr)
>  #ifdef CONFIG_SMP
>  	/* Wait for the secondaries to halt. */
>  	cpu_clear(boot_cpuid, cpu_present_map);
> +	cpu_clear(boot_cpuid, cpu_possible_map);
>  	while (cpus_weight(cpu_present_map))
>  		barrier();
>  #endif
> diff -r c8ab7f6fc5e8 arch/alpha/kernel/smp.c
> --- a/arch/alpha/kernel/smp.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/alpha/kernel/smp.c	Fri Oct 31 11:22:28 2008 +1100
> @@ -69,11 +69,6 @@ enum ipi_message_type {
>  
>  /* Set to a secondary's cpuid when it comes online.  */
>  static int smp_secondary_alive __devinitdata = 0;
> -
> -/* Which cpus ids came online.  */
> -cpumask_t cpu_online_map;
> -
> -EXPORT_SYMBOL(cpu_online_map);
>  
>  int smp_num_probed;		/* Internal processor count */
>  int smp_num_cpus = 1;		/* Number that came online.  */
> @@ -440,6 +435,7 @@ setup_smp(void)
>  				((char *)cpubase + i*hwrpb->processor_size);
>  			if ((cpu->flags & 0x1cc) == 0x1cc) {
>  				smp_num_probed++;
> +				cpu_set(i, cpu_possible_map);
>  				cpu_set(i, cpu_present_map);
>  				cpu->pal_revision = boot_cpu_palrev;
>  			}
> @@ -473,6 +469,7 @@ smp_prepare_cpus(unsigned int max_cpus)
>  
>  	/* Nothing to do on a UP box, or when told not to.  */
>  	if (smp_num_probed == 1 || max_cpus == 0) {
> +		cpu_possible_map = cpumask_of_cpu(boot_cpuid);
>  		cpu_present_map = cpumask_of_cpu(boot_cpuid);
>  		printk(KERN_INFO "SMP mode deactivated.\n");
>  		return;
> diff -r c8ab7f6fc5e8 arch/arm/kernel/smp.c
> --- a/arch/arm/kernel/smp.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/arm/kernel/smp.c	Fri Oct 31 11:22:28 2008 +1100
> @@ -32,16 +32,6 @@
>  #include <asm/processor.h>
>  #include <asm/tlbflush.h>
>  #include <asm/ptrace.h>
> -
> -/*
> - * bitmask of present and online CPUs.
> - * The present bitmask indicates that the CPU is physically present.
> - * The online bitmask indicates that the CPU is up and running.
> - */
> -cpumask_t cpu_possible_map;
> -EXPORT_SYMBOL(cpu_possible_map);
> -cpumask_t cpu_online_map;
> -EXPORT_SYMBOL(cpu_online_map);
>  
>  /*
>   * as from 2.5, kernels no longer have an init_tasks structure
> diff -r c8ab7f6fc5e8 arch/cris/arch-v32/kernel/smp.c
> --- a/arch/cris/arch-v32/kernel/smp.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/cris/arch-v32/kernel/smp.c	Fri Oct 31 11:22:28 2008 +1100
> @@ -29,11 +29,7 @@ spinlock_t cris_atomic_locks[] = { [0 ..
>  spinlock_t cris_atomic_locks[] = { [0 ... LOCK_COUNT - 1] = SPIN_LOCK_UNLOCKED};
>  
>  /* CPU masks */
> -cpumask_t cpu_online_map = CPU_MASK_NONE;
> -EXPORT_SYMBOL(cpu_online_map);
>  cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
> -cpumask_t cpu_possible_map;
> -EXPORT_SYMBOL(cpu_possible_map);
>  EXPORT_SYMBOL(phys_cpu_present_map);
>  
>  /* Variables used during SMP boot */
> diff -r c8ab7f6fc5e8 arch/ia64/include/asm/smp.h
> --- a/arch/ia64/include/asm/smp.h	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/ia64/include/asm/smp.h	Fri Oct 31 11:22:28 2008 +1100
> @@ -57,7 +57,6 @@ extern struct smp_boot_data {
>  
>  extern char no_int_routing __devinitdata;
>  
> -extern cpumask_t cpu_online_map;
>  extern cpumask_t cpu_core_map[NR_CPUS];
>  DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
>  extern int smp_num_siblings;
> diff -r c8ab7f6fc5e8 arch/ia64/kernel/smpboot.c
> --- a/arch/ia64/kernel/smpboot.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/ia64/kernel/smpboot.c	Fri Oct 31 11:22:28 2008 +1100
> @@ -130,12 +130,6 @@ struct task_struct *task_for_booting_cpu
>   * State for each CPU
>   */
>  DEFINE_PER_CPU(int, cpu_state);
> -
> -/* Bitmasks of currently online, and possible CPUs */
> -cpumask_t cpu_online_map;
> -EXPORT_SYMBOL(cpu_online_map);
> -cpumask_t cpu_possible_map = CPU_MASK_NONE;
> -EXPORT_SYMBOL(cpu_possible_map);
>  
>  cpumask_t cpu_core_map[NR_CPUS] __cacheline_aligned;
>  EXPORT_SYMBOL(cpu_core_map);
> diff -r c8ab7f6fc5e8 arch/m32r/Kconfig
> --- a/arch/m32r/Kconfig	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/m32r/Kconfig	Fri Oct 31 11:22:28 2008 +1100
> @@ -10,6 +10,7 @@ config M32R
>  	default y
>  	select HAVE_IDE
>  	select HAVE_OPROFILE
> +	select INIT_ALL_POSSIBLE
>  
>  config SBUS
>  	bool
> diff -r c8ab7f6fc5e8 arch/m32r/kernel/smpboot.c
> --- a/arch/m32r/kernel/smpboot.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/m32r/kernel/smpboot.c	Fri Oct 31 11:22:28 2008 +1100
> @@ -73,17 +73,11 @@ static unsigned int bsp_phys_id = -1;
>  /* Bitmask of physically existing CPUs */
>  physid_mask_t phys_cpu_present_map;
>  
> -/* Bitmask of currently online CPUs */
> -cpumask_t cpu_online_map;
> -EXPORT_SYMBOL(cpu_online_map);
> -
>  cpumask_t cpu_bootout_map;
>  cpumask_t cpu_bootin_map;
>  static cpumask_t cpu_callin_map;
>  cpumask_t cpu_callout_map;
>  EXPORT_SYMBOL(cpu_callout_map);
> -cpumask_t cpu_possible_map = CPU_MASK_ALL;
> -EXPORT_SYMBOL(cpu_possible_map);
>  
>  /* Per CPU bogomips and other parameters */
>  struct cpuinfo_m32r cpu_data[NR_CPUS] __cacheline_aligned;
> diff -r c8ab7f6fc5e8 arch/mips/include/asm/smp.h
> --- a/arch/mips/include/asm/smp.h	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/mips/include/asm/smp.h	Fri Oct 31 11:22:28 2008 +1100
> @@ -38,9 +38,6 @@ extern int __cpu_logical_map[NR_CPUS];
>  #define SMP_RESCHEDULE_YOURSELF	0x1	/* XXX braindead */
>  #define SMP_CALL_FUNCTION	0x2
>  
> -extern cpumask_t phys_cpu_present_map;
> -#define cpu_possible_map	phys_cpu_present_map
> -
>  extern void asmlinkage smp_bootstrap(void);
>  
>  /*
> diff -r c8ab7f6fc5e8 arch/mips/kernel/smp-cmp.c
> --- a/arch/mips/kernel/smp-cmp.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/mips/kernel/smp-cmp.c	Fri Oct 31 11:22:28 2008 +1100
> @@ -226,7 +226,7 @@ void __init cmp_smp_setup(void)
>  
>  	for (i = 1; i < NR_CPUS; i++) {
>  		if (amon_cpu_avail(i)) {
> -			cpu_set(i, phys_cpu_present_map);
> +			cpu_set(i, cpu_possible_map);
>  			__cpu_number_map[i]	= ++ncpu;
>  			__cpu_logical_map[ncpu]	= i;
>  		}
> diff -r c8ab7f6fc5e8 arch/mips/kernel/smp-mt.c
> --- a/arch/mips/kernel/smp-mt.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/mips/kernel/smp-mt.c	Fri Oct 31 11:22:29 2008 +1100
> @@ -70,7 +70,7 @@ static unsigned int __init smvp_vpe_init
>  		write_vpe_c0_vpeconf0(tmp);
>  
>  		/* Record this as available CPU */
> -		cpu_set(tc, phys_cpu_present_map);
> +		cpu_set(tc, cpu_possible_map);
>  		__cpu_number_map[tc]	= ++ncpu;
>  		__cpu_logical_map[ncpu]	= tc;
>  	}
> diff -r c8ab7f6fc5e8 arch/mips/kernel/smp.c
> --- a/arch/mips/kernel/smp.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/mips/kernel/smp.c	Fri Oct 31 11:22:29 2008 +1100
> @@ -44,14 +44,9 @@
>  #include <asm/mipsmtregs.h>
>  #endif /* CONFIG_MIPS_MT_SMTC */
>  
> -cpumask_t phys_cpu_present_map;		/* Bitmask of available CPUs */
>  volatile cpumask_t cpu_callin_map;	/* Bitmask of started secondaries */
> -cpumask_t cpu_online_map;		/* Bitmask of currently online CPUs */
>  int __cpu_number_map[NR_CPUS];		/* Map physical to logical */
>  int __cpu_logical_map[NR_CPUS];		/* Map logical to physical */
> -
> -EXPORT_SYMBOL(phys_cpu_present_map);
> -EXPORT_SYMBOL(cpu_online_map);
>  
>  extern void cpu_idle(void);
>  
> @@ -195,7 +190,7 @@ void __init smp_prepare_cpus(unsigned in
>  /* preload SMP state for boot cpu */
>  void __devinit smp_prepare_boot_cpu(void)
>  {
> -	cpu_set(0, phys_cpu_present_map);
> +	cpu_set(0, cpu_possible_map);
>  	cpu_set(0, cpu_online_map);
>  	cpu_set(0, cpu_callin_map);
>  }
> diff -r c8ab7f6fc5e8 arch/mips/kernel/smtc.c
> --- a/arch/mips/kernel/smtc.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/mips/kernel/smtc.c	Fri Oct 31 11:22:29 2008 +1100
> @@ -290,7 +290,7 @@ static void smtc_configure_tlb(void)
>   * possibly leave some TCs/VPEs as "slave" processors.
>   *
>   * Use c0_MVPConf0 to find out how many TCs are available, setting up
> - * phys_cpu_present_map and the logical/physical mappings.
> + * cpu_possible_map and the logical/physical mappings.
>   */
>  
>  int __init smtc_build_cpu_map(int start_cpu_slot)
> @@ -304,7 +304,7 @@ int __init smtc_build_cpu_map(int start_
>  	 */
>  	ntcs = ((read_c0_mvpconf0() & MVPCONF0_PTC) >> MVPCONF0_PTC_SHIFT) + 1;
>  	for (i=start_cpu_slot; i<NR_CPUS && i<ntcs; i++) {
> -		cpu_set(i, phys_cpu_present_map);
> +		cpu_set(i, cpu_possible_map);
>  		__cpu_number_map[i] = i;
>  		__cpu_logical_map[i] = i;
>  	}
> @@ -521,7 +521,7 @@ void smtc_prepare_cpus(int cpus)
>  	 * Pull any physically present but unused TCs out of circulation.
>  	 */
>  	while (tc < (((val & MVPCONF0_PTC) >> MVPCONF0_PTC_SHIFT) + 1)) {
> -		cpu_clear(tc, phys_cpu_present_map);
> +		cpu_clear(tc, cpu_possible_map);
>  		cpu_clear(tc, cpu_present_map);
>  		tc++;
>  	}
> diff -r c8ab7f6fc5e8 arch/mips/pmc-sierra/yosemite/smp.c
> --- a/arch/mips/pmc-sierra/yosemite/smp.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/mips/pmc-sierra/yosemite/smp.c	Fri Oct 31 11:22:29 2008 +1100
> @@ -141,7 +141,7 @@ static void __cpuinit yos_boot_secondary
>  }
>  
>  /*
> - * Detect available CPUs, populate phys_cpu_present_map before smp_init
> + * Detect available CPUs, populate cpu_possible_map before smp_init
>   *
>   * We don't want to start the secondary CPU yet nor do we have a nice probing
>   * feature in PMON so we just assume presence of the secondary core.
> @@ -150,10 +150,10 @@ static void __init yos_smp_setup(void)
>  {
>  	int i;
>  
> -	cpus_clear(phys_cpu_present_map);
> +	cpus_clear(cpu_possible_map);
>  
>  	for (i = 0; i < 2; i++) {
> -		cpu_set(i, phys_cpu_present_map);
> +		cpu_set(i, cpu_possible_map);
>  		__cpu_number_map[i]	= i;
>  		__cpu_logical_map[i]	= i;
>  	}
> diff -r c8ab7f6fc5e8 arch/mips/sgi-ip27/ip27-smp.c
> --- a/arch/mips/sgi-ip27/ip27-smp.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/mips/sgi-ip27/ip27-smp.c	Fri Oct 31 11:22:29 2008 +1100
> @@ -76,7 +76,7 @@ static int do_cpumask(cnodeid_t cnode, n
>  			/* Only let it join in if it's marked enabled */
>  			if ((acpu->cpu_info.flags & KLINFO_ENABLE) &&
>  			    (tot_cpus_found != NR_CPUS)) {
> -				cpu_set(cpuid, phys_cpu_present_map);
> +				cpu_set(cpuid, cpu_possible_map);
>  				alloc_cpupda(cpuid, tot_cpus_found);
>  				cpus_found++;
>  				tot_cpus_found++;
> diff -r c8ab7f6fc5e8 arch/mips/sibyte/bcm1480/smp.c
> --- a/arch/mips/sibyte/bcm1480/smp.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/mips/sibyte/bcm1480/smp.c	Fri Oct 31 11:22:29 2008 +1100
> @@ -136,7 +136,7 @@ static void __cpuinit bcm1480_boot_secon
>  
>  /*
>   * Use CFE to find out how many CPUs are available, setting up
> - * phys_cpu_present_map and the logical/physical mappings.
> + * cpu_possible_map and the logical/physical mappings.
>   * XXXKW will the boot CPU ever not be physical 0?
>   *
>   * Common setup before any secondaries are started
> @@ -145,14 +145,14 @@ static void __init bcm1480_smp_setup(voi
>  {
>  	int i, num;
>  
> -	cpus_clear(phys_cpu_present_map);
> -	cpu_set(0, phys_cpu_present_map);
> +	cpus_clear(cpu_possible_map);
> +	cpu_set(0, cpu_possible_map);
>  	__cpu_number_map[0] = 0;
>  	__cpu_logical_map[0] = 0;
>  
>  	for (i = 1, num = 0; i < NR_CPUS; i++) {
>  		if (cfe_cpu_stop(i) == 0) {
> -			cpu_set(i, phys_cpu_present_map);
> +			cpu_set(i, cpu_possible_map);
>  			__cpu_number_map[i] = ++num;
>  			__cpu_logical_map[num] = i;
>  		}
> diff -r c8ab7f6fc5e8 arch/mips/sibyte/sb1250/smp.c
> --- a/arch/mips/sibyte/sb1250/smp.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/mips/sibyte/sb1250/smp.c	Fri Oct 31 11:22:29 2008 +1100
> @@ -124,7 +124,7 @@ static void __cpuinit sb1250_boot_second
>  
>  /*
>   * Use CFE to find out how many CPUs are available, setting up
> - * phys_cpu_present_map and the logical/physical mappings.
> + * cpu_possible_map and the logical/physical mappings.
>   * XXXKW will the boot CPU ever not be physical 0?
>   *
>   * Common setup before any secondaries are started
> @@ -133,14 +133,14 @@ static void __init sb1250_smp_setup(void
>  {
>  	int i, num;
>  
> -	cpus_clear(phys_cpu_present_map);
> -	cpu_set(0, phys_cpu_present_map);
> +	cpus_clear(cpu_possible_map);
> +	cpu_set(0, cpu_possible_map);
>  	__cpu_number_map[0] = 0;
>  	__cpu_logical_map[0] = 0;
>  
>  	for (i = 1, num = 0; i < NR_CPUS; i++) {
>  		if (cfe_cpu_stop(i) == 0) {
> -			cpu_set(i, phys_cpu_present_map);
> +			cpu_set(i, cpu_possible_map);
>  			__cpu_number_map[i] = ++num;
>  			__cpu_logical_map[num] = i;
>  		}
> diff -r c8ab7f6fc5e8 arch/parisc/Kconfig
> --- a/arch/parisc/Kconfig	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/parisc/Kconfig	Fri Oct 31 11:22:29 2008 +1100
> @@ -11,6 +11,7 @@ config PARISC
>  	select HAVE_OPROFILE
>  	select RTC_CLASS
>  	select RTC_DRV_PARISC
> +	select INIT_ALL_POSSIBLE
>  	help
>  	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
>  	  in many of their workstations & servers (HP9000 700 and 800 series,
> diff -r c8ab7f6fc5e8 arch/parisc/kernel/smp.c
> --- a/arch/parisc/kernel/smp.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/parisc/kernel/smp.c	Fri Oct 31 11:22:29 2008 +1100
> @@ -66,21 +66,6 @@ static volatile int cpu_now_booting __re
>  static volatile int cpu_now_booting __read_mostly = 0;	/* track which CPU is booting */
>  
>  static int parisc_max_cpus __read_mostly = 1;
> -
> -/* online cpus are ones that we've managed to bring up completely
> - * possible cpus are all valid cpu 
> - * present cpus are all detected cpu
> - *
> - * On startup we bring up the "possible" cpus. Since we discover
> - * CPUs later, we add them as hotplug, so the possible cpu mask is
> - * empty in the beginning.
> - */
> -
> -cpumask_t cpu_online_map   __read_mostly = CPU_MASK_NONE;	/* Bitmap of online CPUs */
> -cpumask_t cpu_possible_map __read_mostly = CPU_MASK_ALL;	/* Bitmap of Present CPUs */
> -
> -EXPORT_SYMBOL(cpu_online_map);
> -EXPORT_SYMBOL(cpu_possible_map);
>  
>  DEFINE_PER_CPU(spinlock_t, ipi_lock) = SPIN_LOCK_UNLOCKED;
>  
> diff -r c8ab7f6fc5e8 arch/powerpc/kernel/smp.c
> --- a/arch/powerpc/kernel/smp.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/powerpc/kernel/smp.c	Fri Oct 31 11:22:29 2008 +1100
> @@ -60,13 +60,9 @@ int smp_hw_index[NR_CPUS];
>  int smp_hw_index[NR_CPUS];
>  struct thread_info *secondary_ti;
>  
> -cpumask_t cpu_possible_map = CPU_MASK_NONE;
> -cpumask_t cpu_online_map = CPU_MASK_NONE;
>  DEFINE_PER_CPU(cpumask_t, cpu_sibling_map) = CPU_MASK_NONE;
>  DEFINE_PER_CPU(cpumask_t, cpu_core_map) = CPU_MASK_NONE;
>  
> -EXPORT_SYMBOL(cpu_online_map);
> -EXPORT_SYMBOL(cpu_possible_map);
>  EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
>  EXPORT_PER_CPU_SYMBOL(cpu_core_map);
>  
> diff -r c8ab7f6fc5e8 arch/s390/Kconfig
> --- a/arch/s390/Kconfig	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/s390/Kconfig	Fri Oct 31 11:22:29 2008 +1100
> @@ -75,6 +75,7 @@ config S390
>  	select HAVE_KRETPROBES
>  	select HAVE_KVM if 64BIT
>  	select HAVE_ARCH_TRACEHOOK
> +	select INIT_ALL_POSSIBLE
>  
>  source "init/Kconfig"
>  
> diff -r c8ab7f6fc5e8 arch/s390/kernel/smp.c
> --- a/arch/s390/kernel/smp.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/s390/kernel/smp.c	Fri Oct 31 11:22:29 2008 +1100
> @@ -51,12 +51,6 @@
>   */
>  struct _lowcore *lowcore_ptr[NR_CPUS];
>  EXPORT_SYMBOL(lowcore_ptr);
> -
> -cpumask_t cpu_online_map = CPU_MASK_NONE;
> -EXPORT_SYMBOL(cpu_online_map);
> -
> -cpumask_t cpu_possible_map = CPU_MASK_ALL;
> -EXPORT_SYMBOL(cpu_possible_map);
>  
>  static struct task_struct *current_set[NR_CPUS];
>  
> diff -r c8ab7f6fc5e8 arch/sh/kernel/smp.c
> --- a/arch/sh/kernel/smp.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/sh/kernel/smp.c	Fri Oct 31 11:22:29 2008 +1100
> @@ -30,12 +30,6 @@
>  
>  int __cpu_number_map[NR_CPUS];		/* Map physical to logical */
>  int __cpu_logical_map[NR_CPUS];		/* Map logical to physical */
> -
> -cpumask_t cpu_possible_map;
> -EXPORT_SYMBOL(cpu_possible_map);
> -
> -cpumask_t cpu_online_map;
> -EXPORT_SYMBOL(cpu_online_map);
>  
>  static inline void __init smp_store_cpu_info(unsigned int cpu)
>  {
> diff -r c8ab7f6fc5e8 arch/sparc/include/asm/smp_32.h
> --- a/arch/sparc/include/asm/smp_32.h	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/sparc/include/asm/smp_32.h	Fri Oct 31 11:22:29 2008 +1100
> @@ -29,8 +29,6 @@
>   */
>  
>  extern unsigned char boot_cpu_id;
> -extern cpumask_t phys_cpu_present_map;
> -#define cpu_possible_map phys_cpu_present_map
>  
>  typedef void (*smpfunc_t)(unsigned long, unsigned long, unsigned long,
>  		       unsigned long, unsigned long);
> diff -r c8ab7f6fc5e8 arch/sparc/kernel/smp.c
> --- a/arch/sparc/kernel/smp.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/sparc/kernel/smp.c	Fri Oct 31 11:22:29 2008 +1100
> @@ -39,8 +39,6 @@ unsigned char boot_cpu_id = 0;
>  unsigned char boot_cpu_id = 0;
>  unsigned char boot_cpu_id4 = 0; /* boot_cpu_id << 2 */
>  
> -cpumask_t cpu_online_map = CPU_MASK_NONE;
> -cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
>  cpumask_t smp_commenced_mask = CPU_MASK_NONE;
>  
>  /* The only guaranteed locking primitive available on all Sparc
> @@ -334,7 +332,7 @@ void __init smp_setup_cpu_possible_map(v
>  	instance = 0;
>  	while (!cpu_find_by_instance(instance, NULL, &mid)) {
>  		if (mid < NR_CPUS) {
> -			cpu_set(mid, phys_cpu_present_map);
> +			cpu_set(mid, cpu_possible_map);
>  			cpu_set(mid, cpu_present_map);
>  		}
>  		instance++;
> @@ -354,7 +352,7 @@ void __init smp_prepare_boot_cpu(void)
>  
>  	current_thread_info()->cpu = cpuid;
>  	cpu_set(cpuid, cpu_online_map);
> -	cpu_set(cpuid, phys_cpu_present_map);
> +	cpu_set(cpuid, cpu_possible_map);
>  }
>  
>  int __cpuinit __cpu_up(unsigned int cpu)
> diff -r c8ab7f6fc5e8 arch/sparc/kernel/sparc_ksyms.c
> --- a/arch/sparc/kernel/sparc_ksyms.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/sparc/kernel/sparc_ksyms.c	Fri Oct 31 11:22:29 2008 +1100
> @@ -113,10 +113,6 @@ EXPORT_PER_CPU_SYMBOL(__cpu_data);
>  #ifdef CONFIG_SMP
>  /* IRQ implementation. */
>  EXPORT_SYMBOL(synchronize_irq);
> -
> -/* CPU online map and active count. */
> -EXPORT_SYMBOL(cpu_online_map);
> -EXPORT_SYMBOL(phys_cpu_present_map);
>  #endif
>  
>  EXPORT_SYMBOL(__udelay);
> diff -r c8ab7f6fc5e8 arch/sparc64/kernel/smp.c
> --- a/arch/sparc64/kernel/smp.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/sparc64/kernel/smp.c	Fri Oct 31 11:22:29 2008 +1100
> @@ -49,14 +49,10 @@
>  
>  int sparc64_multi_core __read_mostly;
>  
> -cpumask_t cpu_possible_map __read_mostly = CPU_MASK_NONE;
> -cpumask_t cpu_online_map __read_mostly = CPU_MASK_NONE;
>  DEFINE_PER_CPU(cpumask_t, cpu_sibling_map) = CPU_MASK_NONE;
>  cpumask_t cpu_core_map[NR_CPUS] __read_mostly =
>  	{ [0 ... NR_CPUS-1] = CPU_MASK_NONE };
>  
> -EXPORT_SYMBOL(cpu_possible_map);
> -EXPORT_SYMBOL(cpu_online_map);
>  EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
>  EXPORT_SYMBOL(cpu_core_map);
>  
> diff -r c8ab7f6fc5e8 arch/um/kernel/smp.c
> --- a/arch/um/kernel/smp.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/um/kernel/smp.c	Fri Oct 31 11:22:29 2008 +1100
> @@ -24,13 +24,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_ga
>  #include "kern.h"
>  #include "irq_user.h"
>  #include "os.h"
> -
> -/* CPU online map, set by smp_boot_cpus */
> -cpumask_t cpu_online_map = CPU_MASK_NONE;
> -cpumask_t cpu_possible_map = CPU_MASK_NONE;
> -
> -EXPORT_SYMBOL(cpu_online_map);
> -EXPORT_SYMBOL(cpu_possible_map);
>  
>  /* Per CPU bogomips and other parameters
>   * The only piece used here is the ipi pipe, which is set before SMP is
> diff -r c8ab7f6fc5e8 arch/x86/kernel/smpboot.c
> --- a/arch/x86/kernel/smpboot.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/x86/kernel/smpboot.c	Fri Oct 31 11:22:29 2008 +1100
> @@ -101,14 +101,8 @@ EXPORT_SYMBOL(smp_num_siblings);
>  /* Last level cache ID of each logical CPU */
>  DEFINE_PER_CPU(u16, cpu_llc_id) = BAD_APICID;
>  
> -/* bitmap of online cpus */
> -cpumask_t cpu_online_map __read_mostly;
> -EXPORT_SYMBOL(cpu_online_map);
> -
>  cpumask_t cpu_callin_map;
>  cpumask_t cpu_callout_map;
> -cpumask_t cpu_possible_map;
> -EXPORT_SYMBOL(cpu_possible_map);
>  
>  /* representing HT siblings of each logical CPU */
>  DEFINE_PER_CPU(cpumask_t, cpu_sibling_map);
> diff -r c8ab7f6fc5e8 arch/x86/mach-voyager/voyager_smp.c
> --- a/arch/x86/mach-voyager/voyager_smp.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/x86/mach-voyager/voyager_smp.c	Fri Oct 31 11:22:29 2008 +1100
> @@ -61,11 +61,6 @@ static int voyager_extended_cpus = 1;
>  
>  /* Used for the invalidate map that's also checked in the spinlock */
>  static volatile unsigned long smp_invalidate_needed;
> -
> -/* Bitmask of currently online CPUs - used by setup.c for
> -   /proc/cpuinfo, visible externally but still physical */
> -cpumask_t cpu_online_map = CPU_MASK_NONE;
> -EXPORT_SYMBOL(cpu_online_map);
>  
>  /* Bitmask of CPUs present in the system - exported by i386_syms.c, used
>   * by scheduler but indexed physically */
> @@ -216,8 +211,6 @@ static cpumask_t smp_commenced_mask = CP
>  /* This is for the new dynamic CPU boot code */
>  cpumask_t cpu_callin_map = CPU_MASK_NONE;
>  cpumask_t cpu_callout_map = CPU_MASK_NONE;
> -cpumask_t cpu_possible_map = CPU_MASK_NONE;
> -EXPORT_SYMBOL(cpu_possible_map);
>  
>  /* The per processor IRQ masks (these are usually kept in sync) */
>  static __u16 vic_irq_mask[NR_CPUS] __cacheline_aligned;
> diff -r c8ab7f6fc5e8 arch/cris/include/asm/smp.h
> --- a/arch/cris/include/asm/smp.h	Fri Oct 31 10:48:30 2008 +1100
> +++ b/arch/cris/include/asm/smp.h	Fri Oct 31 11:22:29 2008 +1100
> @@ -4,7 +4,6 @@
>  #include <linux/cpumask.h>
>  
>  extern cpumask_t phys_cpu_present_map;
> -extern cpumask_t cpu_possible_map;
>  
>  #define raw_smp_processor_id() (current_thread_info()->cpu)
>  
> diff -r c8ab7f6fc5e8 include/asm-m32r/smp.h
> --- a/include/asm-m32r/smp.h	Fri Oct 31 10:48:30 2008 +1100
> +++ b/include/asm-m32r/smp.h	Fri Oct 31 11:22:29 2008 +1100
> @@ -63,8 +63,6 @@ extern volatile int cpu_2_physid[NR_CPUS
>  #define raw_smp_processor_id()	(current_thread_info()->cpu)
>  
>  extern cpumask_t cpu_callout_map;
> -extern cpumask_t cpu_possible_map;
> -extern cpumask_t cpu_present_map;
>  
>  static __inline__ int hard_smp_processor_id(void)
>  {
> diff -r c8ab7f6fc5e8 init/Kconfig
> --- a/init/Kconfig	Fri Oct 31 10:48:30 2008 +1100
> +++ b/init/Kconfig	Fri Oct 31 11:22:29 2008 +1100
> @@ -910,6 +910,15 @@ config MODULE_SRCVERSION_ALL
>  
>  endif # MODULES
>  
> +config INIT_ALL_POSSIBLE
> +	bool
> +	help
> +	  Back when each arch used to define their own cpu_online_map and
> +	  cpu_possible_map, some of them chose to initialize cpu_possible_map
> +	  with all 1s, and others with all 0s.  When they were centralised,
> +	  it was better to provide this option than to break all the archs
> +	  and have several arch maintainers persuing me down dark alleys.
> +
>  config STOP_MACHINE
>  	bool
>  	default y
> diff -r c8ab7f6fc5e8 kernel/cpu.c
> --- a/kernel/cpu.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/kernel/cpu.c	Fri Oct 31 11:22:29 2008 +1100
> @@ -24,19 +24,20 @@ cpumask_t cpu_present_map __read_mostly;
>  cpumask_t cpu_present_map __read_mostly;
>  EXPORT_SYMBOL(cpu_present_map);
>  
> -#ifndef CONFIG_SMP
> -
>  /*
>   * Represents all cpu's that are currently online.
>   */
> -cpumask_t cpu_online_map __read_mostly = CPU_MASK_ALL;
> +cpumask_t cpu_online_map __read_mostly;
>  EXPORT_SYMBOL(cpu_online_map);
>  
> +#ifdef CONFIG_INIT_ALL_POSSIBLE
>  cpumask_t cpu_possible_map __read_mostly = CPU_MASK_ALL;
> +#else
> +cpumask_t cpu_possible_map __read_mostly;
> +#endif
>  EXPORT_SYMBOL(cpu_possible_map);
>  
> -#else /* CONFIG_SMP */
> -
> +#ifdef CONFIG_SMP
>  /* Serializes the updates to cpu_online_map, cpu_present_map */
>  static DEFINE_MUTEX(cpu_add_remove_lock);
>  
> 
