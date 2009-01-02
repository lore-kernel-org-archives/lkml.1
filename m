Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbZABRBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbZABRBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 12:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757286AbZABRAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 12:00:55 -0500
Received: from relay2.sgi.com ([192.48.179.30]:43420 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756985AbZABRAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:00:53 -0500
Message-ID: <495E4837.8090600@sgi.com>
Date: Fri, 02 Jan 2009 09:00:39 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>, Gautham R Shenoy <ego@in.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Sergio Luis <sergio@larces.uece.br>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yinghai Lu <Yinghai.Lu@Sun.COM>, LKML <linux-kernel@vger.kernel.org>
Subject: git-pull request for tip/cpus4096
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

Here's the latest cpumask updates which includes the latest merge from Rusty's cpumask tree.

Thanks,
Mike

The following changes since commit 2ca1a615835d9f4990f42102ab1f2ef434e7e89c:
  Rusty Russell (1):
        Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git master

Gautham R Shenoy (1):
      sched: framework for sched_mc/smt_power_savings=N

Ingo Molnar (19):
      Merge branches 'sched/core', 'core/core' and 'tracing/core' into cpus4096
      sched: convert struct root_domain to cpumask_var_t, fix
      Merge branch 'linus' into cpus4096
      Merge branch 'tracing/fastboot' into cpus4096
      Merge branch 'sched/core' into cpus4096
      Merge branches 'irq/sparseirq', 'x86/quirks' and 'x86/reboot' into cpus4096
      Merge branch 'linus' into cpus4096
      Merge branch 'master' of git://git.kernel.org/.../rusty/linux-2.6-for-ingo into cpus4096
      Merge branch 'linus' into cpus4096
      Merge branch 'master' of git://git.kernel.org/.../travis/linux-2.6-cpus4096-for-ingo into cpus4096
      Merge branch 'irq/sparseirq' into cpus4096
      Merge branch 'x86/crashdump' into cpus4096
      x86: update io_apic.c to the new cpumask code
      Merge branch 'linus' into cpus4096
      Merge branch 'x86/apic' into cpus4096
      sched: move test_sd_parent() to an SMP section of sched.h
      sched: fix warning in kernel/sched.c
      x86: fix warning in arch/x86/kernel/io_apic.c
      x86: export vector_used_by_percpu_irq

Li Zefan (1):
      cpumask: fix bogus kernel-doc

Mike Travis (29):
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
      Merge branch 'master' of git://git.kernel.org/.../rusty/linux-2.6-cpumask into merge-rr-cpumask
      x86: enable cpus display of kernel_max and offlined cpus
      x86: cleanup remaining cpumask_t ops in smpboot code
      sched: put back some stack hog changes that were undone in kernel/sched.c
      x86: cleanup some remaining usages of NR_CPUS where s/b nr_cpu_ids
      x86: cleanup remaining cpumask_t code in mce_amd_64.c
      x86: cleanup remaining cpumask_t code in microcode_core.c
      cpumask: use alloc_cpumask_var_node where appropriate
      cpumask: fix compile error when CONFIG_NR_CPUS is not defined

Rusty Russell (58):
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
      Merge ../linux-2.6-x86
      cpumask: Remove IA64 definition of total_cpus now it's in core code
      percpu: fix percpu accessors to potentially !cpu_possible() cpus: pnpbios
      percpu: fix percpu accessors to potentially !cpu_possible() cpus: m32r
      cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: core
      cpumask: Use accessors code in core
      parisc: remove gratuitous cpu_online_map declaration.
      avr32: define __fls
      blackfin: define __fls
      m68k: define __fls
      m68knommu: define __fls
      bitmap: find_last_bit()
      cpumask: Use find_last_bit()
      cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): sparc
      cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): s390
      cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): powerpc
      cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): ia64
      cpumask: convert kernel trace functions
      cpumask: convert kernel trace functions further
      cpumask: remove any_online_cpu() users: kernel/
      cpumask: remove any_online_cpu() users: mm/
      cpumask: convert kernel/compat.c
      cpumask: convert kernel/workqueue.c
      cpumask: convert kernel time functions
      cpumask: convert kernel/irq
      cpumask: convert RCU implementations
      cpumask: convert kernel/profile.c
      cpumask: convert kernel/cpu.c
      cpumask: convert rest of files in kernel/
      cpumask: convert mm/
      cpumask: replace for_each_cpu_mask_nr with for_each_cpu in kernel/time/
      cpumask: zero extra bits in alloc_cpumask_var_node
      cpumask: CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
      x86: use cpumask_var_t in acpi/boot.c
      cpumask: convert shared_cpu_map in acpi_processor* structs to cpumask_var_t

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
 arch/alpha/kernel/irq.c                       |    3 +-
 arch/avr32/include/asm/bitops.h               |    5 +
 arch/blackfin/include/asm/bitops.h            |    1 +
 arch/ia64/include/asm/topology.h              |    4 +-
 arch/ia64/kernel/acpi.c                       |    1 -
 arch/m32r/kernel/smpboot.c                    |    2 +-
 arch/m68knommu/include/asm/bitops.h           |    1 +
 arch/mips/include/asm/mach-ip27/topology.h    |    1 -
 arch/parisc/include/asm/smp.h                 |    2 -
 arch/powerpc/include/asm/topology.h           |    3 +-
 arch/s390/include/asm/topology.h              |    1 +
 arch/sh/include/asm/topology.h                |    1 -
 arch/sparc/include/asm/topology_64.h          |    2 +
 arch/x86/Kconfig                              |   13 +-
 arch/x86/include/asm/bigsmp/apic.h            |   32 +-
 arch/x86/include/asm/bigsmp/ipi.h             |   13 +-
 arch/x86/include/asm/desc.h                   |   10 +-
 arch/x86/include/asm/es7000/apic.h            |   60 +-
 arch/x86/include/asm/es7000/ipi.h             |   12 +-
 arch/x86/include/asm/genapic_32.h             |   13 +-
 arch/x86/include/asm/genapic_64.h             |   14 +-
 arch/x86/include/asm/ipi.h                    |   23 +-
 arch/x86/include/asm/irq.h                    |    3 +-
 arch/x86/include/asm/lguest.h                 |    2 +-
 arch/x86/include/asm/mach-default/mach_apic.h |   28 +-
 arch/x86/include/asm/mach-default/mach_ipi.h  |   18 +-
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 +
 arch/x86/include/asm/numaq/apic.h             |   16 +-
 arch/x86/include/asm/numaq/ipi.h              |   13 +-
 arch/x86/include/asm/smp.h                    |   38 +-
 arch/x86/include/asm/summit/apic.h            |   39 +-
 arch/x86/include/asm/summit/ipi.h             |    9 +-
 arch/x86/include/asm/topology.h               |    2 +
 arch/x86/kernel/acpi/boot.c                   |   31 +-
 arch/x86/kernel/apic.c                        |   30 +-
 arch/x86/kernel/cpu/common.c                  |   28 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c    |   28 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k7.c     |    9 +
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c     |   24 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c         |   41 +-
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c       |  131 ++--
 arch/x86/kernel/cpuid.c                       |    2 +-
 arch/x86/kernel/genapic_flat_64.c             |  107 ++-
 arch/x86/kernel/genx2apic_cluster.c           |   81 ++-
 arch/x86/kernel/genx2apic_phys.c              |   74 ++-
 arch/x86/kernel/genx2apic_uv_x.c              |   61 ++-
 arch/x86/kernel/io_apic.c                     |  358 +++++-----
 arch/x86/kernel/ipi.c                         |   28 +-
 arch/x86/kernel/irq.c                         |    3 +
 arch/x86/kernel/irq_32.c                      |   13 +-
 arch/x86/kernel/irq_64.c                      |   15 +-
 arch/x86/kernel/irqinit_32.c                  |   16 +-
 arch/x86/kernel/irqinit_64.c                  |   13 +
 arch/x86/kernel/microcode_core.c              |   83 ++-
 arch/x86/kernel/msr.c                         |    2 +-
 arch/x86/kernel/reboot.c                      |    9 +-
 arch/x86/kernel/setup_percpu.c                |   42 +-
 arch/x86/kernel/smp.c                         |   23 +-
 arch/x86/kernel/smpboot.c                     |  159 +++--
 arch/x86/kernel/tlb_32.c                      |    2 +-
 arch/x86/kernel/tlb_64.c                      |    2 +-
 arch/x86/kernel/traps.c                       |   12 +-
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
 arch/x86/xen/xen-ops.h                        |    2 +-
 drivers/acpi/processor_core.c                 |   14 +-
 drivers/acpi/processor_perflib.c              |   28 +-
 drivers/acpi/processor_throttling.c           |   80 ++-
 drivers/base/cpu.c                            |    2 +-
 drivers/lguest/interrupts_and_traps.c         |   13 +-
 drivers/pnp/pnpbios/bioscalls.c               |    2 +-
 include/acpi/processor.h                      |    4 +-
 include/asm-m68k/bitops.h                     |    5 +
 include/linux/bitops.h                        |   13 +-
 include/linux/cpumask.h                       |   11 +-
 include/linux/interrupt.h                     |    2 +-
 include/linux/rcuclassic.h                    |    4 +-
 include/linux/sched.h                         |   92 ++-
 include/linux/stop_machine.h                  |    6 +-
 include/linux/tick.h                          |    4 +-
 include/linux/topology.h                      |    6 +-
 init/main.c                                   |   13 +-
 kernel/compat.c                               |   49 +-
 kernel/cpu.c                                  |   48 +-
 kernel/irq/manage.c                           |   11 +-
 kernel/irq/proc.c                             |   32 +-
 kernel/kexec.c                                |    2 +-
 kernel/power/poweroff.c                       |    2 +-
 kernel/profile.c                              |   38 +-
 kernel/rcuclassic.c                           |   31 +-
 kernel/rcupreempt.c                           |   19 +-
 kernel/rcutorture.c                           |   27 +-
 kernel/sched.c                                |  975 ++++++++++++++-----------
 kernel/sched_cpupri.c                         |   39 +-
 kernel/sched_cpupri.h                         |    5 +-
 kernel/sched_fair.c                           |   32 +-
 kernel/sched_rt.c                             |   74 ++-
 kernel/sched_stats.h                          |    3 +-
 kernel/smp.c                                  |    2 +-
 kernel/softirq.c                              |    2 +-
 kernel/softlockup.c                           |   10 +-
 kernel/stop_machine.c                         |    8 +-
 kernel/taskstats.c                            |   39 +-
 kernel/time/clocksource.c                     |    9 +-
 kernel/time/tick-broadcast.c                  |  115 ++--
 kernel/time/tick-common.c                     |    6 +-
 kernel/time/tick-sched.c                      |   10 +-
 kernel/trace/ring_buffer.c                    |   42 +-
 kernel/trace/trace.c                          |   72 ++-
 kernel/trace/trace.h                          |    2 +-
 kernel/trace/trace_boot.c                     |    2 +-
 kernel/trace/trace_functions_graph.c          |    2 +-
 kernel/trace/trace_hw_branches.c              |    6 +-
 kernel/trace/trace_power.c                    |    2 +-
 kernel/trace/trace_sysprof.c                  |   13 +-
 kernel/workqueue.c                            |   26 +-
 lib/Kconfig                                   |    8 +
 lib/Makefile                                  |    1 +
 lib/cpumask.c                                 |   10 +-
 lib/find_last_bit.c                           |   45 ++
 mm/pdflush.c                                  |   16 +-
 mm/slab.c                                     |    2 +-
 mm/slub.c                                     |   20 +-
 mm/vmscan.c                                   |    4 +-
 mm/vmstat.c                                   |    4 +-
 security/selinux/selinuxfs.c                  |    2 +-
 135 files changed, 2499 insertions(+), 1584 deletions(-)
 create mode 100644 lib/find_last_bit.c

