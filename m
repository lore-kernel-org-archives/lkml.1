Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbYLYRuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbYLYRuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 12:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYLYRuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 12:50:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56722 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbYLYRuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 12:50:01 -0500
Date: Thu, 25 Dec 2008 18:49:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] cpus4096 updates for v2.6.29
Message-ID: <20081225174944.GA11501@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Linus,

Please pull the latest cpus4096-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git cpus4096-for-linus

This includes the off-stack 'struct cpumask' feature and API changes from 
Rusty and from Mike Travis: core cpumask infrastructure changes, the 
conversion of all scheduler cpumask use to the new APIs, and the 
conversion of x86 the architecture to the new cpumask APIs.

[ The shortlog and diffstat below was done with the assumption of you
  having been able to pull the x86, tracing, scheduler and sparseirq 
  trees. If there was a problem with any of those trees then please 
  disregard this pull request. This tree will generate a minor conflict in
  kernel/time/tick-sched.c. ]

CONFIG_MAXSMP is now safe and got reintroduced [and triggers off-stack 
cpumask allocations] - but it is default-off, so that people do not run 
into it accidentally.

There's a category of scheduler changes that were applied to this tree, 
because they intimately interacted with cpumask details that prevented 
them from going into a separate topic: the load-balancer fixes and 
generalizations from Vaidyanathan Srinivasan and Gautham R Shenoy.

Because cpumask changes traditionally had a track record of breaking 
non-x86 architectures, i conducted a cross-arch build test:

 testing 13 architectures:

 testing      alpha:  -git:  pass (  15),  -tip:  pass (  15)
 testing        arm:  -git:  pass (   5),  -tip:  pass (   5)
 testing   blackfin:  -git:  pass (4134),  -tip:  pass (4131)
 testing       cris:  -git:  pass (  28),  -tip:  pass (  28)
 testing       ia64:  -git:  pass ( 129),  -tip:  pass ( 132)
 testing       m32r:  -git:  pass (  21),  -tip:  pass (  21)
 testing       m68k:  -git:  pass ( 150),  -tip:  pass ( 150)
 testing       mips:  -git:  pass (   4),  -tip:  pass (   4)
 testing    powerpc:  -git:  pass (  10),  -tip:  pass (  10)
 testing         sh:  -git:  pass (  23),  -tip:  pass (  23)
 testing      sparc:  -git:  pass (   0),  -tip:  pass (   0)
 testing    sparc64:  -git:  pass (   3),  -tip:  pass (   3)
 testing     xtensa:  -git:  pass (  25),  -tip:  pass (  25)

( The number in parenthesis is the number of build warnings on that arch,
  conducted with 4.3.3 20081123. )

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
 arch/sparc/kernel/smp.c                       |    6 +-
 arch/sparc/kernel/sparc_ksyms.c               |    4 -
 arch/sparc64/kernel/irq.c                     |   11 +-
 arch/sparc64/kernel/of_device.c               |    2 +-
 arch/sparc64/kernel/pci_msi.c                 |    2 +-
 arch/sparc64/kernel/smp.c                     |    4 -
 arch/sparc64/kernel/time.c                    |    2 +-
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
