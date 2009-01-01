Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbZAASCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbZAASCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 13:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbZAASCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 13:02:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43941 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbZAASCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 13:02:19 -0500
Date: Thu, 1 Jan 2009 19:01:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] cpus4096 updates for v2.6.29, #2
Message-ID: <20090101180111.GA31990@elte.hu>
References: <20081225174944.GA11501@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225174944.GA11501@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Linus,
> 
> Please pull the latest cpus4096-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git cpus4096-for-linus
> 
> This includes the off-stack 'struct cpumask' feature and API changes 
> from Rusty and from Mike Travis: core cpumask infrastructure changes, 
> the conversion of all scheduler cpumask use to the new APIs, and the 
> conversion of x86 the architecture to the new cpumask APIs.

this has a conflict with latest -git - the resolution for that (and an 
init section annotation patch) can be pulled from the cpus4096-for-linus-2 
tree at:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git cpus4096-for-linus-2

 Thanks,

	Ingo

------------------>
Gautham R Shenoy (1):
      sched: framework for sched_mc/smt_power_savings=N

Ingo Molnar (6):
      sched: convert struct root_domain to cpumask_var_t, fix
      x86: update io_apic.c to the new cpumask code
      sched: move test_sd_parent() to an SMP section of sched.h
      sched: fix warning in kernel/sched.c
      x86: fix warning in arch/x86/kernel/io_apic.c
      x86: export vector_used_by_percpu_irq

Mike Travis (20):
      sched: reduce stack size requirements in kernel/sched.c
      x86: fix build error with post-merge of tip/cpus4096 and rr-for-ingo/master.
      x86: enable MAXSMP
      x86 smp: modify send_IPI_mask interface to accept cpumask_t pointers
      x86: move and enhance debug printk for nr_cpu_ids etc.
      x86: Add cpu_mask_to_apicid_and
      x86: update add-cpu_mask_to_apicid_and to use struct cpumask*
      x86: Update io_apic.c to use new cpumask API
      xen: convert to cpumask_var_t and new cpumask primitives.
      x86: fixup_irqs() doesnt need an argument.
      x86: cosmetic changes apic-related files.
      x86: Set CONFIG_NR_CPUS even on UP
      x86: prepare for cpumask iterators to only go to nr_cpu_ids
      x86: Use cpumask accessors code for possible/present maps.
      x86: Remove cpumask games in x86/kernel/cpu/intel_cacheinfo.c
      x86: use work_on_cpu in x86/kernel/cpu/mcheck/mce_amd_64.c
      x86: xen: use smp_call_function_many()
      x86: Introduce topology_core_cpumask()/topology_thread_cpumask()
      x86: fix cpu_mask_to_apicid_and to include cpu_online_mask
      x86: use possible_cpus=NUM to extend the possible cpus allowed

Rusty Russell (30):
      sched: convert sched.c from for_each_cpu_mask to for_each_cpu.
      sched: get rid of boutique sched.c allocations, use cpumask_var_t.
      sched: remove any_online_cpu()
      sched: wrap sched_group and sched_domain cpumask accesses.
      sched: convert struct sched_group/sched_domain cpumask_ts to variable bitmaps
      sched: convert nohz_cpu_mask to cpumask_var_t.
      sched: convert struct root_domain to cpumask_var_t.
      sched: convert nohz struct to cpumask_var_t.
      sched: convert idle_balance() to cpumask_var_t.
      sched: convert rebalance_domains() to cpumask_var_t.
      sched: convert sys_sched_getaffinity() to cpumask_var_t.
      sched: avoid stack var in move_task_off_dead_cpu
      sched: convert struct (sys_)sched_setaffinity() to cpumask_var_t.
      sched: convert sched_domain_debug to cpumask_var_t.
      sched: convert cpu_isolated_map to cpumask_var_t.
      sched: convert falback_doms to cpumask_var_t.
      sched: convert struct cpupri_vec cpumask_var_t.
      sched: convert check_preempt_equal_prio to cpumask_var_t.
      sched: convert local_cpu_mask to cpumask_var_t.
      sched: convert remaining old-style cpumask operators
      sched: convert nohz struct to cpumask_var_t, fix
      sched: convert local_cpu_mask to cpumask_var_t, fix
      sched: avoid stack var in move_task_off_dead_cpu, fix
      cpumask: centralize cpu_online_map and cpu_possible_map
      cpumask: change cpumask_scnprintf, cpumask_parse_user, cpulist_parse, and cpulist_scnprintf to take pointers.
      cpumask: make irq_set_affinity() take a const struct cpumask
      cpumask: convert struct clock_event_device to cpumask pointers.
      cpumask: Add CONFIG_CPUMASK_OFFSTACK
      cpumask: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
      cpumask: Use all NR_CPUS bits unless CONFIG_CPUMASK_OFFSTACK

Sergio Luis (1):
      x86: mark get_cpu_leaves() with __cpuinit annotation

Suresh Siddha (1):
      x86: use logical apicid in x2apic_cluster's x2apic_cpu_mask_to_apicid_and()

Vaidyanathan Srinivasan (7):
      sched: convert BALANCE_FOR_xx_POWER to inline functions
      sched: favour lower logical cpu number for sched_mc balance
      sched: nominate preferred wakeup cpu
      sched: bias task wakeups to preferred semi-idle packages
      sched: activate active load balancing in new idle cpus
      sched: add SD_BALANCE_NEWIDLE at MC and CPU level for sched_mc>0
      sched: nominate preferred wakeup cpu, fix

Yinghai Lu (1):
      x86: fix lguest used_vectors breakage, -v2


 Documentation/cpu-hotplug.txt                 |   17 +-
 arch/alpha/include/asm/smp.h                  |    1 -
 arch/alpha/kernel/irq.c                       |    2 +-
 arch/alpha/kernel/process.c                   |    2 +
 arch/alpha/kernel/smp.c                       |    7 +-
 arch/alpha/kernel/sys_dp264.c                 |    8 +-
 arch/alpha/kernel/sys_titan.c                 |    4 +-
 arch/arm/common/gic.c                         |    4 +-
 arch/arm/kernel/irq.c                         |    2 +-
 arch/arm/kernel/smp.c                         |   10 -
 arch/arm/mach-at91/at91rm9200_time.c          |    3 +-
 arch/arm/mach-at91/at91sam926x_time.c         |    2 +-
 arch/arm/mach-davinci/time.c                  |    2 +-
 arch/arm/mach-imx/time.c                      |    2 +-
 arch/arm/mach-ixp4xx/common.c                 |    2 +-
 arch/arm/mach-msm/timer.c                     |    2 +-
 arch/arm/mach-ns9xxx/time-ns9360.c            |    2 +-
 arch/arm/mach-omap1/time.c                    |    2 +-
 arch/arm/mach-omap1/timer32k.c                |    2 +-
 arch/arm/mach-omap2/timer-gp.c                |    2 +-
 arch/arm/mach-pxa/time.c                      |    2 +-
 arch/arm/mach-realview/core.c                 |    2 +-
 arch/arm/mach-realview/localtimer.c           |    4 +-
 arch/arm/mach-sa1100/time.c                   |    2 +-
 arch/arm/mach-versatile/core.c                |    2 +-
 arch/arm/oprofile/op_model_mpcore.c           |    4 +-
 arch/arm/plat-mxc/time.c                      |    2 +-
 arch/arm/plat-orion/time.c                    |    2 +-
 arch/avr32/kernel/time.c                      |    2 +-
 arch/blackfin/kernel/time-ts.c                |    2 +-
 arch/cris/arch-v32/kernel/irq.c               |    4 +-
 arch/cris/arch-v32/kernel/smp.c               |    4 -
 arch/cris/include/asm/smp.h                   |    1 -
 arch/ia64/hp/sim/hpsim_irq.c                  |    2 +-
 arch/ia64/include/asm/smp.h                   |    1 -
 arch/ia64/include/asm/topology.h              |    2 -
 arch/ia64/kernel/iosapic.c                    |   12 +-
 arch/ia64/kernel/irq.c                        |    9 +-
 arch/ia64/kernel/msi_ia64.c                   |   12 +-
 arch/ia64/kernel/smpboot.c                    |   10 +-
 arch/ia64/kernel/topology.c                   |    2 +-
 arch/ia64/sn/kernel/irq.c                     |    6 +-
 arch/ia64/sn/kernel/msi_sn.c                  |    7 +-
 arch/m32r/Kconfig                             |    1 +
 arch/m32r/kernel/smpboot.c                    |    6 -
 arch/m68knommu/platform/coldfire/pit.c        |    2 +-
 arch/mips/include/asm/irq.h                   |    3 +-
 arch/mips/include/asm/mach-ip27/topology.h    |    1 -
 arch/mips/include/asm/smp.h                   |    3 -
 arch/mips/jazz/irq.c                          |    2 +-
 arch/mips/kernel/cevt-bcm1480.c               |    4 +-
 arch/mips/kernel/cevt-ds1287.c                |    2 +-
 arch/mips/kernel/cevt-gt641xx.c               |    2 +-
 arch/mips/kernel/cevt-r4k.c                   |    2 +-
 arch/mips/kernel/cevt-sb1250.c                |    4 +-
 arch/mips/kernel/cevt-smtc.c                  |    2 +-
 arch/mips/kernel/cevt-txx9.c                  |    2 +-
 arch/mips/kernel/i8253.c                      |    2 +-
 arch/mips/kernel/irq-gic.c                    |    6 +-
 arch/mips/kernel/smp-cmp.c                    |    6 +-
 arch/mips/kernel/smp-mt.c                     |    2 +-
 arch/mips/kernel/smp.c                        |    7 +-
 arch/mips/kernel/smtc.c                       |    6 +-
 arch/mips/mti-malta/malta-smtc.c              |    6 +-
 arch/mips/nxp/pnx8550/common/time.c           |    1 +
 arch/mips/pmc-sierra/yosemite/smp.c           |    6 +-
 arch/mips/sgi-ip27/ip27-smp.c                 |    2 +-
 arch/mips/sgi-ip27/ip27-timer.c               |    2 +-
 arch/mips/sibyte/bcm1480/irq.c                |    8 +-
 arch/mips/sibyte/bcm1480/smp.c                |    8 +-
 arch/mips/sibyte/sb1250/irq.c                 |    8 +-
 arch/mips/sibyte/sb1250/smp.c                 |    8 +-
 arch/mips/sni/time.c                          |    2 +-
 arch/parisc/Kconfig                           |    1 +
 arch/parisc/kernel/irq.c                      |    6 +-
 arch/parisc/kernel/smp.c                      |   15 -
 arch/powerpc/include/asm/topology.h           |    1 -
 arch/powerpc/kernel/irq.c                     |    2 +-
 arch/powerpc/kernel/smp.c                     |    4 -
 arch/powerpc/kernel/time.c                    |    2 +-
 arch/powerpc/platforms/pseries/xics.c         |    4 +-
 arch/powerpc/sysdev/mpic.c                    |    4 +-
 arch/powerpc/sysdev/mpic.h                    |    2 +-
 arch/s390/Kconfig                             |    1 +
 arch/s390/kernel/smp.c                        |    6 -
 arch/s390/kernel/time.c                       |    2 +-
 arch/sh/include/asm/smp.h                     |    2 +-
 arch/sh/include/asm/topology.h                |    1 -
 arch/sh/kernel/smp.c                          |   10 +-
 arch/sh/kernel/timers/timer-broadcast.c       |    2 +-
 arch/sh/kernel/timers/timer-tmu.c             |    2 +-
 arch/sparc/include/asm/smp_32.h               |    2 -
 arch/sparc/kernel/irq_64.c                    |   11 +-
 arch/sparc/kernel/of_device_64.c              |    2 +-
 arch/sparc/kernel/pci_msi.c                   |    2 +-
 arch/sparc/kernel/smp_32.c                    |    6 +-
 arch/sparc/kernel/smp_64.c                    |    4 -
 arch/sparc/kernel/sparc_ksyms_32.c            |    4 -
 arch/sparc/kernel/time_64.c                   |    2 +-
 arch/um/kernel/smp.c                          |    7 -
 arch/um/kernel/time.c                         |    2 +-
 arch/x86/Kconfig                              |   13 +-
 arch/x86/include/asm/bigsmp/apic.h            |   32 +-
 arch/x86/include/asm/bigsmp/ipi.h             |   13 +-
 arch/x86/include/asm/desc.h                   |   10 +-
 arch/x86/include/asm/es7000/apic.h            |   82 ++-
 arch/x86/include/asm/es7000/ipi.h             |   12 +-
 arch/x86/include/asm/genapic_32.h             |   13 +-
 arch/x86/include/asm/genapic_64.h             |   14 +-
 arch/x86/include/asm/ipi.h                    |   23 +-
 arch/x86/include/asm/irq.h                    |    3 +-
 arch/x86/include/asm/mach-default/mach_apic.h |   28 +-
 arch/x86/include/asm/mach-default/mach_ipi.h  |   18 +-
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 +
 arch/x86/include/asm/numaq/apic.h             |   12 +-
 arch/x86/include/asm/numaq/ipi.h              |   13 +-
 arch/x86/include/asm/smp.h                    |    6 +-
 arch/x86/include/asm/summit/apic.h            |   55 ++-
 arch/x86/include/asm/summit/ipi.h             |    9 +-
 arch/x86/include/asm/topology.h               |    2 +
 arch/x86/kernel/apic.c                        |   34 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c         |   45 +-
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c       |  108 ++--
 arch/x86/kernel/genapic_flat_64.c             |  107 ++-
 arch/x86/kernel/genx2apic_cluster.c           |   81 ++-
 arch/x86/kernel/genx2apic_phys.c              |   74 ++-
 arch/x86/kernel/genx2apic_uv_x.c              |   61 ++-
 arch/x86/kernel/hpet.c                        |    8 +-
 arch/x86/kernel/i8253.c                       |    2 +-
 arch/x86/kernel/io_apic.c                     |  370 +++++-----
 arch/x86/kernel/ipi.c                         |   28 +-
 arch/x86/kernel/irq.c                         |    3 +
 arch/x86/kernel/irq_32.c                      |   13 +-
 arch/x86/kernel/irq_64.c                      |   15 +-
 arch/x86/kernel/irqinit_32.c                  |   16 +-
 arch/x86/kernel/irqinit_64.c                  |   13 +
 arch/x86/kernel/mfgpt_32.c                    |    2 +-
 arch/x86/kernel/reboot.c                      |    5 +-
 arch/x86/kernel/setup_percpu.c                |   19 +-
 arch/x86/kernel/smp.c                         |    8 +-
 arch/x86/kernel/smpboot.c                     |   33 +-
 arch/x86/kernel/tlb_32.c                      |    2 +-
 arch/x86/kernel/tlb_64.c                      |    2 +-
 arch/x86/kernel/traps.c                       |   12 +-
 arch/x86/kernel/vmiclock_32.c                 |    2 +-
 arch/x86/lguest/boot.c                        |    2 +-
 arch/x86/mach-generic/bigsmp.c                |    5 +-
 arch/x86/mach-generic/es7000.c                |    5 +-
 arch/x86/mach-generic/numaq.c                 |    5 +-
 arch/x86/mach-generic/summit.c                |    5 +-
 arch/x86/mach-voyager/voyager_smp.c           |    9 +-
 arch/x86/mm/numa_64.c                         |    4 +-
 arch/x86/mm/srat_64.c                         |    2 +-
 arch/x86/xen/mmu.c                            |   20 +-
 arch/x86/xen/smp.c                            |   27 +-
 arch/x86/xen/suspend.c                        |    3 +-
 arch/x86/xen/time.c                           |    2 +-
 arch/x86/xen/xen-ops.h                        |    2 +-
 drivers/base/cpu.c                            |    2 +-
 drivers/base/node.c                           |    4 +-
 drivers/base/topology.c                       |    4 +-
 drivers/clocksource/tcb_clksrc.c              |    2 +-
 drivers/lguest/interrupts_and_traps.c         |   13 +-
 drivers/parisc/iosapic.c                      |    7 +-
 drivers/pci/pci-sysfs.c                       |    4 +-
 drivers/pci/probe.c                           |    4 +-
 drivers/xen/events.c                          |    6 +-
 include/asm-generic/topology.h                |   14 +-
 include/asm-m32r/smp.h                        |    2 -
 include/linux/clockchips.h                    |    4 +-
 include/linux/cpumask.h                       |   98 ++-
 include/linux/interrupt.h                     |    4 +-
 include/linux/irq.h                           |    3 +-
 include/linux/sched.h                         |   92 ++-
 include/linux/topology.h                      |    6 +-
 init/Kconfig                                  |    9 +
 kernel/cpu.c                                  |   11 +-
 kernel/cpuset.c                               |    4 +-
 kernel/irq/chip.c                             |    2 +-
 kernel/irq/manage.c                           |   22 +-
 kernel/irq/migration.c                        |   14 +-
 kernel/irq/proc.c                             |   31 +-
 kernel/profile.c                              |    4 +-
 kernel/rcuclassic.c                           |    2 +-
 kernel/sched.c                                |  970 ++++++++++++++-----------
 kernel/sched_cpupri.c                         |   39 +-
 kernel/sched_cpupri.h                         |    5 +-
 kernel/sched_fair.c                           |   32 +-
 kernel/sched_rt.c                             |   73 ++-
 kernel/sched_stats.h                          |    3 +-
 kernel/taskstats.c                            |    2 +-
 kernel/time/clockevents.c                     |    2 +
 kernel/time/tick-broadcast.c                  |    2 +-
 kernel/time/tick-common.c                     |   12 +-
 kernel/time/tick-sched.c                      |   10 +-
 kernel/trace/trace.c                          |    4 +-
 lib/Kconfig                                   |    7 +
 mm/slub.c                                     |    2 +-
 198 files changed, 2019 insertions(+), 1424 deletions(-)

diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
index 94bbc27..9d620c1 100644
--- a/Documentation/cpu-hotplug.txt
+++ b/Documentation/cpu-hotplug.txt
@@ -50,16 +50,17 @@ additional_cpus=n (*)	Use this to limit hotpluggable cpus. This option sets
   			cpu_possible_map = cpu_present_map + additional_cpus
 
 (*) Option valid only for following architectures
-- x86_64, ia64
+- ia64
 
-ia64 and x86_64 use the number of disabled local apics in ACPI tables MADT
-to determine the number of potentially hot-pluggable cpus. The implementation
-should only rely on this to count the # of cpus, but *MUST* not rely on the
-apicid values in those tables for disabled apics. In the event BIOS doesn't
-mark such hot-pluggable cpus as disabled entries, one could use this
-parameter "additional_cpus=x" to represent those cpus in the cpu_possible_map.
+ia64 uses the number of disabled local apics in ACPI tables MADT to
+determine the number of potentially hot-pluggable cpus. The implementation
+should only rely on this to count the # of cpus, but *MUST* not rely
+on the apicid values in those tables for disabled apics. In the event
+BIOS doesn't mark such hot-pluggable cpus as disabled entries, one could
+use this parameter "additional_cpus=x" to represent those cpus in the
+cpu_possible_map.
 
-possible_cpus=n		[s390 only] use this to set hotpluggable cpus.
+possible_cpus=n		[s390,x86_64] use this to set hotpluggable cpus.
 			This option sets possible_cpus bits in
 			cpu_possible_map. Thus keeping the numbers of bits set
 			constant even if the machine gets rebooted.
diff --git a/arch/alpha/include/asm/smp.h b/arch/alpha/include/asm/smp.h
index 544c69a..547e909 100644
--- a/arch/alpha/include/asm/smp.h
+++ b/arch/alpha/include/asm/smp.h
@@ -45,7 +45,6 @@ extern struct cpuinfo_alpha cpu_data[NR_CPUS];
 #define raw_smp_processor_id()	(current_thread_info()->cpu)
 
 extern int smp_num_cpus;
-#define cpu_possible_map	cpu_present_map
 
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi(cpumask_t mask);
diff --git a/arch/alpha/kernel/irq.c b/arch/alpha/kernel/irq.c
index c626a82..d0f1620 100644
--- a/arch/alpha/kernel/irq.c
+++ b/arch/alpha/kernel/irq.c
@@ -55,7 +55,7 @@ int irq_select_affinity(unsigned int irq)
 	last_cpu = cpu;
 
 	irq_desc[irq].affinity = cpumask_of_cpu(cpu);
-	irq_desc[irq].chip->set_affinity(irq, cpumask_of_cpu(cpu));
+	irq_desc[irq].chip->set_affinity(irq, cpumask_of(cpu));
 	return 0;
 }
 #endif /* CONFIG_SMP */
diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 351407e..f238370 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -94,6 +94,7 @@ common_shutdown_1(void *generic_ptr)
 		flags |= 0x00040000UL; /* "remain halted" */
 		*pflags = flags;
 		cpu_clear(cpuid, cpu_present_map);
+		cpu_clear(cpuid, cpu_possible_map);
 		halt();
 	}
 #endif
@@ -120,6 +121,7 @@ common_shutdown_1(void *generic_ptr)
 #ifdef CONFIG_SMP
 	/* Wait for the secondaries to halt. */
 	cpu_clear(boot_cpuid, cpu_present_map);
+	cpu_clear(boot_cpuid, cpu_possible_map);
 	while (cpus_weight(cpu_present_map))
 		barrier();
 #endif
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index cf7da10..d953e51 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -70,11 +70,6 @@ enum ipi_message_type {
 /* Set to a secondary's cpuid when it comes online.  */
 static int smp_secondary_alive __devinitdata = 0;
 
-/* Which cpus ids came online.  */
-cpumask_t cpu_online_map;
-
-EXPORT_SYMBOL(cpu_online_map);
-
 int smp_num_probed;		/* Internal processor count */
 int smp_num_cpus = 1;		/* Number that came online.  */
 EXPORT_SYMBOL(smp_num_cpus);
@@ -440,6 +435,7 @@ setup_smp(void)
 				((char *)cpubase + i*hwrpb->processor_size);
 			if ((cpu->flags & 0x1cc) == 0x1cc) {
 				smp_num_probed++;
+				cpu_set(i, cpu_possible_map);
 				cpu_set(i, cpu_present_map);
 				cpu->pal_revision = boot_cpu_palrev;
 			}
@@ -473,6 +469,7 @@ smp_prepare_cpus(unsigned int max_cpus)
 
 	/* Nothing to do on a UP box, or when told not to.  */
 	if (smp_num_probed == 1 || max_cpus == 0) {
+		cpu_possible_map = cpumask_of_cpu(boot_cpuid);
 		cpu_present_map = cpumask_of_cpu(boot_cpuid);
 		printk(KERN_INFO "SMP mode deactivated.\n");
 		return;
diff --git a/arch/alpha/kernel/sys_dp264.c b/arch/alpha/kernel/sys_dp264.c
index c71b0fd..ab44c16 100644
--- a/arch/alpha/kernel/sys_dp264.c
+++ b/arch/alpha/kernel/sys_dp264.c
@@ -177,19 +177,19 @@ cpu_set_irq_affinity(unsigned int irq, cpumask_t affinity)
 }
 
 static void
-dp264_set_affinity(unsigned int irq, cpumask_t affinity)
+dp264_set_affinity(unsigned int irq, const struct cpumask *affinity)
 { 
 	spin_lock(&dp264_irq_lock);
-	cpu_set_irq_affinity(irq, affinity);
+	cpu_set_irq_affinity(irq, *affinity);
 	tsunami_update_irq_hw(cached_irq_mask);
 	spin_unlock(&dp264_irq_lock);
 }
 
 static void
-clipper_set_affinity(unsigned int irq, cpumask_t affinity)
+clipper_set_affinity(unsigned int irq, const struct cpumask *affinity)
 { 
 	spin_lock(&dp264_irq_lock);
-	cpu_set_irq_affinity(irq - 16, affinity);
+	cpu_set_irq_affinity(irq - 16, *affinity);
 	tsunami_update_irq_hw(cached_irq_mask);
 	spin_unlock(&dp264_irq_lock);
 }
diff --git a/arch/alpha/kernel/sys_titan.c b/arch/alpha/kernel/sys_titan.c
index 52c91cc..27f840a 100644
--- a/arch/alpha/kernel/sys_titan.c
+++ b/arch/alpha/kernel/sys_titan.c
@@ -158,10 +158,10 @@ titan_cpu_set_irq_affinity(unsigned int irq, cpumask_t affinity)
 }
 
 static void
-titan_set_irq_affinity(unsigned int irq, cpumask_t affinity)
+titan_set_irq_affinity(unsigned int irq, const struct cpumask *affinity)
 { 
 	spin_lock(&titan_irq_lock);
-	titan_cpu_set_irq_affinity(irq - 16, affinity);
+	titan_cpu_set_irq_affinity(irq - 16, *affinity);
 	titan_update_irq_hw(titan_cached_irq_mask);
 	spin_unlock(&titan_irq_lock);
 }
diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 7fc9860..c6884ba 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -109,11 +109,11 @@ static void gic_unmask_irq(unsigned int irq)
 }
 
 #ifdef CONFIG_SMP
-static void gic_set_cpu(unsigned int irq, cpumask_t mask_val)
+static void gic_set_cpu(unsigned int irq, const struct cpumask *mask_val)
 {
 	void __iomem *reg = gic_dist_base(irq) + GIC_DIST_TARGET + (gic_irq(irq) & ~3);
 	unsigned int shift = (irq % 4) * 8;
-	unsigned int cpu = first_cpu(mask_val);
+	unsigned int cpu = cpumask_first(mask_val);
 	u32 val;
 
 	spin_lock(&irq_controller_lock);
diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 2f3eb79..7141cee 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -174,7 +174,7 @@ static void route_irq(struct irq_desc *desc, unsigned int irq, unsigned int cpu)
 	pr_debug("IRQ%u: moving from cpu%u to cpu%u\n", irq, desc->cpu, cpu);
 
 	spin_lock_irq(&desc->lock);
-	desc->chip->set_affinity(irq, cpumask_of_cpu(cpu));
+	desc->chip->set_affinity(irq, cpumask_of(cpu));
 	spin_unlock_irq(&desc->lock);
 }
 
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 019237d..55fa7ff 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -34,16 +34,6 @@
 #include <asm/ptrace.h>
 
 /*
- * bitmask of present and online CPUs.
- * The present bitmask indicates that the CPU is physically present.
- * The online bitmask indicates that the CPU is up and running.
- */
-cpumask_t cpu_possible_map;
-EXPORT_SYMBOL(cpu_possible_map);
-cpumask_t cpu_online_map;
-EXPORT_SYMBOL(cpu_online_map);
-
-/*
  * as from 2.5, kernels no longer have an init_tasks structure
  * so we need some other way of telling a new secondary core
  * where to place its SVC stack
diff --git a/arch/arm/mach-at91/at91rm9200_time.c b/arch/arm/mach-at91/at91rm9200_time.c
index d140eae..1ff1bda 100644
--- a/arch/arm/mach-at91/at91rm9200_time.c
+++ b/arch/arm/mach-at91/at91rm9200_time.c
@@ -178,7 +178,6 @@ static struct clock_event_device clkevt = {
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.shift		= 32,
 	.rating		= 150,
-	.cpumask	= CPU_MASK_CPU0,
 	.set_next_event	= clkevt32k_next_event,
 	.set_mode	= clkevt32k_mode,
 };
@@ -206,7 +205,7 @@ void __init at91rm9200_timer_init(void)
 	clkevt.mult = div_sc(AT91_SLOW_CLOCK, NSEC_PER_SEC, clkevt.shift);
 	clkevt.max_delta_ns = clockevent_delta2ns(AT91_ST_ALMV, &clkevt);
 	clkevt.min_delta_ns = clockevent_delta2ns(2, &clkevt) + 1;
-	clkevt.cpumask = cpumask_of_cpu(0);
+	clkevt.cpumask = cpumask_of(0);
 	clockevents_register_device(&clkevt);
 
 	/* register clocksource */
diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
index 122fd77..b63e1d5 100644
--- a/arch/arm/mach-at91/at91sam926x_time.c
+++ b/arch/arm/mach-at91/at91sam926x_time.c
@@ -91,7 +91,6 @@ static struct clock_event_device pit_clkevt = {
 	.features	= CLOCK_EVT_FEAT_PERIODIC,
 	.shift		= 32,
 	.rating		= 100,
-	.cpumask	= CPU_MASK_CPU0,
 	.set_mode	= pit_clkevt_mode,
 };
 
@@ -173,6 +172,7 @@ static void __init at91sam926x_pit_init(void)
 
 	/* Set up and register clockevents */
 	pit_clkevt.mult = div_sc(pit_rate, NSEC_PER_SEC, pit_clkevt.shift);
+	pit_clkevt.cpumask = cpumask_of(0);
 	clockevents_register_device(&pit_clkevt);
 }
 
diff --git a/arch/arm/mach-davinci/time.c b/arch/arm/mach-davinci/time.c
index 3b9a296..f8bcd29 100644
--- a/arch/arm/mach-davinci/time.c
+++ b/arch/arm/mach-davinci/time.c
@@ -322,7 +322,7 @@ static void __init davinci_timer_init(void)
 	clockevent_davinci.min_delta_ns =
 		clockevent_delta2ns(1, &clockevent_davinci);
 
-	clockevent_davinci.cpumask = cpumask_of_cpu(0);
+	clockevent_davinci.cpumask = cpumask_of(0);
 	clockevents_register_device(&clockevent_davinci);
 }
 
diff --git a/arch/arm/mach-imx/time.c b/arch/arm/mach-imx/time.c
index a11765f..aff0ebc 100644
--- a/arch/arm/mach-imx/time.c
+++ b/arch/arm/mach-imx/time.c
@@ -184,7 +184,7 @@ static int __init imx_clockevent_init(unsigned long rate)
 	clockevent_imx.min_delta_ns =
 		clockevent_delta2ns(0xf, &clockevent_imx);
 
-	clockevent_imx.cpumask = cpumask_of_cpu(0);
+	clockevent_imx.cpumask = cpumask_of(0);
 
 	clockevents_register_device(&clockevent_imx);
 
diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index 7766f46..f4656d2 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -487,7 +487,7 @@ static int __init ixp4xx_clockevent_init(void)
 		clockevent_delta2ns(0xfffffffe, &clockevent_ixp4xx);
 	clockevent_ixp4xx.min_delta_ns =
 		clockevent_delta2ns(0xf, &clockevent_ixp4xx);
-	clockevent_ixp4xx.cpumask = cpumask_of_cpu(0);
+	clockevent_ixp4xx.cpumask = cpumask_of(0);
 
 	clockevents_register_device(&clockevent_ixp4xx);
 	return 0;
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 345a14c..444d9c0 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -182,7 +182,7 @@ static void __init msm_timer_init(void)
 			clockevent_delta2ns(0xf0000000 >> clock->shift, ce);
 		/* 4 gets rounded down to 3 */
 		ce->min_delta_ns = clockevent_delta2ns(4, ce);
-		ce->cpumask = cpumask_of_cpu(0);
+		ce->cpumask = cpumask_of(0);
 
 		cs->mult = clocksource_hz2mult(clock->freq, cs->shift);
 		res = clocksource_register(cs);
diff --git a/arch/arm/mach-ns9xxx/time-ns9360.c b/arch/arm/mach-ns9xxx/time-ns9360.c
index a63424d..41df697 100644
--- a/arch/arm/mach-ns9xxx/time-ns9360.c
+++ b/arch/arm/mach-ns9xxx/time-ns9360.c
@@ -173,7 +173,7 @@ static void __init ns9360_timer_init(void)
 	ns9360_clockevent_device.min_delta_ns =
 		clockevent_delta2ns(1, &ns9360_clockevent_device);
 
-	ns9360_clockevent_device.cpumask = cpumask_of_cpu(0);
+	ns9360_clockevent_device.cpumask = cpumask_of(0);
 	clockevents_register_device(&ns9360_clockevent_device);
 
 	setup_irq(IRQ_NS9360_TIMER0 + TIMER_CLOCKEVENT,
diff --git a/arch/arm/mach-omap1/time.c b/arch/arm/mach-omap1/time.c
index 2cf7e32..495a32c 100644
--- a/arch/arm/mach-omap1/time.c
+++ b/arch/arm/mach-omap1/time.c
@@ -173,7 +173,7 @@ static __init void omap_init_mpu_timer(unsigned long rate)
 	clockevent_mpu_timer1.min_delta_ns =
 		clockevent_delta2ns(1, &clockevent_mpu_timer1);
 
-	clockevent_mpu_timer1.cpumask = cpumask_of_cpu(0);
+	clockevent_mpu_timer1.cpumask = cpumask_of(0);
 	clockevents_register_device(&clockevent_mpu_timer1);
 }
 
diff --git a/arch/arm/mach-omap1/timer32k.c b/arch/arm/mach-omap1/timer32k.c
index 705367e..fd3f739 100644
--- a/arch/arm/mach-omap1/timer32k.c
+++ b/arch/arm/mach-omap1/timer32k.c
@@ -187,7 +187,7 @@ static __init void omap_init_32k_timer(void)
 	clockevent_32k_timer.min_delta_ns =
 		clockevent_delta2ns(1, &clockevent_32k_timer);
 
-	clockevent_32k_timer.cpumask = cpumask_of_cpu(0);
+	clockevent_32k_timer.cpumask = cpumask_of(0);
 	clockevents_register_device(&clockevent_32k_timer);
 }
 
diff --git a/arch/arm/mach-omap2/timer-gp.c b/arch/arm/mach-omap2/timer-gp.c
index 589393b..ae60363 100644
--- a/arch/arm/mach-omap2/timer-gp.c
+++ b/arch/arm/mach-omap2/timer-gp.c
@@ -120,7 +120,7 @@ static void __init omap2_gp_clockevent_init(void)
 	clockevent_gpt.min_delta_ns =
 		clockevent_delta2ns(1, &clockevent_gpt);
 
-	clockevent_gpt.cpumask = cpumask_of_cpu(0);
+	clockevent_gpt.cpumask = cpumask_of(0);
 	clockevents_register_device(&clockevent_gpt);
 }
 
diff --git a/arch/arm/mach-pxa/time.c b/arch/arm/mach-pxa/time.c
index 0016241..95656a7 100644
--- a/arch/arm/mach-pxa/time.c
+++ b/arch/arm/mach-pxa/time.c
@@ -122,7 +122,6 @@ static struct clock_event_device ckevt_pxa_osmr0 = {
 	.features	= CLOCK_EVT_FEAT_ONESHOT,
 	.shift		= 32,
 	.rating		= 200,
-	.cpumask	= CPU_MASK_CPU0,
 	.set_next_event	= pxa_osmr0_set_next_event,
 	.set_mode	= pxa_osmr0_set_mode,
 };
@@ -163,6 +162,7 @@ static void __init pxa_timer_init(void)
 		clockevent_delta2ns(0x7fffffff, &ckevt_pxa_osmr0);
 	ckevt_pxa_osmr0.min_delta_ns =
 		clockevent_delta2ns(MIN_OSCR_DELTA * 2, &ckevt_pxa_osmr0) + 1;
+	ckevt_pxa_osmr0.cpumask = cpumask_of(0);
 
 	cksrc_pxa_oscr0.mult =
 		clocksource_hz2mult(clock_tick_rate, cksrc_pxa_oscr0.shift);
diff --git a/arch/arm/mach-realview/core.c b/arch/arm/mach-realview/core.c
index 5f1d559..bd2aa4f 100644
--- a/arch/arm/mach-realview/core.c
+++ b/arch/arm/mach-realview/core.c
@@ -624,7 +624,7 @@ static struct clock_event_device timer0_clockevent =	 {
 	.set_mode	= timer_set_mode,
 	.set_next_event	= timer_set_next_event,
 	.rating		= 300,
-	.cpumask	= CPU_MASK_ALL,
+	.cpumask	= cpu_all_mask,
 };
 
 static void __init realview_clockevents_init(unsigned int timer_irq)
diff --git a/arch/arm/mach-realview/localtimer.c b/arch/arm/mach-realview/localtimer.c
index 9019ef2..67d6d9c 100644
--- a/arch/arm/mach-realview/localtimer.c
+++ b/arch/arm/mach-realview/localtimer.c
@@ -154,7 +154,7 @@ void __cpuinit local_timer_setup(void)
 	clk->set_mode		= local_timer_set_mode;
 	clk->set_next_event	= local_timer_set_next_event;
 	clk->irq		= IRQ_LOCALTIMER;
-	clk->cpumask		= cpumask_of_cpu(cpu);
+	clk->cpumask		= cpumask_of(cpu);
 	clk->shift		= 20;
 	clk->mult		= div_sc(mpcore_timer_rate, NSEC_PER_SEC, clk->shift);
 	clk->max_delta_ns	= clockevent_delta2ns(0xffffffff, clk);
@@ -193,7 +193,7 @@ void __cpuinit local_timer_setup(void)
 	clk->rating		= 200;
 	clk->set_mode		= dummy_timer_set_mode;
 	clk->broadcast		= smp_timer_broadcast;
-	clk->cpumask		= cpumask_of_cpu(cpu);
+	clk->cpumask		= cpumask_of(cpu);
 
 	clockevents_register_device(clk);
 }
diff --git a/arch/arm/mach-sa1100/time.c b/arch/arm/mach-sa1100/time.c
index 8c5e727..711c029 100644
--- a/arch/arm/mach-sa1100/time.c
+++ b/arch/arm/mach-sa1100/time.c
@@ -73,7 +73,6 @@ static struct clock_event_device ckevt_sa1100_osmr0 = {
 	.features	= CLOCK_EVT_FEAT_ONESHOT,
 	.shift		= 32,
 	.rating		= 200,
-	.cpumask	= CPU_MASK_CPU0,
 	.set_next_event	= sa1100_osmr0_set_next_event,
 	.set_mode	= sa1100_osmr0_set_mode,
 };
@@ -110,6 +109,7 @@ static void __init sa1100_timer_init(void)
 		clockevent_delta2ns(0x7fffffff, &ckevt_sa1100_osmr0);
 	ckevt_sa1100_osmr0.min_delta_ns =
 		clockevent_delta2ns(MIN_OSCR_DELTA * 2, &ckevt_sa1100_osmr0) + 1;
+	ckevt_sa1100_osmr0.cpumask = cpumask_of(0);
 
 	cksrc_sa1100_oscr.mult =
 		clocksource_hz2mult(CLOCK_TICK_RATE, cksrc_sa1100_oscr.shift);
diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index df25aa1..1c43494 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -1005,7 +1005,7 @@ static void __init versatile_timer_init(void)
 	timer0_clockevent.min_delta_ns =
 		clockevent_delta2ns(0xf, &timer0_clockevent);
 
-	timer0_clockevent.cpumask = cpumask_of_cpu(0);
+	timer0_clockevent.cpumask = cpumask_of(0);
 	clockevents_register_device(&timer0_clockevent);
 }
 
diff --git a/arch/arm/oprofile/op_model_mpcore.c b/arch/arm/oprofile/op_model_mpcore.c
index 4de366e..6d6bd58 100644
--- a/arch/arm/oprofile/op_model_mpcore.c
+++ b/arch/arm/oprofile/op_model_mpcore.c
@@ -260,10 +260,10 @@ static void em_stop(void)
 static void em_route_irq(int irq, unsigned int cpu)
 {
 	struct irq_desc *desc = irq_desc + irq;
-	cpumask_t mask = cpumask_of_cpu(cpu);
+	const struct cpumask *mask = cpumask_of(cpu);
 
 	spin_lock_irq(&desc->lock);
-	desc->affinity = mask;
+	desc->affinity = *mask;
 	desc->chip->set_affinity(irq, mask);
 	spin_unlock_irq(&desc->lock);
 }
diff --git a/arch/arm/plat-mxc/time.c b/arch/arm/plat-mxc/time.c
index fd28f51..758a129 100644
--- a/arch/arm/plat-mxc/time.c
+++ b/arch/arm/plat-mxc/time.c
@@ -190,7 +190,7 @@ static int __init mxc_clockevent_init(void)
 	clockevent_mxc.min_delta_ns =
 			clockevent_delta2ns(0xff, &clockevent_mxc);
 
-	clockevent_mxc.cpumask = cpumask_of_cpu(0);
+	clockevent_mxc.cpumask = cpumask_of(0);
 
 	clockevents_register_device(&clockevent_mxc);
 
diff --git a/arch/arm/plat-orion/time.c b/arch/arm/plat-orion/time.c
index 544d6b3..6fa2923 100644
--- a/arch/arm/plat-orion/time.c
+++ b/arch/arm/plat-orion/time.c
@@ -149,7 +149,6 @@ static struct clock_event_device orion_clkevt = {
 	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC,
 	.shift		= 32,
 	.rating		= 300,
-	.cpumask	= CPU_MASK_CPU0,
 	.set_next_event	= orion_clkevt_next_event,
 	.set_mode	= orion_clkevt_mode,
 };
@@ -199,5 +198,6 @@ void __init orion_time_init(unsigned int irq, unsigned int tclk)
 	orion_clkevt.mult = div_sc(tclk, NSEC_PER_SEC, orion_clkevt.shift);
 	orion_clkevt.max_delta_ns = clockevent_delta2ns(0xfffffffe, &orion_clkevt);
 	orion_clkevt.min_delta_ns = clockevent_delta2ns(1, &orion_clkevt);
+	orion_clkevt.cpumask = cpumask_of(0);
 	clockevents_register_device(&orion_clkevt);
 }
diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
index 283481d..0ff46bf 100644
--- a/arch/avr32/kernel/time.c
+++ b/arch/avr32/kernel/time.c
@@ -106,7 +106,6 @@ static struct clock_event_device comparator = {
 	.features	= CLOCK_EVT_FEAT_ONESHOT,
 	.shift		= 16,
 	.rating		= 50,
-	.cpumask	= CPU_MASK_CPU0,
 	.set_next_event	= comparator_next_event,
 	.set_mode	= comparator_mode,
 };
@@ -134,6 +133,7 @@ void __init time_init(void)
 	comparator.mult = div_sc(counter_hz, NSEC_PER_SEC, comparator.shift);
 	comparator.max_delta_ns = clockevent_delta2ns((u32)~0, &comparator);
 	comparator.min_delta_ns = clockevent_delta2ns(50, &comparator) + 1;
+	comparator.cpumask = cpumask_of(0);
 
 	sysreg_write(COMPARE, 0);
 	timer_irqaction.dev_id = &comparator;
diff --git a/arch/blackfin/kernel/time-ts.c b/arch/blackfin/kernel/time-ts.c
index e887efc..0ed2bad 100644
--- a/arch/blackfin/kernel/time-ts.c
+++ b/arch/blackfin/kernel/time-ts.c
@@ -162,7 +162,6 @@ static struct clock_event_device clockevent_bfin = {
 	.name		= "bfin_core_timer",
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.shift		= 32,
-	.cpumask	= CPU_MASK_CPU0,
 	.set_next_event = bfin_timer_set_next_event,
 	.set_mode	= bfin_timer_set_mode,
 };
@@ -193,6 +192,7 @@ static int __init bfin_clockevent_init(void)
 	clockevent_bfin.mult = div_sc(timer_clk, NSEC_PER_SEC, clockevent_bfin.shift);
 	clockevent_bfin.max_delta_ns = clockevent_delta2ns(-1, &clockevent_bfin);
 	clockevent_bfin.min_delta_ns = clockevent_delta2ns(100, &clockevent_bfin);
+	clockevent_bfin.cpumask = cpumask_of(0);
 	clockevents_register_device(&clockevent_bfin);
 
 	return 0;
diff --git a/arch/cris/arch-v32/kernel/irq.c b/arch/cris/arch-v32/kernel/irq.c
index 173c141..295131f 100644
--- a/arch/cris/arch-v32/kernel/irq.c
+++ b/arch/cris/arch-v32/kernel/irq.c
@@ -325,11 +325,11 @@ static void end_crisv32_irq(unsigned int irq)
 {
 }
 
-void set_affinity_crisv32_irq(unsigned int irq, cpumask_t dest)
+void set_affinity_crisv32_irq(unsigned int irq, const struct cpumask *dest)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&irq_lock, flags);
-	irq_allocations[irq - FIRST_IRQ].mask = dest;
+	irq_allocations[irq - FIRST_IRQ].mask = *dest;
 	spin_unlock_irqrestore(&irq_lock, flags);
 }
 
diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index 52e16c6..9dac173 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -29,11 +29,7 @@
 spinlock_t cris_atomic_locks[] = { [0 ... LOCK_COUNT - 1] = SPIN_LOCK_UNLOCKED};
 
 /* CPU masks */
-cpumask_t cpu_online_map = CPU_MASK_NONE;
-EXPORT_SYMBOL(cpu_online_map);
 cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
-cpumask_t cpu_possible_map;
-EXPORT_SYMBOL(cpu_possible_map);
 EXPORT_SYMBOL(phys_cpu_present_map);
 
 /* Variables used during SMP boot */
diff --git a/arch/cris/include/asm/smp.h b/arch/cris/include/asm/smp.h
index dba33ab..c615a06 100644
--- a/arch/cris/include/asm/smp.h
+++ b/arch/cris/include/asm/smp.h
@@ -4,7 +4,6 @@
 #include <linux/cpumask.h>
 
 extern cpumask_t phys_cpu_present_map;
-extern cpumask_t cpu_possible_map;
 
 #define raw_smp_processor_id() (current_thread_info()->cpu)
 
diff --git a/arch/ia64/hp/sim/hpsim_irq.c b/arch/ia64/hp/sim/hpsim_irq.c
index c2f58ff..cc0a318 100644
--- a/arch/ia64/hp/sim/hpsim_irq.c
+++ b/arch/ia64/hp/sim/hpsim_irq.c
@@ -22,7 +22,7 @@ hpsim_irq_noop (unsigned int irq)
 }
 
 static void
-hpsim_set_affinity_noop (unsigned int a, cpumask_t b)
+hpsim_set_affinity_noop(unsigned int a, const struct cpumask *b)
 {
 }
 
diff --git a/arch/ia64/include/asm/smp.h b/arch/ia64/include/asm/smp.h
index 12d96e0..21c4023 100644
--- a/arch/ia64/include/asm/smp.h
+++ b/arch/ia64/include/asm/smp.h
@@ -57,7 +57,6 @@ extern struct smp_boot_data {
 
 extern char no_int_routing __devinitdata;
 
-extern cpumask_t cpu_online_map;
 extern cpumask_t cpu_core_map[NR_CPUS];
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 extern int smp_num_siblings;
diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index 35bcb64..a3cc9f6 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -55,7 +55,6 @@
 void build_cpu_to_node_map(void);
 
 #define SD_CPU_INIT (struct sched_domain) {		\
-	.span			= CPU_MASK_NONE,	\
 	.parent			= NULL,			\
 	.child			= NULL,			\
 	.groups			= NULL,			\
@@ -80,7 +79,6 @@ void build_cpu_to_node_map(void);
 
 /* sched_domains SD_NODE_INIT for IA64 NUMA machines */
 #define SD_NODE_INIT (struct sched_domain) {		\
-	.span			= CPU_MASK_NONE,	\
 	.parent			= NULL,			\
 	.child			= NULL,			\
 	.groups			= NULL,			\
diff --git a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
index 5c4674a..c8adecd 100644
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -330,25 +330,25 @@ unmask_irq (unsigned int irq)
 
 
 static void
-iosapic_set_affinity (unsigned int irq, cpumask_t mask)
+iosapic_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 #ifdef CONFIG_SMP
 	u32 high32, low32;
-	int dest, rte_index;
+	int cpu, dest, rte_index;
 	int redir = (irq & IA64_IRQ_REDIRECTED) ? 1 : 0;
 	struct iosapic_rte_info *rte;
 	struct iosapic *iosapic;
 
 	irq &= (~IA64_IRQ_REDIRECTED);
 
-	cpus_and(mask, mask, cpu_online_map);
-	if (cpus_empty(mask))
+	cpu = cpumask_first_and(cpu_online_mask, mask);
+	if (cpu >= nr_cpu_ids)
 		return;
 
-	if (irq_prepare_move(irq, first_cpu(mask)))
+	if (irq_prepare_move(irq, cpu))
 		return;
 
-	dest = cpu_physical_id(first_cpu(mask));
+	dest = cpu_physical_id(cpu);
 
 	if (!iosapic_intr_info[irq].count)
 		return;			/* not an IOSAPIC interrupt */
diff --git a/arch/ia64/kernel/irq.c b/arch/ia64/kernel/irq.c
index 7fd18f5..0b6db53 100644
--- a/arch/ia64/kernel/irq.c
+++ b/arch/ia64/kernel/irq.c
@@ -133,7 +133,6 @@ unsigned int vectors_in_migration[NR_IRQS];
  */
 static void migrate_irqs(void)
 {
-	cpumask_t	mask;
 	irq_desc_t *desc;
 	int 		irq, new_cpu;
 
@@ -152,15 +151,14 @@ static void migrate_irqs(void)
 		if (desc->status == IRQ_PER_CPU)
 			continue;
 
-		cpus_and(mask, irq_desc[irq].affinity, cpu_online_map);
-		if (any_online_cpu(mask) == NR_CPUS) {
+		if (cpumask_any_and(&irq_desc[irq].affinity, cpu_online_mask)
+		    >= nr_cpu_ids) {
 			/*
 			 * Save it for phase 2 processing
 			 */
 			vectors_in_migration[irq] = irq;
 
 			new_cpu = any_online_cpu(cpu_online_map);
-			mask = cpumask_of_cpu(new_cpu);
 
 			/*
 			 * Al three are essential, currently WARN_ON.. maybe panic?
@@ -168,7 +166,8 @@ static void migrate_irqs(void)
 			if (desc->chip && desc->chip->disable &&
 				desc->chip->enable && desc->chip->set_affinity) {
 				desc->chip->disable(irq);
-				desc->chip->set_affinity(irq, mask);
+				desc->chip->set_affinity(irq,
+							 cpumask_of(new_cpu));
 				desc->chip->enable(irq);
 			} else {
 				WARN_ON((!(desc->chip) || !(desc->chip->disable) ||
diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index 702a09c..8903393 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -49,11 +49,12 @@
 static struct irq_chip	ia64_msi_chip;
 
 #ifdef CONFIG_SMP
-static void ia64_set_msi_irq_affinity(unsigned int irq, cpumask_t cpu_mask)
+static void ia64_set_msi_irq_affinity(unsigned int irq,
+				      const cpumask_t *cpu_mask)
 {
 	struct msi_msg msg;
 	u32 addr, data;
-	int cpu = first_cpu(cpu_mask);
+	int cpu = first_cpu(*cpu_mask);
 
 	if (!cpu_online(cpu))
 		return;
@@ -166,12 +167,11 @@ void arch_teardown_msi_irq(unsigned int irq)
 
 #ifdef CONFIG_DMAR
 #ifdef CONFIG_SMP
-static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
+static void dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg = irq_cfg + irq;
 	struct msi_msg msg;
-	int cpu = first_cpu(mask);
-
+	int cpu = cpumask_first(mask);
 
 	if (!cpu_online(cpu))
 		return;
@@ -187,7 +187,7 @@ static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
 	msg.address_lo |= MSI_ADDR_DESTID_CPU(cpu_physical_id(cpu));
 
 	dmar_msi_write(irq, &msg);
-	irq_desc[irq].affinity = mask;
+	irq_desc[irq].affinity = *mask;
 }
 #endif /* CONFIG_SMP */
 
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index 1dcbb85..1146399 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -131,12 +131,6 @@ struct task_struct *task_for_booting_cpu;
  */
 DEFINE_PER_CPU(int, cpu_state);
 
-/* Bitmasks of currently online, and possible CPUs */
-cpumask_t cpu_online_map;
-EXPORT_SYMBOL(cpu_online_map);
-cpumask_t cpu_possible_map = CPU_MASK_NONE;
-EXPORT_SYMBOL(cpu_possible_map);
-
 cpumask_t cpu_core_map[NR_CPUS] __cacheline_aligned;
 EXPORT_SYMBOL(cpu_core_map);
 DEFINE_PER_CPU_SHARED_ALIGNED(cpumask_t, cpu_sibling_map);
@@ -688,7 +682,7 @@ int migrate_platform_irqs(unsigned int cpu)
 {
 	int new_cpei_cpu;
 	irq_desc_t *desc = NULL;
-	cpumask_t 	mask;
+	const struct cpumask *mask;
 	int 		retval = 0;
 
 	/*
@@ -701,7 +695,7 @@ int migrate_platform_irqs(unsigned int cpu)
 			 * Now re-target the CPEI to a different processor
 			 */
 			new_cpei_cpu = any_online_cpu(cpu_online_map);
-			mask = cpumask_of_cpu(new_cpei_cpu);
+			mask = cpumask_of(new_cpei_cpu);
 			set_cpei_target_cpu(new_cpei_cpu);
 			desc = irq_desc + ia64_cpe_irq;
 			/*
diff --git a/arch/ia64/kernel/topology.c b/arch/ia64/kernel/topology.c
index c75b914..a8d61a3 100644
--- a/arch/ia64/kernel/topology.c
+++ b/arch/ia64/kernel/topology.c
@@ -219,7 +219,7 @@ static ssize_t show_shared_cpu_map(struct cache_info *this_leaf, char *buf)
 	cpumask_t shared_cpu_map;
 
 	cpus_and(shared_cpu_map, this_leaf->shared_cpu_map, cpu_online_map);
-	len = cpumask_scnprintf(buf, NR_CPUS+1, shared_cpu_map);
+	len = cpumask_scnprintf(buf, NR_CPUS+1, &shared_cpu_map);
 	len += sprintf(buf+len, "\n");
 	return len;
 }
diff --git a/arch/ia64/sn/kernel/irq.c b/arch/ia64/sn/kernel/irq.c
index 0c66dbd..66fd705 100644
--- a/arch/ia64/sn/kernel/irq.c
+++ b/arch/ia64/sn/kernel/irq.c
@@ -227,14 +227,14 @@ finish_up:
 	return new_irq_info;
 }
 
-static void sn_set_affinity_irq(unsigned int irq, cpumask_t mask)
+static void sn_set_affinity_irq(unsigned int irq, const struct cpumask *mask)
 {
 	struct sn_irq_info *sn_irq_info, *sn_irq_info_safe;
 	nasid_t nasid;
 	int slice;
 
-	nasid = cpuid_to_nasid(first_cpu(mask));
-	slice = cpuid_to_slice(first_cpu(mask));
+	nasid = cpuid_to_nasid(cpumask_first(mask));
+	slice = cpuid_to_slice(cpumask_first(mask));
 
 	list_for_each_entry_safe(sn_irq_info, sn_irq_info_safe,
 				 sn_irq_lh[irq], list)
diff --git a/arch/ia64/sn/kernel/msi_sn.c b/arch/ia64/sn/kernel/msi_sn.c
index 83f190f..ca553b0 100644
--- a/arch/ia64/sn/kernel/msi_sn.c
+++ b/arch/ia64/sn/kernel/msi_sn.c
@@ -151,7 +151,8 @@ int sn_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *entry)
 }
 
 #ifdef CONFIG_SMP
-static void sn_set_msi_irq_affinity(unsigned int irq, cpumask_t cpu_mask)
+static void sn_set_msi_irq_affinity(unsigned int irq,
+				    const struct cpumask *cpu_mask)
 {
 	struct msi_msg msg;
 	int slice;
@@ -164,7 +165,7 @@ static void sn_set_msi_irq_affinity(unsigned int irq, cpumask_t cpu_mask)
 	struct sn_pcibus_provider *provider;
 	unsigned int cpu;
 
-	cpu = first_cpu(cpu_mask);
+	cpu = cpumask_first(cpu_mask);
 	sn_irq_info = sn_msi_info[irq].sn_irq_info;
 	if (sn_irq_info == NULL || sn_irq_info->irq_int_bit >= 0)
 		return;
@@ -204,7 +205,7 @@ static void sn_set_msi_irq_affinity(unsigned int irq, cpumask_t cpu_mask)
 	msg.address_lo = (u32)(bus_addr & 0x00000000ffffffff);
 
 	write_msi_msg(irq, &msg);
-	irq_desc[irq].affinity = cpu_mask;
+	irq_desc[irq].affinity = *cpu_mask;
 }
 #endif /* CONFIG_SMP */
 
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 29047d5..cabba33 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -10,6 +10,7 @@ config M32R
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select INIT_ALL_POSSIBLE
 
 config SBUS
 	bool
diff --git a/arch/m32r/kernel/smpboot.c b/arch/m32r/kernel/smpboot.c
index 39cb6da..0f06b37 100644
--- a/arch/m32r/kernel/smpboot.c
+++ b/arch/m32r/kernel/smpboot.c
@@ -73,17 +73,11 @@ static unsigned int bsp_phys_id = -1;
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map;
 
-/* Bitmask of currently online CPUs */
-cpumask_t cpu_online_map;
-EXPORT_SYMBOL(cpu_online_map);
-
 cpumask_t cpu_bootout_map;
 cpumask_t cpu_bootin_map;
 static cpumask_t cpu_callin_map;
 cpumask_t cpu_callout_map;
 EXPORT_SYMBOL(cpu_callout_map);
-cpumask_t cpu_possible_map = CPU_MASK_ALL;
-EXPORT_SYMBOL(cpu_possible_map);
 
 /* Per CPU bogomips and other parameters */
 struct cpuinfo_m32r cpu_data[NR_CPUS] __cacheline_aligned;
diff --git a/arch/m68knommu/platform/coldfire/pit.c b/arch/m68knommu/platform/coldfire/pit.c
index c5b9167..2a12e7f 100644
--- a/arch/m68knommu/platform/coldfire/pit.c
+++ b/arch/m68knommu/platform/coldfire/pit.c
@@ -156,7 +156,7 @@ void hw_timer_init(void)
 {
 	u32 imr;
 
-	cf_pit_clockevent.cpumask = cpumask_of_cpu(smp_processor_id());
+	cf_pit_clockevent.cpumask = cpumask_of(smp_processor_id());
 	cf_pit_clockevent.mult = div_sc(FREQ, NSEC_PER_SEC, 32);
 	cf_pit_clockevent.max_delta_ns =
 		clockevent_delta2ns(0xFFFF, &cf_pit_clockevent);
diff --git a/arch/mips/include/asm/irq.h b/arch/mips/include/asm/irq.h
index a58f0ee..abc62aa 100644
--- a/arch/mips/include/asm/irq.h
+++ b/arch/mips/include/asm/irq.h
@@ -49,7 +49,8 @@ static inline void smtc_im_ack_irq(unsigned int irq)
 #ifdef CONFIG_MIPS_MT_SMTC_IRQAFF
 #include <linux/cpumask.h>
 
-extern void plat_set_irq_affinity(unsigned int irq, cpumask_t affinity);
+extern void plat_set_irq_affinity(unsigned int irq,
+				  const struct cpumask *affinity);
 extern void smtc_forward_irq(unsigned int irq);
 
 /*
diff --git a/arch/mips/include/asm/mach-ip27/topology.h b/arch/mips/include/asm/mach-ip27/topology.h
index 7785bec..1fb959f 100644
--- a/arch/mips/include/asm/mach-ip27/topology.h
+++ b/arch/mips/include/asm/mach-ip27/topology.h
@@ -37,7 +37,6 @@ extern unsigned char __node_distances[MAX_COMPACT_NODES][MAX_COMPACT_NODES];
 
 /* sched_domains SD_NODE_INIT for SGI IP27 machines */
 #define SD_NODE_INIT (struct sched_domain) {		\
-	.span			= CPU_MASK_NONE,	\
 	.parent			= NULL,			\
 	.child			= NULL,			\
 	.groups			= NULL,			\
diff --git a/arch/mips/include/asm/smp.h b/arch/mips/include/asm/smp.h
index 0ff5b52..86557b5 100644
--- a/arch/mips/include/asm/smp.h
+++ b/arch/mips/include/asm/smp.h
@@ -38,9 +38,6 @@ extern int __cpu_logical_map[NR_CPUS];
 #define SMP_RESCHEDULE_YOURSELF	0x1	/* XXX braindead */
 #define SMP_CALL_FUNCTION	0x2
 
-extern cpumask_t phys_cpu_present_map;
-#define cpu_possible_map	phys_cpu_present_map
-
 extern void asmlinkage smp_bootstrap(void);
 
 /*
diff --git a/arch/mips/jazz/irq.c b/arch/mips/jazz/irq.c
index d7f8a78..03965cb 100644
--- a/arch/mips/jazz/irq.c
+++ b/arch/mips/jazz/irq.c
@@ -146,7 +146,7 @@ void __init plat_time_init(void)
 
 	BUG_ON(HZ != 100);
 
-	cd->cpumask             = cpumask_of_cpu(cpu);
+	cd->cpumask             = cpumask_of(cpu);
 	clockevents_register_device(cd);
 	action->dev_id = cd;
 	setup_irq(JAZZ_TIMER_IRQ, action);
diff --git a/arch/mips/kernel/cevt-bcm1480.c b/arch/mips/kernel/cevt-bcm1480.c
index 0a57f86..b820661 100644
--- a/arch/mips/kernel/cevt-bcm1480.c
+++ b/arch/mips/kernel/cevt-bcm1480.c
@@ -126,7 +126,7 @@ void __cpuinit sb1480_clockevent_init(void)
 	cd->min_delta_ns	= clockevent_delta2ns(2, cd);
 	cd->rating		= 200;
 	cd->irq			= irq;
-	cd->cpumask		= cpumask_of_cpu(cpu);
+	cd->cpumask		= cpumask_of(cpu);
 	cd->set_next_event	= sibyte_next_event;
 	cd->set_mode		= sibyte_set_mode;
 	clockevents_register_device(cd);
@@ -148,6 +148,6 @@ void __cpuinit sb1480_clockevent_init(void)
 	action->name	= name;
 	action->dev_id	= cd;
 
-	irq_set_affinity(irq, cpumask_of_cpu(cpu));
+	irq_set_affinity(irq, cpumask_of(cpu));
 	setup_irq(irq, action);
 }
diff --git a/arch/mips/kernel/cevt-ds1287.c b/arch/mips/kernel/cevt-ds1287.c
index df4acb6..1ada45e 100644
--- a/arch/mips/kernel/cevt-ds1287.c
+++ b/arch/mips/kernel/cevt-ds1287.c
@@ -88,7 +88,6 @@ static void ds1287_event_handler(struct clock_event_device *dev)
 static struct clock_event_device ds1287_clockevent = {
 	.name		= "ds1287",
 	.features	= CLOCK_EVT_FEAT_PERIODIC,
-	.cpumask	= CPU_MASK_CPU0,
 	.set_next_event	= ds1287_set_next_event,
 	.set_mode	= ds1287_set_mode,
 	.event_handler	= ds1287_event_handler,
@@ -122,6 +121,7 @@ int __init ds1287_clockevent_init(int irq)
 	clockevent_set_clock(cd, 32768);
 	cd->max_delta_ns = clockevent_delta2ns(0x7fffffff, cd);
 	cd->min_delta_ns = clockevent_delta2ns(0x300, cd);
+	cd->cpumask = cpumask_of(0);
 
 	clockevents_register_device(&ds1287_clockevent);
 
diff --git a/arch/mips/kernel/cevt-gt641xx.c b/arch/mips/kernel/cevt-gt641xx.c
index 6e2f585..e9b787f 100644
--- a/arch/mips/kernel/cevt-gt641xx.c
+++ b/arch/mips/kernel/cevt-gt641xx.c
@@ -96,7 +96,6 @@ static void gt641xx_timer0_event_handler(struct clock_event_device *dev)
 static struct clock_event_device gt641xx_timer0_clockevent = {
 	.name		= "gt641xx-timer0",
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.cpumask	= CPU_MASK_CPU0,
 	.irq		= GT641XX_TIMER0_IRQ,
 	.set_next_event	= gt641xx_timer0_set_next_event,
 	.set_mode	= gt641xx_timer0_set_mode,
@@ -132,6 +131,7 @@ static int __init gt641xx_timer0_clockevent_init(void)
 	clockevent_set_clock(cd, gt641xx_base_clock);
 	cd->max_delta_ns = clockevent_delta2ns(0x7fffffff, cd);
 	cd->min_delta_ns = clockevent_delta2ns(0x300, cd);
+	cd->cpumask = cpumask_of(0);
 
 	clockevents_register_device(&gt641xx_timer0_clockevent);
 
diff --git a/arch/mips/kernel/cevt-r4k.c b/arch/mips/kernel/cevt-r4k.c
index 4a4c59f..e1ec83b 100644
--- a/arch/mips/kernel/cevt-r4k.c
+++ b/arch/mips/kernel/cevt-r4k.c
@@ -195,7 +195,7 @@ int __cpuinit mips_clockevent_init(void)
 
 	cd->rating		= 300;
 	cd->irq			= irq;
-	cd->cpumask		= cpumask_of_cpu(cpu);
+	cd->cpumask		= cpumask_of(cpu);
 	cd->set_next_event	= mips_next_event;
 	cd->set_mode		= mips_set_clock_mode;
 	cd->event_handler	= mips_event_handler;
diff --git a/arch/mips/kernel/cevt-sb1250.c b/arch/mips/kernel/cevt-sb1250.c
index 63ac3ad..a2eebaa 100644
--- a/arch/mips/kernel/cevt-sb1250.c
+++ b/arch/mips/kernel/cevt-sb1250.c
@@ -125,7 +125,7 @@ void __cpuinit sb1250_clockevent_init(void)
 	cd->min_delta_ns	= clockevent_delta2ns(2, cd);
 	cd->rating		= 200;
 	cd->irq			= irq;
-	cd->cpumask		= cpumask_of_cpu(cpu);
+	cd->cpumask		= cpumask_of(cpu);
 	cd->set_next_event	= sibyte_next_event;
 	cd->set_mode		= sibyte_set_mode;
 	clockevents_register_device(cd);
@@ -147,6 +147,6 @@ void __cpuinit sb1250_clockevent_init(void)
 	action->name	= name;
 	action->dev_id	= cd;
 
-	irq_set_affinity(irq, cpumask_of_cpu(cpu));
+	irq_set_affinity(irq, cpumask_of(cpu));
 	setup_irq(irq, action);
 }
diff --git a/arch/mips/kernel/cevt-smtc.c b/arch/mips/kernel/cevt-smtc.c
index 5162fe4..6d45e24 100644
--- a/arch/mips/kernel/cevt-smtc.c
+++ b/arch/mips/kernel/cevt-smtc.c
@@ -292,7 +292,7 @@ int __cpuinit mips_clockevent_init(void)
 
 	cd->rating		= 300;
 	cd->irq			= irq;
-	cd->cpumask		= cpumask_of_cpu(cpu);
+	cd->cpumask		= cpumask_of(cpu);
 	cd->set_next_event	= mips_next_event;
 	cd->set_mode		= mips_set_clock_mode;
 	cd->event_handler	= mips_event_handler;
diff --git a/arch/mips/kernel/cevt-txx9.c b/arch/mips/kernel/cevt-txx9.c
index b5fc4eb..eccf7d6 100644
--- a/arch/mips/kernel/cevt-txx9.c
+++ b/arch/mips/kernel/cevt-txx9.c
@@ -112,7 +112,6 @@ static struct clock_event_device txx9tmr_clock_event_device = {
 	.name		= "TXx9",
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.rating		= 200,
-	.cpumask	= CPU_MASK_CPU0,
 	.set_mode	= txx9tmr_set_mode,
 	.set_next_event	= txx9tmr_set_next_event,
 };
@@ -150,6 +149,7 @@ void __init txx9_clockevent_init(unsigned long baseaddr, int irq,
 		clockevent_delta2ns(0xffffffff >> (32 - TXX9_TIMER_BITS), cd);
 	cd->min_delta_ns = clockevent_delta2ns(0xf, cd);
 	cd->irq = irq;
+	cd->cpumask = cpumask_of(0),
 	clockevents_register_device(cd);
 	setup_irq(irq, &txx9tmr_irq);
 	printk(KERN_INFO "TXx9: clockevent device at 0x%lx, irq %d\n",
diff --git a/arch/mips/kernel/i8253.c b/arch/mips/kernel/i8253.c
index b6ac551..f4d1878 100644
--- a/arch/mips/kernel/i8253.c
+++ b/arch/mips/kernel/i8253.c
@@ -115,7 +115,7 @@ void __init setup_pit_timer(void)
 	 * Start pit with the boot cpu mask and make it global after the
 	 * IO_APIC has been initialized.
 	 */
-	cd->cpumask = cpumask_of_cpu(cpu);
+	cd->cpumask = cpumask_of(cpu);
 	clockevent_set_clock(cd, CLOCK_TICK_RATE);
 	cd->max_delta_ns = clockevent_delta2ns(0x7FFF, cd);
 	cd->min_delta_ns = clockevent_delta2ns(0xF, cd);
diff --git a/arch/mips/kernel/irq-gic.c b/arch/mips/kernel/irq-gic.c
index f0a4bb1..494a49a 100644
--- a/arch/mips/kernel/irq-gic.c
+++ b/arch/mips/kernel/irq-gic.c
@@ -155,7 +155,7 @@ static void gic_unmask_irq(unsigned int irq)
 
 static DEFINE_SPINLOCK(gic_lock);
 
-static void gic_set_affinity(unsigned int irq, cpumask_t cpumask)
+static void gic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 {
 	cpumask_t	tmp = CPU_MASK_NONE;
 	unsigned long	flags;
@@ -164,7 +164,7 @@ static void gic_set_affinity(unsigned int irq, cpumask_t cpumask)
 	pr_debug(KERN_DEBUG "%s called\n", __func__);
 	irq -= _irqbase;
 
-	cpus_and(tmp, cpumask, cpu_online_map);
+	cpumask_and(&tmp, cpumask, cpu_online_mask);
 	if (cpus_empty(tmp))
 		return;
 
@@ -187,7 +187,7 @@ static void gic_set_affinity(unsigned int irq, cpumask_t cpumask)
 		set_bit(irq, pcpu_masks[first_cpu(tmp)].pcpu_mask);
 
 	}
-	irq_desc[irq].affinity = cpumask;
+	irq_desc[irq].affinity = *cpumask;
 	spin_unlock_irqrestore(&gic_lock, flags);
 
 }
diff --git a/arch/mips/kernel/smp-cmp.c b/arch/mips/kernel/smp-cmp.c
index ca476c4..f27beca 100644
--- a/arch/mips/kernel/smp-cmp.c
+++ b/arch/mips/kernel/smp-cmp.c
@@ -51,10 +51,10 @@ static int __init allowcpus(char *str)
 	int len;
 
 	cpus_clear(cpu_allow_map);
-	if (cpulist_parse(str, cpu_allow_map) == 0) {
+	if (cpulist_parse(str, &cpu_allow_map) == 0) {
 		cpu_set(0, cpu_allow_map);
 		cpus_and(cpu_possible_map, cpu_possible_map, cpu_allow_map);
-		len = cpulist_scnprintf(buf, sizeof(buf)-1, cpu_possible_map);
+		len = cpulist_scnprintf(buf, sizeof(buf)-1, &cpu_possible_map);
 		buf[len] = '\0';
 		pr_debug("Allowable CPUs: %s\n", buf);
 		return 1;
@@ -226,7 +226,7 @@ void __init cmp_smp_setup(void)
 
 	for (i = 1; i < NR_CPUS; i++) {
 		if (amon_cpu_avail(i)) {
-			cpu_set(i, phys_cpu_present_map);
+			cpu_set(i, cpu_possible_map);
 			__cpu_number_map[i]	= ++ncpu;
 			__cpu_logical_map[ncpu]	= i;
 		}
diff --git a/arch/mips/kernel/smp-mt.c b/arch/mips/kernel/smp-mt.c
index 87a1816..6f7ee5a 100644
--- a/arch/mips/kernel/smp-mt.c
+++ b/arch/mips/kernel/smp-mt.c
@@ -70,7 +70,7 @@ static unsigned int __init smvp_vpe_init(unsigned int tc, unsigned int mvpconf0,
 		write_vpe_c0_vpeconf0(tmp);
 
 		/* Record this as available CPU */
-		cpu_set(tc, phys_cpu_present_map);
+		cpu_set(tc, cpu_possible_map);
 		__cpu_number_map[tc]	= ++ncpu;
 		__cpu_logical_map[ncpu]	= tc;
 	}
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 8bf88fa..3da9470 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -44,15 +44,10 @@
 #include <asm/mipsmtregs.h>
 #endif /* CONFIG_MIPS_MT_SMTC */
 
-cpumask_t phys_cpu_present_map;		/* Bitmask of available CPUs */
 volatile cpumask_t cpu_callin_map;	/* Bitmask of started secondaries */
-cpumask_t cpu_online_map;		/* Bitmask of currently online CPUs */
 int __cpu_number_map[NR_CPUS];		/* Map physical to logical */
 int __cpu_logical_map[NR_CPUS];		/* Map logical to physical */
 
-EXPORT_SYMBOL(phys_cpu_present_map);
-EXPORT_SYMBOL(cpu_online_map);
-
 extern void cpu_idle(void);
 
 /* Number of TCs (or siblings in Intel speak) per CPU core */
@@ -195,7 +190,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 /* preload SMP state for boot cpu */
 void __devinit smp_prepare_boot_cpu(void)
 {
-	cpu_set(0, phys_cpu_present_map);
+	cpu_set(0, cpu_possible_map);
 	cpu_set(0, cpu_online_map);
 	cpu_set(0, cpu_callin_map);
 }
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index 897fb2b..b6cca01 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -290,7 +290,7 @@ static void smtc_configure_tlb(void)
  * possibly leave some TCs/VPEs as "slave" processors.
  *
  * Use c0_MVPConf0 to find out how many TCs are available, setting up
- * phys_cpu_present_map and the logical/physical mappings.
+ * cpu_possible_map and the logical/physical mappings.
  */
 
 int __init smtc_build_cpu_map(int start_cpu_slot)
@@ -304,7 +304,7 @@ int __init smtc_build_cpu_map(int start_cpu_slot)
 	 */
 	ntcs = ((read_c0_mvpconf0() & MVPCONF0_PTC) >> MVPCONF0_PTC_SHIFT) + 1;
 	for (i=start_cpu_slot; i<NR_CPUS && i<ntcs; i++) {
-		cpu_set(i, phys_cpu_present_map);
+		cpu_set(i, cpu_possible_map);
 		__cpu_number_map[i] = i;
 		__cpu_logical_map[i] = i;
 	}
@@ -521,7 +521,7 @@ void smtc_prepare_cpus(int cpus)
 	 * Pull any physically present but unused TCs out of circulation.
 	 */
 	while (tc < (((val & MVPCONF0_PTC) >> MVPCONF0_PTC_SHIFT) + 1)) {
-		cpu_clear(tc, phys_cpu_present_map);
+		cpu_clear(tc, cpu_possible_map);
 		cpu_clear(tc, cpu_present_map);
 		tc++;
 	}
diff --git a/arch/mips/mti-malta/malta-smtc.c b/arch/mips/mti-malta/malta-smtc.c
index f84a46a..aabd727 100644
--- a/arch/mips/mti-malta/malta-smtc.c
+++ b/arch/mips/mti-malta/malta-smtc.c
@@ -114,9 +114,9 @@ struct plat_smp_ops msmtc_smp_ops = {
  */
 
 
-void plat_set_irq_affinity(unsigned int irq, cpumask_t affinity)
+void plat_set_irq_affinity(unsigned int irq, const struct cpumask *affinity)
 {
-	cpumask_t tmask = affinity;
+	cpumask_t tmask = *affinity;
 	int cpu = 0;
 	void smtc_set_irq_affinity(unsigned int irq, cpumask_t aff);
 
@@ -139,7 +139,7 @@ void plat_set_irq_affinity(unsigned int irq, cpumask_t affinity)
 	 * be made to forward to an offline "CPU".
 	 */
 
-	for_each_cpu_mask(cpu, affinity) {
+	for_each_cpu(cpu, affinity) {
 		if ((cpu_data[cpu].vpe_id != 0) || !cpu_online(cpu))
 			cpu_clear(cpu, tmask);
 	}
diff --git a/arch/mips/nxp/pnx8550/common/time.c b/arch/mips/nxp/pnx8550/common/time.c
index 62f495b..cf293b2 100644
--- a/arch/mips/nxp/pnx8550/common/time.c
+++ b/arch/mips/nxp/pnx8550/common/time.c
@@ -102,6 +102,7 @@ __init void plat_time_init(void)
 	unsigned int p;
 	unsigned int pow2p;
 
+	pnx8xxx_clockevent.cpumask = cpu_none_mask;
 	clockevents_register_device(&pnx8xxx_clockevent);
 	clocksource_register(&pnx_clocksource);
 
diff --git a/arch/mips/pmc-sierra/yosemite/smp.c b/arch/mips/pmc-sierra/yosemite/smp.c
index 3a7df64..f78c29b 100644
--- a/arch/mips/pmc-sierra/yosemite/smp.c
+++ b/arch/mips/pmc-sierra/yosemite/smp.c
@@ -141,7 +141,7 @@ static void __cpuinit yos_boot_secondary(int cpu, struct task_struct *idle)
 }
 
 /*
- * Detect available CPUs, populate phys_cpu_present_map before smp_init
+ * Detect available CPUs, populate cpu_possible_map before smp_init
  *
  * We don't want to start the secondary CPU yet nor do we have a nice probing
  * feature in PMON so we just assume presence of the secondary core.
@@ -150,10 +150,10 @@ static void __init yos_smp_setup(void)
 {
 	int i;
 
-	cpus_clear(phys_cpu_present_map);
+	cpus_clear(cpu_possible_map);
 
 	for (i = 0; i < 2; i++) {
-		cpu_set(i, phys_cpu_present_map);
+		cpu_set(i, cpu_possible_map);
 		__cpu_number_map[i]	= i;
 		__cpu_logical_map[i]	= i;
 	}
diff --git a/arch/mips/sgi-ip27/ip27-smp.c b/arch/mips/sgi-ip27/ip27-smp.c
index ba5cdeb..5b47d6b 100644
--- a/arch/mips/sgi-ip27/ip27-smp.c
+++ b/arch/mips/sgi-ip27/ip27-smp.c
@@ -76,7 +76,7 @@ static int do_cpumask(cnodeid_t cnode, nasid_t nasid, int highest)
 			/* Only let it join in if it's marked enabled */
 			if ((acpu->cpu_info.flags & KLINFO_ENABLE) &&
 			    (tot_cpus_found != NR_CPUS)) {
-				cpu_set(cpuid, phys_cpu_present_map);
+				cpu_set(cpuid, cpu_possible_map);
 				alloc_cpupda(cpuid, tot_cpus_found);
 				cpus_found++;
 				tot_cpus_found++;
diff --git a/arch/mips/sgi-ip27/ip27-timer.c b/arch/mips/sgi-ip27/ip27-timer.c
index 1327c27..f024057 100644
--- a/arch/mips/sgi-ip27/ip27-timer.c
+++ b/arch/mips/sgi-ip27/ip27-timer.c
@@ -134,7 +134,7 @@ void __cpuinit hub_rt_clock_event_init(void)
 	cd->min_delta_ns        = clockevent_delta2ns(0x300, cd);
 	cd->rating		= 200;
 	cd->irq			= irq;
-	cd->cpumask		= cpumask_of_cpu(cpu);
+	cd->cpumask		= cpumask_of(cpu);
 	cd->set_next_event	= rt_next_event;
 	cd->set_mode		= rt_set_mode;
 	clockevents_register_device(cd);
diff --git a/arch/mips/sibyte/bcm1480/irq.c b/arch/mips/sibyte/bcm1480/irq.c
index a35818e..12b465d 100644
--- a/arch/mips/sibyte/bcm1480/irq.c
+++ b/arch/mips/sibyte/bcm1480/irq.c
@@ -50,7 +50,7 @@ static void enable_bcm1480_irq(unsigned int irq);
 static void disable_bcm1480_irq(unsigned int irq);
 static void ack_bcm1480_irq(unsigned int irq);
 #ifdef CONFIG_SMP
-static void bcm1480_set_affinity(unsigned int irq, cpumask_t mask);
+static void bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask);
 #endif
 
 #ifdef CONFIG_PCI
@@ -109,7 +109,7 @@ void bcm1480_unmask_irq(int cpu, int irq)
 }
 
 #ifdef CONFIG_SMP
-static void bcm1480_set_affinity(unsigned int irq, cpumask_t mask)
+static void bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	int i = 0, old_cpu, cpu, int_on, k;
 	u64 cur_ints;
@@ -117,11 +117,11 @@ static void bcm1480_set_affinity(unsigned int irq, cpumask_t mask)
 	unsigned long flags;
 	unsigned int irq_dirty;
 
-	if (cpus_weight(mask) != 1) {
+	if (cpumask_weight(mask) != 1) {
 		printk("attempted to set irq affinity for irq %d to multiple CPUs\n", irq);
 		return;
 	}
-	i = first_cpu(mask);
+	i = cpumask_first(mask);
 
 	/* Convert logical CPU to physical CPU */
 	cpu = cpu_logical_map(i);
diff --git a/arch/mips/sibyte/bcm1480/smp.c b/arch/mips/sibyte/bcm1480/smp.c
index bd9eeb4..dddfda8 100644
--- a/arch/mips/sibyte/bcm1480/smp.c
+++ b/arch/mips/sibyte/bcm1480/smp.c
@@ -136,7 +136,7 @@ static void __cpuinit bcm1480_boot_secondary(int cpu, struct task_struct *idle)
 
 /*
  * Use CFE to find out how many CPUs are available, setting up
- * phys_cpu_present_map and the logical/physical mappings.
+ * cpu_possible_map and the logical/physical mappings.
  * XXXKW will the boot CPU ever not be physical 0?
  *
  * Common setup before any secondaries are started
@@ -145,14 +145,14 @@ static void __init bcm1480_smp_setup(void)
 {
 	int i, num;
 
-	cpus_clear(phys_cpu_present_map);
-	cpu_set(0, phys_cpu_present_map);
+	cpus_clear(cpu_possible_map);
+	cpu_set(0, cpu_possible_map);
 	__cpu_number_map[0] = 0;
 	__cpu_logical_map[0] = 0;
 
 	for (i = 1, num = 0; i < NR_CPUS; i++) {
 		if (cfe_cpu_stop(i) == 0) {
-			cpu_set(i, phys_cpu_present_map);
+			cpu_set(i, cpu_possible_map);
 			__cpu_number_map[i] = ++num;
 			__cpu_logical_map[num] = i;
 		}
diff --git a/arch/mips/sibyte/sb1250/irq.c b/arch/mips/sibyte/sb1250/irq.c
index a515848..808ac29 100644
--- a/arch/mips/sibyte/sb1250/irq.c
+++ b/arch/mips/sibyte/sb1250/irq.c
@@ -50,7 +50,7 @@ static void enable_sb1250_irq(unsigned int irq);
 static void disable_sb1250_irq(unsigned int irq);
 static void ack_sb1250_irq(unsigned int irq);
 #ifdef CONFIG_SMP
-static void sb1250_set_affinity(unsigned int irq, cpumask_t mask);
+static void sb1250_set_affinity(unsigned int irq, const struct cpumask *mask);
 #endif
 
 #ifdef CONFIG_SIBYTE_HAS_LDT
@@ -103,16 +103,16 @@ void sb1250_unmask_irq(int cpu, int irq)
 }
 
 #ifdef CONFIG_SMP
-static void sb1250_set_affinity(unsigned int irq, cpumask_t mask)
+static void sb1250_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	int i = 0, old_cpu, cpu, int_on;
 	u64 cur_ints;
 	struct irq_desc *desc = irq_desc + irq;
 	unsigned long flags;
 
-	i = first_cpu(mask);
+	i = cpumask_first(mask);
 
-	if (cpus_weight(mask) > 1) {
+	if (cpumask_weight(mask) > 1) {
 		printk("attempted to set irq affinity for irq %d to multiple CPUs\n", irq);
 		return;
 	}
diff --git a/arch/mips/sibyte/sb1250/smp.c b/arch/mips/sibyte/sb1250/smp.c
index 0734b93..5950a28 100644
--- a/arch/mips/sibyte/sb1250/smp.c
+++ b/arch/mips/sibyte/sb1250/smp.c
@@ -124,7 +124,7 @@ static void __cpuinit sb1250_boot_secondary(int cpu, struct task_struct *idle)
 
 /*
  * Use CFE to find out how many CPUs are available, setting up
- * phys_cpu_present_map and the logical/physical mappings.
+ * cpu_possible_map and the logical/physical mappings.
  * XXXKW will the boot CPU ever not be physical 0?
  *
  * Common setup before any secondaries are started
@@ -133,14 +133,14 @@ static void __init sb1250_smp_setup(void)
 {
 	int i, num;
 
-	cpus_clear(phys_cpu_present_map);
-	cpu_set(0, phys_cpu_present_map);
+	cpus_clear(cpu_possible_map);
+	cpu_set(0, cpu_possible_map);
 	__cpu_number_map[0] = 0;
 	__cpu_logical_map[0] = 0;
 
 	for (i = 1, num = 0; i < NR_CPUS; i++) {
 		if (cfe_cpu_stop(i) == 0) {
-			cpu_set(i, phys_cpu_present_map);
+			cpu_set(i, cpu_possible_map);
 			__cpu_number_map[i] = ++num;
 			__cpu_logical_map[num] = i;
 		}
diff --git a/arch/mips/sni/time.c b/arch/mips/sni/time.c
index 796e3ce..69f5f88 100644
--- a/arch/mips/sni/time.c
+++ b/arch/mips/sni/time.c
@@ -80,7 +80,7 @@ static void __init sni_a20r_timer_setup(void)
 	struct irqaction *action = &a20r_irqaction;
 	unsigned int cpu = smp_processor_id();
 
-	cd->cpumask             = cpumask_of_cpu(cpu);
+	cd->cpumask             = cpumask_of(cpu);
 	clockevents_register_device(cd);
 	action->dev_id = cd;
 	setup_irq(SNI_A20R_IRQ_TIMER, &a20r_irqaction);
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 644a70b..aacf11d 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -11,6 +11,7 @@ config PARISC
 	select HAVE_OPROFILE
 	select RTC_CLASS
 	select RTC_DRV_PARISC
+	select INIT_ALL_POSSIBLE
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
 	  in many of their workstations & servers (HP9000 700 and 800 series,
diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index 23ef950..4cea935 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -131,12 +131,12 @@ int cpu_check_affinity(unsigned int irq, cpumask_t *dest)
 	return 0;
 }
 
-static void cpu_set_affinity_irq(unsigned int irq, cpumask_t dest)
+static void cpu_set_affinity_irq(unsigned int irq, const struct cpumask *dest)
 {
-	if (cpu_check_affinity(irq, &dest))
+	if (cpu_check_affinity(irq, dest))
 		return;
 
-	irq_desc[irq].affinity = dest;
+	irq_desc[irq].affinity = *dest;
 }
 #endif
 
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index d47f397..80bc000 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -67,21 +67,6 @@ static volatile int cpu_now_booting __read_mostly = 0;	/* track which CPU is boo
 
 static int parisc_max_cpus __read_mostly = 1;
 
-/* online cpus are ones that we've managed to bring up completely
- * possible cpus are all valid cpu 
- * present cpus are all detected cpu
- *
- * On startup we bring up the "possible" cpus. Since we discover
- * CPUs later, we add them as hotplug, so the possible cpu mask is
- * empty in the beginning.
- */
-
-cpumask_t cpu_online_map   __read_mostly = CPU_MASK_NONE;	/* Bitmap of online CPUs */
-cpumask_t cpu_possible_map __read_mostly = CPU_MASK_ALL;	/* Bitmap of Present CPUs */
-
-EXPORT_SYMBOL(cpu_online_map);
-EXPORT_SYMBOL(cpu_possible_map);
-
 DEFINE_PER_CPU(spinlock_t, ipi_lock) = SPIN_LOCK_UNLOCKED;
 
 enum ipi_message_type {
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index c32da6f..373fca3 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -48,7 +48,6 @@ static inline int pcibus_to_node(struct pci_bus *bus)
 
 /* sched_domains SD_NODE_INIT for PPC64 machines */
 #define SD_NODE_INIT (struct sched_domain) {		\
-	.span			= CPU_MASK_NONE,	\
 	.parent			= NULL,			\
 	.child			= NULL,			\
 	.groups			= NULL,			\
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index ac222d0..23b8b5e 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -237,7 +237,7 @@ void fixup_irqs(cpumask_t map)
 			mask = map;
 		}
 		if (irq_desc[irq].chip->set_affinity)
-			irq_desc[irq].chip->set_affinity(irq, mask);
+			irq_desc[irq].chip->set_affinity(irq, &mask);
 		else if (irq_desc[irq].action && !(warned++))
 			printk("Cannot set affinity for irq %i\n", irq);
 	}
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 8ac3f72..65484b2 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -59,13 +59,9 @@
 
 struct thread_info *secondary_ti;
 
-cpumask_t cpu_possible_map = CPU_MASK_NONE;
-cpumask_t cpu_online_map = CPU_MASK_NONE;
 DEFINE_PER_CPU(cpumask_t, cpu_sibling_map) = CPU_MASK_NONE;
 DEFINE_PER_CPU(cpumask_t, cpu_core_map) = CPU_MASK_NONE;
 
-EXPORT_SYMBOL(cpu_online_map);
-EXPORT_SYMBOL(cpu_possible_map);
 EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
 EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index e1f3a51..99f1ddd 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -844,7 +844,7 @@ static void register_decrementer_clockevent(int cpu)
 	struct clock_event_device *dec = &per_cpu(decrementers, cpu).event;
 
 	*dec = decrementer_clockevent;
-	dec->cpumask = cpumask_of_cpu(cpu);
+	dec->cpumask = cpumask_of(cpu);
 
 	printk(KERN_DEBUG "clockevent: %s mult[%lx] shift[%d] cpu[%d]\n",
 	       dec->name, dec->mult, dec->shift, cpu);
diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
index f7a6902..84e058f 100644
--- a/arch/powerpc/platforms/pseries/xics.c
+++ b/arch/powerpc/platforms/pseries/xics.c
@@ -332,7 +332,7 @@ static void xics_eoi_lpar(unsigned int virq)
 	lpar_xirr_info_set((0xff << 24) | irq);
 }
 
-static void xics_set_affinity(unsigned int virq, cpumask_t cpumask)
+static void xics_set_affinity(unsigned int virq, const struct cpumask *cpumask)
 {
 	unsigned int irq;
 	int status;
@@ -870,7 +870,7 @@ void xics_migrate_irqs_away(void)
 
 		/* Reset affinity to all cpus */
 		irq_desc[virq].affinity = CPU_MASK_ALL;
-		desc->chip->set_affinity(virq, CPU_MASK_ALL);
+		desc->chip->set_affinity(virq, cpu_all_mask);
 unlock:
 		spin_unlock_irqrestore(&desc->lock, flags);
 	}
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index c82babb..3e0d89d 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -806,7 +806,7 @@ static void mpic_end_ipi(unsigned int irq)
 
 #endif /* CONFIG_SMP */
 
-void mpic_set_affinity(unsigned int irq, cpumask_t cpumask)
+void mpic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 {
 	struct mpic *mpic = mpic_from_irq(irq);
 	unsigned int src = mpic_irq_to_hw(irq);
@@ -818,7 +818,7 @@ void mpic_set_affinity(unsigned int irq, cpumask_t cpumask)
 	} else {
 		cpumask_t tmp;
 
-		cpus_and(tmp, cpumask, cpu_online_map);
+		cpumask_and(&tmp, cpumask, cpu_online_mask);
 
 		mpic_irq_write(src, MPIC_INFO(IRQ_DESTINATION),
 			       mpic_physmask(cpus_addr(tmp)[0]));
diff --git a/arch/powerpc/sysdev/mpic.h b/arch/powerpc/sysdev/mpic.h
index 6209c62..3cef2af 100644
--- a/arch/powerpc/sysdev/mpic.h
+++ b/arch/powerpc/sysdev/mpic.h
@@ -36,6 +36,6 @@ static inline int mpic_pasemi_msi_init(struct mpic *mpic)
 
 extern int mpic_set_irq_type(unsigned int virq, unsigned int flow_type);
 extern void mpic_set_vector(unsigned int virq, unsigned int vector);
-extern void mpic_set_affinity(unsigned int irq, cpumask_t cpumask);
+extern void mpic_set_affinity(unsigned int irq, const struct cpumask *cpumask);
 
 #endif /* _POWERPC_SYSDEV_MPIC_H */
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 8152fef..19577ae 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -83,6 +83,7 @@ config S390
 	select HAVE_KRETPROBES
 	select HAVE_KVM if 64BIT
 	select HAVE_ARCH_TRACEHOOK
+	select INIT_ALL_POSSIBLE
 
 source "init/Kconfig"
 
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 6fc7854..3ed5c7a 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -55,12 +55,6 @@
 struct _lowcore *lowcore_ptr[NR_CPUS];
 EXPORT_SYMBOL(lowcore_ptr);
 
-cpumask_t cpu_online_map = CPU_MASK_NONE;
-EXPORT_SYMBOL(cpu_online_map);
-
-cpumask_t cpu_possible_map = CPU_MASK_ALL;
-EXPORT_SYMBOL(cpu_possible_map);
-
 static struct task_struct *current_set[NR_CPUS];
 
 static u8 smp_cpu_type;
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 5be981a..d649600 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -160,7 +160,7 @@ void init_cpu_timer(void)
 	cd->min_delta_ns	= 1;
 	cd->max_delta_ns	= LONG_MAX;
 	cd->rating		= 400;
-	cd->cpumask		= cpumask_of_cpu(cpu);
+	cd->cpumask		= cpumask_of(cpu);
 	cd->set_next_event	= s390_next_event;
 	cd->set_mode		= s390_set_mode;
 
diff --git a/arch/sh/include/asm/smp.h b/arch/sh/include/asm/smp.h
index 85b660c..c24e9c6 100644
--- a/arch/sh/include/asm/smp.h
+++ b/arch/sh/include/asm/smp.h
@@ -31,7 +31,7 @@ enum {
 };
 
 void smp_message_recv(unsigned int msg);
-void smp_timer_broadcast(cpumask_t mask);
+void smp_timer_broadcast(const struct cpumask *mask);
 
 void local_timer_interrupt(void);
 void local_timer_setup(unsigned int cpu);
diff --git a/arch/sh/include/asm/topology.h b/arch/sh/include/asm/topology.h
index 95f0085..279d9cc 100644
--- a/arch/sh/include/asm/topology.h
+++ b/arch/sh/include/asm/topology.h
@@ -5,7 +5,6 @@
 
 /* sched_domains SD_NODE_INIT for sh machines */
 #define SD_NODE_INIT (struct sched_domain) {		\
-	.span			= CPU_MASK_NONE,	\
 	.parent			= NULL,			\
 	.child			= NULL,			\
 	.groups			= NULL,			\
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index 3c5ad16..8f40274 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -31,12 +31,6 @@
 int __cpu_number_map[NR_CPUS];		/* Map physical to logical */
 int __cpu_logical_map[NR_CPUS];		/* Map logical to physical */
 
-cpumask_t cpu_possible_map;
-EXPORT_SYMBOL(cpu_possible_map);
-
-cpumask_t cpu_online_map;
-EXPORT_SYMBOL(cpu_online_map);
-
 static inline void __init smp_store_cpu_info(unsigned int cpu)
 {
 	struct sh_cpuinfo *c = cpu_data + cpu;
@@ -190,11 +184,11 @@ void arch_send_call_function_single_ipi(int cpu)
 	plat_send_ipi(cpu, SMP_MSG_FUNCTION_SINGLE);
 }
 
-void smp_timer_broadcast(cpumask_t mask)
+void smp_timer_broadcast(const struct cpumask *mask)
 {
 	int cpu;
 
-	for_each_cpu_mask(cpu, mask)
+	for_each_cpu(cpu, mask)
 		plat_send_ipi(cpu, SMP_MSG_TIMER);
 }
 
diff --git a/arch/sh/kernel/timers/timer-broadcast.c b/arch/sh/kernel/timers/timer-broadcast.c
index c231763..96e8eae 100644
--- a/arch/sh/kernel/timers/timer-broadcast.c
+++ b/arch/sh/kernel/timers/timer-broadcast.c
@@ -51,7 +51,7 @@ void __cpuinit local_timer_setup(unsigned int cpu)
 	clk->mult		= 1;
 	clk->set_mode		= dummy_timer_set_mode;
 	clk->broadcast		= smp_timer_broadcast;
-	clk->cpumask		= cpumask_of_cpu(cpu);
+	clk->cpumask		= cpumask_of(cpu);
 
 	clockevents_register_device(clk);
 }
diff --git a/arch/sh/kernel/timers/timer-tmu.c b/arch/sh/kernel/timers/timer-tmu.c
index 3c61ddd..0db3f95 100644
--- a/arch/sh/kernel/timers/timer-tmu.c
+++ b/arch/sh/kernel/timers/timer-tmu.c
@@ -263,7 +263,7 @@ static int tmu_timer_init(void)
 	tmu0_clockevent.min_delta_ns =
 			clockevent_delta2ns(1, &tmu0_clockevent);
 
-	tmu0_clockevent.cpumask = cpumask_of_cpu(0);
+	tmu0_clockevent.cpumask = cpumask_of(0);
 
 	clockevents_register_device(&tmu0_clockevent);
 
diff --git a/arch/sparc/include/asm/smp_32.h b/arch/sparc/include/asm/smp_32.h
index a8180e5..8408d9d 100644
--- a/arch/sparc/include/asm/smp_32.h
+++ b/arch/sparc/include/asm/smp_32.h
@@ -29,8 +29,6 @@
  */
 
 extern unsigned char boot_cpu_id;
-extern cpumask_t phys_cpu_present_map;
-#define cpu_possible_map phys_cpu_present_map
 
 typedef void (*smpfunc_t)(unsigned long, unsigned long, unsigned long,
 		       unsigned long, unsigned long);
diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index a3ea2bc..cab8e02 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -312,7 +312,8 @@ static void sun4u_irq_enable(unsigned int virt_irq)
 	}
 }
 
-static void sun4u_set_affinity(unsigned int virt_irq, cpumask_t mask)
+static void sun4u_set_affinity(unsigned int virt_irq,
+			       const struct cpumask *mask)
 {
 	sun4u_irq_enable(virt_irq);
 }
@@ -362,7 +363,8 @@ static void sun4v_irq_enable(unsigned int virt_irq)
 		       ino, err);
 }
 
-static void sun4v_set_affinity(unsigned int virt_irq, cpumask_t mask)
+static void sun4v_set_affinity(unsigned int virt_irq,
+			       const struct cpumask *mask)
 {
 	unsigned int ino = virt_irq_table[virt_irq].dev_ino;
 	unsigned long cpuid = irq_choose_cpu(virt_irq);
@@ -429,7 +431,8 @@ static void sun4v_virq_enable(unsigned int virt_irq)
 		       dev_handle, dev_ino, err);
 }
 
-static void sun4v_virt_set_affinity(unsigned int virt_irq, cpumask_t mask)
+static void sun4v_virt_set_affinity(unsigned int virt_irq,
+				    const struct cpumask *mask)
 {
 	unsigned long cpuid, dev_handle, dev_ino;
 	int err;
@@ -851,7 +854,7 @@ void fixup_irqs(void)
 		    !(irq_desc[irq].status & IRQ_PER_CPU)) {
 			if (irq_desc[irq].chip->set_affinity)
 				irq_desc[irq].chip->set_affinity(irq,
-					irq_desc[irq].affinity);
+					&irq_desc[irq].affinity);
 		}
 		spin_unlock_irqrestore(&irq_desc[irq].lock, flags);
 	}
diff --git a/arch/sparc/kernel/of_device_64.c b/arch/sparc/kernel/of_device_64.c
index 46e231f..322046c 100644
--- a/arch/sparc/kernel/of_device_64.c
+++ b/arch/sparc/kernel/of_device_64.c
@@ -780,7 +780,7 @@ out:
 	if (nid != -1) {
 		cpumask_t numa_mask = node_to_cpumask(nid);
 
-		irq_set_affinity(irq, numa_mask);
+		irq_set_affinity(irq, &numa_mask);
 	}
 
 	return irq;
diff --git a/arch/sparc/kernel/pci_msi.c b/arch/sparc/kernel/pci_msi.c
index 2e680f3..0d0cd81 100644
--- a/arch/sparc/kernel/pci_msi.c
+++ b/arch/sparc/kernel/pci_msi.c
@@ -288,7 +288,7 @@ static int bringup_one_msi_queue(struct pci_pbm_info *pbm,
 	if (nid != -1) {
 		cpumask_t numa_mask = node_to_cpumask(nid);
 
-		irq_set_affinity(irq, numa_mask);
+		irq_set_affinity(irq, &numa_mask);
 	}
 	err = request_irq(irq, sparc64_msiq_interrupt, 0,
 			  "MSIQ",
diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index e396c1f..1e5ac4e 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -39,8 +39,6 @@ volatile unsigned long cpu_callin_map[NR_CPUS] __cpuinitdata = {0,};
 unsigned char boot_cpu_id = 0;
 unsigned char boot_cpu_id4 = 0; /* boot_cpu_id << 2 */
 
-cpumask_t cpu_online_map = CPU_MASK_NONE;
-cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
 cpumask_t smp_commenced_mask = CPU_MASK_NONE;
 
 /* The only guaranteed locking primitive available on all Sparc
@@ -334,7 +332,7 @@ void __init smp_setup_cpu_possible_map(void)
 	instance = 0;
 	while (!cpu_find_by_instance(instance, NULL, &mid)) {
 		if (mid < NR_CPUS) {
-			cpu_set(mid, phys_cpu_present_map);
+			cpu_set(mid, cpu_possible_map);
 			cpu_set(mid, cpu_present_map);
 		}
 		instance++;
@@ -354,7 +352,7 @@ void __init smp_prepare_boot_cpu(void)
 
 	current_thread_info()->cpu = cpuid;
 	cpu_set(cpuid, cpu_online_map);
-	cpu_set(cpuid, phys_cpu_present_map);
+	cpu_set(cpuid, cpu_possible_map);
 }
 
 int __cpuinit __cpu_up(unsigned int cpu)
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index bfe99d8..4632979 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -49,14 +49,10 @@
 
 int sparc64_multi_core __read_mostly;
 
-cpumask_t cpu_possible_map __read_mostly = CPU_MASK_NONE;
-cpumask_t cpu_online_map __read_mostly = CPU_MASK_NONE;
 DEFINE_PER_CPU(cpumask_t, cpu_sibling_map) = CPU_MASK_NONE;
 cpumask_t cpu_core_map[NR_CPUS] __read_mostly =
 	{ [0 ... NR_CPUS-1] = CPU_MASK_NONE };
 
-EXPORT_SYMBOL(cpu_possible_map);
-EXPORT_SYMBOL(cpu_online_map);
 EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
 EXPORT_SYMBOL(cpu_core_map);
 
diff --git a/arch/sparc/kernel/sparc_ksyms_32.c b/arch/sparc/kernel/sparc_ksyms_32.c
index a4d45fc..e1e9763 100644
--- a/arch/sparc/kernel/sparc_ksyms_32.c
+++ b/arch/sparc/kernel/sparc_ksyms_32.c
@@ -112,10 +112,6 @@ EXPORT_PER_CPU_SYMBOL(__cpu_data);
 #ifdef CONFIG_SMP
 /* IRQ implementation. */
 EXPORT_SYMBOL(synchronize_irq);
-
-/* CPU online map and active count. */
-EXPORT_SYMBOL(cpu_online_map);
-EXPORT_SYMBOL(phys_cpu_present_map);
 #endif
 
 EXPORT_SYMBOL(__udelay);
diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index 141da37..9df8f09 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -763,7 +763,7 @@ void __devinit setup_sparc64_timer(void)
 	sevt = &__get_cpu_var(sparc64_events);
 
 	memcpy(sevt, &sparc64_clockevent, sizeof(*sevt));
-	sevt->cpumask = cpumask_of_cpu(smp_processor_id());
+	sevt->cpumask = cpumask_of(smp_processor_id());
 
 	clockevents_register_device(sevt);
 }
diff --git a/arch/um/kernel/smp.c b/arch/um/kernel/smp.c
index 0457721..98351c7 100644
--- a/arch/um/kernel/smp.c
+++ b/arch/um/kernel/smp.c
@@ -25,13 +25,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 #include "irq_user.h"
 #include "os.h"
 
-/* CPU online map, set by smp_boot_cpus */
-cpumask_t cpu_online_map = CPU_MASK_NONE;
-cpumask_t cpu_possible_map = CPU_MASK_NONE;
-
-EXPORT_SYMBOL(cpu_online_map);
-EXPORT_SYMBOL(cpu_possible_map);
-
 /* Per CPU bogomips and other parameters
  * The only piece used here is the ipi pipe, which is set before SMP is
  * started and never changed.
diff --git a/arch/um/kernel/time.c b/arch/um/kernel/time.c
index 47f04f4..b13a87a 100644
--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -50,7 +50,7 @@ static int itimer_next_event(unsigned long delta,
 static struct clock_event_device itimer_clockevent = {
 	.name		= "itimer",
 	.rating		= 250,
-	.cpumask	= CPU_MASK_ALL,
+	.cpumask	= cpu_all_mask,
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.set_mode	= itimer_set_mode,
 	.set_next_event = itimer_next_event,
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0f44add..249d1e0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -601,19 +601,20 @@ config IOMMU_HELPER
 
 config MAXSMP
 	bool "Configure Maximum number of SMP Processors and NUMA Nodes"
-	depends on X86_64 && SMP && BROKEN
+	depends on X86_64 && SMP && DEBUG_KERNEL && EXPERIMENTAL
+	select CPUMASK_OFFSTACK
 	default n
 	help
 	  Configure maximum number of CPUS and NUMA Nodes for this architecture.
 	  If unsure, say N.
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-512)" if !MAXSMP
-	range 2 512
-	depends on SMP
+	int "Maximum number of CPUs" if SMP && !MAXSMP
+	range 2 512 if SMP && !MAXSMP
+	default "1" if !SMP
 	default "4096" if MAXSMP
-	default "32" if X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000
-	default "8"
+	default "32" if SMP && (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000)
+	default "8" if SMP
 	help
 	  This allows you to specify the maximum number of CPUs which this
 	  kernel will support.  The maximum supported value is 512 and the
diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index ce547f2..d8dd9f5 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -9,12 +9,12 @@ static inline int apic_id_registered(void)
 	return (1);
 }
 
-static inline cpumask_t target_cpus(void)
+static inline const cpumask_t *target_cpus(void)
 {
 #ifdef CONFIG_SMP
-        return cpu_online_map;
+	return &cpu_online_map;
 #else
-        return cpumask_of_cpu(0);
+	return &cpumask_of_cpu(0);
 #endif
 }
 
@@ -79,7 +79,7 @@ static inline int apicid_to_node(int logical_apicid)
 
 static inline int cpu_present_to_apicid(int mps_cpu)
 {
-	if (mps_cpu < NR_CPUS)
+	if (mps_cpu < nr_cpu_ids)
 		return (int) per_cpu(x86_bios_cpu_apicid, mps_cpu);
 
 	return BAD_APICID;
@@ -94,7 +94,7 @@ extern u8 cpu_2_logical_apicid[];
 /* Mapping from cpu number to logical apicid */
 static inline int cpu_to_logical_apicid(int cpu)
 {
-	if (cpu >= NR_CPUS)
+	if (cpu >= nr_cpu_ids)
 		return BAD_APICID;
 	return cpu_physical_id(cpu);
 }
@@ -119,16 +119,34 @@ static inline int check_phys_apicid_present(int boot_cpu_physical_apicid)
 }
 
 /* As we are using single CPU as destination, pick only one CPU here */
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	int cpu;
 	int apicid;	
 
-	cpu = first_cpu(cpumask);
+	cpu = first_cpu(*cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
 	return apicid;
 }
 
+static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+						  const struct cpumask *andmask)
+{
+	int cpu;
+
+	/*
+	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * May as well be the first.
+	 */
+	for_each_cpu_and(cpu, cpumask, andmask)
+		if (cpumask_test_cpu(cpu, cpu_online_mask))
+			break;
+	if (cpu < nr_cpu_ids)
+		return cpu_to_logical_apicid(cpu);
+
+	return BAD_APICID;
+}
+
 static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
 {
 	return cpuid_apic >> index_msb;
diff --git a/arch/x86/include/asm/bigsmp/ipi.h b/arch/x86/include/asm/bigsmp/ipi.h
index 9404c53..27fcd01 100644
--- a/arch/x86/include/asm/bigsmp/ipi.h
+++ b/arch/x86/include/asm/bigsmp/ipi.h
@@ -1,25 +1,22 @@
 #ifndef __ASM_MACH_IPI_H
 #define __ASM_MACH_IPI_H
 
-void send_IPI_mask_sequence(cpumask_t mask, int vector);
+void send_IPI_mask_sequence(const struct cpumask *mask, int vector);
+void send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
 
-static inline void send_IPI_mask(cpumask_t mask, int vector)
+static inline void send_IPI_mask(const struct cpumask *mask, int vector)
 {
 	send_IPI_mask_sequence(mask, vector);
 }
 
 static inline void send_IPI_allbutself(int vector)
 {
-	cpumask_t mask = cpu_online_map;
-	cpu_clear(smp_processor_id(), mask);
-
-	if (!cpus_empty(mask))
-		send_IPI_mask(mask, vector);
+	send_IPI_mask_allbutself(cpu_online_mask, vector);
 }
 
 static inline void send_IPI_all(int vector)
 {
-	send_IPI_mask(cpu_online_map, vector);
+	send_IPI_mask(cpu_online_mask, vector);
 }
 
 #endif /* __ASM_MACH_IPI_H */
diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index e6b82b1..dc27705 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -320,16 +320,14 @@ static inline void set_intr_gate(unsigned int n, void *addr)
 	_set_gate(n, GATE_INTERRUPT, addr, 0, 0, __KERNEL_CS);
 }
 
-#define SYS_VECTOR_FREE		0
-#define SYS_VECTOR_ALLOCED	1
-
 extern int first_system_vector;
-extern char system_vectors[];
+/* used_vectors is BITMAP for irq is not managed by percpu vector_irq */
+extern unsigned long used_vectors[];
 
 static inline void alloc_system_vector(int vector)
 {
-	if (system_vectors[vector] == SYS_VECTOR_FREE) {
-		system_vectors[vector] = SYS_VECTOR_ALLOCED;
+	if (!test_bit(vector, used_vectors)) {
+		set_bit(vector, used_vectors);
 		if (first_system_vector > vector)
 			first_system_vector = vector;
 	} else
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index e24ef87..51ac123 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -9,14 +9,14 @@ static inline int apic_id_registered(void)
 	        return (1);
 }
 
-static inline cpumask_t target_cpus_cluster(void)
+static inline const cpumask_t *target_cpus_cluster(void)
 {
-	return CPU_MASK_ALL;
+	return &CPU_MASK_ALL;
 }
 
-static inline cpumask_t target_cpus(void)
+static inline const cpumask_t *target_cpus(void)
 {
-	return cpumask_of_cpu(smp_processor_id());
+	return &cpumask_of_cpu(smp_processor_id());
 }
 
 #define APIC_DFR_VALUE_CLUSTER		(APIC_DFR_CLUSTER)
@@ -80,9 +80,10 @@ extern int apic_version [MAX_APICS];
 static inline void setup_apic_routing(void)
 {
 	int apic = per_cpu(x86_bios_cpu_apicid, smp_processor_id());
-	printk("Enabling APIC mode:  %s.  Using %d I/O APICs, target cpus %lx\n",
+	printk("Enabling APIC mode:  %s. Using %d I/O APICs, target cpus %lx\n",
 		(apic_version[apic] == 0x14) ?
-		"Physical Cluster" : "Logical Cluster", nr_ioapics, cpus_addr(target_cpus())[0]);
+			"Physical Cluster" : "Logical Cluster",
+			nr_ioapics, cpus_addr(*target_cpus())[0]);
 }
 
 static inline int multi_timer_check(int apic, int irq)
@@ -100,7 +101,7 @@ static inline int cpu_present_to_apicid(int mps_cpu)
 {
 	if (!mps_cpu)
 		return boot_cpu_physical_apicid;
-	else if (mps_cpu < NR_CPUS)
+	else if (mps_cpu < nr_cpu_ids)
 		return (int) per_cpu(x86_bios_cpu_apicid, mps_cpu);
 	else
 		return BAD_APICID;
@@ -120,9 +121,9 @@ extern u8 cpu_2_logical_apicid[];
 static inline int cpu_to_logical_apicid(int cpu)
 {
 #ifdef CONFIG_SMP
-       if (cpu >= NR_CPUS)
-	       return BAD_APICID;
-       return (int)cpu_2_logical_apicid[cpu];
+	if (cpu >= nr_cpu_ids)
+		return BAD_APICID;
+	return (int)cpu_2_logical_apicid[cpu];
 #else
 	return logical_smp_processor_id();
 #endif
@@ -146,14 +147,15 @@ static inline int check_phys_apicid_present(int cpu_physical_apicid)
 	return (1);
 }
 
-static inline unsigned int cpu_mask_to_apicid_cluster(cpumask_t cpumask)
+static inline unsigned int
+cpu_mask_to_apicid_cluster(const struct cpumask *cpumask)
 {
 	int num_bits_set;
 	int cpus_found = 0;
 	int cpu;
 	int apicid;
 
-	num_bits_set = cpus_weight(cpumask);
+	num_bits_set = cpumask_weight(cpumask);
 	/* Return id to all */
 	if (num_bits_set == NR_CPUS)
 		return 0xFF;
@@ -161,10 +163,10 @@ static inline unsigned int cpu_mask_to_apicid_cluster(cpumask_t cpumask)
 	 * The cpus in the mask must all be on the apic cluster.  If are not
 	 * on the same apicid cluster return default value of TARGET_CPUS.
 	 */
-	cpu = first_cpu(cpumask);
+	cpu = cpumask_first(cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
 	while (cpus_found < num_bits_set) {
-		if (cpu_isset(cpu, cpumask)) {
+		if (cpumask_test_cpu(cpu, cpumask)) {
 			int new_apicid = cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) !=
 					apicid_cluster(new_apicid)){
@@ -179,14 +181,14 @@ static inline unsigned int cpu_mask_to_apicid_cluster(cpumask_t cpumask)
 	return apicid;
 }
 
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	int num_bits_set;
 	int cpus_found = 0;
 	int cpu;
 	int apicid;
 
-	num_bits_set = cpus_weight(cpumask);
+	num_bits_set = cpus_weight(*cpumask);
 	/* Return id to all */
 	if (num_bits_set == NR_CPUS)
 		return cpu_to_logical_apicid(0);
@@ -194,10 +196,52 @@ static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
 	 * The cpus in the mask must all be on the apic cluster.  If are not
 	 * on the same apicid cluster return default value of TARGET_CPUS.
 	 */
-	cpu = first_cpu(cpumask);
+	cpu = first_cpu(*cpumask);
+	apicid = cpu_to_logical_apicid(cpu);
+	while (cpus_found < num_bits_set) {
+		if (cpu_isset(cpu, *cpumask)) {
+			int new_apicid = cpu_to_logical_apicid(cpu);
+			if (apicid_cluster(apicid) !=
+					apicid_cluster(new_apicid)){
+				printk ("%s: Not a valid mask!\n", __func__);
+				return cpu_to_logical_apicid(0);
+			}
+			apicid = new_apicid;
+			cpus_found++;
+		}
+		cpu++;
+	}
+	return apicid;
+}
+
+
+static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *inmask,
+						  const struct cpumask *andmask)
+{
+	int num_bits_set;
+	int cpus_found = 0;
+	int cpu;
+	int apicid = cpu_to_logical_apicid(0);
+	cpumask_var_t cpumask;
+
+	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
+		return apicid;
+
+	cpumask_and(cpumask, inmask, andmask);
+	cpumask_and(cpumask, cpumask, cpu_online_mask);
+
+	num_bits_set = cpumask_weight(cpumask);
+	/* Return id to all */
+	if (num_bits_set == NR_CPUS)
+		goto exit;
+	/*
+	 * The cpus in the mask must all be on the apic cluster.  If are not
+	 * on the same apicid cluster return default value of TARGET_CPUS.
+	 */
+	cpu = cpumask_first(cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
 	while (cpus_found < num_bits_set) {
-		if (cpu_isset(cpu, cpumask)) {
+		if (cpumask_test_cpu(cpu, cpumask)) {
 			int new_apicid = cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) !=
 					apicid_cluster(new_apicid)){
@@ -209,6 +253,8 @@ static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
 		}
 		cpu++;
 	}
+exit:
+	free_cpumask_var(cpumask);
 	return apicid;
 }
 
diff --git a/arch/x86/include/asm/es7000/ipi.h b/arch/x86/include/asm/es7000/ipi.h
index 632a955..7e8ed24 100644
--- a/arch/x86/include/asm/es7000/ipi.h
+++ b/arch/x86/include/asm/es7000/ipi.h
@@ -1,24 +1,22 @@
 #ifndef __ASM_ES7000_IPI_H
 #define __ASM_ES7000_IPI_H
 
-void send_IPI_mask_sequence(cpumask_t mask, int vector);
+void send_IPI_mask_sequence(const struct cpumask *mask, int vector);
+void send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
 
-static inline void send_IPI_mask(cpumask_t mask, int vector)
+static inline void send_IPI_mask(const struct cpumask *mask, int vector)
 {
 	send_IPI_mask_sequence(mask, vector);
 }
 
 static inline void send_IPI_allbutself(int vector)
 {
-	cpumask_t mask = cpu_online_map;
-	cpu_clear(smp_processor_id(), mask);
-	if (!cpus_empty(mask))
-		send_IPI_mask(mask, vector);
+	send_IPI_mask_allbutself(cpu_online_mask, vector);
 }
 
 static inline void send_IPI_all(int vector)
 {
-	send_IPI_mask(cpu_online_map, vector);
+	send_IPI_mask(cpu_online_mask, vector);
 }
 
 #endif /* __ASM_ES7000_IPI_H */
diff --git a/arch/x86/include/asm/genapic_32.h b/arch/x86/include/asm/genapic_32.h
index 0ac17d3..746f37a 100644
--- a/arch/x86/include/asm/genapic_32.h
+++ b/arch/x86/include/asm/genapic_32.h
@@ -24,7 +24,7 @@ struct genapic {
 	int (*probe)(void);
 
 	int (*apic_id_registered)(void);
-	cpumask_t (*target_cpus)(void);
+	const struct cpumask *(*target_cpus)(void);
 	int int_delivery_mode;
 	int int_dest_mode;
 	int ESR_DISABLE;
@@ -57,12 +57,16 @@ struct genapic {
 
 	unsigned (*get_apic_id)(unsigned long x);
 	unsigned long apic_id_mask;
-	unsigned int (*cpu_mask_to_apicid)(cpumask_t cpumask);
-	cpumask_t (*vector_allocation_domain)(int cpu);
+	unsigned int (*cpu_mask_to_apicid)(const struct cpumask *cpumask);
+	unsigned int (*cpu_mask_to_apicid_and)(const struct cpumask *cpumask,
+					       const struct cpumask *andmask);
+	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
 
 #ifdef CONFIG_SMP
 	/* ipi */
-	void (*send_IPI_mask)(cpumask_t mask, int vector);
+	void (*send_IPI_mask)(const struct cpumask *mask, int vector);
+	void (*send_IPI_mask_allbutself)(const struct cpumask *mask,
+					 int vector);
 	void (*send_IPI_allbutself)(int vector);
 	void (*send_IPI_all)(int vector);
 #endif
@@ -114,6 +118,7 @@ struct genapic {
 	APICFUNC(get_apic_id)				\
 	.apic_id_mask = APIC_ID_MASK,			\
 	APICFUNC(cpu_mask_to_apicid)			\
+	APICFUNC(cpu_mask_to_apicid_and)		\
 	APICFUNC(vector_allocation_domain)		\
 	APICFUNC(acpi_madt_oem_check)			\
 	IPIFUNC(send_IPI_mask)				\
diff --git a/arch/x86/include/asm/genapic_64.h b/arch/x86/include/asm/genapic_64.h
index 2cae011..adf32fb 100644
--- a/arch/x86/include/asm/genapic_64.h
+++ b/arch/x86/include/asm/genapic_64.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_GENAPIC_64_H
 #define _ASM_X86_GENAPIC_64_H
 
+#include <linux/cpumask.h>
+
 /*
  * Copyright 2004 James Cleverdon, IBM.
  * Subject to the GNU Public License, v.2
@@ -18,16 +20,20 @@ struct genapic {
 	u32 int_delivery_mode;
 	u32 int_dest_mode;
 	int (*apic_id_registered)(void);
-	cpumask_t (*target_cpus)(void);
-	cpumask_t (*vector_allocation_domain)(int cpu);
+	const struct cpumask *(*target_cpus)(void);
+	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
 	void (*init_apic_ldr)(void);
 	/* ipi */
-	void (*send_IPI_mask)(cpumask_t mask, int vector);
+	void (*send_IPI_mask)(const struct cpumask *mask, int vector);
+	void (*send_IPI_mask_allbutself)(const struct cpumask *mask,
+					 int vector);
 	void (*send_IPI_allbutself)(int vector);
 	void (*send_IPI_all)(int vector);
 	void (*send_IPI_self)(int vector);
 	/* */
-	unsigned int (*cpu_mask_to_apicid)(cpumask_t cpumask);
+	unsigned int (*cpu_mask_to_apicid)(const struct cpumask *cpumask);
+	unsigned int (*cpu_mask_to_apicid_and)(const struct cpumask *cpumask,
+					       const struct cpumask *andmask);
 	unsigned int (*phys_pkg_id)(int index_msb);
 	unsigned int (*get_apic_id)(unsigned long x);
 	unsigned long (*set_apic_id)(unsigned int id);
diff --git a/arch/x86/include/asm/ipi.h b/arch/x86/include/asm/ipi.h
index f89dffb..c745a30 100644
--- a/arch/x86/include/asm/ipi.h
+++ b/arch/x86/include/asm/ipi.h
@@ -117,7 +117,8 @@ static inline void __send_IPI_dest_field(unsigned int mask, int vector,
 	native_apic_mem_write(APIC_ICR, cfg);
 }
 
-static inline void send_IPI_mask_sequence(cpumask_t mask, int vector)
+static inline void send_IPI_mask_sequence(const struct cpumask *mask,
+					  int vector)
 {
 	unsigned long flags;
 	unsigned long query_cpu;
@@ -128,11 +129,29 @@ static inline void send_IPI_mask_sequence(cpumask_t mask, int vector)
 	 * - mbligh
 	 */
 	local_irq_save(flags);
-	for_each_cpu_mask_nr(query_cpu, mask) {
+	for_each_cpu(query_cpu, mask) {
 		__send_IPI_dest_field(per_cpu(x86_cpu_to_apicid, query_cpu),
 				      vector, APIC_DEST_PHYSICAL);
 	}
 	local_irq_restore(flags);
 }
 
+static inline void send_IPI_mask_allbutself(const struct cpumask *mask,
+					    int vector)
+{
+	unsigned long flags;
+	unsigned int query_cpu;
+	unsigned int this_cpu = smp_processor_id();
+
+	/* See Hack comment above */
+
+	local_irq_save(flags);
+	for_each_cpu(query_cpu, mask)
+		if (query_cpu != this_cpu)
+			__send_IPI_dest_field(
+				per_cpu(x86_cpu_to_apicid, query_cpu),
+				vector, APIC_DEST_PHYSICAL);
+	local_irq_restore(flags);
+}
+
 #endif /* _ASM_X86_IPI_H */
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 28e409f..592688e 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -33,7 +33,7 @@ static inline int irq_canonicalize(int irq)
 
 #ifdef CONFIG_HOTPLUG_CPU
 #include <linux/cpumask.h>
-extern void fixup_irqs(cpumask_t map);
+extern void fixup_irqs(void);
 #endif
 
 extern unsigned int do_IRQ(struct pt_regs *regs);
@@ -42,5 +42,6 @@ extern void native_init_IRQ(void);
 
 /* Interrupt vector management */
 extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
+extern int vector_used_by_percpu_irq(unsigned int vector);
 
 #endif /* _ASM_X86_IRQ_H */
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 6cb3a46..cc09cbb 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -8,12 +8,12 @@
 
 #define APIC_DFR_VALUE	(APIC_DFR_FLAT)
 
-static inline cpumask_t target_cpus(void)
+static inline const struct cpumask *target_cpus(void)
 { 
 #ifdef CONFIG_SMP
-	return cpu_online_map;
+	return cpu_online_mask;
 #else
-	return cpumask_of_cpu(0);
+	return cpumask_of(0);
 #endif
 } 
 
@@ -28,6 +28,7 @@ static inline cpumask_t target_cpus(void)
 #define apic_id_registered (genapic->apic_id_registered)
 #define init_apic_ldr (genapic->init_apic_ldr)
 #define cpu_mask_to_apicid (genapic->cpu_mask_to_apicid)
+#define cpu_mask_to_apicid_and (genapic->cpu_mask_to_apicid_and)
 #define phys_pkg_id	(genapic->phys_pkg_id)
 #define vector_allocation_domain    (genapic->vector_allocation_domain)
 #define read_apic_id()  (GET_APIC_ID(apic_read(APIC_ID)))
@@ -61,9 +62,19 @@ static inline int apic_id_registered(void)
 	return physid_isset(read_apic_id(), phys_cpu_present_map);
 }
 
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+static inline unsigned int cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
-	return cpus_addr(cpumask)[0];
+	return cpumask_bits(cpumask)[0];
+}
+
+static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+						  const struct cpumask *andmask)
+{
+	unsigned long mask1 = cpumask_bits(cpumask)[0];
+	unsigned long mask2 = cpumask_bits(andmask)[0];
+	unsigned long mask3 = cpumask_bits(cpu_online_mask)[0];
+
+	return (unsigned int)(mask1 & mask2 & mask3);
 }
 
 static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
@@ -88,7 +99,7 @@ static inline int apicid_to_node(int logical_apicid)
 #endif
 }
 
-static inline cpumask_t vector_allocation_domain(int cpu)
+static inline void vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
         /* Careful. Some cpus do not strictly honor the set of cpus
          * specified in the interrupt destination when using lowest
@@ -98,8 +109,7 @@ static inline cpumask_t vector_allocation_domain(int cpu)
          * deliver interrupts to the wrong hyperthread when only one
          * hyperthread was specified in the interrupt desitination.
          */
-        cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
-        return domain;
+	*retmask = (cpumask_t) { { [0] = APIC_ALL_CPUS } };
 }
 #endif
 
@@ -131,7 +141,7 @@ static inline int cpu_to_logical_apicid(int cpu)
 
 static inline int cpu_present_to_apicid(int mps_cpu)
 {
-	if (mps_cpu < NR_CPUS && cpu_present(mps_cpu))
+	if (mps_cpu < nr_cpu_ids && cpu_present(mps_cpu))
 		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
 	else
 		return BAD_APICID;
diff --git a/arch/x86/include/asm/mach-default/mach_ipi.h b/arch/x86/include/asm/mach-default/mach_ipi.h
index fabca01..191312d 100644
--- a/arch/x86/include/asm/mach-default/mach_ipi.h
+++ b/arch/x86/include/asm/mach-default/mach_ipi.h
@@ -4,7 +4,8 @@
 /* Avoid include hell */
 #define NMI_VECTOR 0x02
 
-void send_IPI_mask_bitmask(cpumask_t mask, int vector);
+void send_IPI_mask_bitmask(const struct cpumask *mask, int vector);
+void send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
 void __send_IPI_shortcut(unsigned int shortcut, int vector);
 
 extern int no_broadcast;
@@ -12,28 +13,27 @@ extern int no_broadcast;
 #ifdef CONFIG_X86_64
 #include <asm/genapic.h>
 #define send_IPI_mask (genapic->send_IPI_mask)
+#define send_IPI_mask_allbutself (genapic->send_IPI_mask_allbutself)
 #else
-static inline void send_IPI_mask(cpumask_t mask, int vector)
+static inline void send_IPI_mask(const struct cpumask *mask, int vector)
 {
 	send_IPI_mask_bitmask(mask, vector);
 }
+void send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
 #endif
 
 static inline void __local_send_IPI_allbutself(int vector)
 {
-	if (no_broadcast || vector == NMI_VECTOR) {
-		cpumask_t mask = cpu_online_map;
-
-		cpu_clear(smp_processor_id(), mask);
-		send_IPI_mask(mask, vector);
-	} else
+	if (no_broadcast || vector == NMI_VECTOR)
+		send_IPI_mask_allbutself(cpu_online_mask, vector);
+	else
 		__send_IPI_shortcut(APIC_DEST_ALLBUT, vector);
 }
 
 static inline void __local_send_IPI_all(int vector)
 {
 	if (no_broadcast || vector == NMI_VECTOR)
-		send_IPI_mask(cpu_online_map, vector);
+		send_IPI_mask(cpu_online_mask, vector);
 	else
 		__send_IPI_shortcut(APIC_DEST_ALLINC, vector);
 }
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index e430f47..48553e9 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -24,6 +24,7 @@
 #define check_phys_apicid_present (genapic->check_phys_apicid_present)
 #define check_apicid_used (genapic->check_apicid_used)
 #define cpu_mask_to_apicid (genapic->cpu_mask_to_apicid)
+#define cpu_mask_to_apicid_and (genapic->cpu_mask_to_apicid_and)
 #define vector_allocation_domain (genapic->vector_allocation_domain)
 #define enable_apic_mode (genapic->enable_apic_mode)
 #define phys_pkg_id (genapic->phys_pkg_id)
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index 0bf2a06..c80f00d 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -7,9 +7,9 @@
 
 #define APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
 
-static inline cpumask_t target_cpus(void)
+static inline const cpumask_t *target_cpus(void)
 {
-	return CPU_MASK_ALL;
+	return &CPU_MASK_ALL;
 }
 
 #define NO_BALANCE_IRQ (1)
@@ -122,7 +122,13 @@ static inline void enable_apic_mode(void)
  * We use physical apicids here, not logical, so just return the default
  * physical broadcast to stop people from breaking us
  */
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
+{
+	return (int) 0xF;
+}
+
+static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+						  const struct cpumask *andmask)
 {
 	return (int) 0xF;
 }
diff --git a/arch/x86/include/asm/numaq/ipi.h b/arch/x86/include/asm/numaq/ipi.h
index 935588d..a8374c6 100644
--- a/arch/x86/include/asm/numaq/ipi.h
+++ b/arch/x86/include/asm/numaq/ipi.h
@@ -1,25 +1,22 @@
 #ifndef __ASM_NUMAQ_IPI_H
 #define __ASM_NUMAQ_IPI_H
 
-void send_IPI_mask_sequence(cpumask_t, int vector);
+void send_IPI_mask_sequence(const struct cpumask *mask, int vector);
+void send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
 
-static inline void send_IPI_mask(cpumask_t mask, int vector)
+static inline void send_IPI_mask(const struct cpumask *mask, int vector)
 {
 	send_IPI_mask_sequence(mask, vector);
 }
 
 static inline void send_IPI_allbutself(int vector)
 {
-	cpumask_t mask = cpu_online_map;
-	cpu_clear(smp_processor_id(), mask);
-
-	if (!cpus_empty(mask))
-		send_IPI_mask(mask, vector);
+	send_IPI_mask_allbutself(cpu_online_mask, vector);
 }
 
 static inline void send_IPI_all(int vector)
 {
-	send_IPI_mask(cpu_online_map, vector);
+	send_IPI_mask(cpu_online_mask, vector);
 }
 
 #endif /* __ASM_NUMAQ_IPI_H */
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index d12811c..830b9fc 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -60,7 +60,7 @@ struct smp_ops {
 	void (*cpu_die)(unsigned int cpu);
 	void (*play_dead)(void);
 
-	void (*send_call_func_ipi)(cpumask_t mask);
+	void (*send_call_func_ipi)(const struct cpumask *mask);
 	void (*send_call_func_single_ipi)(int cpu);
 };
 
@@ -125,7 +125,7 @@ static inline void arch_send_call_function_single_ipi(int cpu)
 
 static inline void arch_send_call_function_ipi(cpumask_t mask)
 {
-	smp_ops.send_call_func_ipi(mask);
+	smp_ops.send_call_func_ipi(&mask);
 }
 
 void cpu_disable_common(void);
@@ -138,7 +138,7 @@ void native_cpu_die(unsigned int cpu);
 void native_play_dead(void);
 void play_dead_common(void);
 
-void native_send_call_func_ipi(cpumask_t mask);
+void native_send_call_func_ipi(const struct cpumask *mask);
 void native_send_call_func_single_ipi(int cpu);
 
 extern void prefill_possible_map(void);
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index 9b3070f..99327d1 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -14,13 +14,13 @@
 
 #define APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
 
-static inline cpumask_t target_cpus(void)
+static inline const cpumask_t *target_cpus(void)
 {
 	/* CPU_MASK_ALL (0xff) has undefined behaviour with
 	 * dest_LowestPrio mode logical clustered apic interrupt routing
 	 * Just start on cpu 0.  IRQ balancing will spread load
 	 */
-	return cpumask_of_cpu(0);
+	return &cpumask_of_cpu(0);
 }
 
 #define INT_DELIVERY_MODE (dest_LowestPrio)
@@ -137,14 +137,14 @@ static inline void enable_apic_mode(void)
 {
 }
 
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	int num_bits_set;
 	int cpus_found = 0;
 	int cpu;
 	int apicid;
 
-	num_bits_set = cpus_weight(cpumask);
+	num_bits_set = cpus_weight(*cpumask);
 	/* Return id to all */
 	if (num_bits_set == NR_CPUS)
 		return (int) 0xFF;
@@ -152,10 +152,10 @@ static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
 	 * The cpus in the mask must all be on the apic cluster.  If are not
 	 * on the same apicid cluster return default value of TARGET_CPUS.
 	 */
-	cpu = first_cpu(cpumask);
+	cpu = first_cpu(*cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
 	while (cpus_found < num_bits_set) {
-		if (cpu_isset(cpu, cpumask)) {
+		if (cpu_isset(cpu, *cpumask)) {
 			int new_apicid = cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) !=
 					apicid_cluster(new_apicid)){
@@ -170,6 +170,49 @@ static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
 	return apicid;
 }
 
+static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *inmask,
+						  const struct cpumask *andmask)
+{
+	int num_bits_set;
+	int cpus_found = 0;
+	int cpu;
+	int apicid = 0xFF;
+	cpumask_var_t cpumask;
+
+	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
+		return (int) 0xFF;
+
+	cpumask_and(cpumask, inmask, andmask);
+	cpumask_and(cpumask, cpumask, cpu_online_mask);
+
+	num_bits_set = cpumask_weight(cpumask);
+	/* Return id to all */
+	if (num_bits_set == nr_cpu_ids)
+		goto exit;
+	/*
+	 * The cpus in the mask must all be on the apic cluster.  If are not
+	 * on the same apicid cluster return default value of TARGET_CPUS.
+	 */
+	cpu = cpumask_first(cpumask);
+	apicid = cpu_to_logical_apicid(cpu);
+	while (cpus_found < num_bits_set) {
+		if (cpumask_test_cpu(cpu, cpumask)) {
+			int new_apicid = cpu_to_logical_apicid(cpu);
+			if (apicid_cluster(apicid) !=
+					apicid_cluster(new_apicid)){
+				printk ("%s: Not a valid mask!\n", __func__);
+				return 0xFF;
+			}
+			apicid = apicid | new_apicid;
+			cpus_found++;
+		}
+		cpu++;
+	}
+exit:
+	free_cpumask_var(cpumask);
+	return apicid;
+}
+
 /* cpuid returns the value latched in the HW at reset, not the APIC ID
  * register's value.  For any box whose BIOS changes APIC IDs, like
  * clustered APIC systems, we must use hard_smp_processor_id.
diff --git a/arch/x86/include/asm/summit/ipi.h b/arch/x86/include/asm/summit/ipi.h
index 53bd1e7..a8a2c24 100644
--- a/arch/x86/include/asm/summit/ipi.h
+++ b/arch/x86/include/asm/summit/ipi.h
@@ -1,9 +1,10 @@
 #ifndef __ASM_SUMMIT_IPI_H
 #define __ASM_SUMMIT_IPI_H
 
-void send_IPI_mask_sequence(cpumask_t mask, int vector);
+void send_IPI_mask_sequence(const cpumask_t *mask, int vector);
+void send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
 
-static inline void send_IPI_mask(cpumask_t mask, int vector)
+static inline void send_IPI_mask(const cpumask_t *mask, int vector)
 {
 	send_IPI_mask_sequence(mask, vector);
 }
@@ -14,12 +15,12 @@ static inline void send_IPI_allbutself(int vector)
 	cpu_clear(smp_processor_id(), mask);
 
 	if (!cpus_empty(mask))
-		send_IPI_mask(mask, vector);
+		send_IPI_mask(&mask, vector);
 }
 
 static inline void send_IPI_all(int vector)
 {
-	send_IPI_mask(cpu_online_map, vector);
+	send_IPI_mask(&cpu_online_map, vector);
 }
 
 #endif /* __ASM_SUMMIT_IPI_H */
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index ff386ff..79e31e9 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -226,6 +226,8 @@ extern cpumask_t cpu_coregroup_map(int cpu);
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
 #define topology_core_siblings(cpu)		(per_cpu(cpu_core_map, cpu))
 #define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
+#define topology_core_cpumask(cpu)		(&per_cpu(cpu_core_map, cpu))
+#define topology_thread_cpumask(cpu)		(&per_cpu(cpu_sibling_map, cpu))
 
 /* indicates that pointers to the topology cpumask_t maps are valid */
 #define arch_provides_topology_pointers		yes
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index b5229af..6b7f824 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -119,8 +119,6 @@ EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
 
 int first_system_vector = 0xfe;
 
-char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
-
 /*
  * Debug level, exported for io_apic.c
  */
@@ -142,7 +140,7 @@ static int lapic_next_event(unsigned long delta,
 			    struct clock_event_device *evt);
 static void lapic_timer_setup(enum clock_event_mode mode,
 			      struct clock_event_device *evt);
-static void lapic_timer_broadcast(cpumask_t mask);
+static void lapic_timer_broadcast(const cpumask_t *mask);
 static void apic_pm_activate(void);
 
 /*
@@ -455,7 +453,7 @@ static void lapic_timer_setup(enum clock_event_mode mode,
 /*
  * Local APIC timer broadcast function
  */
-static void lapic_timer_broadcast(cpumask_t mask)
+static void lapic_timer_broadcast(const cpumask_t *mask)
 {
 #ifdef CONFIG_SMP
 	send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
@@ -471,7 +469,7 @@ static void __cpuinit setup_APIC_timer(void)
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 
 	memcpy(levt, &lapic_clockevent, sizeof(*levt));
-	levt->cpumask = cpumask_of_cpu(smp_processor_id());
+	levt->cpumask = cpumask_of(smp_processor_id());
 
 	clockevents_register_device(levt);
 }
@@ -1807,28 +1805,32 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 void __cpuinit generic_processor_info(int apicid, int version)
 {
 	int cpu;
-	cpumask_t tmp_map;
 
 	/*
 	 * Validate version
 	 */
 	if (version == 0x0) {
 		pr_warning("BIOS bug, APIC version is 0 for CPU#%d! "
-			"fixing up to 0x10. (tell your hw vendor)\n",
-			version);
+			   "fixing up to 0x10. (tell your hw vendor)\n",
+				version);
 		version = 0x10;
 	}
 	apic_version[apicid] = version;
 
-	if (num_processors >= NR_CPUS) {
-		pr_warning("WARNING: NR_CPUS limit of %i reached."
-			"  Processor ignored.\n", NR_CPUS);
+	if (num_processors >= nr_cpu_ids) {
+		int max = nr_cpu_ids;
+		int thiscpu = max + disabled_cpus;
+
+		pr_warning(
+			"ACPI: NR_CPUS/possible_cpus limit of %i reached."
+			"  Processor %d/0x%x ignored.\n", max, thiscpu, apicid);
+
+		disabled_cpus++;
 		return;
 	}
 
 	num_processors++;
-	cpus_complement(tmp_map, cpu_present_map);
-	cpu = first_cpu(tmp_map);
+	cpu = cpumask_next_zero(-1, cpu_present_mask);
 
 	physid_set(apicid, phys_cpu_present_map);
 	if (apicid == boot_cpu_physical_apicid) {
@@ -1878,8 +1880,8 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	}
 #endif
 
-	cpu_set(cpu, cpu_possible_map);
-	cpu_set(cpu, cpu_present_map);
+	set_cpu_possible(cpu, true);
+	set_cpu_present(cpu, true);
 }
 
 #ifdef CONFIG_X86_64
@@ -2081,7 +2083,7 @@ __cpuinit int apic_is_clustered_box(void)
 	bios_cpu_apicid = early_per_cpu_ptr(x86_bios_cpu_apicid);
 	bitmap_zero(clustermap, NUM_APIC_CLUSTERS);
 
-	for (i = 0; i < NR_CPUS; i++) {
+	for (i = 0; i < nr_cpu_ids; i++) {
 		/* are we being called early in kernel startup? */
 		if (bios_cpu_apicid) {
 			id = bios_cpu_apicid[i];
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 68b5d86..48533d7 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -534,31 +534,16 @@ static void __cpuinit free_cache_attributes(unsigned int cpu)
 	per_cpu(cpuid4_info, cpu) = NULL;
 }
 
-static int __cpuinit detect_cache_attributes(unsigned int cpu)
+static void __cpuinit get_cpu_leaves(void *_retval)
 {
-	struct _cpuid4_info	*this_leaf;
-	unsigned long		j;
-	int			retval;
-	cpumask_t		oldmask;
-
-	if (num_cache_leaves == 0)
-		return -ENOENT;
-
-	per_cpu(cpuid4_info, cpu) = kzalloc(
-	    sizeof(struct _cpuid4_info) * num_cache_leaves, GFP_KERNEL);
-	if (per_cpu(cpuid4_info, cpu) == NULL)
-		return -ENOMEM;
-
-	oldmask = current->cpus_allowed;
-	retval = set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-	if (retval)
-		goto out;
+	int j, *retval = _retval, cpu = smp_processor_id();
 
 	/* Do cpuid and store the results */
 	for (j = 0; j < num_cache_leaves; j++) {
+		struct _cpuid4_info *this_leaf;
 		this_leaf = CPUID4_INFO_IDX(cpu, j);
-		retval = cpuid4_cache_lookup(j, this_leaf);
-		if (unlikely(retval < 0)) {
+		*retval = cpuid4_cache_lookup(j, this_leaf);
+		if (unlikely(*retval < 0)) {
 			int i;
 
 			for (i = 0; i < j; i++)
@@ -567,9 +552,21 @@ static int __cpuinit detect_cache_attributes(unsigned int cpu)
 		}
 		cache_shared_cpu_map_setup(cpu, j);
 	}
-	set_cpus_allowed_ptr(current, &oldmask);
+}
+
+static int __cpuinit detect_cache_attributes(unsigned int cpu)
+{
+	int			retval;
+
+	if (num_cache_leaves == 0)
+		return -ENOENT;
+
+	per_cpu(cpuid4_info, cpu) = kzalloc(
+	    sizeof(struct _cpuid4_info) * num_cache_leaves, GFP_KERNEL);
+	if (per_cpu(cpuid4_info, cpu) == NULL)
+		return -ENOMEM;
 
-out:
+	smp_call_function_single(cpu, get_cpu_leaves, &retval, true);
 	if (retval) {
 		kfree(per_cpu(cpuid4_info, cpu));
 		per_cpu(cpuid4_info, cpu) = NULL;
@@ -626,8 +623,8 @@ static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
 		cpumask_t *mask = &this_leaf->shared_cpu_map;
 
 		n = type?
-			cpulist_scnprintf(buf, len-2, *mask):
-			cpumask_scnprintf(buf, len-2, *mask);
+			cpulist_scnprintf(buf, len-2, mask) :
+			cpumask_scnprintf(buf, len-2, mask);
 		buf[n++] = '\n';
 		buf[n] = '\0';
 	}
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index 748c8f9..a5a5e05 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -83,34 +83,41 @@ static DEFINE_PER_CPU(unsigned char, bank_map);	/* see which banks are on */
  * CPU Initialization
  */
 
+struct thresh_restart {
+	struct threshold_block *b;
+	int reset;
+	u16 old_limit;
+};
+
 /* must be called with correct cpu affinity */
-static void threshold_restart_bank(struct threshold_block *b,
-				   int reset, u16 old_limit)
+static long threshold_restart_bank(void *_tr)
 {
+	struct thresh_restart *tr = _tr;
 	u32 mci_misc_hi, mci_misc_lo;
 
-	rdmsr(b->address, mci_misc_lo, mci_misc_hi);
+	rdmsr(tr->b->address, mci_misc_lo, mci_misc_hi);
 
-	if (b->threshold_limit < (mci_misc_hi & THRESHOLD_MAX))
-		reset = 1;	/* limit cannot be lower than err count */
+	if (tr->b->threshold_limit < (mci_misc_hi & THRESHOLD_MAX))
+		tr->reset = 1;	/* limit cannot be lower than err count */
 
-	if (reset) {		/* reset err count and overflow bit */
+	if (tr->reset) {		/* reset err count and overflow bit */
 		mci_misc_hi =
 		    (mci_misc_hi & ~(MASK_ERR_COUNT_HI | MASK_OVERFLOW_HI)) |
-		    (THRESHOLD_MAX - b->threshold_limit);
-	} else if (old_limit) {	/* change limit w/o reset */
+		    (THRESHOLD_MAX - tr->b->threshold_limit);
+	} else if (tr->old_limit) {	/* change limit w/o reset */
 		int new_count = (mci_misc_hi & THRESHOLD_MAX) +
-		    (old_limit - b->threshold_limit);
+		    (tr->old_limit - tr->b->threshold_limit);
 		mci_misc_hi = (mci_misc_hi & ~MASK_ERR_COUNT_HI) |
 		    (new_count & THRESHOLD_MAX);
 	}
 
-	b->interrupt_enable ?
+	tr->b->interrupt_enable ?
 	    (mci_misc_hi = (mci_misc_hi & ~MASK_INT_TYPE_HI) | INT_TYPE_APIC) :
 	    (mci_misc_hi &= ~MASK_INT_TYPE_HI);
 
 	mci_misc_hi |= MASK_COUNT_EN_HI;
-	wrmsr(b->address, mci_misc_lo, mci_misc_hi);
+	wrmsr(tr->b->address, mci_misc_lo, mci_misc_hi);
+	return 0;
 }
 
 /* cpu init entry point, called from mce.c with preempt off */
@@ -120,6 +127,7 @@ void __cpuinit mce_amd_feature_init(struct cpuinfo_x86 *c)
 	unsigned int cpu = smp_processor_id();
 	u8 lvt_off;
 	u32 low = 0, high = 0, address = 0;
+	struct thresh_restart tr;
 
 	for (bank = 0; bank < NR_BANKS; ++bank) {
 		for (block = 0; block < NR_BLOCKS; ++block) {
@@ -162,7 +170,10 @@ void __cpuinit mce_amd_feature_init(struct cpuinfo_x86 *c)
 			wrmsr(address, low, high);
 
 			threshold_defaults.address = address;
-			threshold_restart_bank(&threshold_defaults, 0, 0);
+			tr.b = &threshold_defaults;
+			tr.reset = 0;
+			tr.old_limit = 0;
+			threshold_restart_bank(&tr);
 		}
 	}
 }
@@ -251,20 +262,6 @@ struct threshold_attr {
 	ssize_t(*store) (struct threshold_block *, const char *, size_t count);
 };
 
-static void affinity_set(unsigned int cpu, cpumask_t *oldmask,
-					   cpumask_t *newmask)
-{
-	*oldmask = current->cpus_allowed;
-	cpus_clear(*newmask);
-	cpu_set(cpu, *newmask);
-	set_cpus_allowed_ptr(current, newmask);
-}
-
-static void affinity_restore(const cpumask_t *oldmask)
-{
-	set_cpus_allowed_ptr(current, oldmask);
-}
-
 #define SHOW_FIELDS(name)                                           \
 static ssize_t show_ ## name(struct threshold_block * b, char *buf) \
 {                                                                   \
@@ -277,15 +274,16 @@ static ssize_t store_interrupt_enable(struct threshold_block *b,
 				      const char *buf, size_t count)
 {
 	char *end;
-	cpumask_t oldmask, newmask;
+	struct thresh_restart tr;
 	unsigned long new = simple_strtoul(buf, &end, 0);
 	if (end == buf)
 		return -EINVAL;
 	b->interrupt_enable = !!new;
 
-	affinity_set(b->cpu, &oldmask, &newmask);
-	threshold_restart_bank(b, 0, 0);
-	affinity_restore(&oldmask);
+	tr.b = b;
+	tr.reset = 0;
+	tr.old_limit = 0;
+	work_on_cpu(b->cpu, threshold_restart_bank, &tr);
 
 	return end - buf;
 }
@@ -294,8 +292,7 @@ static ssize_t store_threshold_limit(struct threshold_block *b,
 				     const char *buf, size_t count)
 {
 	char *end;
-	cpumask_t oldmask, newmask;
-	u16 old;
+	struct thresh_restart tr;
 	unsigned long new = simple_strtoul(buf, &end, 0);
 	if (end == buf)
 		return -EINVAL;
@@ -303,34 +300,36 @@ static ssize_t store_threshold_limit(struct threshold_block *b,
 		new = THRESHOLD_MAX;
 	if (new < 1)
 		new = 1;
-	old = b->threshold_limit;
+	tr.old_limit = b->threshold_limit;
 	b->threshold_limit = new;
+	tr.b = b;
+	tr.reset = 0;
 
-	affinity_set(b->cpu, &oldmask, &newmask);
-	threshold_restart_bank(b, 0, old);
-	affinity_restore(&oldmask);
+	work_on_cpu(b->cpu, threshold_restart_bank, &tr);
 
 	return end - buf;
 }
 
-static ssize_t show_error_count(struct threshold_block *b, char *buf)
+static long local_error_count(void *_b)
 {
-	u32 high, low;
-	cpumask_t oldmask, newmask;
-	affinity_set(b->cpu, &oldmask, &newmask);
+	struct threshold_block *b = _b;
+	u32 low, high;
+
 	rdmsr(b->address, low, high);
-	affinity_restore(&oldmask);
-	return sprintf(buf, "%x\n",
-		       (high & 0xFFF) - (THRESHOLD_MAX - b->threshold_limit));
+	return (high & 0xFFF) - (THRESHOLD_MAX - b->threshold_limit);
+}
+
+static ssize_t show_error_count(struct threshold_block *b, char *buf)
+{
+	return sprintf(buf, "%lx\n", work_on_cpu(b->cpu, local_error_count, b));
 }
 
 static ssize_t store_error_count(struct threshold_block *b,
 				 const char *buf, size_t count)
 {
-	cpumask_t oldmask, newmask;
-	affinity_set(b->cpu, &oldmask, &newmask);
-	threshold_restart_bank(b, 1, 0);
-	affinity_restore(&oldmask);
+	struct thresh_restart tr = { .b = b, .reset = 1, .old_limit = 0 };
+
+	work_on_cpu(b->cpu, threshold_restart_bank, &tr);
 	return 1;
 }
 
@@ -463,12 +462,19 @@ out_free:
 	return err;
 }
 
+static long local_allocate_threshold_blocks(void *_bank)
+{
+	unsigned int *bank = _bank;
+
+	return allocate_threshold_blocks(smp_processor_id(), *bank, 0,
+					 MSR_IA32_MC0_MISC + *bank * 4);
+}
+
 /* symlinks sibling shared banks to first core.  first core owns dir/files. */
 static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 {
 	int i, err = 0;
 	struct threshold_bank *b = NULL;
-	cpumask_t oldmask, newmask;
 	char name[32];
 
 	sprintf(name, "threshold_bank%i", bank);
@@ -519,11 +525,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
 
-	affinity_set(cpu, &oldmask, &newmask);
-	err = allocate_threshold_blocks(cpu, bank, 0,
-					MSR_IA32_MC0_MISC + bank * 4);
-	affinity_restore(&oldmask);
-
+	err = work_on_cpu(cpu, local_allocate_threshold_blocks, &bank);
 	if (err)
 		goto out_free;
 
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index c026279..3418548 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -30,12 +30,12 @@ static int flat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return 1;
 }
 
-static cpumask_t flat_target_cpus(void)
+static const struct cpumask *flat_target_cpus(void)
 {
-	return cpu_online_map;
+	return cpu_online_mask;
 }
 
-static cpumask_t flat_vector_allocation_domain(int cpu)
+static void flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -45,8 +45,8 @@ static cpumask_t flat_vector_allocation_domain(int cpu)
 	 * deliver interrupts to the wrong hyperthread when only one
 	 * hyperthread was specified in the interrupt desitination.
 	 */
-	cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
-	return domain;
+	cpumask_clear(retmask);
+	cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
 }
 
 /*
@@ -69,9 +69,8 @@ static void flat_init_apic_ldr(void)
 	apic_write(APIC_LDR, val);
 }
 
-static void flat_send_IPI_mask(cpumask_t cpumask, int vector)
+static inline void _flat_send_IPI_mask(unsigned long mask, int vector)
 {
-	unsigned long mask = cpus_addr(cpumask)[0];
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -79,20 +78,41 @@ static void flat_send_IPI_mask(cpumask_t cpumask, int vector)
 	local_irq_restore(flags);
 }
 
+static void flat_send_IPI_mask(const struct cpumask *cpumask, int vector)
+{
+	unsigned long mask = cpumask_bits(cpumask)[0];
+
+	_flat_send_IPI_mask(mask, vector);
+}
+
+static void flat_send_IPI_mask_allbutself(const struct cpumask *cpumask,
+					  int vector)
+{
+	unsigned long mask = cpumask_bits(cpumask)[0];
+	int cpu = smp_processor_id();
+
+	if (cpu < BITS_PER_LONG)
+		clear_bit(cpu, &mask);
+	_flat_send_IPI_mask(mask, vector);
+}
+
 static void flat_send_IPI_allbutself(int vector)
 {
+	int cpu = smp_processor_id();
 #ifdef	CONFIG_HOTPLUG_CPU
 	int hotplug = 1;
 #else
 	int hotplug = 0;
 #endif
 	if (hotplug || vector == NMI_VECTOR) {
-		cpumask_t allbutme = cpu_online_map;
+		if (!cpumask_equal(cpu_online_mask, cpumask_of(cpu))) {
+			unsigned long mask = cpumask_bits(cpu_online_mask)[0];
 
-		cpu_clear(smp_processor_id(), allbutme);
+			if (cpu < BITS_PER_LONG)
+				clear_bit(cpu, &mask);
 
-		if (!cpus_empty(allbutme))
-			flat_send_IPI_mask(allbutme, vector);
+			_flat_send_IPI_mask(mask, vector);
+		}
 	} else if (num_online_cpus() > 1) {
 		__send_IPI_shortcut(APIC_DEST_ALLBUT, vector,APIC_DEST_LOGICAL);
 	}
@@ -101,7 +121,7 @@ static void flat_send_IPI_allbutself(int vector)
 static void flat_send_IPI_all(int vector)
 {
 	if (vector == NMI_VECTOR)
-		flat_send_IPI_mask(cpu_online_map, vector);
+		flat_send_IPI_mask(cpu_online_mask, vector);
 	else
 		__send_IPI_shortcut(APIC_DEST_ALLINC, vector, APIC_DEST_LOGICAL);
 }
@@ -135,9 +155,18 @@ static int flat_apic_id_registered(void)
 	return physid_isset(read_xapic_id(), phys_cpu_present_map);
 }
 
-static unsigned int flat_cpu_mask_to_apicid(cpumask_t cpumask)
+static unsigned int flat_cpu_mask_to_apicid(const struct cpumask *cpumask)
+{
+	return cpumask_bits(cpumask)[0] & APIC_ALL_CPUS;
+}
+
+static unsigned int flat_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+						const struct cpumask *andmask)
 {
-	return cpus_addr(cpumask)[0] & APIC_ALL_CPUS;
+	unsigned long mask1 = cpumask_bits(cpumask)[0] & APIC_ALL_CPUS;
+	unsigned long mask2 = cpumask_bits(andmask)[0] & APIC_ALL_CPUS;
+
+	return mask1 & mask2;
 }
 
 static unsigned int phys_pkg_id(int index_msb)
@@ -157,8 +186,10 @@ struct genapic apic_flat =  {
 	.send_IPI_all = flat_send_IPI_all,
 	.send_IPI_allbutself = flat_send_IPI_allbutself,
 	.send_IPI_mask = flat_send_IPI_mask,
+	.send_IPI_mask_allbutself = flat_send_IPI_mask_allbutself,
 	.send_IPI_self = apic_send_IPI_self,
 	.cpu_mask_to_apicid = flat_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and = flat_cpu_mask_to_apicid_and,
 	.phys_pkg_id = phys_pkg_id,
 	.get_apic_id = get_apic_id,
 	.set_apic_id = set_apic_id,
@@ -188,35 +219,39 @@ static int physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return 0;
 }
 
-static cpumask_t physflat_target_cpus(void)
+static const struct cpumask *physflat_target_cpus(void)
 {
-	return cpu_online_map;
+	return cpu_online_mask;
 }
 
-static cpumask_t physflat_vector_allocation_domain(int cpu)
+static void physflat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
-	return cpumask_of_cpu(cpu);
+	cpumask_clear(retmask);
+	cpumask_set_cpu(cpu, retmask);
 }
 
-static void physflat_send_IPI_mask(cpumask_t cpumask, int vector)
+static void physflat_send_IPI_mask(const struct cpumask *cpumask, int vector)
 {
 	send_IPI_mask_sequence(cpumask, vector);
 }
 
-static void physflat_send_IPI_allbutself(int vector)
+static void physflat_send_IPI_mask_allbutself(const struct cpumask *cpumask,
+					      int vector)
 {
-	cpumask_t allbutme = cpu_online_map;
+	send_IPI_mask_allbutself(cpumask, vector);
+}
 
-	cpu_clear(smp_processor_id(), allbutme);
-	physflat_send_IPI_mask(allbutme, vector);
+static void physflat_send_IPI_allbutself(int vector)
+{
+	send_IPI_mask_allbutself(cpu_online_mask, vector);
 }
 
 static void physflat_send_IPI_all(int vector)
 {
-	physflat_send_IPI_mask(cpu_online_map, vector);
+	physflat_send_IPI_mask(cpu_online_mask, vector);
 }
 
-static unsigned int physflat_cpu_mask_to_apicid(cpumask_t cpumask)
+static unsigned int physflat_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
 	int cpu;
 
@@ -224,13 +259,31 @@ static unsigned int physflat_cpu_mask_to_apicid(cpumask_t cpumask)
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(cpumask);
+	cpu = cpumask_first(cpumask);
 	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
 		return BAD_APICID;
 }
 
+static unsigned int
+physflat_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+				const struct cpumask *andmask)
+{
+	int cpu;
+
+	/*
+	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * May as well be the first.
+	 */
+	for_each_cpu_and(cpu, cpumask, andmask)
+		if (cpumask_test_cpu(cpu, cpu_online_mask))
+			break;
+	if (cpu < nr_cpu_ids)
+		return per_cpu(x86_cpu_to_apicid, cpu);
+	return BAD_APICID;
+}
+
 struct genapic apic_physflat =  {
 	.name = "physical flat",
 	.acpi_madt_oem_check = physflat_acpi_madt_oem_check,
@@ -243,8 +296,10 @@ struct genapic apic_physflat =  {
 	.send_IPI_all = physflat_send_IPI_all,
 	.send_IPI_allbutself = physflat_send_IPI_allbutself,
 	.send_IPI_mask = physflat_send_IPI_mask,
+	.send_IPI_mask_allbutself = physflat_send_IPI_mask_allbutself,
 	.send_IPI_self = apic_send_IPI_self,
 	.cpu_mask_to_apicid = physflat_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and = physflat_cpu_mask_to_apicid_and,
 	.phys_pkg_id = phys_pkg_id,
 	.get_apic_id = get_apic_id,
 	.set_apic_id = set_apic_id,
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index f6a2c8e..6ce497c 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -22,19 +22,18 @@ static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
 
-static cpumask_t x2apic_target_cpus(void)
+static const struct cpumask *x2apic_target_cpus(void)
 {
-	return cpumask_of_cpu(0);
+	return cpumask_of(0);
 }
 
 /*
  * for now each logical cpu is in its own vector allocation domain.
  */
-static cpumask_t x2apic_vector_allocation_domain(int cpu)
+static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
-	cpumask_t domain = CPU_MASK_NONE;
-	cpu_set(cpu, domain);
-	return domain;
+	cpumask_clear(retmask);
+	cpumask_set_cpu(cpu, retmask);
 }
 
 static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
@@ -56,32 +55,53 @@ static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
  * at once. We have 16 cpu's in a cluster. This will minimize IPI register
  * writes.
  */
-static void x2apic_send_IPI_mask(cpumask_t mask, int vector)
+static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
 {
 	unsigned long flags;
 	unsigned long query_cpu;
 
 	local_irq_save(flags);
-	for_each_cpu_mask(query_cpu, mask) {
-		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-				       vector, APIC_DEST_LOGICAL);
-	}
+	for_each_cpu(query_cpu, mask)
+		__x2apic_send_IPI_dest(
+			per_cpu(x86_cpu_to_logical_apicid, query_cpu),
+			vector, APIC_DEST_LOGICAL);
 	local_irq_restore(flags);
 }
 
-static void x2apic_send_IPI_allbutself(int vector)
+static void x2apic_send_IPI_mask_allbutself(const struct cpumask *mask,
+					    int vector)
 {
-	cpumask_t mask = cpu_online_map;
+	unsigned long flags;
+	unsigned long query_cpu;
+	unsigned long this_cpu = smp_processor_id();
 
-	cpu_clear(smp_processor_id(), mask);
+	local_irq_save(flags);
+	for_each_cpu(query_cpu, mask)
+		if (query_cpu != this_cpu)
+			__x2apic_send_IPI_dest(
+				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
+				vector, APIC_DEST_LOGICAL);
+	local_irq_restore(flags);
+}
+
+static void x2apic_send_IPI_allbutself(int vector)
+{
+	unsigned long flags;
+	unsigned long query_cpu;
+	unsigned long this_cpu = smp_processor_id();
 
-	if (!cpus_empty(mask))
-		x2apic_send_IPI_mask(mask, vector);
+	local_irq_save(flags);
+	for_each_online_cpu(query_cpu)
+		if (query_cpu != this_cpu)
+			__x2apic_send_IPI_dest(
+				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
+				vector, APIC_DEST_LOGICAL);
+	local_irq_restore(flags);
 }
 
 static void x2apic_send_IPI_all(int vector)
 {
-	x2apic_send_IPI_mask(cpu_online_map, vector);
+	x2apic_send_IPI_mask(cpu_online_mask, vector);
 }
 
 static int x2apic_apic_id_registered(void)
@@ -89,21 +109,38 @@ static int x2apic_apic_id_registered(void)
 	return 1;
 }
 
-static unsigned int x2apic_cpu_mask_to_apicid(cpumask_t cpumask)
+static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
 	int cpu;
 
 	/*
-	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * We're using fixed IRQ delivery, can only return one logical APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(cpumask);
-	if ((unsigned)cpu < NR_CPUS)
+	cpu = cpumask_first(cpumask);
+	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_logical_apicid, cpu);
 	else
 		return BAD_APICID;
 }
 
+static unsigned int x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+						  const struct cpumask *andmask)
+{
+	int cpu;
+
+	/*
+	 * We're using fixed IRQ delivery, can only return one logical APIC ID.
+	 * May as well be the first.
+	 */
+	for_each_cpu_and(cpu, cpumask, andmask)
+		if (cpumask_test_cpu(cpu, cpu_online_mask))
+			break;
+	if (cpu < nr_cpu_ids)
+		return per_cpu(x86_cpu_to_logical_apicid, cpu);
+	return BAD_APICID;
+}
+
 static unsigned int get_apic_id(unsigned long x)
 {
 	unsigned int id;
@@ -150,8 +187,10 @@ struct genapic apic_x2apic_cluster = {
 	.send_IPI_all = x2apic_send_IPI_all,
 	.send_IPI_allbutself = x2apic_send_IPI_allbutself,
 	.send_IPI_mask = x2apic_send_IPI_mask,
+	.send_IPI_mask_allbutself = x2apic_send_IPI_mask_allbutself,
 	.send_IPI_self = x2apic_send_IPI_self,
 	.cpu_mask_to_apicid = x2apic_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and = x2apic_cpu_mask_to_apicid_and,
 	.phys_pkg_id = phys_pkg_id,
 	.get_apic_id = get_apic_id,
 	.set_apic_id = set_apic_id,
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index d042211..62895cf 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -29,16 +29,15 @@ static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
 
-static cpumask_t x2apic_target_cpus(void)
+static const struct cpumask *x2apic_target_cpus(void)
 {
-	return cpumask_of_cpu(0);
+	return cpumask_of(0);
 }
 
-static cpumask_t x2apic_vector_allocation_domain(int cpu)
+static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
-	cpumask_t domain = CPU_MASK_NONE;
-	cpu_set(cpu, domain);
-	return domain;
+	cpumask_clear(retmask);
+	cpumask_set_cpu(cpu, retmask);
 }
 
 static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
@@ -54,32 +53,54 @@ static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
 	x2apic_icr_write(cfg, apicid);
 }
 
-static void x2apic_send_IPI_mask(cpumask_t mask, int vector)
+static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
 {
 	unsigned long flags;
 	unsigned long query_cpu;
 
 	local_irq_save(flags);
-	for_each_cpu_mask(query_cpu, mask) {
+	for_each_cpu(query_cpu, mask) {
 		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
 				       vector, APIC_DEST_PHYSICAL);
 	}
 	local_irq_restore(flags);
 }
 
-static void x2apic_send_IPI_allbutself(int vector)
+static void x2apic_send_IPI_mask_allbutself(const struct cpumask *mask,
+					    int vector)
 {
-	cpumask_t mask = cpu_online_map;
+	unsigned long flags;
+	unsigned long query_cpu;
+	unsigned long this_cpu = smp_processor_id();
+
+	local_irq_save(flags);
+	for_each_cpu(query_cpu, mask) {
+		if (query_cpu != this_cpu)
+			__x2apic_send_IPI_dest(
+				per_cpu(x86_cpu_to_apicid, query_cpu),
+				vector, APIC_DEST_PHYSICAL);
+	}
+	local_irq_restore(flags);
+}
 
-	cpu_clear(smp_processor_id(), mask);
+static void x2apic_send_IPI_allbutself(int vector)
+{
+	unsigned long flags;
+	unsigned long query_cpu;
+	unsigned long this_cpu = smp_processor_id();
 
-	if (!cpus_empty(mask))
-		x2apic_send_IPI_mask(mask, vector);
+	local_irq_save(flags);
+	for_each_online_cpu(query_cpu)
+		if (query_cpu != this_cpu)
+			__x2apic_send_IPI_dest(
+				per_cpu(x86_cpu_to_apicid, query_cpu),
+				vector, APIC_DEST_PHYSICAL);
+	local_irq_restore(flags);
 }
 
 static void x2apic_send_IPI_all(int vector)
 {
-	x2apic_send_IPI_mask(cpu_online_map, vector);
+	x2apic_send_IPI_mask(cpu_online_mask, vector);
 }
 
 static int x2apic_apic_id_registered(void)
@@ -87,7 +108,7 @@ static int x2apic_apic_id_registered(void)
 	return 1;
 }
 
-static unsigned int x2apic_cpu_mask_to_apicid(cpumask_t cpumask)
+static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
 	int cpu;
 
@@ -95,13 +116,30 @@ static unsigned int x2apic_cpu_mask_to_apicid(cpumask_t cpumask)
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(cpumask);
-	if ((unsigned)cpu < NR_CPUS)
+	cpu = cpumask_first(cpumask);
+	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
 		return BAD_APICID;
 }
 
+static unsigned int x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+						  const struct cpumask *andmask)
+{
+	int cpu;
+
+	/*
+	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * May as well be the first.
+	 */
+	for_each_cpu_and(cpu, cpumask, andmask)
+		if (cpumask_test_cpu(cpu, cpu_online_mask))
+			break;
+	if (cpu < nr_cpu_ids)
+		return per_cpu(x86_cpu_to_apicid, cpu);
+	return BAD_APICID;
+}
+
 static unsigned int get_apic_id(unsigned long x)
 {
 	unsigned int id;
@@ -145,8 +183,10 @@ struct genapic apic_x2apic_phys = {
 	.send_IPI_all = x2apic_send_IPI_all,
 	.send_IPI_allbutself = x2apic_send_IPI_allbutself,
 	.send_IPI_mask = x2apic_send_IPI_mask,
+	.send_IPI_mask_allbutself = x2apic_send_IPI_mask_allbutself,
 	.send_IPI_self = x2apic_send_IPI_self,
 	.cpu_mask_to_apicid = x2apic_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and = x2apic_cpu_mask_to_apicid_and,
 	.phys_pkg_id = phys_pkg_id,
 	.get_apic_id = get_apic_id,
 	.set_apic_id = set_apic_id,
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index dece172..b193e08 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -79,16 +79,15 @@ EXPORT_SYMBOL(sn_rtc_cycles_per_second);
 
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
 
-static cpumask_t uv_target_cpus(void)
+static const struct cpumask *uv_target_cpus(void)
 {
-	return cpumask_of_cpu(0);
+	return cpumask_of(0);
 }
 
-static cpumask_t uv_vector_allocation_domain(int cpu)
+static void uv_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
-	cpumask_t domain = CPU_MASK_NONE;
-	cpu_set(cpu, domain);
-	return domain;
+	cpumask_clear(retmask);
+	cpumask_set_cpu(cpu, retmask);
 }
 
 int uv_wakeup_secondary(int phys_apicid, unsigned int start_rip)
@@ -127,28 +126,37 @@ static void uv_send_IPI_one(int cpu, int vector)
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }
 
-static void uv_send_IPI_mask(cpumask_t mask, int vector)
+static void uv_send_IPI_mask(const struct cpumask *mask, int vector)
 {
 	unsigned int cpu;
 
-	for_each_possible_cpu(cpu)
-		if (cpu_isset(cpu, mask))
+	for_each_cpu(cpu, mask)
+		uv_send_IPI_one(cpu, vector);
+}
+
+static void uv_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
+{
+	unsigned int cpu;
+	unsigned int this_cpu = smp_processor_id();
+
+	for_each_cpu(cpu, mask)
+		if (cpu != this_cpu)
 			uv_send_IPI_one(cpu, vector);
 }
 
 static void uv_send_IPI_allbutself(int vector)
 {
-	cpumask_t mask = cpu_online_map;
-
-	cpu_clear(smp_processor_id(), mask);
+	unsigned int cpu;
+	unsigned int this_cpu = smp_processor_id();
 
-	if (!cpus_empty(mask))
-		uv_send_IPI_mask(mask, vector);
+	for_each_online_cpu(cpu)
+		if (cpu != this_cpu)
+			uv_send_IPI_one(cpu, vector);
 }
 
 static void uv_send_IPI_all(int vector)
 {
-	uv_send_IPI_mask(cpu_online_map, vector);
+	uv_send_IPI_mask(cpu_online_mask, vector);
 }
 
 static int uv_apic_id_registered(void)
@@ -160,7 +168,7 @@ static void uv_init_apic_ldr(void)
 {
 }
 
-static unsigned int uv_cpu_mask_to_apicid(cpumask_t cpumask)
+static unsigned int uv_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
 	int cpu;
 
@@ -168,13 +176,30 @@ static unsigned int uv_cpu_mask_to_apicid(cpumask_t cpumask)
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(cpumask);
+	cpu = cpumask_first(cpumask);
 	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
 		return BAD_APICID;
 }
 
+static unsigned int uv_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+					      const struct cpumask *andmask)
+{
+	int cpu;
+
+	/*
+	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * May as well be the first.
+	 */
+	for_each_cpu_and(cpu, cpumask, andmask)
+		if (cpumask_test_cpu(cpu, cpu_online_mask))
+			break;
+	if (cpu < nr_cpu_ids)
+		return per_cpu(x86_cpu_to_apicid, cpu);
+	return BAD_APICID;
+}
+
 static unsigned int get_apic_id(unsigned long x)
 {
 	unsigned int id;
@@ -222,8 +247,10 @@ struct genapic apic_x2apic_uv_x = {
 	.send_IPI_all = uv_send_IPI_all,
 	.send_IPI_allbutself = uv_send_IPI_allbutself,
 	.send_IPI_mask = uv_send_IPI_mask,
+	.send_IPI_mask_allbutself = uv_send_IPI_mask_allbutself,
 	.send_IPI_self = uv_send_IPI_self,
 	.cpu_mask_to_apicid = uv_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and = uv_cpu_mask_to_apicid_and,
 	.phys_pkg_id = phys_pkg_id,
 	.get_apic_id = get_apic_id,
 	.set_apic_id = set_apic_id,
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 845ea09..cd759ad 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -248,7 +248,7 @@ static void hpet_legacy_clockevent_register(void)
 	 * Start hpet with the boot cpu mask and make it
 	 * global after the IO_APIC has been initialized.
 	 */
-	hpet_clockevent.cpumask = cpumask_of_cpu(smp_processor_id());
+	hpet_clockevent.cpumask = cpumask_of(smp_processor_id());
 	clockevents_register_device(&hpet_clockevent);
 	global_clock_event = &hpet_clockevent;
 	printk(KERN_DEBUG "hpet clockevent registered\n");
@@ -303,7 +303,7 @@ static void hpet_set_mode(enum clock_event_mode mode,
 			struct hpet_dev *hdev = EVT_TO_HPET_DEV(evt);
 			hpet_setup_msi_irq(hdev->irq);
 			disable_irq(hdev->irq);
-			irq_set_affinity(hdev->irq, cpumask_of_cpu(hdev->cpu));
+			irq_set_affinity(hdev->irq, cpumask_of(hdev->cpu));
 			enable_irq(hdev->irq);
 		}
 		break;
@@ -451,7 +451,7 @@ static int hpet_setup_irq(struct hpet_dev *dev)
 		return -1;
 
 	disable_irq(dev->irq);
-	irq_set_affinity(dev->irq, cpumask_of_cpu(dev->cpu));
+	irq_set_affinity(dev->irq, cpumask_of(dev->cpu));
 	enable_irq(dev->irq);
 
 	printk(KERN_DEBUG "hpet: %s irq %d for MSI\n",
@@ -502,7 +502,7 @@ static void init_one_hpet_msi_clockevent(struct hpet_dev *hdev, int cpu)
 	/* 5 usec minimum reprogramming delta. */
 	evt->min_delta_ns = 5000;
 
-	evt->cpumask = cpumask_of_cpu(hdev->cpu);
+	evt->cpumask = cpumask_of(hdev->cpu);
 	clockevents_register_device(evt);
 }
 
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index c1b5e3e..10f92fb 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -114,7 +114,7 @@ void __init setup_pit_timer(void)
 	 * Start pit with the boot cpu mask and make it global after the
 	 * IO_APIC has been initialized.
 	 */
-	pit_clockevent.cpumask = cpumask_of_cpu(smp_processor_id());
+	pit_clockevent.cpumask = cpumask_of(smp_processor_id());
 	pit_clockevent.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC,
 				     pit_clockevent.shift);
 	pit_clockevent.max_delta_ns =
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 7491765..62ecfc9 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -136,8 +136,8 @@ static struct irq_pin_list *get_one_free_irq_2_pin(int cpu)
 
 struct irq_cfg {
 	struct irq_pin_list *irq_2_pin;
-	cpumask_t domain;
-	cpumask_t old_domain;
+	cpumask_var_t domain;
+	cpumask_var_t old_domain;
 	unsigned move_cleanup_count;
 	u8 vector;
 	u8 move_in_progress : 1;
@@ -152,22 +152,22 @@ static struct irq_cfg irq_cfgx[] = {
 #else
 static struct irq_cfg irq_cfgx[NR_IRQS] = {
 #endif
-	[0]  = { .domain = CPU_MASK_ALL, .vector = IRQ0_VECTOR,  },
-	[1]  = { .domain = CPU_MASK_ALL, .vector = IRQ1_VECTOR,  },
-	[2]  = { .domain = CPU_MASK_ALL, .vector = IRQ2_VECTOR,  },
-	[3]  = { .domain = CPU_MASK_ALL, .vector = IRQ3_VECTOR,  },
-	[4]  = { .domain = CPU_MASK_ALL, .vector = IRQ4_VECTOR,  },
-	[5]  = { .domain = CPU_MASK_ALL, .vector = IRQ5_VECTOR,  },
-	[6]  = { .domain = CPU_MASK_ALL, .vector = IRQ6_VECTOR,  },
-	[7]  = { .domain = CPU_MASK_ALL, .vector = IRQ7_VECTOR,  },
-	[8]  = { .domain = CPU_MASK_ALL, .vector = IRQ8_VECTOR,  },
-	[9]  = { .domain = CPU_MASK_ALL, .vector = IRQ9_VECTOR,  },
-	[10] = { .domain = CPU_MASK_ALL, .vector = IRQ10_VECTOR, },
-	[11] = { .domain = CPU_MASK_ALL, .vector = IRQ11_VECTOR, },
-	[12] = { .domain = CPU_MASK_ALL, .vector = IRQ12_VECTOR, },
-	[13] = { .domain = CPU_MASK_ALL, .vector = IRQ13_VECTOR, },
-	[14] = { .domain = CPU_MASK_ALL, .vector = IRQ14_VECTOR, },
-	[15] = { .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
+	[0]  = { .vector = IRQ0_VECTOR,  },
+	[1]  = { .vector = IRQ1_VECTOR,  },
+	[2]  = { .vector = IRQ2_VECTOR,  },
+	[3]  = { .vector = IRQ3_VECTOR,  },
+	[4]  = { .vector = IRQ4_VECTOR,  },
+	[5]  = { .vector = IRQ5_VECTOR,  },
+	[6]  = { .vector = IRQ6_VECTOR,  },
+	[7]  = { .vector = IRQ7_VECTOR,  },
+	[8]  = { .vector = IRQ8_VECTOR,  },
+	[9]  = { .vector = IRQ9_VECTOR,  },
+	[10] = { .vector = IRQ10_VECTOR, },
+	[11] = { .vector = IRQ11_VECTOR, },
+	[12] = { .vector = IRQ12_VECTOR, },
+	[13] = { .vector = IRQ13_VECTOR, },
+	[14] = { .vector = IRQ14_VECTOR, },
+	[15] = { .vector = IRQ15_VECTOR, },
 };
 
 int __init arch_early_irq_init(void)
@@ -183,6 +183,10 @@ int __init arch_early_irq_init(void)
 	for (i = 0; i < count; i++) {
 		desc = irq_to_desc(i);
 		desc->chip_data = &cfg[i];
+		alloc_bootmem_cpumask_var(&cfg[i].domain);
+		alloc_bootmem_cpumask_var(&cfg[i].old_domain);
+		if (i < NR_IRQS_LEGACY)
+			cpumask_setall(cfg[i].domain);
 	}
 
 	return 0;
@@ -209,6 +213,20 @@ static struct irq_cfg *get_one_free_irq_cfg(int cpu)
 	node = cpu_to_node(cpu);
 
 	cfg = kzalloc_node(sizeof(*cfg), GFP_ATOMIC, node);
+	if (cfg) {
+		/* FIXME: needs alloc_cpumask_var_node() */
+		if (!alloc_cpumask_var(&cfg->domain, GFP_ATOMIC)) {
+			kfree(cfg);
+			cfg = NULL;
+		} else if (!alloc_cpumask_var(&cfg->old_domain, GFP_ATOMIC)) {
+			free_cpumask_var(cfg->domain);
+			kfree(cfg);
+			cfg = NULL;
+		} else {
+			cpumask_clear(cfg->domain);
+			cpumask_clear(cfg->old_domain);
+		}
+	}
 	printk(KERN_DEBUG "  alloc irq_cfg on cpu %d node %d\n", cpu, node);
 
 	return cfg;
@@ -333,13 +351,14 @@ void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
 	}
 }
 
-static void set_extra_move_desc(struct irq_desc *desc, cpumask_t mask)
+static void
+set_extra_move_desc(struct irq_desc *desc, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg = desc->chip_data;
 
 	if (!cfg->move_in_progress) {
 		/* it means that domain is not changed */
-		if (!cpus_intersects(desc->affinity, mask))
+		if (!cpumask_intersects(&desc->affinity, mask))
 			cfg->move_desc_pending = 1;
 	}
 }
@@ -354,7 +373,8 @@ static struct irq_cfg *irq_cfg(unsigned int irq)
 #endif
 
 #ifndef CONFIG_NUMA_MIGRATE_IRQ_DESC
-static inline void set_extra_move_desc(struct irq_desc *desc, cpumask_t mask)
+static inline void
+set_extra_move_desc(struct irq_desc *desc, const struct cpumask *mask)
 {
 }
 #endif
@@ -485,6 +505,26 @@ static void ioapic_mask_entry(int apic, int pin)
 }
 
 #ifdef CONFIG_SMP
+static void send_cleanup_vector(struct irq_cfg *cfg)
+{
+	cpumask_var_t cleanup_mask;
+
+	if (unlikely(!alloc_cpumask_var(&cleanup_mask, GFP_ATOMIC))) {
+		unsigned int i;
+		cfg->move_cleanup_count = 0;
+		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
+			cfg->move_cleanup_count++;
+		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
+			send_IPI_mask(cpumask_of(i), IRQ_MOVE_CLEANUP_VECTOR);
+	} else {
+		cpumask_and(cleanup_mask, cfg->old_domain, cpu_online_mask);
+		cfg->move_cleanup_count = cpumask_weight(cleanup_mask);
+		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		free_cpumask_var(cleanup_mask);
+	}
+	cfg->move_in_progress = 0;
+}
+
 static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq_cfg *cfg)
 {
 	int apic, pin;
@@ -520,41 +560,55 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
 	}
 }
 
-static int assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask);
+static int
+assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask);
 
-static void set_ioapic_affinity_irq_desc(struct irq_desc *desc, cpumask_t mask)
+/*
+ * Either sets desc->affinity to a valid value, and returns cpu_mask_to_apicid
+ * of that, or returns BAD_APICID and leaves desc->affinity untouched.
+ */
+static unsigned int
+set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
-	unsigned long flags;
-	unsigned int dest;
-	cpumask_t tmp;
 	unsigned int irq;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
-		return;
+	if (!cpumask_intersects(mask, cpu_online_mask))
+		return BAD_APICID;
 
 	irq = desc->irq;
 	cfg = desc->chip_data;
 	if (assign_irq_vector(irq, cfg, mask))
-		return;
+		return BAD_APICID;
 
+	cpumask_and(&desc->affinity, cfg->domain, mask);
 	set_extra_move_desc(desc, mask);
+	return cpu_mask_to_apicid_and(&desc->affinity, cpu_online_mask);
+}
 
-	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
-	/*
-	 * Only the high 8 bits are valid.
-	 */
-	dest = SET_APIC_LOGICAL_ID(dest);
+static void
+set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
+{
+	struct irq_cfg *cfg;
+	unsigned long flags;
+	unsigned int dest;
+	unsigned int irq;
+
+	irq = desc->irq;
+	cfg = desc->chip_data;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	__target_IO_APIC_irq(irq, dest, cfg);
-	desc->affinity = mask;
+	dest = set_desc_affinity(desc, mask);
+	if (dest != BAD_APICID) {
+		/* Only the high 8 bits are valid. */
+		dest = SET_APIC_LOGICAL_ID(dest);
+		__target_IO_APIC_irq(irq, dest, cfg);
+	}
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+static void
+set_ioapic_affinity_irq(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc;
 
@@ -1222,7 +1276,8 @@ void unlock_vector_lock(void)
 	spin_unlock(&vector_lock);
 }
 
-static int __assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask)
+static int
+__assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 {
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -1237,49 +1292,49 @@ static int __assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask)
 	 */
 	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
 	unsigned int old_vector;
-	int cpu;
+	int cpu, err;
+	cpumask_var_t tmp_mask;
 
 	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
 		return -EBUSY;
 
-	/* Only try and allocate irqs on cpus that are present */
-	cpus_and(mask, mask, cpu_online_map);
+	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
+		return -ENOMEM;
 
 	old_vector = cfg->vector;
 	if (old_vector) {
-		cpumask_t tmp;
-		cpus_and(tmp, cfg->domain, mask);
-		if (!cpus_empty(tmp))
+		cpumask_and(tmp_mask, mask, cpu_online_mask);
+		cpumask_and(tmp_mask, cfg->domain, tmp_mask);
+		if (!cpumask_empty(tmp_mask)) {
+			free_cpumask_var(tmp_mask);
 			return 0;
+		}
 	}
 
-	for_each_cpu_mask_nr(cpu, mask) {
-		cpumask_t domain, new_mask;
+	/* Only try and allocate irqs on cpus that are present */
+	err = -ENOSPC;
+	for_each_cpu_and(cpu, mask, cpu_online_mask) {
 		int new_cpu;
 		int vector, offset;
 
-		domain = vector_allocation_domain(cpu);
-		cpus_and(new_mask, domain, cpu_online_map);
+		vector_allocation_domain(cpu, tmp_mask);
 
 		vector = current_vector;
 		offset = current_offset;
 next:
 		vector += 8;
 		if (vector >= first_system_vector) {
-			/* If we run out of vectors on large boxen, must share them. */
+			/* If out of vectors on large boxen, must share them. */
 			offset = (offset + 1) % 8;
 			vector = FIRST_DEVICE_VECTOR + offset;
 		}
 		if (unlikely(current_vector == vector))
 			continue;
-#ifdef CONFIG_X86_64
-		if (vector == IA32_SYSCALL_VECTOR)
-			goto next;
-#else
-		if (vector == SYSCALL_VECTOR)
+
+		if (test_bit(vector, used_vectors))
 			goto next;
-#endif
-		for_each_cpu_mask_nr(new_cpu, new_mask)
+
+		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
 			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
 				goto next;
 		/* Found one! */
@@ -1287,18 +1342,21 @@ next:
 		current_offset = offset;
 		if (old_vector) {
 			cfg->move_in_progress = 1;
-			cfg->old_domain = cfg->domain;
+			cpumask_copy(cfg->old_domain, cfg->domain);
 		}
-		for_each_cpu_mask_nr(new_cpu, new_mask)
+		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
 		cfg->vector = vector;
-		cfg->domain = domain;
-		return 0;
+		cpumask_copy(cfg->domain, tmp_mask);
+		err = 0;
+		break;
 	}
-	return -ENOSPC;
+	free_cpumask_var(tmp_mask);
+	return err;
 }
 
-static int assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask)
+static int
+assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 {
 	int err;
 	unsigned long flags;
@@ -1311,23 +1369,20 @@ static int assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask)
 
 static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 {
-	cpumask_t mask;
 	int cpu, vector;
 
 	BUG_ON(!cfg->vector);
 
 	vector = cfg->vector;
-	cpus_and(mask, cfg->domain, cpu_online_map);
-	for_each_cpu_mask_nr(cpu, mask)
+	for_each_cpu_and(cpu, cfg->domain, cpu_online_mask)
 		per_cpu(vector_irq, cpu)[vector] = -1;
 
 	cfg->vector = 0;
-	cpus_clear(cfg->domain);
+	cpumask_clear(cfg->domain);
 
 	if (likely(!cfg->move_in_progress))
 		return;
-	cpus_and(mask, cfg->old_domain, cpu_online_map);
-	for_each_cpu_mask_nr(cpu, mask) {
+	for_each_cpu_and(cpu, cfg->old_domain, cpu_online_mask) {
 		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
 								vector++) {
 			if (per_cpu(vector_irq, cpu)[vector] != irq)
@@ -1350,7 +1405,7 @@ void __setup_vector_irq(int cpu)
 	/* Mark the inuse vectors */
 	for_each_irq_desc(irq, desc) {
 		cfg = desc->chip_data;
-		if (!cpu_isset(cpu, cfg->domain))
+		if (!cpumask_test_cpu(cpu, cfg->domain))
 			continue;
 		vector = cfg->vector;
 		per_cpu(vector_irq, cpu)[vector] = irq;
@@ -1362,7 +1417,7 @@ void __setup_vector_irq(int cpu)
 			continue;
 
 		cfg = irq_cfg(irq);
-		if (!cpu_isset(cpu, cfg->domain))
+		if (!cpumask_test_cpu(cpu, cfg->domain))
 			per_cpu(vector_irq, cpu)[vector] = -1;
 	}
 }
@@ -1498,18 +1553,17 @@ static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq, struct irq_de
 {
 	struct irq_cfg *cfg;
 	struct IO_APIC_route_entry entry;
-	cpumask_t mask;
+	unsigned int dest;
 
 	if (!IO_APIC_IRQ(irq))
 		return;
 
 	cfg = desc->chip_data;
 
-	mask = TARGET_CPUS;
-	if (assign_irq_vector(irq, cfg, mask))
+	if (assign_irq_vector(irq, cfg, TARGET_CPUS))
 		return;
 
-	cpus_and(mask, cfg->domain, mask);
+	dest = cpu_mask_to_apicid_and(cfg->domain, TARGET_CPUS);
 
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
@@ -1519,8 +1573,7 @@ static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq, struct irq_de
 
 
 	if (setup_ioapic_entry(mp_ioapics[apic].mp_apicid, irq, &entry,
-			       cpu_mask_to_apicid(mask), trigger, polarity,
-			       cfg->vector)) {
+			       dest, trigger, polarity, cfg->vector)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 		       mp_ioapics[apic].mp_apicid, pin);
 		__clear_irq_vector(irq, cfg);
@@ -2240,7 +2293,7 @@ static int ioapic_retrigger_irq(unsigned int irq)
 	unsigned long flags;
 
 	spin_lock_irqsave(&vector_lock, flags);
-	send_IPI_mask(cpumask_of_cpu(first_cpu(cfg->domain)), cfg->vector);
+	send_IPI_mask(cpumask_of(cpumask_first(cfg->domain)), cfg->vector);
 	spin_unlock_irqrestore(&vector_lock, flags);
 
 	return 1;
@@ -2289,18 +2342,17 @@ static DECLARE_DELAYED_WORK(ir_migration_work, ir_irq_migration);
  * as simple as edge triggered migration and we can do the irq migration
  * with a simple atomic update to IO-APIC RTE.
  */
-static void migrate_ioapic_irq_desc(struct irq_desc *desc, cpumask_t mask)
+static void
+migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
-	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
 	int modify_ioapic_rte;
 	unsigned int dest;
 	unsigned long flags;
 	unsigned int irq;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
+	if (!cpumask_intersects(mask, cpu_online_mask))
 		return;
 
 	irq = desc->irq;
@@ -2313,8 +2365,7 @@ static void migrate_ioapic_irq_desc(struct irq_desc *desc, cpumask_t mask)
 
 	set_extra_move_desc(desc, mask);
 
-	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
+	dest = cpu_mask_to_apicid_and(cfg->domain, mask);
 
 	modify_ioapic_rte = desc->status & IRQ_LEVEL;
 	if (modify_ioapic_rte) {
@@ -2331,14 +2382,10 @@ static void migrate_ioapic_irq_desc(struct irq_desc *desc, cpumask_t mask)
 	 */
 	modify_irte(irq, &irte);
 
-	if (cfg->move_in_progress) {
-		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
-		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
-		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
-		cfg->move_in_progress = 0;
-	}
+	if (cfg->move_in_progress)
+		send_cleanup_vector(cfg);
 
-	desc->affinity = mask;
+	cpumask_copy(&desc->affinity, mask);
 }
 
 static int migrate_irq_remapped_level_desc(struct irq_desc *desc)
@@ -2360,11 +2407,11 @@ static int migrate_irq_remapped_level_desc(struct irq_desc *desc)
 	}
 
 	/* everthing is clear. we have right of way */
-	migrate_ioapic_irq_desc(desc, desc->pending_mask);
+	migrate_ioapic_irq_desc(desc, &desc->pending_mask);
 
 	ret = 0;
 	desc->status &= ~IRQ_MOVE_PENDING;
-	cpus_clear(desc->pending_mask);
+	cpumask_clear(&desc->pending_mask);
 
 unmask:
 	unmask_IO_APIC_irq_desc(desc);
@@ -2389,7 +2436,7 @@ static void ir_irq_migration(struct work_struct *work)
 				continue;
 			}
 
-			desc->chip->set_affinity(irq, desc->pending_mask);
+			desc->chip->set_affinity(irq, &desc->pending_mask);
 			spin_unlock_irqrestore(&desc->lock, flags);
 		}
 	}
@@ -2398,18 +2445,20 @@ static void ir_irq_migration(struct work_struct *work)
 /*
  * Migrates the IRQ destination in the process context.
  */
-static void set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc, cpumask_t mask)
+static void set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc,
+					    const struct cpumask *mask)
 {
 	if (desc->status & IRQ_LEVEL) {
 		desc->status |= IRQ_MOVE_PENDING;
-		desc->pending_mask = mask;
+		cpumask_copy(&desc->pending_mask, mask);
 		migrate_irq_remapped_level_desc(desc);
 		return;
 	}
 
 	migrate_ioapic_irq_desc(desc, mask);
 }
-static void set_ir_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+static void set_ir_ioapic_affinity_irq(unsigned int irq,
+				       const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
@@ -2444,7 +2493,7 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 		if (!cfg->move_cleanup_count)
 			goto unlock;
 
-		if ((vector == cfg->vector) && cpu_isset(me, cfg->domain))
+		if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
 			goto unlock;
 
 		__get_cpu_var(vector_irq)[vector] = -1;
@@ -2481,20 +2530,14 @@ static void irq_complete_move(struct irq_desc **descp)
 
 	vector = ~get_irq_regs()->orig_ax;
 	me = smp_processor_id();
-	if ((vector == cfg->vector) && cpu_isset(me, cfg->domain)) {
-		cpumask_t cleanup_mask;
-
 #ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
 		*descp = desc = move_irq_desc(desc, me);
 		/* get the new one */
 		cfg = desc->chip_data;
 #endif
 
-		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
-		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
-		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
-		cfg->move_in_progress = 0;
-	}
+	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
+		send_cleanup_vector(cfg);
 }
 #else
 static inline void irq_complete_move(struct irq_desc **descp) {}
@@ -3216,16 +3259,13 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 	struct irq_cfg *cfg;
 	int err;
 	unsigned dest;
-	cpumask_t tmp;
 
 	cfg = irq_cfg(irq);
-	tmp = TARGET_CPUS;
-	err = assign_irq_vector(irq, cfg, tmp);
+	err = assign_irq_vector(irq, cfg, TARGET_CPUS);
 	if (err)
 		return err;
 
-	cpus_and(tmp, cfg->domain, tmp);
-	dest = cpu_mask_to_apicid(tmp);
+	dest = cpu_mask_to_apicid_and(cfg->domain, TARGET_CPUS);
 
 #ifdef CONFIG_INTR_REMAP
 	if (irq_remapped(irq)) {
@@ -3279,26 +3319,18 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 }
 
 #ifdef CONFIG_SMP
-static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
+static void set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
-	cpumask_t tmp;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
+	dest = set_desc_affinity(desc, mask);
+	if (dest == BAD_APICID)
 		return;
 
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
-		return;
-
-	set_extra_move_desc(desc, mask);
-
-	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
 
 	read_msi_msg_desc(desc, &msg);
 
@@ -3308,37 +3340,27 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	write_msi_msg_desc(desc, &msg);
-	desc->affinity = mask;
 }
 #ifdef CONFIG_INTR_REMAP
 /*
  * Migrate the MSI irq to another cpumask. This migration is
  * done in the process context using interrupt-remapping hardware.
  */
-static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
+static void
+ir_set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg;
+	struct irq_cfg *cfg = desc->chip_data;
 	unsigned int dest;
-	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
-		return;
-
 	if (get_irte(irq, &irte))
 		return;
 
-	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
+	dest = set_desc_affinity(desc, mask);
+	if (dest == BAD_APICID)
 		return;
 
-	set_extra_move_desc(desc, mask);
-
-	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
-
 	irte.vector = cfg->vector;
 	irte.dest_id = IRTE_DEST(dest);
 
@@ -3352,14 +3374,8 @@ static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 	 * at the new destination. So, time to cleanup the previous
 	 * vector allocation.
 	 */
-	if (cfg->move_in_progress) {
-		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
-		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
-		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
-		cfg->move_in_progress = 0;
-	}
-
-	desc->affinity = mask;
+	if (cfg->move_in_progress)
+		send_cleanup_vector(cfg);
 }
 
 #endif
@@ -3550,26 +3566,18 @@ void arch_teardown_msi_irq(unsigned int irq)
 
 #ifdef CONFIG_DMAR
 #ifdef CONFIG_SMP
-static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
+static void dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
-	cpumask_t tmp;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
+	dest = set_desc_affinity(desc, mask);
+	if (dest == BAD_APICID)
 		return;
 
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
-		return;
-
-	set_extra_move_desc(desc, mask);
-
-	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
 
 	dmar_msi_read(irq, &msg);
 
@@ -3579,7 +3587,6 @@ static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
-	desc->affinity = mask;
 }
 
 #endif /* CONFIG_SMP */
@@ -3613,26 +3620,18 @@ int arch_setup_dmar_msi(unsigned int irq)
 #ifdef CONFIG_HPET_TIMER
 
 #ifdef CONFIG_SMP
-static void hpet_msi_set_affinity(unsigned int irq, cpumask_t mask)
+static void hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
-	cpumask_t tmp;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
+	dest = set_desc_affinity(desc, mask);
+	if (dest == BAD_APICID)
 		return;
 
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
-		return;
-
-	set_extra_move_desc(desc, mask);
-
-	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
 
 	hpet_msi_read(irq, &msg);
 
@@ -3642,7 +3641,6 @@ static void hpet_msi_set_affinity(unsigned int irq, cpumask_t mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	hpet_msi_write(irq, &msg);
-	desc->affinity = mask;
 }
 
 #endif /* CONFIG_SMP */
@@ -3697,28 +3695,19 @@ static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
 	write_ht_irq_msg(irq, &msg);
 }
 
-static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
+static void set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	unsigned int dest;
-	cpumask_t tmp;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
+	dest = set_desc_affinity(desc, mask);
+	if (dest == BAD_APICID)
 		return;
 
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
-		return;
-
-	set_extra_move_desc(desc, mask);
-
-	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
 
 	target_ht_irq(irq, dest, cfg->vector);
-	desc->affinity = mask;
 }
 
 #endif
@@ -3738,17 +3727,14 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 {
 	struct irq_cfg *cfg;
 	int err;
-	cpumask_t tmp;
 
 	cfg = irq_cfg(irq);
-	tmp = TARGET_CPUS;
-	err = assign_irq_vector(irq, cfg, tmp);
+	err = assign_irq_vector(irq, cfg, TARGET_CPUS);
 	if (!err) {
 		struct ht_irq_msg msg;
 		unsigned dest;
 
-		cpus_and(tmp, cfg->domain, tmp);
-		dest = cpu_mask_to_apicid(tmp);
+		dest = cpu_mask_to_apicid_and(cfg->domain, TARGET_CPUS);
 
 		msg.address_hi = HT_IRQ_HIGH_DEST_ID(dest);
 
@@ -3784,7 +3770,7 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 		       unsigned long mmr_offset)
 {
-	const cpumask_t *eligible_cpu = get_cpu_mask(cpu);
+	const struct cpumask *eligible_cpu = cpumask_of(cpu);
 	struct irq_cfg *cfg;
 	int mmr_pnode;
 	unsigned long mmr_value;
@@ -3794,7 +3780,7 @@ int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 
 	cfg = irq_cfg(irq);
 
-	err = assign_irq_vector(irq, cfg, *eligible_cpu);
+	err = assign_irq_vector(irq, cfg, eligible_cpu);
 	if (err != 0)
 		return err;
 
@@ -3813,7 +3799,7 @@ int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	entry->polarity = 0;
 	entry->trigger = 0;
 	entry->mask = 0;
-	entry->dest = cpu_mask_to_apicid(*eligible_cpu);
+	entry->dest = cpu_mask_to_apicid(eligible_cpu);
 
 	mmr_pnode = uv_blade_to_pnode(mmr_blade);
 	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
@@ -4024,7 +4010,7 @@ void __init setup_ioapic_dest(void)
 	int pin, ioapic, irq, irq_entry;
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
-	cpumask_t mask;
+	const struct cpumask *mask;
 
 	if (skip_ioapic_setup == 1)
 		return;
@@ -4055,7 +4041,7 @@ void __init setup_ioapic_dest(void)
 			 */
 			if (desc->status &
 			    (IRQ_NO_BALANCING | IRQ_AFFINITY_SET))
-				mask = desc->affinity;
+				mask = &desc->affinity;
 			else
 				mask = TARGET_CPUS;
 
diff --git a/arch/x86/kernel/ipi.c b/arch/x86/kernel/ipi.c
index f1c688e..285bbf8 100644
--- a/arch/x86/kernel/ipi.c
+++ b/arch/x86/kernel/ipi.c
@@ -116,18 +116,18 @@ static inline void __send_IPI_dest_field(unsigned long mask, int vector)
 /*
  * This is only used on smaller machines.
  */
-void send_IPI_mask_bitmask(cpumask_t cpumask, int vector)
+void send_IPI_mask_bitmask(const struct cpumask *cpumask, int vector)
 {
-	unsigned long mask = cpus_addr(cpumask)[0];
+	unsigned long mask = cpumask_bits(cpumask)[0];
 	unsigned long flags;
 
 	local_irq_save(flags);
-	WARN_ON(mask & ~cpus_addr(cpu_online_map)[0]);
+	WARN_ON(mask & ~cpumask_bits(cpu_online_mask)[0]);
 	__send_IPI_dest_field(mask, vector);
 	local_irq_restore(flags);
 }
 
-void send_IPI_mask_sequence(cpumask_t mask, int vector)
+void send_IPI_mask_sequence(const struct cpumask *mask, int vector)
 {
 	unsigned long flags;
 	unsigned int query_cpu;
@@ -139,12 +139,24 @@ void send_IPI_mask_sequence(cpumask_t mask, int vector)
 	 */
 
 	local_irq_save(flags);
-	for_each_possible_cpu(query_cpu) {
-		if (cpu_isset(query_cpu, mask)) {
+	for_each_cpu(query_cpu, mask)
+		__send_IPI_dest_field(cpu_to_logical_apicid(query_cpu), vector);
+	local_irq_restore(flags);
+}
+
+void send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
+{
+	unsigned long flags;
+	unsigned int query_cpu;
+	unsigned int this_cpu = smp_processor_id();
+
+	/* See Hack comment above */
+
+	local_irq_save(flags);
+	for_each_cpu(query_cpu, mask)
+		if (query_cpu != this_cpu)
 			__send_IPI_dest_field(cpu_to_logical_apicid(query_cpu),
 					      vector);
-		}
-	}
 	local_irq_restore(flags);
 }
 
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3f1d9d1..bce53e1 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -9,6 +9,7 @@
 #include <asm/apic.h>
 #include <asm/io_apic.h>
 #include <asm/smp.h>
+#include <asm/irq.h>
 
 atomic_t irq_err_count;
 
@@ -190,3 +191,5 @@ u64 arch_irq_stat(void)
 #endif
 	return sum;
 }
+
+EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 119fc9c..9dc5588 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -233,27 +233,28 @@ unsigned int do_IRQ(struct pt_regs *regs)
 #ifdef CONFIG_HOTPLUG_CPU
 #include <mach_apic.h>
 
-void fixup_irqs(cpumask_t map)
+/* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
+void fixup_irqs(void)
 {
 	unsigned int irq;
 	static int warned;
 	struct irq_desc *desc;
 
 	for_each_irq_desc(irq, desc) {
-		cpumask_t mask;
+		const struct cpumask *affinity;
 
 		if (!desc)
 			continue;
 		if (irq == 2)
 			continue;
 
-		cpus_and(mask, desc->affinity, map);
-		if (any_online_cpu(mask) == NR_CPUS) {
+		affinity = &desc->affinity;
+		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
 			printk("Breaking affinity for irq %i\n", irq);
-			mask = map;
+			affinity = cpu_all_mask;
 		}
 		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, mask);
+			desc->chip->set_affinity(irq, affinity);
 		else if (desc->action && !(warned++))
 			printk("Cannot set affinity for irq %i\n", irq);
 	}
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index a174a21..6383d50 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -80,16 +80,17 @@ asmlinkage unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-void fixup_irqs(cpumask_t map)
+/* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
+void fixup_irqs(void)
 {
 	unsigned int irq;
 	static int warned;
 	struct irq_desc *desc;
 
 	for_each_irq_desc(irq, desc) {
-		cpumask_t mask;
 		int break_affinity = 0;
 		int set_affinity = 1;
+		const struct cpumask *affinity;
 
 		if (!desc)
 			continue;
@@ -99,23 +100,23 @@ void fixup_irqs(cpumask_t map)
 		/* interrupt's are disabled at this point */
 		spin_lock(&desc->lock);
 
+		affinity = &desc->affinity;
 		if (!irq_has_action(irq) ||
-		    cpus_equal(desc->affinity, map)) {
+		    cpumask_equal(affinity, cpu_online_mask)) {
 			spin_unlock(&desc->lock);
 			continue;
 		}
 
-		cpus_and(mask, desc->affinity, map);
-		if (cpus_empty(mask)) {
+		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
 			break_affinity = 1;
-			mask = map;
+			affinity = cpu_all_mask;
 		}
 
 		if (desc->chip->mask)
 			desc->chip->mask(irq);
 
 		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, mask);
+			desc->chip->set_affinity(irq, affinity);
 		else if (!(warned++))
 			set_affinity = 0;
 
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 203384e..8472329 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -110,6 +110,18 @@ DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
 	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
 };
 
+int vector_used_by_percpu_irq(unsigned int vector)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		if (per_cpu(vector_irq, cpu)[vector] != -1)
+			return 1;
+	}
+
+	return 0;
+}
+
 /* Overridden in paravirt.c */
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
@@ -146,10 +158,12 @@ void __init native_init_IRQ(void)
 	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
 
 	/* IPI for single call function */
-	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR, call_function_single_interrupt);
+	alloc_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
+				 call_function_single_interrupt);
 
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
+	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 6190e6e..31ebfe3 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -69,6 +69,18 @@ DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
 	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
 };
 
+int vector_used_by_percpu_irq(unsigned int vector)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		if (per_cpu(vector_irq, cpu)[vector] != -1)
+			return 1;
+	}
+
+	return 0;
+}
+
 void __init init_ISA_irqs(void)
 {
 	int i;
@@ -121,6 +133,7 @@ static void __init smp_intr_init(void)
 
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
+	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
 #endif
 }
 
diff --git a/arch/x86/kernel/mfgpt_32.c b/arch/x86/kernel/mfgpt_32.c
index 3b59951..c12314c 100644
--- a/arch/x86/kernel/mfgpt_32.c
+++ b/arch/x86/kernel/mfgpt_32.c
@@ -287,7 +287,7 @@ static struct clock_event_device mfgpt_clockevent = {
 	.set_mode = mfgpt_set_mode,
 	.set_next_event = mfgpt_next_event,
 	.rating = 250,
-	.cpumask = CPU_MASK_ALL,
+	.cpumask = cpu_all_mask,
 	.shift = 32
 };
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 61f718d..ba7b9a0 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -592,10 +592,7 @@ static int crash_nmi_callback(struct notifier_block *self,
 
 static void smp_send_nmi_allbutself(void)
 {
-	cpumask_t mask = cpu_online_map;
-	cpu_clear(safe_smp_processor_id(), mask);
-	if (!cpus_empty(mask))
-		send_IPI_mask(mask, NMI_VECTOR);
+	send_IPI_allbutself(NMI_VECTOR);
 }
 
 static struct notifier_block crash_nmi_nb = {
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index ae0c0d3..0b63b08 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -152,6 +152,11 @@ void __init setup_per_cpu_areas(void)
 	old_size = PERCPU_ENOUGH_ROOM;
 	align = max_t(unsigned long, PAGE_SIZE, align);
 	size = roundup(old_size, align);
+
+	printk(KERN_INFO
+		"NR_CPUS:%d nr_cpumask_bits:%d nr_cpu_ids:%d nr_node_ids:%d\n",
+		NR_CPUS, nr_cpumask_bits, nr_cpu_ids, nr_node_ids);
+
 	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
 			  size);
 
@@ -168,24 +173,24 @@ void __init setup_per_cpu_areas(void)
 			       "cpu %d has no node %d or node-local memory\n",
 				cpu, node);
 			if (ptr)
-				printk(KERN_DEBUG "per cpu data for cpu%d at %016lx\n",
+				printk(KERN_DEBUG
+					"per cpu data for cpu%d at %016lx\n",
 					 cpu, __pa(ptr));
 		}
 		else {
 			ptr = __alloc_bootmem_node(NODE_DATA(node), size, align,
 							__pa(MAX_DMA_ADDRESS));
 			if (ptr)
-				printk(KERN_DEBUG "per cpu data for cpu%d on node%d at %016lx\n",
-					 cpu, node, __pa(ptr));
+				printk(KERN_DEBUG
+					"per cpu data for cpu%d on node%d "
+					"at %016lx\n",
+					cpu, node, __pa(ptr));
 		}
 #endif
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
 	}
 
-	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids %d\n",
-		NR_CPUS, nr_cpu_ids, nr_node_ids);
-
 	/* Setup percpu data maps */
 	setup_per_cpu_maps();
 
@@ -282,7 +287,7 @@ static void __cpuinit numa_set_cpumask(int cpu, int enable)
 	else
 		cpu_clear(cpu, *mask);
 
-	cpulist_scnprintf(buf, sizeof(buf), *mask);
+	cpulist_scnprintf(buf, sizeof(buf), mask);
 	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
 		enable? "numa_add_cpu":"numa_remove_cpu", cpu, node, buf);
  }
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 7e558db..beea264 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -118,22 +118,22 @@ static void native_smp_send_reschedule(int cpu)
 		WARN_ON(1);
 		return;
 	}
-	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
+	send_IPI_mask(cpumask_of(cpu), RESCHEDULE_VECTOR);
 }
 
 void native_send_call_func_single_ipi(int cpu)
 {
-	send_IPI_mask(cpumask_of_cpu(cpu), CALL_FUNCTION_SINGLE_VECTOR);
+	send_IPI_mask(cpumask_of(cpu), CALL_FUNCTION_SINGLE_VECTOR);
 }
 
-void native_send_call_func_ipi(cpumask_t mask)
+void native_send_call_func_ipi(const struct cpumask *mask)
 {
 	cpumask_t allbutself;
 
 	allbutself = cpu_online_map;
 	cpu_clear(smp_processor_id(), allbutself);
 
-	if (cpus_equal(mask, allbutself) &&
+	if (cpus_equal(*mask, allbutself) &&
 	    cpus_equal(cpu_online_map, cpu_callout_map))
 		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
 	else
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f8500c9..31869bf 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -102,14 +102,8 @@ EXPORT_SYMBOL(smp_num_siblings);
 /* Last level cache ID of each logical CPU */
 DEFINE_PER_CPU(u16, cpu_llc_id) = BAD_APICID;
 
-/* bitmap of online cpus */
-cpumask_t cpu_online_map __read_mostly;
-EXPORT_SYMBOL(cpu_online_map);
-
 cpumask_t cpu_callin_map;
 cpumask_t cpu_callout_map;
-cpumask_t cpu_possible_map;
-EXPORT_SYMBOL(cpu_possible_map);
 
 /* representing HT siblings of each logical CPU */
 DEFINE_PER_CPU(cpumask_t, cpu_sibling_map);
@@ -1260,6 +1254,15 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 	check_nmi_watchdog();
 }
 
+static int __initdata setup_possible_cpus = -1;
+static int __init _setup_possible_cpus(char *str)
+{
+	get_option(&str, &setup_possible_cpus);
+	return 0;
+}
+early_param("possible_cpus", _setup_possible_cpus);
+
+
 /*
  * cpu_possible_map should be static, it cannot change as cpu's
  * are onlined, or offlined. The reason is per-cpu data-structures
@@ -1272,7 +1275,7 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
  *
  * Three ways to find out the number of additional hotplug CPUs:
  * - If the BIOS specified disabled CPUs in ACPI/mptables use that.
- * - The user can overwrite it with additional_cpus=NUM
+ * - The user can overwrite it with possible_cpus=NUM
  * - Otherwise don't reserve additional CPUs.
  * We do this because additional CPUs waste a lot of memory.
  * -AK
@@ -1285,9 +1288,17 @@ __init void prefill_possible_map(void)
 	if (!num_processors)
 		num_processors = 1;
 
-	possible = num_processors + disabled_cpus;
-	if (possible > NR_CPUS)
-		possible = NR_CPUS;
+	if (setup_possible_cpus == -1)
+		possible = num_processors + disabled_cpus;
+	else
+		possible = setup_possible_cpus;
+
+	if (possible > CONFIG_NR_CPUS) {
+		printk(KERN_WARNING
+			"%d Processors exceeds NR_CPUS limit of %d\n",
+			possible, CONFIG_NR_CPUS);
+		possible = CONFIG_NR_CPUS;
+	}
 
 	printk(KERN_INFO "SMP: Allowing %d CPUs, %d hotplug CPUs\n",
 		possible, max_t(int, possible - num_processors, 0));
@@ -1352,7 +1363,7 @@ void cpu_disable_common(void)
 	lock_vector_lock();
 	remove_cpu_from_maps(cpu);
 	unlock_vector_lock();
-	fixup_irqs(cpu_online_map);
+	fixup_irqs();
 }
 
 int native_cpu_disable(void)
diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
index 8da059f..ce50546 100644
--- a/arch/x86/kernel/tlb_32.c
+++ b/arch/x86/kernel/tlb_32.c
@@ -163,7 +163,7 @@ void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */
-	send_IPI_mask(cpumask, INVALIDATE_TLB_VECTOR);
+	send_IPI_mask(&cpumask, INVALIDATE_TLB_VECTOR);
 
 	while (!cpus_empty(flush_cpumask))
 		/* nothing. lockup detection does not belong here */
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
index 29887d7..f8be6f1 100644
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -191,7 +191,7 @@ void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */
-	send_IPI_mask(cpumask, INVALIDATE_TLB_VECTOR_START + sender);
+	send_IPI_mask(&cpumask, INVALIDATE_TLB_VECTOR_START + sender);
 
 	while (!cpus_empty(f->flush_cpumask))
 		cpu_relax();
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 141907a..2d1f4c7 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -72,9 +72,6 @@
 
 #include "cpu/mcheck/mce.h"
 
-DECLARE_BITMAP(used_vectors, NR_VECTORS);
-EXPORT_SYMBOL_GPL(used_vectors);
-
 asmlinkage int system_call(void);
 
 /* Do we ignore FPU interrupts ? */
@@ -89,6 +86,9 @@ gate_desc idt_table[256]
 	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
 #endif
 
+DECLARE_BITMAP(used_vectors, NR_VECTORS);
+EXPORT_SYMBOL_GPL(used_vectors);
+
 static int ignore_nmis;
 
 static inline void conditional_sti(struct pt_regs *regs)
@@ -941,9 +941,7 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 
 void __init trap_init(void)
 {
-#ifdef CONFIG_X86_32
 	int i;
-#endif
 
 #ifdef CONFIG_EISA
 	void __iomem *p = early_ioremap(0x0FFFD9, 4);
@@ -1000,11 +998,15 @@ void __init trap_init(void)
 	}
 
 	set_system_trap_gate(SYSCALL_VECTOR, &system_call);
+#endif
 
 	/* Reserve all the builtin and the syscall vector: */
 	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
 		set_bit(i, used_vectors);
 
+#ifdef CONFIG_X86_64
+	set_bit(IA32_SYSCALL_VECTOR, used_vectors);
+#else
 	set_bit(SYSCALL_VECTOR, used_vectors);
 #endif
 	/*
diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index 254ee07..c4c1f9e 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -226,7 +226,7 @@ static void __devinit vmi_time_init_clockevent(void)
 	/* Upper bound is clockevent's use of ulong for cycle deltas. */
 	evt->max_delta_ns = clockevent_delta2ns(ULONG_MAX, evt);
 	evt->min_delta_ns = clockevent_delta2ns(1, evt);
-	evt->cpumask = cpumask_of_cpu(cpu);
+	evt->cpumask = cpumask_of(cpu);
 
 	printk(KERN_WARNING "vmi: registering clock event %s. mult=%lu shift=%u\n",
 	       evt->name, evt->mult, evt->shift);
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 50a7792..a7ed208 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -738,7 +738,7 @@ static void lguest_time_init(void)
 
 	/* We can't set cpumask in the initializer: damn C limitations!  Set it
 	 * here and register our timer device. */
-	lguest_clockevent.cpumask = cpumask_of_cpu(0);
+	lguest_clockevent.cpumask = cpumask_of(0);
 	clockevents_register_device(&lguest_clockevent);
 
 	/* Finally, we unblock the timer interrupt. */
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 3624a36..bc4c784 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -42,9 +42,10 @@ static const struct dmi_system_id bigsmp_dmi_table[] = {
 	 { }
 };
 
-static cpumask_t vector_allocation_domain(int cpu)
+static void vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
-        return cpumask_of_cpu(cpu);
+	cpus_clear(*retmask);
+	cpu_set(cpu, *retmask);
 }
 
 static int probe_bigsmp(void)
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 7b4e6d0..4ba5cca 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -87,7 +87,7 @@ static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 }
 #endif
 
-static cpumask_t vector_allocation_domain(int cpu)
+static void vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -97,8 +97,7 @@ static cpumask_t vector_allocation_domain(int cpu)
 	 * deliver interrupts to the wrong hyperthread when only one
 	 * hyperthread was specified in the interrupt desitination.
 	 */
-	cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
-	return domain;
+	*retmask = (cpumask_t){ { [0] = APIC_ALL_CPUS, } };
 }
 
 struct genapic __initdata_refok apic_es7000 = APIC_INIT("es7000", probe_es7000);
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 71a309b..511d794 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -38,7 +38,7 @@ static int acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return 0;
 }
 
-static cpumask_t vector_allocation_domain(int cpu)
+static void vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -48,8 +48,7 @@ static cpumask_t vector_allocation_domain(int cpu)
 	 * deliver interrupts to the wrong hyperthread when only one
 	 * hyperthread was specified in the interrupt desitination.
 	 */
-	cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
-	return domain;
+	*retmask = (cpumask_t){ { [0] = APIC_ALL_CPUS, } };
 }
 
 struct genapic apic_numaq = APIC_INIT("NUMAQ", probe_numaq);
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 2c6d234..2821ffc 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -24,7 +24,7 @@ static int probe_summit(void)
 	return 0;
 }
 
-static cpumask_t vector_allocation_domain(int cpu)
+static void vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -34,8 +34,7 @@ static cpumask_t vector_allocation_domain(int cpu)
 	 * deliver interrupts to the wrong hyperthread when only one
 	 * hyperthread was specified in the interrupt desitination.
 	 */
-	cpumask_t domain = { { [0] = APIC_ALL_CPUS, } };
-	return domain;
+	*retmask = (cpumask_t){ { [0] = APIC_ALL_CPUS, } };
 }
 
 struct genapic apic_summit = APIC_INIT("summit", probe_summit);
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 5214500..a5bc054 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -63,11 +63,6 @@ static int voyager_extended_cpus = 1;
 /* Used for the invalidate map that's also checked in the spinlock */
 static volatile unsigned long smp_invalidate_needed;
 
-/* Bitmask of currently online CPUs - used by setup.c for
-   /proc/cpuinfo, visible externally but still physical */
-cpumask_t cpu_online_map = CPU_MASK_NONE;
-EXPORT_SYMBOL(cpu_online_map);
-
 /* Bitmask of CPUs present in the system - exported by i386_syms.c, used
  * by scheduler but indexed physically */
 cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
@@ -218,8 +213,6 @@ static cpumask_t smp_commenced_mask = CPU_MASK_NONE;
 /* This is for the new dynamic CPU boot code */
 cpumask_t cpu_callin_map = CPU_MASK_NONE;
 cpumask_t cpu_callout_map = CPU_MASK_NONE;
-cpumask_t cpu_possible_map = CPU_MASK_NONE;
-EXPORT_SYMBOL(cpu_possible_map);
 
 /* The per processor IRQ masks (these are usually kept in sync) */
 static __u16 vic_irq_mask[NR_CPUS] __cacheline_aligned;
@@ -679,7 +672,7 @@ void __init smp_boot_cpus(void)
 
 	/* loop over all the extended VIC CPUs and boot them.  The
 	 * Quad CPUs must be bootstrapped by their extended VIC cpu */
-	for (i = 0; i < NR_CPUS; i++) {
+	for (i = 0; i < nr_cpu_ids; i++) {
 		if (i == boot_cpu_id || !cpu_isset(i, phys_cpu_present_map))
 			continue;
 		do_boot_cpu(i);
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index cebcbf1..71a14f8 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -278,7 +278,7 @@ void __init numa_init_array(void)
 	int rr, i;
 
 	rr = first_node(node_online_map);
-	for (i = 0; i < NR_CPUS; i++) {
+	for (i = 0; i < nr_cpu_ids; i++) {
 		if (early_cpu_to_node(i) != NUMA_NO_NODE)
 			continue;
 		numa_set_node(i, rr);
@@ -549,7 +549,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn)
 	memnodemap[0] = 0;
 	node_set_online(0);
 	node_set(0, node_possible_map);
-	for (i = 0; i < NR_CPUS; i++)
+	for (i = 0; i < nr_cpu_ids; i++)
 		numa_set_node(i, 0);
 	e820_register_active_regions(0, start_pfn, last_pfn);
 	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 51c0a2f..09737c8 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -382,7 +382,7 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 		if (!node_online(i))
 			setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 
-	for (i = 0; i < NR_CPUS; i++) {
+	for (i = 0; i < nr_cpu_ids; i++) {
 		int node = early_cpu_to_node(i);
 
 		if (node == NUMA_NO_NODE)
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 773d68d..503c240 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1082,7 +1082,7 @@ static void drop_other_mm_ref(void *info)
 
 static void xen_drop_mm_ref(struct mm_struct *mm)
 {
-	cpumask_t mask;
+	cpumask_var_t mask;
 	unsigned cpu;
 
 	if (current->active_mm == mm) {
@@ -1094,7 +1094,16 @@ static void xen_drop_mm_ref(struct mm_struct *mm)
 	}
 
 	/* Get the "official" set of cpus referring to our pagetable. */
-	mask = mm->cpu_vm_mask;
+	if (!alloc_cpumask_var(&mask, GFP_ATOMIC)) {
+		for_each_online_cpu(cpu) {
+			if (!cpumask_test_cpu(cpu, &mm->cpu_vm_mask)
+			    && per_cpu(xen_current_cr3, cpu) != __pa(mm->pgd))
+				continue;
+			smp_call_function_single(cpu, drop_other_mm_ref, mm, 1);
+		}
+		return;
+	}
+	cpumask_copy(mask, &mm->cpu_vm_mask);
 
 	/* It's possible that a vcpu may have a stale reference to our
 	   cr3, because its in lazy mode, and it hasn't yet flushed
@@ -1103,11 +1112,12 @@ static void xen_drop_mm_ref(struct mm_struct *mm)
 	   if needed. */
 	for_each_online_cpu(cpu) {
 		if (per_cpu(xen_current_cr3, cpu) == __pa(mm->pgd))
-			cpu_set(cpu, mask);
+			cpumask_set_cpu(cpu, mask);
 	}
 
-	if (!cpus_empty(mask))
-		smp_call_function_mask(mask, drop_other_mm_ref, mm, 1);
+	if (!cpumask_empty(mask))
+		smp_call_function_many(mask, drop_other_mm_ref, mm, 1);
+	free_cpumask_var(mask);
 }
 #else
 static void xen_drop_mm_ref(struct mm_struct *mm)
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index acd9b67..c44e206 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -33,7 +33,7 @@
 #include "xen-ops.h"
 #include "mmu.h"
 
-cpumask_t xen_cpu_initialized_map;
+cpumask_var_t xen_cpu_initialized_map;
 
 static DEFINE_PER_CPU(int, resched_irq);
 static DEFINE_PER_CPU(int, callfunc_irq);
@@ -158,7 +158,7 @@ static void __init xen_fill_possible_map(void)
 {
 	int i, rc;
 
-	for (i = 0; i < NR_CPUS; i++) {
+	for (i = 0; i < nr_cpu_ids; i++) {
 		rc = HYPERVISOR_vcpu_op(VCPUOP_is_up, i, NULL);
 		if (rc >= 0) {
 			num_processors++;
@@ -192,11 +192,14 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 	if (xen_smp_intr_init(0))
 		BUG();
 
-	xen_cpu_initialized_map = cpumask_of_cpu(0);
+	if (!alloc_cpumask_var(&xen_cpu_initialized_map, GFP_KERNEL))
+		panic("could not allocate xen_cpu_initialized_map\n");
+
+	cpumask_copy(xen_cpu_initialized_map, cpumask_of(0));
 
 	/* Restrict the possible_map according to max_cpus. */
 	while ((num_possible_cpus() > 1) && (num_possible_cpus() > max_cpus)) {
-		for (cpu = NR_CPUS - 1; !cpu_possible(cpu); cpu--)
+		for (cpu = nr_cpu_ids - 1; !cpu_possible(cpu); cpu--)
 			continue;
 		cpu_clear(cpu, cpu_possible_map);
 	}
@@ -221,7 +224,7 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	struct vcpu_guest_context *ctxt;
 	struct desc_struct *gdt;
 
-	if (cpu_test_and_set(cpu, xen_cpu_initialized_map))
+	if (cpumask_test_and_set_cpu(cpu, xen_cpu_initialized_map))
 		return 0;
 
 	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
@@ -408,24 +411,23 @@ static void xen_smp_send_reschedule(int cpu)
 	xen_send_IPI_one(cpu, XEN_RESCHEDULE_VECTOR);
 }
 
-static void xen_send_IPI_mask(cpumask_t mask, enum ipi_vector vector)
+static void xen_send_IPI_mask(const struct cpumask *mask,
+			      enum ipi_vector vector)
 {
 	unsigned cpu;
 
-	cpus_and(mask, mask, cpu_online_map);
-
-	for_each_cpu_mask_nr(cpu, mask)
+	for_each_cpu_and(cpu, mask, cpu_online_mask)
 		xen_send_IPI_one(cpu, vector);
 }
 
-static void xen_smp_send_call_function_ipi(cpumask_t mask)
+static void xen_smp_send_call_function_ipi(const struct cpumask *mask)
 {
 	int cpu;
 
 	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
 
 	/* Make sure other vcpus get a chance to run if they need to. */
-	for_each_cpu_mask_nr(cpu, mask) {
+	for_each_cpu(cpu, mask) {
 		if (xen_vcpu_stolen(cpu)) {
 			HYPERVISOR_sched_op(SCHEDOP_yield, 0);
 			break;
@@ -435,7 +437,8 @@ static void xen_smp_send_call_function_ipi(cpumask_t mask)
 
 static void xen_smp_send_call_function_single_ipi(int cpu)
 {
-	xen_send_IPI_mask(cpumask_of_cpu(cpu), XEN_CALL_FUNCTION_SINGLE_VECTOR);
+	xen_send_IPI_mask(cpumask_of(cpu),
+			  XEN_CALL_FUNCTION_SINGLE_VECTOR);
 }
 
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index 2a234db..212ffe0 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -35,7 +35,8 @@ void xen_post_suspend(int suspend_cancelled)
 			pfn_to_mfn(xen_start_info->console.domU.mfn);
 	} else {
 #ifdef CONFIG_SMP
-		xen_cpu_initialized_map = cpu_online_map;
+		BUG_ON(xen_cpu_initialized_map == NULL);
+		cpumask_copy(xen_cpu_initialized_map, cpu_online_mask);
 #endif
 		xen_vcpu_restore();
 	}
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index c9f7cda..65d75a6 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -437,7 +437,7 @@ void xen_setup_timer(int cpu)
 	evt = &per_cpu(xen_clock_events, cpu);
 	memcpy(evt, xen_clockevent, sizeof(*evt));
 
-	evt->cpumask = cpumask_of_cpu(cpu);
+	evt->cpumask = cpumask_of(cpu);
 	evt->irq = irq;
 
 	setup_runstate_info(cpu);
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 9e1afae..c1f8faf 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -58,7 +58,7 @@ void __init xen_init_spinlocks(void);
 __cpuinit void xen_init_lock_cpu(int cpu);
 void xen_uninit_lock_cpu(int cpu);
 
-extern cpumask_t xen_cpu_initialized_map;
+extern cpumask_var_t xen_cpu_initialized_map;
 #else
 static inline void xen_smp_init(void) {}
 #endif
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 64f5d54..4259072 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -109,7 +109,7 @@ static SYSDEV_ATTR(crash_notes, 0400, show_crash_notes, NULL);
  */
 static ssize_t print_cpus_map(char *buf, cpumask_t *map)
 {
-	int n = cpulist_scnprintf(buf, PAGE_SIZE-2, *map);
+	int n = cpulist_scnprintf(buf, PAGE_SIZE-2, map);
 
 	buf[n++] = '\n';
 	buf[n] = '\0';
diff --git a/drivers/base/node.c b/drivers/base/node.c
index f520709..91636cd 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -30,8 +30,8 @@ static ssize_t node_read_cpumap(struct sys_device *dev, int type, char *buf)
 	BUILD_BUG_ON((NR_CPUS/32 * 9) > (PAGE_SIZE-1));
 
 	len = type?
-		cpulist_scnprintf(buf, PAGE_SIZE-2, *mask):
-		cpumask_scnprintf(buf, PAGE_SIZE-2, *mask);
+		cpulist_scnprintf(buf, PAGE_SIZE-2, mask) :
+		cpumask_scnprintf(buf, PAGE_SIZE-2, mask);
  	buf[len++] = '\n';
  	buf[len] = '\0';
 	return len;
diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index 199cd97..a8bc1cb 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -49,8 +49,8 @@ static ssize_t show_cpumap(int type, cpumask_t *mask, char *buf)
 
 	if (len > 1) {
 		n = type?
-			cpulist_scnprintf(buf, len-2, *mask):
-			cpumask_scnprintf(buf, len-2, *mask);
+			cpulist_scnprintf(buf, len-2, mask) :
+			cpumask_scnprintf(buf, len-2, mask);
 		buf[n++] = '\n';
 		buf[n] = '\0';
 	}
diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index f450588..254f106 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -154,7 +154,6 @@ static struct tc_clkevt_device clkevt = {
 		.shift		= 32,
 		/* Should be lower than at91rm9200's system timer */
 		.rating		= 125,
-		.cpumask	= CPU_MASK_CPU0,
 		.set_next_event	= tc_next_event,
 		.set_mode	= tc_mode,
 	},
@@ -195,6 +194,7 @@ static void __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 	clkevt.clkevt.max_delta_ns
 		= clockevent_delta2ns(0xffff, &clkevt.clkevt);
 	clkevt.clkevt.min_delta_ns = clockevent_delta2ns(1, &clkevt.clkevt) + 1;
+	clkevt.clkevt.cpumask = cpumask_of(0);
 
 	setup_irq(irq, &tc_irqaction);
 
diff --git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
index a103906..415fab0 100644
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -222,11 +222,16 @@ bool check_syscall_vector(struct lguest *lg)
 int init_interrupts(void)
 {
 	/* If they want some strange system call vector, reserve it now */
-	if (syscall_vector != SYSCALL_VECTOR
-	    && test_and_set_bit(syscall_vector, used_vectors)) {
-		printk("lg: couldn't reserve syscall %u\n", syscall_vector);
-		return -EBUSY;
+	if (syscall_vector != SYSCALL_VECTOR) {
+		if (test_bit(syscall_vector, used_vectors) ||
+		    vector_used_by_percpu_irq(syscall_vector)) {
+			printk(KERN_ERR "lg: couldn't reserve syscall %u\n",
+				 syscall_vector);
+			return -EBUSY;
+		}
+		set_bit(syscall_vector, used_vectors);
 	}
+
 	return 0;
 }
 
diff --git a/drivers/parisc/iosapic.c b/drivers/parisc/iosapic.c
index 7beffca..9dedbbd 100644
--- a/drivers/parisc/iosapic.c
+++ b/drivers/parisc/iosapic.c
@@ -704,16 +704,17 @@ static unsigned int iosapic_startup_irq(unsigned int irq)
 }
 
 #ifdef CONFIG_SMP
-static void iosapic_set_affinity_irq(unsigned int irq, cpumask_t dest)
+static void iosapic_set_affinity_irq(unsigned int irq,
+				     const struct cpumask *dest)
 {
 	struct vector_info *vi = iosapic_get_vector(irq);
 	u32 d0, d1, dummy_d0;
 	unsigned long flags;
 
-	if (cpu_check_affinity(irq, &dest))
+	if (cpu_check_affinity(irq, dest))
 		return;
 
-	vi->txn_addr = txn_affinity_addr(irq, first_cpu(dest));
+	vi->txn_addr = txn_affinity_addr(irq, cpumask_first(dest));
 
 	spin_lock_irqsave(&iosapic_lock, flags);
 	/* d1 contains the destination CPU, so only want to set that
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 5d72866..c884858 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -74,7 +74,7 @@ static ssize_t local_cpus_show(struct device *dev,
 	int len;
 
 	mask = pcibus_to_cpumask(to_pci_dev(dev)->bus);
-	len = cpumask_scnprintf(buf, PAGE_SIZE-2, mask);
+	len = cpumask_scnprintf(buf, PAGE_SIZE-2, &mask);
 	buf[len++] = '\n';
 	buf[len] = '\0';
 	return len;
@@ -88,7 +88,7 @@ static ssize_t local_cpulist_show(struct device *dev,
 	int len;
 
 	mask = pcibus_to_cpumask(to_pci_dev(dev)->bus);
-	len = cpulist_scnprintf(buf, PAGE_SIZE-2, mask);
+	len = cpulist_scnprintf(buf, PAGE_SIZE-2, &mask);
 	buf[len++] = '\n';
 	buf[len] = '\0';
 	return len;
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 003a9b3..5b3f593 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -55,8 +55,8 @@ static ssize_t pci_bus_show_cpuaffinity(struct device *dev,
 
 	cpumask = pcibus_to_cpumask(to_pci_bus(dev));
 	ret = type?
-		cpulist_scnprintf(buf, PAGE_SIZE-2, cpumask):
-		cpumask_scnprintf(buf, PAGE_SIZE-2, cpumask);
+		cpulist_scnprintf(buf, PAGE_SIZE-2, &cpumask) :
+		cpumask_scnprintf(buf, PAGE_SIZE-2, &cpumask);
 	buf[ret++] = '\n';
 	buf[ret] = '\0';
 	return ret;
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index e26733a..eb0dfde 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -585,7 +585,7 @@ void rebind_evtchn_irq(int evtchn, int irq)
 	spin_unlock(&irq_mapping_update_lock);
 
 	/* new event channels are always bound to cpu 0 */
-	irq_set_affinity(irq, cpumask_of_cpu(0));
+	irq_set_affinity(irq, cpumask_of(0));
 
 	/* Unmask the event channel. */
 	enable_irq(irq);
@@ -614,9 +614,9 @@ static void rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
 }
 
 
-static void set_affinity_irq(unsigned irq, cpumask_t dest)
+static void set_affinity_irq(unsigned irq, const struct cpumask *dest)
 {
-	unsigned tcpu = first_cpu(dest);
+	unsigned tcpu = cpumask_first(dest);
 	rebind_irq_to_cpu(irq, tcpu);
 }
 
diff --git a/include/asm-generic/topology.h b/include/asm-generic/topology.h
index 54bbf6e..0e9e2bc 100644
--- a/include/asm-generic/topology.h
+++ b/include/asm-generic/topology.h
@@ -40,6 +40,9 @@
 #ifndef node_to_cpumask
 #define node_to_cpumask(node)	((void)node, cpu_online_map)
 #endif
+#ifndef cpumask_of_node
+#define cpumask_of_node(node)	((void)node, cpu_online_mask)
+#endif
 #ifndef node_to_first_cpu
 #define node_to_first_cpu(node)	((void)(node),0)
 #endif
@@ -54,9 +57,18 @@
 				)
 #endif
 
+#ifndef cpumask_of_pcibus
+#define cpumask_of_pcibus(bus)	(pcibus_to_node(bus) == -1 ?		\
+				 cpu_all_mask :				\
+				 cpumask_of_node(pcibus_to_node(bus)))
+#endif
+
 #endif	/* CONFIG_NUMA */
 
-/* returns pointer to cpumask for specified node */
+/*
+ * returns pointer to cpumask for specified node
+ * Deprecated: use "const struct cpumask *mask = cpumask_of_node(node)"
+ */
 #ifndef node_to_cpumask_ptr
 
 #define	node_to_cpumask_ptr(v, node) 					\
diff --git a/include/asm-m32r/smp.h b/include/asm-m32r/smp.h
index c5dd669..b96a6d2 100644
--- a/include/asm-m32r/smp.h
+++ b/include/asm-m32r/smp.h
@@ -63,8 +63,6 @@ extern volatile int cpu_2_physid[NR_CPUS];
 #define raw_smp_processor_id()	(current_thread_info()->cpu)
 
 extern cpumask_t cpu_callout_map;
-extern cpumask_t cpu_possible_map;
-extern cpumask_t cpu_present_map;
 
 static __inline__ int hard_smp_processor_id(void)
 {
diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index ed3a5d4..cea1536 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -82,13 +82,13 @@ struct clock_event_device {
 	int			shift;
 	int			rating;
 	int			irq;
-	cpumask_t		cpumask;
+	const struct cpumask	*cpumask;
 	int			(*set_next_event)(unsigned long evt,
 						  struct clock_event_device *);
 	void			(*set_mode)(enum clock_event_mode mode,
 					    struct clock_event_device *);
 	void			(*event_handler)(struct clock_event_device *);
-	void			(*broadcast)(cpumask_t mask);
+	void			(*broadcast)(const struct cpumask *mask);
 	struct list_head	list;
 	enum clock_event_mode	mode;
 	ktime_t			next_event;
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 21e1dd4..d4bf526 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -339,36 +339,6 @@ extern cpumask_t cpu_mask_all;
 #endif
 #define	CPUMASK_PTR(v, m) 	cpumask_t *v = &(m->v)
 
-#define cpumask_scnprintf(buf, len, src) \
-			__cpumask_scnprintf((buf), (len), &(src), NR_CPUS)
-static inline int __cpumask_scnprintf(char *buf, int len,
-					const cpumask_t *srcp, int nbits)
-{
-	return bitmap_scnprintf(buf, len, srcp->bits, nbits);
-}
-
-#define cpumask_parse_user(ubuf, ulen, dst) \
-			__cpumask_parse_user((ubuf), (ulen), &(dst), NR_CPUS)
-static inline int __cpumask_parse_user(const char __user *buf, int len,
-					cpumask_t *dstp, int nbits)
-{
-	return bitmap_parse_user(buf, len, dstp->bits, nbits);
-}
-
-#define cpulist_scnprintf(buf, len, src) \
-			__cpulist_scnprintf((buf), (len), &(src), NR_CPUS)
-static inline int __cpulist_scnprintf(char *buf, int len,
-					const cpumask_t *srcp, int nbits)
-{
-	return bitmap_scnlistprintf(buf, len, srcp->bits, nbits);
-}
-
-#define cpulist_parse(buf, dst) __cpulist_parse((buf), &(dst), NR_CPUS)
-static inline int __cpulist_parse(const char *buf, cpumask_t *dstp, int nbits)
-{
-	return bitmap_parselist(buf, dstp->bits, nbits);
-}
-
 #define cpu_remap(oldbit, old, new) \
 		__cpu_remap((oldbit), &(old), &(new), NR_CPUS)
 static inline int __cpu_remap(int oldbit,
@@ -540,9 +510,6 @@ extern cpumask_t cpu_active_map;
 	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD	\
 }
 
-/* This produces more efficient code. */
-#define nr_cpumask_bits	NR_CPUS
-
 #else /* NR_CPUS > BITS_PER_LONG */
 
 #define CPU_BITS_ALL						\
@@ -550,9 +517,15 @@ extern cpumask_t cpu_active_map;
 	[0 ... BITS_TO_LONGS(NR_CPUS)-2] = ~0UL,		\
 	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD		\
 }
+#endif /* NR_CPUS > BITS_PER_LONG */
 
+#ifdef CONFIG_CPUMASK_OFFSTACK
+/* Assuming NR_CPUS is huge, a runtime limit is more efficient.  Also,
+ * not all bits may be allocated. */
 #define nr_cpumask_bits	nr_cpu_ids
-#endif /* NR_CPUS > BITS_PER_LONG */
+#else
+#define nr_cpumask_bits	NR_CPUS
+#endif
 
 /* verify cpu argument to cpumask_* operators */
 static inline unsigned int cpumask_check(unsigned int cpu)
@@ -946,6 +919,63 @@ static inline void cpumask_copy(struct cpumask *dstp,
 #define cpumask_of(cpu) (get_cpu_mask(cpu))
 
 /**
+ * cpumask_scnprintf - print a cpumask into a string as comma-separated hex
+ * @buf: the buffer to sprintf into
+ * @len: the length of the buffer
+ * @srcp: the cpumask to print
+ *
+ * If len is zero, returns zero.  Otherwise returns the length of the
+ * (nul-terminated) @buf string.
+ */
+static inline int cpumask_scnprintf(char *buf, int len,
+				    const struct cpumask *srcp)
+{
+	return bitmap_scnprintf(buf, len, srcp->bits, nr_cpumask_bits);
+}
+
+/**
+ * cpumask_parse_user - extract a cpumask from a user string
+ * @buf: the buffer to extract from
+ * @len: the length of the buffer
+ * @dstp: the cpumask to set.
+ *
+ * Returns -errno, or 0 for success.
+ */
+static inline int cpumask_parse_user(const char __user *buf, int len,
+				     struct cpumask *dstp)
+{
+	return bitmap_parse_user(buf, len, dstp->bits, nr_cpumask_bits);
+}
+
+/**
+ * cpulist_scnprintf - print a cpumask into a string as comma-separated list
+ * @buf: the buffer to sprintf into
+ * @len: the length of the buffer
+ * @srcp: the cpumask to print
+ *
+ * If len is zero, returns zero.  Otherwise returns the length of the
+ * (nul-terminated) @buf string.
+ */
+static inline int cpulist_scnprintf(char *buf, int len,
+				    const struct cpumask *srcp)
+{
+	return bitmap_scnlistprintf(buf, len, srcp->bits, nr_cpumask_bits);
+}
+
+/**
+ * cpulist_parse_user - extract a cpumask from a user string of ranges
+ * @buf: the buffer to extract from
+ * @len: the length of the buffer
+ * @dstp: the cpumask to set.
+ *
+ * Returns -errno, or 0 for success.
+ */
+static inline int cpulist_parse(const char *buf, struct cpumask *dstp)
+{
+	return bitmap_parselist(buf, dstp->bits, nr_cpumask_bits);
+}
+
+/**
  * to_cpumask - convert an NR_CPUS bitmap to a struct cpumask *
  * @bitmap: the bitmap
  *
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 8cc8ef4..990355f 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -111,13 +111,13 @@ extern void enable_irq(unsigned int irq);
 
 extern cpumask_t irq_default_affinity;
 
-extern int irq_set_affinity(unsigned int irq, cpumask_t cpumask);
+extern int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask);
 extern int irq_can_set_affinity(unsigned int irq);
 extern int irq_select_affinity(unsigned int irq);
 
 #else /* CONFIG_SMP */
 
-static inline int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
+static inline int irq_set_affinity(unsigned int irq, const struct cpumask *m)
 {
 	return -EINVAL;
 }
diff --git a/include/linux/irq.h b/include/linux/irq.h
index d64a6d4..f899b50 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -113,7 +113,8 @@ struct irq_chip {
 	void		(*eoi)(unsigned int irq);
 
 	void		(*end)(unsigned int irq);
-	void		(*set_affinity)(unsigned int irq, cpumask_t dest);
+	void		(*set_affinity)(unsigned int irq,
+					const struct cpumask *dest);
 	int		(*retrigger)(unsigned int irq);
 	int		(*set_type)(unsigned int irq, unsigned int flow_type);
 	int		(*set_wake)(unsigned int irq, unsigned int on);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8395e71..158d53d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -250,7 +250,7 @@ extern void init_idle_bootup_task(struct task_struct *idle);
 extern int runqueue_is_locked(void);
 extern void task_rq_unlock_wait(struct task_struct *p);
 
-extern cpumask_t nohz_cpu_mask;
+extern cpumask_var_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern int select_nohz_load_balancer(int cpu);
 #else
@@ -758,20 +758,51 @@ enum cpu_idle_type {
 #define SD_SERIALIZE		1024	/* Only a single load balancing instance */
 #define SD_WAKE_IDLE_FAR	2048	/* Gain latency sacrificing cache hit */
 
-#define BALANCE_FOR_MC_POWER	\
-	(sched_smt_power_savings ? SD_POWERSAVINGS_BALANCE : 0)
+enum powersavings_balance_level {
+	POWERSAVINGS_BALANCE_NONE = 0,  /* No power saving load balance */
+	POWERSAVINGS_BALANCE_BASIC,	/* Fill one thread/core/package
+					 * first for long running threads
+					 */
+	POWERSAVINGS_BALANCE_WAKEUP,	/* Also bias task wakeups to semi-idle
+					 * cpu package for power savings
+					 */
+	MAX_POWERSAVINGS_BALANCE_LEVELS
+};
 
-#define BALANCE_FOR_PKG_POWER	\
-	((sched_mc_power_savings || sched_smt_power_savings) ?	\
-	 SD_POWERSAVINGS_BALANCE : 0)
+extern int sched_mc_power_savings, sched_smt_power_savings;
 
-#define test_sd_parent(sd, flag)	((sd->parent &&		\
-					 (sd->parent->flags & flag)) ? 1 : 0)
+static inline int sd_balance_for_mc_power(void)
+{
+	if (sched_smt_power_savings)
+		return SD_POWERSAVINGS_BALANCE;
 
+	return 0;
+}
+
+static inline int sd_balance_for_package_power(void)
+{
+	if (sched_mc_power_savings | sched_smt_power_savings)
+		return SD_POWERSAVINGS_BALANCE;
+
+	return 0;
+}
+
+/*
+ * Optimise SD flags for power savings:
+ * SD_BALANCE_NEWIDLE helps agressive task consolidation and power savings.
+ * Keep default SD flags if sched_{smt,mc}_power_saving=0
+ */
+
+static inline int sd_power_saving_flags(void)
+{
+	if (sched_mc_power_savings | sched_smt_power_savings)
+		return SD_BALANCE_NEWIDLE;
+
+	return 0;
+}
 
 struct sched_group {
 	struct sched_group *next;	/* Must be a circular list */
-	cpumask_t cpumask;
 
 	/*
 	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
@@ -784,8 +815,15 @@ struct sched_group {
 	 * (see include/linux/reciprocal_div.h)
 	 */
 	u32 reciprocal_cpu_power;
+
+	unsigned long cpumask[];
 };
 
+static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
+{
+	return to_cpumask(sg->cpumask);
+}
+
 enum sched_domain_level {
 	SD_LV_NONE = 0,
 	SD_LV_SIBLING,
@@ -809,7 +847,6 @@ struct sched_domain {
 	struct sched_domain *parent;	/* top domain must be null terminated */
 	struct sched_domain *child;	/* bottom domain must be null terminated */
 	struct sched_group *groups;	/* the balancing groups of the domain */
-	cpumask_t span;			/* span of all CPUs in this domain */
 	unsigned long min_interval;	/* Minimum balance interval ms */
 	unsigned long max_interval;	/* Maximum balance interval ms */
 	unsigned int busy_factor;	/* less balancing by factor if busy */
@@ -864,18 +901,35 @@ struct sched_domain {
 #ifdef CONFIG_SCHED_DEBUG
 	char *name;
 #endif
+
+	/* span of all CPUs in this domain */
+	unsigned long span[];
 };
 
-extern void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
+static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
+{
+	return to_cpumask(sd->span);
+}
+
+extern void partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
 				    struct sched_domain_attr *dattr_new);
 extern int arch_reinit_sched_domains(void);
 
+/* Test a flag in parent sched domain */
+static inline int test_sd_parent(struct sched_domain *sd, int flag)
+{
+	if (sd->parent && (sd->parent->flags & flag))
+		return 1;
+
+	return 0;
+}
+
 #else /* CONFIG_SMP */
 
 struct sched_domain_attr;
 
 static inline void
-partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
+partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
 			struct sched_domain_attr *dattr_new)
 {
 }
@@ -926,7 +980,7 @@ struct sched_class {
 	void (*task_wake_up) (struct rq *this_rq, struct task_struct *task);
 
 	void (*set_cpus_allowed)(struct task_struct *p,
-				 const cpumask_t *newmask);
+				 const struct cpumask *newmask);
 
 	void (*rq_online)(struct rq *rq);
 	void (*rq_offline)(struct rq *rq);
@@ -1579,12 +1633,12 @@ extern cputime_t task_gtime(struct task_struct *p);
 
 #ifdef CONFIG_SMP
 extern int set_cpus_allowed_ptr(struct task_struct *p,
-				const cpumask_t *new_mask);
+				const struct cpumask *new_mask);
 #else
 static inline int set_cpus_allowed_ptr(struct task_struct *p,
-				       const cpumask_t *new_mask)
+				       const struct cpumask *new_mask)
 {
-	if (!cpu_isset(0, *new_mask))
+	if (!cpumask_test_cpu(0, new_mask))
 		return -EINVAL;
 	return 0;
 }
@@ -2195,10 +2249,8 @@ __trace_special(void *__tr, void *__data,
 }
 #endif
 
-extern long sched_setaffinity(pid_t pid, const cpumask_t *new_mask);
-extern long sched_getaffinity(pid_t pid, cpumask_t *mask);
-
-extern int sched_mc_power_savings, sched_smt_power_savings;
+extern long sched_setaffinity(pid_t pid, const struct cpumask *new_mask);
+extern long sched_getaffinity(pid_t pid, struct cpumask *mask);
 
 extern void normalize_rt_tasks(void);
 
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 0c5b5ac..e632d29 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -125,7 +125,8 @@ int arch_update_cpu_topology(void);
 				| SD_WAKE_AFFINE	\
 				| SD_WAKE_BALANCE	\
 				| SD_SHARE_PKG_RESOURCES\
-				| BALANCE_FOR_MC_POWER,	\
+				| sd_balance_for_mc_power()\
+				| sd_power_saving_flags(),\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 }
@@ -150,7 +151,8 @@ int arch_update_cpu_topology(void);
 				| SD_BALANCE_FORK	\
 				| SD_WAKE_AFFINE	\
 				| SD_WAKE_BALANCE	\
-				| BALANCE_FOR_PKG_POWER,\
+				| sd_balance_for_package_power()\
+				| sd_power_saving_flags(),\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 }
diff --git a/init/Kconfig b/init/Kconfig
index 1362719..f628171 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -924,6 +924,15 @@ config KMOD
 
 endif # MODULES
 
+config INIT_ALL_POSSIBLE
+	bool
+	help
+	  Back when each arch used to define their own cpu_online_map and
+	  cpu_possible_map, some of them chose to initialize cpu_possible_map
+	  with all 1s, and others with all 0s.  When they were centralised,
+	  it was better to provide this option than to break all the archs
+	  and have several arch maintainers persuing me down dark alleys.
+
 config STOP_MACHINE
 	bool
 	default y
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 8ea32e8..bae131a 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -24,19 +24,20 @@
 cpumask_t cpu_present_map __read_mostly;
 EXPORT_SYMBOL(cpu_present_map);
 
-#ifndef CONFIG_SMP
-
 /*
  * Represents all cpu's that are currently online.
  */
-cpumask_t cpu_online_map __read_mostly = CPU_MASK_ALL;
+cpumask_t cpu_online_map __read_mostly;
 EXPORT_SYMBOL(cpu_online_map);
 
+#ifdef CONFIG_INIT_ALL_POSSIBLE
 cpumask_t cpu_possible_map __read_mostly = CPU_MASK_ALL;
+#else
+cpumask_t cpu_possible_map __read_mostly;
+#endif
 EXPORT_SYMBOL(cpu_possible_map);
 
-#else /* CONFIG_SMP */
-
+#ifdef CONFIG_SMP
 /* Serializes the updates to cpu_online_map, cpu_present_map */
 static DEFINE_MUTEX(cpu_add_remove_lock);
 
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 96c0ba1..39c1a4c 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -896,7 +896,7 @@ static int update_cpumask(struct cpuset *cs, const char *buf)
 	if (!*buf) {
 		cpus_clear(trialcs.cpus_allowed);
 	} else {
-		retval = cpulist_parse(buf, trialcs.cpus_allowed);
+		retval = cpulist_parse(buf, &trialcs.cpus_allowed);
 		if (retval < 0)
 			return retval;
 
@@ -1482,7 +1482,7 @@ static int cpuset_sprintf_cpulist(char *page, struct cpuset *cs)
 	mask = cs->cpus_allowed;
 	mutex_unlock(&callback_mutex);
 
-	return cpulist_scnprintf(page, PAGE_SIZE, mask);
+	return cpulist_scnprintf(page, PAGE_SIZE, &mask);
 }
 
 static int cpuset_sprintf_memlist(char *page, struct cpuset *cs)
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 6eb3c79..f63c706 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -46,7 +46,7 @@ void dynamic_irq_init(unsigned int irq)
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
 #ifdef CONFIG_SMP
-	cpus_setall(desc->affinity);
+	cpumask_setall(&desc->affinity);
 #endif
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 540f6c4..61c4a9b 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -79,7 +79,7 @@ int irq_can_set_affinity(unsigned int irq)
  *	@cpumask:	cpumask
  *
  */
-int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
+int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -91,14 +91,14 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (desc->status & IRQ_MOVE_PCNTXT || desc->status & IRQ_DISABLED) {
-		desc->affinity = cpumask;
+		cpumask_copy(&desc->affinity, cpumask);
 		desc->chip->set_affinity(irq, cpumask);
 	} else {
 		desc->status |= IRQ_MOVE_PENDING;
-		desc->pending_mask = cpumask;
+		cpumask_copy(&desc->pending_mask, cpumask);
 	}
 #else
-	desc->affinity = cpumask;
+	cpumask_copy(&desc->affinity, cpumask);
 	desc->chip->set_affinity(irq, cpumask);
 #endif
 	desc->status |= IRQ_AFFINITY_SET;
@@ -112,26 +112,24 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
  */
 int do_irq_select_affinity(unsigned int irq, struct irq_desc *desc)
 {
-	cpumask_t mask;
-
 	if (!irq_can_set_affinity(irq))
 		return 0;
 
-	cpus_and(mask, cpu_online_map, irq_default_affinity);
-
 	/*
 	 * Preserve an userspace affinity setup, but make sure that
 	 * one of the targets is online.
 	 */
 	if (desc->status & (IRQ_AFFINITY_SET | IRQ_NO_BALANCING)) {
-		if (cpus_intersects(desc->affinity, cpu_online_map))
-			mask = desc->affinity;
+		if (cpumask_any_and(&desc->affinity, cpu_online_mask)
+		    < nr_cpu_ids)
+			goto set_affinity;
 		else
 			desc->status &= ~IRQ_AFFINITY_SET;
 	}
 
-	desc->affinity = mask;
-	desc->chip->set_affinity(irq, mask);
+	cpumask_and(&desc->affinity, cpu_online_mask, &irq_default_affinity);
+set_affinity:
+	desc->chip->set_affinity(irq, &desc->affinity);
 
 	return 0;
 }
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index 9db681d..bd72329 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -4,7 +4,6 @@
 void move_masked_irq(int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	cpumask_t tmp;
 
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
@@ -19,7 +18,7 @@ void move_masked_irq(int irq)
 
 	desc->status &= ~IRQ_MOVE_PENDING;
 
-	if (unlikely(cpus_empty(desc->pending_mask)))
+	if (unlikely(cpumask_empty(&desc->pending_mask)))
 		return;
 
 	if (!desc->chip->set_affinity)
@@ -27,8 +26,6 @@ void move_masked_irq(int irq)
 
 	assert_spin_locked(&desc->lock);
 
-	cpus_and(tmp, desc->pending_mask, cpu_online_map);
-
 	/*
 	 * If there was a valid mask to work with, please
 	 * do the disable, re-program, enable sequence.
@@ -41,10 +38,13 @@ void move_masked_irq(int irq)
 	 * For correct operation this depends on the caller
 	 * masking the irqs.
 	 */
-	if (likely(!cpus_empty(tmp))) {
-		desc->chip->set_affinity(irq,tmp);
+	if (likely(cpumask_any_and(&desc->pending_mask, cpu_online_mask)
+		   < nr_cpu_ids)) {
+		cpumask_and(&desc->affinity,
+			    &desc->pending_mask, cpu_online_mask);
+		desc->chip->set_affinity(irq, &desc->affinity);
 	}
-	cpus_clear(desc->pending_mask);
+	cpumask_clear(&desc->pending_mask);
 }
 
 void move_native_irq(int irq)
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index f6b3440..d2c0e5e 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -40,33 +40,42 @@ static ssize_t irq_affinity_proc_write(struct file *file,
 		const char __user *buffer, size_t count, loff_t *pos)
 {
 	unsigned int irq = (int)(long)PDE(file->f_path.dentry->d_inode)->data;
-	cpumask_t new_value;
+	cpumask_var_t new_value;
 	int err;
 
 	if (!irq_to_desc(irq)->chip->set_affinity || no_irq_affinity ||
 	    irq_balancing_disabled(irq))
 		return -EIO;
 
+	if (!alloc_cpumask_var(&new_value, GFP_KERNEL))
+		return -ENOMEM;
+
 	err = cpumask_parse_user(buffer, count, new_value);
 	if (err)
-		return err;
+		goto free_cpumask;
 
-	if (!is_affinity_mask_valid(new_value))
-		return -EINVAL;
+	if (!is_affinity_mask_valid(*new_value)) {
+		err = -EINVAL;
+		goto free_cpumask;
+	}
 
 	/*
 	 * Do not allow disabling IRQs completely - it's a too easy
 	 * way to make the system unusable accidentally :-) At least
 	 * one online CPU still has to be targeted.
 	 */
-	if (!cpus_intersects(new_value, cpu_online_map))
+	if (!cpumask_intersects(new_value, cpu_online_mask)) {
 		/* Special case for empty set - allow the architecture
 		   code to set default SMP affinity. */
-		return irq_select_affinity_usr(irq) ? -EINVAL : count;
-
-	irq_set_affinity(irq, new_value);
+		err = irq_select_affinity_usr(irq) ? -EINVAL : count;
+	} else {
+		irq_set_affinity(irq, new_value);
+		err = count;
+	}
 
-	return count;
+free_cpumask:
+	free_cpumask_var(new_value);
+	return err;
 }
 
 static int irq_affinity_proc_open(struct inode *inode, struct file *file)
@@ -95,7 +104,7 @@ static ssize_t default_affinity_write(struct file *file,
 	cpumask_t new_value;
 	int err;
 
-	err = cpumask_parse_user(buffer, count, new_value);
+	err = cpumask_parse_user(buffer, count, &new_value);
 	if (err)
 		return err;
 
diff --git a/kernel/profile.c b/kernel/profile.c
index 60adefb..4cb7d68 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -442,7 +442,7 @@ void profile_tick(int type)
 static int prof_cpu_mask_read_proc(char *page, char **start, off_t off,
 			int count, int *eof, void *data)
 {
-	int len = cpumask_scnprintf(page, count, *(cpumask_t *)data);
+	int len = cpumask_scnprintf(page, count, (cpumask_t *)data);
 	if (count - len < 2)
 		return -EINVAL;
 	len += sprintf(page + len, "\n");
@@ -456,7 +456,7 @@ static int prof_cpu_mask_write_proc(struct file *file,
 	unsigned long full_count = count, err;
 	cpumask_t new_value;
 
-	err = cpumask_parse_user(buffer, count, new_value);
+	err = cpumask_parse_user(buffer, count, &new_value);
 	if (err)
 		return err;
 
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index e503a00..c03ca3e 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -393,7 +393,7 @@ static void rcu_start_batch(struct rcu_ctrlblk *rcp)
 		 * unnecessarily.
 		 */
 		smp_mb();
-		cpus_andnot(rcp->cpumask, cpu_online_map, nohz_cpu_mask);
+		cpumask_andnot(&rcp->cpumask, cpu_online_mask, nohz_cpu_mask);
 
 		rcp->signaled = 0;
 	}
diff --git a/kernel/sched.c b/kernel/sched.c
index fff1c4a..27ba1d6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -498,18 +498,26 @@ struct rt_rq {
  */
 struct root_domain {
 	atomic_t refcount;
-	cpumask_t span;
-	cpumask_t online;
+	cpumask_var_t span;
+	cpumask_var_t online;
 
 	/*
 	 * The "RT overload" flag: it gets set if a CPU has more than
 	 * one runnable RT task.
 	 */
-	cpumask_t rto_mask;
+	cpumask_var_t rto_mask;
 	atomic_t rto_count;
 #ifdef CONFIG_SMP
 	struct cpupri cpupri;
 #endif
+#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+	/*
+	 * Preferred wake up cpu nominated by sched_mc balance that will be
+	 * used when most cpus are idle in the system indicating overall very
+	 * low system utilisation. Triggered at POWERSAVINGS_BALANCE_WAKEUP(2)
+	 */
+	unsigned int sched_mc_preferred_wakeup_cpu;
+#endif
 };
 
 /*
@@ -1514,7 +1522,7 @@ static int tg_shares_up(struct task_group *tg, void *data)
 	struct sched_domain *sd = data;
 	int i;
 
-	for_each_cpu_mask(i, sd->span) {
+	for_each_cpu(i, sched_domain_span(sd)) {
 		/*
 		 * If there are currently no tasks on the cpu pretend there
 		 * is one of average load so that when a new task gets to
@@ -1535,7 +1543,7 @@ static int tg_shares_up(struct task_group *tg, void *data)
 	if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
 		shares = tg->shares;
 
-	for_each_cpu_mask(i, sd->span)
+	for_each_cpu(i, sched_domain_span(sd))
 		update_group_shares_cpu(tg, i, shares, rq_weight);
 
 	return 0;
@@ -2101,15 +2109,17 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 		int i;
 
 		/* Skip over this group if it has no CPUs allowed */
-		if (!cpus_intersects(group->cpumask, p->cpus_allowed))
+		if (!cpumask_intersects(sched_group_cpus(group),
+					&p->cpus_allowed))
 			continue;
 
-		local_group = cpu_isset(this_cpu, group->cpumask);
+		local_group = cpumask_test_cpu(this_cpu,
+					       sched_group_cpus(group));
 
 		/* Tally up the load of all CPUs in the group */
 		avg_load = 0;
 
-		for_each_cpu_mask_nr(i, group->cpumask) {
+		for_each_cpu(i, sched_group_cpus(group)) {
 			/* Bias balancing toward cpus of our domain */
 			if (local_group)
 				load = source_load(i, load_idx);
@@ -2141,17 +2151,14 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
  * find_idlest_cpu - find the idlest cpu among the cpus in group.
  */
 static int
-find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu,
-		cpumask_t *tmp)
+find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 {
 	unsigned long load, min_load = ULONG_MAX;
 	int idlest = -1;
 	int i;
 
 	/* Traverse only the allowed CPUs */
-	cpus_and(*tmp, group->cpumask, p->cpus_allowed);
-
-	for_each_cpu_mask_nr(i, *tmp) {
+	for_each_cpu_and(i, sched_group_cpus(group), &p->cpus_allowed) {
 		load = weighted_cpuload(i);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
@@ -2193,7 +2200,6 @@ static int sched_balance_self(int cpu, int flag)
 		update_shares(sd);
 
 	while (sd) {
-		cpumask_t span, tmpmask;
 		struct sched_group *group;
 		int new_cpu, weight;
 
@@ -2202,14 +2208,13 @@ static int sched_balance_self(int cpu, int flag)
 			continue;
 		}
 
-		span = sd->span;
 		group = find_idlest_group(sd, t, cpu);
 		if (!group) {
 			sd = sd->child;
 			continue;
 		}
 
-		new_cpu = find_idlest_cpu(group, t, cpu, &tmpmask);
+		new_cpu = find_idlest_cpu(group, t, cpu);
 		if (new_cpu == -1 || new_cpu == cpu) {
 			/* Now try balancing at a lower domain level of cpu */
 			sd = sd->child;
@@ -2218,10 +2223,10 @@ static int sched_balance_self(int cpu, int flag)
 
 		/* Now try balancing at a lower domain level of new_cpu */
 		cpu = new_cpu;
+		weight = cpumask_weight(sched_domain_span(sd));
 		sd = NULL;
-		weight = cpus_weight(span);
 		for_each_domain(cpu, tmp) {
-			if (weight <= cpus_weight(tmp->span))
+			if (weight <= cpumask_weight(sched_domain_span(tmp)))
 				break;
 			if (tmp->flags & flag)
 				sd = tmp;
@@ -2266,7 +2271,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 		cpu = task_cpu(p);
 
 		for_each_domain(this_cpu, sd) {
-			if (cpu_isset(cpu, sd->span)) {
+			if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
 				update_shares(sd);
 				break;
 			}
@@ -2315,7 +2320,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 	else {
 		struct sched_domain *sd;
 		for_each_domain(this_cpu, sd) {
-			if (cpu_isset(cpu, sd->span)) {
+			if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
 				schedstat_inc(sd, ttwu_wake_remote);
 				break;
 			}
@@ -2846,7 +2851,7 @@ static void sched_migrate_task(struct task_struct *p, int dest_cpu)
 	struct rq *rq;
 
 	rq = task_rq_lock(p, &flags);
-	if (!cpu_isset(dest_cpu, p->cpus_allowed)
+	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed)
 	    || unlikely(!cpu_active(dest_cpu)))
 		goto out;
 
@@ -2911,7 +2916,7 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
 	 * 3) are cache-hot on their current CPU.
 	 */
-	if (!cpu_isset(this_cpu, p->cpus_allowed)) {
+	if (!cpumask_test_cpu(this_cpu, &p->cpus_allowed)) {
 		schedstat_inc(p, se.nr_failed_migrations_affine);
 		return 0;
 	}
@@ -3086,7 +3091,7 @@ static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 static struct sched_group *
 find_busiest_group(struct sched_domain *sd, int this_cpu,
 		   unsigned long *imbalance, enum cpu_idle_type idle,
-		   int *sd_idle, const cpumask_t *cpus, int *balance)
+		   int *sd_idle, const struct cpumask *cpus, int *balance)
 {
 	struct sched_group *busiest = NULL, *this = NULL, *group = sd->groups;
 	unsigned long max_load, avg_load, total_load, this_load, total_pwr;
@@ -3122,10 +3127,11 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		unsigned long sum_avg_load_per_task;
 		unsigned long avg_load_per_task;
 
-		local_group = cpu_isset(this_cpu, group->cpumask);
+		local_group = cpumask_test_cpu(this_cpu,
+					       sched_group_cpus(group));
 
 		if (local_group)
-			balance_cpu = first_cpu(group->cpumask);
+			balance_cpu = cpumask_first(sched_group_cpus(group));
 
 		/* Tally up the load of all CPUs in the group */
 		sum_weighted_load = sum_nr_running = avg_load = 0;
@@ -3134,13 +3140,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		max_cpu_load = 0;
 		min_cpu_load = ~0UL;
 
-		for_each_cpu_mask_nr(i, group->cpumask) {
-			struct rq *rq;
-
-			if (!cpu_isset(i, *cpus))
-				continue;
-
-			rq = cpu_rq(i);
+		for_each_cpu_and(i, sched_group_cpus(group), cpus) {
+			struct rq *rq = cpu_rq(i);
 
 			if (*sd_idle && rq->nr_running)
 				*sd_idle = 0;
@@ -3251,8 +3252,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		 */
 		if ((sum_nr_running < min_nr_running) ||
 		    (sum_nr_running == min_nr_running &&
-		     first_cpu(group->cpumask) <
-		     first_cpu(group_min->cpumask))) {
+		     cpumask_first(sched_group_cpus(group)) >
+		     cpumask_first(sched_group_cpus(group_min)))) {
 			group_min = group;
 			min_nr_running = sum_nr_running;
 			min_load_per_task = sum_weighted_load /
@@ -3267,8 +3268,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		if (sum_nr_running <= group_capacity - 1) {
 			if (sum_nr_running > leader_nr_running ||
 			    (sum_nr_running == leader_nr_running &&
-			     first_cpu(group->cpumask) >
-			      first_cpu(group_leader->cpumask))) {
+			     cpumask_first(sched_group_cpus(group)) <
+			     cpumask_first(sched_group_cpus(group_leader)))) {
 				group_leader = group;
 				leader_nr_running = sum_nr_running;
 			}
@@ -3394,6 +3395,10 @@ out_balanced:
 
 	if (this == group_leader && group_leader != group_min) {
 		*imbalance = min_load_per_task;
+		if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP) {
+			cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
+				cpumask_first(sched_group_cpus(group_leader));
+		}
 		return group_min;
 	}
 #endif
@@ -3407,16 +3412,16 @@ ret:
  */
 static struct rq *
 find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
-		   unsigned long imbalance, const cpumask_t *cpus)
+		   unsigned long imbalance, const struct cpumask *cpus)
 {
 	struct rq *busiest = NULL, *rq;
 	unsigned long max_load = 0;
 	int i;
 
-	for_each_cpu_mask_nr(i, group->cpumask) {
+	for_each_cpu(i, sched_group_cpus(group)) {
 		unsigned long wl;
 
-		if (!cpu_isset(i, *cpus))
+		if (!cpumask_test_cpu(i, cpus))
 			continue;
 
 		rq = cpu_rq(i);
@@ -3446,7 +3451,7 @@ find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
  */
 static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *balance, cpumask_t *cpus)
+			int *balance, struct cpumask *cpus)
 {
 	int ld_moved, all_pinned = 0, active_balance = 0, sd_idle = 0;
 	struct sched_group *group;
@@ -3454,7 +3459,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	struct rq *busiest;
 	unsigned long flags;
 
-	cpus_setall(*cpus);
+	cpumask_setall(cpus);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -3514,8 +3519,8 @@ redo:
 
 		/* All tasks on this runqueue were pinned by CPU affinity */
 		if (unlikely(all_pinned)) {
-			cpu_clear(cpu_of(busiest), *cpus);
-			if (!cpus_empty(*cpus))
+			cpumask_clear_cpu(cpu_of(busiest), cpus);
+			if (!cpumask_empty(cpus))
 				goto redo;
 			goto out_balanced;
 		}
@@ -3532,7 +3537,8 @@ redo:
 			/* don't kick the migration_thread, if the curr
 			 * task on busiest cpu can't be moved to this_cpu
 			 */
-			if (!cpu_isset(this_cpu, busiest->curr->cpus_allowed)) {
+			if (!cpumask_test_cpu(this_cpu,
+					      &busiest->curr->cpus_allowed)) {
 				spin_unlock_irqrestore(&busiest->lock, flags);
 				all_pinned = 1;
 				goto out_one_pinned;
@@ -3607,7 +3613,7 @@ out:
  */
 static int
 load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd,
-			cpumask_t *cpus)
+			struct cpumask *cpus)
 {
 	struct sched_group *group;
 	struct rq *busiest = NULL;
@@ -3616,7 +3622,7 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd,
 	int sd_idle = 0;
 	int all_pinned = 0;
 
-	cpus_setall(*cpus);
+	cpumask_setall(cpus);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -3660,17 +3666,71 @@ redo:
 		double_unlock_balance(this_rq, busiest);
 
 		if (unlikely(all_pinned)) {
-			cpu_clear(cpu_of(busiest), *cpus);
-			if (!cpus_empty(*cpus))
+			cpumask_clear_cpu(cpu_of(busiest), cpus);
+			if (!cpumask_empty(cpus))
 				goto redo;
 		}
 	}
 
 	if (!ld_moved) {
+		int active_balance = 0;
+
 		schedstat_inc(sd, lb_failed[CPU_NEWLY_IDLE]);
 		if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
 		    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
 			return -1;
+
+		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
+			return -1;
+
+		if (sd->nr_balance_failed++ < 2)
+			return -1;
+
+		/*
+		 * The only task running in a non-idle cpu can be moved to this
+		 * cpu in an attempt to completely freeup the other CPU
+		 * package. The same method used to move task in load_balance()
+		 * have been extended for load_balance_newidle() to speedup
+		 * consolidation at sched_mc=POWERSAVINGS_BALANCE_WAKEUP (2)
+		 *
+		 * The package power saving logic comes from
+		 * find_busiest_group().  If there are no imbalance, then
+		 * f_b_g() will return NULL.  However when sched_mc={1,2} then
+		 * f_b_g() will select a group from which a running task may be
+		 * pulled to this cpu in order to make the other package idle.
+		 * If there is no opportunity to make a package idle and if
+		 * there are no imbalance, then f_b_g() will return NULL and no
+		 * action will be taken in load_balance_newidle().
+		 *
+		 * Under normal task pull operation due to imbalance, there
+		 * will be more than one task in the source run queue and
+		 * move_tasks() will succeed.  ld_moved will be true and this
+		 * active balance code will not be triggered.
+		 */
+
+		/* Lock busiest in correct order while this_rq is held */
+		double_lock_balance(this_rq, busiest);
+
+		/*
+		 * don't kick the migration_thread, if the curr
+		 * task on busiest cpu can't be moved to this_cpu
+		 */
+		if (!cpu_isset(this_cpu, busiest->curr->cpus_allowed)) {
+			double_unlock_balance(this_rq, busiest);
+			all_pinned = 1;
+			return ld_moved;
+		}
+
+		if (!busiest->active_balance) {
+			busiest->active_balance = 1;
+			busiest->push_cpu = this_cpu;
+			active_balance = 1;
+		}
+
+		double_unlock_balance(this_rq, busiest);
+		if (active_balance)
+			wake_up_process(busiest->migration_thread);
+
 	} else
 		sd->nr_balance_failed = 0;
 
@@ -3696,7 +3756,10 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 	struct sched_domain *sd;
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
-	cpumask_t tmpmask;
+	cpumask_var_t tmpmask;
+
+	if (!alloc_cpumask_var(&tmpmask, GFP_ATOMIC))
+		return;
 
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
@@ -3707,7 +3770,7 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 		if (sd->flags & SD_BALANCE_NEWIDLE)
 			/* If we've pulled tasks over stop searching: */
 			pulled_task = load_balance_newidle(this_cpu, this_rq,
-							   sd, &tmpmask);
+							   sd, tmpmask);
 
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
@@ -3722,6 +3785,7 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 		 */
 		this_rq->next_balance = next_balance;
 	}
+	free_cpumask_var(tmpmask);
 }
 
 /*
@@ -3759,7 +3823,7 @@ static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
 	/* Search for an sd spanning us and the target CPU. */
 	for_each_domain(target_cpu, sd) {
 		if ((sd->flags & SD_LOAD_BALANCE) &&
-		    cpu_isset(busiest_cpu, sd->span))
+		    cpumask_test_cpu(busiest_cpu, sched_domain_span(sd)))
 				break;
 	}
 
@@ -3778,10 +3842,9 @@ static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
 #ifdef CONFIG_NO_HZ
 static struct {
 	atomic_t load_balancer;
-	cpumask_t cpu_mask;
+	cpumask_var_t cpu_mask;
 } nohz ____cacheline_aligned = {
 	.load_balancer = ATOMIC_INIT(-1),
-	.cpu_mask = CPU_MASK_NONE,
 };
 
 /*
@@ -3809,7 +3872,7 @@ int select_nohz_load_balancer(int stop_tick)
 	int cpu = smp_processor_id();
 
 	if (stop_tick) {
-		cpu_set(cpu, nohz.cpu_mask);
+		cpumask_set_cpu(cpu, nohz.cpu_mask);
 		cpu_rq(cpu)->in_nohz_recently = 1;
 
 		/*
@@ -3823,7 +3886,7 @@ int select_nohz_load_balancer(int stop_tick)
 		}
 
 		/* time for ilb owner also to sleep */
-		if (cpus_weight(nohz.cpu_mask) == num_online_cpus()) {
+		if (cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
 			if (atomic_read(&nohz.load_balancer) == cpu)
 				atomic_set(&nohz.load_balancer, -1);
 			return 0;
@@ -3836,10 +3899,10 @@ int select_nohz_load_balancer(int stop_tick)
 		} else if (atomic_read(&nohz.load_balancer) == cpu)
 			return 1;
 	} else {
-		if (!cpu_isset(cpu, nohz.cpu_mask))
+		if (!cpumask_test_cpu(cpu, nohz.cpu_mask))
 			return 0;
 
-		cpu_clear(cpu, nohz.cpu_mask);
+		cpumask_clear_cpu(cpu, nohz.cpu_mask);
 
 		if (atomic_read(&nohz.load_balancer) == cpu)
 			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
@@ -3867,7 +3930,11 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 	unsigned long next_balance = jiffies + 60*HZ;
 	int update_next_balance = 0;
 	int need_serialize;
-	cpumask_t tmp;
+	cpumask_var_t tmp;
+
+	/* Fails alloc?  Rebalancing probably not a priority right now. */
+	if (!alloc_cpumask_var(&tmp, GFP_ATOMIC))
+		return;
 
 	for_each_domain(cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
@@ -3892,7 +3959,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 		}
 
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
-			if (load_balance(cpu, rq, sd, idle, &balance, &tmp)) {
+			if (load_balance(cpu, rq, sd, idle, &balance, tmp)) {
 				/*
 				 * We've pulled tasks over so either we're no
 				 * longer idle, or one of our SMT siblings is
@@ -3926,6 +3993,8 @@ out:
 	 */
 	if (likely(update_next_balance))
 		rq->next_balance = next_balance;
+
+	free_cpumask_var(tmp);
 }
 
 /*
@@ -3950,12 +4019,13 @@ static void run_rebalance_domains(struct softirq_action *h)
 	 */
 	if (this_rq->idle_at_tick &&
 	    atomic_read(&nohz.load_balancer) == this_cpu) {
-		cpumask_t cpus = nohz.cpu_mask;
 		struct rq *rq;
 		int balance_cpu;
 
-		cpu_clear(this_cpu, cpus);
-		for_each_cpu_mask_nr(balance_cpu, cpus) {
+		for_each_cpu(balance_cpu, nohz.cpu_mask) {
+			if (balance_cpu == this_cpu)
+				continue;
+
 			/*
 			 * If this cpu gets work to do, stop the load balancing
 			 * work being done for other cpus. Next load
@@ -3993,7 +4063,7 @@ static inline void trigger_load_balance(struct rq *rq, int cpu)
 		rq->in_nohz_recently = 0;
 
 		if (atomic_read(&nohz.load_balancer) == cpu) {
-			cpu_clear(cpu, nohz.cpu_mask);
+			cpumask_clear_cpu(cpu, nohz.cpu_mask);
 			atomic_set(&nohz.load_balancer, -1);
 		}
 
@@ -4006,7 +4076,7 @@ static inline void trigger_load_balance(struct rq *rq, int cpu)
 			 * TBD: Traverse the sched domains and nominate
 			 * the nearest cpu in the nohz.cpu_mask.
 			 */
-			int ilb = first_cpu(nohz.cpu_mask);
+			int ilb = cpumask_first(nohz.cpu_mask);
 
 			if (ilb < nr_cpu_ids)
 				resched_cpu(ilb);
@@ -4018,7 +4088,7 @@ static inline void trigger_load_balance(struct rq *rq, int cpu)
 	 * cpus with ticks stopped, is it time for that to stop?
 	 */
 	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) == cpu &&
-	    cpus_weight(nohz.cpu_mask) == num_online_cpus()) {
+	    cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
 		resched_cpu(cpu);
 		return;
 	}
@@ -4028,7 +4098,7 @@ static inline void trigger_load_balance(struct rq *rq, int cpu)
 	 * someone else, then no need raise the SCHED_SOFTIRQ
 	 */
 	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) != cpu &&
-	    cpu_isset(cpu, nohz.cpu_mask))
+	    cpumask_test_cpu(cpu, nohz.cpu_mask))
 		return;
 #endif
 	if (time_after_eq(jiffies, rq->next_balance))
@@ -5401,10 +5471,9 @@ out_unlock:
 	return retval;
 }
 
-long sched_setaffinity(pid_t pid, const cpumask_t *in_mask)
+long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 {
-	cpumask_t cpus_allowed;
-	cpumask_t new_mask = *in_mask;
+	cpumask_var_t cpus_allowed, new_mask;
 	struct task_struct *p;
 	int retval;
 
@@ -5426,6 +5495,14 @@ long sched_setaffinity(pid_t pid, const cpumask_t *in_mask)
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
 
+	if (!alloc_cpumask_var(&cpus_allowed, GFP_KERNEL)) {
+		retval = -ENOMEM;
+		goto out_put_task;
+	}
+	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL)) {
+		retval = -ENOMEM;
+		goto out_free_cpus_allowed;
+	}
 	retval = -EPERM;
 	if (!check_same_owner(p) && !capable(CAP_SYS_NICE))
 		goto out_unlock;
@@ -5434,37 +5511,41 @@ long sched_setaffinity(pid_t pid, const cpumask_t *in_mask)
 	if (retval)
 		goto out_unlock;
 
-	cpuset_cpus_allowed(p, &cpus_allowed);
-	cpus_and(new_mask, new_mask, cpus_allowed);
+	cpuset_cpus_allowed(p, cpus_allowed);
+	cpumask_and(new_mask, in_mask, cpus_allowed);
  again:
-	retval = set_cpus_allowed_ptr(p, &new_mask);
+	retval = set_cpus_allowed_ptr(p, new_mask);
 
 	if (!retval) {
-		cpuset_cpus_allowed(p, &cpus_allowed);
-		if (!cpus_subset(new_mask, cpus_allowed)) {
+		cpuset_cpus_allowed(p, cpus_allowed);
+		if (!cpumask_subset(new_mask, cpus_allowed)) {
 			/*
 			 * We must have raced with a concurrent cpuset
 			 * update. Just reset the cpus_allowed to the
 			 * cpuset's cpus_allowed
 			 */
-			new_mask = cpus_allowed;
+			cpumask_copy(new_mask, cpus_allowed);
 			goto again;
 		}
 	}
 out_unlock:
+	free_cpumask_var(new_mask);
+out_free_cpus_allowed:
+	free_cpumask_var(cpus_allowed);
+out_put_task:
 	put_task_struct(p);
 	put_online_cpus();
 	return retval;
 }
 
 static int get_user_cpu_mask(unsigned long __user *user_mask_ptr, unsigned len,
-			     cpumask_t *new_mask)
+			     struct cpumask *new_mask)
 {
-	if (len < sizeof(cpumask_t)) {
-		memset(new_mask, 0, sizeof(cpumask_t));
-	} else if (len > sizeof(cpumask_t)) {
-		len = sizeof(cpumask_t);
-	}
+	if (len < cpumask_size())
+		cpumask_clear(new_mask);
+	else if (len > cpumask_size())
+		len = cpumask_size();
+
 	return copy_from_user(new_mask, user_mask_ptr, len) ? -EFAULT : 0;
 }
 
@@ -5477,17 +5558,20 @@ static int get_user_cpu_mask(unsigned long __user *user_mask_ptr, unsigned len,
 asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 				      unsigned long __user *user_mask_ptr)
 {
-	cpumask_t new_mask;
+	cpumask_var_t new_mask;
 	int retval;
 
-	retval = get_user_cpu_mask(user_mask_ptr, len, &new_mask);
-	if (retval)
-		return retval;
+	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL))
+		return -ENOMEM;
 
-	return sched_setaffinity(pid, &new_mask);
+	retval = get_user_cpu_mask(user_mask_ptr, len, new_mask);
+	if (retval == 0)
+		retval = sched_setaffinity(pid, new_mask);
+	free_cpumask_var(new_mask);
+	return retval;
 }
 
-long sched_getaffinity(pid_t pid, cpumask_t *mask)
+long sched_getaffinity(pid_t pid, struct cpumask *mask)
 {
 	struct task_struct *p;
 	int retval;
@@ -5504,7 +5588,7 @@ long sched_getaffinity(pid_t pid, cpumask_t *mask)
 	if (retval)
 		goto out_unlock;
 
-	cpus_and(*mask, p->cpus_allowed, cpu_online_map);
+	cpumask_and(mask, &p->cpus_allowed, cpu_online_mask);
 
 out_unlock:
 	read_unlock(&tasklist_lock);
@@ -5523,19 +5607,24 @@ asmlinkage long sys_sched_getaffinity(pid_t pid, unsigned int len,
 				      unsigned long __user *user_mask_ptr)
 {
 	int ret;
-	cpumask_t mask;
+	cpumask_var_t mask;
 
-	if (len < sizeof(cpumask_t))
+	if (len < cpumask_size())
 		return -EINVAL;
 
-	ret = sched_getaffinity(pid, &mask);
-	if (ret < 0)
-		return ret;
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+		return -ENOMEM;
 
-	if (copy_to_user(user_mask_ptr, &mask, sizeof(cpumask_t)))
-		return -EFAULT;
+	ret = sched_getaffinity(pid, mask);
+	if (ret == 0) {
+		if (copy_to_user(user_mask_ptr, mask, cpumask_size()))
+			ret = -EFAULT;
+		else
+			ret = cpumask_size();
+	}
+	free_cpumask_var(mask);
 
-	return sizeof(cpumask_t);
+	return ret;
 }
 
 /**
@@ -5877,7 +5966,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	idle->se.exec_start = sched_clock();
 
 	idle->prio = idle->normal_prio = MAX_PRIO;
-	idle->cpus_allowed = cpumask_of_cpu(cpu);
+	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
 	__set_task_cpu(idle, cpu);
 
 	rq->curr = rq->idle = idle;
@@ -5904,9 +5993,9 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
  * indicates which cpus entered this state. This is used
  * in the rcu update to wait only for active cpus. For system
  * which do not switch off the HZ timer nohz_cpu_mask should
- * always be CPU_MASK_NONE.
+ * always be CPU_BITS_NONE.
  */
-cpumask_t nohz_cpu_mask = CPU_MASK_NONE;
+cpumask_var_t nohz_cpu_mask;
 
 /*
  * Increase the granularity value when there are more CPUs,
@@ -5961,7 +6050,7 @@ static inline void sched_init_granularity(void)
  * task must not exit() & deallocate itself prematurely. The
  * call is not atomic; no spinlocks may be held.
  */
-int set_cpus_allowed_ptr(struct task_struct *p, const cpumask_t *new_mask)
+int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 {
 	struct migration_req req;
 	unsigned long flags;
@@ -5969,13 +6058,13 @@ int set_cpus_allowed_ptr(struct task_struct *p, const cpumask_t *new_mask)
 	int ret = 0;
 
 	rq = task_rq_lock(p, &flags);
-	if (!cpus_intersects(*new_mask, cpu_online_map)) {
+	if (!cpumask_intersects(new_mask, cpu_online_mask)) {
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
-		     !cpus_equal(p->cpus_allowed, *new_mask))) {
+		     !cpumask_equal(&p->cpus_allowed, new_mask))) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -5983,15 +6072,15 @@ int set_cpus_allowed_ptr(struct task_struct *p, const cpumask_t *new_mask)
 	if (p->sched_class->set_cpus_allowed)
 		p->sched_class->set_cpus_allowed(p, new_mask);
 	else {
-		p->cpus_allowed = *new_mask;
-		p->rt.nr_cpus_allowed = cpus_weight(*new_mask);
+		cpumask_copy(&p->cpus_allowed, new_mask);
+		p->rt.nr_cpus_allowed = cpumask_weight(new_mask);
 	}
 
 	/* Can the task run on the task's current CPU? If so, we're done */
-	if (cpu_isset(task_cpu(p), *new_mask))
+	if (cpumask_test_cpu(task_cpu(p), new_mask))
 		goto out;
 
-	if (migrate_task(p, any_online_cpu(*new_mask), &req)) {
+	if (migrate_task(p, cpumask_any_and(cpu_online_mask, new_mask), &req)) {
 		/* Need help from migration thread: drop lock and wait. */
 		task_rq_unlock(rq, &flags);
 		wake_up_process(rq->migration_thread);
@@ -6033,7 +6122,7 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	if (task_cpu(p) != src_cpu)
 		goto done;
 	/* Affinity changed (again). */
-	if (!cpu_isset(dest_cpu, p->cpus_allowed))
+	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
 		goto fail;
 
 	on_rq = p->se.on_rq;
@@ -6130,50 +6219,43 @@ static int __migrate_task_irq(struct task_struct *p, int src_cpu, int dest_cpu)
  */
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
-	unsigned long flags;
-	cpumask_t mask;
-	struct rq *rq;
 	int dest_cpu;
+	/* FIXME: Use cpumask_of_node here. */
+	cpumask_t _nodemask = node_to_cpumask(cpu_to_node(dead_cpu));
+	const struct cpumask *nodemask = &_nodemask;
+
+again:
+	/* Look for allowed, online CPU in same node. */
+	for_each_cpu_and(dest_cpu, nodemask, cpu_online_mask)
+		if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
+			goto move;
+
+	/* Any allowed, online CPU? */
+	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_online_mask);
+	if (dest_cpu < nr_cpu_ids)
+		goto move;
+
+	/* No more Mr. Nice Guy. */
+	if (dest_cpu >= nr_cpu_ids) {
+		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
+		dest_cpu = cpumask_any_and(cpu_online_mask, &p->cpus_allowed);
 
-	do {
-		/* On same node? */
-		mask = node_to_cpumask(cpu_to_node(dead_cpu));
-		cpus_and(mask, mask, p->cpus_allowed);
-		dest_cpu = any_online_cpu(mask);
-
-		/* On any allowed CPU? */
-		if (dest_cpu >= nr_cpu_ids)
-			dest_cpu = any_online_cpu(p->cpus_allowed);
-
-		/* No more Mr. Nice Guy. */
-		if (dest_cpu >= nr_cpu_ids) {
-			cpumask_t cpus_allowed;
-
-			cpuset_cpus_allowed_locked(p, &cpus_allowed);
-			/*
-			 * Try to stay on the same cpuset, where the
-			 * current cpuset may be a subset of all cpus.
-			 * The cpuset_cpus_allowed_locked() variant of
-			 * cpuset_cpus_allowed() will not block. It must be
-			 * called within calls to cpuset_lock/cpuset_unlock.
-			 */
-			rq = task_rq_lock(p, &flags);
-			p->cpus_allowed = cpus_allowed;
-			dest_cpu = any_online_cpu(p->cpus_allowed);
-			task_rq_unlock(rq, &flags);
-
-			/*
-			 * Don't tell them about moving exiting tasks or
-			 * kernel threads (both mm NULL), since they never
-			 * leave kernel.
-			 */
-			if (p->mm && printk_ratelimit()) {
-				printk(KERN_INFO "process %d (%s) no "
-				       "longer affine to cpu%d\n",
-					task_pid_nr(p), p->comm, dead_cpu);
-			}
+		/*
+		 * Don't tell them about moving exiting tasks or
+		 * kernel threads (both mm NULL), since they never
+		 * leave kernel.
+		 */
+		if (p->mm && printk_ratelimit()) {
+			printk(KERN_INFO "process %d (%s) no "
+			       "longer affine to cpu%d\n",
+			       task_pid_nr(p), p->comm, dead_cpu);
 		}
-	} while (!__migrate_task_irq(p, dead_cpu, dest_cpu));
+	}
+
+move:
+	/* It can have affinity changed while we were choosing. */
+	if (unlikely(!__migrate_task_irq(p, dead_cpu, dest_cpu)))
+		goto again;
 }
 
 /*
@@ -6185,7 +6267,7 @@ static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
  */
 static void migrate_nr_uninterruptible(struct rq *rq_src)
 {
-	struct rq *rq_dest = cpu_rq(any_online_cpu(*CPU_MASK_ALL_PTR));
+	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_online_mask));
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -6475,7 +6557,7 @@ static void set_rq_online(struct rq *rq)
 	if (!rq->online) {
 		const struct sched_class *class;
 
-		cpu_set(rq->cpu, rq->rd->online);
+		cpumask_set_cpu(rq->cpu, rq->rd->online);
 		rq->online = 1;
 
 		for_each_class(class) {
@@ -6495,7 +6577,7 @@ static void set_rq_offline(struct rq *rq)
 				class->rq_offline(rq);
 		}
 
-		cpu_clear(rq->cpu, rq->rd->online);
+		cpumask_clear_cpu(rq->cpu, rq->rd->online);
 		rq->online = 0;
 	}
 }
@@ -6536,7 +6618,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		rq = cpu_rq(cpu);
 		spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
-			BUG_ON(!cpu_isset(cpu, rq->rd->span));
+			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
 
 			set_rq_online(rq);
 		}
@@ -6550,7 +6632,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 			break;
 		/* Unbind it from offline cpu so it can run. Fall thru. */
 		kthread_bind(cpu_rq(cpu)->migration_thread,
-			     any_online_cpu(cpu_online_map));
+			     cpumask_any(cpu_online_mask));
 		kthread_stop(cpu_rq(cpu)->migration_thread);
 		cpu_rq(cpu)->migration_thread = NULL;
 		break;
@@ -6600,7 +6682,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		rq = cpu_rq(cpu);
 		spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
-			BUG_ON(!cpu_isset(cpu, rq->rd->span));
+			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
 			set_rq_offline(rq);
 		}
 		spin_unlock_irqrestore(&rq->lock, flags);
@@ -6639,13 +6721,13 @@ early_initcall(migration_init);
 #ifdef CONFIG_SCHED_DEBUG
 
 static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
-				  cpumask_t *groupmask)
+				  struct cpumask *groupmask)
 {
 	struct sched_group *group = sd->groups;
 	char str[256];
 
-	cpulist_scnprintf(str, sizeof(str), sd->span);
-	cpus_clear(*groupmask);
+	cpulist_scnprintf(str, sizeof(str), sched_domain_span(sd));
+	cpumask_clear(groupmask);
 
 	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
 
@@ -6659,11 +6741,11 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 
 	printk(KERN_CONT "span %s level %s\n", str, sd->name);
 
-	if (!cpu_isset(cpu, sd->span)) {
+	if (!cpumask_test_cpu(cpu, sched_domain_span(sd))) {
 		printk(KERN_ERR "ERROR: domain->span does not contain "
 				"CPU%d\n", cpu);
 	}
-	if (!cpu_isset(cpu, group->cpumask)) {
+	if (!cpumask_test_cpu(cpu, sched_group_cpus(group))) {
 		printk(KERN_ERR "ERROR: domain->groups does not contain"
 				" CPU%d\n", cpu);
 	}
@@ -6683,31 +6765,32 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 			break;
 		}
 
-		if (!cpus_weight(group->cpumask)) {
+		if (!cpumask_weight(sched_group_cpus(group))) {
 			printk(KERN_CONT "\n");
 			printk(KERN_ERR "ERROR: empty group\n");
 			break;
 		}
 
-		if (cpus_intersects(*groupmask, group->cpumask)) {
+		if (cpumask_intersects(groupmask, sched_group_cpus(group))) {
 			printk(KERN_CONT "\n");
 			printk(KERN_ERR "ERROR: repeated CPUs\n");
 			break;
 		}
 
-		cpus_or(*groupmask, *groupmask, group->cpumask);
+		cpumask_or(groupmask, groupmask, sched_group_cpus(group));
 
-		cpulist_scnprintf(str, sizeof(str), group->cpumask);
+		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
 		printk(KERN_CONT " %s", str);
 
 		group = group->next;
 	} while (group != sd->groups);
 	printk(KERN_CONT "\n");
 
-	if (!cpus_equal(sd->span, *groupmask))
+	if (!cpumask_equal(sched_domain_span(sd), groupmask))
 		printk(KERN_ERR "ERROR: groups don't span domain->span\n");
 
-	if (sd->parent && !cpus_subset(*groupmask, sd->parent->span))
+	if (sd->parent &&
+	    !cpumask_subset(groupmask, sched_domain_span(sd->parent)))
 		printk(KERN_ERR "ERROR: parent span is not a superset "
 			"of domain->span\n");
 	return 0;
@@ -6715,7 +6798,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 
 static void sched_domain_debug(struct sched_domain *sd, int cpu)
 {
-	cpumask_t *groupmask;
+	cpumask_var_t groupmask;
 	int level = 0;
 
 	if (!sd) {
@@ -6725,8 +6808,7 @@ static void sched_domain_debug(struct sched_domain *sd, int cpu)
 
 	printk(KERN_DEBUG "CPU%d attaching sched-domain:\n", cpu);
 
-	groupmask = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
-	if (!groupmask) {
+	if (!alloc_cpumask_var(&groupmask, GFP_KERNEL)) {
 		printk(KERN_DEBUG "Cannot load-balance (out of memory)\n");
 		return;
 	}
@@ -6739,7 +6821,7 @@ static void sched_domain_debug(struct sched_domain *sd, int cpu)
 		if (!sd)
 			break;
 	}
-	kfree(groupmask);
+	free_cpumask_var(groupmask);
 }
 #else /* !CONFIG_SCHED_DEBUG */
 # define sched_domain_debug(sd, cpu) do { } while (0)
@@ -6747,7 +6829,7 @@ static void sched_domain_debug(struct sched_domain *sd, int cpu)
 
 static int sd_degenerate(struct sched_domain *sd)
 {
-	if (cpus_weight(sd->span) == 1)
+	if (cpumask_weight(sched_domain_span(sd)) == 1)
 		return 1;
 
 	/* Following flags need at least 2 groups */
@@ -6778,7 +6860,7 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 	if (sd_degenerate(parent))
 		return 1;
 
-	if (!cpus_equal(sd->span, parent->span))
+	if (!cpumask_equal(sched_domain_span(sd), sched_domain_span(parent)))
 		return 0;
 
 	/* Does parent contain flags not in child? */
@@ -6802,6 +6884,16 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 	return 1;
 }
 
+static void free_rootdomain(struct root_domain *rd)
+{
+	cpupri_cleanup(&rd->cpupri);
+
+	free_cpumask_var(rd->rto_mask);
+	free_cpumask_var(rd->online);
+	free_cpumask_var(rd->span);
+	kfree(rd);
+}
+
 static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 {
 	unsigned long flags;
@@ -6811,38 +6903,63 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	if (rq->rd) {
 		struct root_domain *old_rd = rq->rd;
 
-		if (cpu_isset(rq->cpu, old_rd->online))
+		if (cpumask_test_cpu(rq->cpu, old_rd->online))
 			set_rq_offline(rq);
 
-		cpu_clear(rq->cpu, old_rd->span);
+		cpumask_clear_cpu(rq->cpu, old_rd->span);
 
 		if (atomic_dec_and_test(&old_rd->refcount))
-			kfree(old_rd);
+			free_rootdomain(old_rd);
 	}
 
 	atomic_inc(&rd->refcount);
 	rq->rd = rd;
 
-	cpu_set(rq->cpu, rd->span);
-	if (cpu_isset(rq->cpu, cpu_online_map))
+	cpumask_set_cpu(rq->cpu, rd->span);
+	if (cpumask_test_cpu(rq->cpu, cpu_online_mask))
 		set_rq_online(rq);
 
 	spin_unlock_irqrestore(&rq->lock, flags);
 }
 
-static void init_rootdomain(struct root_domain *rd)
+static int init_rootdomain(struct root_domain *rd, bool bootmem)
 {
 	memset(rd, 0, sizeof(*rd));
 
-	cpus_clear(rd->span);
-	cpus_clear(rd->online);
+	if (bootmem) {
+		alloc_bootmem_cpumask_var(&def_root_domain.span);
+		alloc_bootmem_cpumask_var(&def_root_domain.online);
+		alloc_bootmem_cpumask_var(&def_root_domain.rto_mask);
+		cpupri_init(&rd->cpupri, true);
+		return 0;
+	}
+
+	if (!alloc_cpumask_var(&rd->span, GFP_KERNEL))
+		goto free_rd;
+	if (!alloc_cpumask_var(&rd->online, GFP_KERNEL))
+		goto free_span;
+	if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
+		goto free_online;
+
+	if (cpupri_init(&rd->cpupri, false) != 0)
+		goto free_rto_mask;
+	return 0;
 
-	cpupri_init(&rd->cpupri);
+free_rto_mask:
+	free_cpumask_var(rd->rto_mask);
+free_online:
+	free_cpumask_var(rd->online);
+free_span:
+	free_cpumask_var(rd->span);
+free_rd:
+	kfree(rd);
+	return -ENOMEM;
 }
 
 static void init_defrootdomain(void)
 {
-	init_rootdomain(&def_root_domain);
+	init_rootdomain(&def_root_domain, true);
+
 	atomic_set(&def_root_domain.refcount, 1);
 }
 
@@ -6854,7 +6971,10 @@ static struct root_domain *alloc_rootdomain(void)
 	if (!rd)
 		return NULL;
 
-	init_rootdomain(rd);
+	if (init_rootdomain(rd, false) != 0) {
+		kfree(rd);
+		return NULL;
+	}
 
 	return rd;
 }
@@ -6896,19 +7016,12 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 }
 
 /* cpus with isolated domains */
-static cpumask_t cpu_isolated_map = CPU_MASK_NONE;
+static cpumask_var_t cpu_isolated_map;
 
 /* Setup the mask of cpus configured for isolated domains */
 static int __init isolated_cpu_setup(char *str)
 {
-	static int __initdata ints[NR_CPUS];
-	int i;
-
-	str = get_options(str, ARRAY_SIZE(ints), ints);
-	cpus_clear(cpu_isolated_map);
-	for (i = 1; i <= ints[0]; i++)
-		if (ints[i] < NR_CPUS)
-			cpu_set(ints[i], cpu_isolated_map);
+	cpulist_parse(str, cpu_isolated_map);
 	return 1;
 }
 
@@ -6917,42 +7030,43 @@ __setup("isolcpus=", isolated_cpu_setup);
 /*
  * init_sched_build_groups takes the cpumask we wish to span, and a pointer
  * to a function which identifies what group(along with sched group) a CPU
- * belongs to. The return value of group_fn must be a >= 0 and < NR_CPUS
- * (due to the fact that we keep track of groups covered with a cpumask_t).
+ * belongs to. The return value of group_fn must be a >= 0 and < nr_cpu_ids
+ * (due to the fact that we keep track of groups covered with a struct cpumask).
  *
  * init_sched_build_groups will build a circular linked list of the groups
  * covered by the given span, and will set each group's ->cpumask correctly,
  * and ->cpu_power to 0.
  */
 static void
-init_sched_build_groups(const cpumask_t *span, const cpumask_t *cpu_map,
-			int (*group_fn)(int cpu, const cpumask_t *cpu_map,
+init_sched_build_groups(const struct cpumask *span,
+			const struct cpumask *cpu_map,
+			int (*group_fn)(int cpu, const struct cpumask *cpu_map,
 					struct sched_group **sg,
-					cpumask_t *tmpmask),
-			cpumask_t *covered, cpumask_t *tmpmask)
+					struct cpumask *tmpmask),
+			struct cpumask *covered, struct cpumask *tmpmask)
 {
 	struct sched_group *first = NULL, *last = NULL;
 	int i;
 
-	cpus_clear(*covered);
+	cpumask_clear(covered);
 
-	for_each_cpu_mask_nr(i, *span) {
+	for_each_cpu(i, span) {
 		struct sched_group *sg;
 		int group = group_fn(i, cpu_map, &sg, tmpmask);
 		int j;
 
-		if (cpu_isset(i, *covered))
+		if (cpumask_test_cpu(i, covered))
 			continue;
 
-		cpus_clear(sg->cpumask);
+		cpumask_clear(sched_group_cpus(sg));
 		sg->__cpu_power = 0;
 
-		for_each_cpu_mask_nr(j, *span) {
+		for_each_cpu(j, span) {
 			if (group_fn(j, cpu_map, NULL, tmpmask) != group)
 				continue;
 
-			cpu_set(j, *covered);
-			cpu_set(j, sg->cpumask);
+			cpumask_set_cpu(j, covered);
+			cpumask_set_cpu(j, sched_group_cpus(sg));
 		}
 		if (!first)
 			first = sg;
@@ -7016,9 +7130,10 @@ static int find_next_best_node(int node, nodemask_t *used_nodes)
  * should be one that prevents unnecessary balancing, but also spreads tasks
  * out optimally.
  */
-static void sched_domain_node_span(int node, cpumask_t *span)
+static void sched_domain_node_span(int node, struct cpumask *span)
 {
 	nodemask_t used_nodes;
+	/* FIXME: use cpumask_of_node() */
 	node_to_cpumask_ptr(nodemask, node);
 	int i;
 
@@ -7040,18 +7155,33 @@ static void sched_domain_node_span(int node, cpumask_t *span)
 int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
 
 /*
+ * The cpus mask in sched_group and sched_domain hangs off the end.
+ * FIXME: use cpumask_var_t or dynamic percpu alloc to avoid wasting space
+ * for nr_cpu_ids < CONFIG_NR_CPUS.
+ */
+struct static_sched_group {
+	struct sched_group sg;
+	DECLARE_BITMAP(cpus, CONFIG_NR_CPUS);
+};
+
+struct static_sched_domain {
+	struct sched_domain sd;
+	DECLARE_BITMAP(span, CONFIG_NR_CPUS);
+};
+
+/*
  * SMT sched-domains:
  */
 #ifdef CONFIG_SCHED_SMT
-static DEFINE_PER_CPU(struct sched_domain, cpu_domains);
-static DEFINE_PER_CPU(struct sched_group, sched_group_cpus);
+static DEFINE_PER_CPU(struct static_sched_domain, cpu_domains);
+static DEFINE_PER_CPU(struct static_sched_group, sched_group_cpus);
 
 static int
-cpu_to_cpu_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
-		 cpumask_t *unused)
+cpu_to_cpu_group(int cpu, const struct cpumask *cpu_map,
+		 struct sched_group **sg, struct cpumask *unused)
 {
 	if (sg)
-		*sg = &per_cpu(sched_group_cpus, cpu);
+		*sg = &per_cpu(sched_group_cpus, cpu).sg;
 	return cpu;
 }
 #endif /* CONFIG_SCHED_SMT */
@@ -7060,56 +7190,55 @@ cpu_to_cpu_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
  * multi-core sched-domains:
  */
 #ifdef CONFIG_SCHED_MC
-static DEFINE_PER_CPU(struct sched_domain, core_domains);
-static DEFINE_PER_CPU(struct sched_group, sched_group_core);
+static DEFINE_PER_CPU(struct static_sched_domain, core_domains);
+static DEFINE_PER_CPU(struct static_sched_group, sched_group_core);
 #endif /* CONFIG_SCHED_MC */
 
 #if defined(CONFIG_SCHED_MC) && defined(CONFIG_SCHED_SMT)
 static int
-cpu_to_core_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
-		  cpumask_t *mask)
+cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
+		  struct sched_group **sg, struct cpumask *mask)
 {
 	int group;
 
-	*mask = per_cpu(cpu_sibling_map, cpu);
-	cpus_and(*mask, *mask, *cpu_map);
-	group = first_cpu(*mask);
+	cpumask_and(mask, &per_cpu(cpu_sibling_map, cpu), cpu_map);
+	group = cpumask_first(mask);
 	if (sg)
-		*sg = &per_cpu(sched_group_core, group);
+		*sg = &per_cpu(sched_group_core, group).sg;
 	return group;
 }
 #elif defined(CONFIG_SCHED_MC)
 static int
-cpu_to_core_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
-		  cpumask_t *unused)
+cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
+		  struct sched_group **sg, struct cpumask *unused)
 {
 	if (sg)
-		*sg = &per_cpu(sched_group_core, cpu);
+		*sg = &per_cpu(sched_group_core, cpu).sg;
 	return cpu;
 }
 #endif
 
-static DEFINE_PER_CPU(struct sched_domain, phys_domains);
-static DEFINE_PER_CPU(struct sched_group, sched_group_phys);
+static DEFINE_PER_CPU(struct static_sched_domain, phys_domains);
+static DEFINE_PER_CPU(struct static_sched_group, sched_group_phys);
 
 static int
-cpu_to_phys_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
-		  cpumask_t *mask)
+cpu_to_phys_group(int cpu, const struct cpumask *cpu_map,
+		  struct sched_group **sg, struct cpumask *mask)
 {
 	int group;
 #ifdef CONFIG_SCHED_MC
+	/* FIXME: Use cpu_coregroup_mask. */
 	*mask = cpu_coregroup_map(cpu);
 	cpus_and(*mask, *mask, *cpu_map);
-	group = first_cpu(*mask);
+	group = cpumask_first(mask);
 #elif defined(CONFIG_SCHED_SMT)
-	*mask = per_cpu(cpu_sibling_map, cpu);
-	cpus_and(*mask, *mask, *cpu_map);
-	group = first_cpu(*mask);
+	cpumask_and(mask, &per_cpu(cpu_sibling_map, cpu), cpu_map);
+	group = cpumask_first(mask);
 #else
 	group = cpu;
 #endif
 	if (sg)
-		*sg = &per_cpu(sched_group_phys, group);
+		*sg = &per_cpu(sched_group_phys, group).sg;
 	return group;
 }
 
@@ -7123,19 +7252,21 @@ static DEFINE_PER_CPU(struct sched_domain, node_domains);
 static struct sched_group ***sched_group_nodes_bycpu;
 
 static DEFINE_PER_CPU(struct sched_domain, allnodes_domains);
-static DEFINE_PER_CPU(struct sched_group, sched_group_allnodes);
+static DEFINE_PER_CPU(struct static_sched_group, sched_group_allnodes);
 
-static int cpu_to_allnodes_group(int cpu, const cpumask_t *cpu_map,
-				 struct sched_group **sg, cpumask_t *nodemask)
+static int cpu_to_allnodes_group(int cpu, const struct cpumask *cpu_map,
+				 struct sched_group **sg,
+				 struct cpumask *nodemask)
 {
 	int group;
+	/* FIXME: use cpumask_of_node */
+	node_to_cpumask_ptr(pnodemask, cpu_to_node(cpu));
 
-	*nodemask = node_to_cpumask(cpu_to_node(cpu));
-	cpus_and(*nodemask, *nodemask, *cpu_map);
-	group = first_cpu(*nodemask);
+	cpumask_and(nodemask, pnodemask, cpu_map);
+	group = cpumask_first(nodemask);
 
 	if (sg)
-		*sg = &per_cpu(sched_group_allnodes, group);
+		*sg = &per_cpu(sched_group_allnodes, group).sg;
 	return group;
 }
 
@@ -7147,11 +7278,11 @@ static void init_numa_sched_groups_power(struct sched_group *group_head)
 	if (!sg)
 		return;
 	do {
-		for_each_cpu_mask_nr(j, sg->cpumask) {
+		for_each_cpu(j, sched_group_cpus(sg)) {
 			struct sched_domain *sd;
 
-			sd = &per_cpu(phys_domains, j);
-			if (j != first_cpu(sd->groups->cpumask)) {
+			sd = &per_cpu(phys_domains, j).sd;
+			if (j != cpumask_first(sched_group_cpus(sd->groups))) {
 				/*
 				 * Only add "power" once for each
 				 * physical package.
@@ -7168,11 +7299,12 @@ static void init_numa_sched_groups_power(struct sched_group *group_head)
 
 #ifdef CONFIG_NUMA
 /* Free memory allocated for various sched_group structures */
-static void free_sched_groups(const cpumask_t *cpu_map, cpumask_t *nodemask)
+static void free_sched_groups(const struct cpumask *cpu_map,
+			      struct cpumask *nodemask)
 {
 	int cpu, i;
 
-	for_each_cpu_mask_nr(cpu, *cpu_map) {
+	for_each_cpu(cpu, cpu_map) {
 		struct sched_group **sched_group_nodes
 			= sched_group_nodes_bycpu[cpu];
 
@@ -7181,10 +7313,11 @@ static void free_sched_groups(const cpumask_t *cpu_map, cpumask_t *nodemask)
 
 		for (i = 0; i < nr_node_ids; i++) {
 			struct sched_group *oldsg, *sg = sched_group_nodes[i];
+			/* FIXME: Use cpumask_of_node */
+			node_to_cpumask_ptr(pnodemask, i);
 
-			*nodemask = node_to_cpumask(i);
-			cpus_and(*nodemask, *nodemask, *cpu_map);
-			if (cpus_empty(*nodemask))
+			cpus_and(*nodemask, *pnodemask, *cpu_map);
+			if (cpumask_empty(nodemask))
 				continue;
 
 			if (sg == NULL)
@@ -7202,7 +7335,8 @@ next_sg:
 	}
 }
 #else /* !CONFIG_NUMA */
-static void free_sched_groups(const cpumask_t *cpu_map, cpumask_t *nodemask)
+static void free_sched_groups(const struct cpumask *cpu_map,
+			      struct cpumask *nodemask)
 {
 }
 #endif /* CONFIG_NUMA */
@@ -7228,7 +7362,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 
 	WARN_ON(!sd || !sd->groups);
 
-	if (cpu != first_cpu(sd->groups->cpumask))
+	if (cpu != cpumask_first(sched_group_cpus(sd->groups)))
 		return;
 
 	child = sd->child;
@@ -7293,48 +7427,6 @@ SD_INIT_FUNC(CPU)
  SD_INIT_FUNC(MC)
 #endif
 
-/*
- * To minimize stack usage kmalloc room for cpumasks and share the
- * space as the usage in build_sched_domains() dictates.  Used only
- * if the amount of space is significant.
- */
-struct allmasks {
-	cpumask_t tmpmask;			/* make this one first */
-	union {
-		cpumask_t nodemask;
-		cpumask_t this_sibling_map;
-		cpumask_t this_core_map;
-	};
-	cpumask_t send_covered;
-
-#ifdef CONFIG_NUMA
-	cpumask_t domainspan;
-	cpumask_t covered;
-	cpumask_t notcovered;
-#endif
-};
-
-#if	NR_CPUS > 128
-#define SCHED_CPUMASK_DECLARE(v)	struct allmasks *v
-static inline void sched_cpumask_alloc(struct allmasks **masks)
-{
-	*masks = kmalloc(sizeof(**masks), GFP_KERNEL);
-}
-static inline void sched_cpumask_free(struct allmasks *masks)
-{
-	kfree(masks);
-}
-#else
-#define SCHED_CPUMASK_DECLARE(v)	struct allmasks _v, *v = &_v
-static inline void sched_cpumask_alloc(struct allmasks **masks)
-{ }
-static inline void sched_cpumask_free(struct allmasks *masks)
-{ }
-#endif
-
-#define	SCHED_CPUMASK_VAR(v, a) 	cpumask_t *v = (cpumask_t *) \
-			((unsigned long)(a) + offsetof(struct allmasks, v))
-
 static int default_relax_domain_level = -1;
 
 static int __init setup_relax_domain_level(char *str)
@@ -7374,17 +7466,38 @@ static void set_domain_attribute(struct sched_domain *sd,
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
  */
-static int __build_sched_domains(const cpumask_t *cpu_map,
+static int __build_sched_domains(const struct cpumask *cpu_map,
 				 struct sched_domain_attr *attr)
 {
-	int i;
+	int i, err = -ENOMEM;
 	struct root_domain *rd;
-	SCHED_CPUMASK_DECLARE(allmasks);
-	cpumask_t *tmpmask;
+	cpumask_var_t nodemask, this_sibling_map, this_core_map, send_covered,
+		tmpmask;
 #ifdef CONFIG_NUMA
+	cpumask_var_t domainspan, covered, notcovered;
 	struct sched_group **sched_group_nodes = NULL;
 	int sd_allnodes = 0;
 
+	if (!alloc_cpumask_var(&domainspan, GFP_KERNEL))
+		goto out;
+	if (!alloc_cpumask_var(&covered, GFP_KERNEL))
+		goto free_domainspan;
+	if (!alloc_cpumask_var(&notcovered, GFP_KERNEL))
+		goto free_covered;
+#endif
+
+	if (!alloc_cpumask_var(&nodemask, GFP_KERNEL))
+		goto free_notcovered;
+	if (!alloc_cpumask_var(&this_sibling_map, GFP_KERNEL))
+		goto free_nodemask;
+	if (!alloc_cpumask_var(&this_core_map, GFP_KERNEL))
+		goto free_this_sibling_map;
+	if (!alloc_cpumask_var(&send_covered, GFP_KERNEL))
+		goto free_this_core_map;
+	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL))
+		goto free_send_covered;
+
+#ifdef CONFIG_NUMA
 	/*
 	 * Allocate the per-node list of sched groups
 	 */
@@ -7392,54 +7505,37 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 				    GFP_KERNEL);
 	if (!sched_group_nodes) {
 		printk(KERN_WARNING "Can not alloc sched group node list\n");
-		return -ENOMEM;
+		goto free_tmpmask;
 	}
 #endif
 
 	rd = alloc_rootdomain();
 	if (!rd) {
 		printk(KERN_WARNING "Cannot alloc root domain\n");
-#ifdef CONFIG_NUMA
-		kfree(sched_group_nodes);
-#endif
-		return -ENOMEM;
+		goto free_sched_groups;
 	}
 
-	/* get space for all scratch cpumask variables */
-	sched_cpumask_alloc(&allmasks);
-	if (!allmasks) {
-		printk(KERN_WARNING "Cannot alloc cpumask array\n");
-		kfree(rd);
 #ifdef CONFIG_NUMA
-		kfree(sched_group_nodes);
-#endif
-		return -ENOMEM;
-	}
-
-	tmpmask = (cpumask_t *)allmasks;
-
-
-#ifdef CONFIG_NUMA
-	sched_group_nodes_bycpu[first_cpu(*cpu_map)] = sched_group_nodes;
+	sched_group_nodes_bycpu[cpumask_first(cpu_map)] = sched_group_nodes;
 #endif
 
 	/*
 	 * Set up domains for cpus specified by the cpu_map.
 	 */
-	for_each_cpu_mask_nr(i, *cpu_map) {
+	for_each_cpu(i, cpu_map) {
 		struct sched_domain *sd = NULL, *p;
-		SCHED_CPUMASK_VAR(nodemask, allmasks);
 
+		/* FIXME: use cpumask_of_node */
 		*nodemask = node_to_cpumask(cpu_to_node(i));
 		cpus_and(*nodemask, *nodemask, *cpu_map);
 
 #ifdef CONFIG_NUMA
-		if (cpus_weight(*cpu_map) >
-				SD_NODES_PER_DOMAIN*cpus_weight(*nodemask)) {
+		if (cpumask_weight(cpu_map) >
+				SD_NODES_PER_DOMAIN*cpumask_weight(nodemask)) {
 			sd = &per_cpu(allnodes_domains, i);
 			SD_INIT(sd, ALLNODES);
 			set_domain_attribute(sd, attr);
-			sd->span = *cpu_map;
+			cpumask_copy(sched_domain_span(sd), cpu_map);
 			cpu_to_allnodes_group(i, cpu_map, &sd->groups, tmpmask);
 			p = sd;
 			sd_allnodes = 1;
@@ -7449,18 +7545,19 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		sd = &per_cpu(node_domains, i);
 		SD_INIT(sd, NODE);
 		set_domain_attribute(sd, attr);
-		sched_domain_node_span(cpu_to_node(i), &sd->span);
+		sched_domain_node_span(cpu_to_node(i), sched_domain_span(sd));
 		sd->parent = p;
 		if (p)
 			p->child = sd;
-		cpus_and(sd->span, sd->span, *cpu_map);
+		cpumask_and(sched_domain_span(sd),
+			    sched_domain_span(sd), cpu_map);
 #endif
 
 		p = sd;
-		sd = &per_cpu(phys_domains, i);
+		sd = &per_cpu(phys_domains, i).sd;
 		SD_INIT(sd, CPU);
 		set_domain_attribute(sd, attr);
-		sd->span = *nodemask;
+		cpumask_copy(sched_domain_span(sd), nodemask);
 		sd->parent = p;
 		if (p)
 			p->child = sd;
@@ -7468,11 +7565,12 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 
 #ifdef CONFIG_SCHED_MC
 		p = sd;
-		sd = &per_cpu(core_domains, i);
+		sd = &per_cpu(core_domains, i).sd;
 		SD_INIT(sd, MC);
 		set_domain_attribute(sd, attr);
-		sd->span = cpu_coregroup_map(i);
-		cpus_and(sd->span, sd->span, *cpu_map);
+		*sched_domain_span(sd) = cpu_coregroup_map(i);
+		cpumask_and(sched_domain_span(sd),
+			    sched_domain_span(sd), cpu_map);
 		sd->parent = p;
 		p->child = sd;
 		cpu_to_core_group(i, cpu_map, &sd->groups, tmpmask);
@@ -7480,11 +7578,11 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 
 #ifdef CONFIG_SCHED_SMT
 		p = sd;
-		sd = &per_cpu(cpu_domains, i);
+		sd = &per_cpu(cpu_domains, i).sd;
 		SD_INIT(sd, SIBLING);
 		set_domain_attribute(sd, attr);
-		sd->span = per_cpu(cpu_sibling_map, i);
-		cpus_and(sd->span, sd->span, *cpu_map);
+		cpumask_and(sched_domain_span(sd),
+			    &per_cpu(cpu_sibling_map, i), cpu_map);
 		sd->parent = p;
 		p->child = sd;
 		cpu_to_cpu_group(i, cpu_map, &sd->groups, tmpmask);
@@ -7493,13 +7591,10 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 
 #ifdef CONFIG_SCHED_SMT
 	/* Set up CPU (sibling) groups */
-	for_each_cpu_mask_nr(i, *cpu_map) {
-		SCHED_CPUMASK_VAR(this_sibling_map, allmasks);
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
-
-		*this_sibling_map = per_cpu(cpu_sibling_map, i);
-		cpus_and(*this_sibling_map, *this_sibling_map, *cpu_map);
-		if (i != first_cpu(*this_sibling_map))
+	for_each_cpu(i, cpu_map) {
+		cpumask_and(this_sibling_map,
+			    &per_cpu(cpu_sibling_map, i), cpu_map);
+		if (i != cpumask_first(this_sibling_map))
 			continue;
 
 		init_sched_build_groups(this_sibling_map, cpu_map,
@@ -7510,13 +7605,11 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 
 #ifdef CONFIG_SCHED_MC
 	/* Set up multi-core groups */
-	for_each_cpu_mask_nr(i, *cpu_map) {
-		SCHED_CPUMASK_VAR(this_core_map, allmasks);
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
-
+	for_each_cpu(i, cpu_map) {
+		/* FIXME: Use cpu_coregroup_mask */
 		*this_core_map = cpu_coregroup_map(i);
 		cpus_and(*this_core_map, *this_core_map, *cpu_map);
-		if (i != first_cpu(*this_core_map))
+		if (i != cpumask_first(this_core_map))
 			continue;
 
 		init_sched_build_groups(this_core_map, cpu_map,
@@ -7527,12 +7620,10 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 
 	/* Set up physical groups */
 	for (i = 0; i < nr_node_ids; i++) {
-		SCHED_CPUMASK_VAR(nodemask, allmasks);
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
-
+		/* FIXME: Use cpumask_of_node */
 		*nodemask = node_to_cpumask(i);
 		cpus_and(*nodemask, *nodemask, *cpu_map);
-		if (cpus_empty(*nodemask))
+		if (cpumask_empty(nodemask))
 			continue;
 
 		init_sched_build_groups(nodemask, cpu_map,
@@ -7543,8 +7634,6 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 #ifdef CONFIG_NUMA
 	/* Set up node groups */
 	if (sd_allnodes) {
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
-
 		init_sched_build_groups(cpu_map, cpu_map,
 					&cpu_to_allnodes_group,
 					send_covered, tmpmask);
@@ -7553,58 +7642,58 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 	for (i = 0; i < nr_node_ids; i++) {
 		/* Set up node groups */
 		struct sched_group *sg, *prev;
-		SCHED_CPUMASK_VAR(nodemask, allmasks);
-		SCHED_CPUMASK_VAR(domainspan, allmasks);
-		SCHED_CPUMASK_VAR(covered, allmasks);
 		int j;
 
+		/* FIXME: Use cpumask_of_node */
 		*nodemask = node_to_cpumask(i);
-		cpus_clear(*covered);
+		cpumask_clear(covered);
 
 		cpus_and(*nodemask, *nodemask, *cpu_map);
-		if (cpus_empty(*nodemask)) {
+		if (cpumask_empty(nodemask)) {
 			sched_group_nodes[i] = NULL;
 			continue;
 		}
 
 		sched_domain_node_span(i, domainspan);
-		cpus_and(*domainspan, *domainspan, *cpu_map);
+		cpumask_and(domainspan, domainspan, cpu_map);
 
-		sg = kmalloc_node(sizeof(struct sched_group), GFP_KERNEL, i);
+		sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
+				  GFP_KERNEL, i);
 		if (!sg) {
 			printk(KERN_WARNING "Can not alloc domain group for "
 				"node %d\n", i);
 			goto error;
 		}
 		sched_group_nodes[i] = sg;
-		for_each_cpu_mask_nr(j, *nodemask) {
+		for_each_cpu(j, nodemask) {
 			struct sched_domain *sd;
 
 			sd = &per_cpu(node_domains, j);
 			sd->groups = sg;
 		}
 		sg->__cpu_power = 0;
-		sg->cpumask = *nodemask;
+		cpumask_copy(sched_group_cpus(sg), nodemask);
 		sg->next = sg;
-		cpus_or(*covered, *covered, *nodemask);
+		cpumask_or(covered, covered, nodemask);
 		prev = sg;
 
 		for (j = 0; j < nr_node_ids; j++) {
-			SCHED_CPUMASK_VAR(notcovered, allmasks);
 			int n = (i + j) % nr_node_ids;
+			/* FIXME: Use cpumask_of_node */
 			node_to_cpumask_ptr(pnodemask, n);
 
-			cpus_complement(*notcovered, *covered);
-			cpus_and(*tmpmask, *notcovered, *cpu_map);
-			cpus_and(*tmpmask, *tmpmask, *domainspan);
-			if (cpus_empty(*tmpmask))
+			cpumask_complement(notcovered, covered);
+			cpumask_and(tmpmask, notcovered, cpu_map);
+			cpumask_and(tmpmask, tmpmask, domainspan);
+			if (cpumask_empty(tmpmask))
 				break;
 
-			cpus_and(*tmpmask, *tmpmask, *pnodemask);
-			if (cpus_empty(*tmpmask))
+			cpumask_and(tmpmask, tmpmask, pnodemask);
+			if (cpumask_empty(tmpmask))
 				continue;
 
-			sg = kmalloc_node(sizeof(struct sched_group),
+			sg = kmalloc_node(sizeof(struct sched_group) +
+					  cpumask_size(),
 					  GFP_KERNEL, i);
 			if (!sg) {
 				printk(KERN_WARNING
@@ -7612,9 +7701,9 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 				goto error;
 			}
 			sg->__cpu_power = 0;
-			sg->cpumask = *tmpmask;
+			cpumask_copy(sched_group_cpus(sg), tmpmask);
 			sg->next = prev->next;
-			cpus_or(*covered, *covered, *tmpmask);
+			cpumask_or(covered, covered, tmpmask);
 			prev->next = sg;
 			prev = sg;
 		}
@@ -7623,22 +7712,22 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 
 	/* Calculate CPU power for physical packages and nodes */
 #ifdef CONFIG_SCHED_SMT
-	for_each_cpu_mask_nr(i, *cpu_map) {
-		struct sched_domain *sd = &per_cpu(cpu_domains, i);
+	for_each_cpu(i, cpu_map) {
+		struct sched_domain *sd = &per_cpu(cpu_domains, i).sd;
 
 		init_sched_groups_power(i, sd);
 	}
 #endif
 #ifdef CONFIG_SCHED_MC
-	for_each_cpu_mask_nr(i, *cpu_map) {
-		struct sched_domain *sd = &per_cpu(core_domains, i);
+	for_each_cpu(i, cpu_map) {
+		struct sched_domain *sd = &per_cpu(core_domains, i).sd;
 
 		init_sched_groups_power(i, sd);
 	}
 #endif
 
-	for_each_cpu_mask_nr(i, *cpu_map) {
-		struct sched_domain *sd = &per_cpu(phys_domains, i);
+	for_each_cpu(i, cpu_map) {
+		struct sched_domain *sd = &per_cpu(phys_domains, i).sd;
 
 		init_sched_groups_power(i, sd);
 	}
@@ -7650,53 +7739,78 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 	if (sd_allnodes) {
 		struct sched_group *sg;
 
-		cpu_to_allnodes_group(first_cpu(*cpu_map), cpu_map, &sg,
+		cpu_to_allnodes_group(cpumask_first(cpu_map), cpu_map, &sg,
 								tmpmask);
 		init_numa_sched_groups_power(sg);
 	}
 #endif
 
 	/* Attach the domains */
-	for_each_cpu_mask_nr(i, *cpu_map) {
+	for_each_cpu(i, cpu_map) {
 		struct sched_domain *sd;
 #ifdef CONFIG_SCHED_SMT
-		sd = &per_cpu(cpu_domains, i);
+		sd = &per_cpu(cpu_domains, i).sd;
 #elif defined(CONFIG_SCHED_MC)
-		sd = &per_cpu(core_domains, i);
+		sd = &per_cpu(core_domains, i).sd;
 #else
-		sd = &per_cpu(phys_domains, i);
+		sd = &per_cpu(phys_domains, i).sd;
 #endif
 		cpu_attach_domain(sd, rd, i);
 	}
 
-	sched_cpumask_free(allmasks);
-	return 0;
+	err = 0;
+
+free_tmpmask:
+	free_cpumask_var(tmpmask);
+free_send_covered:
+	free_cpumask_var(send_covered);
+free_this_core_map:
+	free_cpumask_var(this_core_map);
+free_this_sibling_map:
+	free_cpumask_var(this_sibling_map);
+free_nodemask:
+	free_cpumask_var(nodemask);
+free_notcovered:
+#ifdef CONFIG_NUMA
+	free_cpumask_var(notcovered);
+free_covered:
+	free_cpumask_var(covered);
+free_domainspan:
+	free_cpumask_var(domainspan);
+out:
+#endif
+	return err;
+
+free_sched_groups:
+#ifdef CONFIG_NUMA
+	kfree(sched_group_nodes);
+#endif
+	goto free_tmpmask;
 
 #ifdef CONFIG_NUMA
 error:
 	free_sched_groups(cpu_map, tmpmask);
-	sched_cpumask_free(allmasks);
-	kfree(rd);
-	return -ENOMEM;
+	free_rootdomain(rd);
+	goto free_tmpmask;
 #endif
 }
 
-static int build_sched_domains(const cpumask_t *cpu_map)
+static int build_sched_domains(const struct cpumask *cpu_map)
 {
 	return __build_sched_domains(cpu_map, NULL);
 }
 
-static cpumask_t *doms_cur;	/* current sched domains */
+static struct cpumask *doms_cur;	/* current sched domains */
 static int ndoms_cur;		/* number of sched domains in 'doms_cur' */
 static struct sched_domain_attr *dattr_cur;
 				/* attribues of custom domains in 'doms_cur' */
 
 /*
  * Special case: If a kmalloc of a doms_cur partition (array of
- * cpumask_t) fails, then fallback to a single sched domain,
- * as determined by the single cpumask_t fallback_doms.
+ * cpumask) fails, then fallback to a single sched domain,
+ * as determined by the single cpumask fallback_doms.
  */
-static cpumask_t fallback_doms;
+static cpumask_var_t fallback_doms;
 
 /*
  * arch_update_cpu_topology lets virtualized architectures update the
@@ -7713,16 +7827,16 @@ int __attribute__((weak)) arch_update_cpu_topology(void)
  * For now this just excludes isolated cpus, but could be used to
  * exclude other special cases in the future.
  */
-static int arch_init_sched_domains(const cpumask_t *cpu_map)
+static int arch_init_sched_domains(const struct cpumask *cpu_map)
 {
 	int err;
 
 	arch_update_cpu_topology();
 	ndoms_cur = 1;
-	doms_cur = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
+	doms_cur = kmalloc(cpumask_size(), GFP_KERNEL);
 	if (!doms_cur)
-		doms_cur = &fallback_doms;
-	cpus_andnot(*doms_cur, *cpu_map, cpu_isolated_map);
+		doms_cur = fallback_doms;
+	cpumask_andnot(doms_cur, cpu_map, cpu_isolated_map);
 	dattr_cur = NULL;
 	err = build_sched_domains(doms_cur);
 	register_sched_domain_sysctl();
@@ -7730,8 +7844,8 @@ static int arch_init_sched_domains(const cpumask_t *cpu_map)
 	return err;
 }
 
-static void arch_destroy_sched_domains(const cpumask_t *cpu_map,
-				       cpumask_t *tmpmask)
+static void arch_destroy_sched_domains(const struct cpumask *cpu_map,
+				       struct cpumask *tmpmask)
 {
 	free_sched_groups(cpu_map, tmpmask);
 }
@@ -7740,15 +7854,16 @@ static void arch_destroy_sched_domains(const cpumask_t *cpu_map,
  * Detach sched domains from a group of cpus specified in cpu_map
  * These cpus will now be attached to the NULL domain
  */
-static void detach_destroy_domains(const cpumask_t *cpu_map)
+static void detach_destroy_domains(const struct cpumask *cpu_map)
 {
-	cpumask_t tmpmask;
+	/* Save because hotplug lock held. */
+	static DECLARE_BITMAP(tmpmask, CONFIG_NR_CPUS);
 	int i;
 
-	for_each_cpu_mask_nr(i, *cpu_map)
+	for_each_cpu(i, cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
 	synchronize_sched();
-	arch_destroy_sched_domains(cpu_map, &tmpmask);
+	arch_destroy_sched_domains(cpu_map, to_cpumask(tmpmask));
 }
 
 /* handle null as "default" */
@@ -7773,7 +7888,7 @@ static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
  * doms_new[] to the current sched domain partitioning, doms_cur[].
  * It destroys each deleted domain and builds each new domain.
  *
- * 'doms_new' is an array of cpumask_t's of length 'ndoms_new'.
+ * 'doms_new' is an array of cpumask's of length 'ndoms_new'.
  * The masks don't intersect (don't overlap.) We should setup one
  * sched domain for each mask. CPUs not in any of the cpumasks will
  * not be load balanced. If the same cpumask appears both in the
@@ -7787,13 +7902,14 @@ static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
  * the single partition 'fallback_doms', it also forces the domains
  * to be rebuilt.
  *
- * If doms_new == NULL it will be replaced with cpu_online_map.
+ * If doms_new == NULL it will be replaced with cpu_online_mask.
  * ndoms_new == 0 is a special case for destroying existing domains,
  * and it will not create the default domain.
  *
  * Call with hotplug lock held
  */
-void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
+/* FIXME: Change to struct cpumask *doms_new[] */
+void partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
 			     struct sched_domain_attr *dattr_new)
 {
 	int i, j, n;
@@ -7812,7 +7928,7 @@ void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
 	/* Destroy deleted domains */
 	for (i = 0; i < ndoms_cur; i++) {
 		for (j = 0; j < n && !new_topology; j++) {
-			if (cpus_equal(doms_cur[i], doms_new[j])
+			if (cpumask_equal(&doms_cur[i], &doms_new[j])
 			    && dattrs_equal(dattr_cur, i, dattr_new, j))
 				goto match1;
 		}
@@ -7824,15 +7940,15 @@ match1:
 
 	if (doms_new == NULL) {
 		ndoms_cur = 0;
-		doms_new = &fallback_doms;
-		cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
+		doms_new = fallback_doms;
+		cpumask_andnot(&doms_new[0], cpu_online_mask, cpu_isolated_map);
 		WARN_ON_ONCE(dattr_new);
 	}
 
 	/* Build new domains */
 	for (i = 0; i < ndoms_new; i++) {
 		for (j = 0; j < ndoms_cur && !new_topology; j++) {
-			if (cpus_equal(doms_new[i], doms_cur[j])
+			if (cpumask_equal(&doms_new[i], &doms_cur[j])
 			    && dattrs_equal(dattr_new, i, dattr_cur, j))
 				goto match2;
 		}
@@ -7844,7 +7960,7 @@ match2:
 	}
 
 	/* Remember the new sched domains */
-	if (doms_cur != &fallback_doms)
+	if (doms_cur != fallback_doms)
 		kfree(doms_cur);
 	kfree(dattr_cur);	/* kfree(NULL) is safe */
 	doms_cur = doms_new;
@@ -7873,14 +7989,25 @@ int arch_reinit_sched_domains(void)
 static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
 {
 	int ret;
+	unsigned int level = 0;
 
-	if (buf[0] != '0' && buf[0] != '1')
+	if (sscanf(buf, "%u", &level) != 1)
+		return -EINVAL;
+
+	/*
+	 * level is always be positive so don't check for
+	 * level < POWERSAVINGS_BALANCE_NONE which is 0
+	 * What happens on 0 or 1 byte write,
+	 * need to check for count as well?
+	 */
+
+	if (level >= MAX_POWERSAVINGS_BALANCE_LEVELS)
 		return -EINVAL;
 
 	if (smt)
-		sched_smt_power_savings = (buf[0] == '1');
+		sched_smt_power_savings = level;
 	else
-		sched_mc_power_savings = (buf[0] == '1');
+		sched_mc_power_savings = level;
 
 	ret = arch_reinit_sched_domains();
 
@@ -7984,7 +8111,9 @@ static int update_runtime(struct notifier_block *nfb,
 
 void __init sched_init_smp(void)
 {
-	cpumask_t non_isolated_cpus;
+	cpumask_var_t non_isolated_cpus;
+
+	alloc_cpumask_var(&non_isolated_cpus, GFP_KERNEL);
 
 #if defined(CONFIG_NUMA)
 	sched_group_nodes_bycpu = kzalloc(nr_cpu_ids * sizeof(void **),
@@ -7993,10 +8122,10 @@ void __init sched_init_smp(void)
 #endif
 	get_online_cpus();
 	mutex_lock(&sched_domains_mutex);
-	arch_init_sched_domains(&cpu_online_map);
-	cpus_andnot(non_isolated_cpus, cpu_possible_map, cpu_isolated_map);
-	if (cpus_empty(non_isolated_cpus))
-		cpu_set(smp_processor_id(), non_isolated_cpus);
+	arch_init_sched_domains(cpu_online_mask);
+	cpumask_andnot(non_isolated_cpus, cpu_possible_mask, cpu_isolated_map);
+	if (cpumask_empty(non_isolated_cpus))
+		cpumask_set_cpu(smp_processor_id(), non_isolated_cpus);
 	mutex_unlock(&sched_domains_mutex);
 	put_online_cpus();
 
@@ -8011,9 +8140,13 @@ void __init sched_init_smp(void)
 	init_hrtick();
 
 	/* Move init over to a non-isolated CPU */
-	if (set_cpus_allowed_ptr(current, &non_isolated_cpus) < 0)
+	if (set_cpus_allowed_ptr(current, non_isolated_cpus) < 0)
 		BUG();
 	sched_init_granularity();
+	free_cpumask_var(non_isolated_cpus);
+
+	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
+	init_sched_rt_class();
 }
 #else
 void __init sched_init_smp(void)
@@ -8328,6 +8461,15 @@ void __init sched_init(void)
 	 */
 	current->sched_class = &fair_sched_class;
 
+	/* Allocate the nohz_cpu_mask if CONFIG_CPUMASK_OFFSTACK */
+	alloc_bootmem_cpumask_var(&nohz_cpu_mask);
+#ifdef CONFIG_SMP
+#ifdef CONFIG_NO_HZ
+	alloc_bootmem_cpumask_var(&nohz.cpu_mask);
+#endif
+	alloc_bootmem_cpumask_var(&cpu_isolated_map);
+#endif /* SMP */
+
 	scheduler_running = 1;
 }
 
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index 52154fe..018b7be 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -67,24 +67,21 @@ static int convert_prio(int prio)
  * Returns: (int)bool - CPUs were found
  */
 int cpupri_find(struct cpupri *cp, struct task_struct *p,
-		cpumask_t *lowest_mask)
+		struct cpumask *lowest_mask)
 {
 	int                  idx      = 0;
 	int                  task_pri = convert_prio(p->prio);
 
 	for_each_cpupri_active(cp->pri_active, idx) {
 		struct cpupri_vec *vec  = &cp->pri_to_cpu[idx];
-		cpumask_t mask;
 
 		if (idx >= task_pri)
 			break;
 
-		cpus_and(mask, p->cpus_allowed, vec->mask);
-
-		if (cpus_empty(mask))
+		if (cpumask_any_and(&p->cpus_allowed, vec->mask) >= nr_cpu_ids)
 			continue;
 
-		*lowest_mask = mask;
+		cpumask_and(lowest_mask, &p->cpus_allowed, vec->mask);
 		return 1;
 	}
 
@@ -126,7 +123,7 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 		vec->count--;
 		if (!vec->count)
 			clear_bit(oldpri, cp->pri_active);
-		cpu_clear(cpu, vec->mask);
+		cpumask_clear_cpu(cpu, vec->mask);
 
 		spin_unlock_irqrestore(&vec->lock, flags);
 	}
@@ -136,7 +133,7 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 
 		spin_lock_irqsave(&vec->lock, flags);
 
-		cpu_set(cpu, vec->mask);
+		cpumask_set_cpu(cpu, vec->mask);
 		vec->count++;
 		if (vec->count == 1)
 			set_bit(newpri, cp->pri_active);
@@ -150,10 +147,11 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 /**
  * cpupri_init - initialize the cpupri structure
  * @cp: The cpupri context
+ * @bootmem: true if allocations need to use bootmem
  *
- * Returns: (void)
+ * Returns: -ENOMEM if memory fails.
  */
-void cpupri_init(struct cpupri *cp)
+int cpupri_init(struct cpupri *cp, bool bootmem)
 {
 	int i;
 
@@ -164,11 +162,30 @@ void cpupri_init(struct cpupri *cp)
 
 		spin_lock_init(&vec->lock);
 		vec->count = 0;
-		cpus_clear(vec->mask);
+		if (bootmem)
+			alloc_bootmem_cpumask_var(&vec->mask);
+		else if (!alloc_cpumask_var(&vec->mask, GFP_KERNEL))
+			goto cleanup;
 	}
 
 	for_each_possible_cpu(i)
 		cp->cpu_to_pri[i] = CPUPRI_INVALID;
+	return 0;
+
+cleanup:
+	for (i--; i >= 0; i--)
+		free_cpumask_var(cp->pri_to_cpu[i].mask);
+	return -ENOMEM;
 }
 
+/**
+ * cpupri_cleanup - clean up the cpupri structure
+ * @cp: The cpupri context
+ */
+void cpupri_cleanup(struct cpupri *cp)
+{
+	int i;
 
+	for (i = 0; i < CPUPRI_NR_PRIORITIES; i++)
+		free_cpumask_var(cp->pri_to_cpu[i].mask);
+}
diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
index f25811b..642a94e 100644
--- a/kernel/sched_cpupri.h
+++ b/kernel/sched_cpupri.h
@@ -14,7 +14,7 @@
 struct cpupri_vec {
 	spinlock_t lock;
 	int        count;
-	cpumask_t  mask;
+	cpumask_var_t mask;
 };
 
 struct cpupri {
@@ -27,7 +27,8 @@ struct cpupri {
 int  cpupri_find(struct cpupri *cp,
 		 struct task_struct *p, cpumask_t *lowest_mask);
 void cpupri_set(struct cpupri *cp, int cpu, int pri);
-void cpupri_init(struct cpupri *cp);
+int cpupri_init(struct cpupri *cp, bool bootmem);
+void cpupri_cleanup(struct cpupri *cp);
 #else
 #define cpupri_set(cp, cpu, pri) do { } while (0)
 #define cpupri_init() do { } while (0)
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5ad4440..56c0efe 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1019,16 +1019,33 @@ static void yield_task_fair(struct rq *rq)
  * search starts with cpus closest then further out as needed,
  * so we always favor a closer, idle cpu.
  * Domains may include CPUs that are not usable for migration,
- * hence we need to mask them out (cpu_active_map)
+ * hence we need to mask them out (cpu_active_mask)
  *
  * Returns the CPU we should wake onto.
  */
 #if defined(ARCH_HAS_SCHED_WAKE_IDLE)
 static int wake_idle(int cpu, struct task_struct *p)
 {
-	cpumask_t tmp;
 	struct sched_domain *sd;
 	int i;
+	unsigned int chosen_wakeup_cpu;
+	int this_cpu;
+
+	/*
+	 * At POWERSAVINGS_BALANCE_WAKEUP level, if both this_cpu and prev_cpu
+	 * are idle and this is not a kernel thread and this task's affinity
+	 * allows it to be moved to preferred cpu, then just move!
+	 */
+
+	this_cpu = smp_processor_id();
+	chosen_wakeup_cpu =
+		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu;
+
+	if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP &&
+		idle_cpu(cpu) && idle_cpu(this_cpu) &&
+		p->mm && !(p->flags & PF_KTHREAD) &&
+		cpu_isset(chosen_wakeup_cpu, p->cpus_allowed))
+		return chosen_wakeup_cpu;
 
 	/*
 	 * If it is idle, then it is the best cpu to run this task.
@@ -1046,10 +1063,9 @@ static int wake_idle(int cpu, struct task_struct *p)
 		if ((sd->flags & SD_WAKE_IDLE)
 		    || ((sd->flags & SD_WAKE_IDLE_FAR)
 			&& !task_hot(p, task_rq(p)->clock, sd))) {
-			cpus_and(tmp, sd->span, p->cpus_allowed);
-			cpus_and(tmp, tmp, cpu_active_map);
-			for_each_cpu_mask_nr(i, tmp) {
-				if (idle_cpu(i)) {
+			for_each_cpu_and(i, sched_domain_span(sd),
+					 &p->cpus_allowed) {
+				if (cpu_active(i) && idle_cpu(i)) {
 					if (i != task_cpu(p)) {
 						schedstat_inc(p,
 						       se.nr_wakeups_idle);
@@ -1242,13 +1258,13 @@ static int select_task_rq_fair(struct task_struct *p, int sync)
 	 * this_cpu and prev_cpu are present in:
 	 */
 	for_each_domain(this_cpu, sd) {
-		if (cpu_isset(prev_cpu, sd->span)) {
+		if (cpumask_test_cpu(prev_cpu, sched_domain_span(sd))) {
 			this_sd = sd;
 			break;
 		}
 	}
 
-	if (unlikely(!cpu_isset(this_cpu, p->cpus_allowed)))
+	if (unlikely(!cpumask_test_cpu(this_cpu, &p->cpus_allowed)))
 		goto out;
 
 	/*
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 51d2af3..833b6d4 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -15,7 +15,7 @@ static inline void rt_set_overload(struct rq *rq)
 	if (!rq->online)
 		return;
 
-	cpu_set(rq->cpu, rq->rd->rto_mask);
+	cpumask_set_cpu(rq->cpu, rq->rd->rto_mask);
 	/*
 	 * Make sure the mask is visible before we set
 	 * the overload count. That is checked to determine
@@ -34,7 +34,7 @@ static inline void rt_clear_overload(struct rq *rq)
 
 	/* the order here really doesn't matter */
 	atomic_dec(&rq->rd->rto_count);
-	cpu_clear(rq->cpu, rq->rd->rto_mask);
+	cpumask_clear_cpu(rq->cpu, rq->rd->rto_mask);
 }
 
 static void update_rt_migration(struct rq *rq)
@@ -139,14 +139,14 @@ static int rt_se_boosted(struct sched_rt_entity *rt_se)
 }
 
 #ifdef CONFIG_SMP
-static inline cpumask_t sched_rt_period_mask(void)
+static inline const struct cpumask *sched_rt_period_mask(void)
 {
 	return cpu_rq(smp_processor_id())->rd->span;
 }
 #else
-static inline cpumask_t sched_rt_period_mask(void)
+static inline const struct cpumask *sched_rt_period_mask(void)
 {
-	return cpu_online_map;
+	return cpu_online_mask;
 }
 #endif
 
@@ -212,9 +212,9 @@ static inline int rt_rq_throttled(struct rt_rq *rt_rq)
 	return rt_rq->rt_throttled;
 }
 
-static inline cpumask_t sched_rt_period_mask(void)
+static inline const struct cpumask *sched_rt_period_mask(void)
 {
-	return cpu_online_map;
+	return cpu_online_mask;
 }
 
 static inline
@@ -241,11 +241,11 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
 	int i, weight, more = 0;
 	u64 rt_period;
 
-	weight = cpus_weight(rd->span);
+	weight = cpumask_weight(rd->span);
 
 	spin_lock(&rt_b->rt_runtime_lock);
 	rt_period = ktime_to_ns(rt_b->rt_period);
-	for_each_cpu_mask_nr(i, rd->span) {
+	for_each_cpu(i, rd->span) {
 		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
 		s64 diff;
 
@@ -324,7 +324,7 @@ static void __disable_runtime(struct rq *rq)
 		/*
 		 * Greedy reclaim, take back as much as we can.
 		 */
-		for_each_cpu_mask(i, rd->span) {
+		for_each_cpu(i, rd->span) {
 			struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
 			s64 diff;
 
@@ -429,13 +429,13 @@ static inline int balance_runtime(struct rt_rq *rt_rq)
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 {
 	int i, idle = 1;
-	cpumask_t span;
+	const struct cpumask *span;
 
 	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
 		return 1;
 
 	span = sched_rt_period_mask();
-	for_each_cpu_mask(i, span) {
+	for_each_cpu(i, span) {
 		int enqueue = 0;
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
 		struct rq *rq = rq_of_rt_rq(rt_rq);
@@ -805,17 +805,20 @@ static int select_task_rq_rt(struct task_struct *p, int sync)
 
 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 {
-	cpumask_t mask;
+	cpumask_var_t mask;
 
 	if (rq->curr->rt.nr_cpus_allowed == 1)
 		return;
 
-	if (p->rt.nr_cpus_allowed != 1
-	    && cpupri_find(&rq->rd->cpupri, p, &mask))
+	if (!alloc_cpumask_var(&mask, GFP_ATOMIC))
 		return;
 
-	if (!cpupri_find(&rq->rd->cpupri, rq->curr, &mask))
-		return;
+	if (p->rt.nr_cpus_allowed != 1
+	    && cpupri_find(&rq->rd->cpupri, p, mask))
+		goto free;
+
+	if (!cpupri_find(&rq->rd->cpupri, rq->curr, mask))
+		goto free;
 
 	/*
 	 * There appears to be other cpus that can accept
@@ -824,6 +827,8 @@ static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 	 */
 	requeue_task_rt(rq, p, 1);
 	resched_task(rq->curr);
+free:
+	free_cpumask_var(mask);
 }
 
 #endif /* CONFIG_SMP */
@@ -914,7 +919,7 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep);
 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
 	if (!task_running(rq, p) &&
-	    (cpu < 0 || cpu_isset(cpu, p->cpus_allowed)) &&
+	    (cpu < 0 || cpumask_test_cpu(cpu, &p->cpus_allowed)) &&
 	    (p->rt.nr_cpus_allowed > 1))
 		return 1;
 	return 0;
@@ -953,7 +958,7 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
 	return next;
 }
 
-static DEFINE_PER_CPU(cpumask_t, local_cpu_mask);
+static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
 
 static inline int pick_optimal_cpu(int this_cpu, cpumask_t *mask)
 {
@@ -973,7 +978,7 @@ static inline int pick_optimal_cpu(int this_cpu, cpumask_t *mask)
 static int find_lowest_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
-	cpumask_t *lowest_mask = &__get_cpu_var(local_cpu_mask);
+	struct cpumask *lowest_mask = __get_cpu_var(local_cpu_mask);
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);
 
@@ -988,7 +993,7 @@ static int find_lowest_rq(struct task_struct *task)
 	 * I guess we might want to change cpupri_find() to ignore those
 	 * in the first place.
 	 */
-	cpus_and(*lowest_mask, *lowest_mask, cpu_active_map);
+	cpumask_and(lowest_mask, lowest_mask, cpu_active_mask);
 
 	/*
 	 * At this point we have built a mask of cpus representing the
@@ -998,7 +1003,7 @@ static int find_lowest_rq(struct task_struct *task)
 	 * We prioritize the last cpu that the task executed on since
 	 * it is most likely cache-hot in that location.
 	 */
-	if (cpu_isset(cpu, *lowest_mask))
+	if (cpumask_test_cpu(cpu, lowest_mask))
 		return cpu;
 
 	/*
@@ -1013,7 +1018,8 @@ static int find_lowest_rq(struct task_struct *task)
 			cpumask_t domain_mask;
 			int       best_cpu;
 
-			cpus_and(domain_mask, sd->span, *lowest_mask);
+			cpumask_and(&domain_mask, sched_domain_span(sd),
+				    lowest_mask);
 
 			best_cpu = pick_optimal_cpu(this_cpu,
 						    &domain_mask);
@@ -1054,8 +1060,8 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 			 * Also make sure that it wasn't scheduled on its rq.
 			 */
 			if (unlikely(task_rq(task) != rq ||
-				     !cpu_isset(lowest_rq->cpu,
-						task->cpus_allowed) ||
+				     !cpumask_test_cpu(lowest_rq->cpu,
+						       &task->cpus_allowed) ||
 				     task_running(rq, task) ||
 				     !task->se.on_rq)) {
 
@@ -1176,7 +1182,7 @@ static int pull_rt_task(struct rq *this_rq)
 
 	next = pick_next_task_rt(this_rq);
 
-	for_each_cpu_mask_nr(cpu, this_rq->rd->rto_mask) {
+	for_each_cpu(cpu, this_rq->rd->rto_mask) {
 		if (this_cpu == cpu)
 			continue;
 
@@ -1305,9 +1311,9 @@ move_one_task_rt(struct rq *this_rq, int this_cpu, struct rq *busiest,
 }
 
 static void set_cpus_allowed_rt(struct task_struct *p,
-				const cpumask_t *new_mask)
+				const struct cpumask *new_mask)
 {
-	int weight = cpus_weight(*new_mask);
+	int weight = cpumask_weight(new_mask);
 
 	BUG_ON(!rt_task(p));
 
@@ -1328,7 +1334,7 @@ static void set_cpus_allowed_rt(struct task_struct *p,
 		update_rt_migration(rq);
 	}
 
-	p->cpus_allowed    = *new_mask;
+	cpumask_copy(&p->cpus_allowed, new_mask);
 	p->rt.nr_cpus_allowed = weight;
 }
 
@@ -1371,6 +1377,14 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p,
 	if (!rq->rt.rt_nr_running)
 		pull_rt_task(rq);
 }
+
+static inline void init_sched_rt_class(void)
+{
+	unsigned int i;
+
+	for_each_possible_cpu(i)
+		alloc_cpumask_var(&per_cpu(local_cpu_mask, i), GFP_KERNEL);
+}
 #endif /* CONFIG_SMP */
 
 /*
@@ -1541,3 +1555,4 @@ static void print_rt_stats(struct seq_file *m, int cpu)
 	rcu_read_unlock();
 }
 #endif /* CONFIG_SCHED_DEBUG */
+
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 3b01098..f2773b5 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -42,7 +42,8 @@ static int show_schedstat(struct seq_file *seq, void *v)
 		for_each_domain(cpu, sd) {
 			enum cpu_idle_type itype;
 
-			cpumask_scnprintf(mask_str, mask_len, sd->span);
+			cpumask_scnprintf(mask_str, mask_len,
+					  sched_domain_span(sd));
 			seq_printf(seq, "domain%d %s", dcount++, mask_str);
 			for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
 					itype++) {
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index bd6be76..6d7dc4e 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -352,7 +352,7 @@ static int parse(struct nlattr *na, cpumask_t *mask)
 	if (!data)
 		return -ENOMEM;
 	nla_strlcpy(data, na, len);
-	ret = cpulist_parse(data, *mask);
+	ret = cpulist_parse(data, mask);
 	kfree(data);
 	return ret;
 }
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index f8d9680..ea2f48a 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -166,6 +166,8 @@ static void clockevents_notify_released(void)
 void clockevents_register_device(struct clock_event_device *dev)
 {
 	BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
+	BUG_ON(!dev->cpumask);
+
 	/*
 	 * A nsec2cyc multiplicator of 0 is invalid and we'd crash
 	 * on it, so fix it up and emit a warning:
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f98a1b7..9590af2 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -150,7 +150,7 @@ static void tick_do_broadcast(cpumask_t mask)
 		 */
 		cpu = first_cpu(mask);
 		td = &per_cpu(tick_cpu_device, cpu);
-		td->evtdev->broadcast(mask);
+		td->evtdev->broadcast(&mask);
 	}
 }
 
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index df12434..f8372be 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -136,7 +136,7 @@ void tick_setup_periodic(struct clock_event_device *dev, int broadcast)
  */
 static void tick_setup_device(struct tick_device *td,
 			      struct clock_event_device *newdev, int cpu,
-			      const cpumask_t *cpumask)
+			      const struct cpumask *cpumask)
 {
 	ktime_t next_event;
 	void (*handler)(struct clock_event_device *) = NULL;
@@ -171,8 +171,8 @@ static void tick_setup_device(struct tick_device *td,
 	 * When the device is not per cpu, pin the interrupt to the
 	 * current cpu:
 	 */
-	if (!cpus_equal(newdev->cpumask, *cpumask))
-		irq_set_affinity(newdev->irq, *cpumask);
+	if (!cpumask_equal(newdev->cpumask, cpumask))
+		irq_set_affinity(newdev->irq, cpumask);
 
 	/*
 	 * When global broadcasting is active, check if the current
@@ -202,14 +202,14 @@ static int tick_check_new_device(struct clock_event_device *newdev)
 	spin_lock_irqsave(&tick_device_lock, flags);
 
 	cpu = smp_processor_id();
-	if (!cpu_isset(cpu, newdev->cpumask))
+	if (!cpumask_test_cpu(cpu, newdev->cpumask))
 		goto out_bc;
 
 	td = &per_cpu(tick_cpu_device, cpu);
 	curdev = td->evtdev;
 
 	/* cpu local device ? */
-	if (!cpus_equal(newdev->cpumask, cpumask_of_cpu(cpu))) {
+	if (!cpumask_equal(newdev->cpumask, cpumask_of(cpu))) {
 
 		/*
 		 * If the cpu affinity of the device interrupt can not
@@ -222,7 +222,7 @@ static int tick_check_new_device(struct clock_event_device *newdev)
 		 * If we have a cpu local device already, do not replace it
 		 * by a non cpu local device
 		 */
-		if (curdev && cpus_equal(curdev->cpumask, cpumask_of_cpu(cpu)))
+		if (curdev && cpumask_equal(curdev->cpumask, cpumask_of(cpu)))
 			goto out_bc;
 	}
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 8f3fc25..8408fd4 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -144,7 +144,7 @@ void tick_nohz_update_jiffies(void)
 	if (!ts->tick_stopped)
 		return;
 
-	cpu_clear(cpu, nohz_cpu_mask);
+	cpumask_clear_cpu(cpu, nohz_cpu_mask);
 	now = ktime_get();
 	ts->idle_waketime = now;
 
@@ -301,12 +301,12 @@ void tick_nohz_stop_sched_tick(int inidle)
 			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
 
 		if (delta_jiffies > 1)
-			cpu_set(cpu, nohz_cpu_mask);
 
 		/* Skip reprogram of event if its not changed */
 		if (ts->tick_stopped && ktime_equal(expires, dev->next_event))
 			goto out;
 
+			cpumask_set_cpu(cpu, nohz_cpu_mask);
 		/*
 		 * nohz_stop_sched_tick can be called several times before
 		 * the nohz_restart_sched_tick is called. This happens when
@@ -319,7 +319,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 				/*
 				 * sched tick not stopped!
 				 */
-				cpu_clear(cpu, nohz_cpu_mask);
+				cpumask_clear_cpu(cpu, nohz_cpu_mask);
 				goto out;
 			}
 
@@ -361,7 +361,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 		 * softirq.
 		 */
 		tick_do_update_jiffies64(ktime_get());
-		cpu_clear(cpu, nohz_cpu_mask);
+		cpumask_clear_cpu(cpu, nohz_cpu_mask);
 	}
 	raise_softirq_irqoff(TIMER_SOFTIRQ);
 out:
@@ -439,7 +439,7 @@ void tick_nohz_restart_sched_tick(void)
 	select_nohz_load_balancer(0);
 	now = ktime_get();
 	tick_do_update_jiffies64(now);
-	cpu_clear(cpu, nohz_cpu_mask);
+	cpumask_clear_cpu(cpu, nohz_cpu_mask);
 
 	/*
 	 * We stopped the tick in idle. Update process times would miss the
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4185d52..0e91f43 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2674,7 +2674,7 @@ tracing_cpumask_read(struct file *filp, char __user *ubuf,
 
 	mutex_lock(&tracing_cpumask_update_lock);
 
-	len = cpumask_scnprintf(mask_str, count, tracing_cpumask);
+	len = cpumask_scnprintf(mask_str, count, &tracing_cpumask);
 	if (count - len < 2) {
 		count = -EINVAL;
 		goto out_err;
@@ -2695,7 +2695,7 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 	int err, cpu;
 
 	mutex_lock(&tracing_cpumask_update_lock);
-	err = cpumask_parse_user(ubuf, count, tracing_cpumask_new);
+	err = cpumask_parse_user(ubuf, count, &tracing_cpumask_new);
 	if (err)
 		goto err_unlock;
 
diff --git a/lib/Kconfig b/lib/Kconfig
index fd4118e..2ba43c4 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -159,4 +159,11 @@ config CHECK_SIGNATURE
 config HAVE_LMB
 	boolean
 
+config CPUMASK_OFFSTACK
+	bool "Force CPU masks off stack" if DEBUG_PER_CPU_MAPS
+	help
+	  Use dynamic allocation for cpumask_var_t, instead of putting
+	  them on the stack.  This is a bit more expensive, but avoids
+	  stack overflow.
+
 endmenu
diff --git a/mm/slub.c b/mm/slub.c
index 6cb7ad1..0d861c3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3642,7 +3642,7 @@ static int list_locations(struct kmem_cache *s, char *buf,
 				len < PAGE_SIZE - 60) {
 			len += sprintf(buf + len, " cpus=");
 			len += cpulist_scnprintf(buf + len, PAGE_SIZE - len - 50,
-					l->cpus);
+					&l->cpus);
 		}
 
 		if (num_online_nodes() > 1 && !nodes_empty(l->nodes) &&
