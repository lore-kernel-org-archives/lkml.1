Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZAUSv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZAUSv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 13:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZAUSvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 13:51:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45002 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbZAUSv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 13:51:29 -0500
Date: Wed, 21 Jan 2009 19:50:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Subject: [announce] Performance Counters for Linux, v6
Message-ID: <20090121185021.GA8852@elte.hu>
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


We are pleased to announce version 6 of our performance counters subsystem 
implementation. The shortlog, diffstat and the combo patch can be found 
below. The combo patch against latest -git (2.6.29-rc2) can be also found 
at:

   http://people.redhat.com/mingo/perfcounters/perfcounters-v6-v2.6.29-rc2.patch

It's also available in tip/master at:
 
   http://people.redhat.com/mingo/tip.git/README
 
There are many changes in the v6 release:

 - PowerPC performance counters support from Paul Mackerras, for POWER6
   and for the PPC970 family.

 - ioctl API to disable/enable individual counters and groups without
   closing their fd. This can be useful for libraries, ad-hoc 
   instrumentation and PAPI support.

 - 'pinned' and 'exclusive' counter attributes - for those
   applications that want to influence counter scheduling explicitly.

 - The 'perfstat' utility (ex 'timec') has been updated:

      http://people.redhat.com/mingo/perfcounters/perfstat.c

 - 'kerneltop' (easy-to-use text mode NMI profiler) has been updated:
   
      http://people.redhat.com/mingo/perfcounters/kerneltop.c
 
 - Merged to latest mainline

 - Various fixes and other updates

	Ingo

------------------>
Andi Kleen (1):
      x86, generic: mark complex bitops.h inlines as __always_inline

Brian Gerst (12):
      x86-64: Move irq stats from PDA to per-cpu and consolidate with 32-bit.
      x86-64: Move TLB state from PDA to per-cpu and consolidate with 32-bit.
      x86-64: Convert irqstacks to per-cpu
      x86-64: Convert exception stacks to per-cpu
      x86-64: Move cpu number from PDA to per-cpu and consolidate with 32-bit.
      x86-64: Move current task from PDA to per-cpu and consolidate with 32-bit.
      x86-64: Move kernelstack from PDA to per-cpu.
      x86-64: Move oldrsp from PDA to per-cpu.
      x86-64: Move irqcount from PDA to per-cpu.
      x86-64: Move nodenumber from PDA to per-cpu.
      x86-64: Move isidle from PDA to per-cpu.
      x86-64: Use absolute displacements for per-cpu accesses.

Christophe Saout (1):
      xen: fix too early kmalloc call

Ingo Molnar (50):
      performance counters: documentation
      performance counters: x86 support
      x86, perfcounters: read out MSR_CORE_PERF_GLOBAL_STATUS with counters disabled
      perfcounters: select ANON_INODES
      perfcounters, x86: simplify disable/enable of counters
      perfcounters, x86: clean up debug code
      perfcounters: consolidate global-disable codepaths
      perf counters: restructure the API
      perf counters: add support for group counters
      perf counters: group counter, fixes
      perf counters: hw driver API
      perf counters: implement PERF_COUNT_CPU_CLOCK
      perf counters: consolidate hw_perf save/restore APIs
      perf counters: implement PERF_COUNT_TASK_CLOCK
      perf counters: add prctl interface to disable/enable counters
      perf counters: clean up state transitions
      perf counters: update docs
      x86: implement atomic64_t on 32-bit
      perfcounters: restructure x86 counter math
      perfcounters: implement "counter inheritance"
      perfcounters: fix task clock counter
      perfcounters: add context switch counter
      perfcounters: add task migrations counter
      perfcounters: add nr-of-faults counter
      perfcounters: fix non-intel-perfmon CPUs
      perfcounters, x86: fix sw counters on non-PMC CPUs
      perfcounters: fix lapic initialization
      perfcounters: release CPU context when exiting task counters
      perfcounters: flush on setuid exec
      perfcounters: use hw_event.disable flag
      perfcounters: remove warnings
      perfcounters: tweak group scheduling
      x86, perfcounters: rename intel_arch_perfmon.h => perf_counter.h
      x86, perfcounters: prepare for fixed-mode PMCs
      perfcounters: add fixed-mode PMC enumeration
      x86, perfcounters: refactor code for fixed-function PMCs
      perfcounters: hw ops rename
      perfcounters: fix task clock counter
      perfcounters: pull inherited counters
      perfcounters: fix init context lock
      perfcounters: enable lowlevel pmc code to schedule counters
      x86, perfcounters: print out the ->used bitmask
      perfcounters: remove ->nr_inherited
      perfcounters: generalize the counter scheduler
      perfcounters: add PERF_COUNT_BUS_CYCLES
      x86, perfcounters: add support for fixed-function pmcs
      perfcounters: include asm/perf_counter.h only if CONFIG_PERF_COUNTERS=y
      x86, cpufreq: remove leftover copymask_copy()
      x86: fix broken flush_tlb_others_ipi(), fix
      percpu: add optimized generic percpu accessors

Jan Beulich (2):
      x86: fully honor "nolapic"
      x86: avoid early crash in disable_local_APIC()

Jaswinder Singh (1):
      x86: perf_counter.c intel_perfmon_event_map and max_intel_perfmon_events should be static

Jaswinder Singh Rajput (20):
      x86: perf_counter remove unwanted hw_perf_enable_all
      x86: smp.h remove obsolete function declaration
      x86: smp.h move zap_low_mappings declartion to tlbflush.h
      x86: smp.h move prefill_possible_map declartion to cpu.h
      x86: smp.h move stack_processor_id declartion to cpu.h
      x86: smp.h move safe_smp_processor_id declartion to cpu.h
      x86: smp.h move cpu_physical_id declartion to cpu.h
      x86: smp.h move boot_cpu_id declartion to cpu.h
      x86: rename intel_mp_floating to mpf_intel
      x86: rename all fields of mpf_intel mpf_X to X
      x86: smp.h move cpu_callin_mask and cpu_callin_map declartion to cpumask.h
      x86: smp.h move cpu_callout_mask and cpu_callout_map declartion to cpumask.h
      x86: smp.h move cpu_initialized_mask and cpu_initialized declartion to cpumask.h
      x86: smp.h move cpu_sibling_setup_mask and cpu_sibling_setup_map declartion to cpumask.h
      x86: microcode_intel.c fix style problems
      x86: msr.c fix style problems
      x86: module_32.c fix style problems
      x86: module_64.c fix style problems
      x86: replacing mp_config_ioapic with mpc_ioapic
      x86: replacing mp_config_intsrc with mpc_intsrc

Mike Travis (17):
      cpumask: update irq_desc to use cpumask_var_t
      cpumask: fix bug in use cpumask_var_t in irq_desc
      SGI UV cpumask: use static temp cpumask in flush_tlb
      x86: cleanup remaining cpumask_t code in mce_amd_64.c
      x86: reduce stack usage in init_intel_cacheinfo
      cpumask: use cpumask_var_t in dcdbas.c
      cpumask: reduce stack usage in find_lowest_rq
      Xen: reduce memory required for cpu_evtchn_mask
      irq: change references from NR_IRQS to nr_irqs
      irq: use WARN() instead of WARN_ON().
      irq: allocate irq_desc_ptrs array based on nr_irqs
      irq: initialize nr_irqs based on nr_cpu_ids
      kstat: modify kstat_irqs_legacy to be variable sized
      cpumask, irq: non-x86 build failures
      irq: update all arches for new irq_desc
      irq: update all arches for new irq_desc, fix
      x86: cleanup early setup_percpu references

Paul Mackerras (13):
      perf_counter: Fix return value from dummy hw_perf_counter_init
      perf_counter: Fix the cpu_clock software counter
      perf_counter: Add optional hw_perf_group_sched_in arch function
      perf_counter: Add dummy perf_counter_print_debug function
      powerpc/perf_counter: Add perf_counter system call on powerpc
      powerpc: Provide a way to defer perf counter work until interrupts are enabled
      powerpc/perf_counter: Add generic support for POWER-family PMU hardware
      powerpc/perf_counter: Add support for PPC970 family
      powerpc/perf_counter: Add support for POWER6
      perf_counter: Always schedule all software counters in
      powerpc/perf_counter: Make sure PMU gets enabled properly
      perf_counter: Add support for pinned and exclusive counter groups
      perf_counter: Add counter enable/disable ioctls

Rusty Russell (5):
      cpumask: Use topology_core_cpumask()/topology_thread_cpumask()
      cpumask: convert misc driver functions
      cpumask: convert drivers/net/sfc
      cpumask: convert other misc kernel functions
      x86: change flush_tlb_others to take a const struct cpumask

Suresh Siddha (2):
      x86: fix broken flush_tlb_others_ipi()
      x86, pat: fix reserve_memtype() for legacy 1MB range

Tejun Heo (15):
      x86: fix pda_to_op()
      x86: make early_per_cpu() a lvalue and use it
      x86: make vmlinux_32.lds.S use PERCPU() macro
      x86: make percpu symbols zerobased on SMP
      x86: load pointer to pda into %gs while brining up a CPU
      x86: use static _cpu_pda array
      x86: fold pda into percpu area on SMP
      x86: merge 64 and 32 SMP percpu handling
      x86: make pda a percpu variable
      x86: convert pda ops to wrappers around x86 percpu accessors
      x86: misc clean up after the percpu update
      x86: fix build bug introduced during merge
      x86_64: initialize this_cpu_off to __per_cpu_load
      linker script: add missing VMLINUX_SYMBOL
      linker script: add missing .data.percpu.page_aligned

Thomas Gleixner (4):
      performance counters: core code
      perf counters: protect them against CSTATE transitions
      perf counters: clean up 'raw' type API
      perf counters: expand use of counter->event

Yinghai Lu (3):
      perf_counter: more barrier in blank weak function
      x86: arch_probe_nr_irqs
      x86: make 32bit MAX_HARDIRQS_PER_CPU to be NR_VECTORS


 Documentation/cputopology.txt                  |    6 +-
 Documentation/perf-counters.txt                |  147 ++
 arch/alpha/kernel/irq.c                        |    2 +-
 arch/arm/kernel/irq.c                          |   18 +-
 arch/arm/kernel/vmlinux.lds.S                  |    1 +
 arch/arm/oprofile/op_model_mpcore.c            |    2 +-
 arch/blackfin/kernel/irqchip.c                 |    5 +
 arch/ia64/kernel/iosapic.c                     |    2 +-
 arch/ia64/kernel/irq.c                         |    4 +-
 arch/ia64/kernel/irq_ia64.c                    |   12 +-
 arch/ia64/kernel/msi_ia64.c                    |    4 +-
 arch/ia64/kernel/vmlinux.lds.S                 |    1 +
 arch/ia64/sn/kernel/msi_sn.c                   |    2 +-
 arch/mips/include/asm/irq.h                    |    2 +-
 arch/mips/kernel/irq-gic.c                     |    2 +-
 arch/mips/kernel/smtc.c                        |    6 +-
 arch/mips/mti-malta/malta-smtc.c               |    5 +-
 arch/mips/sgi-ip22/ip22-int.c                  |    2 +-
 arch/mips/sgi-ip22/ip22-time.c                 |    2 +-
 arch/mips/sibyte/bcm1480/smp.c                 |    3 +-
 arch/mips/sibyte/sb1250/smp.c                  |    3 +-
 arch/mn10300/kernel/mn10300-watchdog.c         |    3 +-
 arch/parisc/kernel/irq.c                       |    8 +-
 arch/powerpc/include/asm/hw_irq.h              |   31 +
 arch/powerpc/include/asm/paca.h                |    1 +
 arch/powerpc/include/asm/perf_counter.h        |   72 +
 arch/powerpc/include/asm/systbl.h              |    1 +
 arch/powerpc/include/asm/unistd.h              |    3 +-
 arch/powerpc/kernel/Makefile                   |    1 +
 arch/powerpc/kernel/asm-offsets.c              |    1 +
 arch/powerpc/kernel/entry_64.S                 |    9 +
 arch/powerpc/kernel/irq.c                      |   12 +-
 arch/powerpc/kernel/perf_counter.c             |  785 +++++++++
 arch/powerpc/kernel/power6-pmu.c               |  283 +++
 arch/powerpc/kernel/ppc970-pmu.c               |  375 ++++
 arch/powerpc/kernel/vmlinux.lds.S              |    1 +
 arch/powerpc/platforms/Kconfig.cputype         |    1 +
 arch/powerpc/platforms/pseries/xics.c          |    5 +-
 arch/powerpc/sysdev/mpic.c                     |    3 +-
 arch/sparc/kernel/irq_64.c                     |    5 +-
 arch/sparc/kernel/time_64.c                    |    2 +-
 arch/x86/Kconfig                               |    1 +
 arch/x86/ia32/ia32entry.S                      |   11 +-
 arch/x86/include/asm/apicnum.h                 |   12 +
 arch/x86/include/asm/atomic_32.h               |  218 +++
 arch/x86/include/asm/bitops.h                  |   14 +-
 arch/x86/include/asm/cpu.h                     |   21 +
 arch/x86/include/asm/cpumask.h                 |   28 +
 arch/x86/include/asm/current.h                 |   24 +-
 arch/x86/include/asm/hardirq_32.h              |    4 +
 arch/x86/include/asm/hardirq_64.h              |   25 +-
 arch/x86/include/asm/hw_irq.h                  |    2 +
 arch/x86/include/asm/intel_arch_perfmon.h      |   31 -
 arch/x86/include/asm/io_apic.h                 |   26 +-
 arch/x86/include/asm/irq_regs_32.h             |    4 +-
 arch/x86/include/asm/irq_vectors.h             |   18 +-
 arch/x86/include/asm/mach-default/entry_arch.h |    5 +
 arch/x86/include/asm/mmu_context_32.h          |   12 +-
 arch/x86/include/asm/mmu_context_64.h          |   16 +-
 arch/x86/include/asm/mpspec_def.h              |   23 +-
 arch/x86/include/asm/page_64.h                 |    4 +-
 arch/x86/include/asm/paravirt.h                |    8 +-
 arch/x86/include/asm/pda.h                     |  124 +--
 arch/x86/include/asm/percpu.h                  |  159 +-
 arch/x86/include/asm/perf_counter.h            |   95 +
 arch/x86/include/asm/processor.h               |    3 +
 arch/x86/include/asm/setup.h                   |    1 -
 arch/x86/include/asm/smp.h                     |   49 +-
 arch/x86/include/asm/system.h                  |    4 +-
 arch/x86/include/asm/thread_info.h             |   24 +-
 arch/x86/include/asm/tlbflush.h                |   17 +-
 arch/x86/include/asm/topology.h                |    8 +-
 arch/x86/include/asm/trampoline.h              |    1 +
 arch/x86/include/asm/unistd_32.h               |    1 +
 arch/x86/include/asm/unistd_64.h               |    3 +-
 arch/x86/include/asm/uv/uv_bau.h               |    3 +-
 arch/x86/kernel/acpi/boot.c                    |   96 +-
 arch/x86/kernel/acpi/sleep.c                   |    1 +
 arch/x86/kernel/apic.c                         |   26 +-
 arch/x86/kernel/asm-offsets_64.c               |    8 +-
 arch/x86/kernel/cpu/Makefile                   |   12 +-
 arch/x86/kernel/cpu/common.c                   |   82 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c     |    2 -
 arch/x86/kernel/cpu/intel_cacheinfo.c          |   63 +-
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c        |   21 +-
 arch/x86/kernel/cpu/perf_counter.c             |  695 ++++++++
 arch/x86/kernel/cpu/perfctr-watchdog.c         |    2 +-
 arch/x86/kernel/crash.c                        |    2 +-
 arch/x86/kernel/dumpstack_64.c                 |   35 +-
 arch/x86/kernel/entry_64.S                     |   46 +-
 arch/x86/kernel/head64.c                       |   23 +-
 arch/x86/kernel/head_64.S                      |   47 +-
 arch/x86/kernel/io_apic.c                      |  163 +-
 arch/x86/kernel/irq.c                          |   11 +-
 arch/x86/kernel/irq_32.c                       |    2 +-
 arch/x86/kernel/irq_64.c                       |    5 +-
 arch/x86/kernel/irqinit_32.c                   |    3 +
 arch/x86/kernel/irqinit_64.c                   |    5 +
 arch/x86/kernel/microcode_intel.c              |   10 +-
 arch/x86/kernel/module_32.c                    |    6 +-
 arch/x86/kernel/module_64.c                    |   32 +-
 arch/x86/kernel/mpparse.c                      |  142 +-
 arch/x86/kernel/msr.c                          |    2 +-
 arch/x86/kernel/nmi.c                          |   10 +-
 arch/x86/kernel/process_32.c                   |    5 +-
 arch/x86/kernel/process_64.c                   |   22 +-
 arch/x86/kernel/reboot.c                       |    1 +
 arch/x86/kernel/setup.c                        |    2 +-
 arch/x86/kernel/setup_percpu.c                 |  208 ++-
 arch/x86/kernel/signal.c                       |    7 +-
 arch/x86/kernel/smpboot.c                      |   69 +-
 arch/x86/kernel/smpcommon.c                    |   10 +-
 arch/x86/kernel/syscall_table_32.S             |    1 +
 arch/x86/kernel/tlb_32.c                       |   85 +-
 arch/x86/kernel/tlb_64.c                       |   76 +-
 arch/x86/kernel/tlb_uv.c                       |   16 +-
 arch/x86/kernel/vmlinux_32.lds.S               |    9 +-
 arch/x86/kernel/vmlinux_64.lds.S               |   22 +-
 arch/x86/kernel/x8664_ksyms_64.c               |    2 -
 arch/x86/mach-voyager/setup.c                  |    1 +
 arch/x86/mach-voyager/voyager_smp.c            |    6 +-
 arch/x86/mm/init_32.c                          |    1 -
 arch/x86/mm/pat.c                              |   37 +-
 arch/x86/oprofile/op_model_ppro.c              |    2 +-
 arch/x86/xen/enlighten.c                       |   47 +-
 arch/x86/xen/irq.c                             |    8 +-
 arch/x86/xen/mmu.c                             |    8 +-
 arch/x86/xen/multicalls.h                      |    2 +-
 arch/x86/xen/smp.c                             |   33 +-
 arch/x86/xen/xen-asm_64.S                      |   31 +-
 drivers/acpi/processor_idle.c                  |    8 +
 drivers/base/cpu.c                             |    2 +-
 drivers/base/topology.c                        |   33 +-
 drivers/char/sysrq.c                           |    2 +
 drivers/firmware/dcdbas.c                      |   12 +-
 drivers/misc/sgi-xp/xpc_main.c                 |    2 +-
 drivers/net/sfc/efx.c                          |   17 +-
 drivers/oprofile/buffer_sync.c                 |   22 +-
 drivers/oprofile/buffer_sync.h                 |    4 +
 drivers/oprofile/oprof.c                       |    9 +-
 drivers/pci/intr_remapping.c                   |    1 +
 drivers/xen/events.c                           |   26 +-
 drivers/xen/manage.c                           |    2 +-
 fs/exec.c                                      |    8 +
 include/asm-generic/bitops/__ffs.h             |    2 +-
 include/asm-generic/bitops/__fls.h             |    2 +-
 include/asm-generic/bitops/fls.h               |    2 +-
 include/asm-generic/bitops/fls64.h             |    4 +-
 include/asm-generic/percpu.h                   |   52 +
 include/asm-generic/sections.h                 |    2 +-
 include/asm-generic/vmlinux.lds.h              |   75 +-
 include/linux/init_task.h                      |   11 +
 include/linux/interrupt.h                      |    1 +
 include/linux/irq.h                            |   86 +-
 include/linux/irqnr.h                          |    1 +
 include/linux/kernel_stat.h                    |    8 +
 include/linux/perf_counter.h                   |  290 ++++
 include/linux/prctl.h                          |    3 +
 include/linux/sched.h                          |   12 +-
 include/linux/syscalls.h                       |    8 +
 include/linux/topology.h                       |    6 +
 init/Kconfig                                   |   30 +
 kernel/Makefile                                |    1 +
 kernel/exit.c                                  |   13 +-
 kernel/fork.c                                  |    1 +
 kernel/irq/chip.c                              |    5 +-
 kernel/irq/handle.c                            |   57 +-
 kernel/irq/internals.h                         |    7 +
 kernel/irq/manage.c                            |   12 +-
 kernel/irq/migration.c                         |   12 +-
 kernel/irq/numa_migrate.c                      |   19 +-
 kernel/irq/proc.c                              |    4 +-
 kernel/perf_counter.c                          | 2169 ++++++++++++++++++++++++
 kernel/sched.c                                 |   76 +-
 kernel/sched_rt.c                              |   36 +-
 kernel/softirq.c                               |    5 +
 kernel/sys.c                                   |    7 +
 kernel/sys_ni.c                                |    3 +
 lib/smp_processor_id.c                         |    2 +-
 179 files changed, 6925 insertions(+), 1342 deletions(-)
 create mode 100644 Documentation/perf-counters.txt
 create mode 100644 arch/powerpc/include/asm/perf_counter.h
 create mode 100644 arch/powerpc/kernel/perf_counter.c
 create mode 100644 arch/powerpc/kernel/power6-pmu.c
 create mode 100644 arch/powerpc/kernel/ppc970-pmu.c
 create mode 100644 arch/x86/include/asm/apicnum.h
 create mode 100644 arch/x86/include/asm/cpumask.h
 delete mode 100644 arch/x86/include/asm/intel_arch_perfmon.h
 create mode 100644 arch/x86/include/asm/perf_counter.h
 create mode 100644 arch/x86/kernel/cpu/perf_counter.c
 create mode 100644 include/linux/perf_counter.h
 create mode 100644 kernel/perf_counter.c

diff --git a/Documentation/cputopology.txt b/Documentation/cputopology.txt
index 45932ec..b41f3e5 100644
--- a/Documentation/cputopology.txt
+++ b/Documentation/cputopology.txt
@@ -18,11 +18,11 @@ For an architecture to support this feature, it must define some of
 these macros in include/asm-XXX/topology.h:
 #define topology_physical_package_id(cpu)
 #define topology_core_id(cpu)
-#define topology_thread_siblings(cpu)
-#define topology_core_siblings(cpu)
+#define topology_thread_cpumask(cpu)
+#define topology_core_cpumask(cpu)
 
 The type of **_id is int.
-The type of siblings is cpumask_t.
+The type of siblings is (const) struct cpumask *.
 
 To be consistent on all architectures, include/linux/topology.h
 provides default definitions for any of the above macros that are
diff --git a/Documentation/perf-counters.txt b/Documentation/perf-counters.txt
new file mode 100644
index 0000000..fddd321
--- /dev/null
+++ b/Documentation/perf-counters.txt
@@ -0,0 +1,147 @@
+
+Performance Counters for Linux
+------------------------------
+
+Performance counters are special hardware registers available on most modern
+CPUs. These registers count the number of certain types of hw events: such
+as instructions executed, cachemisses suffered, or branches mis-predicted -
+without slowing down the kernel or applications. These registers can also
+trigger interrupts when a threshold number of events have passed - and can
+thus be used to profile the code that runs on that CPU.
+
+The Linux Performance Counter subsystem provides an abstraction of these
+hardware capabilities. It provides per task and per CPU counters, counter
+groups, and it provides event capabilities on top of those.
+
+Performance counters are accessed via special file descriptors.
+There's one file descriptor per virtual counter used.
+
+The special file descriptor is opened via the perf_counter_open()
+system call:
+
+   int sys_perf_counter_open(struct perf_counter_hw_event *hw_event_uptr,
+			     pid_t pid, int cpu, int group_fd);
+
+The syscall returns the new fd. The fd can be used via the normal
+VFS system calls: read() can be used to read the counter, fcntl()
+can be used to set the blocking mode, etc.
+
+Multiple counters can be kept open at a time, and the counters
+can be poll()ed.
+
+When creating a new counter fd, 'perf_counter_hw_event' is:
+
+/*
+ * Hardware event to monitor via a performance monitoring counter:
+ */
+struct perf_counter_hw_event {
+	s64			type;
+
+	u64			irq_period;
+	u32			record_type;
+
+	u32			disabled     :  1, /* off by default */
+				nmi	     :  1, /* NMI sampling   */
+				raw	     :  1, /* raw event type */
+				__reserved_1 : 29;
+
+	u64			__reserved_2;
+};
+
+/*
+ * Generalized performance counter event types, used by the hw_event.type
+ * parameter of the sys_perf_counter_open() syscall:
+ */
+enum hw_event_types {
+	/*
+	 * Common hardware events, generalized by the kernel:
+	 */
+	PERF_COUNT_CYCLES		=  0,
+	PERF_COUNT_INSTRUCTIONS		=  1,
+	PERF_COUNT_CACHE_REFERENCES	=  2,
+	PERF_COUNT_CACHE_MISSES		=  3,
+	PERF_COUNT_BRANCH_INSTRUCTIONS	=  4,
+	PERF_COUNT_BRANCH_MISSES	=  5,
+
+	/*
+	 * Special "software" counters provided by the kernel, even if
+	 * the hardware does not support performance counters. These
+	 * counters measure various physical and sw events of the
+	 * kernel (and allow the profiling of them as well):
+	 */
+	PERF_COUNT_CPU_CLOCK		= -1,
+	PERF_COUNT_TASK_CLOCK		= -2,
+	/*
+	 * Future software events:
+	 */
+	/* PERF_COUNT_PAGE_FAULTS	= -3,
+	   PERF_COUNT_CONTEXT_SWITCHES	= -4, */
+};
+
+These are standardized types of events that work uniformly on all CPUs
+that implements Performance Counters support under Linux. If a CPU is
+not able to count branch-misses, then the system call will return
+-EINVAL.
+
+More hw_event_types are supported as well, but they are CPU
+specific and are enumerated via /sys on a per CPU basis. Raw hw event
+types can be passed in under hw_event.type if hw_event.raw is 1.
+For example, to count "External bus cycles while bus lock signal asserted"
+events on Intel Core CPUs, pass in a 0x4064 event type value and set
+hw_event.raw to 1.
+
+'record_type' is the type of data that a read() will provide for the
+counter, and it can be one of:
+
+/*
+ * IRQ-notification data record type:
+ */
+enum perf_counter_record_type {
+	PERF_RECORD_SIMPLE		=  0,
+	PERF_RECORD_IRQ			=  1,
+	PERF_RECORD_GROUP		=  2,
+};
+
+a "simple" counter is one that counts hardware events and allows
+them to be read out into a u64 count value. (read() returns 8 on
+a successful read of a simple counter.)
+
+An "irq" counter is one that will also provide an IRQ context information:
+the IP of the interrupted context. In this case read() will return
+the 8-byte counter value, plus the Instruction Pointer address of the
+interrupted context.
+
+The parameter 'hw_event_period' is the number of events before waking up
+a read() that is blocked on a counter fd. Zero value means a non-blocking
+counter.
+
+The 'pid' parameter allows the counter to be specific to a task:
+
+ pid == 0: if the pid parameter is zero, the counter is attached to the
+ current task.
+
+ pid > 0: the counter is attached to a specific task (if the current task
+ has sufficient privilege to do so)
+
+ pid < 0: all tasks are counted (per cpu counters)
+
+The 'cpu' parameter allows a counter to be made specific to a full
+CPU:
+
+ cpu >= 0: the counter is restricted to a specific CPU
+ cpu == -1: the counter counts on all CPUs
+
+(Note: the combination of 'pid == -1' and 'cpu == -1' is not valid.)
+
+A 'pid > 0' and 'cpu == -1' counter is a per task counter that counts
+events of that task and 'follows' that task to whatever CPU the task
+gets schedule to. Per task counters can be created by any user, for
+their own tasks.
+
+A 'pid == -1' and 'cpu == x' counter is a per CPU counter that counts
+all events on CPU-x. Per CPU counters need CAP_SYS_ADMIN privilege.
+
+Group counters are created by passing in a group_fd of another counter.
+Groups are scheduled at once and can be used with PERF_RECORD_GROUP
+to record multi-dimensional timestamps.
+
diff --git a/arch/alpha/kernel/irq.c b/arch/alpha/kernel/irq.c
index 703731a..7bc7489 100644
--- a/arch/alpha/kernel/irq.c
+++ b/arch/alpha/kernel/irq.c
@@ -55,7 +55,7 @@ int irq_select_affinity(unsigned int irq)
 		cpu = (cpu < (NR_CPUS-1) ? cpu + 1 : 0);
 	last_cpu = cpu;
 
-	irq_desc[irq].affinity = cpumask_of_cpu(cpu);
+	cpumask_copy(irq_desc[irq].affinity, cpumask_of(cpu));
 	irq_desc[irq].chip->set_affinity(irq, cpumask_of(cpu));
 	return 0;
 }
diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 7141cee..4bb723e 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -104,6 +104,11 @@ static struct irq_desc bad_irq_desc = {
 	.lock = SPIN_LOCK_UNLOCKED
 };
 
+#ifdef CONFIG_CPUMASK_OFFSTACK
+/* We are not allocating bad_irq_desc.affinity or .pending_mask */
+#error "ARM architecture does not support CONFIG_CPUMASK_OFFSTACK."
+#endif
+
 /*
  * do_IRQ handles all hardware IRQ's.  Decoded IRQs should not
  * come via this function.  Instead, they should provide their
@@ -161,7 +166,7 @@ void __init init_IRQ(void)
 		irq_desc[irq].status |= IRQ_NOREQUEST | IRQ_NOPROBE;
 
 #ifdef CONFIG_SMP
-	bad_irq_desc.affinity = CPU_MASK_ALL;
+	cpumask_setall(bad_irq_desc.affinity);
 	bad_irq_desc.cpu = smp_processor_id();
 #endif
 	init_arch_irq();
@@ -191,15 +196,16 @@ void migrate_irqs(void)
 		struct irq_desc *desc = irq_desc + i;
 
 		if (desc->cpu == cpu) {
-			unsigned int newcpu = any_online_cpu(desc->affinity);
-
-			if (newcpu == NR_CPUS) {
+			unsigned int newcpu = cpumask_any_and(desc->affinity,
+							      cpu_online_mask);
+			if (newcpu >= nr_cpu_ids) {
 				if (printk_ratelimit())
 					printk(KERN_INFO "IRQ%u no longer affine to CPU%u\n",
 					       i, cpu);
 
-				cpus_setall(desc->affinity);
-				newcpu = any_online_cpu(desc->affinity);
+				cpumask_setall(desc->affinity);
+				newcpu = cpumask_any_and(desc->affinity,
+							 cpu_online_mask);
 			}
 
 			route_irq(desc, i, newcpu);
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 0021607..85598f7 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -65,6 +65,7 @@ SECTIONS
 #endif
 		. = ALIGN(4096);
 		__per_cpu_start = .;
+			*(.data.percpu.page_aligned)
 			*(.data.percpu)
 			*(.data.percpu.shared_aligned)
 		__per_cpu_end = .;
diff --git a/arch/arm/oprofile/op_model_mpcore.c b/arch/arm/oprofile/op_model_mpcore.c
index 6d6bd58..853d42b 100644
--- a/arch/arm/oprofile/op_model_mpcore.c
+++ b/arch/arm/oprofile/op_model_mpcore.c
@@ -263,7 +263,7 @@ static void em_route_irq(int irq, unsigned int cpu)
 	const struct cpumask *mask = cpumask_of(cpu);
 
 	spin_lock_irq(&desc->lock);
-	desc->affinity = *mask;
+	cpumask_copy(desc->affinity, mask);
 	desc->chip->set_affinity(irq, mask);
 	spin_unlock_irq(&desc->lock);
 }
diff --git a/arch/blackfin/kernel/irqchip.c b/arch/blackfin/kernel/irqchip.c
index ab8209c..5780d6d 100644
--- a/arch/blackfin/kernel/irqchip.c
+++ b/arch/blackfin/kernel/irqchip.c
@@ -69,6 +69,11 @@ static struct irq_desc bad_irq_desc = {
 #endif
 };
 
+#ifdef CONFIG_CPUMASK_OFFSTACK
+/* We are not allocating a variable-sized bad_irq_desc.affinity */
+#error "Blackfin architecture does not support CONFIG_CPUMASK_OFFSTACK."
+#endif
+
 int show_interrupts(struct seq_file *p, void *v)
 {
 	int i = *(loff_t *) v, j;
diff --git a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
index 5cfd3d9..006ad36 100644
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -880,7 +880,7 @@ iosapic_unregister_intr (unsigned int gsi)
 	if (iosapic_intr_info[irq].count == 0) {
 #ifdef CONFIG_SMP
 		/* Clear affinity */
-		cpus_setall(idesc->affinity);
+		cpumask_setall(idesc->affinity);
 #endif
 		/* Clear the interrupt information */
 		iosapic_intr_info[irq].dest = 0;
diff --git a/arch/ia64/kernel/irq.c b/arch/ia64/kernel/irq.c
index a58f64c..226233a 100644
--- a/arch/ia64/kernel/irq.c
+++ b/arch/ia64/kernel/irq.c
@@ -103,7 +103,7 @@ static char irq_redir [NR_IRQS]; // = { [0 ... NR_IRQS-1] = 1 };
 void set_irq_affinity_info (unsigned int irq, int hwid, int redir)
 {
 	if (irq < NR_IRQS) {
-		cpumask_copy(&irq_desc[irq].affinity,
+		cpumask_copy(irq_desc[irq].affinity,
 			     cpumask_of(cpu_logical_id(hwid)));
 		irq_redir[irq] = (char) (redir & 0xff);
 	}
@@ -148,7 +148,7 @@ static void migrate_irqs(void)
 		if (desc->status == IRQ_PER_CPU)
 			continue;
 
-		if (cpumask_any_and(&irq_desc[irq].affinity, cpu_online_mask)
+		if (cpumask_any_and(irq_desc[irq].affinity, cpu_online_mask)
 		    >= nr_cpu_ids) {
 			/*
 			 * Save it for phase 2 processing
diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index 28d3d48..927ad02 100644
--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -493,11 +493,13 @@ ia64_handle_irq (ia64_vector vector, struct pt_regs *regs)
 	saved_tpr = ia64_getreg(_IA64_REG_CR_TPR);
 	ia64_srlz_d();
 	while (vector != IA64_SPURIOUS_INT_VECTOR) {
+		struct irq_desc *desc = irq_to_desc(vector);
+
 		if (unlikely(IS_LOCAL_TLB_FLUSH(vector))) {
 			smp_local_flush_tlb();
-			kstat_this_cpu.irqs[vector]++;
+			kstat_incr_irqs_this_cpu(vector, desc);
 		} else if (unlikely(IS_RESCHEDULE(vector)))
-			kstat_this_cpu.irqs[vector]++;
+			kstat_incr_irqs_this_cpu(vector, desc);
 		else {
 			int irq = local_vector_to_irq(vector);
 
@@ -551,11 +553,13 @@ void ia64_process_pending_intr(void)
 	  * Perform normal interrupt style processing
 	  */
 	while (vector != IA64_SPURIOUS_INT_VECTOR) {
+		struct irq_desc *desc = irq_to_desc(vector);
+
 		if (unlikely(IS_LOCAL_TLB_FLUSH(vector))) {
 			smp_local_flush_tlb();
-			kstat_this_cpu.irqs[vector]++;
+			kstat_incr_irqs_this_cpu(vector, desc);
 		} else if (unlikely(IS_RESCHEDULE(vector)))
-			kstat_this_cpu.irqs[vector]++;
+			kstat_incr_irqs_this_cpu(vector, desc);
 		else {
 			struct pt_regs *old_regs = set_irq_regs(NULL);
 			int irq = local_vector_to_irq(vector);
diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index 8903393..dcb6b7c 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -75,7 +75,7 @@ static void ia64_set_msi_irq_affinity(unsigned int irq,
 	msg.data = data;
 
 	write_msi_msg(irq, &msg);
-	irq_desc[irq].affinity = cpumask_of_cpu(cpu);
+	cpumask_copy(irq_desc[irq].affinity, cpumask_of(cpu));
 }
 #endif /* CONFIG_SMP */
 
@@ -187,7 +187,7 @@ static void dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 	msg.address_lo |= MSI_ADDR_DESTID_CPU(cpu_physical_id(cpu));
 
 	dmar_msi_write(irq, &msg);
-	irq_desc[irq].affinity = *mask;
+	cpumask_copy(irq_desc[irq].affinity, mask);
 }
 #endif /* CONFIG_SMP */
 
diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index 10a7d47..f45e4e5 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -219,6 +219,7 @@ SECTIONS
   .data.percpu PERCPU_ADDR : AT(__phys_per_cpu_start - LOAD_OFFSET)
 	{
 		__per_cpu_start = .;
+		*(.data.percpu.page_aligned)
 		*(.data.percpu)
 		*(.data.percpu.shared_aligned)
 		__per_cpu_end = .;
diff --git a/arch/ia64/sn/kernel/msi_sn.c b/arch/ia64/sn/kernel/msi_sn.c
index ca553b0..81e4289 100644
--- a/arch/ia64/sn/kernel/msi_sn.c
+++ b/arch/ia64/sn/kernel/msi_sn.c
@@ -205,7 +205,7 @@ static void sn_set_msi_irq_affinity(unsigned int irq,
 	msg.address_lo = (u32)(bus_addr & 0x00000000ffffffff);
 
 	write_msi_msg(irq, &msg);
-	irq_desc[irq].affinity = *cpu_mask;
+	cpumask_copy(irq_desc[irq].affinity, cpu_mask);
 }
 #endif /* CONFIG_SMP */
 
diff --git a/arch/mips/include/asm/irq.h b/arch/mips/include/asm/irq.h
index abc62aa..3214ade 100644
--- a/arch/mips/include/asm/irq.h
+++ b/arch/mips/include/asm/irq.h
@@ -66,7 +66,7 @@ extern void smtc_forward_irq(unsigned int irq);
  */
 #define IRQ_AFFINITY_HOOK(irq)						\
 do {									\
-    if (!cpu_isset(smp_processor_id(), irq_desc[irq].affinity)) {	\
+    if (!cpumask_test_cpu(smp_processor_id(), irq_desc[irq].affinity)) {\
 	smtc_forward_irq(irq);						\
 	irq_exit();							\
 	return;								\
diff --git a/arch/mips/kernel/irq-gic.c b/arch/mips/kernel/irq-gic.c
index 494a49a..87deb8f 100644
--- a/arch/mips/kernel/irq-gic.c
+++ b/arch/mips/kernel/irq-gic.c
@@ -187,7 +187,7 @@ static void gic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 		set_bit(irq, pcpu_masks[first_cpu(tmp)].pcpu_mask);
 
 	}
-	irq_desc[irq].affinity = *cpumask;
+	cpumask_copy(irq_desc[irq].affinity, cpumask);
 	spin_unlock_irqrestore(&gic_lock, flags);
 
 }
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index b6cca01..5f5af7d 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -686,7 +686,7 @@ void smtc_forward_irq(unsigned int irq)
 	 * and efficiency, we just pick the easiest one to find.
 	 */
 
-	target = first_cpu(irq_desc[irq].affinity);
+	target = cpumask_first(irq_desc[irq].affinity);
 
 	/*
 	 * We depend on the platform code to have correctly processed
@@ -921,11 +921,13 @@ void ipi_decode(struct smtc_ipi *pipi)
 	struct clock_event_device *cd;
 	void *arg_copy = pipi->arg;
 	int type_copy = pipi->type;
+	int irq = MIPS_CPU_IRQ_BASE + 1;
+
 	smtc_ipi_nq(&freeIPIq, pipi);
 	switch (type_copy) {
 	case SMTC_CLOCK_TICK:
 		irq_enter();
-		kstat_this_cpu.irqs[MIPS_CPU_IRQ_BASE + 1]++;
+		kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
 		cd = &per_cpu(mips_clockevent_device, cpu);
 		cd->event_handler(cd);
 		irq_exit();
diff --git a/arch/mips/mti-malta/malta-smtc.c b/arch/mips/mti-malta/malta-smtc.c
index aabd727..5ba3188 100644
--- a/arch/mips/mti-malta/malta-smtc.c
+++ b/arch/mips/mti-malta/malta-smtc.c
@@ -116,7 +116,7 @@ struct plat_smp_ops msmtc_smp_ops = {
 
 void plat_set_irq_affinity(unsigned int irq, const struct cpumask *affinity)
 {
-	cpumask_t tmask = *affinity;
+	cpumask_t tmask;
 	int cpu = 0;
 	void smtc_set_irq_affinity(unsigned int irq, cpumask_t aff);
 
@@ -139,11 +139,12 @@ void plat_set_irq_affinity(unsigned int irq, const struct cpumask *affinity)
 	 * be made to forward to an offline "CPU".
 	 */
 
+	cpumask_copy(&tmask, affinity);
 	for_each_cpu(cpu, affinity) {
 		if ((cpu_data[cpu].vpe_id != 0) || !cpu_online(cpu))
 			cpu_clear(cpu, tmask);
 	}
-	irq_desc[irq].affinity = tmask;
+	cpumask_copy(irq_desc[irq].affinity, &tmask);
 
 	if (cpus_empty(tmask))
 		/*
diff --git a/arch/mips/sgi-ip22/ip22-int.c b/arch/mips/sgi-ip22/ip22-int.c
index f8b18af..0ecd5fe 100644
--- a/arch/mips/sgi-ip22/ip22-int.c
+++ b/arch/mips/sgi-ip22/ip22-int.c
@@ -155,7 +155,7 @@ static void indy_buserror_irq(void)
 	int irq = SGI_BUSERR_IRQ;
 
 	irq_enter();
-	kstat_this_cpu.irqs[irq]++;
+	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
 	ip22_be_interrupt(irq);
 	irq_exit();
 }
diff --git a/arch/mips/sgi-ip22/ip22-time.c b/arch/mips/sgi-ip22/ip22-time.c
index 3dcb27e..c8f7d23 100644
--- a/arch/mips/sgi-ip22/ip22-time.c
+++ b/arch/mips/sgi-ip22/ip22-time.c
@@ -122,7 +122,7 @@ void indy_8254timer_irq(void)
 	char c;
 
 	irq_enter();
-	kstat_this_cpu.irqs[irq]++;
+	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
 	printk(KERN_ALERT "Oops, got 8254 interrupt.\n");
 	ArcRead(0, &c, 1, &cnt);
 	ArcEnterInteractiveMode();
diff --git a/arch/mips/sibyte/bcm1480/smp.c b/arch/mips/sibyte/bcm1480/smp.c
index dddfda8..3146916 100644
--- a/arch/mips/sibyte/bcm1480/smp.c
+++ b/arch/mips/sibyte/bcm1480/smp.c
@@ -178,9 +178,10 @@ struct plat_smp_ops bcm1480_smp_ops = {
 void bcm1480_mailbox_interrupt(void)
 {
 	int cpu = smp_processor_id();
+	int irq = K_BCM1480_INT_MBOX_0_0;
 	unsigned int action;
 
-	kstat_this_cpu.irqs[K_BCM1480_INT_MBOX_0_0]++;
+	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
 	/* Load the mailbox register to figure out what we're supposed to do */
 	action = (__raw_readq(mailbox_0_regs[cpu]) >> 48) & 0xffff;
 
diff --git a/arch/mips/sibyte/sb1250/smp.c b/arch/mips/sibyte/sb1250/smp.c
index 5950a28..cad1400 100644
--- a/arch/mips/sibyte/sb1250/smp.c
+++ b/arch/mips/sibyte/sb1250/smp.c
@@ -166,9 +166,10 @@ struct plat_smp_ops sb_smp_ops = {
 void sb1250_mailbox_interrupt(void)
 {
 	int cpu = smp_processor_id();
+	int irq = K_INT_MBOX_0;
 	unsigned int action;
 
-	kstat_this_cpu.irqs[K_INT_MBOX_0]++;
+	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
 	/* Load the mailbox register to figure out what we're supposed to do */
 	action = (____raw_readq(mailbox_regs[cpu]) >> 48) & 0xffff;
 
diff --git a/arch/mn10300/kernel/mn10300-watchdog.c b/arch/mn10300/kernel/mn10300-watchdog.c
index 10811e9..2e370d8 100644
--- a/arch/mn10300/kernel/mn10300-watchdog.c
+++ b/arch/mn10300/kernel/mn10300-watchdog.c
@@ -130,6 +130,7 @@ void watchdog_interrupt(struct pt_regs *regs, enum exception_code excep)
 	 * the stack NMI-atomically, it's safe to use smp_processor_id().
 	 */
 	int sum, cpu = smp_processor_id();
+	int irq = NMIIRQ;
 	u8 wdt, tmp;
 
 	wdt = WDCTR & ~WDCTR_WDCNE;
@@ -138,7 +139,7 @@ void watchdog_interrupt(struct pt_regs *regs, enum exception_code excep)
 	NMICR = NMICR_WDIF;
 
 	nmi_count(cpu)++;
-	kstat_this_cpu.irqs[NMIIRQ]++;
+	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
 	sum = irq_stat[cpu].__irq_count;
 
 	if (last_irq_sums[cpu] == sum) {
diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index ac2c822..4948280 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -120,7 +120,7 @@ int cpu_check_affinity(unsigned int irq, cpumask_t *dest)
 	if (CHECK_IRQ_PER_CPU(irq)) {
 		/* Bad linux design decision.  The mask has already
 		 * been set; we must reset it */
-		irq_desc[irq].affinity = CPU_MASK_ALL;
+		cpumask_setall(irq_desc[irq].affinity);
 		return -EINVAL;
 	}
 
@@ -136,7 +136,7 @@ static void cpu_set_affinity_irq(unsigned int irq, const struct cpumask *dest)
 	if (cpu_check_affinity(irq, dest))
 		return;
 
-	irq_desc[irq].affinity = *dest;
+	cpumask_copy(irq_desc[irq].affinity, dest);
 }
 #endif
 
@@ -295,7 +295,7 @@ int txn_alloc_irq(unsigned int bits_wide)
 unsigned long txn_affinity_addr(unsigned int irq, int cpu)
 {
 #ifdef CONFIG_SMP
-	irq_desc[irq].affinity = cpumask_of_cpu(cpu);
+	cpumask_copy(irq_desc[irq].affinity, cpumask_of(cpu));
 #endif
 
 	return per_cpu(cpu_data, cpu).txn_addr;
@@ -352,7 +352,7 @@ void do_cpu_irq_mask(struct pt_regs *regs)
 	irq = eirr_to_irq(eirr_val);
 
 #ifdef CONFIG_SMP
-	dest = irq_desc[irq].affinity;
+	cpumask_copy(&dest, irq_desc[irq].affinity);
 	if (CHECK_IRQ_PER_CPU(irq_desc[irq].status) &&
 	    !cpu_isset(smp_processor_id(), dest)) {
 		int cpu = first_cpu(dest);
diff --git a/arch/powerpc/include/asm/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
index f75a5fc..e10f151 100644
--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -131,5 +131,36 @@ static inline int irqs_disabled_flags(unsigned long flags)
  */
 struct hw_interrupt_type;
 
+#ifdef CONFIG_PERF_COUNTERS
+static inline unsigned long get_perf_counter_pending(void)
+{
+	unsigned long x;
+
+	asm volatile("lbz %0,%1(13)"
+		: "=r" (x)
+		: "i" (offsetof(struct paca_struct, perf_counter_pending)));
+	return x;
+}
+
+static inline void set_perf_counter_pending(int x)
+{
+	asm volatile("stb %0,%1(13)" : :
+		"r" (x),
+		"i" (offsetof(struct paca_struct, perf_counter_pending)));
+}
+
+extern void perf_counter_do_pending(void);
+
+#else
+
+static inline unsigned long get_perf_counter_pending(void)
+{
+	return 0;
+}
+
+static inline void set_perf_counter_pending(int x) {}
+static inline void perf_counter_do_pending(void) {}
+#endif /* CONFIG_PERF_COUNTERS */
+
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_HW_IRQ_H */
diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index 082b3ae..6ef0557 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -99,6 +99,7 @@ struct paca_struct {
 	u8 soft_enabled;		/* irq soft-enable flag */
 	u8 hard_enabled;		/* set if irqs are enabled in MSR */
 	u8 io_sync;			/* writel() needs spin_unlock sync */
+	u8 perf_counter_pending;	/* PM interrupt while soft-disabled */
 
 	/* Stuff for accurate time accounting */
 	u64 user_time;			/* accumulated usermode TB ticks */
diff --git a/arch/powerpc/include/asm/perf_counter.h b/arch/powerpc/include/asm/perf_counter.h
new file mode 100644
index 0000000..9d7ff6d
--- /dev/null
+++ b/arch/powerpc/include/asm/perf_counter.h
@@ -0,0 +1,72 @@
+/*
+ * Performance counter support - PowerPC-specific definitions.
+ *
+ * Copyright 2008-2009 Paul Mackerras, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/types.h>
+
+#define MAX_HWCOUNTERS		8
+#define MAX_EVENT_ALTERNATIVES	8
+
+/*
+ * This struct provides the constants and functions needed to
+ * describe the PMU on a particular POWER-family CPU.
+ */
+struct power_pmu {
+	int	n_counter;
+	int	max_alternatives;
+	u64	add_fields;
+	u64	test_adder;
+	int	(*compute_mmcr)(unsigned int events[], int n_ev,
+				unsigned int hwc[], u64 mmcr[]);
+	int	(*get_constraint)(unsigned int event, u64 *mskp, u64 *valp);
+	int	(*get_alternatives)(unsigned int event, unsigned int alt[]);
+	void	(*disable_pmc)(unsigned int pmc, u64 mmcr[]);
+	int	n_generic;
+	int	*generic_events;
+};
+
+extern struct power_pmu *ppmu;
+
+/*
+ * The power_pmu.get_constraint function returns a 64-bit value and
+ * a 64-bit mask that express the constraints between this event and
+ * other events.
+ *
+ * The value and mask are divided up into (non-overlapping) bitfields
+ * of three different types:
+ *
+ * Select field: this expresses the constraint that some set of bits
+ * in MMCR* needs to be set to a specific value for this event.  For a
+ * select field, the mask contains 1s in every bit of the field, and
+ * the value contains a unique value for each possible setting of the
+ * MMCR* bits.  The constraint checking code will ensure that two events
+ * that set the same field in their masks have the same value in their
+ * value dwords.
+ *
+ * Add field: this expresses the constraint that there can be at most
+ * N events in a particular class.  A field of k bits can be used for
+ * N <= 2^(k-1) - 1.  The mask has the most significant bit of the field
+ * set (and the other bits 0), and the value has only the least significant
+ * bit of the field set.  In addition, the 'add_fields' and 'test_adder'
+ * in the struct power_pmu for this processor come into play.  The
+ * add_fields value contains 1 in the LSB of the field, and the
+ * test_adder contains 2^(k-1) - 1 - N in the field.
+ *
+ * NAND field: this expresses the constraint that you may not have events
+ * in all of a set of classes.  (For example, on PPC970, you can't select
+ * events from the FPU, ISU and IDU simultaneously, although any two are
+ * possible.)  For N classes, the field is N+1 bits wide, and each class
+ * is assigned one bit from the least-significant N bits.  The mask has
+ * only the most-significant bit set, and the value has only the bit
+ * for the event's class set.  The test_adder has the least significant
+ * bit set in the field.
+ *
+ * If an event is not subject to the constraint expressed by a particular
+ * field, then it will have 0 in both the mask and value for that field.
+ */
diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 72353f6..4c8095f 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -322,3 +322,4 @@ SYSCALL_SPU(epoll_create1)
 SYSCALL_SPU(dup3)
 SYSCALL_SPU(pipe2)
 SYSCALL(inotify_init1)
+SYSCALL(perf_counter_open)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index e07d0c7..7cef5af 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -341,10 +341,11 @@
 #define __NR_dup3		316
 #define __NR_pipe2		317
 #define __NR_inotify_init1	318
+#define __NR_perf_counter_open	319
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		319
+#define __NR_syscalls		320
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 8d1a419..7c941ec 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -94,6 +94,7 @@ obj-$(CONFIG_AUDIT)		+= audit.o
 obj64-$(CONFIG_AUDIT)		+= compat_audit.o
 
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
+obj-$(CONFIG_PERF_COUNTERS)	+= perf_counter.o ppc970-pmu.o power6-pmu.o
 
 obj-$(CONFIG_8XX_MINIMAL_FPEMU) += softemu8xx.o
 
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 19ee491..3734973 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -131,6 +131,7 @@ int main(void)
 	DEFINE(PACAKMSR, offsetof(struct paca_struct, kernel_msr));
 	DEFINE(PACASOFTIRQEN, offsetof(struct paca_struct, soft_enabled));
 	DEFINE(PACAHARDIRQEN, offsetof(struct paca_struct, hard_enabled));
+	DEFINE(PACAPERFPEND, offsetof(struct paca_struct, perf_counter_pending));
 	DEFINE(PACASLBCACHE, offsetof(struct paca_struct, slb_cache));
 	DEFINE(PACASLBCACHEPTR, offsetof(struct paca_struct, slb_cache_ptr));
 	DEFINE(PACACONTEXTID, offsetof(struct paca_struct, context.id));
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 383ed6e..f30b4e5 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -526,6 +526,15 @@ ALT_FW_FTR_SECTION_END_IFCLR(FW_FEATURE_ISERIES)
 2:
 	TRACE_AND_RESTORE_IRQ(r5);
 
+#ifdef CONFIG_PERF_COUNTERS
+	/* check paca->perf_counter_pending if we're enabling ints */
+	lbz	r3,PACAPERFPEND(r13)
+	and.	r3,r3,r5
+	beq	27f
+	bl	.perf_counter_do_pending
+27:
+#endif /* CONFIG_PERF_COUNTERS */
+
 	/* extract EE bit and use it to restore paca->hard_enabled */
 	ld	r3,_MSR(r1)
 	rldicl	r4,r3,49,63		/* r0 = (r3 >> 15) & 1 */
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 23b8b5e..7f8e6a9 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -104,6 +104,13 @@ static inline notrace void set_soft_enabled(unsigned long enable)
 	: : "r" (enable), "i" (offsetof(struct paca_struct, soft_enabled)));
 }
 
+#ifdef CONFIG_PERF_COUNTERS
+notrace void __weak perf_counter_do_pending(void)
+{
+	set_perf_counter_pending(0);
+}
+#endif
+
 notrace void raw_local_irq_restore(unsigned long en)
 {
 	/*
@@ -135,6 +142,9 @@ notrace void raw_local_irq_restore(unsigned long en)
 			iseries_handle_interrupts();
 	}
 
+	if (get_perf_counter_pending())
+		perf_counter_do_pending();
+
 	/*
 	 * if (get_paca()->hard_enabled) return;
 	 * But again we need to take care that gcc gets hard_enabled directly
@@ -231,7 +241,7 @@ void fixup_irqs(cpumask_t map)
 		if (irq_desc[irq].status & IRQ_PER_CPU)
 			continue;
 
-		cpus_and(mask, irq_desc[irq].affinity, map);
+		cpumask_and(&mask, irq_desc[irq].affinity, &map);
 		if (any_online_cpu(mask) == NR_CPUS) {
 			printk("Breaking affinity for irq %i\n", irq);
 			mask = map;
diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
new file mode 100644
index 0000000..5b02113
--- /dev/null
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -0,0 +1,785 @@
+/*
+ * Performance counter support - powerpc architecture code
+ *
+ * Copyright 2008-2009 Paul Mackerras, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/perf_counter.h>
+#include <linux/percpu.h>
+#include <linux/hardirq.h>
+#include <asm/reg.h>
+#include <asm/pmc.h>
+#include <asm/machdep.h>
+
+struct cpu_hw_counters {
+	int n_counters;
+	int n_percpu;
+	int disabled;
+	int n_added;
+	struct perf_counter *counter[MAX_HWCOUNTERS];
+	unsigned int events[MAX_HWCOUNTERS];
+	u64 mmcr[3];
+	u8 pmcs_enabled;
+};
+DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters);
+
+struct power_pmu *ppmu;
+
+void perf_counter_print_debug(void)
+{
+}
+
+/*
+ * Read one performance monitor counter (PMC).
+ */
+static unsigned long read_pmc(int idx)
+{
+	unsigned long val;
+
+	switch (idx) {
+	case 1:
+		val = mfspr(SPRN_PMC1);
+		break;
+	case 2:
+		val = mfspr(SPRN_PMC2);
+		break;
+	case 3:
+		val = mfspr(SPRN_PMC3);
+		break;
+	case 4:
+		val = mfspr(SPRN_PMC4);
+		break;
+	case 5:
+		val = mfspr(SPRN_PMC5);
+		break;
+	case 6:
+		val = mfspr(SPRN_PMC6);
+		break;
+	case 7:
+		val = mfspr(SPRN_PMC7);
+		break;
+	case 8:
+		val = mfspr(SPRN_PMC8);
+		break;
+	default:
+		printk(KERN_ERR "oops trying to read PMC%d\n", idx);
+		val = 0;
+	}
+	return val;
+}
+
+/*
+ * Write one PMC.
+ */
+static void write_pmc(int idx, unsigned long val)
+{
+	switch (idx) {
+	case 1:
+		mtspr(SPRN_PMC1, val);
+		break;
+	case 2:
+		mtspr(SPRN_PMC2, val);
+		break;
+	case 3:
+		mtspr(SPRN_PMC3, val);
+		break;
+	case 4:
+		mtspr(SPRN_PMC4, val);
+		break;
+	case 5:
+		mtspr(SPRN_PMC5, val);
+		break;
+	case 6:
+		mtspr(SPRN_PMC6, val);
+		break;
+	case 7:
+		mtspr(SPRN_PMC7, val);
+		break;
+	case 8:
+		mtspr(SPRN_PMC8, val);
+		break;
+	default:
+		printk(KERN_ERR "oops trying to write PMC%d\n", idx);
+	}
+}
+
+/*
+ * Check if a set of events can all go on the PMU at once.
+ * If they can't, this will look at alternative codes for the events
+ * and see if any combination of alternative codes is feasible.
+ * The feasible set is returned in event[].
+ */
+static int power_check_constraints(unsigned int event[], int n_ev)
+{
+	u64 mask, value, nv;
+	unsigned int alternatives[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
+	u64 amasks[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
+	u64 avalues[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
+	u64 smasks[MAX_HWCOUNTERS], svalues[MAX_HWCOUNTERS];
+	int n_alt[MAX_HWCOUNTERS], choice[MAX_HWCOUNTERS];
+	int i, j;
+	u64 addf = ppmu->add_fields;
+	u64 tadd = ppmu->test_adder;
+
+	if (n_ev > ppmu->n_counter)
+		return -1;
+
+	/* First see if the events will go on as-is */
+	for (i = 0; i < n_ev; ++i) {
+		alternatives[i][0] = event[i];
+		if (ppmu->get_constraint(event[i], &amasks[i][0],
+					 &avalues[i][0]))
+			return -1;
+		choice[i] = 0;
+	}
+	value = mask = 0;
+	for (i = 0; i < n_ev; ++i) {
+		nv = (value | avalues[i][0]) + (value & avalues[i][0] & addf);
+		if ((((nv + tadd) ^ value) & mask) != 0 ||
+		    (((nv + tadd) ^ avalues[i][0]) & amasks[i][0]) != 0)
+			break;
+		value = nv;
+		mask |= amasks[i][0];
+	}
+	if (i == n_ev)
+		return 0;	/* all OK */
+
+	/* doesn't work, gather alternatives... */
+	if (!ppmu->get_alternatives)
+		return -1;
+	for (i = 0; i < n_ev; ++i) {
+		n_alt[i] = ppmu->get_alternatives(event[i], alternatives[i]);
+		for (j = 1; j < n_alt[i]; ++j)
+			ppmu->get_constraint(alternatives[i][j],
+					     &amasks[i][j], &avalues[i][j]);
+	}
+
+	/* enumerate all possibilities and see if any will work */
+	i = 0;
+	j = -1;
+	value = mask = nv = 0;
+	while (i < n_ev) {
+		if (j >= 0) {
+			/* we're backtracking, restore context */
+			value = svalues[i];
+			mask = smasks[i];
+			j = choice[i];
+		}
+		/*
+		 * See if any alternative k for event i,
+		 * where k > j, will satisfy the constraints.
+		 */
+		while (++j < n_alt[i]) {
+			nv = (value | avalues[i][j]) +
+				(value & avalues[i][j] & addf);
+			if ((((nv + tadd) ^ value) & mask) == 0 &&
+			    (((nv + tadd) ^ avalues[i][j])
+			     & amasks[i][j]) == 0)
+				break;
+		}
+		if (j >= n_alt[i]) {
+			/*
+			 * No feasible alternative, backtrack
+			 * to event i-1 and continue enumerating its
+			 * alternatives from where we got up to.
+			 */
+			if (--i < 0)
+				return -1;
+		} else {
+			/*
+			 * Found a feasible alternative for event i,
+			 * remember where we got up to with this event,
+			 * go on to the next event, and start with
+			 * the first alternative for it.
+			 */
+			choice[i] = j;
+			svalues[i] = value;
+			smasks[i] = mask;
+			value = nv;
+			mask |= amasks[i][j];
+			++i;
+			j = -1;
+		}
+	}
+
+	/* OK, we have a feasible combination, tell the caller the solution */
+	for (i = 0; i < n_ev; ++i)
+		event[i] = alternatives[i][choice[i]];
+	return 0;
+}
+
+static void power_perf_read(struct perf_counter *counter)
+{
+	long val, delta, prev;
+
+	if (!counter->hw.idx)
+		return;
+	/*
+	 * Performance monitor interrupts come even when interrupts
+	 * are soft-disabled, as long as interrupts are hard-enabled.
+	 * Therefore we treat them like NMIs.
+	 */
+	do {
+		prev = atomic64_read(&counter->hw.prev_count);
+		barrier();
+		val = read_pmc(counter->hw.idx);
+	} while (atomic64_cmpxchg(&counter->hw.prev_count, prev, val) != prev);
+
+	/* The counters are only 32 bits wide */
+	delta = (val - prev) & 0xfffffffful;
+	atomic64_add(delta, &counter->count);
+	atomic64_sub(delta, &counter->hw.period_left);
+}
+
+/*
+ * Disable all counters to prevent PMU interrupts and to allow
+ * counters to be added or removed.
+ */
+u64 hw_perf_save_disable(void)
+{
+	struct cpu_hw_counters *cpuhw;
+	unsigned long ret;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	cpuhw = &__get_cpu_var(cpu_hw_counters);
+
+	ret = cpuhw->disabled;
+	if (!ret) {
+		cpuhw->disabled = 1;
+		cpuhw->n_added = 0;
+
+		/*
+		 * Check if we ever enabled the PMU on this cpu.
+		 */
+		if (!cpuhw->pmcs_enabled) {
+			if (ppc_md.enable_pmcs)
+				ppc_md.enable_pmcs();
+			cpuhw->pmcs_enabled = 1;
+		}
+
+		/*
+		 * Set the 'freeze counters' bit.
+		 * The barrier is to make sure the mtspr has been
+		 * executed and the PMU has frozen the counters
+		 * before we return.
+		 */
+		mtspr(SPRN_MMCR0, mfspr(SPRN_MMCR0) | MMCR0_FC);
+		mb();
+	}
+	local_irq_restore(flags);
+	return ret;
+}
+
+/*
+ * Re-enable all counters if disable == 0.
+ * If we were previously disabled and counters were added, then
+ * put the new config on the PMU.
+ */
+void hw_perf_restore(u64 disable)
+{
+	struct perf_counter *counter;
+	struct cpu_hw_counters *cpuhw;
+	unsigned long flags;
+	long i;
+	unsigned long val;
+	s64 left;
+	unsigned int hwc_index[MAX_HWCOUNTERS];
+
+	if (disable)
+		return;
+	local_irq_save(flags);
+	cpuhw = &__get_cpu_var(cpu_hw_counters);
+	cpuhw->disabled = 0;
+
+	/*
+	 * If we didn't change anything, or only removed counters,
+	 * no need to recalculate MMCR* settings and reset the PMCs.
+	 * Just reenable the PMU with the current MMCR* settings
+	 * (possibly updated for removal of counters).
+	 */
+	if (!cpuhw->n_added) {
+		mtspr(SPRN_MMCRA, cpuhw->mmcr[2]);
+		mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
+		mtspr(SPRN_MMCR0, cpuhw->mmcr[0]);
+		if (cpuhw->n_counters == 0)
+			get_lppaca()->pmcregs_in_use = 0;
+		goto out;
+	}
+
+	/*
+	 * Compute MMCR* values for the new set of counters
+	 */
+	if (ppmu->compute_mmcr(cpuhw->events, cpuhw->n_counters, hwc_index,
+			       cpuhw->mmcr)) {
+		/* shouldn't ever get here */
+		printk(KERN_ERR "oops compute_mmcr failed\n");
+		goto out;
+	}
+
+	/*
+	 * Write the new configuration to MMCR* with the freeze
+	 * bit set and set the hardware counters to their initial values.
+	 * Then unfreeze the counters.
+	 */
+	get_lppaca()->pmcregs_in_use = 1;
+	mtspr(SPRN_MMCRA, cpuhw->mmcr[2]);
+	mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
+	mtspr(SPRN_MMCR0, (cpuhw->mmcr[0] & ~(MMCR0_PMC1CE | MMCR0_PMCjCE))
+				| MMCR0_FC);
+
+	/*
+	 * Read off any pre-existing counters that need to move
+	 * to another PMC.
+	 */
+	for (i = 0; i < cpuhw->n_counters; ++i) {
+		counter = cpuhw->counter[i];
+		if (counter->hw.idx && counter->hw.idx != hwc_index[i] + 1) {
+			power_perf_read(counter);
+			write_pmc(counter->hw.idx, 0);
+			counter->hw.idx = 0;
+		}
+	}
+
+	/*
+	 * Initialize the PMCs for all the new and moved counters.
+	 */
+	for (i = 0; i < cpuhw->n_counters; ++i) {
+		counter = cpuhw->counter[i];
+		if (counter->hw.idx)
+			continue;
+		val = 0;
+		if (counter->hw_event.irq_period) {
+			left = atomic64_read(&counter->hw.period_left);
+			if (left < 0x80000000L)
+				val = 0x80000000L - left;
+		}
+		atomic64_set(&counter->hw.prev_count, val);
+		counter->hw.idx = hwc_index[i] + 1;
+		write_pmc(counter->hw.idx, val);
+	}
+	mb();
+	cpuhw->mmcr[0] |= MMCR0_PMXE | MMCR0_FCECE;
+	mtspr(SPRN_MMCR0, cpuhw->mmcr[0]);
+
+ out:
+	local_irq_restore(flags);
+}
+
+static int collect_events(struct perf_counter *group, int max_count,
+			  struct perf_counter *ctrs[], unsigned int *events)
+{
+	int n = 0;
+	struct perf_counter *counter;
+
+	if (!is_software_counter(group)) {
+		if (n >= max_count)
+			return -1;
+		ctrs[n] = group;
+		events[n++] = group->hw.config;
+	}
+	list_for_each_entry(counter, &group->sibling_list, list_entry) {
+		if (!is_software_counter(counter) &&
+		    counter->state != PERF_COUNTER_STATE_OFF) {
+			if (n >= max_count)
+				return -1;
+			ctrs[n] = counter;
+			events[n++] = counter->hw.config;
+		}
+	}
+	return n;
+}
+
+static void counter_sched_in(struct perf_counter *counter, int cpu)
+{
+	counter->state = PERF_COUNTER_STATE_ACTIVE;
+	counter->oncpu = cpu;
+	if (is_software_counter(counter))
+		counter->hw_ops->enable(counter);
+}
+
+/*
+ * Called to enable a whole group of counters.
+ * Returns 1 if the group was enabled, or -EAGAIN if it could not be.
+ * Assumes the caller has disabled interrupts and has
+ * frozen the PMU with hw_perf_save_disable.
+ */
+int hw_perf_group_sched_in(struct perf_counter *group_leader,
+	       struct perf_cpu_context *cpuctx,
+	       struct perf_counter_context *ctx, int cpu)
+{
+	struct cpu_hw_counters *cpuhw;
+	long i, n, n0;
+	struct perf_counter *sub;
+
+	cpuhw = &__get_cpu_var(cpu_hw_counters);
+	n0 = cpuhw->n_counters;
+	n = collect_events(group_leader, ppmu->n_counter - n0,
+			   &cpuhw->counter[n0], &cpuhw->events[n0]);
+	if (n < 0)
+		return -EAGAIN;
+	if (power_check_constraints(cpuhw->events, n + n0))
+		return -EAGAIN;
+	cpuhw->n_counters = n0 + n;
+	cpuhw->n_added += n;
+
+	/*
+	 * OK, this group can go on; update counter states etc.,
+	 * and enable any software counters
+	 */
+	for (i = n0; i < n0 + n; ++i)
+		cpuhw->counter[i]->hw.config = cpuhw->events[i];
+	cpuctx->active_oncpu += n;
+	n = 1;
+	counter_sched_in(group_leader, cpu);
+	list_for_each_entry(sub, &group_leader->sibling_list, list_entry) {
+		if (sub->state != PERF_COUNTER_STATE_OFF) {
+			counter_sched_in(sub, cpu);
+			++n;
+		}
+	}
+	ctx->nr_active += n;
+
+	return 1;
+}
+
+/*
+ * Add a counter to the PMU.
+ * If all counters are not already frozen, then we disable and
+ * re-enable the PMU in order to get hw_perf_restore to do the
+ * actual work of reconfiguring the PMU.
+ */
+static int power_perf_enable(struct perf_counter *counter)
+{
+	struct cpu_hw_counters *cpuhw;
+	unsigned long flags;
+	u64 pmudis;
+	int n0;
+	int ret = -EAGAIN;
+
+	local_irq_save(flags);
+	pmudis = hw_perf_save_disable();
+
+	/*
+	 * Add the counter to the list (if there is room)
+	 * and check whether the total set is still feasible.
+	 */
+	cpuhw = &__get_cpu_var(cpu_hw_counters);
+	n0 = cpuhw->n_counters;
+	if (n0 >= ppmu->n_counter)
+		goto out;
+	cpuhw->counter[n0] = counter;
+	cpuhw->events[n0] = counter->hw.config;
+	if (power_check_constraints(cpuhw->events, n0 + 1))
+		goto out;
+
+	counter->hw.config = cpuhw->events[n0];
+	++cpuhw->n_counters;
+	++cpuhw->n_added;
+
+	ret = 0;
+ out:
+	hw_perf_restore(pmudis);
+	local_irq_restore(flags);
+	return ret;
+}
+
+/*
+ * Remove a counter from the PMU.
+ */
+static void power_perf_disable(struct perf_counter *counter)
+{
+	struct cpu_hw_counters *cpuhw;
+	long i;
+	u64 pmudis;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	pmudis = hw_perf_save_disable();
+
+	power_perf_read(counter);
+
+	cpuhw = &__get_cpu_var(cpu_hw_counters);
+	for (i = 0; i < cpuhw->n_counters; ++i) {
+		if (counter == cpuhw->counter[i]) {
+			while (++i < cpuhw->n_counters)
+				cpuhw->counter[i-1] = cpuhw->counter[i];
+			--cpuhw->n_counters;
+			ppmu->disable_pmc(counter->hw.idx - 1, cpuhw->mmcr);
+			write_pmc(counter->hw.idx, 0);
+			counter->hw.idx = 0;
+			break;
+		}
+	}
+	if (cpuhw->n_counters == 0) {
+		/* disable exceptions if no counters are running */
+		cpuhw->mmcr[0] &= ~(MMCR0_PMXE | MMCR0_FCECE);
+	}
+
+	hw_perf_restore(pmudis);
+	local_irq_restore(flags);
+}
+
+struct hw_perf_counter_ops power_perf_ops = {
+	.enable = power_perf_enable,
+	.disable = power_perf_disable,
+	.read = power_perf_read
+};
+
+const struct hw_perf_counter_ops *
+hw_perf_counter_init(struct perf_counter *counter)
+{
+	unsigned long ev;
+	struct perf_counter *ctrs[MAX_HWCOUNTERS];
+	unsigned int events[MAX_HWCOUNTERS];
+	int n;
+
+	if (!ppmu)
+		return NULL;
+	if ((s64)counter->hw_event.irq_period < 0)
+		return NULL;
+	ev = counter->hw_event.type;
+	if (!counter->hw_event.raw) {
+		if (ev >= ppmu->n_generic ||
+		    ppmu->generic_events[ev] == 0)
+			return NULL;
+		ev = ppmu->generic_events[ev];
+	}
+	counter->hw.config_base = ev;
+	counter->hw.idx = 0;
+
+	/*
+	 * If this is in a group, check if it can go on with all the
+	 * other hardware counters in the group.  We assume the counter
+	 * hasn't been linked into its leader's sibling list at this point.
+	 */
+	n = 0;
+	if (counter->group_leader != counter) {
+		n = collect_events(counter->group_leader, ppmu->n_counter - 1,
+				   ctrs, events);
+		if (n < 0)
+			return NULL;
+	}
+	events[n++] = ev;
+	if (power_check_constraints(events, n))
+		return NULL;
+
+	counter->hw.config = events[n - 1];
+	atomic64_set(&counter->hw.period_left, counter->hw_event.irq_period);
+	return &power_perf_ops;
+}
+
+/*
+ * Handle wakeups.
+ */
+void perf_counter_do_pending(void)
+{
+	int i;
+	struct cpu_hw_counters *cpuhw = &__get_cpu_var(cpu_hw_counters);
+	struct perf_counter *counter;
+
+	set_perf_counter_pending(0);
+	for (i = 0; i < cpuhw->n_counters; ++i) {
+		counter = cpuhw->counter[i];
+		if (counter && counter->wakeup_pending) {
+			counter->wakeup_pending = 0;
+			wake_up(&counter->waitq);
+		}
+	}
+}
+
+/*
+ * Record data for an irq counter.
+ * This function was lifted from the x86 code; maybe it should
+ * go in the core?
+ */
+static void perf_store_irq_data(struct perf_counter *counter, u64 data)
+{
+	struct perf_data *irqdata = counter->irqdata;
+
+	if (irqdata->len > PERF_DATA_BUFLEN - sizeof(u64)) {
+		irqdata->overrun++;
+	} else {
+		u64 *p = (u64 *) &irqdata->data[irqdata->len];
+
+		*p = data;
+		irqdata->len += sizeof(u64);
+	}
+}
+
+/*
+ * Record all the values of the counters in a group
+ */
+static void perf_handle_group(struct perf_counter *counter)
+{
+	struct perf_counter *leader, *sub;
+
+	leader = counter->group_leader;
+	list_for_each_entry(sub, &leader->sibling_list, list_entry) {
+		if (sub != counter)
+			sub->hw_ops->read(sub);
+		perf_store_irq_data(counter, sub->hw_event.type);
+		perf_store_irq_data(counter, atomic64_read(&sub->count));
+	}
+}
+
+/*
+ * A counter has overflowed; update its count and record
+ * things if requested.  Note that interrupts are hard-disabled
+ * here so there is no possibility of being interrupted.
+ */
+static void record_and_restart(struct perf_counter *counter, long val,
+			       struct pt_regs *regs)
+{
+	s64 prev, delta, left;
+	int record = 0;
+
+	/* we don't have to worry about interrupts here */
+	prev = atomic64_read(&counter->hw.prev_count);
+	delta = (val - prev) & 0xfffffffful;
+	atomic64_add(delta, &counter->count);
+
+	/*
+	 * See if the total period for this counter has expired,
+	 * and update for the next period.
+	 */
+	val = 0;
+	left = atomic64_read(&counter->hw.period_left) - delta;
+	if (counter->hw_event.irq_period) {
+		if (left <= 0) {
+			left += counter->hw_event.irq_period;
+			if (left <= 0)
+				left = counter->hw_event.irq_period;
+			record = 1;
+		}
+		if (left < 0x80000000L)
+			val = 0x80000000L - left;
+	}
+	write_pmc(counter->hw.idx, val);
+	atomic64_set(&counter->hw.prev_count, val);
+	atomic64_set(&counter->hw.period_left, left);
+
+	/*
+	 * Finally record data if requested.
+	 */
+	if (record) {
+		switch (counter->hw_event.record_type) {
+		case PERF_RECORD_SIMPLE:
+			break;
+		case PERF_RECORD_IRQ:
+			perf_store_irq_data(counter, instruction_pointer(regs));
+			counter->wakeup_pending = 1;
+			break;
+		case PERF_RECORD_GROUP:
+			perf_handle_group(counter);
+			counter->wakeup_pending = 1;
+			break;
+		}
+	}
+}
+
+/*
+ * Performance monitor interrupt stuff
+ */
+static void perf_counter_interrupt(struct pt_regs *regs)
+{
+	int i;
+	struct cpu_hw_counters *cpuhw = &__get_cpu_var(cpu_hw_counters);
+	struct perf_counter *counter;
+	long val;
+	int need_wakeup = 0, found = 0;
+
+	for (i = 0; i < cpuhw->n_counters; ++i) {
+		counter = cpuhw->counter[i];
+		val = read_pmc(counter->hw.idx);
+		if ((int)val < 0) {
+			/* counter has overflowed */
+			found = 1;
+			record_and_restart(counter, val, regs);
+			if (counter->wakeup_pending)
+				need_wakeup = 1;
+		}
+	}
+
+	/*
+	 * In case we didn't find and reset the counter that caused
+	 * the interrupt, scan all counters and reset any that are
+	 * negative, to avoid getting continual interrupts.
+	 * Any that we processed in the previous loop will not be negative.
+	 */
+	if (!found) {
+		for (i = 0; i < ppmu->n_counter; ++i) {
+			val = read_pmc(i + 1);
+			if ((int)val < 0)
+				write_pmc(i + 1, 0);
+		}
+	}
+
+	/*
+	 * Reset MMCR0 to its normal value.  This will set PMXE and
+	 * clear FC (freeze counters) and PMAO (perf mon alert occurred)
+	 * and thus allow interrupts to occur again.
+	 * XXX might want to use MSR.PM to keep the counters frozen until
+	 * we get back out of this interrupt.
+	 */
+	mtspr(SPRN_MMCR0, cpuhw->mmcr[0]);
+
+	/*
+	 * If we need a wakeup, check whether interrupts were soft-enabled
+	 * when we took the interrupt.  If they were, we can wake stuff up
+	 * immediately; otherwise we'll have to set a flag and do the
+	 * wakeup when interrupts get soft-enabled.
+	 */
+	if (need_wakeup) {
+		if (regs->softe) {
+			irq_enter();
+			perf_counter_do_pending();
+			irq_exit();
+		} else {
+			set_perf_counter_pending(1);
+		}
+	}
+}
+
+void hw_perf_counter_setup(int cpu)
+{
+	struct cpu_hw_counters *cpuhw = &per_cpu(cpu_hw_counters, cpu);
+
+	memset(cpuhw, 0, sizeof(*cpuhw));
+	cpuhw->mmcr[0] = MMCR0_FC;
+}
+
+extern struct power_pmu ppc970_pmu;
+extern struct power_pmu power6_pmu;
+
+static int init_perf_counters(void)
+{
+	unsigned long pvr;
+
+	if (reserve_pmc_hardware(perf_counter_interrupt)) {
+		printk(KERN_ERR "Couldn't init performance monitor subsystem\n");
+		return -EBUSY;
+	}
+
+	/* XXX should get this from cputable */
+	pvr = mfspr(SPRN_PVR);
+	switch (PVR_VER(pvr)) {
+	case PV_970:
+	case PV_970FX:
+	case PV_970MP:
+		ppmu = &ppc970_pmu;
+		break;
+	case 0x3e:
+		ppmu = &power6_pmu;
+		break;
+	}
+	return 0;
+}
+
+arch_initcall(init_perf_counters);
diff --git a/arch/powerpc/kernel/power6-pmu.c b/arch/powerpc/kernel/power6-pmu.c
new file mode 100644
index 0000000..b1f61f3
--- /dev/null
+++ b/arch/powerpc/kernel/power6-pmu.c
@@ -0,0 +1,283 @@
+/*
+ * Performance counter support for POWER6 processors.
+ *
+ * Copyright 2008-2009 Paul Mackerras, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/perf_counter.h>
+#include <asm/reg.h>
+
+/*
+ * Bits in event code for POWER6
+ */
+#define PM_PMC_SH	20	/* PMC number (1-based) for direct events */
+#define PM_PMC_MSK	0x7
+#define PM_PMC_MSKS	(PM_PMC_MSK << PM_PMC_SH)
+#define PM_UNIT_SH	16	/* Unit event comes (TTMxSEL encoding) */
+#define PM_UNIT_MSK	0xf
+#define PM_UNIT_MSKS	(PM_UNIT_MSK << PM_UNIT_SH)
+#define PM_LLAV		0x8000	/* Load lookahead match value */
+#define PM_LLA		0x4000	/* Load lookahead match enable */
+#define PM_BYTE_SH	12	/* Byte of event bus to use */
+#define PM_BYTE_MSK	3
+#define PM_SUBUNIT_SH	8	/* Subunit event comes from (NEST_SEL enc.) */
+#define PM_SUBUNIT_MSK	7
+#define PM_SUBUNIT_MSKS	(PM_SUBUNIT_MSK << PM_SUBUNIT_SH)
+#define PM_PMCSEL_MSK	0xff	/* PMCxSEL value */
+#define PM_BUSEVENT_MSK	0xf3700
+
+/*
+ * Bits in MMCR1 for POWER6
+ */
+#define MMCR1_TTM0SEL_SH	60
+#define MMCR1_TTMSEL_SH(n)	(MMCR1_TTM0SEL_SH - (n) * 4)
+#define MMCR1_TTMSEL_MSK	0xf
+#define MMCR1_TTMSEL(m, n)	(((m) >> MMCR1_TTMSEL_SH(n)) & MMCR1_TTMSEL_MSK)
+#define MMCR1_NESTSEL_SH	45
+#define MMCR1_NESTSEL_MSK	0x7
+#define MMCR1_NESTSEL(m)	(((m) >> MMCR1_NESTSEL_SH) & MMCR1_NESTSEL_MSK)
+#define MMCR1_PMC1_LLA		((u64)1 << 44)
+#define MMCR1_PMC1_LLA_VALUE	((u64)1 << 39)
+#define MMCR1_PMC1_ADDR_SEL	((u64)1 << 35)
+#define MMCR1_PMC1SEL_SH	24
+#define MMCR1_PMCSEL_SH(n)	(MMCR1_PMC1SEL_SH - (n) * 8)
+#define MMCR1_PMCSEL_MSK	0xff
+
+/*
+ * Assign PMC numbers and compute MMCR1 value for a set of events
+ */
+static int p6_compute_mmcr(unsigned int event[], int n_ev,
+			   unsigned int hwc[], u64 mmcr[])
+{
+	u64 mmcr1 = 0;
+	int i;
+	unsigned int pmc, ev, b, u, s, psel;
+	unsigned int ttmset = 0;
+	unsigned int pmc_inuse = 0;
+
+	if (n_ev > 4)
+		return -1;
+	for (i = 0; i < n_ev; ++i) {
+		pmc = (event[i] >> PM_PMC_SH) & PM_PMC_MSK;
+		if (pmc) {
+			if (pmc_inuse & (1 << (pmc - 1)))
+				return -1;	/* collision! */
+			pmc_inuse |= 1 << (pmc - 1);
+		}
+	}
+	for (i = 0; i < n_ev; ++i) {
+		ev = event[i];
+		pmc = (ev >> PM_PMC_SH) & PM_PMC_MSK;
+		if (pmc) {
+			--pmc;
+		} else {
+			/* can go on any PMC; find a free one */
+			for (pmc = 0; pmc < 4; ++pmc)
+				if (!(pmc_inuse & (1 << pmc)))
+					break;
+			pmc_inuse |= 1 << pmc;
+		}
+		hwc[i] = pmc;
+		psel = ev & PM_PMCSEL_MSK;
+		if (ev & PM_BUSEVENT_MSK) {
+			/* this event uses the event bus */
+			b = (ev >> PM_BYTE_SH) & PM_BYTE_MSK;
+			u = (ev >> PM_UNIT_SH) & PM_UNIT_MSK;
+			/* check for conflict on this byte of event bus */
+			if ((ttmset & (1 << b)) && MMCR1_TTMSEL(mmcr1, b) != u)
+				return -1;
+			mmcr1 |= (u64)u << MMCR1_TTMSEL_SH(b);
+			ttmset |= 1 << b;
+			if (u == 5) {
+				/* Nest events have a further mux */
+				s = (ev >> PM_SUBUNIT_SH) & PM_SUBUNIT_MSK;
+				if ((ttmset & 0x10) &&
+				    MMCR1_NESTSEL(mmcr1) != s)
+					return -1;
+				ttmset |= 0x10;
+				mmcr1 |= (u64)s << MMCR1_NESTSEL_SH;
+			}
+			if (0x30 <= psel && psel <= 0x3d) {
+				/* these need the PMCx_ADDR_SEL bits */
+				if (b >= 2)
+					mmcr1 |= MMCR1_PMC1_ADDR_SEL >> pmc;
+			}
+			/* bus select values are different for PMC3/4 */
+			if (pmc >= 2 && (psel & 0x90) == 0x80)
+				psel ^= 0x20;
+		}
+		if (ev & PM_LLA) {
+			mmcr1 |= MMCR1_PMC1_LLA >> pmc;
+			if (ev & PM_LLAV)
+				mmcr1 |= MMCR1_PMC1_LLA_VALUE >> pmc;
+		}
+		mmcr1 |= (u64)psel << MMCR1_PMCSEL_SH(pmc);
+	}
+	mmcr[0] = 0;
+	if (pmc_inuse & 1)
+		mmcr[0] = MMCR0_PMC1CE;
+	if (pmc_inuse & 0xe)
+		mmcr[0] |= MMCR0_PMCjCE;
+	mmcr[1] = mmcr1;
+	mmcr[2] = 0;
+	return 0;
+}
+
+/*
+ * Layout of constraint bits:
+ *
+ *	0-1	add field: number of uses of PMC1 (max 1)
+ *	2-3, 4-5, 6-7: ditto for PMC2, 3, 4
+ *	8-10	select field: nest (subunit) event selector
+ *	16-19	select field: unit on byte 0 of event bus
+ *	20-23, 24-27, 28-31 ditto for bytes 1, 2, 3
+ */
+static int p6_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
+{
+	int pmc, byte, sh;
+	unsigned int mask = 0, value = 0;
+
+	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+	if (pmc) {
+		if (pmc > 4)
+			return -1;
+		sh = (pmc - 1) * 2;
+		mask |= 2 << sh;
+		value |= 1 << sh;
+	}
+	if (event & PM_BUSEVENT_MSK) {
+		byte = (event >> PM_BYTE_SH) & PM_BYTE_MSK;
+		sh = byte * 4;
+		mask |= PM_UNIT_MSKS << sh;
+		value |= (event & PM_UNIT_MSKS) << sh;
+		if ((event & PM_UNIT_MSKS) == (5 << PM_UNIT_SH)) {
+			mask |= PM_SUBUNIT_MSKS;
+			value |= event & PM_SUBUNIT_MSKS;
+		}
+	}
+	*maskp = mask;
+	*valp = value;
+	return 0;
+}
+
+#define MAX_ALT	4	/* at most 4 alternatives for any event */
+
+static const unsigned int event_alternatives[][MAX_ALT] = {
+	{ 0x0130e8, 0x2000f6, 0x3000fc },	/* PM_PTEG_RELOAD_VALID */
+	{ 0x080080, 0x10000d, 0x30000c, 0x4000f0 }, /* PM_LD_MISS_L1 */
+	{ 0x080088, 0x200054, 0x3000f0 },	/* PM_ST_MISS_L1 */
+	{ 0x10000a, 0x2000f4 },			/* PM_RUN_CYC */
+	{ 0x10000b, 0x2000f5 },			/* PM_RUN_COUNT */
+	{ 0x10000e, 0x400010 },			/* PM_PURR */
+	{ 0x100010, 0x4000f8 },			/* PM_FLUSH */
+	{ 0x10001a, 0x200010 },			/* PM_MRK_INST_DISP */
+	{ 0x100026, 0x3000f8 },			/* PM_TB_BIT_TRANS */
+	{ 0x100054, 0x2000f0 },			/* PM_ST_FIN */
+	{ 0x100056, 0x2000fc },			/* PM_L1_ICACHE_MISS */
+	{ 0x1000f0, 0x40000a },			/* PM_INST_IMC_MATCH_CMPL */
+	{ 0x1000f8, 0x200008 },			/* PM_GCT_EMPTY_CYC */
+	{ 0x1000fc, 0x400006 },			/* PM_LSU_DERAT_MISS_CYC */
+	{ 0x20000e, 0x400007 },			/* PM_LSU_DERAT_MISS */
+	{ 0x200012, 0x300012 },			/* PM_INST_DISP */
+	{ 0x2000f2, 0x3000f2 },			/* PM_INST_DISP */
+	{ 0x2000f8, 0x300010 },			/* PM_EXT_INT */
+	{ 0x2000fe, 0x300056 },			/* PM_DATA_FROM_L2MISS */
+	{ 0x2d0030, 0x30001a },			/* PM_MRK_FPU_FIN */
+	{ 0x30000a, 0x400018 },			/* PM_MRK_INST_FIN */
+	{ 0x3000f6, 0x40000e },			/* PM_L1_DCACHE_RELOAD_VALID */
+	{ 0x3000fe, 0x400056 },			/* PM_DATA_FROM_L3MISS */
+};
+
+/*
+ * This could be made more efficient with a binary search on
+ * a presorted list, if necessary
+ */
+static int find_alternatives_list(unsigned int event)
+{
+	int i, j;
+	unsigned int alt;
+
+	for (i = 0; i < ARRAY_SIZE(event_alternatives); ++i) {
+		if (event < event_alternatives[i][0])
+			return -1;
+		for (j = 0; j < MAX_ALT; ++j) {
+			alt = event_alternatives[i][j];
+			if (!alt || event < alt)
+				break;
+			if (event == alt)
+				return i;
+		}
+	}
+	return -1;
+}
+
+static int p6_get_alternatives(unsigned int event, unsigned int alt[])
+{
+	int i, j;
+	unsigned int aevent, psel, pmc;
+	unsigned int nalt = 1;
+
+	alt[0] = event;
+
+	/* check the alternatives table */
+	i = find_alternatives_list(event);
+	if (i >= 0) {
+		/* copy out alternatives from list */
+		for (j = 0; j < MAX_ALT; ++j) {
+			aevent = event_alternatives[i][j];
+			if (!aevent)
+				break;
+			if (aevent != event)
+				alt[nalt++] = aevent;
+		}
+
+	} else {
+		/* Check for alternative ways of computing sum events */
+		/* PMCSEL 0x32 counter N == PMCSEL 0x34 counter 5-N */
+		psel = event & (PM_PMCSEL_MSK & ~1);	/* ignore edge bit */
+		pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+		if (pmc && (psel == 0x32 || psel == 0x34))
+			alt[nalt++] = ((event ^ 0x6) & ~PM_PMC_MSKS) |
+				((5 - pmc) << PM_PMC_SH);
+
+		/* PMCSEL 0x38 counter N == PMCSEL 0x3a counter N+/-2 */
+		if (pmc && (psel == 0x38 || psel == 0x3a))
+			alt[nalt++] = ((event ^ 0x2) & ~PM_PMC_MSKS) |
+				((pmc > 2? pmc - 2: pmc + 2) << PM_PMC_SH);
+	}
+
+	return nalt;
+}
+
+static void p6_disable_pmc(unsigned int pmc, u64 mmcr[])
+{
+	/* Set PMCxSEL to 0 to disable PMCx */
+	mmcr[1] &= ~(0xffUL << MMCR1_PMCSEL_SH(pmc));
+}
+
+static int power6_generic_events[] = {
+	[PERF_COUNT_CPU_CYCLES] = 0x1e,
+	[PERF_COUNT_INSTRUCTIONS] = 2,
+	[PERF_COUNT_CACHE_REFERENCES] = 0x280030,	/* LD_REF_L1 */
+	[PERF_COUNT_CACHE_MISSES] = 0x30000c,		/* LD_MISS_L1 */
+	[PERF_COUNT_BRANCH_INSTRUCTIONS] = 0x410a0,	/* BR_PRED */ 
+	[PERF_COUNT_BRANCH_MISSES] = 0x400052,		/* BR_MPRED */
+};
+
+struct power_pmu power6_pmu = {
+	.n_counter = 4,
+	.max_alternatives = MAX_ALT,
+	.add_fields = 0x55,
+	.test_adder = 0,
+	.compute_mmcr = p6_compute_mmcr,
+	.get_constraint = p6_get_constraint,
+	.get_alternatives = p6_get_alternatives,
+	.disable_pmc = p6_disable_pmc,
+	.n_generic = ARRAY_SIZE(power6_generic_events),
+	.generic_events = power6_generic_events,
+};
diff --git a/arch/powerpc/kernel/ppc970-pmu.c b/arch/powerpc/kernel/ppc970-pmu.c
new file mode 100644
index 0000000..c325658
--- /dev/null
+++ b/arch/powerpc/kernel/ppc970-pmu.c
@@ -0,0 +1,375 @@
+/*
+ * Performance counter support for PPC970-family processors.
+ *
+ * Copyright 2008-2009 Paul Mackerras, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/string.h>
+#include <linux/perf_counter.h>
+#include <asm/reg.h>
+
+/*
+ * Bits in event code for PPC970
+ */
+#define PM_PMC_SH	12	/* PMC number (1-based) for direct events */
+#define PM_PMC_MSK	0xf
+#define PM_UNIT_SH	8	/* TTMMUX number and setting - unit select */
+#define PM_UNIT_MSK	0xf
+#define PM_BYTE_SH	4	/* Byte number of event bus to use */
+#define PM_BYTE_MSK	3
+#define PM_PMCSEL_MSK	0xf
+
+/* Values in PM_UNIT field */
+#define PM_NONE		0
+#define PM_FPU		1
+#define PM_VPU		2
+#define PM_ISU		3
+#define PM_IFU		4
+#define PM_IDU		5
+#define PM_STS		6
+#define PM_LSU0		7
+#define PM_LSU1U	8
+#define PM_LSU1L	9
+#define PM_LASTUNIT	9
+
+/*
+ * Bits in MMCR0 for PPC970
+ */
+#define MMCR0_PMC1SEL_SH	8
+#define MMCR0_PMC2SEL_SH	1
+#define MMCR_PMCSEL_MSK		0x1f
+
+/*
+ * Bits in MMCR1 for PPC970
+ */
+#define MMCR1_TTM0SEL_SH	62
+#define MMCR1_TTM1SEL_SH	59
+#define MMCR1_TTM3SEL_SH	53
+#define MMCR1_TTMSEL_MSK	3
+#define MMCR1_TD_CP_DBG0SEL_SH	50
+#define MMCR1_TD_CP_DBG1SEL_SH	48
+#define MMCR1_TD_CP_DBG2SEL_SH	46
+#define MMCR1_TD_CP_DBG3SEL_SH	44
+#define MMCR1_PMC1_ADDER_SEL_SH	39
+#define MMCR1_PMC2_ADDER_SEL_SH	38
+#define MMCR1_PMC6_ADDER_SEL_SH	37
+#define MMCR1_PMC5_ADDER_SEL_SH	36
+#define MMCR1_PMC8_ADDER_SEL_SH	35
+#define MMCR1_PMC7_ADDER_SEL_SH	34
+#define MMCR1_PMC3_ADDER_SEL_SH	33
+#define MMCR1_PMC4_ADDER_SEL_SH	32
+#define MMCR1_PMC3SEL_SH	27
+#define MMCR1_PMC4SEL_SH	22
+#define MMCR1_PMC5SEL_SH	17
+#define MMCR1_PMC6SEL_SH	12
+#define MMCR1_PMC7SEL_SH	7
+#define MMCR1_PMC8SEL_SH	2
+
+static short mmcr1_adder_bits[8] = {
+	MMCR1_PMC1_ADDER_SEL_SH,
+	MMCR1_PMC2_ADDER_SEL_SH,
+	MMCR1_PMC3_ADDER_SEL_SH,
+	MMCR1_PMC4_ADDER_SEL_SH,
+	MMCR1_PMC5_ADDER_SEL_SH,
+	MMCR1_PMC6_ADDER_SEL_SH,
+	MMCR1_PMC7_ADDER_SEL_SH,
+	MMCR1_PMC8_ADDER_SEL_SH
+};
+
+/*
+ * Bits in MMCRA
+ */
+
+/*
+ * Layout of constraint bits:
+ * 6666555555555544444444443333333333222222222211111111110000000000
+ * 3210987654321098765432109876543210987654321098765432109876543210
+ *                 <><>[  >[  >[  ><  ><  ><  ><  ><><><><><><><><>
+ *                 T0T1 UC  PS1 PS2 B0  B1  B2  B3 P1P2P3P4P5P6P7P8
+ *
+ * T0 - TTM0 constraint
+ *     46-47: TTM0SEL value (0=FPU, 2=IFU, 3=VPU) 0xC000_0000_0000
+ *
+ * T1 - TTM1 constraint
+ *     44-45: TTM1SEL value (0=IDU, 3=STS) 0x3000_0000_0000
+ *
+ * UC - unit constraint: can't have all three of FPU|IFU|VPU, ISU, IDU|STS
+ *     43: UC3 error 0x0800_0000_0000
+ *     42: FPU|IFU|VPU events needed 0x0400_0000_0000
+ *     41: ISU events needed 0x0200_0000_0000
+ *     40: IDU|STS events needed 0x0100_0000_0000
+ *
+ * PS1
+ *     39: PS1 error 0x0080_0000_0000
+ *     36-38: count of events needing PMC1/2/5/6 0x0070_0000_0000
+ *
+ * PS2
+ *     35: PS2 error 0x0008_0000_0000
+ *     32-34: count of events needing PMC3/4/7/8 0x0007_0000_0000
+ *
+ * B0
+ *     28-31: Byte 0 event source 0xf000_0000
+ *	      Encoding as for the event code
+ *
+ * B1, B2, B3
+ *     24-27, 20-23, 16-19: Byte 1, 2, 3 event sources
+ *
+ * P1
+ *     15: P1 error 0x8000
+ *     14-15: Count of events needing PMC1
+ *
+ * P2..P8
+ *     0-13: Count of events needing PMC2..PMC8
+ */
+
+/* Masks and values for using events from the various units */
+static u64 unit_cons[PM_LASTUNIT+1][2] = {
+	[PM_FPU] =   { 0xc80000000000ull, 0x040000000000ull },
+	[PM_VPU] =   { 0xc80000000000ull, 0xc40000000000ull },
+	[PM_ISU] =   { 0x080000000000ull, 0x020000000000ull },
+	[PM_IFU] =   { 0xc80000000000ull, 0x840000000000ull },
+	[PM_IDU] =   { 0x380000000000ull, 0x010000000000ull },
+	[PM_STS] =   { 0x380000000000ull, 0x310000000000ull },
+};
+
+static int p970_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
+{
+	int pmc, byte, unit, sh;
+	u64 mask = 0, value = 0;
+	int grp = -1;
+
+	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+	if (pmc) {
+		if (pmc > 8)
+			return -1;
+		sh = (pmc - 1) * 2;
+		mask |= 2 << sh;
+		value |= 1 << sh;
+		grp = ((pmc - 1) >> 1) & 1;
+	}
+	unit = (event >> PM_UNIT_SH) & PM_UNIT_MSK;
+	if (unit) {
+		if (unit > PM_LASTUNIT)
+			return -1;
+		mask |= unit_cons[unit][0];
+		value |= unit_cons[unit][1];
+		byte = (event >> PM_BYTE_SH) & PM_BYTE_MSK;
+		/*
+		 * Bus events on bytes 0 and 2 can be counted
+		 * on PMC1/2/5/6; bytes 1 and 3 on PMC3/4/7/8.
+		 */
+		if (!pmc)
+			grp = byte & 1;
+		/* Set byte lane select field */
+		mask  |= 0xfULL << (28 - 4 * byte);
+		value |= (u64)unit << (28 - 4 * byte);
+	}
+	if (grp == 0) {
+		/* increment PMC1/2/5/6 field */
+		mask  |= 0x8000000000ull;
+		value |= 0x1000000000ull;
+	} else if (grp == 1) {
+		/* increment PMC3/4/7/8 field */
+		mask  |= 0x800000000ull;
+		value |= 0x100000000ull;
+	}
+	*maskp = mask;
+	*valp = value;
+	return 0;
+}
+
+static int p970_get_alternatives(unsigned int event, unsigned int alt[])
+{
+	alt[0] = event;
+
+	/* 2 alternatives for LSU empty */
+	if (event == 0x2002 || event == 0x3002) {
+		alt[1] = event ^ 0x1000;
+		return 2;
+	}
+		
+	return 1;
+}
+
+static int p970_compute_mmcr(unsigned int event[], int n_ev,
+			     unsigned int hwc[], u64 mmcr[])
+{
+	u64 mmcr0 = 0, mmcr1 = 0, mmcra = 0;
+	unsigned int pmc, unit, byte, psel;
+	unsigned int ttm, grp;
+	unsigned int pmc_inuse = 0;
+	unsigned int pmc_grp_use[2];
+	unsigned char busbyte[4];
+	unsigned char unituse[16];
+	unsigned char unitmap[] = { 0, 0<<3, 3<<3, 1<<3, 2<<3, 0|4, 3|4 };
+	unsigned char ttmuse[2];
+	unsigned char pmcsel[8];
+	int i;
+
+	if (n_ev > 8)
+		return -1;
+
+	/* First pass to count resource use */
+	pmc_grp_use[0] = pmc_grp_use[1] = 0;
+	memset(busbyte, 0, sizeof(busbyte));
+	memset(unituse, 0, sizeof(unituse));
+	for (i = 0; i < n_ev; ++i) {
+		pmc = (event[i] >> PM_PMC_SH) & PM_PMC_MSK;
+		if (pmc) {
+			if (pmc_inuse & (1 << (pmc - 1)))
+				return -1;
+			pmc_inuse |= 1 << (pmc - 1);
+			/* count 1/2/5/6 vs 3/4/7/8 use */
+			++pmc_grp_use[((pmc - 1) >> 1) & 1];
+		}
+		unit = (event[i] >> PM_UNIT_SH) & PM_UNIT_MSK;
+		byte = (event[i] >> PM_BYTE_SH) & PM_BYTE_MSK;
+		if (unit) {
+			if (unit > PM_LASTUNIT)
+				return -1;
+			if (!pmc)
+				++pmc_grp_use[byte & 1];
+			if (busbyte[byte] && busbyte[byte] != unit)
+				return -1;
+			busbyte[byte] = unit;
+			unituse[unit] = 1;
+		}
+	}
+	if (pmc_grp_use[0] > 4 || pmc_grp_use[1] > 4)
+		return -1;
+
+	/*
+	 * Assign resources and set multiplexer selects.
+	 *
+	 * PM_ISU can go either on TTM0 or TTM1, but that's the only
+	 * choice we have to deal with.
+	 */
+	if (unituse[PM_ISU] &
+	    (unituse[PM_FPU] | unituse[PM_IFU] | unituse[PM_VPU]))
+		unitmap[PM_ISU] = 2 | 4;	/* move ISU to TTM1 */
+	/* Set TTM[01]SEL fields. */
+	ttmuse[0] = ttmuse[1] = 0;
+	for (i = PM_FPU; i <= PM_STS; ++i) {
+		if (!unituse[i])
+			continue;
+		ttm = unitmap[i];
+		++ttmuse[(ttm >> 2) & 1];
+		mmcr1 |= (u64)(ttm & ~4) << MMCR1_TTM1SEL_SH;
+	}
+	/* Check only one unit per TTMx */
+	if (ttmuse[0] > 1 || ttmuse[1] > 1)
+		return -1;
+
+	/* Set byte lane select fields and TTM3SEL. */
+	for (byte = 0; byte < 4; ++byte) {
+		unit = busbyte[byte];
+		if (!unit)
+			continue;
+		if (unit <= PM_STS)
+			ttm = (unitmap[unit] >> 2) & 1;
+		else if (unit == PM_LSU0)
+			ttm = 2;
+		else {
+			ttm = 3;
+			if (unit == PM_LSU1L && byte >= 2)
+				mmcr1 |= 1ull << (MMCR1_TTM3SEL_SH + 3 - byte);
+		}
+		mmcr1 |= (u64)ttm << (MMCR1_TD_CP_DBG0SEL_SH - 2 * byte);
+	}
+
+	/* Second pass: assign PMCs, set PMCxSEL and PMCx_ADDER_SEL fields */
+	memset(pmcsel, 0x8, sizeof(pmcsel));	/* 8 means don't count */
+	for (i = 0; i < n_ev; ++i) {
+		pmc = (event[i] >> PM_PMC_SH) & PM_PMC_MSK;
+		unit = (event[i] >> PM_UNIT_SH) & PM_UNIT_MSK;
+		byte = (event[i] >> PM_BYTE_SH) & PM_BYTE_MSK;
+		psel = event[i] & PM_PMCSEL_MSK;
+		if (!pmc) {
+			/* Bus event or any-PMC direct event */
+			if (unit)
+				psel |= 0x10 | ((byte & 2) << 2);
+			else
+				psel |= 8;
+			for (pmc = 0; pmc < 8; ++pmc) {
+				if (pmc_inuse & (1 << pmc))
+					continue;
+				grp = (pmc >> 1) & 1;
+				if (unit) {
+					if (grp == (byte & 1))
+						break;
+				} else if (pmc_grp_use[grp] < 4) {
+					++pmc_grp_use[grp];
+					break;
+				}
+			}
+			pmc_inuse |= 1 << pmc;
+		} else {
+			/* Direct event */
+			--pmc;
+			if (psel == 0 && (byte & 2))
+				/* add events on higher-numbered bus */
+				mmcr1 |= 1ull << mmcr1_adder_bits[pmc];
+		}
+		pmcsel[pmc] = psel;
+		hwc[i] = pmc;
+	}
+	for (pmc = 0; pmc < 2; ++pmc)
+		mmcr0 |= pmcsel[pmc] << (MMCR0_PMC1SEL_SH - 7 * pmc);
+	for (; pmc < 8; ++pmc)
+		mmcr1 |= (u64)pmcsel[pmc] << (MMCR1_PMC3SEL_SH - 5 * (pmc - 2));
+	if (pmc_inuse & 1)
+		mmcr0 |= MMCR0_PMC1CE;
+	if (pmc_inuse & 0xfe)
+		mmcr0 |= MMCR0_PMCjCE;
+
+	mmcra |= 0x2000;	/* mark only one IOP per PPC instruction */
+
+	/* Return MMCRx values */
+	mmcr[0] = mmcr0;
+	mmcr[1] = mmcr1;
+	mmcr[2] = mmcra;
+	return 0;
+}
+
+static void p970_disable_pmc(unsigned int pmc, u64 mmcr[])
+{
+	int shift, i;
+
+	if (pmc <= 1) {
+		shift = MMCR0_PMC1SEL_SH - 7 * pmc;
+		i = 0;
+	} else {
+		shift = MMCR1_PMC3SEL_SH - 5 * (pmc - 2);
+		i = 1;
+	}
+	/*
+	 * Setting the PMCxSEL field to 0x08 disables PMC x.
+	 */
+	mmcr[i] = (mmcr[i] & ~(0x1fUL << shift)) | (0x08UL << shift);
+}
+
+static int ppc970_generic_events[] = {
+	[PERF_COUNT_CPU_CYCLES] = 7,
+	[PERF_COUNT_INSTRUCTIONS] = 1,
+	[PERF_COUNT_CACHE_REFERENCES] = 0x8810,		/* PM_LD_REF_L1 */
+	[PERF_COUNT_CACHE_MISSES] = 0x3810,		/* PM_LD_MISS_L1 */
+	[PERF_COUNT_BRANCH_INSTRUCTIONS] = 0x431,	/* PM_BR_ISSUED */
+	[PERF_COUNT_BRANCH_MISSES] = 0x327,		/* PM_GRP_BR_MPRED */
+};
+
+struct power_pmu ppc970_pmu = {
+	.n_counter = 8,
+	.max_alternatives = 2,
+	.add_fields = 0x001100005555ull,
+	.test_adder = 0x013300000000ull,
+	.compute_mmcr = p970_compute_mmcr,
+	.get_constraint = p970_get_constraint,
+	.get_alternatives = p970_get_alternatives,
+	.disable_pmc = p970_disable_pmc,
+	.n_generic = ARRAY_SIZE(ppc970_generic_events),
+	.generic_events = ppc970_generic_events,
+};
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 161b9b9..295ccc5 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -184,6 +184,7 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
 		__per_cpu_start = .;
+		*(.data.percpu.page_aligned)
 		*(.data.percpu)
 		*(.data.percpu.shared_aligned)
 		__per_cpu_end = .;
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index e868b5c..dc0f3c9 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -1,6 +1,7 @@
 config PPC64
 	bool "64-bit kernel"
 	default n
+	select HAVE_PERF_COUNTERS
 	help
 	  This option selects whether a 32-bit or a 64-bit kernel
 	  will be built.
diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
index 84e058f..80b5134 100644
--- a/arch/powerpc/platforms/pseries/xics.c
+++ b/arch/powerpc/platforms/pseries/xics.c
@@ -153,9 +153,10 @@ static int get_irq_server(unsigned int virq, unsigned int strict_check)
 {
 	int server;
 	/* For the moment only implement delivery to all cpus or one cpu */
-	cpumask_t cpumask = irq_desc[virq].affinity;
+	cpumask_t cpumask;
 	cpumask_t tmp = CPU_MASK_NONE;
 
+	cpumask_copy(&cpumask, irq_desc[virq].affinity);
 	if (!distribute_irqs)
 		return default_server;
 
@@ -869,7 +870,7 @@ void xics_migrate_irqs_away(void)
 		       virq, cpu);
 
 		/* Reset affinity to all cpus */
-		irq_desc[virq].affinity = CPU_MASK_ALL;
+		cpumask_setall(irq_desc[virq].affinity);
 		desc->chip->set_affinity(virq, cpu_all_mask);
 unlock:
 		spin_unlock_irqrestore(&desc->lock, flags);
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index a35297d..532e205 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -566,9 +566,10 @@ static void __init mpic_scan_ht_pics(struct mpic *mpic)
 #ifdef CONFIG_SMP
 static int irq_choose_cpu(unsigned int virt_irq)
 {
-	cpumask_t mask = irq_desc[virt_irq].affinity;
+	cpumask_t mask;
 	int cpuid;
 
+	cpumask_copy(&mask, irq_desc[virt_irq].affinity);
 	if (cpus_equal(mask, CPU_MASK_ALL)) {
 		static int irq_rover;
 		static DEFINE_SPINLOCK(irq_rover_lock);
diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index cab8e02..4ac5c65 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -247,9 +247,10 @@ struct irq_handler_data {
 #ifdef CONFIG_SMP
 static int irq_choose_cpu(unsigned int virt_irq)
 {
-	cpumask_t mask = irq_desc[virt_irq].affinity;
+	cpumask_t mask;
 	int cpuid;
 
+	cpumask_copy(&mask, irq_desc[virt_irq].affinity);
 	if (cpus_equal(mask, CPU_MASK_ALL)) {
 		static int irq_rover;
 		static DEFINE_SPINLOCK(irq_rover_lock);
@@ -854,7 +855,7 @@ void fixup_irqs(void)
 		    !(irq_desc[irq].status & IRQ_PER_CPU)) {
 			if (irq_desc[irq].chip->set_affinity)
 				irq_desc[irq].chip->set_affinity(irq,
-					&irq_desc[irq].affinity);
+					irq_desc[irq].affinity);
 		}
 		spin_unlock_irqrestore(&irq_desc[irq].lock, flags);
 	}
diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index 2db3c22..db310aa 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -729,7 +729,7 @@ void timer_interrupt(int irq, struct pt_regs *regs)
 
 	irq_enter();
 
-	kstat_this_cpu.irqs[0]++;
+	kstat_incr_irqs_this_cpu(0, irq_to_desc(0));
 
 	if (unlikely(!evt->event_handler)) {
 		printk(KERN_WARNING
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 73f7fe8..1f48445 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -685,6 +685,7 @@ config X86_UP_IOAPIC
 config X86_LOCAL_APIC
 	def_bool y
 	depends on X86_64 || (X86_32 && (X86_UP_APIC || (SMP && !X86_VOYAGER) || X86_GENERICARCH))
+	select HAVE_PERF_COUNTERS if (!M386 && !M486)
 
 config X86_IO_APIC
 	def_bool y
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 256b00b..01e7c4c 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -112,8 +112,8 @@ ENTRY(ia32_sysenter_target)
 	CFI_DEF_CFA	rsp,0
 	CFI_REGISTER	rsp,rbp
 	SWAPGS_UNSAFE_STACK
-	movq	%gs:pda_kernelstack, %rsp
-	addq	$(PDA_STACKOFFSET),%rsp	
+	movq	PER_CPU_VAR(kernel_stack), %rsp
+	addq	$(KERNEL_STACK_OFFSET),%rsp
 	/*
 	 * No need to follow this irqs on/off section: the syscall
 	 * disabled irqs, here we enable it straight after entry:
@@ -273,13 +273,13 @@ ENDPROC(ia32_sysenter_target)
 ENTRY(ia32_cstar_target)
 	CFI_STARTPROC32	simple
 	CFI_SIGNAL_FRAME
-	CFI_DEF_CFA	rsp,PDA_STACKOFFSET
+	CFI_DEF_CFA	rsp,KERNEL_STACK_OFFSET
 	CFI_REGISTER	rip,rcx
 	/*CFI_REGISTER	rflags,r11*/
 	SWAPGS_UNSAFE_STACK
 	movl	%esp,%r8d
 	CFI_REGISTER	rsp,r8
-	movq	%gs:pda_kernelstack,%rsp
+	movq	PER_CPU_VAR(kernel_stack),%rsp
 	/*
 	 * No need to follow this irqs on/off section: the syscall
 	 * disabled irqs and here we enable it straight after entry:
@@ -823,7 +823,8 @@ ia32_sys_call_table:
 	.quad compat_sys_signalfd4
 	.quad sys_eventfd2
 	.quad sys_epoll_create1
-	.quad sys_dup3			/* 330 */
+	.quad sys_dup3				/* 330 */
 	.quad sys_pipe2
 	.quad sys_inotify_init1
+	.quad sys_perf_counter_open
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/apicnum.h b/arch/x86/include/asm/apicnum.h
new file mode 100644
index 0000000..82f613c
--- /dev/null
+++ b/arch/x86/include/asm/apicnum.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_X86_APICNUM_H
+#define _ASM_X86_APICNUM_H
+
+/* define MAX_IO_APICS */
+#ifdef CONFIG_X86_32
+# define MAX_IO_APICS 64
+#else
+# define MAX_IO_APICS 128
+# define MAX_LOCAL_APIC 32768
+#endif
+
+#endif /* _ASM_X86_APICNUM_H */
diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index 85b46fb..977250e 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -247,5 +247,223 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
+/* An 64bit atomic type */
+
+typedef struct {
+	unsigned long long counter;
+} atomic64_t;
+
+#define ATOMIC64_INIT(val)	{ (val) }
+
+/**
+ * atomic64_read - read atomic64 variable
+ * @v: pointer of type atomic64_t
+ *
+ * Atomically reads the value of @v.
+ * Doesn't imply a read memory barrier.
+ */
+#define __atomic64_read(ptr)		((ptr)->counter)
+
+static inline unsigned long long
+cmpxchg8b(unsigned long long *ptr, unsigned long long old, unsigned long long new)
+{
+	asm volatile(
+
+		LOCK_PREFIX "cmpxchg8b (%[ptr])\n"
+
+		     :		"=A" (old)
+
+		     : [ptr]	"D" (ptr),
+				"A" (old),
+				"b" (ll_low(new)),
+				"c" (ll_high(new))
+
+		     : "memory");
+
+	return old;
+}
+
+static inline unsigned long long
+atomic64_cmpxchg(atomic64_t *ptr, unsigned long long old_val,
+		 unsigned long long new_val)
+{
+	return cmpxchg8b(&ptr->counter, old_val, new_val);
+}
+
+/**
+ * atomic64_set - set atomic64 variable
+ * @ptr:      pointer to type atomic64_t
+ * @new_val:  value to assign
+ *
+ * Atomically sets the value of @ptr to @new_val.
+ */
+static inline void atomic64_set(atomic64_t *ptr, unsigned long long new_val)
+{
+	unsigned long long old_val;
+
+	do {
+		old_val = atomic_read(ptr);
+	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
+}
+
+/**
+ * atomic64_read - read atomic64 variable
+ * @ptr:      pointer to type atomic64_t
+ *
+ * Atomically reads the value of @ptr and returns it.
+ */
+static inline unsigned long long atomic64_read(atomic64_t *ptr)
+{
+	unsigned long long curr_val;
+
+	do {
+		curr_val = __atomic64_read(ptr);
+	} while (atomic64_cmpxchg(ptr, curr_val, curr_val) != curr_val);
+
+	return curr_val;
+}
+
+/**
+ * atomic64_add_return - add and return
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr and returns @delta + *@ptr
+ */
+static inline unsigned long long
+atomic64_add_return(unsigned long long delta, atomic64_t *ptr)
+{
+	unsigned long long old_val, new_val;
+
+	do {
+		old_val = atomic_read(ptr);
+		new_val = old_val + delta;
+
+	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
+
+	return new_val;
+}
+
+static inline long atomic64_sub_return(unsigned long long delta, atomic64_t *ptr)
+{
+	return atomic64_add_return(-delta, ptr);
+}
+
+static inline long atomic64_inc_return(atomic64_t *ptr)
+{
+	return atomic64_add_return(1, ptr);
+}
+
+static inline long atomic64_dec_return(atomic64_t *ptr)
+{
+	return atomic64_sub_return(1, ptr);
+}
+
+/**
+ * atomic64_add - add integer to atomic64 variable
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr.
+ */
+static inline void atomic64_add(unsigned long long delta, atomic64_t *ptr)
+{
+	atomic64_add_return(delta, ptr);
+}
+
+/**
+ * atomic64_sub - subtract the atomic64 variable
+ * @delta: integer value to subtract
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically subtracts @delta from @ptr.
+ */
+static inline void atomic64_sub(unsigned long long delta, atomic64_t *ptr)
+{
+	atomic64_add(-delta, ptr);
+}
+
+/**
+ * atomic64_sub_and_test - subtract value from variable and test result
+ * @delta: integer value to subtract
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically subtracts @delta from @ptr and returns
+ * true if the result is zero, or false for all
+ * other cases.
+ */
+static inline int
+atomic64_sub_and_test(unsigned long long delta, atomic64_t *ptr)
+{
+	unsigned long long old_val = atomic64_sub_return(delta, ptr);
+
+	return old_val == 0;
+}
+
+/**
+ * atomic64_inc - increment atomic64 variable
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically increments @ptr by 1.
+ */
+static inline void atomic64_inc(atomic64_t *ptr)
+{
+	atomic64_add(1, ptr);
+}
+
+/**
+ * atomic64_dec - decrement atomic64 variable
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically decrements @ptr by 1.
+ */
+static inline void atomic64_dec(atomic64_t *ptr)
+{
+	atomic64_sub(1, ptr);
+}
+
+/**
+ * atomic64_dec_and_test - decrement and test
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically decrements @ptr by 1 and
+ * returns true if the result is 0, or false for all other
+ * cases.
+ */
+static inline int atomic64_dec_and_test(atomic64_t *ptr)
+{
+	return atomic64_sub_and_test(1, ptr);
+}
+
+/**
+ * atomic64_inc_and_test - increment and test
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically increments @ptr by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+static inline int atomic64_inc_and_test(atomic64_t *ptr)
+{
+	return atomic64_sub_and_test(-1, ptr);
+}
+
+/**
+ * atomic64_add_negative - add and test if negative
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr and returns true
+ * if the result is negative, or false when
+ * result is greater than or equal to zero.
+ */
+static inline int
+atomic64_add_negative(unsigned long long delta, atomic64_t *ptr)
+{
+	long long old_val = atomic64_add_return(delta, ptr);
+
+	return old_val < 0;
+}
+
 #include <asm-generic/atomic.h>
 #endif /* _ASM_X86_ATOMIC_32_H */
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index e02a359..02b47a6 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -3,6 +3,9 @@
 
 /*
  * Copyright 1992, Linus Torvalds.
+ *
+ * Note: inlines with more than a single statement should be marked
+ * __always_inline to avoid problems with older gcc's inlining heuristics.
  */
 
 #ifndef _LINUX_BITOPS_H
@@ -53,7 +56,8 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void set_bit(unsigned int nr, volatile unsigned long *addr)
+static __always_inline void
+set_bit(unsigned int nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "orb %1,%0"
@@ -90,7 +94,8 @@ static inline void __set_bit(int nr, volatile unsigned long *addr)
  * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
  * in order to ensure changes are visible on other processors.
  */
-static inline void clear_bit(int nr, volatile unsigned long *addr)
+static __always_inline void
+clear_bit(int nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "andb %1,%0"
@@ -204,7 +209,8 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
  *
  * This is the same as test_and_set_bit on x86.
  */
-static inline int test_and_set_bit_lock(int nr, volatile unsigned long *addr)
+static __always_inline int
+test_and_set_bit_lock(int nr, volatile unsigned long *addr)
 {
 	return test_and_set_bit(nr, addr);
 }
@@ -300,7 +306,7 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 	return oldbit;
 }
 
-static inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
+static __always_inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
 {
 	return ((1UL << (nr % BITS_PER_LONG)) &
 		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index bae482d..f03b23e 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -7,6 +7,20 @@
 #include <linux/nodemask.h>
 #include <linux/percpu.h>
 
+#ifdef CONFIG_SMP
+
+extern void prefill_possible_map(void);
+
+#else /* CONFIG_SMP */
+
+static inline void prefill_possible_map(void) {}
+
+#define cpu_physical_id(cpu)			boot_cpu_physical_apicid
+#define safe_smp_processor_id()			0
+#define stack_smp_processor_id()		0
+
+#endif /* CONFIG_SMP */
+
 struct x86_cpu {
 	struct cpu cpu;
 };
@@ -17,4 +31,11 @@ extern void arch_unregister_cpu(int);
 #endif
 
 DECLARE_PER_CPU(int, cpu_state);
+
+#ifdef CONFIG_X86_HAS_BOOT_CPU_ID
+extern unsigned char boot_cpu_id;
+#else
+#define boot_cpu_id				0
+#endif
+
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/include/asm/cpumask.h b/arch/x86/include/asm/cpumask.h
new file mode 100644
index 0000000..26c6dad
--- /dev/null
+++ b/arch/x86/include/asm/cpumask.h
@@ -0,0 +1,28 @@
+#ifndef _ASM_X86_CPUMASK_H
+#define _ASM_X86_CPUMASK_H
+#ifndef __ASSEMBLY__
+#include <linux/cpumask.h>
+
+#ifdef CONFIG_X86_64
+
+extern cpumask_var_t cpu_callin_mask;
+extern cpumask_var_t cpu_callout_mask;
+extern cpumask_var_t cpu_initialized_mask;
+extern cpumask_var_t cpu_sibling_setup_mask;
+
+#else /* CONFIG_X86_32 */
+
+extern cpumask_t cpu_callin_map;
+extern cpumask_t cpu_callout_map;
+extern cpumask_t cpu_initialized;
+extern cpumask_t cpu_sibling_setup_map;
+
+#define cpu_callin_mask		((struct cpumask *)&cpu_callin_map)
+#define cpu_callout_mask	((struct cpumask *)&cpu_callout_map)
+#define cpu_initialized_mask	((struct cpumask *)&cpu_initialized)
+#define cpu_sibling_setup_mask	((struct cpumask *)&cpu_sibling_setup_map)
+
+#endif /* CONFIG_X86_32 */
+
+#endif /* __ASSEMBLY__ */
+#endif /* _ASM_X86_CPUMASK_H */
diff --git a/arch/x86/include/asm/current.h b/arch/x86/include/asm/current.h
index 0930b4f..c68c361 100644
--- a/arch/x86/include/asm/current.h
+++ b/arch/x86/include/asm/current.h
@@ -1,39 +1,21 @@
 #ifndef _ASM_X86_CURRENT_H
 #define _ASM_X86_CURRENT_H
 
-#ifdef CONFIG_X86_32
 #include <linux/compiler.h>
 #include <asm/percpu.h>
 
+#ifndef __ASSEMBLY__
 struct task_struct;
 
 DECLARE_PER_CPU(struct task_struct *, current_task);
-static __always_inline struct task_struct *get_current(void)
-{
-	return x86_read_percpu(current_task);
-}
-
-#else /* X86_32 */
-
-#ifndef __ASSEMBLY__
-#include <asm/pda.h>
-
-struct task_struct;
 
 static __always_inline struct task_struct *get_current(void)
 {
-	return read_pda(pcurrent);
+	return percpu_read(current_task);
 }
 
-#else /* __ASSEMBLY__ */
-
-#include <asm/asm-offsets.h>
-#define GET_CURRENT(reg) movq %gs:(pda_pcurrent),reg
+#define current get_current()
 
 #endif /* __ASSEMBLY__ */
 
-#endif /* X86_32 */
-
-#define current get_current()
-
 #endif /* _ASM_X86_CURRENT_H */
diff --git a/arch/x86/include/asm/hardirq_32.h b/arch/x86/include/asm/hardirq_32.h
index cf7954d..7838276 100644
--- a/arch/x86/include/asm/hardirq_32.h
+++ b/arch/x86/include/asm/hardirq_32.h
@@ -9,6 +9,7 @@ typedef struct {
 	unsigned long idle_timestamp;
 	unsigned int __nmi_count;	/* arch dependent */
 	unsigned int apic_timer_irqs;	/* arch dependent */
+	unsigned int apic_perf_irqs;	/* arch dependent */
 	unsigned int irq0_irqs;
 	unsigned int irq_resched_count;
 	unsigned int irq_call_count;
@@ -19,6 +20,9 @@ typedef struct {
 
 DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
 
+/* We can have at most NR_VECTORS irqs routed to a cpu at a time */
+#define MAX_HARDIRQS_PER_CPU NR_VECTORS
+
 #define __ARCH_IRQ_STAT
 #define __IRQ_STAT(cpu, member) (per_cpu(irq_stat, cpu).member)
 
diff --git a/arch/x86/include/asm/hardirq_64.h b/arch/x86/include/asm/hardirq_64.h
index b5a6b5d..42930b2 100644
--- a/arch/x86/include/asm/hardirq_64.h
+++ b/arch/x86/include/asm/hardirq_64.h
@@ -3,22 +3,37 @@
 
 #include <linux/threads.h>
 #include <linux/irq.h>
-#include <asm/pda.h>
 #include <asm/apic.h>
 
+typedef struct {
+	unsigned int __softirq_pending;
+	unsigned int __nmi_count;	/* arch dependent */
+	unsigned int apic_timer_irqs;	/* arch dependent */
+	unsigned int apic_perf_irqs;	/* arch dependent */
+	unsigned int irq0_irqs;
+	unsigned int irq_resched_count;
+	unsigned int irq_call_count;
+	unsigned int irq_tlb_count;
+	unsigned int irq_thermal_count;
+	unsigned int irq_spurious_count;
+	unsigned int irq_threshold_count;
+} ____cacheline_aligned irq_cpustat_t;
+
+DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
+
 /* We can have at most NR_VECTORS irqs routed to a cpu at a time */
 #define MAX_HARDIRQS_PER_CPU NR_VECTORS
 
 #define __ARCH_IRQ_STAT 1
 
-#define inc_irq_stat(member)	add_pda(member, 1)
+#define inc_irq_stat(member)	percpu_add(irq_stat.member, 1)
 
-#define local_softirq_pending() read_pda(__softirq_pending)
+#define local_softirq_pending() percpu_read(irq_stat.__softirq_pending)
 
 #define __ARCH_SET_SOFTIRQ_PENDING 1
 
-#define set_softirq_pending(x) write_pda(__softirq_pending, (x))
-#define or_softirq_pending(x)  or_pda(__softirq_pending, (x))
+#define set_softirq_pending(x) percpu_write(irq_stat.__softirq_pending, (x))
+#define or_softirq_pending(x)  percpu_or(irq_stat.__softirq_pending, (x))
 
 extern void ack_bad_irq(unsigned int irq);
 
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 8de644b..aa93e53 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -30,6 +30,8 @@
 /* Interrupt handlers registered during init_IRQ */
 extern void apic_timer_interrupt(void);
 extern void error_interrupt(void);
+extern void perf_counter_interrupt(void);
+
 extern void spurious_interrupt(void);
 extern void thermal_interrupt(void);
 extern void reschedule_interrupt(void);
diff --git a/arch/x86/include/asm/intel_arch_perfmon.h b/arch/x86/include/asm/intel_arch_perfmon.h
deleted file mode 100644
index fa0fd06..0000000
--- a/arch/x86/include/asm/intel_arch_perfmon.h
+++ /dev/null
@@ -1,31 +0,0 @@
-#ifndef _ASM_X86_INTEL_ARCH_PERFMON_H
-#define _ASM_X86_INTEL_ARCH_PERFMON_H
-
-#define MSR_ARCH_PERFMON_PERFCTR0		0xc1
-#define MSR_ARCH_PERFMON_PERFCTR1		0xc2
-
-#define MSR_ARCH_PERFMON_EVENTSEL0		0x186
-#define MSR_ARCH_PERFMON_EVENTSEL1		0x187
-
-#define ARCH_PERFMON_EVENTSEL0_ENABLE	(1 << 22)
-#define ARCH_PERFMON_EVENTSEL_INT	(1 << 20)
-#define ARCH_PERFMON_EVENTSEL_OS	(1 << 17)
-#define ARCH_PERFMON_EVENTSEL_USR	(1 << 16)
-
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL	(0x3c)
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK	(0x00 << 8)
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX (0)
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT \
-	(1 << (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX))
-
-union cpuid10_eax {
-	struct {
-		unsigned int version_id:8;
-		unsigned int num_counters:8;
-		unsigned int bit_width:8;
-		unsigned int mask_length:8;
-	} split;
-	unsigned int full;
-};
-
-#endif /* _ASM_X86_INTEL_ARCH_PERFMON_H */
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 7a1f44a..08ec793 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -114,38 +114,16 @@ struct IR_IO_APIC_route_entry {
 extern int nr_ioapics;
 extern int nr_ioapic_registers[MAX_IO_APICS];
 
-/*
- * MP-BIOS irq configuration table structures:
- */
-
 #define MP_MAX_IOAPIC_PIN 127
 
-struct mp_config_ioapic {
-	unsigned long mp_apicaddr;
-	unsigned int mp_apicid;
-	unsigned char mp_type;
-	unsigned char mp_apicver;
-	unsigned char mp_flags;
-};
-
-struct mp_config_intsrc {
-	unsigned int mp_dstapic;
-	unsigned char mp_type;
-	unsigned char mp_irqtype;
-	unsigned short mp_irqflag;
-	unsigned char mp_srcbus;
-	unsigned char mp_srcbusirq;
-	unsigned char mp_dstirq;
-};
-
 /* I/O APIC entries */
-extern struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
+extern struct mpc_ioapic mp_ioapics[MAX_IO_APICS];
 
 /* # of MP IRQ source entries */
 extern int mp_irq_entries;
 
 /* MP IRQ source entries */
-extern struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
+extern struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 
 /* non-0 if default (table-less) MP configuration */
 extern int mpc_default_type;
diff --git a/arch/x86/include/asm/irq_regs_32.h b/arch/x86/include/asm/irq_regs_32.h
index 86afd74..d7ed33e 100644
--- a/arch/x86/include/asm/irq_regs_32.h
+++ b/arch/x86/include/asm/irq_regs_32.h
@@ -15,7 +15,7 @@ DECLARE_PER_CPU(struct pt_regs *, irq_regs);
 
 static inline struct pt_regs *get_irq_regs(void)
 {
-	return x86_read_percpu(irq_regs);
+	return percpu_read(irq_regs);
 }
 
 static inline struct pt_regs *set_irq_regs(struct pt_regs *new_regs)
@@ -23,7 +23,7 @@ static inline struct pt_regs *set_irq_regs(struct pt_regs *new_regs)
 	struct pt_regs *old_regs;
 
 	old_regs = get_irq_regs();
-	x86_write_percpu(irq_regs, new_regs);
+	percpu_write(irq_regs, new_regs);
 
 	return old_regs;
 }
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index f7ff650..1554d02 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -87,6 +87,11 @@
 #define LOCAL_TIMER_VECTOR	0xef
 
 /*
+ * Performance monitoring interrupt vector:
+ */
+#define LOCAL_PERF_VECTOR	0xee
+
+/*
  * First APIC vector available to drivers: (vectors 0x30-0xee) we
  * start at 0x31(0x41) to spread out vectors evenly between priority
  * levels. (0x80 is the syscall vector)
@@ -105,6 +110,8 @@
 
 #if defined(CONFIG_X86_IO_APIC) && !defined(CONFIG_X86_VOYAGER)
 
+#include <asm/apicnum.h>	/* need MAX_IO_APICS */
+
 #ifndef CONFIG_SPARSE_IRQ
 # if NR_CPUS < MAX_IO_APICS
 #  define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
@@ -112,11 +119,12 @@
 #  define NR_IRQS (NR_VECTORS + (32 * MAX_IO_APICS))
 # endif
 #else
-# if (8 * NR_CPUS) > (32 * MAX_IO_APICS)
-#  define NR_IRQS (NR_VECTORS + (8 * NR_CPUS))
-# else
-#  define NR_IRQS (NR_VECTORS + (32 * MAX_IO_APICS))
-# endif
+
+# define NR_IRQS					\
+	((8 * NR_CPUS) > (32 * MAX_IO_APICS) ?		\
+		(NR_VECTORS + (8 * NR_CPUS)) :		\
+		(NR_VECTORS + (32 * MAX_IO_APICS)))	\
+
 #endif
 
 #elif defined(CONFIG_X86_VOYAGER)
diff --git a/arch/x86/include/asm/mach-default/entry_arch.h b/arch/x86/include/asm/mach-default/entry_arch.h
index 6b1add8..ad31e5d 100644
--- a/arch/x86/include/asm/mach-default/entry_arch.h
+++ b/arch/x86/include/asm/mach-default/entry_arch.h
@@ -25,10 +25,15 @@ BUILD_INTERRUPT(irq_move_cleanup_interrupt,IRQ_MOVE_CLEANUP_VECTOR)
  * a much simpler SMP time architecture:
  */
 #ifdef CONFIG_X86_LOCAL_APIC
+
 BUILD_INTERRUPT(apic_timer_interrupt,LOCAL_TIMER_VECTOR)
 BUILD_INTERRUPT(error_interrupt,ERROR_APIC_VECTOR)
 BUILD_INTERRUPT(spurious_interrupt,SPURIOUS_APIC_VECTOR)
 
+#ifdef CONFIG_PERF_COUNTERS
+BUILD_INTERRUPT(perf_counter_interrupt, LOCAL_PERF_VECTOR)
+#endif
+
 #ifdef CONFIG_X86_MCE_P4THERMAL
 BUILD_INTERRUPT(thermal_interrupt,THERMAL_APIC_VECTOR)
 #endif
diff --git a/arch/x86/include/asm/mmu_context_32.h b/arch/x86/include/asm/mmu_context_32.h
index 7e98ce1..08b5345 100644
--- a/arch/x86/include/asm/mmu_context_32.h
+++ b/arch/x86/include/asm/mmu_context_32.h
@@ -4,8 +4,8 @@
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
 #ifdef CONFIG_SMP
-	if (x86_read_percpu(cpu_tlbstate.state) == TLBSTATE_OK)
-		x86_write_percpu(cpu_tlbstate.state, TLBSTATE_LAZY);
+	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
+		percpu_write(cpu_tlbstate.state, TLBSTATE_LAZY);
 #endif
 }
 
@@ -19,8 +19,8 @@ static inline void switch_mm(struct mm_struct *prev,
 		/* stop flush ipis for the previous mm */
 		cpu_clear(cpu, prev->cpu_vm_mask);
 #ifdef CONFIG_SMP
-		x86_write_percpu(cpu_tlbstate.state, TLBSTATE_OK);
-		x86_write_percpu(cpu_tlbstate.active_mm, next);
+		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
+		percpu_write(cpu_tlbstate.active_mm, next);
 #endif
 		cpu_set(cpu, next->cpu_vm_mask);
 
@@ -35,8 +35,8 @@ static inline void switch_mm(struct mm_struct *prev,
 	}
 #ifdef CONFIG_SMP
 	else {
-		x86_write_percpu(cpu_tlbstate.state, TLBSTATE_OK);
-		BUG_ON(x86_read_percpu(cpu_tlbstate.active_mm) != next);
+		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
+		BUG_ON(percpu_read(cpu_tlbstate.active_mm) != next);
 
 		if (!cpu_test_and_set(cpu, next->cpu_vm_mask)) {
 			/* We were in lazy tlb mode and leave_mm disabled
diff --git a/arch/x86/include/asm/mmu_context_64.h b/arch/x86/include/asm/mmu_context_64.h
index 677d36e..c457250 100644
--- a/arch/x86/include/asm/mmu_context_64.h
+++ b/arch/x86/include/asm/mmu_context_64.h
@@ -1,13 +1,11 @@
 #ifndef _ASM_X86_MMU_CONTEXT_64_H
 #define _ASM_X86_MMU_CONTEXT_64_H
 
-#include <asm/pda.h>
-
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
 #ifdef CONFIG_SMP
-	if (read_pda(mmu_state) == TLBSTATE_OK)
-		write_pda(mmu_state, TLBSTATE_LAZY);
+	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
+		percpu_write(cpu_tlbstate.state, TLBSTATE_LAZY);
 #endif
 }
 
@@ -19,8 +17,8 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		/* stop flush ipis for the previous mm */
 		cpu_clear(cpu, prev->cpu_vm_mask);
 #ifdef CONFIG_SMP
-		write_pda(mmu_state, TLBSTATE_OK);
-		write_pda(active_mm, next);
+		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
+		percpu_write(cpu_tlbstate.active_mm, next);
 #endif
 		cpu_set(cpu, next->cpu_vm_mask);
 		load_cr3(next->pgd);
@@ -30,9 +28,9 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	}
 #ifdef CONFIG_SMP
 	else {
-		write_pda(mmu_state, TLBSTATE_OK);
-		if (read_pda(active_mm) != next)
-			BUG();
+		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
+		BUG_ON(percpu_read(cpu_tlbstate.active_mm) != next);
+
 		if (!cpu_test_and_set(cpu, next->cpu_vm_mask)) {
 			/* We were in lazy tlb mode and leave_mm disabled
 			 * tlb flush IPI delivery. We must reload CR3
diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index 59568bc..4a7f96d 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -24,17 +24,18 @@
 # endif
 #endif
 
-struct intel_mp_floating {
-	char mpf_signature[4];		/* "_MP_"			*/
-	unsigned int mpf_physptr;	/* Configuration table address	*/
-	unsigned char mpf_length;	/* Our length (paragraphs)	*/
-	unsigned char mpf_specification;/* Specification version	*/
-	unsigned char mpf_checksum;	/* Checksum (makes sum 0)	*/
-	unsigned char mpf_feature1;	/* Standard or configuration ?	*/
-	unsigned char mpf_feature2;	/* Bit7 set for IMCR|PIC	*/
-	unsigned char mpf_feature3;	/* Unused (0)			*/
-	unsigned char mpf_feature4;	/* Unused (0)			*/
-	unsigned char mpf_feature5;	/* Unused (0)			*/
+/* Intel MP Floating Pointer Structure */
+struct mpf_intel {
+	char signature[4];		/* "_MP_"			*/
+	unsigned int physptr;		/* Configuration table address	*/
+	unsigned char length;		/* Our length (paragraphs)	*/
+	unsigned char specification;	/* Specification version	*/
+	unsigned char checksum;		/* Checksum (makes sum 0)	*/
+	unsigned char feature1;		/* Standard or configuration ?	*/
+	unsigned char feature2;		/* Bit7 set for IMCR|PIC	*/
+	unsigned char feature3;		/* Unused (0)			*/
+	unsigned char feature4;		/* Unused (0)			*/
+	unsigned char feature5;		/* Unused (0)			*/
 };
 
 #define MPC_SIGNATURE "PCMP"
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 5ebca29..e27fdbe 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -13,8 +13,8 @@
 #define DEBUG_STACK_ORDER (EXCEPTION_STACK_ORDER + 1)
 #define DEBUG_STKSZ (PAGE_SIZE << DEBUG_STACK_ORDER)
 
-#define IRQSTACK_ORDER 2
-#define IRQSTACKSIZE (PAGE_SIZE << IRQSTACK_ORDER)
+#define IRQ_STACK_ORDER 2
+#define IRQ_STACK_SIZE (PAGE_SIZE << IRQ_STACK_ORDER)
 
 #define STACKFAULT_STACK 1
 #define DOUBLEFAULT_STACK 2
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index ba3e2ff..c26c6bf 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -244,7 +244,8 @@ struct pv_mmu_ops {
 	void (*flush_tlb_user)(void);
 	void (*flush_tlb_kernel)(void);
 	void (*flush_tlb_single)(unsigned long addr);
-	void (*flush_tlb_others)(const cpumask_t *cpus, struct mm_struct *mm,
+	void (*flush_tlb_others)(const struct cpumask *cpus,
+				 struct mm_struct *mm,
 				 unsigned long va);
 
 	/* Hooks for allocating and freeing a pagetable top-level */
@@ -984,10 +985,11 @@ static inline void __flush_tlb_single(unsigned long addr)
 	PVOP_VCALL1(pv_mmu_ops.flush_tlb_single, addr);
 }
 
-static inline void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
+static inline void flush_tlb_others(const struct cpumask *cpumask,
+				    struct mm_struct *mm,
 				    unsigned long va)
 {
-	PVOP_VCALL3(pv_mmu_ops.flush_tlb_others, &cpumask, mm, va);
+	PVOP_VCALL3(pv_mmu_ops.flush_tlb_others, cpumask, mm, va);
 }
 
 static inline int paravirt_pgd_alloc(struct mm_struct *mm)
diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 2fbfff8..c31ca04 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -5,133 +5,41 @@
 #include <linux/stddef.h>
 #include <linux/types.h>
 #include <linux/cache.h>
+#include <linux/threads.h>
 #include <asm/page.h>
+#include <asm/percpu.h>
 
 /* Per processor datastructure. %gs points to it while the kernel runs */
 struct x8664_pda {
-	struct task_struct *pcurrent;	/* 0  Current process */
-	unsigned long data_offset;	/* 8 Per cpu data offset from linker
-					   address */
-	unsigned long kernelstack;	/* 16 top of kernel stack for current */
-	unsigned long oldrsp;		/* 24 user rsp for system call */
-	int irqcount;			/* 32 Irq nesting counter. Starts -1 */
-	unsigned int cpunumber;		/* 36 Logical CPU number */
+	unsigned long unused1;
+	unsigned long unused2;
+	unsigned long unused3;
+	unsigned long unused4;
+	int unused5;
+	unsigned int unused6;		/* 36 was cpunumber */
 #ifdef CONFIG_CC_STACKPROTECTOR
 	unsigned long stack_canary;	/* 40 stack canary value */
 					/* gcc-ABI: this canary MUST be at
 					   offset 40!!! */
 #endif
-	char *irqstackptr;
-	short nodenumber;		/* number of current node (32k max) */
 	short in_bootmem;		/* pda lives in bootmem */
-	unsigned int __softirq_pending;
-	unsigned int __nmi_count;	/* number of NMI on this CPUs */
-	short mmu_state;
-	short isidle;
-	struct mm_struct *active_mm;
-	unsigned apic_timer_irqs;
-	unsigned irq0_irqs;
-	unsigned irq_resched_count;
-	unsigned irq_call_count;
-	unsigned irq_tlb_count;
-	unsigned irq_thermal_count;
-	unsigned irq_threshold_count;
-	unsigned irq_spurious_count;
 } ____cacheline_aligned_in_smp;
 
-extern struct x8664_pda **_cpu_pda;
+DECLARE_PER_CPU(struct x8664_pda, __pda);
 extern void pda_init(int);
 
-#define cpu_pda(i) (_cpu_pda[i])
+#define cpu_pda(cpu)		(&per_cpu(__pda, cpu))
 
-/*
- * There is no fast way to get the base address of the PDA, all the accesses
- * have to mention %fs/%gs.  So it needs to be done this Torvaldian way.
- */
-extern void __bad_pda_field(void) __attribute__((noreturn));
-
-/*
- * proxy_pda doesn't actually exist, but tell gcc it is accessed for
- * all PDA accesses so it gets read/write dependencies right.
- */
-extern struct x8664_pda _proxy_pda;
-
-#define pda_offset(field) offsetof(struct x8664_pda, field)
-
-#define pda_to_op(op, field, val)					\
-do {									\
-	typedef typeof(_proxy_pda.field) T__;				\
-	if (0) { T__ tmp__; tmp__ = (val); }	/* type checking */	\
-	switch (sizeof(_proxy_pda.field)) {				\
-	case 2:								\
-		asm(op "w %1,%%gs:%c2" :				\
-		    "+m" (_proxy_pda.field) :				\
-		    "ri" ((T__)val),					\
-		    "i"(pda_offset(field)));				\
-		break;							\
-	case 4:								\
-		asm(op "l %1,%%gs:%c2" :				\
-		    "+m" (_proxy_pda.field) :				\
-		    "ri" ((T__)val),					\
-		    "i" (pda_offset(field)));				\
-		break;							\
-	case 8:								\
-		asm(op "q %1,%%gs:%c2":					\
-		    "+m" (_proxy_pda.field) :				\
-		    "ri" ((T__)val),					\
-		    "i"(pda_offset(field)));				\
-		break;							\
-	default:							\
-		__bad_pda_field();					\
-	}								\
-} while (0)
-
-#define pda_from_op(op, field)			\
-({						\
-	typeof(_proxy_pda.field) ret__;		\
-	switch (sizeof(_proxy_pda.field)) {	\
-	case 2:					\
-		asm(op "w %%gs:%c1,%0" :	\
-		    "=r" (ret__) :		\
-		    "i" (pda_offset(field)),	\
-		    "m" (_proxy_pda.field));	\
-		break;				\
-	case 4:					\
-		asm(op "l %%gs:%c1,%0":		\
-		    "=r" (ret__):		\
-		    "i" (pda_offset(field)),	\
-		    "m" (_proxy_pda.field));	\
-		break;				\
-	case 8:					\
-		asm(op "q %%gs:%c1,%0":		\
-		    "=r" (ret__) :		\
-		    "i" (pda_offset(field)),	\
-		    "m" (_proxy_pda.field));	\
-		break;				\
-	default:				\
-		__bad_pda_field();		\
-	}					\
-	ret__;					\
-})
-
-#define read_pda(field)		pda_from_op("mov", field)
-#define write_pda(field, val)	pda_to_op("mov", field, val)
-#define add_pda(field, val)	pda_to_op("add", field, val)
-#define sub_pda(field, val)	pda_to_op("sub", field, val)
-#define or_pda(field, val)	pda_to_op("or", field, val)
+#define read_pda(field)		percpu_read(__pda.field)
+#define write_pda(field, val)	percpu_write(__pda.field, val)
+#define add_pda(field, val)	percpu_add(__pda.field, val)
+#define sub_pda(field, val)	percpu_sub(__pda.field, val)
+#define or_pda(field, val)	percpu_or(__pda.field, val)
 
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */
 #define test_and_clear_bit_pda(bit, field)				\
-({									\
-	int old__;							\
-	asm volatile("btr %2,%%gs:%c3\n\tsbbl %0,%0"			\
-		     : "=r" (old__), "+m" (_proxy_pda.field)		\
-		     : "dIr" (bit), "i" (pda_offset(field)) : "memory");\
-	old__;								\
-})
+	x86_test_and_clear_bit_percpu(bit, __pda.field)
 
 #endif
 
-#define PDA_STACKOFFSET (5*8)
-
 #endif /* _ASM_X86_PDA_H */
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index ece7205..165d527 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -2,53 +2,12 @@
 #define _ASM_X86_PERCPU_H
 
 #ifdef CONFIG_X86_64
-#include <linux/compiler.h>
-
-/* Same as asm-generic/percpu.h, except that we store the per cpu offset
-   in the PDA. Longer term the PDA and every per cpu variable
-   should be just put into a single section and referenced directly
-   from %gs */
-
-#ifdef CONFIG_SMP
-#include <asm/pda.h>
-
-#define __per_cpu_offset(cpu) (cpu_pda(cpu)->data_offset)
-#define __my_cpu_offset read_pda(data_offset)
-
-#define per_cpu_offset(x) (__per_cpu_offset(x))
-
+#define __percpu_seg		gs
+#define __percpu_mov_op		movq
+#else
+#define __percpu_seg		fs
+#define __percpu_mov_op		movl
 #endif
-#include <asm-generic/percpu.h>
-
-DECLARE_PER_CPU(struct x8664_pda, pda);
-
-/*
- * These are supposed to be implemented as a single instruction which
- * operates on the per-cpu data base segment.  x86-64 doesn't have
- * that yet, so this is a fairly inefficient workaround for the
- * meantime.  The single instruction is atomic with respect to
- * preemption and interrupts, so we need to explicitly disable
- * interrupts here to achieve the same effect.  However, because it
- * can be used from within interrupt-disable/enable, we can't actually
- * disable interrupts; disabling preemption is enough.
- */
-#define x86_read_percpu(var)						\
-	({								\
-		typeof(per_cpu_var(var)) __tmp;				\
-		preempt_disable();					\
-		__tmp = __get_cpu_var(var);				\
-		preempt_enable();					\
-		__tmp;							\
-	})
-
-#define x86_write_percpu(var, val)					\
-	do {								\
-		preempt_disable();					\
-		__get_cpu_var(var) = (val);				\
-		preempt_enable();					\
-	} while(0)
-
-#else /* CONFIG_X86_64 */
 
 #ifdef __ASSEMBLY__
 
@@ -65,47 +24,26 @@ DECLARE_PER_CPU(struct x8664_pda, pda);
  *    PER_CPU(cpu_gdt_descr, %ebx)
  */
 #ifdef CONFIG_SMP
-#define PER_CPU(var, reg)				\
-	movl %fs:per_cpu__##this_cpu_off, reg;		\
+#define PER_CPU(var, reg)						\
+	__percpu_mov_op %__percpu_seg:per_cpu__this_cpu_off, reg;	\
 	lea per_cpu__##var(reg), reg
-#define PER_CPU_VAR(var)	%fs:per_cpu__##var
+#define PER_CPU_VAR(var)	%__percpu_seg:per_cpu__##var
 #else /* ! SMP */
-#define PER_CPU(var, reg)			\
-	movl $per_cpu__##var, reg
+#define PER_CPU(var, reg)						\
+	__percpu_mov_op $per_cpu__##var, reg
 #define PER_CPU_VAR(var)	per_cpu__##var
 #endif	/* SMP */
 
 #else /* ...!ASSEMBLY */
 
-/*
- * PER_CPU finds an address of a per-cpu variable.
- *
- * Args:
- *    var - variable name
- *    cpu - 32bit register containing the current CPU number
- *
- * The resulting address is stored in the "cpu" argument.
- *
- * Example:
- *    PER_CPU(cpu_gdt_descr, %ebx)
- */
-#ifdef CONFIG_SMP
-
-#define __my_cpu_offset x86_read_percpu(this_cpu_off)
-
-/* fs segment starts at (positive) offset == __per_cpu_offset[cpu] */
-#define __percpu_seg "%%fs:"
-
-#else  /* !SMP */
+#include <linux/stringify.h>
 
-#define __percpu_seg ""
-
-#endif	/* SMP */
-
-#include <asm-generic/percpu.h>
-
-/* We can use this directly for local CPU (faster). */
-DECLARE_PER_CPU(unsigned long, this_cpu_off);
+#ifdef CONFIG_SMP
+#define __percpu_arg(x)		"%%"__stringify(__percpu_seg)":%P" #x
+#define __my_cpu_offset		percpu_read(this_cpu_off)
+#else
+#define __percpu_arg(x)		"%" #x
+#endif
 
 /* For arch-specific code, we can use direct single-insn ops (they
  * don't give an lvalue though). */
@@ -120,20 +58,25 @@ do {							\
 	}						\
 	switch (sizeof(var)) {				\
 	case 1:						\
-		asm(op "b %1,"__percpu_seg"%0"		\
+		asm(op "b %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
 		    : "ri" ((T__)val));			\
 		break;					\
 	case 2:						\
-		asm(op "w %1,"__percpu_seg"%0"		\
+		asm(op "w %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
 		    : "ri" ((T__)val));			\
 		break;					\
 	case 4:						\
-		asm(op "l %1,"__percpu_seg"%0"		\
+		asm(op "l %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
 		    : "ri" ((T__)val));			\
 		break;					\
+	case 8:						\
+		asm(op "q %1,"__percpu_arg(0)		\
+		    : "+m" (var)			\
+		    : "r" ((T__)val));			\
+		break;					\
 	default: __bad_percpu_size();			\
 	}						\
 } while (0)
@@ -143,17 +86,22 @@ do {							\
 	typeof(var) ret__;				\
 	switch (sizeof(var)) {				\
 	case 1:						\
-		asm(op "b "__percpu_seg"%1,%0"		\
+		asm(op "b "__percpu_arg(1)",%0"		\
 		    : "=r" (ret__)			\
 		    : "m" (var));			\
 		break;					\
 	case 2:						\
-		asm(op "w "__percpu_seg"%1,%0"		\
+		asm(op "w "__percpu_arg(1)",%0"		\
 		    : "=r" (ret__)			\
 		    : "m" (var));			\
 		break;					\
 	case 4:						\
-		asm(op "l "__percpu_seg"%1,%0"		\
+		asm(op "l "__percpu_arg(1)",%0"		\
+		    : "=r" (ret__)			\
+		    : "m" (var));			\
+		break;					\
+	case 8:						\
+		asm(op "q "__percpu_arg(1)",%0"		\
 		    : "=r" (ret__)			\
 		    : "m" (var));			\
 		break;					\
@@ -162,13 +110,36 @@ do {							\
 	ret__;						\
 })
 
-#define x86_read_percpu(var) percpu_from_op("mov", per_cpu__##var)
-#define x86_write_percpu(var, val) percpu_to_op("mov", per_cpu__##var, val)
-#define x86_add_percpu(var, val) percpu_to_op("add", per_cpu__##var, val)
-#define x86_sub_percpu(var, val) percpu_to_op("sub", per_cpu__##var, val)
-#define x86_or_percpu(var, val) percpu_to_op("or", per_cpu__##var, val)
+#define percpu_read(var)	percpu_from_op("mov", per_cpu__##var)
+#define percpu_write(var, val)	percpu_to_op("mov", per_cpu__##var, val)
+#define percpu_add(var, val)	percpu_to_op("add", per_cpu__##var, val)
+#define percpu_sub(var, val)	percpu_to_op("sub", per_cpu__##var, val)
+#define percpu_and(var, val)	percpu_to_op("and", per_cpu__##var, val)
+#define percpu_or(var, val)	percpu_to_op("or", per_cpu__##var, val)
+#define percpu_xor(var, val)	percpu_to_op("xor", per_cpu__##var, val)
+
+/* This is not atomic against other CPUs -- CPU preemption needs to be off */
+#define x86_test_and_clear_bit_percpu(bit, var)				\
+({									\
+	int old__;							\
+	asm volatile("btr %2,"__percpu_arg(1)"\n\tsbbl %0,%0"		\
+		     : "=r" (old__), "+m" (per_cpu__##var)		\
+		     : "dIr" (bit));					\
+	old__;								\
+})
+
+#include <asm-generic/percpu.h>
+
+/* We can use this directly for local CPU (faster). */
+DECLARE_PER_CPU(unsigned long, this_cpu_off);
+
+#ifdef CONFIG_X86_64
+extern void load_pda_offset(int cpu);
+#else
+static inline void load_pda_offset(int cpu) { }
+#endif
+
 #endif /* !__ASSEMBLY__ */
-#endif /* !CONFIG_X86_64 */
 
 #ifdef CONFIG_SMP
 
@@ -195,9 +166,9 @@ do {							\
 #define	early_per_cpu_ptr(_name) (_name##_early_ptr)
 #define	early_per_cpu_map(_name, _idx) (_name##_early_map[_idx])
 #define	early_per_cpu(_name, _cpu) 				\
-	(early_per_cpu_ptr(_name) ?				\
-		early_per_cpu_ptr(_name)[_cpu] :		\
-		per_cpu(_name, _cpu))
+	*(early_per_cpu_ptr(_name) ?				\
+		&early_per_cpu_ptr(_name)[_cpu] :		\
+		&per_cpu(_name, _cpu))
 
 #else	/* !CONFIG_SMP */
 #define	DEFINE_EARLY_PER_CPU(_type, _name, _initvalue)		\
diff --git a/arch/x86/include/asm/perf_counter.h b/arch/x86/include/asm/perf_counter.h
new file mode 100644
index 0000000..2e08ed7
--- /dev/null
+++ b/arch/x86/include/asm/perf_counter.h
@@ -0,0 +1,95 @@
+#ifndef _ASM_X86_PERF_COUNTER_H
+#define _ASM_X86_PERF_COUNTER_H
+
+/*
+ * Performance counter hw details:
+ */
+
+#define X86_PMC_MAX_GENERIC					8
+#define X86_PMC_MAX_FIXED					3
+
+#define X86_PMC_IDX_GENERIC				        0
+#define X86_PMC_IDX_FIXED				       32
+#define X86_PMC_IDX_MAX					       64
+
+#define MSR_ARCH_PERFMON_PERFCTR0			      0xc1
+#define MSR_ARCH_PERFMON_PERFCTR1			      0xc2
+
+#define MSR_ARCH_PERFMON_EVENTSEL0			     0x186
+#define MSR_ARCH_PERFMON_EVENTSEL1			     0x187
+
+#define ARCH_PERFMON_EVENTSEL0_ENABLE			  (1 << 22)
+#define ARCH_PERFMON_EVENTSEL_INT			  (1 << 20)
+#define ARCH_PERFMON_EVENTSEL_OS			  (1 << 17)
+#define ARCH_PERFMON_EVENTSEL_USR			  (1 << 16)
+
+/*
+ * Includes eventsel and unit mask as well:
+ */
+#define ARCH_PERFMON_EVENT_MASK				    0xffff
+
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		      0x3c
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX 		 0
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT \
+		(1 << (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX))
+
+#define ARCH_PERFMON_BRANCH_MISSES_RETIRED			 6
+
+/*
+ * Intel "Architectural Performance Monitoring" CPUID
+ * detection/enumeration details:
+ */
+union cpuid10_eax {
+	struct {
+		unsigned int version_id:8;
+		unsigned int num_counters:8;
+		unsigned int bit_width:8;
+		unsigned int mask_length:8;
+	} split;
+	unsigned int full;
+};
+
+union cpuid10_edx {
+	struct {
+		unsigned int num_counters_fixed:4;
+		unsigned int reserved:28;
+	} split;
+	unsigned int full;
+};
+
+
+/*
+ * Fixed-purpose performance counters:
+ */
+
+/*
+ * All 3 fixed-mode PMCs are configured via this single MSR:
+ */
+#define MSR_ARCH_PERFMON_FIXED_CTR_CTRL			0x38d
+
+/*
+ * The counts are available in three separate MSRs:
+ */
+
+/* Instr_Retired.Any: */
+#define MSR_ARCH_PERFMON_FIXED_CTR0			0x309
+#define X86_PMC_IDX_FIXED_INSTRUCTIONS			(X86_PMC_IDX_FIXED + 0)
+
+/* CPU_CLK_Unhalted.Core: */
+#define MSR_ARCH_PERFMON_FIXED_CTR1			0x30a
+#define X86_PMC_IDX_FIXED_CPU_CYCLES			(X86_PMC_IDX_FIXED + 1)
+
+/* CPU_CLK_Unhalted.Ref: */
+#define MSR_ARCH_PERFMON_FIXED_CTR2			0x30b
+#define X86_PMC_IDX_FIXED_BUS_CYCLES			(X86_PMC_IDX_FIXED + 2)
+
+#ifdef CONFIG_PERF_COUNTERS
+extern void init_hw_perf_counters(void);
+extern void perf_counters_lapic_init(int nmi);
+#else
+static inline void init_hw_perf_counters(void)		{ }
+static inline void perf_counters_lapic_init(int nmi)	{ }
+#endif
+
+#endif /* _ASM_X86_PERF_COUNTER_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 091cd88..f511246 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -378,6 +378,9 @@ union thread_xstate {
 
 #ifdef CONFIG_X86_64
 DECLARE_PER_CPU(struct orig_ist, orig_ist);
+
+DECLARE_PER_CPU(char[IRQ_STACK_SIZE], irq_stack);
+DECLARE_PER_CPU(char *, irq_stack_ptr);
 #endif
 
 extern void print_cpu_info(struct cpuinfo_x86 *);
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index ebe858c..5369497 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -100,7 +100,6 @@ extern unsigned long init_pg_tables_start;
 extern unsigned long init_pg_tables_end;
 
 #else
-void __init x86_64_init_pda(void);
 void __init x86_64_start_kernel(char *real_mode);
 void __init x86_64_start_reservations(char *real_mode_data);
 
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 19953df..68636e7 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -17,32 +17,7 @@
 #endif
 #include <asm/pda.h>
 #include <asm/thread_info.h>
-
-#ifdef CONFIG_X86_64
-
-extern cpumask_var_t cpu_callin_mask;
-extern cpumask_var_t cpu_callout_mask;
-extern cpumask_var_t cpu_initialized_mask;
-extern cpumask_var_t cpu_sibling_setup_mask;
-
-#else /* CONFIG_X86_32 */
-
-extern cpumask_t cpu_callin_map;
-extern cpumask_t cpu_callout_map;
-extern cpumask_t cpu_initialized;
-extern cpumask_t cpu_sibling_setup_map;
-
-#define cpu_callin_mask		((struct cpumask *)&cpu_callin_map)
-#define cpu_callout_mask	((struct cpumask *)&cpu_callout_map)
-#define cpu_initialized_mask	((struct cpumask *)&cpu_initialized)
-#define cpu_sibling_setup_mask	((struct cpumask *)&cpu_sibling_setup_map)
-
-#endif /* CONFIG_X86_32 */
-
-extern void (*mtrr_hook)(void);
-extern void zap_low_mappings(void);
-
-extern int __cpuinit get_local_pda(int cpu);
+#include <asm/cpumask.h>
 
 extern int smp_num_siblings;
 extern unsigned int num_processors;
@@ -50,9 +25,7 @@ extern unsigned int num_processors;
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_t, cpu_core_map);
 DECLARE_PER_CPU(u16, cpu_llc_id);
-#ifdef CONFIG_X86_32
 DECLARE_PER_CPU(int, cpu_number);
-#endif
 
 static inline struct cpumask *cpu_sibling_mask(int cpu)
 {
@@ -167,8 +140,6 @@ void play_dead_common(void);
 void native_send_call_func_ipi(const struct cpumask *mask);
 void native_send_call_func_single_ipi(int cpu);
 
-extern void prefill_possible_map(void);
-
 void smp_store_cpu_info(int id);
 #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
 
@@ -177,10 +148,6 @@ static inline int num_booting_cpus(void)
 {
 	return cpumask_weight(cpu_callout_mask);
 }
-#else
-static inline void prefill_possible_map(void)
-{
-}
 #endif /* CONFIG_SMP */
 
 extern unsigned disabled_cpus __cpuinitdata;
@@ -191,11 +158,11 @@ extern unsigned disabled_cpus __cpuinitdata;
  * from the initial startup. We map APIC_BASE very early in page_setup(),
  * so this is correct in the x86 case.
  */
-#define raw_smp_processor_id() (x86_read_percpu(cpu_number))
+#define raw_smp_processor_id() (percpu_read(cpu_number))
 extern int safe_smp_processor_id(void);
 
 #elif defined(CONFIG_X86_64_SMP)
-#define raw_smp_processor_id()	read_pda(cpunumber)
+#define raw_smp_processor_id() (percpu_read(cpu_number))
 
 #define stack_smp_processor_id()					\
 ({								\
@@ -205,10 +172,6 @@ extern int safe_smp_processor_id(void);
 })
 #define safe_smp_processor_id()		smp_processor_id()
 
-#else /* !CONFIG_X86_32_SMP && !CONFIG_X86_64_SMP */
-#define cpu_physical_id(cpu)		boot_cpu_physical_apicid
-#define safe_smp_processor_id()		0
-#define stack_smp_processor_id() 	0
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -251,11 +214,5 @@ static inline int hard_smp_processor_id(void)
 
 #endif /* CONFIG_X86_LOCAL_APIC */
 
-#ifdef CONFIG_X86_HAS_BOOT_CPU_ID
-extern unsigned char boot_cpu_id;
-#else
-#define boot_cpu_id	0
-#endif
-
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_SMP_H */
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 8e626ea..d1dc27d 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -94,7 +94,7 @@ do {									\
 	     "call __switch_to\n\t"					  \
 	     ".globl thread_return\n"					  \
 	     "thread_return:\n\t"					  \
-	     "movq %%gs:%P[pda_pcurrent],%%rsi\n\t"			  \
+	     "movq "__percpu_arg([current_task])",%%rsi\n\t"		  \
 	     "movq %P[thread_info](%%rsi),%%r8\n\t"			  \
 	     LOCK_PREFIX "btr  %[tif_fork],%P[ti_flags](%%r8)\n\t"	  \
 	     "movq %%rax,%%rdi\n\t" 					  \
@@ -106,7 +106,7 @@ do {									\
 	       [ti_flags] "i" (offsetof(struct thread_info, flags)),	  \
 	       [tif_fork] "i" (TIF_FORK),			  	  \
 	       [thread_info] "i" (offsetof(struct task_struct, stack)),   \
-	       [pda_pcurrent] "i" (offsetof(struct x8664_pda, pcurrent))  \
+	       [current_task] "m" (per_cpu_var(current_task))		  \
 	     : "memory", "cc" __EXTRA_CLOBBER)
 #endif
 
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 9878964..f384889 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -82,6 +82,7 @@ struct thread_info {
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
+#define TIF_PERF_COUNTERS	11	/* notify perf counter work */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* 32bit process */
 #define TIF_FORK		18	/* ret_from_fork */
@@ -104,6 +105,7 @@ struct thread_info {
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
+#define _TIF_PERF_COUNTERS	(1 << TIF_PERF_COUNTERS)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
@@ -135,7 +137,7 @@ struct thread_info {
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY|_TIF_NOTIFY_RESUME)
+	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY|_TIF_PERF_COUNTERS|_TIF_NOTIFY_RESUME)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
@@ -194,25 +196,21 @@ static inline struct thread_info *current_thread_info(void)
 
 #else /* X86_32 */
 
-#include <asm/pda.h>
+#include <asm/percpu.h>
+#define KERNEL_STACK_OFFSET (5*8)
 
 /*
  * macros/functions for gaining access to the thread information structure
  * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
 #ifndef __ASSEMBLY__
-static inline struct thread_info *current_thread_info(void)
-{
-	struct thread_info *ti;
-	ti = (void *)(read_pda(kernelstack) + PDA_STACKOFFSET - THREAD_SIZE);
-	return ti;
-}
+DECLARE_PER_CPU(unsigned long, kernel_stack);
 
-/* do not use in interrupt context */
-static inline struct thread_info *stack_thread_info(void)
+static inline struct thread_info *current_thread_info(void)
 {
 	struct thread_info *ti;
-	asm("andq %%rsp,%0; " : "=r" (ti) : "0" (~(THREAD_SIZE - 1)));
+	ti = (void *)(percpu_read(kernel_stack) +
+		      KERNEL_STACK_OFFSET - THREAD_SIZE);
 	return ti;
 }
 
@@ -220,8 +218,8 @@ static inline struct thread_info *stack_thread_info(void)
 
 /* how to get the thread information struct from ASM */
 #define GET_THREAD_INFO(reg) \
-	movq %gs:pda_kernelstack,reg ; \
-	subq $(THREAD_SIZE-PDA_STACKOFFSET),reg
+	movq PER_CPU_VAR(kernel_stack),reg ; \
+	subq $(THREAD_SIZE-KERNEL_STACK_OFFSET),reg
 
 #endif
 
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 0e7bbb5..d3539f9 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -113,7 +113,7 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
 		__flush_tlb();
 }
 
-static inline void native_flush_tlb_others(const cpumask_t *cpumask,
+static inline void native_flush_tlb_others(const struct cpumask *cpumask,
 					   struct mm_struct *mm,
 					   unsigned long va)
 {
@@ -142,31 +142,28 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
 	flush_tlb_mm(vma->vm_mm);
 }
 
-void native_flush_tlb_others(const cpumask_t *cpumask, struct mm_struct *mm,
-			     unsigned long va);
+void native_flush_tlb_others(const struct cpumask *cpumask,
+			     struct mm_struct *mm, unsigned long va);
 
 #define TLBSTATE_OK	1
 #define TLBSTATE_LAZY	2
 
-#ifdef CONFIG_X86_32
 struct tlb_state {
 	struct mm_struct *active_mm;
 	int state;
-	char __cacheline_padding[L1_CACHE_BYTES-8];
 };
 DECLARE_PER_CPU(struct tlb_state, cpu_tlbstate);
 
-void reset_lazy_tlbstate(void);
-#else
 static inline void reset_lazy_tlbstate(void)
 {
+	percpu_write(cpu_tlbstate.state, 0);
+	percpu_write(cpu_tlbstate.active_mm, &init_mm);
 }
-#endif
 
 #endif	/* SMP */
 
 #ifndef CONFIG_PARAVIRT
-#define flush_tlb_others(mask, mm, va)	native_flush_tlb_others(&mask, mm, va)
+#define flush_tlb_others(mask, mm, va)	native_flush_tlb_others(mask, mm, va)
 #endif
 
 static inline void flush_tlb_kernel_range(unsigned long start,
@@ -175,4 +172,6 @@ static inline void flush_tlb_kernel_range(unsigned long start,
 	flush_tlb_all();
 }
 
+extern void zap_low_mappings(void);
+
 #endif /* _ASM_X86_TLBFLUSH_H */
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 4e2f2e0..ffea1fe 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -83,7 +83,8 @@ extern cpumask_t *node_to_cpumask_map;
 DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);
 
 /* Returns the number of the current Node. */
-#define numa_node_id()		read_pda(nodenumber)
+DECLARE_PER_CPU(int, node_number);
+#define numa_node_id()		percpu_read(node_number)
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 extern int cpu_to_node(int cpu);
@@ -102,10 +103,7 @@ static inline int cpu_to_node(int cpu)
 /* Same function but used if called before per_cpu areas are setup */
 static inline int early_cpu_to_node(int cpu)
 {
-	if (early_per_cpu_ptr(x86_cpu_to_node_map))
-		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
-
-	return per_cpu(x86_cpu_to_node_map, cpu);
+	return early_per_cpu(x86_cpu_to_node_map, cpu);
 }
 
 /* Returns a pointer to the cpumask of CPUs on Node 'node'. */
diff --git a/arch/x86/include/asm/trampoline.h b/arch/x86/include/asm/trampoline.h
index 780ba0a..90f06c2 100644
--- a/arch/x86/include/asm/trampoline.h
+++ b/arch/x86/include/asm/trampoline.h
@@ -13,6 +13,7 @@ extern unsigned char *trampoline_base;
 
 extern unsigned long init_rsp;
 extern unsigned long initial_code;
+extern unsigned long initial_gs;
 
 #define TRAMPOLINE_SIZE roundup(trampoline_end - trampoline_data, PAGE_SIZE)
 #define TRAMPOLINE_BASE 0x6000
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index f2bba78..7e47658 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -338,6 +338,7 @@
 #define __NR_dup3		330
 #define __NR_pipe2		331
 #define __NR_inotify_init1	332
+#define __NR_perf_counter_open	333
 
 #ifdef __KERNEL__
 
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index d2e415e..53025fe 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -653,7 +653,8 @@ __SYSCALL(__NR_dup3, sys_dup3)
 __SYSCALL(__NR_pipe2, sys_pipe2)
 #define __NR_inotify_init1			294
 __SYSCALL(__NR_inotify_init1, sys_inotify_init1)
-
+#define __NR_perf_counter_open		295
+__SYSCALL(__NR_perf_counter_open, sys_perf_counter_open)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 50423c7..74e6393 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -325,7 +325,8 @@ static inline void bau_cpubits_clear(struct bau_local_cpumask *dstp, int nbits)
 #define cpubit_isset(cpu, bau_local_cpumask) \
 	test_bit((cpu), (bau_local_cpumask).bits)
 
-extern int uv_flush_tlb_others(cpumask_t *, struct mm_struct *, unsigned long);
+extern int uv_flush_tlb_others(struct cpumask *,
+			       struct mm_struct *, unsigned long);
 extern void uv_bau_message_intr1(void);
 extern void uv_bau_timeout_intr1(void);
 
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d37593c..4cb5964 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -912,8 +912,8 @@ static u8 __init uniq_ioapic_id(u8 id)
 	DECLARE_BITMAP(used, 256);
 	bitmap_zero(used, 256);
 	for (i = 0; i < nr_ioapics; i++) {
-		struct mp_config_ioapic *ia = &mp_ioapics[i];
-		__set_bit(ia->mp_apicid, used);
+		struct mpc_ioapic *ia = &mp_ioapics[i];
+		__set_bit(ia->apicid, used);
 	}
 	if (!test_bit(id, used))
 		return id;
@@ -945,47 +945,47 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 
 	idx = nr_ioapics;
 
-	mp_ioapics[idx].mp_type = MP_IOAPIC;
-	mp_ioapics[idx].mp_flags = MPC_APIC_USABLE;
-	mp_ioapics[idx].mp_apicaddr = address;
+	mp_ioapics[idx].type = MP_IOAPIC;
+	mp_ioapics[idx].flags = MPC_APIC_USABLE;
+	mp_ioapics[idx].apicaddr = address;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
-	mp_ioapics[idx].mp_apicid = uniq_ioapic_id(id);
+	mp_ioapics[idx].apicid = uniq_ioapic_id(id);
 #ifdef CONFIG_X86_32
-	mp_ioapics[idx].mp_apicver = io_apic_get_version(idx);
+	mp_ioapics[idx].apicver = io_apic_get_version(idx);
 #else
-	mp_ioapics[idx].mp_apicver = 0;
+	mp_ioapics[idx].apicver = 0;
 #endif
 	/*
 	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
-	mp_ioapic_routing[idx].apic_id = mp_ioapics[idx].mp_apicid;
+	mp_ioapic_routing[idx].apic_id = mp_ioapics[idx].apicid;
 	mp_ioapic_routing[idx].gsi_base = gsi_base;
 	mp_ioapic_routing[idx].gsi_end = gsi_base +
 	    io_apic_get_redir_entries(idx);
 
-	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%lx, "
-	       "GSI %d-%d\n", idx, mp_ioapics[idx].mp_apicid,
-	       mp_ioapics[idx].mp_apicver, mp_ioapics[idx].mp_apicaddr,
+	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
+	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
+	       mp_ioapics[idx].apicver, mp_ioapics[idx].apicaddr,
 	       mp_ioapic_routing[idx].gsi_base, mp_ioapic_routing[idx].gsi_end);
 
 	nr_ioapics++;
 }
 
-static void assign_to_mp_irq(struct mp_config_intsrc *m,
-				    struct mp_config_intsrc *mp_irq)
+static void assign_to_mp_irq(struct mpc_intsrc *m,
+				    struct mpc_intsrc *mp_irq)
 {
-	memcpy(mp_irq, m, sizeof(struct mp_config_intsrc));
+	memcpy(mp_irq, m, sizeof(struct mpc_intsrc));
 }
 
-static int mp_irq_cmp(struct mp_config_intsrc *mp_irq,
-				struct mp_config_intsrc *m)
+static int mp_irq_cmp(struct mpc_intsrc *mp_irq,
+				struct mpc_intsrc *m)
 {
-	return memcmp(mp_irq, m, sizeof(struct mp_config_intsrc));
+	return memcmp(mp_irq, m, sizeof(struct mpc_intsrc));
 }
 
-static void save_mp_irq(struct mp_config_intsrc *m)
+static void save_mp_irq(struct mpc_intsrc *m)
 {
 	int i;
 
@@ -1003,7 +1003,7 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 {
 	int ioapic;
 	int pin;
-	struct mp_config_intsrc mp_irq;
+	struct mpc_intsrc mp_irq;
 
 	/*
 	 * Convert 'gsi' to 'ioapic.pin'.
@@ -1021,13 +1021,13 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 	if ((bus_irq == 0) && (trigger == 3))
 		trigger = 1;
 
-	mp_irq.mp_type = MP_INTSRC;
-	mp_irq.mp_irqtype = mp_INT;
-	mp_irq.mp_irqflag = (trigger << 2) | polarity;
-	mp_irq.mp_srcbus = MP_ISA_BUS;
-	mp_irq.mp_srcbusirq = bus_irq;	/* IRQ */
-	mp_irq.mp_dstapic = mp_ioapics[ioapic].mp_apicid; /* APIC ID */
-	mp_irq.mp_dstirq = pin;	/* INTIN# */
+	mp_irq.type = MP_INTSRC;
+	mp_irq.irqtype = mp_INT;
+	mp_irq.irqflag = (trigger << 2) | polarity;
+	mp_irq.srcbus = MP_ISA_BUS;
+	mp_irq.srcbusirq = bus_irq;	/* IRQ */
+	mp_irq.dstapic = mp_ioapics[ioapic].apicid; /* APIC ID */
+	mp_irq.dstirq = pin;	/* INTIN# */
 
 	save_mp_irq(&mp_irq);
 }
@@ -1037,7 +1037,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 	int i;
 	int ioapic;
 	unsigned int dstapic;
-	struct mp_config_intsrc mp_irq;
+	struct mpc_intsrc mp_irq;
 
 #if defined (CONFIG_MCA) || defined (CONFIG_EISA)
 	/*
@@ -1062,7 +1062,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 	ioapic = mp_find_ioapic(0);
 	if (ioapic < 0)
 		return;
-	dstapic = mp_ioapics[ioapic].mp_apicid;
+	dstapic = mp_ioapics[ioapic].apicid;
 
 	/*
 	 * Use the default configuration for the IRQs 0-15.  Unless
@@ -1072,16 +1072,14 @@ void __init mp_config_acpi_legacy_irqs(void)
 		int idx;
 
 		for (idx = 0; idx < mp_irq_entries; idx++) {
-			struct mp_config_intsrc *irq = mp_irqs + idx;
+			struct mpc_intsrc *irq = mp_irqs + idx;
 
 			/* Do we already have a mapping for this ISA IRQ? */
-			if (irq->mp_srcbus == MP_ISA_BUS
-			    && irq->mp_srcbusirq == i)
+			if (irq->srcbus == MP_ISA_BUS && irq->srcbusirq == i)
 				break;
 
 			/* Do we already have a mapping for this IOAPIC pin */
-			if (irq->mp_dstapic == dstapic &&
-			    irq->mp_dstirq == i)
+			if (irq->dstapic == dstapic && irq->dstirq == i)
 				break;
 		}
 
@@ -1090,13 +1088,13 @@ void __init mp_config_acpi_legacy_irqs(void)
 			continue;	/* IRQ already used */
 		}
 
-		mp_irq.mp_type = MP_INTSRC;
-		mp_irq.mp_irqflag = 0;	/* Conforming */
-		mp_irq.mp_srcbus = MP_ISA_BUS;
-		mp_irq.mp_dstapic = dstapic;
-		mp_irq.mp_irqtype = mp_INT;
-		mp_irq.mp_srcbusirq = i; /* Identity mapped */
-		mp_irq.mp_dstirq = i;
+		mp_irq.type = MP_INTSRC;
+		mp_irq.irqflag = 0;	/* Conforming */
+		mp_irq.srcbus = MP_ISA_BUS;
+		mp_irq.dstapic = dstapic;
+		mp_irq.irqtype = mp_INT;
+		mp_irq.srcbusirq = i; /* Identity mapped */
+		mp_irq.dstirq = i;
 
 		save_mp_irq(&mp_irq);
 	}
@@ -1207,22 +1205,22 @@ int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
 			u32 gsi, int triggering, int polarity)
 {
 #ifdef CONFIG_X86_MPPARSE
-	struct mp_config_intsrc mp_irq;
+	struct mpc_intsrc mp_irq;
 	int ioapic;
 
 	if (!acpi_ioapic)
 		return 0;
 
 	/* print the entry should happen on mptable identically */
-	mp_irq.mp_type = MP_INTSRC;
-	mp_irq.mp_irqtype = mp_INT;
-	mp_irq.mp_irqflag = (triggering == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
+	mp_irq.type = MP_INTSRC;
+	mp_irq.irqtype = mp_INT;
+	mp_irq.irqflag = (triggering == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
 				(polarity == ACPI_ACTIVE_HIGH ? 1 : 3);
-	mp_irq.mp_srcbus = number;
-	mp_irq.mp_srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
+	mp_irq.srcbus = number;
+	mp_irq.srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
 	ioapic = mp_find_ioapic(gsi);
-	mp_irq.mp_dstapic = mp_ioapic_routing[ioapic].apic_id;
-	mp_irq.mp_dstirq = gsi - mp_ioapic_routing[ioapic].gsi_base;
+	mp_irq.dstapic = mp_ioapic_routing[ioapic].apic_id;
+	mp_irq.dstirq = gsi - mp_ioapic_routing[ioapic].gsi_base;
 
 	save_mp_irq(&mp_irq);
 #endif
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 707c1f6..4abff45 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -101,6 +101,7 @@ int acpi_save_state_mem(void)
 	stack_start.sp = temp_stack + sizeof(temp_stack);
 	early_gdt_descr.address =
 			(unsigned long)get_cpu_gdt_table(smp_processor_id());
+	initial_gs = per_cpu_offset(smp_processor_id());
 #endif
 	initial_code = (unsigned long)wakeup_long64;
 	saved_magic = 0x123456789abcdef0;
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 0f830e4..e9af14f 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -35,6 +35,7 @@
 #include <linux/nmi.h>
 #include <linux/timex.h>
 
+#include <asm/perf_counter.h>
 #include <asm/atomic.h>
 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
@@ -895,6 +896,10 @@ void disable_local_APIC(void)
 {
 	unsigned int value;
 
+	/* APIC hasn't been mapped yet */
+	if (!apic_phys)
+		return;
+
 	clear_local_APIC();
 
 	/*
@@ -1126,6 +1131,11 @@ void __cpuinit setup_local_APIC(void)
 	unsigned int value;
 	int i, j;
 
+	if (disable_apic) {
+		disable_ioapic_setup();
+		return;
+	}
+
 #ifdef CONFIG_X86_32
 	/* Pound the ESR really hard over the head with a big hammer - mbligh */
 	if (lapic_is_integrated() && esr_disable) {
@@ -1135,6 +1145,7 @@ void __cpuinit setup_local_APIC(void)
 		apic_write(APIC_ESR, 0);
 	}
 #endif
+	perf_counters_lapic_init(0);
 
 	preempt_disable();
 
@@ -1566,11 +1577,11 @@ int apic_version[MAX_APICS];
 
 int __init APIC_init_uniprocessor(void)
 {
-#ifdef CONFIG_X86_64
 	if (disable_apic) {
 		pr_info("Apic disabled\n");
 		return -1;
 	}
+#ifdef CONFIG_X86_64
 	if (!cpu_has_apic) {
 		disable_apic = 1;
 		pr_info("Apic disabled by BIOS\n");
@@ -1868,17 +1879,8 @@ void __cpuinit generic_processor_info(int apicid, int version)
 #endif
 
 #if defined(CONFIG_X86_SMP) || defined(CONFIG_X86_64)
-	/* are we being called early in kernel startup? */
-	if (early_per_cpu_ptr(x86_cpu_to_apicid)) {
-		u16 *cpu_to_apicid = early_per_cpu_ptr(x86_cpu_to_apicid);
-		u16 *bios_cpu_apicid = early_per_cpu_ptr(x86_bios_cpu_apicid);
-
-		cpu_to_apicid[cpu] = apicid;
-		bios_cpu_apicid[cpu] = apicid;
-	} else {
-		per_cpu(x86_cpu_to_apicid, cpu) = apicid;
-		per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
-	}
+	early_per_cpu(x86_cpu_to_apicid, cpu) = apicid;
+	early_per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
 #endif
 
 	set_cpu_possible(cpu, true);
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 1d41d3f..64c834a 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -49,13 +49,7 @@ int main(void)
 	BLANK();
 #undef ENTRY
 #define ENTRY(entry) DEFINE(pda_ ## entry, offsetof(struct x8664_pda, entry))
-	ENTRY(kernelstack); 
-	ENTRY(oldrsp); 
-	ENTRY(pcurrent); 
-	ENTRY(irqcount);
-	ENTRY(cpunumber);
-	ENTRY(irqstackptr);
-	ENTRY(data_offset);
+	DEFINE(pda_size, sizeof(struct x8664_pda));
 	BLANK();
 #undef ENTRY
 #ifdef CONFIG_PARAVIRT
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 82db7f4..c381330 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -1,5 +1,5 @@
 #
-# Makefile for x86-compatible CPU details and quirks
+# Makefile for x86-compatible CPU details, features and quirks
 #
 
 # Don't trace early stages of a secondary CPU boot
@@ -22,11 +22,13 @@ obj-$(CONFIG_CPU_SUP_CENTAUR_64)	+= centaur_64.o
 obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
 obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 
-obj-$(CONFIG_X86_MCE)	+= mcheck/
-obj-$(CONFIG_MTRR)	+= mtrr/
-obj-$(CONFIG_CPU_FREQ)	+= cpufreq/
+obj-$(CONFIG_PERF_COUNTERS)		+= perf_counter.o
 
-obj-$(CONFIG_X86_LOCAL_APIC) += perfctr-watchdog.o
+obj-$(CONFIG_X86_MCE)			+= mcheck/
+obj-$(CONFIG_MTRR)			+= mtrr/
+obj-$(CONFIG_CPU_FREQ)			+= cpufreq/
+
+obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o
 
 quiet_cmd_mkcapflags = MKCAP   $@
       cmd_mkcapflags = $(PERL) $(srctree)/$(src)/mkcapflags.pl $< $@
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 83492b1..95eb30e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -17,10 +17,13 @@
 #include <asm/mmu_context.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
+#include <asm/perf_counter.h>
 #include <asm/pat.h>
 #include <asm/asm.h>
 #include <asm/numa.h>
 #include <asm/smp.h>
+#include <asm/cpu.h>
+#include <asm/cpumask.h>
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/mpspec.h>
 #include <asm/apic.h>
@@ -772,6 +775,7 @@ void __init identify_boot_cpu(void)
 #else
 	vgetcpu_set_mode();
 #endif
+	init_hw_perf_counters();
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
@@ -877,54 +881,34 @@ static __init int setup_disablecpuid(char *arg)
 __setup("clearcpuid=", setup_disablecpuid);
 
 #ifdef CONFIG_X86_64
-struct x8664_pda **_cpu_pda __read_mostly;
-EXPORT_SYMBOL(_cpu_pda);
-
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
-static char boot_cpu_stack[IRQSTACKSIZE] __page_aligned_bss;
+DEFINE_PER_CPU_PAGE_ALIGNED(char[IRQ_STACK_SIZE], irq_stack);
+#ifdef CONFIG_SMP
+DEFINE_PER_CPU(char *, irq_stack_ptr);	/* will be set during per cpu init */
+#else
+DEFINE_PER_CPU(char *, irq_stack_ptr) =
+	per_cpu_var(irq_stack) + IRQ_STACK_SIZE - 64;
+#endif
+
+DEFINE_PER_CPU(unsigned long, kernel_stack) =
+	(unsigned long)&init_thread_union - KERNEL_STACK_OFFSET + THREAD_SIZE;
+EXPORT_PER_CPU_SYMBOL(kernel_stack);
+
+DEFINE_PER_CPU(unsigned int, irq_count) = -1;
 
 void __cpuinit pda_init(int cpu)
 {
-	struct x8664_pda *pda = cpu_pda(cpu);
-
 	/* Setup up data that may be needed in __get_free_pages early */
 	loadsegment(fs, 0);
 	loadsegment(gs, 0);
-	/* Memory clobbers used to order PDA accessed */
-	mb();
-	wrmsrl(MSR_GS_BASE, pda);
-	mb();
-
-	pda->cpunumber = cpu;
-	pda->irqcount = -1;
-	pda->kernelstack = (unsigned long)stack_thread_info() -
-				 PDA_STACKOFFSET + THREAD_SIZE;
-	pda->active_mm = &init_mm;
-	pda->mmu_state = 0;
-
-	if (cpu == 0) {
-		/* others are initialized in smpboot.c */
-		pda->pcurrent = &init_task;
-		pda->irqstackptr = boot_cpu_stack;
-		pda->irqstackptr += IRQSTACKSIZE - 64;
-	} else {
-		if (!pda->irqstackptr) {
-			pda->irqstackptr = (char *)
-				__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
-			if (!pda->irqstackptr)
-				panic("cannot allocate irqstack for cpu %d",
-				      cpu);
-			pda->irqstackptr += IRQSTACKSIZE - 64;
-		}
 
-		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
-			pda->nodenumber = cpu_to_node(cpu);
-	}
+	load_pda_offset(cpu);
 }
 
-static char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ +
-				  DEBUG_STKSZ] __page_aligned_bss;
+static DEFINE_PER_CPU_PAGE_ALIGNED(char, exception_stacks
+	[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ])
+	__aligned(PAGE_SIZE);
 
 extern asmlinkage void ignore_sysret(void);
 
@@ -982,15 +966,18 @@ void __cpuinit cpu_init(void)
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
 	struct orig_ist *orig_ist = &per_cpu(orig_ist, cpu);
 	unsigned long v;
-	char *estacks = NULL;
 	struct task_struct *me;
 	int i;
 
 	/* CPU 0 is initialised in head64.c */
 	if (cpu != 0)
 		pda_init(cpu);
-	else
-		estacks = boot_exception_stacks;
+
+#ifdef CONFIG_NUMA
+	if (cpu != 0 && percpu_read(node_number) == 0 &&
+	    cpu_to_node(cpu) != NUMA_NO_NODE)
+		percpu_write(node_number, cpu_to_node(cpu));
+#endif
 
 	me = current;
 
@@ -1024,18 +1011,13 @@ void __cpuinit cpu_init(void)
 	 * set up and load the per-CPU TSS
 	 */
 	if (!orig_ist->ist[0]) {
-		static const unsigned int order[N_EXCEPTION_STACKS] = {
-		  [0 ... N_EXCEPTION_STACKS - 1] = EXCEPTION_STACK_ORDER,
-		  [DEBUG_STACK - 1] = DEBUG_STACK_ORDER
+		static const unsigned int sizes[N_EXCEPTION_STACKS] = {
+		  [0 ... N_EXCEPTION_STACKS - 1] = EXCEPTION_STKSZ,
+		  [DEBUG_STACK - 1] = DEBUG_STKSZ
 		};
+		char *estacks = per_cpu(exception_stacks, cpu);
 		for (v = 0; v < N_EXCEPTION_STACKS; v++) {
-			if (cpu) {
-				estacks = (char *)__get_free_pages(GFP_ATOMIC, order[v]);
-				if (!estacks)
-					panic("Cannot allocate exception "
-					      "stack %ld %d\n", v, cpu);
-			}
-			estacks += PAGE_SIZE << order[v];
+			estacks += sizes[v];
 			orig_ist->ist[v] = t->x86_tss.ist[v] =
 					(unsigned long)estacks;
 		}
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 6f11e02..8f3c95c 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -235,8 +235,6 @@ static u32 get_cur_val(const struct cpumask *mask)
 		return 0;
 	}
 
-	cpumask_copy(cmd.mask, mask);
-
 	drv_read(&cmd);
 
 	dprintk("get_cur_val = %u\n", cmd.val);
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 48533d7..58527a9 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -132,7 +132,16 @@ struct _cpuid4_info {
 	union _cpuid4_leaf_ecx ecx;
 	unsigned long size;
 	unsigned long can_disable;
-	cpumask_t shared_cpu_map;	/* future?: only cpus/node is needed */
+	DECLARE_BITMAP(shared_cpu_map, NR_CPUS);
+};
+
+/* subset of above _cpuid4_info w/o shared_cpu_map */
+struct _cpuid4_info_regs {
+	union _cpuid4_leaf_eax eax;
+	union _cpuid4_leaf_ebx ebx;
+	union _cpuid4_leaf_ecx ecx;
+	unsigned long size;
+	unsigned long can_disable;
 };
 
 #ifdef CONFIG_PCI
@@ -263,7 +272,7 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 }
 
 static void __cpuinit
-amd_check_l3_disable(int index, struct _cpuid4_info *this_leaf)
+amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 {
 	if (index < 3)
 		return;
@@ -271,7 +280,8 @@ amd_check_l3_disable(int index, struct _cpuid4_info *this_leaf)
 }
 
 static int
-__cpuinit cpuid4_cache_lookup(int index, struct _cpuid4_info *this_leaf)
+__cpuinit cpuid4_cache_lookup_regs(int index,
+				   struct _cpuid4_info_regs *this_leaf)
 {
 	union _cpuid4_leaf_eax 	eax;
 	union _cpuid4_leaf_ebx 	ebx;
@@ -299,6 +309,15 @@ __cpuinit cpuid4_cache_lookup(int index, struct _cpuid4_info *this_leaf)
 	return 0;
 }
 
+static int
+__cpuinit cpuid4_cache_lookup(int index, struct _cpuid4_info *this_leaf)
+{
+	struct _cpuid4_info_regs *leaf_regs =
+		(struct _cpuid4_info_regs *)this_leaf;
+
+	return cpuid4_cache_lookup_regs(index, leaf_regs);
+}
+
 static int __cpuinit find_num_cache_leaves(void)
 {
 	unsigned int		eax, ebx, ecx, edx;
@@ -338,11 +357,10 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 		 * parameters cpuid leaf to find the cache details
 		 */
 		for (i = 0; i < num_cache_leaves; i++) {
-			struct _cpuid4_info this_leaf;
-
+			struct _cpuid4_info_regs this_leaf;
 			int retval;
 
-			retval = cpuid4_cache_lookup(i, &this_leaf);
+			retval = cpuid4_cache_lookup_regs(i, &this_leaf);
 			if (retval >= 0) {
 				switch(this_leaf.eax.split.level) {
 				    case 1:
@@ -491,17 +509,20 @@ static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
 	num_threads_sharing = 1 + this_leaf->eax.split.num_threads_sharing;
 
 	if (num_threads_sharing == 1)
-		cpu_set(cpu, this_leaf->shared_cpu_map);
+		cpumask_set_cpu(cpu, to_cpumask(this_leaf->shared_cpu_map));
 	else {
 		index_msb = get_count_order(num_threads_sharing);
 
 		for_each_online_cpu(i) {
 			if (cpu_data(i).apicid >> index_msb ==
 			    c->apicid >> index_msb) {
-				cpu_set(i, this_leaf->shared_cpu_map);
+				cpumask_set_cpu(i,
+					to_cpumask(this_leaf->shared_cpu_map));
 				if (i != cpu && per_cpu(cpuid4_info, i))  {
-					sibling_leaf = CPUID4_INFO_IDX(i, index);
-					cpu_set(cpu, sibling_leaf->shared_cpu_map);
+					sibling_leaf =
+						CPUID4_INFO_IDX(i, index);
+					cpumask_set_cpu(cpu, to_cpumask(
+						sibling_leaf->shared_cpu_map));
 				}
 			}
 		}
@@ -513,9 +534,10 @@ static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
 	int sibling;
 
 	this_leaf = CPUID4_INFO_IDX(cpu, index);
-	for_each_cpu_mask_nr(sibling, this_leaf->shared_cpu_map) {
+	for_each_cpu(sibling, to_cpumask(this_leaf->shared_cpu_map)) {
 		sibling_leaf = CPUID4_INFO_IDX(sibling, index);
-		cpu_clear(cpu, sibling_leaf->shared_cpu_map);
+		cpumask_clear_cpu(cpu,
+				  to_cpumask(sibling_leaf->shared_cpu_map));
 	}
 }
 #else
@@ -620,8 +642,9 @@ static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
 	int n = 0;
 
 	if (len > 1) {
-		cpumask_t *mask = &this_leaf->shared_cpu_map;
+		const struct cpumask *mask;
 
+		mask = to_cpumask(this_leaf->shared_cpu_map);
 		n = type?
 			cpulist_scnprintf(buf, len-2, mask) :
 			cpumask_scnprintf(buf, len-2, mask);
@@ -684,7 +707,8 @@ static struct pci_dev *get_k8_northbridge(int node)
 
 static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf)
 {
-	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
+	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
+	int node = cpu_to_node(cpumask_first(mask));
 	struct pci_dev *dev = NULL;
 	ssize_t ret = 0;
 	int i;
@@ -718,7 +742,8 @@ static ssize_t
 store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
 		    size_t count)
 {
-	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
+	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
+	int node = cpu_to_node(cpumask_first(mask));
 	struct pci_dev *dev = NULL;
 	unsigned int ret, index, val;
 
@@ -863,7 +888,7 @@ err_out:
 	return -ENOMEM;
 }
 
-static cpumask_t cache_dev_map = CPU_MASK_NONE;
+static DECLARE_BITMAP(cache_dev_map, NR_CPUS);
 
 /* Add/Remove cache interface for CPU device */
 static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
@@ -903,7 +928,7 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 		}
 		kobject_uevent(&(this_object->kobj), KOBJ_ADD);
 	}
-	cpu_set(cpu, cache_dev_map);
+	cpumask_set_cpu(cpu, to_cpumask(cache_dev_map));
 
 	kobject_uevent(per_cpu(cache_kobject, cpu), KOBJ_ADD);
 	return 0;
@@ -916,9 +941,9 @@ static void __cpuinit cache_remove_dev(struct sys_device * sys_dev)
 
 	if (per_cpu(cpuid4_info, cpu) == NULL)
 		return;
-	if (!cpu_isset(cpu, cache_dev_map))
+	if (!cpumask_test_cpu(cpu, to_cpumask(cache_dev_map)))
 		return;
-	cpu_clear(cpu, cache_dev_map);
+	cpumask_clear_cpu(cpu, to_cpumask(cache_dev_map));
 
 	for (i = 0; i < num_cache_leaves; i++)
 		kobject_put(&(INDEX_KOBJECT_PTR(cpu,i)->kobj));
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index 8ae8c4f..4772e91 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -67,7 +67,7 @@ static struct threshold_block threshold_defaults = {
 struct threshold_bank {
 	struct kobject *kobj;
 	struct threshold_block *blocks;
-	cpumask_t cpus;
+	cpumask_var_t cpus;
 };
 static DEFINE_PER_CPU(struct threshold_bank *, threshold_banks[NR_BANKS]);
 
@@ -481,7 +481,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 #ifdef CONFIG_SMP
 	if (cpu_data(cpu).cpu_core_id && shared_bank[bank]) {	/* symlink */
-		i = first_cpu(per_cpu(cpu_core_map, cpu));
+		i = cpumask_first(&per_cpu(cpu_core_map, cpu));
 
 		/* first core not up yet */
 		if (cpu_data(i).cpu_core_id)
@@ -501,7 +501,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		if (err)
 			goto out;
 
-		b->cpus = per_cpu(cpu_core_map, cpu);
+		cpumask_copy(b->cpus, &per_cpu(cpu_core_map, cpu));
 		per_cpu(threshold_banks, cpu)[bank] = b;
 		goto out;
 	}
@@ -512,15 +512,20 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		err = -ENOMEM;
 		goto out;
 	}
+	if (!alloc_cpumask_var(&b->cpus, GFP_KERNEL)) {
+		kfree(b);
+		err = -ENOMEM;
+		goto out;
+	}
 
 	b->kobj = kobject_create_and_add(name, &per_cpu(device_mce, cpu).kobj);
 	if (!b->kobj)
 		goto out_free;
 
 #ifndef CONFIG_SMP
-	b->cpus = CPU_MASK_ALL;
+	cpumask_setall(b->cpus);
 #else
-	b->cpus = per_cpu(cpu_core_map, cpu);
+	cpumask_copy(b->cpus, &per_cpu(cpu_core_map, cpu));
 #endif
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
@@ -529,7 +534,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 	if (err)
 		goto out_free;
 
-	for_each_cpu_mask_nr(i, b->cpus) {
+	for_each_cpu(i, b->cpus) {
 		if (i == cpu)
 			continue;
 
@@ -545,6 +550,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 out_free:
 	per_cpu(threshold_banks, cpu)[bank] = NULL;
+	free_cpumask_var(b->cpus);
 	kfree(b);
 out:
 	return err;
@@ -619,7 +625,7 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 #endif
 
 	/* remove all sibling symlinks before unregistering */
-	for_each_cpu_mask_nr(i, b->cpus) {
+	for_each_cpu(i, b->cpus) {
 		if (i == cpu)
 			continue;
 
@@ -632,6 +638,7 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 free_out:
 	kobject_del(b->kobj);
 	kobject_put(b->kobj);
+	free_cpumask_var(b->cpus);
 	kfree(b);
 	per_cpu(threshold_banks, cpu)[bank] = NULL;
 }
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
new file mode 100644
index 0000000..9376771
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -0,0 +1,695 @@
+/*
+ * Performance counter x86 architecture code
+ *
+ *  Copyright(C) 2008 Thomas Gleixner <tglx@linutronix.de>
+ *  Copyright(C) 2008 Red Hat, Inc., Ingo Molnar
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#include <linux/perf_counter.h>
+#include <linux/capability.h>
+#include <linux/notifier.h>
+#include <linux/hardirq.h>
+#include <linux/kprobes.h>
+#include <linux/module.h>
+#include <linux/kdebug.h>
+#include <linux/sched.h>
+
+#include <asm/perf_counter.h>
+#include <asm/apic.h>
+
+static bool perf_counters_initialized __read_mostly;
+
+/*
+ * Number of (generic) HW counters:
+ */
+static int nr_counters_generic __read_mostly;
+static u64 perf_counter_mask __read_mostly;
+static u64 counter_value_mask __read_mostly;
+
+static int nr_counters_fixed __read_mostly;
+
+struct cpu_hw_counters {
+	struct perf_counter	*counters[X86_PMC_IDX_MAX];
+	unsigned long		used[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+};
+
+/*
+ * Intel PerfMon v3. Used on Core2 and later.
+ */
+static DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters);
+
+static const int intel_perfmon_event_map[] =
+{
+  [PERF_COUNT_CPU_CYCLES]		= 0x003c,
+  [PERF_COUNT_INSTRUCTIONS]		= 0x00c0,
+  [PERF_COUNT_CACHE_REFERENCES]		= 0x4f2e,
+  [PERF_COUNT_CACHE_MISSES]		= 0x412e,
+  [PERF_COUNT_BRANCH_INSTRUCTIONS]	= 0x00c4,
+  [PERF_COUNT_BRANCH_MISSES]		= 0x00c5,
+  [PERF_COUNT_BUS_CYCLES]		= 0x013c,
+};
+
+static const int max_intel_perfmon_events = ARRAY_SIZE(intel_perfmon_event_map);
+
+/*
+ * Propagate counter elapsed time into the generic counter.
+ * Can only be executed on the CPU where the counter is active.
+ * Returns the delta events processed.
+ */
+static void
+x86_perf_counter_update(struct perf_counter *counter,
+			struct hw_perf_counter *hwc, int idx)
+{
+	u64 prev_raw_count, new_raw_count, delta;
+
+	/*
+	 * Careful: an NMI might modify the previous counter value.
+	 *
+	 * Our tactic to handle this is to first atomically read and
+	 * exchange a new raw count - then add that new-prev delta
+	 * count to the generic counter atomically:
+	 */
+again:
+	prev_raw_count = atomic64_read(&hwc->prev_count);
+	rdmsrl(hwc->counter_base + idx, new_raw_count);
+
+	if (atomic64_cmpxchg(&hwc->prev_count, prev_raw_count,
+					new_raw_count) != prev_raw_count)
+		goto again;
+
+	/*
+	 * Now we have the new raw value and have updated the prev
+	 * timestamp already. We can now calculate the elapsed delta
+	 * (counter-)time and add that to the generic counter.
+	 *
+	 * Careful, not all hw sign-extends above the physical width
+	 * of the count, so we do that by clipping the delta to 32 bits:
+	 */
+	delta = (u64)(u32)((s32)new_raw_count - (s32)prev_raw_count);
+
+	atomic64_add(delta, &counter->count);
+	atomic64_sub(delta, &hwc->period_left);
+}
+
+/*
+ * Setup the hardware configuration for a given hw_event_type
+ */
+static int __hw_perf_counter_init(struct perf_counter *counter)
+{
+	struct perf_counter_hw_event *hw_event = &counter->hw_event;
+	struct hw_perf_counter *hwc = &counter->hw;
+
+	if (unlikely(!perf_counters_initialized))
+		return -EINVAL;
+
+	/*
+	 * Count user events, and generate PMC IRQs:
+	 * (keep 'enabled' bit clear for now)
+	 */
+	hwc->config = ARCH_PERFMON_EVENTSEL_USR | ARCH_PERFMON_EVENTSEL_INT;
+
+	/*
+	 * If privileged enough, count OS events too, and allow
+	 * NMI events as well:
+	 */
+	hwc->nmi = 0;
+	if (capable(CAP_SYS_ADMIN)) {
+		hwc->config |= ARCH_PERFMON_EVENTSEL_OS;
+		if (hw_event->nmi)
+			hwc->nmi = 1;
+	}
+
+	hwc->irq_period		= hw_event->irq_period;
+	/*
+	 * Intel PMCs cannot be accessed sanely above 32 bit width,
+	 * so we install an artificial 1<<31 period regardless of
+	 * the generic counter period:
+	 */
+	if ((s64)hwc->irq_period <= 0 || hwc->irq_period > 0x7FFFFFFF)
+		hwc->irq_period = 0x7FFFFFFF;
+
+	atomic64_set(&hwc->period_left, hwc->irq_period);
+
+	/*
+	 * Raw event type provide the config in the event structure
+	 */
+	if (hw_event->raw) {
+		hwc->config |= hw_event->type;
+	} else {
+		if (hw_event->type >= max_intel_perfmon_events)
+			return -EINVAL;
+		/*
+		 * The generic map:
+		 */
+		hwc->config |= intel_perfmon_event_map[hw_event->type];
+	}
+	counter->wakeup_pending = 0;
+
+	return 0;
+}
+
+u64 hw_perf_save_disable(void)
+{
+	u64 ctrl;
+
+	if (unlikely(!perf_counters_initialized))
+		return 0;
+
+	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+
+	return ctrl;
+}
+EXPORT_SYMBOL_GPL(hw_perf_save_disable);
+
+void hw_perf_restore(u64 ctrl)
+{
+	if (unlikely(!perf_counters_initialized))
+		return;
+
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
+}
+EXPORT_SYMBOL_GPL(hw_perf_restore);
+
+static inline void
+__pmc_fixed_disable(struct perf_counter *counter,
+		    struct hw_perf_counter *hwc, unsigned int __idx)
+{
+	int idx = __idx - X86_PMC_IDX_FIXED;
+	u64 ctrl_val, mask;
+	int err;
+
+	mask = 0xfULL << (idx * 4);
+
+	rdmsrl(hwc->config_base, ctrl_val);
+	ctrl_val &= ~mask;
+	err = checking_wrmsrl(hwc->config_base, ctrl_val);
+}
+
+static inline void
+__pmc_generic_disable(struct perf_counter *counter,
+			   struct hw_perf_counter *hwc, unsigned int idx)
+{
+	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL))
+		__pmc_fixed_disable(counter, hwc, idx);
+	else
+		wrmsr_safe(hwc->config_base + idx, hwc->config, 0);
+}
+
+static DEFINE_PER_CPU(u64, prev_left[X86_PMC_IDX_MAX]);
+
+/*
+ * Set the next IRQ period, based on the hwc->period_left value.
+ * To be called with the counter disabled in hw:
+ */
+static void
+__hw_perf_counter_set_period(struct perf_counter *counter,
+			     struct hw_perf_counter *hwc, int idx)
+{
+	s64 left = atomic64_read(&hwc->period_left);
+	s32 period = hwc->irq_period;
+	int err;
+
+	/*
+	 * If we are way outside a reasoable range then just skip forward:
+	 */
+	if (unlikely(left <= -period)) {
+		left = period;
+		atomic64_set(&hwc->period_left, left);
+	}
+
+	if (unlikely(left <= 0)) {
+		left += period;
+		atomic64_set(&hwc->period_left, left);
+	}
+
+	per_cpu(prev_left[idx], smp_processor_id()) = left;
+
+	/*
+	 * The hw counter starts counting from this counter offset,
+	 * mark it to be able to extra future deltas:
+	 */
+	atomic64_set(&hwc->prev_count, (u64)-left);
+
+	err = checking_wrmsrl(hwc->counter_base + idx,
+			     (u64)(-left) & counter_value_mask);
+}
+
+static inline void
+__pmc_fixed_enable(struct perf_counter *counter,
+		   struct hw_perf_counter *hwc, unsigned int __idx)
+{
+	int idx = __idx - X86_PMC_IDX_FIXED;
+	u64 ctrl_val, bits, mask;
+	int err;
+
+	/*
+	 * Enable IRQ generation (0x8) and ring-3 counting (0x2),
+	 * and enable ring-0 counting if allowed:
+	 */
+	bits = 0x8ULL | 0x2ULL;
+	if (hwc->config & ARCH_PERFMON_EVENTSEL_OS)
+		bits |= 0x1;
+	bits <<= (idx * 4);
+	mask = 0xfULL << (idx * 4);
+
+	rdmsrl(hwc->config_base, ctrl_val);
+	ctrl_val &= ~mask;
+	ctrl_val |= bits;
+	err = checking_wrmsrl(hwc->config_base, ctrl_val);
+}
+
+static void
+__pmc_generic_enable(struct perf_counter *counter,
+			  struct hw_perf_counter *hwc, int idx)
+{
+	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL))
+		__pmc_fixed_enable(counter, hwc, idx);
+	else
+		wrmsr(hwc->config_base + idx,
+		      hwc->config | ARCH_PERFMON_EVENTSEL0_ENABLE, 0);
+}
+
+static int
+fixed_mode_idx(struct perf_counter *counter, struct hw_perf_counter *hwc)
+{
+	unsigned int event;
+
+	if (unlikely(hwc->nmi))
+		return -1;
+
+	event = hwc->config & ARCH_PERFMON_EVENT_MASK;
+
+	if (unlikely(event == intel_perfmon_event_map[PERF_COUNT_INSTRUCTIONS]))
+		return X86_PMC_IDX_FIXED_INSTRUCTIONS;
+	if (unlikely(event == intel_perfmon_event_map[PERF_COUNT_CPU_CYCLES]))
+		return X86_PMC_IDX_FIXED_CPU_CYCLES;
+	if (unlikely(event == intel_perfmon_event_map[PERF_COUNT_BUS_CYCLES]))
+		return X86_PMC_IDX_FIXED_BUS_CYCLES;
+
+	return -1;
+}
+
+/*
+ * Find a PMC slot for the freshly enabled / scheduled in counter:
+ */
+static int pmc_generic_enable(struct perf_counter *counter)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	struct hw_perf_counter *hwc = &counter->hw;
+	int idx;
+
+	idx = fixed_mode_idx(counter, hwc);
+	if (idx >= 0) {
+		/*
+		 * Try to get the fixed counter, if that is already taken
+		 * then try to get a generic counter:
+		 */
+		if (test_and_set_bit(idx, cpuc->used))
+			goto try_generic;
+
+		hwc->config_base = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
+		/*
+		 * We set it so that counter_base + idx in wrmsr/rdmsr maps to
+		 * MSR_ARCH_PERFMON_FIXED_CTR0 ... CTR2:
+		 */
+		hwc->counter_base =
+			MSR_ARCH_PERFMON_FIXED_CTR0 - X86_PMC_IDX_FIXED;
+		hwc->idx = idx;
+	} else {
+		idx = hwc->idx;
+		/* Try to get the previous generic counter again */
+		if (test_and_set_bit(idx, cpuc->used)) {
+try_generic:
+			idx = find_first_zero_bit(cpuc->used, nr_counters_generic);
+			if (idx == nr_counters_generic)
+				return -EAGAIN;
+
+			set_bit(idx, cpuc->used);
+			hwc->idx = idx;
+		}
+		hwc->config_base  = MSR_ARCH_PERFMON_EVENTSEL0;
+		hwc->counter_base = MSR_ARCH_PERFMON_PERFCTR0;
+	}
+
+	perf_counters_lapic_init(hwc->nmi);
+
+	__pmc_generic_disable(counter, hwc, idx);
+
+	cpuc->counters[idx] = counter;
+	/*
+	 * Make it visible before enabling the hw:
+	 */
+	smp_wmb();
+
+	__hw_perf_counter_set_period(counter, hwc, idx);
+	__pmc_generic_enable(counter, hwc, idx);
+
+	return 0;
+}
+
+void perf_counter_print_debug(void)
+{
+	u64 ctrl, status, overflow, pmc_ctrl, pmc_count, prev_left, fixed;
+	struct cpu_hw_counters *cpuc;
+	int cpu, idx;
+
+	if (!nr_counters_generic)
+		return;
+
+	local_irq_disable();
+
+	cpu = smp_processor_id();
+	cpuc = &per_cpu(cpu_hw_counters, cpu);
+
+	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
+	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
+	rdmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, overflow);
+	rdmsrl(MSR_ARCH_PERFMON_FIXED_CTR_CTRL, fixed);
+
+	printk(KERN_INFO "\n");
+	printk(KERN_INFO "CPU#%d: ctrl:       %016llx\n", cpu, ctrl);
+	printk(KERN_INFO "CPU#%d: status:     %016llx\n", cpu, status);
+	printk(KERN_INFO "CPU#%d: overflow:   %016llx\n", cpu, overflow);
+	printk(KERN_INFO "CPU#%d: fixed:      %016llx\n", cpu, fixed);
+	printk(KERN_INFO "CPU#%d: used:       %016llx\n", cpu, *(u64 *)cpuc->used);
+
+	for (idx = 0; idx < nr_counters_generic; idx++) {
+		rdmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + idx, pmc_ctrl);
+		rdmsrl(MSR_ARCH_PERFMON_PERFCTR0  + idx, pmc_count);
+
+		prev_left = per_cpu(prev_left[idx], cpu);
+
+		printk(KERN_INFO "CPU#%d:   gen-PMC%d ctrl:  %016llx\n",
+			cpu, idx, pmc_ctrl);
+		printk(KERN_INFO "CPU#%d:   gen-PMC%d count: %016llx\n",
+			cpu, idx, pmc_count);
+		printk(KERN_INFO "CPU#%d:   gen-PMC%d left:  %016llx\n",
+			cpu, idx, prev_left);
+	}
+	for (idx = 0; idx < nr_counters_fixed; idx++) {
+		rdmsrl(MSR_ARCH_PERFMON_FIXED_CTR0 + idx, pmc_count);
+
+		printk(KERN_INFO "CPU#%d: fixed-PMC%d count: %016llx\n",
+			cpu, idx, pmc_count);
+	}
+	local_irq_enable();
+}
+
+static void pmc_generic_disable(struct perf_counter *counter)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	struct hw_perf_counter *hwc = &counter->hw;
+	unsigned int idx = hwc->idx;
+
+	__pmc_generic_disable(counter, hwc, idx);
+
+	clear_bit(idx, cpuc->used);
+	cpuc->counters[idx] = NULL;
+	/*
+	 * Make sure the cleared pointer becomes visible before we
+	 * (potentially) free the counter:
+	 */
+	smp_wmb();
+
+	/*
+	 * Drain the remaining delta count out of a counter
+	 * that we are disabling:
+	 */
+	x86_perf_counter_update(counter, hwc, idx);
+}
+
+static void perf_store_irq_data(struct perf_counter *counter, u64 data)
+{
+	struct perf_data *irqdata = counter->irqdata;
+
+	if (irqdata->len > PERF_DATA_BUFLEN - sizeof(u64)) {
+		irqdata->overrun++;
+	} else {
+		u64 *p = (u64 *) &irqdata->data[irqdata->len];
+
+		*p = data;
+		irqdata->len += sizeof(u64);
+	}
+}
+
+/*
+ * Save and restart an expired counter. Called by NMI contexts,
+ * so it has to be careful about preempting normal counter ops:
+ */
+static void perf_save_and_restart(struct perf_counter *counter)
+{
+	struct hw_perf_counter *hwc = &counter->hw;
+	int idx = hwc->idx;
+
+	x86_perf_counter_update(counter, hwc, idx);
+	__hw_perf_counter_set_period(counter, hwc, idx);
+
+	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
+		__pmc_generic_enable(counter, hwc, idx);
+}
+
+static void
+perf_handle_group(struct perf_counter *sibling, u64 *status, u64 *overflown)
+{
+	struct perf_counter *counter, *group_leader = sibling->group_leader;
+
+	/*
+	 * Store sibling timestamps (if any):
+	 */
+	list_for_each_entry(counter, &group_leader->sibling_list, list_entry) {
+
+		x86_perf_counter_update(counter, &counter->hw, counter->hw.idx);
+		perf_store_irq_data(sibling, counter->hw_event.type);
+		perf_store_irq_data(sibling, atomic64_read(&counter->count));
+	}
+}
+
+/*
+ * This handler is triggered by the local APIC, so the APIC IRQ handling
+ * rules apply:
+ */
+static void __smp_perf_counter_interrupt(struct pt_regs *regs, int nmi)
+{
+	int bit, cpu = smp_processor_id();
+	u64 ack, status, saved_global;
+	struct cpu_hw_counters *cpuc;
+
+	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, saved_global);
+
+	/* Disable counters globally */
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+	ack_APIC_irq();
+
+	cpuc = &per_cpu(cpu_hw_counters, cpu);
+
+	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
+	if (!status)
+		goto out;
+
+again:
+	ack = status;
+	for_each_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
+		struct perf_counter *counter = cpuc->counters[bit];
+
+		clear_bit(bit, (unsigned long *) &status);
+		if (!counter)
+			continue;
+
+		perf_save_and_restart(counter);
+
+		switch (counter->hw_event.record_type) {
+		case PERF_RECORD_SIMPLE:
+			continue;
+		case PERF_RECORD_IRQ:
+			perf_store_irq_data(counter, instruction_pointer(regs));
+			break;
+		case PERF_RECORD_GROUP:
+			perf_handle_group(counter, &status, &ack);
+			break;
+		}
+		/*
+		 * From NMI context we cannot call into the scheduler to
+		 * do a task wakeup - but we mark these generic as
+		 * wakeup_pending and initate a wakeup callback:
+		 */
+		if (nmi) {
+			counter->wakeup_pending = 1;
+			set_tsk_thread_flag(current, TIF_PERF_COUNTERS);
+		} else {
+			wake_up(&counter->waitq);
+		}
+	}
+
+	wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, ack);
+
+	/*
+	 * Repeat if there is more work to be done:
+	 */
+	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
+	if (status)
+		goto again;
+out:
+	/*
+	 * Restore - do not reenable when global enable is off:
+	 */
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, saved_global);
+}
+
+void smp_perf_counter_interrupt(struct pt_regs *regs)
+{
+	irq_enter();
+	inc_irq_stat(apic_perf_irqs);
+	apic_write(APIC_LVTPC, LOCAL_PERF_VECTOR);
+	__smp_perf_counter_interrupt(regs, 0);
+
+	irq_exit();
+}
+
+/*
+ * This handler is triggered by NMI contexts:
+ */
+void perf_counter_notify(struct pt_regs *regs)
+{
+	struct cpu_hw_counters *cpuc;
+	unsigned long flags;
+	int bit, cpu;
+
+	local_irq_save(flags);
+	cpu = smp_processor_id();
+	cpuc = &per_cpu(cpu_hw_counters, cpu);
+
+	for_each_bit(bit, cpuc->used, X86_PMC_IDX_MAX) {
+		struct perf_counter *counter = cpuc->counters[bit];
+
+		if (!counter)
+			continue;
+
+		if (counter->wakeup_pending) {
+			counter->wakeup_pending = 0;
+			wake_up(&counter->waitq);
+		}
+	}
+
+	local_irq_restore(flags);
+}
+
+void __cpuinit perf_counters_lapic_init(int nmi)
+{
+	u32 apic_val;
+
+	if (!perf_counters_initialized)
+		return;
+	/*
+	 * Enable the performance counter vector in the APIC LVT:
+	 */
+	apic_val = apic_read(APIC_LVTERR);
+
+	apic_write(APIC_LVTERR, apic_val | APIC_LVT_MASKED);
+	if (nmi)
+		apic_write(APIC_LVTPC, APIC_DM_NMI);
+	else
+		apic_write(APIC_LVTPC, LOCAL_PERF_VECTOR);
+	apic_write(APIC_LVTERR, apic_val);
+}
+
+static int __kprobes
+perf_counter_nmi_handler(struct notifier_block *self,
+			 unsigned long cmd, void *__args)
+{
+	struct die_args *args = __args;
+	struct pt_regs *regs;
+
+	if (likely(cmd != DIE_NMI_IPI))
+		return NOTIFY_DONE;
+
+	regs = args->regs;
+
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	__smp_perf_counter_interrupt(regs, 1);
+
+	return NOTIFY_STOP;
+}
+
+static __read_mostly struct notifier_block perf_counter_nmi_notifier = {
+	.notifier_call		= perf_counter_nmi_handler
+};
+
+void __init init_hw_perf_counters(void)
+{
+	union cpuid10_eax eax;
+	unsigned int ebx;
+	unsigned int unused;
+	union cpuid10_edx edx;
+
+	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
+		return;
+
+	/*
+	 * Check whether the Architectural PerfMon supports
+	 * Branch Misses Retired Event or not.
+	 */
+	cpuid(10, &eax.full, &ebx, &unused, &edx.full);
+	if (eax.split.mask_length <= ARCH_PERFMON_BRANCH_MISSES_RETIRED)
+		return;
+
+	printk(KERN_INFO "Intel Performance Monitoring support detected.\n");
+
+	printk(KERN_INFO "... version:         %d\n", eax.split.version_id);
+	printk(KERN_INFO "... num counters:    %d\n", eax.split.num_counters);
+	nr_counters_generic = eax.split.num_counters;
+	if (nr_counters_generic > X86_PMC_MAX_GENERIC) {
+		nr_counters_generic = X86_PMC_MAX_GENERIC;
+		WARN(1, KERN_ERR "hw perf counters %d > max(%d), clipping!",
+			nr_counters_generic, X86_PMC_MAX_GENERIC);
+	}
+	perf_counter_mask = (1 << nr_counters_generic) - 1;
+	perf_max_counters = nr_counters_generic;
+
+	printk(KERN_INFO "... bit width:       %d\n", eax.split.bit_width);
+	counter_value_mask = (1ULL << eax.split.bit_width) - 1;
+	printk(KERN_INFO "... value mask:      %016Lx\n", counter_value_mask);
+
+	printk(KERN_INFO "... mask length:     %d\n", eax.split.mask_length);
+
+	nr_counters_fixed = edx.split.num_counters_fixed;
+	if (nr_counters_fixed > X86_PMC_MAX_FIXED) {
+		nr_counters_fixed = X86_PMC_MAX_FIXED;
+		WARN(1, KERN_ERR "hw perf counters fixed %d > max(%d), clipping!",
+			nr_counters_fixed, X86_PMC_MAX_FIXED);
+	}
+	printk(KERN_INFO "... fixed counters:  %d\n", nr_counters_fixed);
+
+	perf_counter_mask |= ((1LL << nr_counters_fixed)-1) << X86_PMC_IDX_FIXED;
+
+	printk(KERN_INFO "... counter mask:    %016Lx\n", perf_counter_mask);
+	perf_counters_initialized = true;
+
+	perf_counters_lapic_init(0);
+	register_die_notifier(&perf_counter_nmi_notifier);
+}
+
+static void pmc_generic_read(struct perf_counter *counter)
+{
+	x86_perf_counter_update(counter, &counter->hw, counter->hw.idx);
+}
+
+static const struct hw_perf_counter_ops x86_perf_counter_ops = {
+	.enable		= pmc_generic_enable,
+	.disable	= pmc_generic_disable,
+	.read		= pmc_generic_read,
+};
+
+const struct hw_perf_counter_ops *
+hw_perf_counter_init(struct perf_counter *counter)
+{
+	int err;
+
+	err = __hw_perf_counter_init(counter);
+	if (err)
+		return NULL;
+
+	return &x86_perf_counter_ops;
+}
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index 9abd48b..d6f5b9f 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -20,7 +20,7 @@
 #include <linux/kprobes.h>
 
 #include <asm/apic.h>
-#include <asm/intel_arch_perfmon.h>
+#include <asm/perf_counter.h>
 
 struct nmi_watchdog_ctlblk {
 	unsigned int cccr_msr;
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index c689d19..11b93ca 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -24,7 +24,7 @@
 #include <asm/apic.h>
 #include <asm/hpet.h>
 #include <linux/kdebug.h>
-#include <asm/smp.h>
+#include <asm/cpu.h>
 #include <asm/reboot.h>
 #include <asm/virtext.h>
 
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index c302d07..d35db59 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -106,7 +106,8 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		const struct stacktrace_ops *ops, void *data)
 {
 	const unsigned cpu = get_cpu();
-	unsigned long *irqstack_end = (unsigned long *)cpu_pda(cpu)->irqstackptr;
+	unsigned long *irq_stack_end =
+		(unsigned long *)per_cpu(irq_stack_ptr, cpu);
 	unsigned used = 0;
 	struct thread_info *tinfo;
 	int graph = 0;
@@ -160,23 +161,23 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 			stack = (unsigned long *) estack_end[-2];
 			continue;
 		}
-		if (irqstack_end) {
-			unsigned long *irqstack;
-			irqstack = irqstack_end -
-				(IRQSTACKSIZE - 64) / sizeof(*irqstack);
+		if (irq_stack_end) {
+			unsigned long *irq_stack;
+			irq_stack = irq_stack_end -
+				(IRQ_STACK_SIZE - 64) / sizeof(*irq_stack);
 
-			if (stack >= irqstack && stack < irqstack_end) {
+			if (stack >= irq_stack && stack < irq_stack_end) {
 				if (ops->stack(data, "IRQ") < 0)
 					break;
 				bp = print_context_stack(tinfo, stack, bp,
-					ops, data, irqstack_end, &graph);
+					ops, data, irq_stack_end, &graph);
 				/*
 				 * We link to the next stack (which would be
 				 * the process stack normally) the last
 				 * pointer (index -1 to end) in the IRQ stack:
 				 */
-				stack = (unsigned long *) (irqstack_end[-1]);
-				irqstack_end = NULL;
+				stack = (unsigned long *) (irq_stack_end[-1]);
+				irq_stack_end = NULL;
 				ops->stack(data, "EOI");
 				continue;
 			}
@@ -199,10 +200,10 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	unsigned long *stack;
 	int i;
 	const int cpu = smp_processor_id();
-	unsigned long *irqstack_end =
-		(unsigned long *) (cpu_pda(cpu)->irqstackptr);
-	unsigned long *irqstack =
-		(unsigned long *) (cpu_pda(cpu)->irqstackptr - IRQSTACKSIZE);
+	unsigned long *irq_stack_end =
+		(unsigned long *)(per_cpu(irq_stack_ptr, cpu));
+	unsigned long *irq_stack =
+		(unsigned long *)(per_cpu(irq_stack_ptr, cpu) - IRQ_STACK_SIZE);
 
 	/*
 	 * debugging aid: "show_stack(NULL, NULL);" prints the
@@ -218,9 +219,9 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 
 	stack = sp;
 	for (i = 0; i < kstack_depth_to_print; i++) {
-		if (stack >= irqstack && stack <= irqstack_end) {
-			if (stack == irqstack_end) {
-				stack = (unsigned long *) (irqstack_end[-1]);
+		if (stack >= irq_stack && stack <= irq_stack_end) {
+			if (stack == irq_stack_end) {
+				stack = (unsigned long *) (irq_stack_end[-1]);
 				printk(" <EOI> ");
 			}
 		} else {
@@ -241,7 +242,7 @@ void show_registers(struct pt_regs *regs)
 	int i;
 	unsigned long sp;
 	const int cpu = smp_processor_id();
-	struct task_struct *cur = cpu_pda(cpu)->pcurrent;
+	struct task_struct *cur = current;
 
 	sp = regs->sp;
 	printk("CPU %d ", cpu);
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e28c7a9..c092e7d 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -52,6 +52,7 @@
 #include <asm/irqflags.h>
 #include <asm/paravirt.h>
 #include <asm/ftrace.h>
+#include <asm/percpu.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
 #include <linux/elf-em.h>
@@ -209,7 +210,7 @@ ENTRY(native_usergs_sysret64)
 
 	/* %rsp:at FRAMEEND */
 	.macro FIXUP_TOP_OF_STACK tmp offset=0
-	movq %gs:pda_oldrsp,\tmp
+	movq PER_CPU_VAR(old_rsp),\tmp
 	movq \tmp,RSP+\offset(%rsp)
 	movq $__USER_DS,SS+\offset(%rsp)
 	movq $__USER_CS,CS+\offset(%rsp)
@@ -220,7 +221,7 @@ ENTRY(native_usergs_sysret64)
 
 	.macro RESTORE_TOP_OF_STACK tmp offset=0
 	movq RSP+\offset(%rsp),\tmp
-	movq \tmp,%gs:pda_oldrsp
+	movq \tmp,PER_CPU_VAR(old_rsp)
 	movq EFLAGS+\offset(%rsp),\tmp
 	movq \tmp,R11+\offset(%rsp)
 	.endm
@@ -336,15 +337,15 @@ ENTRY(save_args)
 	je 1f
 	SWAPGS
 	/*
-	 * irqcount is used to check if a CPU is already on an interrupt stack
+	 * irq_count is used to check if a CPU is already on an interrupt stack
 	 * or not. While this is essentially redundant with preempt_count it is
 	 * a little cheaper to use a separate counter in the PDA (short of
 	 * moving irq_enter into assembly, which would be too much work)
 	 */
-1:	incl %gs:pda_irqcount
+1:	incl PER_CPU_VAR(irq_count)
 	jne 2f
 	popq_cfi %rax			/* move return address... */
-	mov %gs:pda_irqstackptr,%rsp
+	mov PER_CPU_VAR(irq_stack_ptr),%rsp
 	EMPTY_FRAME 0
 	pushq_cfi %rax			/* ... to the new stack */
 	/*
@@ -467,7 +468,7 @@ END(ret_from_fork)
 ENTRY(system_call)
 	CFI_STARTPROC	simple
 	CFI_SIGNAL_FRAME
-	CFI_DEF_CFA	rsp,PDA_STACKOFFSET
+	CFI_DEF_CFA	rsp,KERNEL_STACK_OFFSET
 	CFI_REGISTER	rip,rcx
 	/*CFI_REGISTER	rflags,r11*/
 	SWAPGS_UNSAFE_STACK
@@ -478,8 +479,8 @@ ENTRY(system_call)
 	 */
 ENTRY(system_call_after_swapgs)
 
-	movq	%rsp,%gs:pda_oldrsp
-	movq	%gs:pda_kernelstack,%rsp
+	movq	%rsp,PER_CPU_VAR(old_rsp)
+	movq	PER_CPU_VAR(kernel_stack),%rsp
 	/*
 	 * No need to follow this irqs off/on section - it's straight
 	 * and short:
@@ -522,7 +523,7 @@ sysret_check:
 	CFI_REGISTER	rip,rcx
 	RESTORE_ARGS 0,-ARG_SKIP,1
 	/*CFI_REGISTER	rflags,r11*/
-	movq	%gs:pda_oldrsp, %rsp
+	movq	PER_CPU_VAR(old_rsp), %rsp
 	USERGS_SYSRET64
 
 	CFI_RESTORE_STATE
@@ -832,11 +833,11 @@ common_interrupt:
 	XCPT_FRAME
 	addq $-0x80,(%rsp)		/* Adjust vector to [-256,-1] range */
 	interrupt do_IRQ
-	/* 0(%rsp): oldrsp-ARGOFFSET */
+	/* 0(%rsp): old_rsp-ARGOFFSET */
 ret_from_intr:
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	decl %gs:pda_irqcount
+	decl PER_CPU_VAR(irq_count)
 	leaveq
 	CFI_DEF_CFA_REGISTER	rsp
 	CFI_ADJUST_CFA_OFFSET	-8
@@ -1024,6 +1025,11 @@ apicinterrupt ERROR_APIC_VECTOR \
 apicinterrupt SPURIOUS_APIC_VECTOR \
 	spurious_interrupt smp_spurious_interrupt
 
+#ifdef CONFIG_PERF_COUNTERS
+apicinterrupt LOCAL_PERF_VECTOR \
+	perf_counter_interrupt smp_perf_counter_interrupt
+#endif
+
 /*
  * Exception entry points.
  */
@@ -1072,10 +1078,10 @@ ENTRY(\sym)
 	TRACE_IRQS_OFF
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
-	movq %gs:pda_data_offset, %rbp
-	subq $EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
+	PER_CPU(init_tss, %rbp)
+	subq $EXCEPTION_STKSZ, TSS_ist + (\ist - 1) * 8(%rbp)
 	call \do_sym
-	addq $EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
+	addq $EXCEPTION_STKSZ, TSS_ist + (\ist - 1) * 8(%rbp)
 	jmp paranoid_exit	/* %ebx: no swapgs flag */
 	CFI_ENDPROC
 END(\sym)
@@ -1259,14 +1265,14 @@ ENTRY(call_softirq)
 	CFI_REL_OFFSET rbp,0
 	mov  %rsp,%rbp
 	CFI_DEF_CFA_REGISTER rbp
-	incl %gs:pda_irqcount
-	cmove %gs:pda_irqstackptr,%rsp
+	incl PER_CPU_VAR(irq_count)
+	cmove PER_CPU_VAR(irq_stack_ptr),%rsp
 	push  %rbp			# backlink for old unwinder
 	call __do_softirq
 	leaveq
 	CFI_DEF_CFA_REGISTER	rsp
 	CFI_ADJUST_CFA_OFFSET   -8
-	decl %gs:pda_irqcount
+	decl PER_CPU_VAR(irq_count)
 	ret
 	CFI_ENDPROC
 END(call_softirq)
@@ -1296,15 +1302,15 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 	movq %rdi, %rsp            # we don't return, adjust the stack frame
 	CFI_ENDPROC
 	DEFAULT_FRAME
-11:	incl %gs:pda_irqcount
+11:	incl PER_CPU_VAR(irq_count)
 	movq %rsp,%rbp
 	CFI_DEF_CFA_REGISTER rbp
-	cmovzq %gs:pda_irqstackptr,%rsp
+	cmovzq PER_CPU_VAR(irq_stack_ptr),%rsp
 	pushq %rbp			# backlink for old unwinder
 	call xen_evtchn_do_upcall
 	popq %rsp
 	CFI_DEF_CFA_REGISTER rsp
-	decl %gs:pda_irqcount
+	decl PER_CPU_VAR(irq_count)
 	jmp  error_exit
 	CFI_ENDPROC
 END(do_hypervisor_callback)
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index b9a4d8c..af67d32 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -26,27 +26,6 @@
 #include <asm/bios_ebda.h>
 #include <asm/trampoline.h>
 
-/* boot cpu pda */
-static struct x8664_pda _boot_cpu_pda;
-
-#ifdef CONFIG_SMP
-/*
- * We install an empty cpu_pda pointer table to indicate to early users
- * (numa_set_node) that the cpu_pda pointer table for cpus other than
- * the boot cpu is not yet setup.
- */
-static struct x8664_pda *__cpu_pda[NR_CPUS] __initdata;
-#else
-static struct x8664_pda *__cpu_pda[NR_CPUS] __read_mostly;
-#endif
-
-void __init x86_64_init_pda(void)
-{
-	_cpu_pda = __cpu_pda;
-	cpu_pda(0) = &_boot_cpu_pda;
-	pda_init(0);
-}
-
 static void __init zap_identity_mappings(void)
 {
 	pgd_t *pgd = pgd_offset_k(0UL);
@@ -112,7 +91,7 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	if (console_loglevel == 10)
 		early_printk("Kernel alive\n");
 
-	x86_64_init_pda();
+	pda_init(0);
 
 	x86_64_start_reservations(real_mode_data);
 }
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 0e275d4..c8ace88 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -19,6 +19,7 @@
 #include <asm/msr.h>
 #include <asm/cache.h>
 #include <asm/processor-flags.h>
+#include <asm/percpu.h>
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/asm-offsets.h>
@@ -204,6 +205,23 @@ ENTRY(secondary_startup_64)
 	pushq $0
 	popfq
 
+#ifdef CONFIG_SMP
+	/*
+	 * early_gdt_base should point to the gdt_page in static percpu init
+	 * data area.  Computing this requires two symbols - __per_cpu_load
+	 * and per_cpu__gdt_page.  As linker can't do no such relocation, do
+	 * it by hand.  As early_gdt_descr is manipulated by C code for
+	 * secondary CPUs, this should be done only once for the boot CPU
+	 * when early_gdt_descr_base contains zero.
+	 */
+	movq	early_gdt_descr_base(%rip), %rax
+	testq	%rax, %rax
+	jnz	1f
+	movq	$__per_cpu_load, %rax
+	addq	$per_cpu__gdt_page, %rax
+	movq	%rax, early_gdt_descr_base(%rip)
+1:
+#endif
 	/*
 	 * We must switch to a new descriptor in kernel space for the GDT
 	 * because soon the kernel won't have access anymore to the userspace
@@ -226,12 +244,18 @@ ENTRY(secondary_startup_64)
 	movl %eax,%fs
 	movl %eax,%gs
 
-	/* 
-	 * Setup up a dummy PDA. this is just for some early bootup code
-	 * that does in_interrupt() 
-	 */ 
+	/* Set up %gs.
+	 *
+	 * On SMP, %gs should point to the per-cpu area.  For initial
+	 * boot, make %gs point to the init data section.  For a
+	 * secondary CPU,initial_gs should be set to its pda address
+	 * before the CPU runs this code.
+	 *
+	 * On UP, initial_gs points to PER_CPU_VAR(__pda) and doesn't
+	 * change.
+	 */
 	movl	$MSR_GS_BASE,%ecx
-	movq	$empty_zero_page,%rax
+	movq	initial_gs(%rip),%rax
 	movq    %rax,%rdx
 	shrq	$32,%rdx
 	wrmsr	
@@ -257,6 +281,12 @@ ENTRY(secondary_startup_64)
 	.align	8
 	ENTRY(initial_code)
 	.quad	x86_64_start_kernel
+	ENTRY(initial_gs)
+#ifdef CONFIG_SMP
+	.quad	__per_cpu_load
+#else
+	.quad	PER_CPU_VAR(__pda)
+#endif
 	__FINITDATA
 
 	ENTRY(stack_start)
@@ -401,7 +431,12 @@ NEXT_PAGE(level2_spare_pgt)
 	.globl early_gdt_descr
 early_gdt_descr:
 	.word	GDT_ENTRIES*8-1
-	.quad   per_cpu__gdt_page
+#ifdef CONFIG_SMP
+early_gdt_descr_base:
+	.quad   0x0000000000000000
+#else
+	.quad	per_cpu__gdt_page
+#endif
 
 ENTRY(phys_base)
 	/* This must match the first entry in level2_kernel_pgt */
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 1c4a130..f796603 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -46,6 +46,7 @@
 #include <asm/idle.h>
 #include <asm/io.h>
 #include <asm/smp.h>
+#include <asm/cpu.h>
 #include <asm/desc.h>
 #include <asm/proto.h>
 #include <asm/acpi.h>
@@ -82,11 +83,11 @@ static DEFINE_SPINLOCK(vector_lock);
 int nr_ioapic_registers[MAX_IO_APICS];
 
 /* I/O APIC entries */
-struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
+struct mpc_ioapic mp_ioapics[MAX_IO_APICS];
 int nr_ioapics;
 
 /* MP IRQ source entries */
-struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
+struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 
 /* # of MP IRQ source entries */
 int mp_irq_entries;
@@ -356,7 +357,7 @@ set_extra_move_desc(struct irq_desc *desc, const struct cpumask *mask)
 
 	if (!cfg->move_in_progress) {
 		/* it means that domain is not changed */
-		if (!cpumask_intersects(&desc->affinity, mask))
+		if (!cpumask_intersects(desc->affinity, mask))
 			cfg->move_desc_pending = 1;
 	}
 }
@@ -386,7 +387,7 @@ struct io_apic {
 static __attribute_const__ struct io_apic __iomem *io_apic_base(int idx)
 {
 	return (void __iomem *) __fix_to_virt(FIX_IO_APIC_BASE_0 + idx)
-		+ (mp_ioapics[idx].mp_apicaddr & ~PAGE_MASK);
+		+ (mp_ioapics[idx].apicaddr & ~PAGE_MASK);
 }
 
 static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
@@ -579,9 +580,9 @@ set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
 	if (assign_irq_vector(irq, cfg, mask))
 		return BAD_APICID;
 
-	cpumask_and(&desc->affinity, cfg->domain, mask);
+	cpumask_and(desc->affinity, cfg->domain, mask);
 	set_extra_move_desc(desc, mask);
-	return cpu_mask_to_apicid_and(&desc->affinity, cpu_online_mask);
+	return cpu_mask_to_apicid_and(desc->affinity, cpu_online_mask);
 }
 
 static void
@@ -944,10 +945,10 @@ static int find_irq_entry(int apic, int pin, int type)
 	int i;
 
 	for (i = 0; i < mp_irq_entries; i++)
-		if (mp_irqs[i].mp_irqtype == type &&
-		    (mp_irqs[i].mp_dstapic == mp_ioapics[apic].mp_apicid ||
-		     mp_irqs[i].mp_dstapic == MP_APIC_ALL) &&
-		    mp_irqs[i].mp_dstirq == pin)
+		if (mp_irqs[i].irqtype == type &&
+		    (mp_irqs[i].dstapic == mp_ioapics[apic].apicid ||
+		     mp_irqs[i].dstapic == MP_APIC_ALL) &&
+		    mp_irqs[i].dstirq == pin)
 			return i;
 
 	return -1;
@@ -961,13 +962,13 @@ static int __init find_isa_irq_pin(int irq, int type)
 	int i;
 
 	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].mp_srcbus;
+		int lbus = mp_irqs[i].srcbus;
 
 		if (test_bit(lbus, mp_bus_not_pci) &&
-		    (mp_irqs[i].mp_irqtype == type) &&
-		    (mp_irqs[i].mp_srcbusirq == irq))
+		    (mp_irqs[i].irqtype == type) &&
+		    (mp_irqs[i].srcbusirq == irq))
 
-			return mp_irqs[i].mp_dstirq;
+			return mp_irqs[i].dstirq;
 	}
 	return -1;
 }
@@ -977,17 +978,17 @@ static int __init find_isa_irq_apic(int irq, int type)
 	int i;
 
 	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].mp_srcbus;
+		int lbus = mp_irqs[i].srcbus;
 
 		if (test_bit(lbus, mp_bus_not_pci) &&
-		    (mp_irqs[i].mp_irqtype == type) &&
-		    (mp_irqs[i].mp_srcbusirq == irq))
+		    (mp_irqs[i].irqtype == type) &&
+		    (mp_irqs[i].srcbusirq == irq))
 			break;
 	}
 	if (i < mp_irq_entries) {
 		int apic;
 		for(apic = 0; apic < nr_ioapics; apic++) {
-			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mp_dstapic)
+			if (mp_ioapics[apic].apicid == mp_irqs[i].dstapic)
 				return apic;
 		}
 	}
@@ -1012,23 +1013,23 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 		return -1;
 	}
 	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].mp_srcbus;
+		int lbus = mp_irqs[i].srcbus;
 
 		for (apic = 0; apic < nr_ioapics; apic++)
-			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mp_dstapic ||
-			    mp_irqs[i].mp_dstapic == MP_APIC_ALL)
+			if (mp_ioapics[apic].apicid == mp_irqs[i].dstapic ||
+			    mp_irqs[i].dstapic == MP_APIC_ALL)
 				break;
 
 		if (!test_bit(lbus, mp_bus_not_pci) &&
-		    !mp_irqs[i].mp_irqtype &&
+		    !mp_irqs[i].irqtype &&
 		    (bus == lbus) &&
-		    (slot == ((mp_irqs[i].mp_srcbusirq >> 2) & 0x1f))) {
-			int irq = pin_2_irq(i,apic,mp_irqs[i].mp_dstirq);
+		    (slot == ((mp_irqs[i].srcbusirq >> 2) & 0x1f))) {
+			int irq = pin_2_irq(i, apic, mp_irqs[i].dstirq);
 
 			if (!(apic || IO_APIC_IRQ(irq)))
 				continue;
 
-			if (pin == (mp_irqs[i].mp_srcbusirq & 3))
+			if (pin == (mp_irqs[i].srcbusirq & 3))
 				return irq;
 			/*
 			 * Use the first all-but-pin matching entry as a
@@ -1071,7 +1072,7 @@ static int EISA_ELCR(unsigned int irq)
  * EISA conforming in the MP table, that means its trigger type must
  * be read in from the ELCR */
 
-#define default_EISA_trigger(idx)	(EISA_ELCR(mp_irqs[idx].mp_srcbusirq))
+#define default_EISA_trigger(idx)	(EISA_ELCR(mp_irqs[idx].srcbusirq))
 #define default_EISA_polarity(idx)	default_ISA_polarity(idx)
 
 /* PCI interrupts are always polarity one level triggered,
@@ -1088,13 +1089,13 @@ static int EISA_ELCR(unsigned int irq)
 
 static int MPBIOS_polarity(int idx)
 {
-	int bus = mp_irqs[idx].mp_srcbus;
+	int bus = mp_irqs[idx].srcbus;
 	int polarity;
 
 	/*
 	 * Determine IRQ line polarity (high active or low active):
 	 */
-	switch (mp_irqs[idx].mp_irqflag & 3)
+	switch (mp_irqs[idx].irqflag & 3)
 	{
 		case 0: /* conforms, ie. bus-type dependent polarity */
 			if (test_bit(bus, mp_bus_not_pci))
@@ -1130,13 +1131,13 @@ static int MPBIOS_polarity(int idx)
 
 static int MPBIOS_trigger(int idx)
 {
-	int bus = mp_irqs[idx].mp_srcbus;
+	int bus = mp_irqs[idx].srcbus;
 	int trigger;
 
 	/*
 	 * Determine IRQ trigger mode (edge or level sensitive):
 	 */
-	switch ((mp_irqs[idx].mp_irqflag>>2) & 3)
+	switch ((mp_irqs[idx].irqflag>>2) & 3)
 	{
 		case 0: /* conforms, ie. bus-type dependent */
 			if (test_bit(bus, mp_bus_not_pci))
@@ -1214,16 +1215,16 @@ int (*ioapic_renumber_irq)(int ioapic, int irq);
 static int pin_2_irq(int idx, int apic, int pin)
 {
 	int irq, i;
-	int bus = mp_irqs[idx].mp_srcbus;
+	int bus = mp_irqs[idx].srcbus;
 
 	/*
 	 * Debugging check, we are in big trouble if this message pops up!
 	 */
-	if (mp_irqs[idx].mp_dstirq != pin)
+	if (mp_irqs[idx].dstirq != pin)
 		printk(KERN_ERR "broken BIOS or MPTABLE parser, ayiee!!\n");
 
 	if (test_bit(bus, mp_bus_not_pci)) {
-		irq = mp_irqs[idx].mp_srcbusirq;
+		irq = mp_irqs[idx].srcbusirq;
 	} else {
 		/*
 		 * PCI IRQs are mapped in order
@@ -1566,14 +1567,14 @@ static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq, struct irq_de
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
 		    "IRQ %d Mode:%i Active:%i)\n",
-		    apic, mp_ioapics[apic].mp_apicid, pin, cfg->vector,
+		    apic, mp_ioapics[apic].apicid, pin, cfg->vector,
 		    irq, trigger, polarity);
 
 
-	if (setup_ioapic_entry(mp_ioapics[apic].mp_apicid, irq, &entry,
+	if (setup_ioapic_entry(mp_ioapics[apic].apicid, irq, &entry,
 			       dest, trigger, polarity, cfg->vector)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
-		       mp_ioapics[apic].mp_apicid, pin);
+		       mp_ioapics[apic].apicid, pin);
 		__clear_irq_vector(irq, cfg);
 		return;
 	}
@@ -1604,12 +1605,10 @@ static void __init setup_IO_APIC_irqs(void)
 					notcon = 1;
 					apic_printk(APIC_VERBOSE,
 						KERN_DEBUG " %d-%d",
-						mp_ioapics[apic].mp_apicid,
-						pin);
+						mp_ioapics[apic].apicid, pin);
 				} else
 					apic_printk(APIC_VERBOSE, " %d-%d",
-						mp_ioapics[apic].mp_apicid,
-						pin);
+						mp_ioapics[apic].apicid, pin);
 				continue;
 			}
 			if (notcon) {
@@ -1699,7 +1698,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for (i = 0; i < nr_ioapics; i++)
 		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
-		       mp_ioapics[i].mp_apicid, nr_ioapic_registers[i]);
+		       mp_ioapics[i].apicid, nr_ioapic_registers[i]);
 
 	/*
 	 * We are a bit conservative about what we expect.  We have to
@@ -1719,7 +1718,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	printk("\n");
-	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].mp_apicid);
+	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].apicid);
 	printk(KERN_DEBUG ".... register #00: %08X\n", reg_00.raw);
 	printk(KERN_DEBUG ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
 	printk(KERN_DEBUG ".......    : Delivery Type: %X\n", reg_00.bits.delivery_type);
@@ -2121,14 +2120,14 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		reg_00.raw = io_apic_read(apic, 0);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
 
-		old_id = mp_ioapics[apic].mp_apicid;
+		old_id = mp_ioapics[apic].apicid;
 
-		if (mp_ioapics[apic].mp_apicid >= get_physical_broadcast()) {
+		if (mp_ioapics[apic].apicid >= get_physical_broadcast()) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
-				apic, mp_ioapics[apic].mp_apicid);
+				apic, mp_ioapics[apic].apicid);
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				reg_00.bits.ID);
-			mp_ioapics[apic].mp_apicid = reg_00.bits.ID;
+			mp_ioapics[apic].apicid = reg_00.bits.ID;
 		}
 
 		/*
@@ -2137,9 +2136,9 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		 * 'stuck on smp_invalidate_needed IPI wait' messages.
 		 */
 		if (check_apicid_used(phys_id_present_map,
-					mp_ioapics[apic].mp_apicid)) {
+					mp_ioapics[apic].apicid)) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
-				apic, mp_ioapics[apic].mp_apicid);
+				apic, mp_ioapics[apic].apicid);
 			for (i = 0; i < get_physical_broadcast(); i++)
 				if (!physid_isset(i, phys_id_present_map))
 					break;
@@ -2148,13 +2147,13 @@ static void __init setup_ioapic_ids_from_mpc(void)
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				i);
 			physid_set(i, phys_id_present_map);
-			mp_ioapics[apic].mp_apicid = i;
+			mp_ioapics[apic].apicid = i;
 		} else {
 			physid_mask_t tmp;
-			tmp = apicid_to_cpu_present(mp_ioapics[apic].mp_apicid);
+			tmp = apicid_to_cpu_present(mp_ioapics[apic].apicid);
 			apic_printk(APIC_VERBOSE, "Setting %d in the "
 					"phys_id_present_map\n",
-					mp_ioapics[apic].mp_apicid);
+					mp_ioapics[apic].apicid);
 			physids_or(phys_id_present_map, phys_id_present_map, tmp);
 		}
 
@@ -2163,11 +2162,11 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		 * We need to adjust the IRQ routing table
 		 * if the ID changed.
 		 */
-		if (old_id != mp_ioapics[apic].mp_apicid)
+		if (old_id != mp_ioapics[apic].apicid)
 			for (i = 0; i < mp_irq_entries; i++)
-				if (mp_irqs[i].mp_dstapic == old_id)
-					mp_irqs[i].mp_dstapic
-						= mp_ioapics[apic].mp_apicid;
+				if (mp_irqs[i].dstapic == old_id)
+					mp_irqs[i].dstapic
+						= mp_ioapics[apic].apicid;
 
 		/*
 		 * Read the right value from the MPC table and
@@ -2175,9 +2174,9 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		 */
 		apic_printk(APIC_VERBOSE, KERN_INFO
 			"...changing IO-APIC physical APIC ID to %d ...",
-			mp_ioapics[apic].mp_apicid);
+			mp_ioapics[apic].apicid);
 
-		reg_00.bits.ID = mp_ioapics[apic].mp_apicid;
+		reg_00.bits.ID = mp_ioapics[apic].apicid;
 		spin_lock_irqsave(&ioapic_lock, flags);
 		io_apic_write(apic, 0, reg_00.raw);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
@@ -2188,7 +2187,7 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		spin_lock_irqsave(&ioapic_lock, flags);
 		reg_00.raw = io_apic_read(apic, 0);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
-		if (reg_00.bits.ID != mp_ioapics[apic].mp_apicid)
+		if (reg_00.bits.ID != mp_ioapics[apic].apicid)
 			printk("could not set ID!\n");
 		else
 			apic_printk(APIC_VERBOSE, " ok.\n");
@@ -2383,7 +2382,7 @@ migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 	if (cfg->move_in_progress)
 		send_cleanup_vector(cfg);
 
-	cpumask_copy(&desc->affinity, mask);
+	cpumask_copy(desc->affinity, mask);
 }
 
 static int migrate_irq_remapped_level_desc(struct irq_desc *desc)
@@ -2405,11 +2404,11 @@ static int migrate_irq_remapped_level_desc(struct irq_desc *desc)
 	}
 
 	/* everthing is clear. we have right of way */
-	migrate_ioapic_irq_desc(desc, &desc->pending_mask);
+	migrate_ioapic_irq_desc(desc, desc->pending_mask);
 
 	ret = 0;
 	desc->status &= ~IRQ_MOVE_PENDING;
-	cpumask_clear(&desc->pending_mask);
+	cpumask_clear(desc->pending_mask);
 
 unmask:
 	unmask_IO_APIC_irq_desc(desc);
@@ -2434,7 +2433,7 @@ static void ir_irq_migration(struct work_struct *work)
 				continue;
 			}
 
-			desc->chip->set_affinity(irq, &desc->pending_mask);
+			desc->chip->set_affinity(irq, desc->pending_mask);
 			spin_unlock_irqrestore(&desc->lock, flags);
 		}
 	}
@@ -2448,7 +2447,7 @@ static void set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc,
 {
 	if (desc->status & IRQ_LEVEL) {
 		desc->status |= IRQ_MOVE_PENDING;
-		cpumask_copy(&desc->pending_mask, mask);
+		cpumask_copy(desc->pending_mask, mask);
 		migrate_irq_remapped_level_desc(desc);
 		return;
 	}
@@ -2516,7 +2515,7 @@ static void irq_complete_move(struct irq_desc **descp)
 
 		/* domain has not changed, but affinity did */
 		me = smp_processor_id();
-		if (cpu_isset(me, desc->affinity)) {
+		if (cpumask_test_cpu(me, desc->affinity)) {
 			*descp = desc = move_irq_desc(desc, me);
 			/* get the new one */
 			cfg = desc->chip_data;
@@ -3117,8 +3116,8 @@ static int ioapic_resume(struct sys_device *dev)
 
 	spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(dev->id, 0);
-	if (reg_00.bits.ID != mp_ioapics[dev->id].mp_apicid) {
-		reg_00.bits.ID = mp_ioapics[dev->id].mp_apicid;
+	if (reg_00.bits.ID != mp_ioapics[dev->id].apicid) {
+		reg_00.bits.ID = mp_ioapics[dev->id].apicid;
 		io_apic_write(dev->id, 0, reg_00.raw);
 	}
 	spin_unlock_irqrestore(&ioapic_lock, flags);
@@ -3183,7 +3182,7 @@ unsigned int create_irq_nr(unsigned int irq_want)
 
 	irq = 0;
 	spin_lock_irqsave(&vector_lock, flags);
-	for (new = irq_want; new < NR_IRQS; new++) {
+	for (new = irq_want; new < nr_irqs; new++) {
 		if (platform_legacy_irq(new))
 			continue;
 
@@ -3258,6 +3257,9 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 	int err;
 	unsigned dest;
 
+	if (disable_apic)
+		return -ENXIO;
+
 	cfg = irq_cfg(irq);
 	err = assign_irq_vector(irq, cfg, TARGET_CPUS);
 	if (err)
@@ -3726,6 +3728,9 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 	struct irq_cfg *cfg;
 	int err;
 
+	if (disable_apic)
+		return -ENXIO;
+
 	cfg = irq_cfg(irq);
 	err = assign_irq_vector(irq, cfg, TARGET_CPUS);
 	if (!err) {
@@ -3850,6 +3855,22 @@ void __init probe_nr_irqs_gsi(void)
 		nr_irqs_gsi = nr;
 }
 
+#ifdef CONFIG_SPARSE_IRQ
+int __init arch_probe_nr_irqs(void)
+{
+	int nr;
+
+	nr = ((8 * nr_cpu_ids) > (32 * nr_ioapics) ?
+		(NR_VECTORS + (8 * nr_cpu_ids)) :
+		(NR_VECTORS + (32 * nr_ioapics)));
+
+	if (nr < nr_irqs && nr > nr_irqs_gsi)
+		nr_irqs = nr;
+
+	return 0;
+}
+#endif
+
 /* --------------------------------------------------------------------------
                           ACPI-based IOAPIC Configuration
    -------------------------------------------------------------------------- */
@@ -3984,8 +4005,8 @@ int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 		return -1;
 
 	for (i = 0; i < mp_irq_entries; i++)
-		if (mp_irqs[i].mp_irqtype == mp_INT &&
-		    mp_irqs[i].mp_srcbusirq == bus_irq)
+		if (mp_irqs[i].irqtype == mp_INT &&
+		    mp_irqs[i].srcbusirq == bus_irq)
 			break;
 	if (i >= mp_irq_entries)
 		return -1;
@@ -4039,7 +4060,7 @@ void __init setup_ioapic_dest(void)
 			 */
 			if (desc->status &
 			    (IRQ_NO_BALANCING | IRQ_AFFINITY_SET))
-				mask = &desc->affinity;
+				mask = desc->affinity;
 			else
 				mask = TARGET_CPUS;
 
@@ -4100,7 +4121,7 @@ void __init ioapic_init_mappings(void)
 	ioapic_res = ioapic_setup_resources();
 	for (i = 0; i < nr_ioapics; i++) {
 		if (smp_found_config) {
-			ioapic_phys = mp_ioapics[i].mp_apicaddr;
+			ioapic_phys = mp_ioapics[i].apicaddr;
 #ifdef CONFIG_X86_32
 			if (!ioapic_phys) {
 				printk(KERN_ERR
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3973e2d..a6bca1d 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -36,11 +36,7 @@ void ack_bad_irq(unsigned int irq)
 #endif
 }
 
-#ifdef CONFIG_X86_32
-# define irq_stats(x)		(&per_cpu(irq_stat, x))
-#else
-# define irq_stats(x)		cpu_pda(x)
-#endif
+#define irq_stats(x)		(&per_cpu(irq_stat, x))
 /*
  * /proc/interrupts printing:
  */
@@ -57,6 +53,10 @@ static int show_other_interrupts(struct seq_file *p)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_timer_irqs);
 	seq_printf(p, "  Local timer interrupts\n");
+	seq_printf(p, "CNT: ");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
+	seq_printf(p, "  Performance counter interrupts\n");
 #endif
 #ifdef CONFIG_SMP
 	seq_printf(p, "RES: ");
@@ -164,6 +164,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	sum += irq_stats(cpu)->apic_timer_irqs;
+	sum += irq_stats(cpu)->apic_perf_irqs;
 #endif
 #ifdef CONFIG_SMP
 	sum += irq_stats(cpu)->irq_resched_count;
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 74b9ff7..e0f29be 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -248,7 +248,7 @@ void fixup_irqs(void)
 		if (irq == 2)
 			continue;
 
-		affinity = &desc->affinity;
+		affinity = desc->affinity;
 		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
 			printk("Breaking affinity for irq %i\n", irq);
 			affinity = cpu_all_mask;
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 63c88e6..1db0524 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -19,6 +19,9 @@
 #include <asm/io_apic.h>
 #include <asm/idle.h>
 
+DEFINE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
+EXPORT_PER_CPU_SYMBOL(irq_stat);
+
 /*
  * Probabilistic stack overflow check:
  *
@@ -100,7 +103,7 @@ void fixup_irqs(void)
 		/* interrupt's are disabled at this point */
 		spin_lock(&desc->lock);
 
-		affinity = &desc->affinity;
+		affinity = desc->affinity;
 		if (!irq_has_action(irq) ||
 		    cpumask_equal(affinity, cpu_online_mask)) {
 			spin_unlock(&desc->lock);
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 1507ad4..0bef628 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -171,6 +171,9 @@ void __init native_init_IRQ(void)
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+# ifdef CONFIG_PERF_COUNTERS
+	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
+# endif
 #endif
 
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_MCE_P4THERMAL)
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index da481a1..6a71bfc 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -150,6 +150,11 @@ static void __init apic_intr_init(void)
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+
+	/* Performance monitoring interrupt: */
+#ifdef CONFIG_PERF_COUNTERS
+	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
+#endif
 }
 
 void __init native_init_IRQ(void)
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index b7f4c92..5e9f4fc 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -87,9 +87,9 @@
 #include <linux/cpu.h>
 #include <linux/firmware.h>
 #include <linux/platform_device.h>
+#include <linux/uaccess.h>
 
 #include <asm/msr.h>
-#include <asm/uaccess.h>
 #include <asm/processor.h>
 #include <asm/microcode.h>
 
@@ -196,7 +196,7 @@ static inline int update_match_cpu(struct cpu_signature *csig, int sig, int pf)
 	return (!sigmatch(sig, csig->sig, pf, csig->pf)) ? 0 : 1;
 }
 
-static inline int 
+static inline int
 update_match_revision(struct microcode_header_intel *mc_header,	int rev)
 {
 	return (mc_header->rev <= rev) ? 0 : 1;
@@ -442,8 +442,8 @@ static int request_microcode_fw(int cpu, struct device *device)
 		return ret;
 	}
 
-	ret = generic_load_microcode(cpu, (void*)firmware->data, firmware->size,
-			&get_ucode_fw);
+	ret = generic_load_microcode(cpu, (void *)firmware->data,
+				     firmware->size, &get_ucode_fw);
 
 	release_firmware(firmware);
 
@@ -460,7 +460,7 @@ static int request_microcode_user(int cpu, const void __user *buf, size_t size)
 	/* We should bind the task to the CPU */
 	BUG_ON(cpu != raw_smp_processor_id());
 
-	return generic_load_microcode(cpu, (void*)buf, size, &get_ucode_user);
+	return generic_load_microcode(cpu, (void *)buf, size, &get_ucode_user);
 }
 
 static void microcode_fini_cpu(int cpu)
diff --git a/arch/x86/kernel/module_32.c b/arch/x86/kernel/module_32.c
index 3db0a54..0edd819 100644
--- a/arch/x86/kernel/module_32.c
+++ b/arch/x86/kernel/module_32.c
@@ -42,7 +42,7 @@ void module_free(struct module *mod, void *module_region)
 {
 	vfree(module_region);
 	/* FIXME: If module_region == mod->init_region, trim exception
-           table entries. */
+	   table entries. */
 }
 
 /* We don't need anything special. */
@@ -113,13 +113,13 @@ int module_finalize(const Elf_Ehdr *hdr,
 		*para = NULL;
 	char *secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
 
-	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) { 
+	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) {
 		if (!strcmp(".text", secstrings + s->sh_name))
 			text = s;
 		if (!strcmp(".altinstructions", secstrings + s->sh_name))
 			alt = s;
 		if (!strcmp(".smp_locks", secstrings + s->sh_name))
-			locks= s;
+			locks = s;
 		if (!strcmp(".parainstructions", secstrings + s->sh_name))
 			para = s;
 	}
diff --git a/arch/x86/kernel/module_64.c b/arch/x86/kernel/module_64.c
index 6ba8783..c23880b 100644
--- a/arch/x86/kernel/module_64.c
+++ b/arch/x86/kernel/module_64.c
@@ -30,14 +30,14 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 
-#define DEBUGP(fmt...) 
+#define DEBUGP(fmt...)
 
 #ifndef CONFIG_UML
 void module_free(struct module *mod, void *module_region)
 {
 	vfree(module_region);
 	/* FIXME: If module_region == mod->init_region, trim exception
-           table entries. */
+	   table entries. */
 }
 
 void *module_alloc(unsigned long size)
@@ -77,7 +77,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 	Elf64_Rela *rel = (void *)sechdrs[relsec].sh_addr;
 	Elf64_Sym *sym;
 	void *loc;
-	u64 val; 
+	u64 val;
 
 	DEBUGP("Applying relocate section %u to %u\n", relsec,
 	       sechdrs[relsec].sh_info);
@@ -91,11 +91,11 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 		sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
 			+ ELF64_R_SYM(rel[i].r_info);
 
-	        DEBUGP("type %d st_value %Lx r_addend %Lx loc %Lx\n",
-		       (int)ELF64_R_TYPE(rel[i].r_info), 
-		       sym->st_value, rel[i].r_addend, (u64)loc);
+		DEBUGP("type %d st_value %Lx r_addend %Lx loc %Lx\n",
+			(int)ELF64_R_TYPE(rel[i].r_info),
+			sym->st_value, rel[i].r_addend, (u64)loc);
 
-		val = sym->st_value + rel[i].r_addend; 
+		val = sym->st_value + rel[i].r_addend;
 
 		switch (ELF64_R_TYPE(rel[i].r_info)) {
 		case R_X86_64_NONE:
@@ -113,16 +113,16 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 			if ((s64)val != *(s32 *)loc)
 				goto overflow;
 			break;
-		case R_X86_64_PC32: 
+		case R_X86_64_PC32:
 			val -= (u64)loc;
 			*(u32 *)loc = val;
 #if 0
 			if ((s64)val != *(s32 *)loc)
-				goto overflow; 
+				goto overflow;
 #endif
 			break;
 		default:
-			printk(KERN_ERR "module %s: Unknown rela relocation: %Lu\n",
+			printk(KERN_ERR "module %s: Unknown rela relocation: %llu\n",
 			       me->name, ELF64_R_TYPE(rel[i].r_info));
 			return -ENOEXEC;
 		}
@@ -130,7 +130,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 	return 0;
 
 overflow:
-	printk(KERN_ERR "overflow in relocation type %d val %Lx\n", 
+	printk(KERN_ERR "overflow in relocation type %d val %Lx\n",
 	       (int)ELF64_R_TYPE(rel[i].r_info), val);
 	printk(KERN_ERR "`%s' likely not compiled with -mcmodel=kernel\n",
 	       me->name);
@@ -143,13 +143,13 @@ int apply_relocate(Elf_Shdr *sechdrs,
 		   unsigned int relsec,
 		   struct module *me)
 {
-	printk("non add relocation not supported\n");
+	printk(KERN_ERR "non add relocation not supported\n");
 	return -ENOSYS;
-} 
+}
 
 int module_finalize(const Elf_Ehdr *hdr,
-                    const Elf_Shdr *sechdrs,
-                    struct module *me)
+		    const Elf_Shdr *sechdrs,
+		    struct module *me)
 {
 	const Elf_Shdr *s, *text = NULL, *alt = NULL, *locks = NULL,
 		*para = NULL;
@@ -161,7 +161,7 @@ int module_finalize(const Elf_Ehdr *hdr,
 		if (!strcmp(".altinstructions", secstrings + s->sh_name))
 			alt = s;
 		if (!strcmp(".smp_locks", secstrings + s->sh_name))
-			locks= s;
+			locks = s;
 		if (!strcmp(".parainstructions", secstrings + s->sh_name))
 			para = s;
 	}
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index a649a4c..fa6bb26 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -144,11 +144,11 @@ static void __init MP_ioapic_info(struct mpc_ioapic *m)
 	if (bad_ioapic(m->apicaddr))
 		return;
 
-	mp_ioapics[nr_ioapics].mp_apicaddr = m->apicaddr;
-	mp_ioapics[nr_ioapics].mp_apicid = m->apicid;
-	mp_ioapics[nr_ioapics].mp_type = m->type;
-	mp_ioapics[nr_ioapics].mp_apicver = m->apicver;
-	mp_ioapics[nr_ioapics].mp_flags = m->flags;
+	mp_ioapics[nr_ioapics].apicaddr = m->apicaddr;
+	mp_ioapics[nr_ioapics].apicid = m->apicid;
+	mp_ioapics[nr_ioapics].type = m->type;
+	mp_ioapics[nr_ioapics].apicver = m->apicver;
+	mp_ioapics[nr_ioapics].flags = m->flags;
 	nr_ioapics++;
 }
 
@@ -160,55 +160,55 @@ static void print_MP_intsrc_info(struct mpc_intsrc *m)
 		m->srcbusirq, m->dstapic, m->dstirq);
 }
 
-static void __init print_mp_irq_info(struct mp_config_intsrc *mp_irq)
+static void __init print_mp_irq_info(struct mpc_intsrc *mp_irq)
 {
 	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
-		mp_irq->mp_irqtype, mp_irq->mp_irqflag & 3,
-		(mp_irq->mp_irqflag >> 2) & 3, mp_irq->mp_srcbus,
-		mp_irq->mp_srcbusirq, mp_irq->mp_dstapic, mp_irq->mp_dstirq);
+		mp_irq->irqtype, mp_irq->irqflag & 3,
+		(mp_irq->irqflag >> 2) & 3, mp_irq->srcbus,
+		mp_irq->srcbusirq, mp_irq->dstapic, mp_irq->dstirq);
 }
 
 static void __init assign_to_mp_irq(struct mpc_intsrc *m,
-				    struct mp_config_intsrc *mp_irq)
+				    struct mpc_intsrc *mp_irq)
 {
-	mp_irq->mp_dstapic = m->dstapic;
-	mp_irq->mp_type = m->type;
-	mp_irq->mp_irqtype = m->irqtype;
-	mp_irq->mp_irqflag = m->irqflag;
-	mp_irq->mp_srcbus = m->srcbus;
-	mp_irq->mp_srcbusirq = m->srcbusirq;
-	mp_irq->mp_dstirq = m->dstirq;
+	mp_irq->dstapic = m->dstapic;
+	mp_irq->type = m->type;
+	mp_irq->irqtype = m->irqtype;
+	mp_irq->irqflag = m->irqflag;
+	mp_irq->srcbus = m->srcbus;
+	mp_irq->srcbusirq = m->srcbusirq;
+	mp_irq->dstirq = m->dstirq;
 }
 
-static void __init assign_to_mpc_intsrc(struct mp_config_intsrc *mp_irq,
+static void __init assign_to_mpc_intsrc(struct mpc_intsrc *mp_irq,
 					struct mpc_intsrc *m)
 {
-	m->dstapic = mp_irq->mp_dstapic;
-	m->type = mp_irq->mp_type;
-	m->irqtype = mp_irq->mp_irqtype;
-	m->irqflag = mp_irq->mp_irqflag;
-	m->srcbus = mp_irq->mp_srcbus;
-	m->srcbusirq = mp_irq->mp_srcbusirq;
-	m->dstirq = mp_irq->mp_dstirq;
+	m->dstapic = mp_irq->dstapic;
+	m->type = mp_irq->type;
+	m->irqtype = mp_irq->irqtype;
+	m->irqflag = mp_irq->irqflag;
+	m->srcbus = mp_irq->srcbus;
+	m->srcbusirq = mp_irq->srcbusirq;
+	m->dstirq = mp_irq->dstirq;
 }
 
-static int __init mp_irq_mpc_intsrc_cmp(struct mp_config_intsrc *mp_irq,
+static int __init mp_irq_mpc_intsrc_cmp(struct mpc_intsrc *mp_irq,
 					struct mpc_intsrc *m)
 {
-	if (mp_irq->mp_dstapic != m->dstapic)
+	if (mp_irq->dstapic != m->dstapic)
 		return 1;
-	if (mp_irq->mp_type != m->type)
+	if (mp_irq->type != m->type)
 		return 2;
-	if (mp_irq->mp_irqtype != m->irqtype)
+	if (mp_irq->irqtype != m->irqtype)
 		return 3;
-	if (mp_irq->mp_irqflag != m->irqflag)
+	if (mp_irq->irqflag != m->irqflag)
 		return 4;
-	if (mp_irq->mp_srcbus != m->srcbus)
+	if (mp_irq->srcbus != m->srcbus)
 		return 5;
-	if (mp_irq->mp_srcbusirq != m->srcbusirq)
+	if (mp_irq->srcbusirq != m->srcbusirq)
 		return 6;
-	if (mp_irq->mp_dstirq != m->dstirq)
+	if (mp_irq->dstirq != m->dstirq)
 		return 7;
 
 	return 0;
@@ -417,7 +417,7 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 	intsrc.type = MP_INTSRC;
 	intsrc.irqflag = 0;	/* conforming */
 	intsrc.srcbus = 0;
-	intsrc.dstapic = mp_ioapics[0].mp_apicid;
+	intsrc.dstapic = mp_ioapics[0].apicid;
 
 	intsrc.irqtype = mp_INT;
 
@@ -570,14 +570,14 @@ static inline void __init construct_default_ISA_mptable(int mpc_default_type)
 	}
 }
 
-static struct intel_mp_floating *mpf_found;
+static struct mpf_intel *mpf_found;
 
 /*
  * Scan the memory blocks for an SMP configuration block.
  */
 static void __init __get_smp_config(unsigned int early)
 {
-	struct intel_mp_floating *mpf = mpf_found;
+	struct mpf_intel *mpf = mpf_found;
 
 	if (!mpf)
 		return;
@@ -598,9 +598,9 @@ static void __init __get_smp_config(unsigned int early)
 	}
 
 	printk(KERN_INFO "Intel MultiProcessor Specification v1.%d\n",
-	       mpf->mpf_specification);
+	       mpf->specification);
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
-	if (mpf->mpf_feature2 & (1 << 7)) {
+	if (mpf->feature2 & (1 << 7)) {
 		printk(KERN_INFO "    IMCR and PIC compatibility mode.\n");
 		pic_mode = 1;
 	} else {
@@ -611,7 +611,7 @@ static void __init __get_smp_config(unsigned int early)
 	/*
 	 * Now see if we need to read further.
 	 */
-	if (mpf->mpf_feature1 != 0) {
+	if (mpf->feature1 != 0) {
 		if (early) {
 			/*
 			 * local APIC has default address
@@ -621,16 +621,16 @@ static void __init __get_smp_config(unsigned int early)
 		}
 
 		printk(KERN_INFO "Default MP configuration #%d\n",
-		       mpf->mpf_feature1);
-		construct_default_ISA_mptable(mpf->mpf_feature1);
+		       mpf->feature1);
+		construct_default_ISA_mptable(mpf->feature1);
 
-	} else if (mpf->mpf_physptr) {
+	} else if (mpf->physptr) {
 
 		/*
 		 * Read the physical hardware table.  Anything here will
 		 * override the defaults.
 		 */
-		if (!smp_read_mpc(phys_to_virt(mpf->mpf_physptr), early)) {
+		if (!smp_read_mpc(phys_to_virt(mpf->physptr), early)) {
 #ifdef CONFIG_X86_LOCAL_APIC
 			smp_found_config = 0;
 #endif
@@ -688,19 +688,19 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 				  unsigned reserve)
 {
 	unsigned int *bp = phys_to_virt(base);
-	struct intel_mp_floating *mpf;
+	struct mpf_intel *mpf;
 
 	apic_printk(APIC_VERBOSE, "Scan SMP from %p for %ld bytes.\n",
 			bp, length);
 	BUILD_BUG_ON(sizeof(*mpf) != 16);
 
 	while (length > 0) {
-		mpf = (struct intel_mp_floating *)bp;
+		mpf = (struct mpf_intel *)bp;
 		if ((*bp == SMP_MAGIC_IDENT) &&
-		    (mpf->mpf_length == 1) &&
+		    (mpf->length == 1) &&
 		    !mpf_checksum((unsigned char *)bp, 16) &&
-		    ((mpf->mpf_specification == 1)
-		     || (mpf->mpf_specification == 4))) {
+		    ((mpf->specification == 1)
+		     || (mpf->specification == 4))) {
 #ifdef CONFIG_X86_LOCAL_APIC
 			smp_found_config = 1;
 #endif
@@ -713,7 +713,7 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 				return 1;
 			reserve_bootmem_generic(virt_to_phys(mpf), PAGE_SIZE,
 					BOOTMEM_DEFAULT);
-			if (mpf->mpf_physptr) {
+			if (mpf->physptr) {
 				unsigned long size = PAGE_SIZE;
 #ifdef CONFIG_X86_32
 				/*
@@ -722,14 +722,14 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 				 * the bottom is mapped now.
 				 * PC-9800's MPC table places on the very last
 				 * of physical memory; so that simply reserving
-				 * PAGE_SIZE from mpg->mpf_physptr yields BUG()
+				 * PAGE_SIZE from mpf->physptr yields BUG()
 				 * in reserve_bootmem.
 				 */
 				unsigned long end = max_low_pfn * PAGE_SIZE;
-				if (mpf->mpf_physptr + size > end)
-					size = end - mpf->mpf_physptr;
+				if (mpf->physptr + size > end)
+					size = end - mpf->physptr;
 #endif
-				reserve_bootmem_generic(mpf->mpf_physptr, size,
+				reserve_bootmem_generic(mpf->physptr, size,
 						BOOTMEM_DEFAULT);
 			}
 
@@ -809,15 +809,15 @@ static int  __init get_MP_intsrc_index(struct mpc_intsrc *m)
 	/* not legacy */
 
 	for (i = 0; i < mp_irq_entries; i++) {
-		if (mp_irqs[i].mp_irqtype != mp_INT)
+		if (mp_irqs[i].irqtype != mp_INT)
 			continue;
 
-		if (mp_irqs[i].mp_irqflag != 0x0f)
+		if (mp_irqs[i].irqflag != 0x0f)
 			continue;
 
-		if (mp_irqs[i].mp_srcbus != m->srcbus)
+		if (mp_irqs[i].srcbus != m->srcbus)
 			continue;
-		if (mp_irqs[i].mp_srcbusirq != m->srcbusirq)
+		if (mp_irqs[i].srcbusirq != m->srcbusirq)
 			continue;
 		if (irq_used[i]) {
 			/* already claimed */
@@ -922,10 +922,10 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 		if (irq_used[i])
 			continue;
 
-		if (mp_irqs[i].mp_irqtype != mp_INT)
+		if (mp_irqs[i].irqtype != mp_INT)
 			continue;
 
-		if (mp_irqs[i].mp_irqflag != 0x0f)
+		if (mp_irqs[i].irqflag != 0x0f)
 			continue;
 
 		if (nr_m_spare > 0) {
@@ -1001,7 +1001,7 @@ static int __init update_mp_table(void)
 {
 	char str[16];
 	char oem[10];
-	struct intel_mp_floating *mpf;
+	struct mpf_intel *mpf;
 	struct mpc_table *mpc, *mpc_new;
 
 	if (!enable_update_mptable)
@@ -1014,19 +1014,19 @@ static int __init update_mp_table(void)
 	/*
 	 * Now see if we need to go further.
 	 */
-	if (mpf->mpf_feature1 != 0)
+	if (mpf->feature1 != 0)
 		return 0;
 
-	if (!mpf->mpf_physptr)
+	if (!mpf->physptr)
 		return 0;
 
-	mpc = phys_to_virt(mpf->mpf_physptr);
+	mpc = phys_to_virt(mpf->physptr);
 
 	if (!smp_check_mpc(mpc, oem, str))
 		return 0;
 
 	printk(KERN_INFO "mpf: %lx\n", virt_to_phys(mpf));
-	printk(KERN_INFO "mpf_physptr: %x\n", mpf->mpf_physptr);
+	printk(KERN_INFO "physptr: %x\n", mpf->physptr);
 
 	if (mpc_new_phys && mpc->length > mpc_new_length) {
 		mpc_new_phys = 0;
@@ -1047,23 +1047,23 @@ static int __init update_mp_table(void)
 		}
 		printk(KERN_INFO "use in-positon replacing\n");
 	} else {
-		mpf->mpf_physptr = mpc_new_phys;
+		mpf->physptr = mpc_new_phys;
 		mpc_new = phys_to_virt(mpc_new_phys);
 		memcpy(mpc_new, mpc, mpc->length);
 		mpc = mpc_new;
 		/* check if we can modify that */
-		if (mpc_new_phys - mpf->mpf_physptr) {
-			struct intel_mp_floating *mpf_new;
+		if (mpc_new_phys - mpf->physptr) {
+			struct mpf_intel *mpf_new;
 			/* steal 16 bytes from [0, 1k) */
 			printk(KERN_INFO "mpf new: %x\n", 0x400 - 16);
 			mpf_new = phys_to_virt(0x400 - 16);
 			memcpy(mpf_new, mpf, 16);
 			mpf = mpf_new;
-			mpf->mpf_physptr = mpc_new_phys;
+			mpf->physptr = mpc_new_phys;
 		}
-		mpf->mpf_checksum = 0;
-		mpf->mpf_checksum -= mpf_checksum((unsigned char *)mpf, 16);
-		printk(KERN_INFO "mpf_physptr new: %x\n", mpf->mpf_physptr);
+		mpf->checksum = 0;
+		mpf->checksum -= mpf_checksum((unsigned char *)mpf, 16);
+		printk(KERN_INFO "physptr new: %x\n", mpf->physptr);
 	}
 
 	/*
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 7262666..3cf3413 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -35,10 +35,10 @@
 #include <linux/device.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
+#include <linux/uaccess.h>
 
 #include <asm/processor.h>
 #include <asm/msr.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 static struct class *msr_class;
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 7228979..23b6d9e 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -61,11 +61,7 @@ static int endflag __initdata;
 
 static inline unsigned int get_nmi_count(int cpu)
 {
-#ifdef CONFIG_X86_64
-	return cpu_pda(cpu)->__nmi_count;
-#else
-	return nmi_count(cpu);
-#endif
+	return per_cpu(irq_stat, cpu).__nmi_count;
 }
 
 static inline int mce_in_progress(void)
@@ -82,12 +78,8 @@ static inline int mce_in_progress(void)
  */
 static inline unsigned int get_timer_irqs(int cpu)
 {
-#ifdef CONFIG_X86_64
-	return read_pda(apic_timer_irqs) + read_pda(irq0_irqs);
-#else
 	return per_cpu(irq_stat, cpu).apic_timer_irqs +
 		per_cpu(irq_stat, cpu).irq0_irqs;
-#endif
 }
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index a546f55..2c00a57 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -66,9 +66,6 @@ asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
 EXPORT_PER_CPU_SYMBOL(current_task);
 
-DEFINE_PER_CPU(int, cpu_number);
-EXPORT_PER_CPU_SYMBOL(cpu_number);
-
 /*
  * Return saved PC of a blocked thread.
  */
@@ -591,7 +588,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	if (prev->gs | next->gs)
 		loadsegment(gs, next->gs);
 
-	x86_write_percpu(current_task, next_p);
+	percpu_write(current_task, next_p);
 
 	return prev_p;
 }
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 416fb92..4523ff8 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -57,6 +57,12 @@
 
 asmlinkage extern void ret_from_fork(void);
 
+DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
+EXPORT_PER_CPU_SYMBOL(current_task);
+
+DEFINE_PER_CPU(unsigned long, old_rsp);
+static DEFINE_PER_CPU(unsigned char, is_idle);
+
 unsigned long kernel_thread_flags = CLONE_VM | CLONE_UNTRACED;
 
 static ATOMIC_NOTIFIER_HEAD(idle_notifier);
@@ -75,13 +81,13 @@ EXPORT_SYMBOL_GPL(idle_notifier_unregister);
 
 void enter_idle(void)
 {
-	write_pda(isidle, 1);
+	percpu_write(is_idle, 1);
 	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
 }
 
 static void __exit_idle(void)
 {
-	if (test_and_clear_bit_pda(0, isidle) == 0)
+	if (x86_test_and_clear_bit_percpu(0, is_idle) == 0)
 		return;
 	atomic_notifier_call_chain(&idle_notifier, IDLE_END, NULL);
 }
@@ -392,7 +398,7 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 	load_gs_index(0);
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
-	write_pda(oldrsp, new_sp);
+	percpu_write(old_rsp, new_sp);
 	regs->cs		= __USER_CS;
 	regs->ss		= __USER_DS;
 	regs->flags		= 0x200;
@@ -613,13 +619,13 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	/*
 	 * Switch the PDA and FPU contexts.
 	 */
-	prev->usersp = read_pda(oldrsp);
-	write_pda(oldrsp, next->usersp);
-	write_pda(pcurrent, next_p);
+	prev->usersp = percpu_read(old_rsp);
+	percpu_write(old_rsp, next->usersp);
+	percpu_write(current_task, next_p);
 
-	write_pda(kernelstack,
+	percpu_write(kernel_stack,
 		  (unsigned long)task_stack_page(next_p) +
-		  THREAD_SIZE - PDA_STACKOFFSET);
+		  THREAD_SIZE - KERNEL_STACK_OFFSET);
 #ifdef CONFIG_CC_STACKPROTECTOR
 	write_pda(stack_canary, next_p->stack_canary);
 	/*
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 2b46eb4..f8536fe 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -14,6 +14,7 @@
 #include <asm/reboot.h>
 #include <asm/pci_x86.h>
 #include <asm/virtext.h>
+#include <asm/cpu.h>
 
 #ifdef CONFIG_X86_32
 # include <linux/dmi.h>
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ae0d804..f41c448 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -89,7 +89,7 @@
 
 #include <asm/system.h>
 #include <asm/vsyscall.h>
-#include <asm/smp.h>
+#include <asm/cpu.h>
 #include <asm/desc.h>
 #include <asm/dma.h>
 #include <asm/iommu.h>
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 55c4607..efbafbb 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -13,6 +13,23 @@
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
 #include <asm/highmem.h>
+#include <asm/proto.h>
+#include <asm/cpumask.h>
+
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+# define DBG(x...) printk(KERN_DEBUG x)
+#else
+# define DBG(x...)
+#endif
+
+/*
+ * Could be inside CONFIG_HAVE_SETUP_PER_CPU_AREA with other stuff but
+ * voyager wants cpu_number too.
+ */
+#ifdef CONFIG_SMP
+DEFINE_PER_CPU(int, cpu_number);
+EXPORT_PER_CPU_SYMBOL(cpu_number);
+#endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
 unsigned int num_processors;
@@ -26,31 +43,84 @@ unsigned int max_physical_apicid;
 physid_mask_t phys_cpu_present_map;
 #endif
 
-/* map cpu index to physical APIC ID */
+/*
+ * Map cpu index to physical APIC ID
+ */
 DEFINE_EARLY_PER_CPU(u16, x86_cpu_to_apicid, BAD_APICID);
 DEFINE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid, BAD_APICID);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
-#define	X86_64_NUMA	1
+#define	X86_64_NUMA	1	/* (used later) */
+DEFINE_PER_CPU(int, node_number) = 0;
+EXPORT_PER_CPU_SYMBOL(node_number);
 
-/* map cpu index to node index */
+/*
+ * Map cpu index to node index
+ */
 DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
 
-/* which logical CPUs are on which nodes */
+/*
+ * Which logical CPUs are on which nodes
+ */
 cpumask_t *node_to_cpumask_map;
 EXPORT_SYMBOL(node_to_cpumask_map);
 
-/* setup node_to_cpumask_map */
+/*
+ * Setup node_to_cpumask_map
+ */
 static void __init setup_node_to_cpumask_map(void);
 
 #else
 static inline void setup_node_to_cpumask_map(void) { }
 #endif
 
-#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_X86_SMP)
+/*
+ * Define load_pda_offset() and per-cpu __pda for x86_64.
+ * load_pda_offset() is responsible for loading the offset of pda into
+ * %gs.
+ *
+ * On SMP, pda offset also duals as percpu base address and thus it
+ * should be at the start of per-cpu area.  To achieve this, it's
+ * preallocated in vmlinux_64.lds.S directly instead of using
+ * DEFINE_PER_CPU().
+ */
+#ifdef CONFIG_X86_64
+void __cpuinit load_pda_offset(int cpu)
+{
+	/* Memory clobbers used to order pda/percpu accesses */
+	mb();
+	wrmsrl(MSR_GS_BASE, cpu_pda(cpu));
+	mb();
+}
+#ifndef CONFIG_SMP
+DEFINE_PER_CPU(struct x8664_pda, __pda);
+#endif
+EXPORT_PER_CPU_SYMBOL(__pda);
+#endif /* CONFIG_SMP && CONFIG_X86_64 */
+
+#ifdef CONFIG_X86_64
+
+/* correctly size the local cpu masks */
+static void setup_cpu_local_masks(void)
+{
+	alloc_bootmem_cpumask_var(&cpu_initialized_mask);
+	alloc_bootmem_cpumask_var(&cpu_callin_mask);
+	alloc_bootmem_cpumask_var(&cpu_callout_mask);
+	alloc_bootmem_cpumask_var(&cpu_sibling_setup_mask);
+}
+
+#else /* CONFIG_X86_32 */
+
+static inline void setup_cpu_local_masks(void)
+{
+}
+
+#endif /* CONFIG_X86_32 */
+
+#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 /*
  * Copy data used in early init routines from the initial arrays to the
  * per cpu data areas.  These arrays then become expendable and the
@@ -79,78 +149,14 @@ static void __init setup_per_cpu_maps(void)
 #endif
 }
 
-#ifdef CONFIG_X86_32
-/*
- * Great future not-so-futuristic plan: make i386 and x86_64 do it
- * the same way
- */
+#ifdef CONFIG_X86_64
+unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
+	[0] = (unsigned long)__per_cpu_load,
+};
+#else
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
+#endif
 EXPORT_SYMBOL(__per_cpu_offset);
-static inline void setup_cpu_pda_map(void) { }
-
-#elif !defined(CONFIG_SMP)
-static inline void setup_cpu_pda_map(void) { }
-
-#else /* CONFIG_SMP && CONFIG_X86_64 */
-
-/*
- * Allocate cpu_pda pointer table and array via alloc_bootmem.
- */
-static void __init setup_cpu_pda_map(void)
-{
-	char *pda;
-	struct x8664_pda **new_cpu_pda;
-	unsigned long size;
-	int cpu;
-
-	size = roundup(sizeof(struct x8664_pda), cache_line_size());
-
-	/* allocate cpu_pda array and pointer table */
-	{
-		unsigned long tsize = nr_cpu_ids * sizeof(void *);
-		unsigned long asize = size * (nr_cpu_ids - 1);
-
-		tsize = roundup(tsize, cache_line_size());
-		new_cpu_pda = alloc_bootmem(tsize + asize);
-		pda = (char *)new_cpu_pda + tsize;
-	}
-
-	/* initialize pointer table to static pda's */
-	for_each_possible_cpu(cpu) {
-		if (cpu == 0) {
-			/* leave boot cpu pda in place */
-			new_cpu_pda[0] = cpu_pda(0);
-			continue;
-		}
-		new_cpu_pda[cpu] = (struct x8664_pda *)pda;
-		new_cpu_pda[cpu]->in_bootmem = 1;
-		pda += size;
-	}
-
-	/* point to new pointer table */
-	_cpu_pda = new_cpu_pda;
-}
-
-#endif /* CONFIG_SMP && CONFIG_X86_64 */
-
-#ifdef CONFIG_X86_64
-
-/* correctly size the local cpu masks */
-static void setup_cpu_local_masks(void)
-{
-	alloc_bootmem_cpumask_var(&cpu_initialized_mask);
-	alloc_bootmem_cpumask_var(&cpu_callin_mask);
-	alloc_bootmem_cpumask_var(&cpu_callout_mask);
-	alloc_bootmem_cpumask_var(&cpu_sibling_setup_mask);
-}
-
-#else /* CONFIG_X86_32 */
-
-static inline void setup_cpu_local_masks(void)
-{
-}
-
-#endif /* CONFIG_X86_32 */
 
 /*
  * Great future plan:
@@ -164,9 +170,6 @@ void __init setup_per_cpu_areas(void)
 	int cpu;
 	unsigned long align = 1;
 
-	/* Setup cpu_pda map */
-	setup_cpu_pda_map();
-
 	/* Copy section for each CPU (we discard the original) */
 	old_size = PERCPU_ENOUGH_ROOM;
 	align = max_t(unsigned long, PAGE_SIZE, align);
@@ -197,8 +200,25 @@ void __init setup_per_cpu_areas(void)
 				cpu, node, __pa(ptr));
 		}
 #endif
+
+		memcpy(ptr, __per_cpu_load, __per_cpu_end - __per_cpu_start);
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
-		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
+		per_cpu(this_cpu_off, cpu) = per_cpu_offset(cpu);
+		per_cpu(cpu_number, cpu) = cpu;
+#ifdef CONFIG_X86_64
+		per_cpu(irq_stack_ptr, cpu) =
+			(char *)per_cpu(irq_stack, cpu) + IRQ_STACK_SIZE - 64;
+		/*
+		 * CPU0 modified pda in the init data area, reload pda
+		 * offset for CPU0 and clear the area for others.
+		 */
+		if (cpu == 0)
+			load_pda_offset(0);
+		else
+			memset(cpu_pda(cpu), 0, sizeof(*cpu_pda(cpu)));
+#endif
+
+		DBG("PERCPU: cpu %4d %p\n", cpu, ptr);
 	}
 
 	/* Setup percpu data maps */
@@ -220,6 +240,7 @@ void __init setup_per_cpu_areas(void)
  * Requires node_possible_map to be valid.
  *
  * Note: node_to_cpumask() is not valid until after this is done.
+ * (Use CONFIG_DEBUG_PER_CPU_MAPS to check this.)
  */
 static void __init setup_node_to_cpumask_map(void)
 {
@@ -235,6 +256,7 @@ static void __init setup_node_to_cpumask_map(void)
 
 	/* allocate the map */
 	map = alloc_bootmem_low(nr_node_ids * sizeof(cpumask_t));
+	DBG("node_to_cpumask_map at %p for %d nodes\n", map, nr_node_ids);
 
 	pr_debug("Node to cpumask map at %p for %d nodes\n",
 		 map, nr_node_ids);
@@ -247,17 +269,23 @@ void __cpuinit numa_set_node(int cpu, int node)
 {
 	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
 
-	if (cpu_pda(cpu) && node != NUMA_NO_NODE)
-		cpu_pda(cpu)->nodenumber = node;
-
-	if (cpu_to_node_map)
+	/* early setting, no percpu area yet */
+	if (cpu_to_node_map) {
 		cpu_to_node_map[cpu] = node;
+		return;
+	}
 
-	else if (per_cpu_offset(cpu))
-		per_cpu(x86_cpu_to_node_map, cpu) = node;
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+	if (cpu >= nr_cpu_ids || !per_cpu_offset(cpu)) {
+		printk(KERN_ERR "numa_set_node: invalid cpu# (%d)\n", cpu);
+		dump_stack();
+		return;
+	}
+#endif
+	per_cpu(x86_cpu_to_node_map, cpu) = node;
 
-	else
-		pr_debug("Setting node for non-present cpu %d\n", cpu);
+	if (node != NUMA_NO_NODE)
+		per_cpu(node_number, cpu) = node;
 }
 
 void __cpuinit numa_clear_node(int cpu)
@@ -274,7 +302,7 @@ void __cpuinit numa_add_cpu(int cpu)
 
 void __cpuinit numa_remove_cpu(int cpu)
 {
-	cpu_clear(cpu, node_to_cpumask_map[cpu_to_node(cpu)]);
+	cpu_clear(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
 }
 
 #else /* CONFIG_DEBUG_PER_CPU_MAPS */
@@ -284,7 +312,7 @@ void __cpuinit numa_remove_cpu(int cpu)
  */
 static void __cpuinit numa_set_cpumask(int cpu, int enable)
 {
-	int node = cpu_to_node(cpu);
+	int node = early_cpu_to_node(cpu);
 	cpumask_t *mask;
 	char buf[64];
 
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 89bb766..4fa5243 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -6,7 +6,7 @@
  *  2000-06-20  Pentium III FXSR, SSE support by Gareth Hughes
  *  2000-2002   x86-64 support by Andi Kleen
  */
-
+#include <linux/perf_counter.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
@@ -886,6 +886,11 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 		tracehook_notify_resume(regs);
 	}
 
+	if (thread_info_flags & _TIF_PERF_COUNTERS) {
+		clear_thread_flag(TIF_PERF_COUNTERS);
+		perf_counter_notify(regs);
+	}
+
 #ifdef CONFIG_X86_32
 	clear_thread_flag(TIF_IRET);
 #endif /* CONFIG_X86_32 */
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index bb1a3b1..869b988 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -53,7 +53,6 @@
 #include <asm/nmi.h>
 #include <asm/irq.h>
 #include <asm/idle.h>
-#include <asm/smp.h>
 #include <asm/trampoline.h>
 #include <asm/cpu.h>
 #include <asm/numa.h>
@@ -745,52 +744,6 @@ static void __cpuinit do_fork_idle(struct work_struct *work)
 	complete(&c_idle->done);
 }
 
-#ifdef CONFIG_X86_64
-
-/* __ref because it's safe to call free_bootmem when after_bootmem == 0. */
-static void __ref free_bootmem_pda(struct x8664_pda *oldpda)
-{
-	if (!after_bootmem)
-		free_bootmem((unsigned long)oldpda, sizeof(*oldpda));
-}
-
-/*
- * Allocate node local memory for the AP pda.
- *
- * Must be called after the _cpu_pda pointer table is initialized.
- */
-int __cpuinit get_local_pda(int cpu)
-{
-	struct x8664_pda *oldpda, *newpda;
-	unsigned long size = sizeof(struct x8664_pda);
-	int node = cpu_to_node(cpu);
-
-	if (cpu_pda(cpu) && !cpu_pda(cpu)->in_bootmem)
-		return 0;
-
-	oldpda = cpu_pda(cpu);
-	newpda = kmalloc_node(size, GFP_ATOMIC, node);
-	if (!newpda) {
-		printk(KERN_ERR "Could not allocate node local PDA "
-			"for CPU %d on node %d\n", cpu, node);
-
-		if (oldpda)
-			return 0;	/* have a usable pda */
-		else
-			return -1;
-	}
-
-	if (oldpda) {
-		memcpy(newpda, oldpda, size);
-		free_bootmem_pda(oldpda);
-	}
-
-	newpda->in_bootmem = 0;
-	cpu_pda(cpu) = newpda;
-	return 0;
-}
-#endif /* CONFIG_X86_64 */
-
 static int __cpuinit do_boot_cpu(int apicid, int cpu)
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
@@ -808,16 +761,6 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 	};
 	INIT_WORK(&c_idle.work, do_fork_idle);
 
-#ifdef CONFIG_X86_64
-	/* Allocate node local memory for AP pdas */
-	if (cpu > 0) {
-		boot_error = get_local_pda(cpu);
-		if (boot_error)
-			goto restore_state;
-			/* if can't get pda memory, can't start cpu */
-	}
-#endif
-
 	alternatives_smp_switch(1);
 
 	c_idle.idle = get_idle_for_cpu(cpu);
@@ -847,14 +790,17 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 
 	set_idle_for_cpu(cpu, c_idle.idle);
 do_rest:
-#ifdef CONFIG_X86_32
 	per_cpu(current_task, cpu) = c_idle.idle;
+#ifdef CONFIG_X86_32
 	init_gdt(cpu);
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	irq_ctx_init(cpu);
 #else
-	cpu_pda(cpu)->pcurrent = c_idle.idle;
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
+	initial_gs = per_cpu_offset(cpu);
+	per_cpu(kernel_stack, cpu) =
+		(unsigned long)task_stack_page(c_idle.idle) -
+		KERNEL_STACK_OFFSET + THREAD_SIZE;
 #endif
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	initial_code = (unsigned long)start_secondary;
@@ -931,9 +877,7 @@ do_rest:
 				inquire_remote_apic(apicid);
 		}
 	}
-#ifdef CONFIG_X86_64
-restore_state:
-#endif
+
 	if (boot_error) {
 		/* Try to put things back the way they were before ... */
 		numa_remove_cpu(cpu); /* was set by numa_add_cpu */
@@ -1125,6 +1069,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 		printk(KERN_ERR "... forcing use of dummy APIC emulation."
 				"(tell your hw vendor)\n");
 		smpboot_clear_io_apic();
+		disable_ioapic_setup();
 		return -1;
 	}
 
diff --git a/arch/x86/kernel/smpcommon.c b/arch/x86/kernel/smpcommon.c
index 397e309..add36b4 100644
--- a/arch/x86/kernel/smpcommon.c
+++ b/arch/x86/kernel/smpcommon.c
@@ -3,11 +3,16 @@
  */
 #include <linux/module.h>
 #include <asm/smp.h>
+#include <asm/sections.h>
 
-#ifdef CONFIG_X86_32
+#ifdef CONFIG_X86_64
+DEFINE_PER_CPU(unsigned long, this_cpu_off) = (unsigned long)__per_cpu_load;
+#else
 DEFINE_PER_CPU(unsigned long, this_cpu_off);
+#endif
 EXPORT_PER_CPU_SYMBOL(this_cpu_off);
 
+#ifdef CONFIG_X86_32
 /*
  * Initialize the CPU's GDT.  This is either the boot CPU doing itself
  * (still using the master per-cpu area), or a CPU doing it for a
@@ -23,8 +28,5 @@ __cpuinit void init_gdt(int cpu)
 
 	write_gdt_entry(get_cpu_gdt_table(cpu),
 			GDT_ENTRY_PERCPU, &gdt, DESCTYPE_S);
-
-	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
-	per_cpu(cpu_number, cpu) = cpu;
 }
 #endif
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index e2e86a0..0c4d601 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -332,3 +332,4 @@ ENTRY(sys_call_table)
 	.long sys_dup3			/* 330 */
 	.long sys_pipe2
 	.long sys_inotify_init1
+	.long sys_perf_counter_open
diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
index ce50546..abf0808 100644
--- a/arch/x86/kernel/tlb_32.c
+++ b/arch/x86/kernel/tlb_32.c
@@ -4,8 +4,8 @@
 
 #include <asm/tlbflush.h>
 
-DEFINE_PER_CPU(struct tlb_state, cpu_tlbstate)
-			____cacheline_aligned = { &init_mm, 0, };
+DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate)
+			= { &init_mm, 0, };
 
 /* must come after the send_IPI functions above for inlining */
 #include <mach_ipi.h>
@@ -20,7 +20,7 @@ DEFINE_PER_CPU(struct tlb_state, cpu_tlbstate)
  *	Optimizations Manfred Spraul <manfred@colorfullife.com>
  */
 
-static cpumask_t flush_cpumask;
+static cpumask_var_t flush_cpumask;
 static struct mm_struct *flush_mm;
 static unsigned long flush_va;
 static DEFINE_SPINLOCK(tlbstate_lock);
@@ -34,8 +34,8 @@ static DEFINE_SPINLOCK(tlbstate_lock);
  */
 void leave_mm(int cpu)
 {
-	BUG_ON(x86_read_percpu(cpu_tlbstate.state) == TLBSTATE_OK);
-	cpu_clear(cpu, x86_read_percpu(cpu_tlbstate.active_mm)->cpu_vm_mask);
+	BUG_ON(percpu_read(cpu_tlbstate.state) == TLBSTATE_OK);
+	cpu_clear(cpu, percpu_read(cpu_tlbstate.active_mm)->cpu_vm_mask);
 	load_cr3(swapper_pg_dir);
 }
 EXPORT_SYMBOL_GPL(leave_mm);
@@ -92,7 +92,7 @@ void smp_invalidate_interrupt(struct pt_regs *regs)
 
 	cpu = get_cpu();
 
-	if (!cpu_isset(cpu, flush_cpumask))
+	if (!cpumask_test_cpu(cpu, flush_cpumask))
 		goto out;
 		/*
 		 * This was a BUG() but until someone can quote me the
@@ -103,8 +103,8 @@ void smp_invalidate_interrupt(struct pt_regs *regs)
 		 * BUG();
 		 */
 
-	if (flush_mm == x86_read_percpu(cpu_tlbstate.active_mm)) {
-		if (x86_read_percpu(cpu_tlbstate.state) == TLBSTATE_OK) {
+	if (flush_mm == percpu_read(cpu_tlbstate.active_mm)) {
+		if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
 			if (flush_va == TLB_FLUSH_ALL)
 				local_flush_tlb();
 			else
@@ -114,35 +114,22 @@ void smp_invalidate_interrupt(struct pt_regs *regs)
 	}
 	ack_APIC_irq();
 	smp_mb__before_clear_bit();
-	cpu_clear(cpu, flush_cpumask);
+	cpumask_clear_cpu(cpu, flush_cpumask);
 	smp_mb__after_clear_bit();
 out:
 	put_cpu_no_resched();
 	inc_irq_stat(irq_tlb_count);
 }
 
-void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
-			     unsigned long va)
+void native_flush_tlb_others(const struct cpumask *cpumask,
+			     struct mm_struct *mm, unsigned long va)
 {
-	cpumask_t cpumask = *cpumaskp;
-
 	/*
-	 * A couple of (to be removed) sanity checks:
-	 *
-	 * - current CPU must not be in mask
 	 * - mask must exist :)
 	 */
-	BUG_ON(cpus_empty(cpumask));
-	BUG_ON(cpu_isset(smp_processor_id(), cpumask));
+	BUG_ON(cpumask_empty(cpumask));
 	BUG_ON(!mm);
 
-#ifdef CONFIG_HOTPLUG_CPU
-	/* If a CPU which we ran on has gone down, OK. */
-	cpus_and(cpumask, cpumask, cpu_online_map);
-	if (unlikely(cpus_empty(cpumask)))
-		return;
-#endif
-
 	/*
 	 * i'm not happy about this global shared spinlock in the
 	 * MM hot path, but we'll see how contended it is.
@@ -150,9 +137,17 @@ void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 	 */
 	spin_lock(&tlbstate_lock);
 
+	cpumask_andnot(flush_cpumask, cpumask, cpumask_of(smp_processor_id()));
+#ifdef CONFIG_HOTPLUG_CPU
+	/* If a CPU which we ran on has gone down, OK. */
+	cpumask_and(flush_cpumask, flush_cpumask, cpu_online_mask);
+	if (unlikely(cpumask_empty(flush_cpumask))) {
+		spin_unlock(&tlbstate_lock);
+		return;
+	}
+#endif
 	flush_mm = mm;
 	flush_va = va;
-	cpus_or(flush_cpumask, cpumask, flush_cpumask);
 
 	/*
 	 * Make the above memory operations globally visible before
@@ -163,9 +158,9 @@ void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */
-	send_IPI_mask(&cpumask, INVALIDATE_TLB_VECTOR);
+	send_IPI_mask(flush_cpumask, INVALIDATE_TLB_VECTOR);
 
-	while (!cpus_empty(flush_cpumask))
+	while (!cpumask_empty(flush_cpumask))
 		/* nothing. lockup detection does not belong here */
 		cpu_relax();
 
@@ -177,25 +172,19 @@ void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 void flush_tlb_current_task(void)
 {
 	struct mm_struct *mm = current->mm;
-	cpumask_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
 
 	local_flush_tlb();
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
+	if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(&mm->cpu_vm_mask, mm, TLB_FLUSH_ALL);
 	preempt_enable();
 }
 
 void flush_tlb_mm(struct mm_struct *mm)
 {
-	cpumask_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
 
 	if (current->active_mm == mm) {
 		if (current->mm)
@@ -203,8 +192,8 @@ void flush_tlb_mm(struct mm_struct *mm)
 		else
 			leave_mm(smp_processor_id());
 	}
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
+	if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(&mm->cpu_vm_mask, mm, TLB_FLUSH_ALL);
 
 	preempt_enable();
 }
@@ -212,11 +201,8 @@ void flush_tlb_mm(struct mm_struct *mm)
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	cpumask_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
 
 	if (current->active_mm == mm) {
 		if (current->mm)
@@ -225,9 +211,8 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 			leave_mm(smp_processor_id());
 	}
 
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, va);
-
+	if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(&mm->cpu_vm_mask, mm, va);
 	preempt_enable();
 }
 EXPORT_SYMBOL(flush_tlb_page);
@@ -237,7 +222,7 @@ static void do_flush_tlb_all(void *info)
 	unsigned long cpu = smp_processor_id();
 
 	__flush_tlb_all();
-	if (x86_read_percpu(cpu_tlbstate.state) == TLBSTATE_LAZY)
+	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
 		leave_mm(cpu);
 }
 
@@ -246,11 +231,9 @@ void flush_tlb_all(void)
 	on_each_cpu(do_flush_tlb_all, NULL, 1);
 }
 
-void reset_lazy_tlbstate(void)
+static int init_flush_cpumask(void)
 {
-	int cpu = raw_smp_processor_id();
-
-	per_cpu(cpu_tlbstate, cpu).state = 0;
-	per_cpu(cpu_tlbstate, cpu).active_mm = &init_mm;
+	alloc_cpumask_var(&flush_cpumask, GFP_KERNEL);
+	return 0;
 }
-
+early_initcall(init_flush_cpumask);
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
index f8be6f1..e64a32c 100644
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -18,6 +18,9 @@
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_bau.h>
 
+DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate)
+			= { &init_mm, 0, };
+
 #include <mach_ipi.h>
 /*
  *	Smarter SMP flushing macros.
@@ -43,10 +46,10 @@
 
 union smp_flush_state {
 	struct {
-		cpumask_t flush_cpumask;
 		struct mm_struct *flush_mm;
 		unsigned long flush_va;
 		spinlock_t tlbstate_lock;
+		DECLARE_BITMAP(flush_cpumask, NR_CPUS);
 	};
 	char pad[SMP_CACHE_BYTES];
 } ____cacheline_aligned;
@@ -62,9 +65,9 @@ static DEFINE_PER_CPU(union smp_flush_state, flush_state);
  */
 void leave_mm(int cpu)
 {
-	if (read_pda(mmu_state) == TLBSTATE_OK)
+	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
 		BUG();
-	cpu_clear(cpu, read_pda(active_mm)->cpu_vm_mask);
+	cpu_clear(cpu, percpu_read(cpu_tlbstate.active_mm)->cpu_vm_mask);
 	load_cr3(swapper_pg_dir);
 }
 EXPORT_SYMBOL_GPL(leave_mm);
@@ -131,7 +134,7 @@ asmlinkage void smp_invalidate_interrupt(struct pt_regs *regs)
 	sender = ~regs->orig_ax - INVALIDATE_TLB_VECTOR_START;
 	f = &per_cpu(flush_state, sender);
 
-	if (!cpu_isset(cpu, f->flush_cpumask))
+	if (!cpumask_test_cpu(cpu, to_cpumask(f->flush_cpumask)))
 		goto out;
 		/*
 		 * This was a BUG() but until someone can quote me the
@@ -142,8 +145,8 @@ asmlinkage void smp_invalidate_interrupt(struct pt_regs *regs)
 		 * BUG();
 		 */
 
-	if (f->flush_mm == read_pda(active_mm)) {
-		if (read_pda(mmu_state) == TLBSTATE_OK) {
+	if (f->flush_mm == percpu_read(cpu_tlbstate.active_mm)) {
+		if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
 			if (f->flush_va == TLB_FLUSH_ALL)
 				local_flush_tlb();
 			else
@@ -153,19 +156,15 @@ asmlinkage void smp_invalidate_interrupt(struct pt_regs *regs)
 	}
 out:
 	ack_APIC_irq();
-	cpu_clear(cpu, f->flush_cpumask);
+	cpumask_clear_cpu(cpu, to_cpumask(f->flush_cpumask));
 	inc_irq_stat(irq_tlb_count);
 }
 
-void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
-			     unsigned long va)
+static void flush_tlb_others_ipi(const struct cpumask *cpumask,
+				 struct mm_struct *mm, unsigned long va)
 {
 	int sender;
 	union smp_flush_state *f;
-	cpumask_t cpumask = *cpumaskp;
-
-	if (is_uv_system() && uv_flush_tlb_others(&cpumask, mm, va))
-		return;
 
 	/* Caller has disabled preemption */
 	sender = smp_processor_id() % NUM_INVALIDATE_TLB_VECTORS;
@@ -180,7 +179,8 @@ void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 
 	f->flush_mm = mm;
 	f->flush_va = va;
-	cpus_or(f->flush_cpumask, cpumask, f->flush_cpumask);
+	cpumask_andnot(to_cpumask(f->flush_cpumask),
+		       cpumask, cpumask_of(smp_processor_id()));
 
 	/*
 	 * Make the above memory operations globally visible before
@@ -191,9 +191,10 @@ void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */
-	send_IPI_mask(&cpumask, INVALIDATE_TLB_VECTOR_START + sender);
+	send_IPI_mask(to_cpumask(f->flush_cpumask),
+		      INVALIDATE_TLB_VECTOR_START + sender);
 
-	while (!cpus_empty(f->flush_cpumask))
+	while (!cpumask_empty(to_cpumask(f->flush_cpumask)))
 		cpu_relax();
 
 	f->flush_mm = NULL;
@@ -201,6 +202,25 @@ void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 	spin_unlock(&f->tlbstate_lock);
 }
 
+void native_flush_tlb_others(const struct cpumask *cpumask,
+			     struct mm_struct *mm, unsigned long va)
+{
+	if (is_uv_system()) {
+		/* FIXME: could be an percpu_alloc'd thing */
+		static DEFINE_PER_CPU(cpumask_t, flush_tlb_mask);
+		struct cpumask *after_uv_flush = &get_cpu_var(flush_tlb_mask);
+
+		cpumask_andnot(after_uv_flush, cpumask,
+			       cpumask_of(smp_processor_id()));
+		if (!uv_flush_tlb_others(after_uv_flush, mm, va))
+			flush_tlb_others_ipi(after_uv_flush, mm, va);
+
+		put_cpu_var(flush_tlb_uv_cpumask);
+		return;
+	}
+	flush_tlb_others_ipi(cpumask, mm, va);
+}
+
 static int __cpuinit init_smp_flush(void)
 {
 	int i;
@@ -215,25 +235,18 @@ core_initcall(init_smp_flush);
 void flush_tlb_current_task(void)
 {
 	struct mm_struct *mm = current->mm;
-	cpumask_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
 
 	local_flush_tlb();
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
+	if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(&mm->cpu_vm_mask, mm, TLB_FLUSH_ALL);
 	preempt_enable();
 }
 
 void flush_tlb_mm(struct mm_struct *mm)
 {
-	cpumask_t cpu_mask;
-
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
 
 	if (current->active_mm == mm) {
 		if (current->mm)
@@ -241,8 +254,8 @@ void flush_tlb_mm(struct mm_struct *mm)
 		else
 			leave_mm(smp_processor_id());
 	}
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
+	if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(&mm->cpu_vm_mask, mm, TLB_FLUSH_ALL);
 
 	preempt_enable();
 }
@@ -250,11 +263,8 @@ void flush_tlb_mm(struct mm_struct *mm)
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	cpumask_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
 
 	if (current->active_mm == mm) {
 		if (current->mm)
@@ -263,8 +273,8 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 			leave_mm(smp_processor_id());
 	}
 
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, va);
+	if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(&mm->cpu_vm_mask, mm, va);
 
 	preempt_enable();
 }
@@ -274,7 +284,7 @@ static void do_flush_tlb_all(void *info)
 	unsigned long cpu = smp_processor_id();
 
 	__flush_tlb_all();
-	if (read_pda(mmu_state) == TLBSTATE_LAZY)
+	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
 		leave_mm(cpu);
 }
 
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index f885023..690dcf1 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -212,11 +212,11 @@ static int uv_wait_completion(struct bau_desc *bau_desc,
  * The cpumaskp mask contains the cpus the broadcast was sent to.
  *
  * Returns 1 if all remote flushing was done. The mask is zeroed.
- * Returns 0 if some remote flushing remains to be done. The mask is left
- * unchanged.
+ * Returns 0 if some remote flushing remains to be done. The mask will have
+ * some bits still set.
  */
 int uv_flush_send_and_wait(int cpu, int this_blade, struct bau_desc *bau_desc,
-			   cpumask_t *cpumaskp)
+			   struct cpumask *cpumaskp)
 {
 	int completion_status = 0;
 	int right_shift;
@@ -263,13 +263,13 @@ int uv_flush_send_and_wait(int cpu, int this_blade, struct bau_desc *bau_desc,
 	 * Success, so clear the remote cpu's from the mask so we don't
 	 * use the IPI method of shootdown on them.
 	 */
-	for_each_cpu_mask(bit, *cpumaskp) {
+	for_each_cpu(bit, cpumaskp) {
 		blade = uv_cpu_to_blade_id(bit);
 		if (blade == this_blade)
 			continue;
-		cpu_clear(bit, *cpumaskp);
+		cpumask_clear_cpu(bit, cpumaskp);
 	}
-	if (!cpus_empty(*cpumaskp))
+	if (!cpumask_empty(cpumaskp))
 		return 0;
 	return 1;
 }
@@ -296,7 +296,7 @@ int uv_flush_send_and_wait(int cpu, int this_blade, struct bau_desc *bau_desc,
  * Returns 1 if all remote flushing was done.
  * Returns 0 if some remote flushing remains to be done.
  */
-int uv_flush_tlb_others(cpumask_t *cpumaskp, struct mm_struct *mm,
+int uv_flush_tlb_others(struct cpumask *cpumaskp, struct mm_struct *mm,
 			unsigned long va)
 {
 	int i;
@@ -315,7 +315,7 @@ int uv_flush_tlb_others(cpumask_t *cpumaskp, struct mm_struct *mm,
 	bau_nodes_clear(&bau_desc->distribution, UV_DISTRIBUTION_SIZE);
 
 	i = 0;
-	for_each_cpu_mask(bit, *cpumaskp) {
+	for_each_cpu(bit, cpumaskp) {
 		blade = uv_cpu_to_blade_id(bit);
 		BUG_ON(blade > (UV_DISTRIBUTION_SIZE - 1));
 		if (blade == this_blade) {
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 82c6755..3eba7f7 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -178,14 +178,7 @@ SECTIONS
 	__initramfs_end = .;
   }
 #endif
-  . = ALIGN(PAGE_SIZE);
-  .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
-	__per_cpu_start = .;
-	*(.data.percpu.page_aligned)
-	*(.data.percpu)
-	*(.data.percpu.shared_aligned)
-	__per_cpu_end = .;
-  }
+  PERCPU(PAGE_SIZE)
   . = ALIGN(PAGE_SIZE);
   /* freed after init ends here */
 
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 1a614c0..a09abb8 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -5,6 +5,7 @@
 #define LOAD_OFFSET __START_KERNEL_map
 
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/asm-offsets.h>
 #include <asm/page.h>
 
 #undef i386	/* in case the preprocessor is a 32bit one */
@@ -13,12 +14,14 @@ OUTPUT_FORMAT("elf64-x86-64", "elf64-x86-64", "elf64-x86-64")
 OUTPUT_ARCH(i386:x86-64)
 ENTRY(phys_startup_64)
 jiffies_64 = jiffies;
-_proxy_pda = 1;
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
 	data PT_LOAD FLAGS(7);	/* RWE */
 	user PT_LOAD FLAGS(7);	/* RWE */
 	data.init PT_LOAD FLAGS(7);	/* RWE */
+#ifdef CONFIG_SMP
+	percpu PT_LOAD FLAGS(7);	/* RWE */
+#endif
 	note PT_NOTE FLAGS(0);	/* ___ */
 }
 SECTIONS
@@ -208,14 +211,29 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
+#ifdef CONFIG_SMP
+  /*
+   * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
+   * output PHDR, so the next output section - __data_nosave - should
+   * switch it back to data.init.  Also, pda should be at the head of
+   * percpu area.  Preallocate it and define the percpu offset symbol
+   * so that it can be accessed as a percpu variable.
+   */
+  . = ALIGN(PAGE_SIZE);
+  PERCPU_VADDR_PREALLOC(0, :percpu, pda_size)
+  per_cpu____pda = __per_cpu_start;
+#else
   PERCPU(PAGE_SIZE)
+#endif
 
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
 
   . = ALIGN(PAGE_SIZE);
   __nosave_begin = .;
-  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) { *(.data.nosave) }
+  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
+      *(.data.nosave)
+  } :data.init	/* switch back to data.init, see PERCPU_VADDR() above */
   . = ALIGN(PAGE_SIZE);
   __nosave_end = .;
 
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 695e426..3909e3b 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -58,5 +58,3 @@ EXPORT_SYMBOL(__memcpy);
 EXPORT_SYMBOL(empty_zero_page);
 EXPORT_SYMBOL(init_level4_pgt);
 EXPORT_SYMBOL(load_gs_index);
-
-EXPORT_SYMBOL(_proxy_pda);
diff --git a/arch/x86/mach-voyager/setup.c b/arch/x86/mach-voyager/setup.c
index a580b95..0ade625 100644
--- a/arch/x86/mach-voyager/setup.c
+++ b/arch/x86/mach-voyager/setup.c
@@ -9,6 +9,7 @@
 #include <asm/e820.h>
 #include <asm/io.h>
 #include <asm/setup.h>
+#include <asm/cpu.h>
 
 void __init pre_intr_init_hook(void)
 {
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 9840b7e..96f15b0 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -402,7 +402,7 @@ void __init find_smp_config(void)
 	     VOYAGER_SUS_IN_CONTROL_PORT);
 
 	current_thread_info()->cpu = boot_cpu_id;
-	x86_write_percpu(cpu_number, boot_cpu_id);
+	percpu_write(cpu_number, boot_cpu_id);
 }
 
 /*
@@ -531,6 +531,7 @@ static void __init do_boot_cpu(__u8 cpu)
 	stack_start.sp = (void *)idle->thread.sp;
 
 	init_gdt(cpu);
+	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
 	per_cpu(current_task, cpu) = idle;
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	irq_ctx_init(cpu);
@@ -1748,6 +1749,7 @@ static void __init voyager_smp_prepare_cpus(unsigned int max_cpus)
 static void __cpuinit voyager_smp_prepare_boot_cpu(void)
 {
 	init_gdt(smp_processor_id());
+	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
 	switch_to_new_gdt();
 
 	cpu_set(smp_processor_id(), cpu_online_map);
@@ -1780,7 +1782,7 @@ static void __init voyager_smp_cpus_done(unsigned int max_cpus)
 void __init smp_setup_processor_id(void)
 {
 	current_thread_info()->cpu = hard_smp_processor_id();
-	x86_write_percpu(cpu_number, hard_smp_processor_id());
+	percpu_write(cpu_number, hard_smp_processor_id());
 }
 
 static void voyager_send_call_func(cpumask_t callmask)
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 88f1b10..4a6989e 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -49,7 +49,6 @@
 #include <asm/paravirt.h>
 #include <asm/setup.h>
 #include <asm/cacheflush.h>
-#include <asm/smp.h>
 
 unsigned int __VMALLOC_RESERVE = 128 << 20;
 
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 8b08fb9..c948851 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -333,11 +333,20 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 					      req_type & _PAGE_CACHE_MASK);
 	}
 
-	is_range_ram = pagerange_is_ram(start, end);
-	if (is_range_ram == 1)
-		return reserve_ram_pages_type(start, end, req_type, new_type);
-	else if (is_range_ram < 0)
-		return -EINVAL;
+	/*
+	 * For legacy reasons, some parts of the physical address range in the
+	 * legacy 1MB region is treated as non-RAM (even when listed as RAM in
+	 * the e820 tables).  So we will track the memory attributes of this
+	 * legacy 1MB region using the linear memtype_list always.
+	 */
+	if (end >= ISA_END_ADDRESS) {
+		is_range_ram = pagerange_is_ram(start, end);
+		if (is_range_ram == 1)
+			return reserve_ram_pages_type(start, end, req_type,
+						      new_type);
+		else if (is_range_ram < 0)
+			return -EINVAL;
+	}
 
 	new  = kmalloc(sizeof(struct memtype), GFP_KERNEL);
 	if (!new)
@@ -437,11 +446,19 @@ int free_memtype(u64 start, u64 end)
 	if (is_ISA_range(start, end - 1))
 		return 0;
 
-	is_range_ram = pagerange_is_ram(start, end);
-	if (is_range_ram == 1)
-		return free_ram_pages_type(start, end);
-	else if (is_range_ram < 0)
-		return -EINVAL;
+	/*
+	 * For legacy reasons, some parts of the physical address range in the
+	 * legacy 1MB region is treated as non-RAM (even when listed as RAM in
+	 * the e820 tables).  So we will track the memory attributes of this
+	 * legacy 1MB region using the linear memtype_list always.
+	 */
+	if (end >= ISA_END_ADDRESS) {
+		is_range_ram = pagerange_is_ram(start, end);
+		if (is_range_ram == 1)
+			return free_ram_pages_type(start, end);
+		else if (is_range_ram < 0)
+			return -EINVAL;
+	}
 
 	spin_lock(&memtype_lock);
 	list_for_each_entry(entry, &memtype_list, nd) {
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index e9f80c7..07c9145 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -18,7 +18,7 @@
 #include <asm/msr.h>
 #include <asm/apic.h>
 #include <asm/nmi.h>
-#include <asm/intel_arch_perfmon.h>
+#include <asm/perf_counter.h>
 
 #include "op_x86_model.h"
 #include "op_counter.h"
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index bea2152..75b9413 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -634,35 +634,27 @@ static void xen_flush_tlb_single(unsigned long addr)
 	preempt_enable();
 }
 
-static void xen_flush_tlb_others(const cpumask_t *cpus, struct mm_struct *mm,
-				 unsigned long va)
+static void xen_flush_tlb_others(const struct cpumask *cpus,
+				 struct mm_struct *mm, unsigned long va)
 {
 	struct {
 		struct mmuext_op op;
-		cpumask_t mask;
+		DECLARE_BITMAP(mask, NR_CPUS);
 	} *args;
-	cpumask_t cpumask = *cpus;
 	struct multicall_space mcs;
 
-	/*
-	 * A couple of (to be removed) sanity checks:
-	 *
-	 * - current CPU must not be in mask
-	 * - mask must exist :)
-	 */
-	BUG_ON(cpus_empty(cpumask));
-	BUG_ON(cpu_isset(smp_processor_id(), cpumask));
+	BUG_ON(cpumask_empty(cpus));
 	BUG_ON(!mm);
 
-	/* If a CPU which we ran on has gone down, OK. */
-	cpus_and(cpumask, cpumask, cpu_online_map);
-	if (cpus_empty(cpumask))
-		return;
-
 	mcs = xen_mc_entry(sizeof(*args));
 	args = mcs.args;
-	args->mask = cpumask;
-	args->op.arg2.vcpumask = &args->mask;
+	args->op.arg2.vcpumask = to_cpumask(args->mask);
+
+	/* Remove us, and any offline CPUS. */
+	cpumask_and(to_cpumask(args->mask), cpus, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), to_cpumask(args->mask));
+	if (unlikely(cpumask_empty(to_cpumask(args->mask))))
+		goto issue;
 
 	if (va == TLB_FLUSH_ALL) {
 		args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
@@ -673,6 +665,7 @@ static void xen_flush_tlb_others(const cpumask_t *cpus, struct mm_struct *mm,
 
 	MULTI_mmuext_op(mcs.mc, &args->op, 1, NULL, DOMID_SELF);
 
+issue:
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 }
 
@@ -702,17 +695,17 @@ static void xen_write_cr0(unsigned long cr0)
 
 static void xen_write_cr2(unsigned long cr2)
 {
-	x86_read_percpu(xen_vcpu)->arch.cr2 = cr2;
+	percpu_read(xen_vcpu)->arch.cr2 = cr2;
 }
 
 static unsigned long xen_read_cr2(void)
 {
-	return x86_read_percpu(xen_vcpu)->arch.cr2;
+	return percpu_read(xen_vcpu)->arch.cr2;
 }
 
 static unsigned long xen_read_cr2_direct(void)
 {
-	return x86_read_percpu(xen_vcpu_info.arch.cr2);
+	return percpu_read(xen_vcpu_info.arch.cr2);
 }
 
 static void xen_write_cr4(unsigned long cr4)
@@ -725,12 +718,12 @@ static void xen_write_cr4(unsigned long cr4)
 
 static unsigned long xen_read_cr3(void)
 {
-	return x86_read_percpu(xen_cr3);
+	return percpu_read(xen_cr3);
 }
 
 static void set_current_cr3(void *v)
 {
-	x86_write_percpu(xen_current_cr3, (unsigned long)v);
+	percpu_write(xen_current_cr3, (unsigned long)v);
 }
 
 static void __xen_write_cr3(bool kernel, unsigned long cr3)
@@ -755,7 +748,7 @@ static void __xen_write_cr3(bool kernel, unsigned long cr3)
 	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
 
 	if (kernel) {
-		x86_write_percpu(xen_cr3, cr3);
+		percpu_write(xen_cr3, cr3);
 
 		/* Update xen_current_cr3 once the batch has actually
 		   been submitted. */
@@ -771,7 +764,7 @@ static void xen_write_cr3(unsigned long cr3)
 
 	/* Update while interrupts are disabled, so its atomic with
 	   respect to ipis */
-	x86_write_percpu(xen_cr3, cr3);
+	percpu_write(xen_cr3, cr3);
 
 	__xen_write_cr3(true, cr3);
 
@@ -1652,7 +1645,7 @@ asmlinkage void __init xen_start_kernel(void)
 #ifdef CONFIG_X86_64
 	/* Disable until direct per-cpu data access. */
 	have_vcpu_info_placement = 0;
-	x86_64_init_pda();
+	pda_init(0);
 #endif
 
 	xen_smp_init();
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index bb04260..2e82714 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -39,7 +39,7 @@ static unsigned long xen_save_fl(void)
 	struct vcpu_info *vcpu;
 	unsigned long flags;
 
-	vcpu = x86_read_percpu(xen_vcpu);
+	vcpu = percpu_read(xen_vcpu);
 
 	/* flag has opposite sense of mask */
 	flags = !vcpu->evtchn_upcall_mask;
@@ -62,7 +62,7 @@ static void xen_restore_fl(unsigned long flags)
 	   make sure we're don't switch CPUs between getting the vcpu
 	   pointer and updating the mask. */
 	preempt_disable();
-	vcpu = x86_read_percpu(xen_vcpu);
+	vcpu = percpu_read(xen_vcpu);
 	vcpu->evtchn_upcall_mask = flags;
 	preempt_enable_no_resched();
 
@@ -83,7 +83,7 @@ static void xen_irq_disable(void)
 	   make sure we're don't switch CPUs between getting the vcpu
 	   pointer and updating the mask. */
 	preempt_disable();
-	x86_read_percpu(xen_vcpu)->evtchn_upcall_mask = 1;
+	percpu_read(xen_vcpu)->evtchn_upcall_mask = 1;
 	preempt_enable_no_resched();
 }
 
@@ -96,7 +96,7 @@ static void xen_irq_enable(void)
 	   the caller is confused and is trying to re-enable interrupts
 	   on an indeterminate processor. */
 
-	vcpu = x86_read_percpu(xen_vcpu);
+	vcpu = percpu_read(xen_vcpu);
 	vcpu->evtchn_upcall_mask = 0;
 
 	/* Doesn't matter if we get preempted here, because any
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 503c240..98cb986 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1063,18 +1063,14 @@ static void drop_other_mm_ref(void *info)
 	struct mm_struct *mm = info;
 	struct mm_struct *active_mm;
 
-#ifdef CONFIG_X86_64
-	active_mm = read_pda(active_mm);
-#else
-	active_mm = __get_cpu_var(cpu_tlbstate).active_mm;
-#endif
+	active_mm = percpu_read(cpu_tlbstate.active_mm);
 
 	if (active_mm == mm)
 		leave_mm(smp_processor_id());
 
 	/* If this cpu still has a stale cr3 reference, then make sure
 	   it has been flushed. */
-	if (x86_read_percpu(xen_current_cr3) == __pa(mm->pgd)) {
+	if (percpu_read(xen_current_cr3) == __pa(mm->pgd)) {
 		load_cr3(swapper_pg_dir);
 		arch_flush_lazy_cpu_mode();
 	}
diff --git a/arch/x86/xen/multicalls.h b/arch/x86/xen/multicalls.h
index 8589382..e786fa7 100644
--- a/arch/x86/xen/multicalls.h
+++ b/arch/x86/xen/multicalls.h
@@ -39,7 +39,7 @@ static inline void xen_mc_issue(unsigned mode)
 		xen_mc_flush();
 
 	/* restore flags saved in xen_mc_batch */
-	local_irq_restore(x86_read_percpu(xen_mc_irq_flags));
+	local_irq_restore(percpu_read(xen_mc_irq_flags));
 }
 
 /* Set up a callback to be called when the current batch is flushed */
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index c44e206..72c2eb9 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -50,11 +50,7 @@ static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id);
  */
 static irqreturn_t xen_reschedule_interrupt(int irq, void *dev_id)
 {
-#ifdef CONFIG_X86_32
-	__get_cpu_var(irq_stat).irq_resched_count++;
-#else
-	add_pda(irq_resched_count, 1);
-#endif
+	inc_irq_stat(irq_resched_count);
 
 	return IRQ_HANDLED;
 }
@@ -78,7 +74,7 @@ static __cpuinit void cpu_bringup(void)
 	xen_setup_cpu_clockevents();
 
 	cpu_set(cpu, cpu_online_map);
-	x86_write_percpu(cpu_state, CPU_ONLINE);
+	percpu_write(cpu_state, CPU_ONLINE);
 	wmb();
 
 	/* We can take interrupts now: we're officially "up". */
@@ -283,22 +279,11 @@ static int __cpuinit xen_cpu_up(unsigned int cpu)
 	struct task_struct *idle = idle_task(cpu);
 	int rc;
 
-#ifdef CONFIG_X86_64
-	/* Allocate node local memory for AP pdas */
-	WARN_ON(cpu == 0);
-	if (cpu > 0) {
-		rc = get_local_pda(cpu);
-		if (rc)
-			return rc;
-	}
-#endif
-
+	per_cpu(current_task, cpu) = idle;
 #ifdef CONFIG_X86_32
 	init_gdt(cpu);
-	per_cpu(current_task, cpu) = idle;
 	irq_ctx_init(cpu);
 #else
-	cpu_pda(cpu)->pcurrent = idle;
 	clear_tsk_thread_flag(idle, TIF_FORK);
 #endif
 	xen_setup_timer(cpu);
@@ -445,11 +430,7 @@ static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
 {
 	irq_enter();
 	generic_smp_call_function_interrupt();
-#ifdef CONFIG_X86_32
-	__get_cpu_var(irq_stat).irq_call_count++;
-#else
-	add_pda(irq_call_count, 1);
-#endif
+	inc_irq_stat(irq_call_count);
 	irq_exit();
 
 	return IRQ_HANDLED;
@@ -459,11 +440,7 @@ static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id)
 {
 	irq_enter();
 	generic_smp_call_function_single_interrupt();
-#ifdef CONFIG_X86_32
-	__get_cpu_var(irq_stat).irq_call_count++;
-#else
-	add_pda(irq_call_count, 1);
-#endif
+	inc_irq_stat(irq_call_count);
 	irq_exit();
 
 	return IRQ_HANDLED;
diff --git a/arch/x86/xen/xen-asm_64.S b/arch/x86/xen/xen-asm_64.S
index 05794c5..d6fc51f 100644
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -17,6 +17,7 @@
 #include <asm/processor-flags.h>
 #include <asm/errno.h>
 #include <asm/segment.h>
+#include <asm/percpu.h>
 
 #include <xen/interface/xen.h>
 
@@ -28,12 +29,10 @@
 
 #if 1
 /*
-	x86-64 does not yet support direct access to percpu variables
-	via a segment override, so we just need to make sure this code
-	never gets used
+	FIXME: x86_64 now can support direct access to percpu variables
+	via a segment override.  Update xen accordingly.
  */
 #define BUG			ud2a
-#define PER_CPU_VAR(var, off)	0xdeadbeef
 #endif
 
 /*
@@ -45,14 +44,14 @@ ENTRY(xen_irq_enable_direct)
 	BUG
 
 	/* Unmask events */
-	movb $0, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
+	movb $0, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
 
 	/* Preempt here doesn't matter because that will deal with
 	   any pending interrupts.  The pending check may end up being
 	   run on the wrong CPU, but that doesn't hurt. */
 
 	/* Test for pending */
-	testb $0xff, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_pending)
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_pending
 	jz 1f
 
 2:	call check_events
@@ -69,7 +68,7 @@ ENDPATCH(xen_irq_enable_direct)
 ENTRY(xen_irq_disable_direct)
 	BUG
 
-	movb $1, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
+	movb $1, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
 ENDPATCH(xen_irq_disable_direct)
 	ret
 	ENDPROC(xen_irq_disable_direct)
@@ -87,7 +86,7 @@ ENDPATCH(xen_irq_disable_direct)
 ENTRY(xen_save_fl_direct)
 	BUG
 
-	testb $0xff, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
 	setz %ah
 	addb %ah,%ah
 ENDPATCH(xen_save_fl_direct)
@@ -107,13 +106,13 @@ ENTRY(xen_restore_fl_direct)
 	BUG
 
 	testb $X86_EFLAGS_IF>>8, %ah
-	setz PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
+	setz PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
 	/* Preempt here doesn't matter because that will deal with
 	   any pending interrupts.  The pending check may end up being
 	   run on the wrong CPU, but that doesn't hurt. */
 
 	/* check for unmasked and pending */
-	cmpw $0x0001, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_pending)
+	cmpw $0x0001, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_pending
 	jz 1f
 2:	call check_events
 1:
@@ -195,11 +194,11 @@ RELOC(xen_sysexit, 1b+1)
 ENTRY(xen_sysret64)
 	/* We're already on the usermode stack at this point, but still
 	   with the kernel gs, so we can easily switch back */
-	movq %rsp, %gs:pda_oldrsp
-	movq %gs:pda_kernelstack,%rsp
+	movq %rsp, PER_CPU_VAR(old_rsp)
+	movq PER_CPU_VAR(kernel_stack),%rsp
 
 	pushq $__USER_DS
-	pushq %gs:pda_oldrsp
+	pushq PER_CPU_VAR(old_rsp)
 	pushq %r11
 	pushq $__USER_CS
 	pushq %rcx
@@ -212,11 +211,11 @@ RELOC(xen_sysret64, 1b+1)
 ENTRY(xen_sysret32)
 	/* We're already on the usermode stack at this point, but still
 	   with the kernel gs, so we can easily switch back */
-	movq %rsp, %gs:pda_oldrsp
-	movq %gs:pda_kernelstack, %rsp
+	movq %rsp, PER_CPU_VAR(old_rsp)
+	movq PER_CPU_VAR(kernel_stack), %rsp
 
 	pushq $__USER32_DS
-	pushq %gs:pda_oldrsp
+	pushq PER_CPU_VAR(old_rsp)
 	pushq %r11
 	pushq $__USER32_CS
 	pushq %rcx
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 66a9d81..7acb23f 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -271,8 +271,11 @@ static atomic_t c3_cpu_count;
 /* Common C-state entry for C2, C3, .. */
 static void acpi_cstate_enter(struct acpi_processor_cx *cstate)
 {
+	u64 perf_flags;
+
 	/* Don't trace irqs off for idle */
 	stop_critical_timings();
+	perf_flags = hw_perf_save_disable();
 	if (cstate->entry_method == ACPI_CSTATE_FFH) {
 		/* Call into architectural FFH based C-state */
 		acpi_processor_ffh_cstate_enter(cstate);
@@ -285,6 +288,7 @@ static void acpi_cstate_enter(struct acpi_processor_cx *cstate)
 		   gets asserted in time to freeze execution properly. */
 		unused = inl(acpi_gbl_FADT.xpm_timer_block.address);
 	}
+	hw_perf_restore(perf_flags);
 	start_critical_timings();
 }
 #endif /* !CONFIG_CPU_IDLE */
@@ -1426,8 +1430,11 @@ static inline void acpi_idle_update_bm_rld(struct acpi_processor *pr,
  */
 static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
 {
+	u64 pctrl;
+
 	/* Don't trace irqs off for idle */
 	stop_critical_timings();
+	pctrl = hw_perf_save_disable();
 	if (cx->entry_method == ACPI_CSTATE_FFH) {
 		/* Call into architectural FFH based C-state */
 		acpi_processor_ffh_cstate_enter(cx);
@@ -1442,6 +1449,7 @@ static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
 		   gets asserted in time to freeze execution properly. */
 		unused = inl(acpi_gbl_FADT.xpm_timer_block.address);
 	}
+	hw_perf_restore(pctrl);
 	start_critical_timings();
 }
 
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 719ee5c..5b257a5 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -107,7 +107,7 @@ static SYSDEV_ATTR(crash_notes, 0400, show_crash_notes, NULL);
 /*
  * Print cpu online, possible, present, and system maps
  */
-static ssize_t print_cpus_map(char *buf, cpumask_t *map)
+static ssize_t print_cpus_map(char *buf, const struct cpumask *map)
 {
 	int n = cpulist_scnprintf(buf, PAGE_SIZE-2, map);
 
diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index a778fb5..bf6b132 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -31,7 +31,10 @@
 #include <linux/hardirq.h>
 #include <linux/topology.h>
 
-#define define_one_ro(_name) 		\
+#define define_one_ro_named(_name, _func)				\
+static SYSDEV_ATTR(_name, 0444, _func, NULL)
+
+#define define_one_ro(_name)				\
 static SYSDEV_ATTR(_name, 0444, show_##_name, NULL)
 
 #define define_id_show_func(name)				\
@@ -42,8 +45,8 @@ static ssize_t show_##name(struct sys_device *dev,		\
 	return sprintf(buf, "%d\n", topology_##name(cpu));	\
 }
 
-#if defined(topology_thread_siblings) || defined(topology_core_siblings)
-static ssize_t show_cpumap(int type, cpumask_t *mask, char *buf)
+#if defined(topology_thread_cpumask) || defined(topology_core_cpumask)
+static ssize_t show_cpumap(int type, const struct cpumask *mask, char *buf)
 {
 	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
 	int n = 0;
@@ -65,7 +68,7 @@ static ssize_t show_##name(struct sys_device *dev,			\
 			   struct sysdev_attribute *attr, char *buf)	\
 {									\
 	unsigned int cpu = dev->id;					\
-	return show_cpumap(0, &(topology_##name(cpu)), buf);		\
+	return show_cpumap(0, topology_##name(cpu), buf);		\
 }
 
 #define define_siblings_show_list(name)					\
@@ -74,7 +77,7 @@ static ssize_t show_##name##_list(struct sys_device *dev,		\
 				  char *buf)				\
 {									\
 	unsigned int cpu = dev->id;					\
-	return show_cpumap(1, &(topology_##name(cpu)), buf);		\
+	return show_cpumap(1, topology_##name(cpu), buf);		\
 }
 
 #else
@@ -82,9 +85,7 @@ static ssize_t show_##name##_list(struct sys_device *dev,		\
 static ssize_t show_##name(struct sys_device *dev,			\
 			   struct sysdev_attribute *attr, char *buf)	\
 {									\
-	unsigned int cpu = dev->id;					\
-	cpumask_t mask = topology_##name(cpu);				\
-	return show_cpumap(0, &mask, buf);				\
+	return show_cpumap(0, topology_##name(dev->id), buf);		\
 }
 
 #define define_siblings_show_list(name)					\
@@ -92,9 +93,7 @@ static ssize_t show_##name##_list(struct sys_device *dev,		\
 				  struct sysdev_attribute *attr,	\
 				  char *buf)				\
 {									\
-	unsigned int cpu = dev->id;					\
-	cpumask_t mask = topology_##name(cpu);				\
-	return show_cpumap(1, &mask, buf);				\
+	return show_cpumap(1, topology_##name(dev->id), buf);		\
 }
 #endif
 
@@ -107,13 +106,13 @@ define_one_ro(physical_package_id);
 define_id_show_func(core_id);
 define_one_ro(core_id);
 
-define_siblings_show_func(thread_siblings);
-define_one_ro(thread_siblings);
-define_one_ro(thread_siblings_list);
+define_siblings_show_func(thread_cpumask);
+define_one_ro_named(thread_siblings, show_thread_cpumask);
+define_one_ro_named(thread_siblings_list, show_thread_cpumask_list);
 
-define_siblings_show_func(core_siblings);
-define_one_ro(core_siblings);
-define_one_ro(core_siblings_list);
+define_siblings_show_func(core_cpumask);
+define_one_ro_named(core_siblings, show_core_cpumask);
+define_one_ro_named(core_siblings_list, show_core_cpumask_list);
 
 static struct attribute *default_attrs[] = {
 	&attr_physical_package_id.attr,
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 33a9351..fa71b84 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -25,6 +25,7 @@
 #include <linux/kbd_kern.h>
 #include <linux/proc_fs.h>
 #include <linux/quotaops.h>
+#include <linux/perf_counter.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/suspend.h>
@@ -244,6 +245,7 @@ static void sysrq_handle_showregs(int key, struct tty_struct *tty)
 	struct pt_regs *regs = get_irq_regs();
 	if (regs)
 		show_regs(regs);
+	perf_counter_print_debug();
 }
 static struct sysrq_key_op sysrq_showregs_op = {
 	.handler	= sysrq_handle_showregs,
diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index 777fba4..3009e01 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -244,7 +244,7 @@ static ssize_t host_control_on_shutdown_store(struct device *dev,
  */
 int dcdbas_smi_request(struct smi_cmd *smi_cmd)
 {
-	cpumask_t old_mask;
+	cpumask_var_t old_mask;
 	int ret = 0;
 
 	if (smi_cmd->magic != SMI_CMD_MAGIC) {
@@ -254,8 +254,11 @@ int dcdbas_smi_request(struct smi_cmd *smi_cmd)
 	}
 
 	/* SMI requires CPU 0 */
-	old_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(0));
+	if (!alloc_cpumask_var(&old_mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	cpumask_copy(old_mask, &current->cpus_allowed);
+	set_cpus_allowed_ptr(current, cpumask_of(0));
 	if (smp_processor_id() != 0) {
 		dev_dbg(&dcdbas_pdev->dev, "%s: failed to get CPU 0\n",
 			__func__);
@@ -275,7 +278,8 @@ int dcdbas_smi_request(struct smi_cmd *smi_cmd)
 	);
 
 out:
-	set_cpus_allowed_ptr(current, &old_mask);
+	set_cpus_allowed_ptr(current, old_mask);
+	free_cpumask_var(old_mask);
 	return ret;
 }
 
diff --git a/drivers/misc/sgi-xp/xpc_main.c b/drivers/misc/sgi-xp/xpc_main.c
index 89218f7..6576170 100644
--- a/drivers/misc/sgi-xp/xpc_main.c
+++ b/drivers/misc/sgi-xp/xpc_main.c
@@ -318,7 +318,7 @@ xpc_hb_checker(void *ignore)
 
 	/* this thread was marked active by xpc_hb_init() */
 
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(XPC_HB_CHECK_CPU));
+	set_cpus_allowed_ptr(current, cpumask_of(XPC_HB_CHECK_CPU));
 
 	/* set our heartbeating to other partitions into motion */
 	xpc_hb_check_timeout = jiffies + (xpc_hb_check_interval * HZ);
diff --git a/drivers/net/sfc/efx.c b/drivers/net/sfc/efx.c
index 7673fd9..101c00a 100644
--- a/drivers/net/sfc/efx.c
+++ b/drivers/net/sfc/efx.c
@@ -854,20 +854,27 @@ static void efx_fini_io(struct efx_nic *efx)
  * interrupts across them. */
 static int efx_wanted_rx_queues(void)
 {
-	cpumask_t core_mask;
+	cpumask_var_t core_mask;
 	int count;
 	int cpu;
 
-	cpus_clear(core_mask);
+	if (!alloc_cpumask_var(&core_mask, GFP_KERNEL)) {
+		printk(KERN_WARNING
+		       "efx.c: allocation failure, irq balancing hobbled\n");
+		return 1;
+	}
+
+	cpumask_clear(core_mask);
 	count = 0;
 	for_each_online_cpu(cpu) {
-		if (!cpu_isset(cpu, core_mask)) {
+		if (!cpumask_test_cpu(cpu, core_mask)) {
 			++count;
-			cpus_or(core_mask, core_mask,
-				topology_core_siblings(cpu));
+			cpumask_or(core_mask, core_mask,
+				   topology_core_cpumask(cpu));
 		}
 	}
 
+	free_cpumask_var(core_mask);
 	return count;
 }
 
diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 9da5a4b..c3ea5fa 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -38,7 +38,7 @@
 
 static LIST_HEAD(dying_tasks);
 static LIST_HEAD(dead_tasks);
-static cpumask_t marked_cpus = CPU_MASK_NONE;
+static cpumask_var_t marked_cpus;
 static DEFINE_SPINLOCK(task_mortuary);
 static void process_task_mortuary(void);
 
@@ -456,10 +456,10 @@ static void mark_done(int cpu)
 {
 	int i;
 
-	cpu_set(cpu, marked_cpus);
+	cpumask_set_cpu(cpu, marked_cpus);
 
 	for_each_online_cpu(i) {
-		if (!cpu_isset(i, marked_cpus))
+		if (!cpumask_test_cpu(i, marked_cpus))
 			return;
 	}
 
@@ -468,7 +468,7 @@ static void mark_done(int cpu)
 	 */
 	process_task_mortuary();
 
-	cpus_clear(marked_cpus);
+	cpumask_clear(marked_cpus);
 }
 
 
@@ -565,6 +565,20 @@ void sync_buffer(int cpu)
 	mutex_unlock(&buffer_mutex);
 }
 
+int __init buffer_sync_init(void)
+{
+	if (!alloc_cpumask_var(&marked_cpus, GFP_KERNEL))
+		return -ENOMEM;
+
+	cpumask_clear(marked_cpus);
+		return 0;
+}
+
+void __exit buffer_sync_cleanup(void)
+{
+	free_cpumask_var(marked_cpus);
+}
+
 /* The function can be used to add a buffer worth of data directly to
  * the kernel buffer. The buffer is assumed to be a circular buffer.
  * Take the entries from index start and end at index end, wrapping
diff --git a/drivers/oprofile/buffer_sync.h b/drivers/oprofile/buffer_sync.h
index 3110732..0ebf5db 100644
--- a/drivers/oprofile/buffer_sync.h
+++ b/drivers/oprofile/buffer_sync.h
@@ -19,4 +19,8 @@ void sync_stop(void);
 /* sync the given CPU's buffer */
 void sync_buffer(int cpu);
 
+/* initialize/destroy the buffer system. */
+int buffer_sync_init(void);
+void buffer_sync_cleanup(void);
+
 #endif /* OPROFILE_BUFFER_SYNC_H */
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index 3cffce9..ced39f6 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -183,6 +183,10 @@ static int __init oprofile_init(void)
 {
 	int err;
 
+	err = buffer_sync_init();
+	if (err)
+		return err;
+
 	err = oprofile_arch_init(&oprofile_ops);
 
 	if (err < 0 || timer) {
@@ -191,8 +195,10 @@ static int __init oprofile_init(void)
 	}
 
 	err = oprofilefs_register();
-	if (err)
+	if (err) {
 		oprofile_arch_exit();
+		buffer_sync_cleanup();
+	}
 
 	return err;
 }
@@ -202,6 +208,7 @@ static void __exit oprofile_exit(void)
 {
 	oprofilefs_unregister();
 	oprofile_arch_exit();
+	buffer_sync_cleanup();
 }
 
 
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index f78371b..5a57753 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -6,6 +6,7 @@
 #include <linux/irq.h>
 #include <asm/io_apic.h>
 #include <asm/smp.h>
+#include <asm/cpu.h>
 #include <linux/intel-iommu.h>
 #include "intr_remapping.h"
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index eb0dfde..3141e14 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -26,6 +26,7 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/bootmem.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq.h>
@@ -75,7 +76,14 @@ enum {
 static int evtchn_to_irq[NR_EVENT_CHANNELS] = {
 	[0 ... NR_EVENT_CHANNELS-1] = -1
 };
-static unsigned long cpu_evtchn_mask[NR_CPUS][NR_EVENT_CHANNELS/BITS_PER_LONG];
+struct cpu_evtchn_s {
+	unsigned long bits[NR_EVENT_CHANNELS/BITS_PER_LONG];
+};
+static struct cpu_evtchn_s *cpu_evtchn_mask_p;
+static inline unsigned long *cpu_evtchn_mask(int cpu)
+{
+	return cpu_evtchn_mask_p[cpu].bits;
+}
 static u8 cpu_evtchn[NR_EVENT_CHANNELS];
 
 /* Reference counts for bindings to IRQs. */
@@ -115,7 +123,7 @@ static inline unsigned long active_evtchns(unsigned int cpu,
 					   unsigned int idx)
 {
 	return (sh->evtchn_pending[idx] &
-		cpu_evtchn_mask[cpu][idx] &
+		cpu_evtchn_mask(cpu)[idx] &
 		~sh->evtchn_mask[idx]);
 }
 
@@ -125,11 +133,11 @@ static void bind_evtchn_to_cpu(unsigned int chn, unsigned int cpu)
 
 	BUG_ON(irq == -1);
 #ifdef CONFIG_SMP
-	irq_to_desc(irq)->affinity = cpumask_of_cpu(cpu);
+	cpumask_copy(irq_to_desc(irq)->affinity, cpumask_of(cpu));
 #endif
 
-	__clear_bit(chn, cpu_evtchn_mask[cpu_evtchn[chn]]);
-	__set_bit(chn, cpu_evtchn_mask[cpu]);
+	__clear_bit(chn, cpu_evtchn_mask(cpu_evtchn[chn]));
+	__set_bit(chn, cpu_evtchn_mask(cpu));
 
 	cpu_evtchn[chn] = cpu;
 }
@@ -142,12 +150,12 @@ static void init_evtchn_cpu_bindings(void)
 
 	/* By default all event channels notify CPU#0. */
 	for_each_irq_desc(i, desc) {
-		desc->affinity = cpumask_of_cpu(0);
+		cpumask_copy(desc->affinity, cpumask_of(0));
 	}
 #endif
 
 	memset(cpu_evtchn, 0, sizeof(cpu_evtchn));
-	memset(cpu_evtchn_mask[0], ~0, sizeof(cpu_evtchn_mask[0]));
+	memset(cpu_evtchn_mask(0), ~0, sizeof(cpu_evtchn_mask(0)));
 }
 
 static inline unsigned int cpu_from_evtchn(unsigned int evtchn)
@@ -822,6 +830,10 @@ static struct irq_chip xen_dynamic_chip __read_mostly = {
 void __init xen_init_IRQ(void)
 {
 	int i;
+	size_t size = nr_cpu_ids * sizeof(struct cpu_evtchn_s);
+
+	cpu_evtchn_mask_p = alloc_bootmem(size);
+	BUG_ON(cpu_evtchn_mask_p == NULL);
 
 	init_evtchn_cpu_bindings();
 
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 9b91617..e7e83b6 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -100,7 +100,7 @@ static void do_suspend(void)
 	/* XXX use normal device tree? */
 	xenbus_suspend();
 
-	err = stop_machine(xen_suspend, &cancelled, &cpumask_of_cpu(0));
+	err = stop_machine(xen_suspend, &cancelled, cpumask_of(0));
 	if (err) {
 		printk(KERN_ERR "failed to start xen_suspend: %d\n", err);
 		goto out;
diff --git a/fs/exec.c b/fs/exec.c
index 0dd60a0..97f9c22 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -33,6 +33,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
+#include <linux/perf_counter.h>
 #include <linux/highmem.h>
 #include <linux/spinlock.h>
 #include <linux/key.h>
@@ -1010,6 +1011,13 @@ int flush_old_exec(struct linux_binprm * bprm)
 
 	current->personality &= ~bprm->per_clear;
 
+	/*
+	 * Flush performance counters when crossing a
+	 * security domain:
+	 */
+	if (!get_dumpable(current->mm))
+		perf_counter_exit_task(current);
+
 	/* An exec changes our domain. We are no longer part of the thread
 	   group */
 
diff --git a/include/asm-generic/bitops/__ffs.h b/include/asm-generic/bitops/__ffs.h
index 9a3274a..937d7c4 100644
--- a/include/asm-generic/bitops/__ffs.h
+++ b/include/asm-generic/bitops/__ffs.h
@@ -9,7 +9,7 @@
  *
  * Undefined if no bit exists, so code should check against 0 first.
  */
-static inline unsigned long __ffs(unsigned long word)
+static __always_inline unsigned long __ffs(unsigned long word)
 {
 	int num = 0;
 
diff --git a/include/asm-generic/bitops/__fls.h b/include/asm-generic/bitops/__fls.h
index be24465..a60a7cc 100644
--- a/include/asm-generic/bitops/__fls.h
+++ b/include/asm-generic/bitops/__fls.h
@@ -9,7 +9,7 @@
  *
  * Undefined if no set bit exists, so code should check against 0 first.
  */
-static inline unsigned long __fls(unsigned long word)
+static __always_inline unsigned long __fls(unsigned long word)
 {
 	int num = BITS_PER_LONG - 1;
 
diff --git a/include/asm-generic/bitops/fls.h b/include/asm-generic/bitops/fls.h
index 850859b..0576d1f 100644
--- a/include/asm-generic/bitops/fls.h
+++ b/include/asm-generic/bitops/fls.h
@@ -9,7 +9,7 @@
  * Note fls(0) = 0, fls(1) = 1, fls(0x80000000) = 32.
  */
 
-static inline int fls(int x)
+static __always_inline int fls(int x)
 {
 	int r = 32;
 
diff --git a/include/asm-generic/bitops/fls64.h b/include/asm-generic/bitops/fls64.h
index 86d403f..b097cf8 100644
--- a/include/asm-generic/bitops/fls64.h
+++ b/include/asm-generic/bitops/fls64.h
@@ -15,7 +15,7 @@
  * at position 64.
  */
 #if BITS_PER_LONG == 32
-static inline int fls64(__u64 x)
+static __always_inline int fls64(__u64 x)
 {
 	__u32 h = x >> 32;
 	if (h)
@@ -23,7 +23,7 @@ static inline int fls64(__u64 x)
 	return fls(x);
 }
 #elif BITS_PER_LONG == 64
-static inline int fls64(__u64 x)
+static __always_inline int fls64(__u64 x)
 {
 	if (x == 0)
 		return 0;
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index b0e63c6..00f45ff 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -80,4 +80,56 @@ extern void setup_per_cpu_areas(void);
 #define DECLARE_PER_CPU(type, name) extern PER_CPU_ATTRIBUTES \
 					__typeof__(type) per_cpu_var(name)
 
+/*
+ * Optional methods for optimized non-lvalue per-cpu variable access.
+ *
+ * @var can be a percpu variable or a field of it and its size should
+ * equal char, int or long.  percpu_read() evaluates to a lvalue and
+ * all others to void.
+ *
+ * These operations are guaranteed to be atomic w.r.t. preemption.
+ * The generic versions use plain get/put_cpu_var().  Archs are
+ * encouraged to implement single-instruction alternatives which don't
+ * require preemption protection.
+ */
+#ifndef percpu_read
+# define percpu_read(var)						\
+  ({									\
+	typeof(per_cpu_var(var)) __tmp_var__;				\
+	__tmp_var__ = get_cpu_var(var);					\
+	put_cpu_var(var);						\
+	__tmp_var__;							\
+  })
+#endif
+
+#define __percpu_generic_to_op(var, val, op)				\
+do {									\
+	get_cpu_var(var) op val;					\
+	put_cpu_var(var);						\
+} while (0)
+
+#ifndef percpu_write
+# define percpu_write(var, val)		__percpu_generic_to_op(var, (val), =)
+#endif
+
+#ifndef percpu_add
+# define percpu_add(var, val)		__percpu_generic_to_op(var, (val), +=)
+#endif
+
+#ifndef percpu_sub
+# define percpu_sub(var, val)		__percpu_generic_to_op(var, (val), -=)
+#endif
+
+#ifndef percpu_and
+# define percpu_and(var, val)		__percpu_generic_to_op(var, (val), &=)
+#endif
+
+#ifndef percpu_or
+# define percpu_or(var, val)		__percpu_generic_to_op(var, (val), |=)
+#endif
+
+#ifndef percpu_xor
+# define percpu_xor(var, val)		__percpu_generic_to_op(var, (val), ^=)
+#endif
+
 #endif /* _ASM_GENERIC_PERCPU_H_ */
diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index 79a7ff9..4ce48e8 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -9,7 +9,7 @@ extern char __bss_start[], __bss_stop[];
 extern char __init_begin[], __init_end[];
 extern char _sinittext[], _einittext[];
 extern char _end[];
-extern char __per_cpu_start[], __per_cpu_end[];
+extern char __per_cpu_load[], __per_cpu_start[], __per_cpu_end[];
 extern char __kprobes_text_start[], __kprobes_text_end[];
 extern char __initdata_begin[], __initdata_end[];
 extern char __start_rodata[], __end_rodata[];
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index c61fab1..aa6b9b1 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -430,12 +430,75 @@
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
 
-#define PERCPU(align)							\
-	. = ALIGN(align);						\
-	VMLINUX_SYMBOL(__per_cpu_start) = .;				\
-	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
+#define PERCPU_PROLOG(vaddr)						\
+	VMLINUX_SYMBOL(__per_cpu_load) = .;				\
+	.data.percpu vaddr : AT(VMLINUX_SYMBOL(__per_cpu_load)		\
+				- LOAD_OFFSET) {			\
+		VMLINUX_SYMBOL(__per_cpu_start) = .;
+
+#define PERCPU_EPILOG(phdr)						\
+		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
+	} phdr								\
+	. = VMLINUX_SYMBOL(__per_cpu_load) + SIZEOF(.data.percpu);
+
+/**
+ * PERCPU_VADDR_PREALLOC - define output section for percpu area with prealloc
+ * @vaddr: explicit base address (optional)
+ * @phdr: destination PHDR (optional)
+ * @prealloc: the size of prealloc area
+ *
+ * Macro which expands to output section for percpu area.  If @vaddr
+ * is not blank, it specifies explicit base address and all percpu
+ * symbols will be offset from the given address.  If blank, @vaddr
+ * always equals @laddr + LOAD_OFFSET.
+ *
+ * @phdr defines the output PHDR to use if not blank.  Be warned that
+ * output PHDR is sticky.  If @phdr is specified, the next output
+ * section in the linker script will go there too.  @phdr should have
+ * a leading colon.
+ *
+ * If @prealloc is non-zero, the specified number of bytes will be
+ * reserved at the start of percpu area.  As the prealloc area is
+ * likely to break alignment, this macro puts areas in increasing
+ * alignment order.
+ *
+ * This macro defines three symbols, __per_cpu_load, __per_cpu_start
+ * and __per_cpu_end.  The first one is the vaddr of loaded percpu
+ * init data.  __per_cpu_start equals @vaddr and __per_cpu_end is the
+ * end offset.
+ */
+#define PERCPU_VADDR_PREALLOC(vaddr, segment, prealloc)			\
+	PERCPU_PROLOG(vaddr)						\
+		. += prealloc;						\
+		*(.data.percpu)						\
+		*(.data.percpu.shared_aligned)				\
+		*(.data.percpu.page_aligned)				\
+	PERCPU_EPILOG(segment)
+
+/**
+ * PERCPU_VADDR - define output section for percpu area
+ * @vaddr: explicit base address (optional)
+ * @phdr: destination PHDR (optional)
+ *
+ * Macro which expands to output section for percpu area.  Mostly
+ * identical to PERCPU_VADDR_PREALLOC(@vaddr, @phdr, 0) other than
+ * using slighly different layout.
+ */
+#define PERCPU_VADDR(vaddr, phdr)					\
+	PERCPU_PROLOG(vaddr)						\
 		*(.data.percpu.page_aligned)				\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
-	}								\
-	VMLINUX_SYMBOL(__per_cpu_end) = .;
+	PERCPU_EPILOG(phdr)
+
+/**
+ * PERCPU - define output section for percpu area, simple version
+ * @align: required alignment
+ *
+ * Align to @align and outputs output section for percpu area.  This
+ * macro doesn't maniuplate @vaddr or @phdr and __per_cpu_load and
+ * __per_cpu_start will be identical.
+ */
+#define PERCPU(align)							\
+	. = ALIGN(align);						\
+	PERCPU_VADDR( , )
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 2f3c2d4..49a40fb 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -115,6 +115,16 @@ extern struct group_info init_groups;
 
 extern struct cred init_cred;
 
+#ifdef CONFIG_PERF_COUNTERS
+# define INIT_PERF_COUNTERS(tsk)					\
+	.perf_counter_ctx.counter_list =				\
+		LIST_HEAD_INIT(tsk.perf_counter_ctx.counter_list),	\
+	.perf_counter_ctx.lock =					\
+		__SPIN_LOCK_UNLOCKED(tsk.perf_counter_ctx.lock),
+#else
+# define INIT_PERF_COUNTERS(tsk)
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -179,6 +189,7 @@ extern struct cred init_cred;
 	INIT_IDS							\
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
+	INIT_PERF_COUNTERS(tsk)						\
 }
 
 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 9127f6b..472f117 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -467,6 +467,7 @@ int show_interrupts(struct seq_file *p, void *v);
 struct irq_desc;
 
 extern int early_irq_init(void);
+extern int arch_probe_nr_irqs(void);
 extern int arch_early_irq_init(void);
 extern int arch_init_chip_data(struct irq_desc *desc, int cpu);
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index f899b50..27a6753 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -182,11 +182,11 @@ struct irq_desc {
 	unsigned int		irqs_unhandled;
 	spinlock_t		lock;
 #ifdef CONFIG_SMP
-	cpumask_t		affinity;
+	cpumask_var_t		affinity;
 	unsigned int		cpu;
-#endif
 #ifdef CONFIG_GENERIC_PENDING_IRQ
-	cpumask_t		pending_mask;
+	cpumask_var_t		pending_mask;
+#endif
 #endif
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry	*dir;
@@ -422,4 +422,84 @@ extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
 
 #endif /* !CONFIG_S390 */
 
+#ifdef CONFIG_SMP
+/**
+ * init_alloc_desc_masks - allocate cpumasks for irq_desc
+ * @desc:	pointer to irq_desc struct
+ * @cpu:	cpu which will be handling the cpumasks
+ * @boot:	true if need bootmem
+ *
+ * Allocates affinity and pending_mask cpumask if required.
+ * Returns true if successful (or not required).
+ * Side effect: affinity has all bits set, pending_mask has all bits clear.
+ */
+static inline bool init_alloc_desc_masks(struct irq_desc *desc, int cpu,
+								bool boot)
+{
+	int node;
+
+	if (boot) {
+		alloc_bootmem_cpumask_var(&desc->affinity);
+		cpumask_setall(desc->affinity);
+
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+		alloc_bootmem_cpumask_var(&desc->pending_mask);
+		cpumask_clear(desc->pending_mask);
+#endif
+		return true;
+	}
+
+	node = cpu_to_node(cpu);
+
+	if (!alloc_cpumask_var_node(&desc->affinity, GFP_ATOMIC, node))
+		return false;
+	cpumask_setall(desc->affinity);
+
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	if (!alloc_cpumask_var_node(&desc->pending_mask, GFP_ATOMIC, node)) {
+		free_cpumask_var(desc->affinity);
+		return false;
+	}
+	cpumask_clear(desc->pending_mask);
+#endif
+	return true;
+}
+
+/**
+ * init_copy_desc_masks - copy cpumasks for irq_desc
+ * @old_desc:	pointer to old irq_desc struct
+ * @new_desc:	pointer to new irq_desc struct
+ *
+ * Insures affinity and pending_masks are copied to new irq_desc.
+ * If !CONFIG_CPUMASKS_OFFSTACK the cpumasks are embedded in the
+ * irq_desc struct so the copy is redundant.
+ */
+
+static inline void init_copy_desc_masks(struct irq_desc *old_desc,
+					struct irq_desc *new_desc)
+{
+#ifdef CONFIG_CPUMASKS_OFFSTACK
+	cpumask_copy(new_desc->affinity, old_desc->affinity);
+
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	cpumask_copy(new_desc->pending_mask, old_desc->pending_mask);
+#endif
+#endif
+}
+
+#else /* !CONFIG_SMP */
+
+static inline bool init_alloc_desc_masks(struct irq_desc *desc, int cpu,
+								bool boot)
+{
+	return true;
+}
+
+static inline void init_copy_desc_masks(struct irq_desc *old_desc,
+					struct irq_desc *new_desc)
+{
+}
+
+#endif	/* CONFIG_SMP */
+
 #endif /* _LINUX_IRQ_H */
diff --git a/include/linux/irqnr.h b/include/linux/irqnr.h
index 86af92e..887477b 100644
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
@@ -20,6 +20,7 @@
 
 # define for_each_irq_desc_reverse(irq, desc)                          \
 	for (irq = nr_irqs - 1; irq >= 0; irq--)
+
 #else /* CONFIG_GENERIC_HARDIRQS */
 
 extern int nr_irqs;
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 570d204..ecfa668 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -78,7 +78,15 @@ static inline unsigned int kstat_irqs(unsigned int irq)
 	return sum;
 }
 
+
+/*
+ * Lock/unlock the current runqueue - to extract task statistics:
+ */
+extern void curr_rq_lock_irq_save(unsigned long *flags);
+extern void curr_rq_unlock_irq_restore(unsigned long *flags);
+extern unsigned long long __task_delta_exec(struct task_struct *tsk, int update);
 extern unsigned long long task_delta_exec(struct task_struct *);
+
 extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
 extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
 extern void account_steal_time(cputime_t);
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
new file mode 100644
index 0000000..33ba9fe
--- /dev/null
+++ b/include/linux/perf_counter.h
@@ -0,0 +1,290 @@
+/*
+ *  Performance counters:
+ *
+ *   Copyright(C) 2008, Thomas Gleixner <tglx@linutronix.de>
+ *   Copyright(C) 2008, Red Hat, Inc., Ingo Molnar
+ *
+ *  Data type definitions, declarations, prototypes.
+ *
+ *  Started by: Thomas Gleixner and Ingo Molnar
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+#ifndef _LINUX_PERF_COUNTER_H
+#define _LINUX_PERF_COUNTER_H
+
+#include <asm/atomic.h>
+#include <asm/ioctl.h>
+
+#ifdef CONFIG_PERF_COUNTERS
+# include <asm/perf_counter.h>
+#endif
+
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/rculist.h>
+#include <linux/rcupdate.h>
+#include <linux/spinlock.h>
+
+struct task_struct;
+
+/*
+ * User-space ABI bits:
+ */
+
+/*
+ * Generalized performance counter event types, used by the hw_event.type
+ * parameter of the sys_perf_counter_open() syscall:
+ */
+enum hw_event_types {
+	/*
+	 * Common hardware events, generalized by the kernel:
+	 */
+	PERF_COUNT_CPU_CYCLES		=  0,
+	PERF_COUNT_INSTRUCTIONS		=  1,
+	PERF_COUNT_CACHE_REFERENCES	=  2,
+	PERF_COUNT_CACHE_MISSES		=  3,
+	PERF_COUNT_BRANCH_INSTRUCTIONS	=  4,
+	PERF_COUNT_BRANCH_MISSES	=  5,
+	PERF_COUNT_BUS_CYCLES		=  6,
+
+	PERF_HW_EVENTS_MAX		=  7,
+
+	/*
+	 * Special "software" counters provided by the kernel, even if
+	 * the hardware does not support performance counters. These
+	 * counters measure various physical and sw events of the
+	 * kernel (and allow the profiling of them as well):
+	 */
+	PERF_COUNT_CPU_CLOCK		= -1,
+	PERF_COUNT_TASK_CLOCK		= -2,
+	PERF_COUNT_PAGE_FAULTS		= -3,
+	PERF_COUNT_CONTEXT_SWITCHES	= -4,
+	PERF_COUNT_CPU_MIGRATIONS	= -5,
+
+	PERF_SW_EVENTS_MIN		= -6,
+};
+
+/*
+ * IRQ-notification data record type:
+ */
+enum perf_counter_record_type {
+	PERF_RECORD_SIMPLE		=  0,
+	PERF_RECORD_IRQ			=  1,
+	PERF_RECORD_GROUP		=  2,
+};
+
+/*
+ * Hardware event to monitor via a performance monitoring counter:
+ */
+struct perf_counter_hw_event {
+	s64			type;
+
+	u64			irq_period;
+	u32			record_type;
+
+	u32			disabled     :  1, /* off by default      */
+				nmi	     :  1, /* NMI sampling        */
+				raw	     :  1, /* raw event type      */
+				inherit	     :  1, /* children inherit it */
+				pinned	     :  1, /* must always be on PMU */
+				exclusive    :  1, /* only counter on PMU */
+
+				__reserved_1 : 26;
+
+	u64			__reserved_2;
+};
+
+/*
+ * Ioctls that can be done on a perf counter fd:
+ */
+#define PERF_COUNTER_IOC_ENABLE		_IO('$', 0)
+#define PERF_COUNTER_IOC_DISABLE	_IO('$', 1)
+
+/*
+ * Kernel-internal data types:
+ */
+
+/**
+ * struct hw_perf_counter - performance counter hardware details:
+ */
+struct hw_perf_counter {
+#ifdef CONFIG_PERF_COUNTERS
+	u64				config;
+	unsigned long			config_base;
+	unsigned long			counter_base;
+	int				nmi;
+	unsigned int			idx;
+	atomic64_t			prev_count;
+	u64				irq_period;
+	atomic64_t			period_left;
+#endif
+};
+
+/*
+ * Hardcoded buffer length limit for now, for IRQ-fed events:
+ */
+#define PERF_DATA_BUFLEN		2048
+
+/**
+ * struct perf_data - performance counter IRQ data sampling ...
+ */
+struct perf_data {
+	int				len;
+	int				rd_idx;
+	int				overrun;
+	u8				data[PERF_DATA_BUFLEN];
+};
+
+struct perf_counter;
+
+/**
+ * struct hw_perf_counter_ops - performance counter hw ops
+ */
+struct hw_perf_counter_ops {
+	int (*enable)			(struct perf_counter *counter);
+	void (*disable)			(struct perf_counter *counter);
+	void (*read)			(struct perf_counter *counter);
+};
+
+/**
+ * enum perf_counter_active_state - the states of a counter
+ */
+enum perf_counter_active_state {
+	PERF_COUNTER_STATE_ERROR	= -2,
+	PERF_COUNTER_STATE_OFF		= -1,
+	PERF_COUNTER_STATE_INACTIVE	=  0,
+	PERF_COUNTER_STATE_ACTIVE	=  1,
+};
+
+struct file;
+
+/**
+ * struct perf_counter - performance counter kernel representation:
+ */
+struct perf_counter {
+#ifdef CONFIG_PERF_COUNTERS
+	struct list_head		list_entry;
+	struct list_head		sibling_list;
+	struct perf_counter		*group_leader;
+	const struct hw_perf_counter_ops *hw_ops;
+
+	enum perf_counter_active_state	state;
+	atomic64_t			count;
+
+	struct perf_counter_hw_event	hw_event;
+	struct hw_perf_counter		hw;
+
+	struct perf_counter_context	*ctx;
+	struct task_struct		*task;
+	struct file			*filp;
+
+	struct perf_counter		*parent;
+	struct list_head		child_list;
+
+	/*
+	 * Protect attach/detach and child_list:
+	 */
+	struct mutex			mutex;
+
+	int				oncpu;
+	int				cpu;
+
+	/* read() / irq related data */
+	wait_queue_head_t		waitq;
+	/* optional: for NMIs */
+	int				wakeup_pending;
+	struct perf_data		*irqdata;
+	struct perf_data		*usrdata;
+	struct perf_data		data[2];
+#endif
+};
+
+/**
+ * struct perf_counter_context - counter context structure
+ *
+ * Used as a container for task counters and CPU counters as well:
+ */
+struct perf_counter_context {
+#ifdef CONFIG_PERF_COUNTERS
+	/*
+	 * Protect the states of the counters in the list,
+	 * nr_active, and the list:
+	 */
+	spinlock_t		lock;
+	/*
+	 * Protect the list of counters.  Locking either mutex or lock
+	 * is sufficient to ensure the list doesn't change; to change
+	 * the list you need to lock both the mutex and the spinlock.
+	 */
+	struct mutex		mutex;
+
+	struct list_head	counter_list;
+	int			nr_counters;
+	int			nr_active;
+	int			is_active;
+	struct task_struct	*task;
+#endif
+};
+
+/**
+ * struct perf_counter_cpu_context - per cpu counter context structure
+ */
+struct perf_cpu_context {
+	struct perf_counter_context	ctx;
+	struct perf_counter_context	*task_ctx;
+	int				active_oncpu;
+	int				max_pertask;
+	int				exclusive;
+};
+
+/*
+ * Set by architecture code:
+ */
+extern int perf_max_counters;
+
+#ifdef CONFIG_PERF_COUNTERS
+extern const struct hw_perf_counter_ops *
+hw_perf_counter_init(struct perf_counter *counter);
+
+extern void perf_counter_task_sched_in(struct task_struct *task, int cpu);
+extern void perf_counter_task_sched_out(struct task_struct *task, int cpu);
+extern void perf_counter_task_tick(struct task_struct *task, int cpu);
+extern void perf_counter_init_task(struct task_struct *child);
+extern void perf_counter_exit_task(struct task_struct *child);
+extern void perf_counter_notify(struct pt_regs *regs);
+extern void perf_counter_print_debug(void);
+extern u64 hw_perf_save_disable(void);
+extern void hw_perf_restore(u64 ctrl);
+extern int perf_counter_task_disable(void);
+extern int perf_counter_task_enable(void);
+extern int hw_perf_group_sched_in(struct perf_counter *group_leader,
+	       struct perf_cpu_context *cpuctx,
+	       struct perf_counter_context *ctx, int cpu);
+
+/*
+ * Return 1 for a software counter, 0 for a hardware counter
+ */
+static inline int is_software_counter(struct perf_counter *counter)
+{
+	return !counter->hw_event.raw && counter->hw_event.type < 0;
+}
+
+#else
+static inline void
+perf_counter_task_sched_in(struct task_struct *task, int cpu)		{ }
+static inline void
+perf_counter_task_sched_out(struct task_struct *task, int cpu)		{ }
+static inline void
+perf_counter_task_tick(struct task_struct *task, int cpu)		{ }
+static inline void perf_counter_init_task(struct task_struct *child)	{ }
+static inline void perf_counter_exit_task(struct task_struct *child)	{ }
+static inline void perf_counter_notify(struct pt_regs *regs)		{ }
+static inline void perf_counter_print_debug(void)			{ }
+static inline void hw_perf_restore(u64 ctrl)			{ }
+static inline u64 hw_perf_save_disable(void)		      { return 0; }
+static inline int perf_counter_task_disable(void)	{ return -EINVAL; }
+static inline int perf_counter_task_enable(void)	{ return -EINVAL; }
+#endif
+
+#endif /* _LINUX_PERF_COUNTER_H */
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index 48d887e..b00df4c 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -85,4 +85,7 @@
 #define PR_SET_TIMERSLACK 29
 #define PR_GET_TIMERSLACK 30
 
+#define PR_TASK_PERF_COUNTERS_DISABLE		31
+#define PR_TASK_PERF_COUNTERS_ENABLE		32
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4cae9b8..f134a0f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -71,6 +71,7 @@ struct sched_param {
 #include <linux/fs_struct.h>
 #include <linux/compiler.h>
 #include <linux/completion.h>
+#include <linux/perf_counter.h>
 #include <linux/pid.h>
 #include <linux/percpu.h>
 #include <linux/topology.h>
@@ -1031,6 +1032,8 @@ struct sched_entity {
 	u64			last_wakeup;
 	u64			avg_overlap;
 
+	u64			nr_migrations;
+
 #ifdef CONFIG_SCHEDSTATS
 	u64			wait_start;
 	u64			wait_max;
@@ -1046,7 +1049,6 @@ struct sched_entity {
 	u64			exec_max;
 	u64			slice_max;
 
-	u64			nr_migrations;
 	u64			nr_migrations_cold;
 	u64			nr_failed_migrations_affine;
 	u64			nr_failed_migrations_running;
@@ -1349,6 +1351,7 @@ struct task_struct {
 	struct list_head pi_state_list;
 	struct futex_pi_state *pi_state_cache;
 #endif
+	struct perf_counter_context perf_counter_ctx;
 #ifdef CONFIG_NUMA
 	struct mempolicy *mempolicy;
 	short il_next;
@@ -2322,6 +2325,13 @@ static inline void inc_syscw(struct task_struct *tsk)
 #define TASK_SIZE_OF(tsk)	TASK_SIZE
 #endif
 
+/*
+ * Call the function if the target task is executing on a CPU right now:
+ */
+extern void task_oncpu_function_call(struct task_struct *p,
+				     void (*func) (void *info), void *info);
+
+
 #ifdef CONFIG_MM_OWNER
 extern void mm_update_next_owner(struct mm_struct *mm);
 extern void mm_init_owner(struct mm_struct *mm, struct task_struct *p);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 16875f8..fc81937 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -55,6 +55,7 @@ struct compat_timeval;
 struct robust_list_head;
 struct getcpu_cache;
 struct old_linux_dirent;
+struct perf_counter_hw_event;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -689,4 +690,11 @@ asmlinkage long sys_pipe(int __user *);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
+
+asmlinkage int sys_perf_counter_open(
+
+	struct perf_counter_hw_event	*hw_event_uptr		__user,
+	pid_t				pid,
+	int				cpu,
+	int				group_fd);
 #endif
diff --git a/include/linux/topology.h b/include/linux/topology.h
index e632d29..a16b9e0 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -193,5 +193,11 @@ int arch_update_cpu_topology(void);
 #ifndef topology_core_siblings
 #define topology_core_siblings(cpu)		cpumask_of_cpu(cpu)
 #endif
+#ifndef topology_thread_cpumask
+#define topology_thread_cpumask(cpu)		cpumask_of(cpu)
+#endif
+#ifndef topology_core_cpumask
+#define topology_core_cpumask(cpu)		cpumask_of(cpu)
+#endif
 
 #endif /* _LINUX_TOPOLOGY_H */
diff --git a/init/Kconfig b/init/Kconfig
index 2af8382..6af96b7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -776,6 +776,36 @@ config AIO
           by some high performance threaded applications. Disabling
           this option saves about 7k.
 
+config HAVE_PERF_COUNTERS
+	bool
+
+menu "Performance Counters"
+
+config PERF_COUNTERS
+	bool "Kernel Performance Counters"
+	depends on HAVE_PERF_COUNTERS
+	default y
+	select ANON_INODES
+	help
+	  Enable kernel support for performance counter hardware.
+
+	  Performance counters are special hardware registers available
+	  on most modern CPUs. These registers count the number of certain
+	  types of hw events: such as instructions executed, cachemisses
+	  suffered, or branches mis-predicted - without slowing down the
+	  kernel or applications. These registers can also trigger interrupts
+	  when a threshold number of events have passed - and can thus be
+	  used to profile the code that runs on that CPU.
+
+	  The Linux Performance Counter subsystem provides an abstraction of
+	  these hardware capabilities, available via a system call. It
+	  provides per task and per CPU counters, and it provides event
+	  capabilities on top of those.
+
+	  Say Y if unsure.
+
+endmenu
+
 config VM_EVENT_COUNTERS
 	default y
 	bool "Enable VM event counters for /proc/vmstat" if EMBEDDED
diff --git a/kernel/Makefile b/kernel/Makefile
index 170a921..5537554 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -92,6 +92,7 @@ obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
+obj-$(CONFIG_PERF_COUNTERS) += perf_counter.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/exit.c b/kernel/exit.c
index f80dec3..29f4b79 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -159,6 +159,9 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
 {
 	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);
 
+#ifdef CONFIG_PERF_COUNTERS
+	WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
+#endif
 	trace_sched_process_free(tsk);
 	put_task_struct(tsk);
 }
@@ -1093,10 +1096,6 @@ NORET_TYPE void do_exit(long code)
 	tsk->mempolicy = NULL;
 #endif
 #ifdef CONFIG_FUTEX
-	/*
-	 * This must happen late, after the PID is not
-	 * hashed anymore:
-	 */
 	if (unlikely(!list_empty(&tsk->pi_state_list)))
 		exit_pi_state_list(tsk);
 	if (unlikely(current->pi_state_cache))
@@ -1363,6 +1362,12 @@ static int wait_task_zombie(struct task_struct *p, int options,
 	 */
 	read_unlock(&tasklist_lock);
 
+	/*
+	 * Flush inherited counters to the parent - before the parent
+	 * gets woken up by child-exit notifications.
+	 */
+	perf_counter_exit_task(p);
+
 	retval = ru ? getrusage(p, RUSAGE_BOTH, ru) : 0;
 	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
 		? p->signal->group_exit_code : p->exit_code;
diff --git a/kernel/fork.c b/kernel/fork.c
index bf0cef8..70ca185 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -985,6 +985,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto fork_out;
 
 	rt_mutex_init_task(p);
+	perf_counter_init_task(p);
 
 #ifdef CONFIG_PROVE_LOCKING
 	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index f63c706..c248eba 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -46,7 +46,10 @@ void dynamic_irq_init(unsigned int irq)
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
 #ifdef CONFIG_SMP
-	cpumask_setall(&desc->affinity);
+	cpumask_setall(desc->affinity);
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	cpumask_clear(desc->pending_mask);
+#endif
 #endif
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index c20db0b..375d68c 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -17,6 +17,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/rculist.h>
 #include <linux/hash.h>
+#include <linux/bootmem.h>
 
 #include "internals.h"
 
@@ -57,6 +58,7 @@ int nr_irqs = NR_IRQS;
 EXPORT_SYMBOL_GPL(nr_irqs);
 
 #ifdef CONFIG_SPARSE_IRQ
+
 static struct irq_desc irq_desc_init = {
 	.irq	    = -1,
 	.status	    = IRQ_DISABLED,
@@ -64,9 +66,6 @@ static struct irq_desc irq_desc_init = {
 	.handle_irq = handle_bad_irq,
 	.depth      = 1,
 	.lock       = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
-#ifdef CONFIG_SMP
-	.affinity   = CPU_MASK_ALL
-#endif
 };
 
 void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
@@ -101,6 +100,10 @@ static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
 		printk(KERN_ERR "can not alloc kstat_irqs\n");
 		BUG_ON(1);
 	}
+	if (!init_alloc_desc_masks(desc, cpu, false)) {
+		printk(KERN_ERR "can not alloc irq_desc cpumasks\n");
+		BUG_ON(1);
+	}
 	arch_init_chip_data(desc, cpu);
 }
 
@@ -109,7 +112,7 @@ static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
  */
 DEFINE_SPINLOCK(sparse_irq_lock);
 
-struct irq_desc *irq_desc_ptrs[NR_IRQS] __read_mostly;
+struct irq_desc **irq_desc_ptrs __read_mostly;
 
 static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS_LEGACY-1] = {
@@ -119,14 +122,10 @@ static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_sm
 		.handle_irq = handle_bad_irq,
 		.depth	    = 1,
 		.lock	    = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
-#ifdef CONFIG_SMP
-		.affinity   = CPU_MASK_ALL
-#endif
 	}
 };
 
-/* FIXME: use bootmem alloc ...*/
-static unsigned int kstat_irqs_legacy[NR_IRQS_LEGACY][NR_CPUS];
+static unsigned int *kstat_irqs_legacy;
 
 int __init early_irq_init(void)
 {
@@ -134,18 +133,30 @@ int __init early_irq_init(void)
 	int legacy_count;
 	int i;
 
+	 /* initialize nr_irqs based on nr_cpu_ids */
+	arch_probe_nr_irqs();
+	printk(KERN_INFO "NR_IRQS:%d nr_irqs:%d\n", NR_IRQS, nr_irqs);
+
 	desc = irq_desc_legacy;
 	legacy_count = ARRAY_SIZE(irq_desc_legacy);
 
+	/* allocate irq_desc_ptrs array based on nr_irqs */
+	irq_desc_ptrs = alloc_bootmem(nr_irqs * sizeof(void *));
+
+	/* allocate based on nr_cpu_ids */
+	/* FIXME: invert kstat_irgs, and it'd be a per_cpu_alloc'd thing */
+	kstat_irqs_legacy = alloc_bootmem(NR_IRQS_LEGACY * nr_cpu_ids *
+					  sizeof(int));
+
 	for (i = 0; i < legacy_count; i++) {
 		desc[i].irq = i;
-		desc[i].kstat_irqs = kstat_irqs_legacy[i];
+		desc[i].kstat_irqs = kstat_irqs_legacy + i * nr_cpu_ids;
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
-
+		init_alloc_desc_masks(&desc[i], 0, true);
 		irq_desc_ptrs[i] = desc + i;
 	}
 
-	for (i = legacy_count; i < NR_IRQS; i++)
+	for (i = legacy_count; i < nr_irqs; i++)
 		irq_desc_ptrs[i] = NULL;
 
 	return arch_early_irq_init();
@@ -153,7 +164,10 @@ int __init early_irq_init(void)
 
 struct irq_desc *irq_to_desc(unsigned int irq)
 {
-	return (irq < NR_IRQS) ? irq_desc_ptrs[irq] : NULL;
+	if (irq_desc_ptrs && irq < nr_irqs)
+		return irq_desc_ptrs[irq];
+
+	return NULL;
 }
 
 struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
@@ -162,10 +176,9 @@ struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
 	unsigned long flags;
 	int node;
 
-	if (irq >= NR_IRQS) {
-		printk(KERN_WARNING "irq >= NR_IRQS in irq_to_desc_alloc: %d %d\n",
-				irq, NR_IRQS);
-		WARN_ON(1);
+	if (irq >= nr_irqs) {
+		WARN(1, "irq (%d) >= nr_irqs (%d) in irq_to_desc_alloc\n",
+			irq, nr_irqs);
 		return NULL;
 	}
 
@@ -207,9 +220,6 @@ struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 		.handle_irq = handle_bad_irq,
 		.depth = 1,
 		.lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
-#ifdef CONFIG_SMP
-		.affinity = CPU_MASK_ALL
-#endif
 	}
 };
 
@@ -219,12 +229,15 @@ int __init early_irq_init(void)
 	int count;
 	int i;
 
+	printk(KERN_INFO "NR_IRQS:%d\n", NR_IRQS);
+
 	desc = irq_desc;
 	count = ARRAY_SIZE(irq_desc);
 
-	for (i = 0; i < count; i++)
+	for (i = 0; i < count; i++) {
 		desc[i].irq = i;
-
+		init_alloc_desc_masks(&desc[i], 0, true);
+	}
 	return arch_early_irq_init();
 }
 
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index e6d0a43..40416a8 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -16,7 +16,14 @@ extern int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 extern struct lock_class_key irq_desc_lock_class;
 extern void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr);
 extern spinlock_t sparse_irq_lock;
+
+#ifdef CONFIG_SPARSE_IRQ
+/* irq_desc_ptrs allocated at boot time */
+extern struct irq_desc **irq_desc_ptrs;
+#else
+/* irq_desc_ptrs is a fixed size array */
 extern struct irq_desc *irq_desc_ptrs[NR_IRQS];
+#endif
 
 #ifdef CONFIG_PROC_FS
 extern void register_irq_proc(unsigned int irq, struct irq_desc *desc);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index cd0cd8d..b98739a 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -98,14 +98,14 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (desc->status & IRQ_MOVE_PCNTXT || desc->status & IRQ_DISABLED) {
-		cpumask_copy(&desc->affinity, cpumask);
+		cpumask_copy(desc->affinity, cpumask);
 		desc->chip->set_affinity(irq, cpumask);
 	} else {
 		desc->status |= IRQ_MOVE_PENDING;
-		cpumask_copy(&desc->pending_mask, cpumask);
+		cpumask_copy(desc->pending_mask, cpumask);
 	}
 #else
-	cpumask_copy(&desc->affinity, cpumask);
+	cpumask_copy(desc->affinity, cpumask);
 	desc->chip->set_affinity(irq, cpumask);
 #endif
 	desc->status |= IRQ_AFFINITY_SET;
@@ -127,16 +127,16 @@ int do_irq_select_affinity(unsigned int irq, struct irq_desc *desc)
 	 * one of the targets is online.
 	 */
 	if (desc->status & (IRQ_AFFINITY_SET | IRQ_NO_BALANCING)) {
-		if (cpumask_any_and(&desc->affinity, cpu_online_mask)
+		if (cpumask_any_and(desc->affinity, cpu_online_mask)
 		    < nr_cpu_ids)
 			goto set_affinity;
 		else
 			desc->status &= ~IRQ_AFFINITY_SET;
 	}
 
-	cpumask_and(&desc->affinity, cpu_online_mask, irq_default_affinity);
+	cpumask_and(desc->affinity, cpu_online_mask, irq_default_affinity);
 set_affinity:
-	desc->chip->set_affinity(irq, &desc->affinity);
+	desc->chip->set_affinity(irq, desc->affinity);
 
 	return 0;
 }
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index bd72329..e05ad9b 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -18,7 +18,7 @@ void move_masked_irq(int irq)
 
 	desc->status &= ~IRQ_MOVE_PENDING;
 
-	if (unlikely(cpumask_empty(&desc->pending_mask)))
+	if (unlikely(cpumask_empty(desc->pending_mask)))
 		return;
 
 	if (!desc->chip->set_affinity)
@@ -38,13 +38,13 @@ void move_masked_irq(int irq)
 	 * For correct operation this depends on the caller
 	 * masking the irqs.
 	 */
-	if (likely(cpumask_any_and(&desc->pending_mask, cpu_online_mask)
+	if (likely(cpumask_any_and(desc->pending_mask, cpu_online_mask)
 		   < nr_cpu_ids)) {
-		cpumask_and(&desc->affinity,
-			    &desc->pending_mask, cpu_online_mask);
-		desc->chip->set_affinity(irq, &desc->affinity);
+		cpumask_and(desc->affinity,
+			    desc->pending_mask, cpu_online_mask);
+		desc->chip->set_affinity(irq, desc->affinity);
 	}
-	cpumask_clear(&desc->pending_mask);
+	cpumask_clear(desc->pending_mask);
 }
 
 void move_native_irq(int irq)
diff --git a/kernel/irq/numa_migrate.c b/kernel/irq/numa_migrate.c
index ecf765c..666260e 100644
--- a/kernel/irq/numa_migrate.c
+++ b/kernel/irq/numa_migrate.c
@@ -38,15 +38,22 @@ static void free_kstat_irqs(struct irq_desc *old_desc, struct irq_desc *desc)
 	old_desc->kstat_irqs = NULL;
 }
 
-static void init_copy_one_irq_desc(int irq, struct irq_desc *old_desc,
+static bool init_copy_one_irq_desc(int irq, struct irq_desc *old_desc,
 		 struct irq_desc *desc, int cpu)
 {
 	memcpy(desc, old_desc, sizeof(struct irq_desc));
+	if (!init_alloc_desc_masks(desc, cpu, false)) {
+		printk(KERN_ERR "irq %d: can not get new irq_desc cpumask "
+				"for migration.\n", irq);
+		return false;
+	}
 	spin_lock_init(&desc->lock);
 	desc->cpu = cpu;
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 	init_copy_kstat_irqs(old_desc, desc, cpu, nr_cpu_ids);
+	init_copy_desc_masks(old_desc, desc);
 	arch_init_copy_chip_data(old_desc, desc, cpu);
+	return true;
 }
 
 static void free_one_irq_desc(struct irq_desc *old_desc, struct irq_desc *desc)
@@ -76,12 +83,18 @@ static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
 	node = cpu_to_node(cpu);
 	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
 	if (!desc) {
-		printk(KERN_ERR "irq %d: can not get new irq_desc for migration.\n", irq);
+		printk(KERN_ERR "irq %d: can not get new irq_desc "
+				"for migration.\n", irq);
+		/* still use old one */
+		desc = old_desc;
+		goto out_unlock;
+	}
+	if (!init_copy_one_irq_desc(irq, old_desc, desc, cpu)) {
 		/* still use old one */
+		kfree(desc);
 		desc = old_desc;
 		goto out_unlock;
 	}
-	init_copy_one_irq_desc(irq, old_desc, desc, cpu);
 
 	irq_desc_ptrs[irq] = desc;
 
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index aae3f74..692363d 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -20,11 +20,11 @@ static struct proc_dir_entry *root_irq_dir;
 static int irq_affinity_proc_show(struct seq_file *m, void *v)
 {
 	struct irq_desc *desc = irq_to_desc((long)m->private);
-	const struct cpumask *mask = &desc->affinity;
+	const struct cpumask *mask = desc->affinity;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (desc->status & IRQ_MOVE_PENDING)
-		mask = &desc->pending_mask;
+		mask = desc->pending_mask;
 #endif
 	seq_cpumask(m, mask);
 	seq_putc(m, '\n');
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
new file mode 100644
index 0000000..1ac18da
--- /dev/null
+++ b/kernel/perf_counter.c
@@ -0,0 +1,2169 @@
+/*
+ * Performance counter core code
+ *
+ *  Copyright(C) 2008 Thomas Gleixner <tglx@linutronix.de>
+ *  Copyright(C) 2008 Red Hat, Inc., Ingo Molnar
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#include <linux/fs.h>
+#include <linux/cpu.h>
+#include <linux/smp.h>
+#include <linux/file.h>
+#include <linux/poll.h>
+#include <linux/sysfs.h>
+#include <linux/ptrace.h>
+#include <linux/percpu.h>
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+#include <linux/anon_inodes.h>
+#include <linux/kernel_stat.h>
+#include <linux/perf_counter.h>
+
+/*
+ * Each CPU has a list of per CPU counters:
+ */
+DEFINE_PER_CPU(struct perf_cpu_context, perf_cpu_context);
+
+int perf_max_counters __read_mostly = 1;
+static int perf_reserved_percpu __read_mostly;
+static int perf_overcommit __read_mostly = 1;
+
+/*
+ * Mutex for (sysadmin-configurable) counter reservations:
+ */
+static DEFINE_MUTEX(perf_resource_mutex);
+
+/*
+ * Architecture provided APIs - weak aliases:
+ */
+extern __weak const struct hw_perf_counter_ops *
+hw_perf_counter_init(struct perf_counter *counter)
+{
+	return NULL;
+}
+
+u64 __weak hw_perf_save_disable(void)		{ return 0; }
+void __weak hw_perf_restore(u64 ctrl)		{ barrier(); }
+void __weak hw_perf_counter_setup(int cpu)	{ barrier(); }
+int __weak hw_perf_group_sched_in(struct perf_counter *group_leader,
+	       struct perf_cpu_context *cpuctx,
+	       struct perf_counter_context *ctx, int cpu)
+{
+	return 0;
+}
+
+void __weak perf_counter_print_debug(void)	{ }
+
+static void
+list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
+{
+	struct perf_counter *group_leader = counter->group_leader;
+
+	/*
+	 * Depending on whether it is a standalone or sibling counter,
+	 * add it straight to the context's counter list, or to the group
+	 * leader's sibling list:
+	 */
+	if (counter->group_leader == counter)
+		list_add_tail(&counter->list_entry, &ctx->counter_list);
+	else
+		list_add_tail(&counter->list_entry, &group_leader->sibling_list);
+}
+
+static void
+list_del_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
+{
+	struct perf_counter *sibling, *tmp;
+
+	list_del_init(&counter->list_entry);
+
+	/*
+	 * If this was a group counter with sibling counters then
+	 * upgrade the siblings to singleton counters by adding them
+	 * to the context list directly:
+	 */
+	list_for_each_entry_safe(sibling, tmp,
+				 &counter->sibling_list, list_entry) {
+
+		list_del_init(&sibling->list_entry);
+		list_add_tail(&sibling->list_entry, &ctx->counter_list);
+		sibling->group_leader = sibling;
+	}
+}
+
+static void
+counter_sched_out(struct perf_counter *counter,
+		  struct perf_cpu_context *cpuctx,
+		  struct perf_counter_context *ctx)
+{
+	if (counter->state != PERF_COUNTER_STATE_ACTIVE)
+		return;
+
+	counter->state = PERF_COUNTER_STATE_INACTIVE;
+	counter->hw_ops->disable(counter);
+	counter->oncpu = -1;
+
+	if (!is_software_counter(counter))
+		cpuctx->active_oncpu--;
+	ctx->nr_active--;
+	if (counter->hw_event.exclusive || !cpuctx->active_oncpu)
+		cpuctx->exclusive = 0;
+}
+
+static void
+group_sched_out(struct perf_counter *group_counter,
+		struct perf_cpu_context *cpuctx,
+		struct perf_counter_context *ctx)
+{
+	struct perf_counter *counter;
+
+	if (group_counter->state != PERF_COUNTER_STATE_ACTIVE)
+		return;
+
+	counter_sched_out(group_counter, cpuctx, ctx);
+
+	/*
+	 * Schedule out siblings (if any):
+	 */
+	list_for_each_entry(counter, &group_counter->sibling_list, list_entry)
+		counter_sched_out(counter, cpuctx, ctx);
+
+	if (group_counter->hw_event.exclusive)
+		cpuctx->exclusive = 0;
+}
+
+/*
+ * Cross CPU call to remove a performance counter
+ *
+ * We disable the counter on the hardware level first. After that we
+ * remove it from the context list.
+ */
+static void __perf_counter_remove_from_context(void *info)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter *counter = info;
+	struct perf_counter_context *ctx = counter->ctx;
+	unsigned long flags;
+	u64 perf_flags;
+
+	/*
+	 * If this is a task context, we need to check whether it is
+	 * the current task context of this cpu. If not it has been
+	 * scheduled out before the smp call arrived.
+	 */
+	if (ctx->task && cpuctx->task_ctx != ctx)
+		return;
+
+	curr_rq_lock_irq_save(&flags);
+	spin_lock(&ctx->lock);
+
+	counter_sched_out(counter, cpuctx, ctx);
+
+	counter->task = NULL;
+	ctx->nr_counters--;
+
+	/*
+	 * Protect the list operation against NMI by disabling the
+	 * counters on a global level. NOP for non NMI based counters.
+	 */
+	perf_flags = hw_perf_save_disable();
+	list_del_counter(counter, ctx);
+	hw_perf_restore(perf_flags);
+
+	if (!ctx->task) {
+		/*
+		 * Allow more per task counters with respect to the
+		 * reservation:
+		 */
+		cpuctx->max_pertask =
+			min(perf_max_counters - ctx->nr_counters,
+			    perf_max_counters - perf_reserved_percpu);
+	}
+
+	spin_unlock(&ctx->lock);
+	curr_rq_unlock_irq_restore(&flags);
+}
+
+
+/*
+ * Remove the counter from a task's (or a CPU's) list of counters.
+ *
+ * Must be called with counter->mutex and ctx->mutex held.
+ *
+ * CPU counters are removed with a smp call. For task counters we only
+ * call when the task is on a CPU.
+ */
+static void perf_counter_remove_from_context(struct perf_counter *counter)
+{
+	struct perf_counter_context *ctx = counter->ctx;
+	struct task_struct *task = ctx->task;
+
+	if (!task) {
+		/*
+		 * Per cpu counters are removed via an smp call and
+		 * the removal is always sucessful.
+		 */
+		smp_call_function_single(counter->cpu,
+					 __perf_counter_remove_from_context,
+					 counter, 1);
+		return;
+	}
+
+retry:
+	task_oncpu_function_call(task, __perf_counter_remove_from_context,
+				 counter);
+
+	spin_lock_irq(&ctx->lock);
+	/*
+	 * If the context is active we need to retry the smp call.
+	 */
+	if (ctx->nr_active && !list_empty(&counter->list_entry)) {
+		spin_unlock_irq(&ctx->lock);
+		goto retry;
+	}
+
+	/*
+	 * The lock prevents that this context is scheduled in so we
+	 * can remove the counter safely, if the call above did not
+	 * succeed.
+	 */
+	if (!list_empty(&counter->list_entry)) {
+		ctx->nr_counters--;
+		list_del_counter(counter, ctx);
+		counter->task = NULL;
+	}
+	spin_unlock_irq(&ctx->lock);
+}
+
+/*
+ * Cross CPU call to disable a performance counter
+ */
+static void __perf_counter_disable(void *info)
+{
+	struct perf_counter *counter = info;
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter_context *ctx = counter->ctx;
+	unsigned long flags;
+
+	/*
+	 * If this is a per-task counter, need to check whether this
+	 * counter's task is the current task on this cpu.
+	 */
+	if (ctx->task && cpuctx->task_ctx != ctx)
+		return;
+
+	curr_rq_lock_irq_save(&flags);
+	spin_lock(&ctx->lock);
+
+	/*
+	 * If the counter is on, turn it off.
+	 * If it is in error state, leave it in error state.
+	 */
+	if (counter->state >= PERF_COUNTER_STATE_INACTIVE) {
+		if (counter == counter->group_leader)
+			group_sched_out(counter, cpuctx, ctx);
+		else
+			counter_sched_out(counter, cpuctx, ctx);
+		counter->state = PERF_COUNTER_STATE_OFF;
+	}
+
+	spin_unlock(&ctx->lock);
+	curr_rq_unlock_irq_restore(&flags);
+}
+
+/*
+ * Disable a counter.
+ */
+static void perf_counter_disable(struct perf_counter *counter)
+{
+	struct perf_counter_context *ctx = counter->ctx;
+	struct task_struct *task = ctx->task;
+
+	if (!task) {
+		/*
+		 * Disable the counter on the cpu that it's on
+		 */
+		smp_call_function_single(counter->cpu, __perf_counter_disable,
+					 counter, 1);
+		return;
+	}
+
+ retry:
+	task_oncpu_function_call(task, __perf_counter_disable, counter);
+
+	spin_lock_irq(&ctx->lock);
+	/*
+	 * If the counter is still active, we need to retry the cross-call.
+	 */
+	if (counter->state == PERF_COUNTER_STATE_ACTIVE) {
+		spin_unlock_irq(&ctx->lock);
+		goto retry;
+	}
+
+	/*
+	 * Since we have the lock this context can't be scheduled
+	 * in, so we can change the state safely.
+	 */
+	if (counter->state == PERF_COUNTER_STATE_INACTIVE)
+		counter->state = PERF_COUNTER_STATE_OFF;
+
+	spin_unlock_irq(&ctx->lock);
+}
+
+/*
+ * Disable a counter and all its children.
+ */
+static void perf_counter_disable_family(struct perf_counter *counter)
+{
+	struct perf_counter *child;
+
+	perf_counter_disable(counter);
+
+	/*
+	 * Lock the mutex to protect the list of children
+	 */
+	mutex_lock(&counter->mutex);
+	list_for_each_entry(child, &counter->child_list, child_list)
+		perf_counter_disable(child);
+	mutex_unlock(&counter->mutex);
+}
+
+static int
+counter_sched_in(struct perf_counter *counter,
+		 struct perf_cpu_context *cpuctx,
+		 struct perf_counter_context *ctx,
+		 int cpu)
+{
+	if (counter->state <= PERF_COUNTER_STATE_OFF)
+		return 0;
+
+	counter->state = PERF_COUNTER_STATE_ACTIVE;
+	counter->oncpu = cpu;	/* TODO: put 'cpu' into cpuctx->cpu */
+	/*
+	 * The new state must be visible before we turn it on in the hardware:
+	 */
+	smp_wmb();
+
+	if (counter->hw_ops->enable(counter)) {
+		counter->state = PERF_COUNTER_STATE_INACTIVE;
+		counter->oncpu = -1;
+		return -EAGAIN;
+	}
+
+	if (!is_software_counter(counter))
+		cpuctx->active_oncpu++;
+	ctx->nr_active++;
+
+	if (counter->hw_event.exclusive)
+		cpuctx->exclusive = 1;
+
+	return 0;
+}
+
+/*
+ * Return 1 for a group consisting entirely of software counters,
+ * 0 if the group contains any hardware counters.
+ */
+static int is_software_only_group(struct perf_counter *leader)
+{
+	struct perf_counter *counter;
+
+	if (!is_software_counter(leader))
+		return 0;
+	list_for_each_entry(counter, &leader->sibling_list, list_entry)
+		if (!is_software_counter(counter))
+			return 0;
+	return 1;
+}
+
+/*
+ * Work out whether we can put this counter group on the CPU now.
+ */
+static int group_can_go_on(struct perf_counter *counter,
+			   struct perf_cpu_context *cpuctx,
+			   int can_add_hw)
+{
+	/*
+	 * Groups consisting entirely of software counters can always go on.
+	 */
+	if (is_software_only_group(counter))
+		return 1;
+	/*
+	 * If an exclusive group is already on, no other hardware
+	 * counters can go on.
+	 */
+	if (cpuctx->exclusive)
+		return 0;
+	/*
+	 * If this group is exclusive and there are already
+	 * counters on the CPU, it can't go on.
+	 */
+	if (counter->hw_event.exclusive && cpuctx->active_oncpu)
+		return 0;
+	/*
+	 * Otherwise, try to add it if all previous groups were able
+	 * to go on.
+	 */
+	return can_add_hw;
+}
+
+/*
+ * Cross CPU call to install and enable a performance counter
+ */
+static void __perf_install_in_context(void *info)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter *counter = info;
+	struct perf_counter_context *ctx = counter->ctx;
+	struct perf_counter *leader = counter->group_leader;
+	int cpu = smp_processor_id();
+	unsigned long flags;
+	u64 perf_flags;
+	int err;
+
+	/*
+	 * If this is a task context, we need to check whether it is
+	 * the current task context of this cpu. If not it has been
+	 * scheduled out before the smp call arrived.
+	 */
+	if (ctx->task && cpuctx->task_ctx != ctx)
+		return;
+
+	curr_rq_lock_irq_save(&flags);
+	spin_lock(&ctx->lock);
+
+	/*
+	 * Protect the list operation against NMI by disabling the
+	 * counters on a global level. NOP for non NMI based counters.
+	 */
+	perf_flags = hw_perf_save_disable();
+
+	list_add_counter(counter, ctx);
+	ctx->nr_counters++;
+
+	/*
+	 * Don't put the counter on if it is disabled or if
+	 * it is in a group and the group isn't on.
+	 */
+	if (counter->state != PERF_COUNTER_STATE_INACTIVE ||
+	    (leader != counter && leader->state != PERF_COUNTER_STATE_ACTIVE))
+		goto unlock;
+
+	/*
+	 * An exclusive counter can't go on if there are already active
+	 * hardware counters, and no hardware counter can go on if there
+	 * is already an exclusive counter on.
+	 */
+	if (!group_can_go_on(counter, cpuctx, 1))
+		err = -EEXIST;
+	else
+		err = counter_sched_in(counter, cpuctx, ctx, cpu);
+
+	if (err) {
+		/*
+		 * This counter couldn't go on.  If it is in a group
+		 * then we have to pull the whole group off.
+		 * If the counter group is pinned then put it in error state.
+		 */
+		if (leader != counter)
+			group_sched_out(leader, cpuctx, ctx);
+		if (leader->hw_event.pinned)
+			leader->state = PERF_COUNTER_STATE_ERROR;
+	}
+
+	if (!err && !ctx->task && cpuctx->max_pertask)
+		cpuctx->max_pertask--;
+
+ unlock:
+	hw_perf_restore(perf_flags);
+
+	spin_unlock(&ctx->lock);
+	curr_rq_unlock_irq_restore(&flags);
+}
+
+/*
+ * Attach a performance counter to a context
+ *
+ * First we add the counter to the list with the hardware enable bit
+ * in counter->hw_config cleared.
+ *
+ * If the counter is attached to a task which is on a CPU we use a smp
+ * call to enable it in the task context. The task might have been
+ * scheduled away, but we check this in the smp call again.
+ *
+ * Must be called with ctx->mutex held.
+ */
+static void
+perf_install_in_context(struct perf_counter_context *ctx,
+			struct perf_counter *counter,
+			int cpu)
+{
+	struct task_struct *task = ctx->task;
+
+	counter->ctx = ctx;
+	if (!task) {
+		/*
+		 * Per cpu counters are installed via an smp call and
+		 * the install is always sucessful.
+		 */
+		smp_call_function_single(cpu, __perf_install_in_context,
+					 counter, 1);
+		return;
+	}
+
+	counter->task = task;
+retry:
+	task_oncpu_function_call(task, __perf_install_in_context,
+				 counter);
+
+	spin_lock_irq(&ctx->lock);
+	/*
+	 * we need to retry the smp call.
+	 */
+	if (ctx->is_active && list_empty(&counter->list_entry)) {
+		spin_unlock_irq(&ctx->lock);
+		goto retry;
+	}
+
+	/*
+	 * The lock prevents that this context is scheduled in so we
+	 * can add the counter safely, if it the call above did not
+	 * succeed.
+	 */
+	if (list_empty(&counter->list_entry)) {
+		list_add_counter(counter, ctx);
+		ctx->nr_counters++;
+	}
+	spin_unlock_irq(&ctx->lock);
+}
+
+/*
+ * Cross CPU call to enable a performance counter
+ */
+static void __perf_counter_enable(void *info)
+{
+	struct perf_counter *counter = info;
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter_context *ctx = counter->ctx;
+	struct perf_counter *leader = counter->group_leader;
+	unsigned long flags;
+	int err;
+
+	/*
+	 * If this is a per-task counter, need to check whether this
+	 * counter's task is the current task on this cpu.
+	 */
+	if (ctx->task && cpuctx->task_ctx != ctx)
+		return;
+
+	curr_rq_lock_irq_save(&flags);
+	spin_lock(&ctx->lock);
+
+	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
+		goto unlock;
+	counter->state = PERF_COUNTER_STATE_INACTIVE;
+
+	/*
+	 * If the counter is in a group and isn't the group leader,
+	 * then don't put it on unless the group is on.
+	 */
+	if (leader != counter && leader->state != PERF_COUNTER_STATE_ACTIVE)
+		goto unlock;
+
+	if (!group_can_go_on(counter, cpuctx, 1))
+		err = -EEXIST;
+	else
+		err = counter_sched_in(counter, cpuctx, ctx,
+				       smp_processor_id());
+
+	if (err) {
+		/*
+		 * If this counter can't go on and it's part of a
+		 * group, then the whole group has to come off.
+		 */
+		if (leader != counter)
+			group_sched_out(leader, cpuctx, ctx);
+		if (leader->hw_event.pinned)
+			leader->state = PERF_COUNTER_STATE_ERROR;
+	}
+
+ unlock:
+	spin_unlock(&ctx->lock);
+	curr_rq_unlock_irq_restore(&flags);
+}
+
+/*
+ * Enable a counter.
+ */
+static void perf_counter_enable(struct perf_counter *counter)
+{
+	struct perf_counter_context *ctx = counter->ctx;
+	struct task_struct *task = ctx->task;
+
+	if (!task) {
+		/*
+		 * Enable the counter on the cpu that it's on
+		 */
+		smp_call_function_single(counter->cpu, __perf_counter_enable,
+					 counter, 1);
+		return;
+	}
+
+	spin_lock_irq(&ctx->lock);
+	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
+		goto out;
+
+	/*
+	 * If the counter is in error state, clear that first.
+	 * That way, if we see the counter in error state below, we
+	 * know that it has gone back into error state, as distinct
+	 * from the task having been scheduled away before the
+	 * cross-call arrived.
+	 */
+	if (counter->state == PERF_COUNTER_STATE_ERROR)
+		counter->state = PERF_COUNTER_STATE_OFF;
+
+ retry:
+	spin_unlock_irq(&ctx->lock);
+	task_oncpu_function_call(task, __perf_counter_enable, counter);
+
+	spin_lock_irq(&ctx->lock);
+
+	/*
+	 * If the context is active and the counter is still off,
+	 * we need to retry the cross-call.
+	 */
+	if (ctx->is_active && counter->state == PERF_COUNTER_STATE_OFF)
+		goto retry;
+
+	/*
+	 * Since we have the lock this context can't be scheduled
+	 * in, so we can change the state safely.
+	 */
+	if (counter->state == PERF_COUNTER_STATE_OFF)
+		counter->state = PERF_COUNTER_STATE_INACTIVE;
+ out:
+	spin_unlock_irq(&ctx->lock);
+}
+
+/*
+ * Enable a counter and all its children.
+ */
+static void perf_counter_enable_family(struct perf_counter *counter)
+{
+	struct perf_counter *child;
+
+	perf_counter_enable(counter);
+
+	/*
+	 * Lock the mutex to protect the list of children
+	 */
+	mutex_lock(&counter->mutex);
+	list_for_each_entry(child, &counter->child_list, child_list)
+		perf_counter_enable(child);
+	mutex_unlock(&counter->mutex);
+}
+
+void __perf_counter_sched_out(struct perf_counter_context *ctx,
+			      struct perf_cpu_context *cpuctx)
+{
+	struct perf_counter *counter;
+	u64 flags;
+
+	spin_lock(&ctx->lock);
+	ctx->is_active = 0;
+	if (likely(!ctx->nr_counters))
+		goto out;
+
+	flags = hw_perf_save_disable();
+	if (ctx->nr_active) {
+		list_for_each_entry(counter, &ctx->counter_list, list_entry)
+			group_sched_out(counter, cpuctx, ctx);
+	}
+	hw_perf_restore(flags);
+ out:
+	spin_unlock(&ctx->lock);
+}
+
+/*
+ * Called from scheduler to remove the counters of the current task,
+ * with interrupts disabled.
+ *
+ * We stop each counter and update the counter value in counter->count.
+ *
+ * This does not protect us against NMI, but disable()
+ * sets the disabled bit in the control field of counter _before_
+ * accessing the counter control register. If a NMI hits, then it will
+ * not restart the counter.
+ */
+void perf_counter_task_sched_out(struct task_struct *task, int cpu)
+{
+	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct perf_counter_context *ctx = &task->perf_counter_ctx;
+
+	if (likely(!cpuctx->task_ctx))
+		return;
+
+	__perf_counter_sched_out(ctx, cpuctx);
+
+	cpuctx->task_ctx = NULL;
+}
+
+static void perf_counter_cpu_sched_out(struct perf_cpu_context *cpuctx)
+{
+	__perf_counter_sched_out(&cpuctx->ctx, cpuctx);
+}
+
+static int
+group_sched_in(struct perf_counter *group_counter,
+	       struct perf_cpu_context *cpuctx,
+	       struct perf_counter_context *ctx,
+	       int cpu)
+{
+	struct perf_counter *counter, *partial_group;
+	int ret;
+
+	if (group_counter->state == PERF_COUNTER_STATE_OFF)
+		return 0;
+
+	ret = hw_perf_group_sched_in(group_counter, cpuctx, ctx, cpu);
+	if (ret)
+		return ret < 0 ? ret : 0;
+
+	if (counter_sched_in(group_counter, cpuctx, ctx, cpu))
+		return -EAGAIN;
+
+	/*
+	 * Schedule in siblings as one group (if any):
+	 */
+	list_for_each_entry(counter, &group_counter->sibling_list, list_entry) {
+		if (counter_sched_in(counter, cpuctx, ctx, cpu)) {
+			partial_group = counter;
+			goto group_error;
+		}
+	}
+
+	return 0;
+
+group_error:
+	/*
+	 * Groups can be scheduled in as one unit only, so undo any
+	 * partial group before returning:
+	 */
+	list_for_each_entry(counter, &group_counter->sibling_list, list_entry) {
+		if (counter == partial_group)
+			break;
+		counter_sched_out(counter, cpuctx, ctx);
+	}
+	counter_sched_out(group_counter, cpuctx, ctx);
+
+	return -EAGAIN;
+}
+
+static void
+__perf_counter_sched_in(struct perf_counter_context *ctx,
+			struct perf_cpu_context *cpuctx, int cpu)
+{
+	struct perf_counter *counter;
+	u64 flags;
+	int can_add_hw = 1;
+
+	spin_lock(&ctx->lock);
+	ctx->is_active = 1;
+	if (likely(!ctx->nr_counters))
+		goto out;
+
+	flags = hw_perf_save_disable();
+
+	/*
+	 * First go through the list and put on any pinned groups
+	 * in order to give them the best chance of going on.
+	 */
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		if (counter->state <= PERF_COUNTER_STATE_OFF ||
+		    !counter->hw_event.pinned)
+			continue;
+		if (counter->cpu != -1 && counter->cpu != cpu)
+			continue;
+
+		if (group_can_go_on(counter, cpuctx, 1))
+			group_sched_in(counter, cpuctx, ctx, cpu);
+
+		/*
+		 * If this pinned group hasn't been scheduled,
+		 * put it in error state.
+		 */
+		if (counter->state == PERF_COUNTER_STATE_INACTIVE)
+			counter->state = PERF_COUNTER_STATE_ERROR;
+	}
+
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		/*
+		 * Ignore counters in OFF or ERROR state, and
+		 * ignore pinned counters since we did them already.
+		 */
+		if (counter->state <= PERF_COUNTER_STATE_OFF ||
+		    counter->hw_event.pinned)
+			continue;
+
+		/*
+		 * Listen to the 'cpu' scheduling filter constraint
+		 * of counters:
+		 */
+		if (counter->cpu != -1 && counter->cpu != cpu)
+			continue;
+
+		if (group_can_go_on(counter, cpuctx, can_add_hw)) {
+			if (group_sched_in(counter, cpuctx, ctx, cpu))
+				can_add_hw = 0;
+		}
+	}
+	hw_perf_restore(flags);
+ out:
+	spin_unlock(&ctx->lock);
+}
+
+/*
+ * Called from scheduler to add the counters of the current task
+ * with interrupts disabled.
+ *
+ * We restore the counter value and then enable it.
+ *
+ * This does not protect us against NMI, but enable()
+ * sets the enabled bit in the control field of counter _before_
+ * accessing the counter control register. If a NMI hits, then it will
+ * keep the counter running.
+ */
+void perf_counter_task_sched_in(struct task_struct *task, int cpu)
+{
+	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct perf_counter_context *ctx = &task->perf_counter_ctx;
+
+	__perf_counter_sched_in(ctx, cpuctx, cpu);
+	cpuctx->task_ctx = ctx;
+}
+
+static void perf_counter_cpu_sched_in(struct perf_cpu_context *cpuctx, int cpu)
+{
+	struct perf_counter_context *ctx = &cpuctx->ctx;
+
+	__perf_counter_sched_in(ctx, cpuctx, cpu);
+}
+
+int perf_counter_task_disable(void)
+{
+	struct task_struct *curr = current;
+	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
+	struct perf_counter *counter;
+	unsigned long flags;
+	u64 perf_flags;
+	int cpu;
+
+	if (likely(!ctx->nr_counters))
+		return 0;
+
+	curr_rq_lock_irq_save(&flags);
+	cpu = smp_processor_id();
+
+	/* force the update of the task clock: */
+	__task_delta_exec(curr, 1);
+
+	perf_counter_task_sched_out(curr, cpu);
+
+	spin_lock(&ctx->lock);
+
+	/*
+	 * Disable all the counters:
+	 */
+	perf_flags = hw_perf_save_disable();
+
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		if (counter->state != PERF_COUNTER_STATE_ERROR)
+			counter->state = PERF_COUNTER_STATE_OFF;
+	}
+
+	hw_perf_restore(perf_flags);
+
+	spin_unlock(&ctx->lock);
+
+	curr_rq_unlock_irq_restore(&flags);
+
+	return 0;
+}
+
+int perf_counter_task_enable(void)
+{
+	struct task_struct *curr = current;
+	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
+	struct perf_counter *counter;
+	unsigned long flags;
+	u64 perf_flags;
+	int cpu;
+
+	if (likely(!ctx->nr_counters))
+		return 0;
+
+	curr_rq_lock_irq_save(&flags);
+	cpu = smp_processor_id();
+
+	/* force the update of the task clock: */
+	__task_delta_exec(curr, 1);
+
+	perf_counter_task_sched_out(curr, cpu);
+
+	spin_lock(&ctx->lock);
+
+	/*
+	 * Disable all the counters:
+	 */
+	perf_flags = hw_perf_save_disable();
+
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		if (counter->state > PERF_COUNTER_STATE_OFF)
+			continue;
+		counter->state = PERF_COUNTER_STATE_INACTIVE;
+		counter->hw_event.disabled = 0;
+	}
+	hw_perf_restore(perf_flags);
+
+	spin_unlock(&ctx->lock);
+
+	perf_counter_task_sched_in(curr, cpu);
+
+	curr_rq_unlock_irq_restore(&flags);
+
+	return 0;
+}
+
+/*
+ * Round-robin a context's counters:
+ */
+static void rotate_ctx(struct perf_counter_context *ctx)
+{
+	struct perf_counter *counter;
+	u64 perf_flags;
+
+	if (!ctx->nr_counters)
+		return;
+
+	spin_lock(&ctx->lock);
+	/*
+	 * Rotate the first entry last (works just fine for group counters too):
+	 */
+	perf_flags = hw_perf_save_disable();
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		list_del(&counter->list_entry);
+		list_add_tail(&counter->list_entry, &ctx->counter_list);
+		break;
+	}
+	hw_perf_restore(perf_flags);
+
+	spin_unlock(&ctx->lock);
+}
+
+void perf_counter_task_tick(struct task_struct *curr, int cpu)
+{
+	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
+	const int rotate_percpu = 0;
+
+	if (rotate_percpu)
+		perf_counter_cpu_sched_out(cpuctx);
+	perf_counter_task_sched_out(curr, cpu);
+
+	if (rotate_percpu)
+		rotate_ctx(&cpuctx->ctx);
+	rotate_ctx(ctx);
+
+	if (rotate_percpu)
+		perf_counter_cpu_sched_in(cpuctx, cpu);
+	perf_counter_task_sched_in(curr, cpu);
+}
+
+/*
+ * Cross CPU call to read the hardware counter
+ */
+static void __read(void *info)
+{
+	struct perf_counter *counter = info;
+	unsigned long flags;
+
+	curr_rq_lock_irq_save(&flags);
+	counter->hw_ops->read(counter);
+	curr_rq_unlock_irq_restore(&flags);
+}
+
+static u64 perf_counter_read(struct perf_counter *counter)
+{
+	/*
+	 * If counter is enabled and currently active on a CPU, update the
+	 * value in the counter structure:
+	 */
+	if (counter->state == PERF_COUNTER_STATE_ACTIVE) {
+		smp_call_function_single(counter->oncpu,
+					 __read, counter, 1);
+	}
+
+	return atomic64_read(&counter->count);
+}
+
+/*
+ * Cross CPU call to switch performance data pointers
+ */
+static void __perf_switch_irq_data(void *info)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter *counter = info;
+	struct perf_counter_context *ctx = counter->ctx;
+	struct perf_data *oldirqdata = counter->irqdata;
+
+	/*
+	 * If this is a task context, we need to check whether it is
+	 * the current task context of this cpu. If not it has been
+	 * scheduled out before the smp call arrived.
+	 */
+	if (ctx->task) {
+		if (cpuctx->task_ctx != ctx)
+			return;
+		spin_lock(&ctx->lock);
+	}
+
+	/* Change the pointer NMI safe */
+	atomic_long_set((atomic_long_t *)&counter->irqdata,
+			(unsigned long) counter->usrdata);
+	counter->usrdata = oldirqdata;
+
+	if (ctx->task)
+		spin_unlock(&ctx->lock);
+}
+
+static struct perf_data *perf_switch_irq_data(struct perf_counter *counter)
+{
+	struct perf_counter_context *ctx = counter->ctx;
+	struct perf_data *oldirqdata = counter->irqdata;
+	struct task_struct *task = ctx->task;
+
+	if (!task) {
+		smp_call_function_single(counter->cpu,
+					 __perf_switch_irq_data,
+					 counter, 1);
+		return counter->usrdata;
+	}
+
+retry:
+	spin_lock_irq(&ctx->lock);
+	if (counter->state != PERF_COUNTER_STATE_ACTIVE) {
+		counter->irqdata = counter->usrdata;
+		counter->usrdata = oldirqdata;
+		spin_unlock_irq(&ctx->lock);
+		return oldirqdata;
+	}
+	spin_unlock_irq(&ctx->lock);
+	task_oncpu_function_call(task, __perf_switch_irq_data, counter);
+	/* Might have failed, because task was scheduled out */
+	if (counter->irqdata == oldirqdata)
+		goto retry;
+
+	return counter->usrdata;
+}
+
+static void put_context(struct perf_counter_context *ctx)
+{
+	if (ctx->task)
+		put_task_struct(ctx->task);
+}
+
+static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
+{
+	struct perf_cpu_context *cpuctx;
+	struct perf_counter_context *ctx;
+	struct task_struct *task;
+
+	/*
+	 * If cpu is not a wildcard then this is a percpu counter:
+	 */
+	if (cpu != -1) {
+		/* Must be root to operate on a CPU counter: */
+		if (!capable(CAP_SYS_ADMIN))
+			return ERR_PTR(-EACCES);
+
+		if (cpu < 0 || cpu > num_possible_cpus())
+			return ERR_PTR(-EINVAL);
+
+		/*
+		 * We could be clever and allow to attach a counter to an
+		 * offline CPU and activate it when the CPU comes up, but
+		 * that's for later.
+		 */
+		if (!cpu_isset(cpu, cpu_online_map))
+			return ERR_PTR(-ENODEV);
+
+		cpuctx = &per_cpu(perf_cpu_context, cpu);
+		ctx = &cpuctx->ctx;
+
+		return ctx;
+	}
+
+	rcu_read_lock();
+	if (!pid)
+		task = current;
+	else
+		task = find_task_by_vpid(pid);
+	if (task)
+		get_task_struct(task);
+	rcu_read_unlock();
+
+	if (!task)
+		return ERR_PTR(-ESRCH);
+
+	ctx = &task->perf_counter_ctx;
+	ctx->task = task;
+
+	/* Reuse ptrace permission checks for now. */
+	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
+		put_context(ctx);
+		return ERR_PTR(-EACCES);
+	}
+
+	return ctx;
+}
+
+/*
+ * Called when the last reference to the file is gone.
+ */
+static int perf_release(struct inode *inode, struct file *file)
+{
+	struct perf_counter *counter = file->private_data;
+	struct perf_counter_context *ctx = counter->ctx;
+
+	file->private_data = NULL;
+
+	mutex_lock(&ctx->mutex);
+	mutex_lock(&counter->mutex);
+
+	perf_counter_remove_from_context(counter);
+	put_context(ctx);
+
+	mutex_unlock(&counter->mutex);
+	mutex_unlock(&ctx->mutex);
+
+	kfree(counter);
+
+	return 0;
+}
+
+/*
+ * Read the performance counter - simple non blocking version for now
+ */
+static ssize_t
+perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
+{
+	u64 cntval;
+
+	if (count != sizeof(cntval))
+		return -EINVAL;
+
+	/*
+	 * Return end-of-file for a read on a counter that is in
+	 * error state (i.e. because it was pinned but it couldn't be
+	 * scheduled on to the CPU at some point).
+	 */
+	if (counter->state == PERF_COUNTER_STATE_ERROR)
+		return 0;
+
+	mutex_lock(&counter->mutex);
+	cntval = perf_counter_read(counter);
+	mutex_unlock(&counter->mutex);
+
+	return put_user(cntval, (u64 __user *) buf) ? -EFAULT : sizeof(cntval);
+}
+
+static ssize_t
+perf_copy_usrdata(struct perf_data *usrdata, char __user *buf, size_t count)
+{
+	if (!usrdata->len)
+		return 0;
+
+	count = min(count, (size_t)usrdata->len);
+	if (copy_to_user(buf, usrdata->data + usrdata->rd_idx, count))
+		return -EFAULT;
+
+	/* Adjust the counters */
+	usrdata->len -= count;
+	if (!usrdata->len)
+		usrdata->rd_idx = 0;
+	else
+		usrdata->rd_idx += count;
+
+	return count;
+}
+
+static ssize_t
+perf_read_irq_data(struct perf_counter	*counter,
+		   char __user		*buf,
+		   size_t		count,
+		   int			nonblocking)
+{
+	struct perf_data *irqdata, *usrdata;
+	DECLARE_WAITQUEUE(wait, current);
+	ssize_t res, res2;
+
+	irqdata = counter->irqdata;
+	usrdata = counter->usrdata;
+
+	if (usrdata->len + irqdata->len >= count)
+		goto read_pending;
+
+	if (nonblocking)
+		return -EAGAIN;
+
+	spin_lock_irq(&counter->waitq.lock);
+	__add_wait_queue(&counter->waitq, &wait);
+	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (usrdata->len + irqdata->len >= count)
+			break;
+
+		if (signal_pending(current))
+			break;
+
+		if (counter->state == PERF_COUNTER_STATE_ERROR)
+			break;
+
+		spin_unlock_irq(&counter->waitq.lock);
+		schedule();
+		spin_lock_irq(&counter->waitq.lock);
+	}
+	__remove_wait_queue(&counter->waitq, &wait);
+	__set_current_state(TASK_RUNNING);
+	spin_unlock_irq(&counter->waitq.lock);
+
+	if (usrdata->len + irqdata->len < count &&
+	    counter->state != PERF_COUNTER_STATE_ERROR)
+		return -ERESTARTSYS;
+read_pending:
+	mutex_lock(&counter->mutex);
+
+	/* Drain pending data first: */
+	res = perf_copy_usrdata(usrdata, buf, count);
+	if (res < 0 || res == count)
+		goto out;
+
+	/* Switch irq buffer: */
+	usrdata = perf_switch_irq_data(counter);
+	res2 = perf_copy_usrdata(usrdata, buf + res, count - res);
+	if (res2 < 0) {
+		if (!res)
+			res = -EFAULT;
+	} else {
+		res += res2;
+	}
+out:
+	mutex_unlock(&counter->mutex);
+
+	return res;
+}
+
+static ssize_t
+perf_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+{
+	struct perf_counter *counter = file->private_data;
+
+	switch (counter->hw_event.record_type) {
+	case PERF_RECORD_SIMPLE:
+		return perf_read_hw(counter, buf, count);
+
+	case PERF_RECORD_IRQ:
+	case PERF_RECORD_GROUP:
+		return perf_read_irq_data(counter, buf, count,
+					  file->f_flags & O_NONBLOCK);
+	}
+	return -EINVAL;
+}
+
+static unsigned int perf_poll(struct file *file, poll_table *wait)
+{
+	struct perf_counter *counter = file->private_data;
+	unsigned int events = 0;
+	unsigned long flags;
+
+	poll_wait(file, &counter->waitq, wait);
+
+	spin_lock_irqsave(&counter->waitq.lock, flags);
+	if (counter->usrdata->len || counter->irqdata->len)
+		events |= POLLIN;
+	spin_unlock_irqrestore(&counter->waitq.lock, flags);
+
+	return events;
+}
+
+static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct perf_counter *counter = file->private_data;
+	int err = 0;
+
+	switch (cmd) {
+	case PERF_COUNTER_IOC_ENABLE:
+		perf_counter_enable_family(counter);
+		break;
+	case PERF_COUNTER_IOC_DISABLE:
+		perf_counter_disable_family(counter);
+		break;
+	default:
+		err = -ENOTTY;
+	}
+	return err;
+}
+
+static const struct file_operations perf_fops = {
+	.release		= perf_release,
+	.read			= perf_read,
+	.poll			= perf_poll,
+	.unlocked_ioctl		= perf_ioctl,
+	.compat_ioctl		= perf_ioctl,
+};
+
+static int cpu_clock_perf_counter_enable(struct perf_counter *counter)
+{
+	int cpu = raw_smp_processor_id();
+
+	atomic64_set(&counter->hw.prev_count, cpu_clock(cpu));
+	return 0;
+}
+
+static void cpu_clock_perf_counter_update(struct perf_counter *counter)
+{
+	int cpu = raw_smp_processor_id();
+	s64 prev;
+	u64 now;
+
+	now = cpu_clock(cpu);
+	prev = atomic64_read(&counter->hw.prev_count);
+	atomic64_set(&counter->hw.prev_count, now);
+	atomic64_add(now - prev, &counter->count);
+}
+
+static void cpu_clock_perf_counter_disable(struct perf_counter *counter)
+{
+	cpu_clock_perf_counter_update(counter);
+}
+
+static void cpu_clock_perf_counter_read(struct perf_counter *counter)
+{
+	cpu_clock_perf_counter_update(counter);
+}
+
+static const struct hw_perf_counter_ops perf_ops_cpu_clock = {
+	.enable		= cpu_clock_perf_counter_enable,
+	.disable	= cpu_clock_perf_counter_disable,
+	.read		= cpu_clock_perf_counter_read,
+};
+
+/*
+ * Called from within the scheduler:
+ */
+static u64 task_clock_perf_counter_val(struct perf_counter *counter, int update)
+{
+	struct task_struct *curr = counter->task;
+	u64 delta;
+
+	delta = __task_delta_exec(curr, update);
+
+	return curr->se.sum_exec_runtime + delta;
+}
+
+static void task_clock_perf_counter_update(struct perf_counter *counter, u64 now)
+{
+	u64 prev;
+	s64 delta;
+
+	prev = atomic64_read(&counter->hw.prev_count);
+
+	atomic64_set(&counter->hw.prev_count, now);
+
+	delta = now - prev;
+
+	atomic64_add(delta, &counter->count);
+}
+
+static void task_clock_perf_counter_read(struct perf_counter *counter)
+{
+	u64 now = task_clock_perf_counter_val(counter, 1);
+
+	task_clock_perf_counter_update(counter, now);
+}
+
+static int task_clock_perf_counter_enable(struct perf_counter *counter)
+{
+	u64 now = task_clock_perf_counter_val(counter, 0);
+
+	atomic64_set(&counter->hw.prev_count, now);
+
+	return 0;
+}
+
+static void task_clock_perf_counter_disable(struct perf_counter *counter)
+{
+	u64 now = task_clock_perf_counter_val(counter, 0);
+
+	task_clock_perf_counter_update(counter, now);
+}
+
+static const struct hw_perf_counter_ops perf_ops_task_clock = {
+	.enable		= task_clock_perf_counter_enable,
+	.disable	= task_clock_perf_counter_disable,
+	.read		= task_clock_perf_counter_read,
+};
+
+static u64 get_page_faults(void)
+{
+	struct task_struct *curr = current;
+
+	return curr->maj_flt + curr->min_flt;
+}
+
+static void page_faults_perf_counter_update(struct perf_counter *counter)
+{
+	u64 prev, now;
+	s64 delta;
+
+	prev = atomic64_read(&counter->hw.prev_count);
+	now = get_page_faults();
+
+	atomic64_set(&counter->hw.prev_count, now);
+
+	delta = now - prev;
+
+	atomic64_add(delta, &counter->count);
+}
+
+static void page_faults_perf_counter_read(struct perf_counter *counter)
+{
+	page_faults_perf_counter_update(counter);
+}
+
+static int page_faults_perf_counter_enable(struct perf_counter *counter)
+{
+	/*
+	 * page-faults is a per-task value already,
+	 * so we dont have to clear it on switch-in.
+	 */
+
+	return 0;
+}
+
+static void page_faults_perf_counter_disable(struct perf_counter *counter)
+{
+	page_faults_perf_counter_update(counter);
+}
+
+static const struct hw_perf_counter_ops perf_ops_page_faults = {
+	.enable		= page_faults_perf_counter_enable,
+	.disable	= page_faults_perf_counter_disable,
+	.read		= page_faults_perf_counter_read,
+};
+
+static u64 get_context_switches(void)
+{
+	struct task_struct *curr = current;
+
+	return curr->nvcsw + curr->nivcsw;
+}
+
+static void context_switches_perf_counter_update(struct perf_counter *counter)
+{
+	u64 prev, now;
+	s64 delta;
+
+	prev = atomic64_read(&counter->hw.prev_count);
+	now = get_context_switches();
+
+	atomic64_set(&counter->hw.prev_count, now);
+
+	delta = now - prev;
+
+	atomic64_add(delta, &counter->count);
+}
+
+static void context_switches_perf_counter_read(struct perf_counter *counter)
+{
+	context_switches_perf_counter_update(counter);
+}
+
+static int context_switches_perf_counter_enable(struct perf_counter *counter)
+{
+	/*
+	 * ->nvcsw + curr->nivcsw is a per-task value already,
+	 * so we dont have to clear it on switch-in.
+	 */
+
+	return 0;
+}
+
+static void context_switches_perf_counter_disable(struct perf_counter *counter)
+{
+	context_switches_perf_counter_update(counter);
+}
+
+static const struct hw_perf_counter_ops perf_ops_context_switches = {
+	.enable		= context_switches_perf_counter_enable,
+	.disable	= context_switches_perf_counter_disable,
+	.read		= context_switches_perf_counter_read,
+};
+
+static inline u64 get_cpu_migrations(void)
+{
+	return current->se.nr_migrations;
+}
+
+static void cpu_migrations_perf_counter_update(struct perf_counter *counter)
+{
+	u64 prev, now;
+	s64 delta;
+
+	prev = atomic64_read(&counter->hw.prev_count);
+	now = get_cpu_migrations();
+
+	atomic64_set(&counter->hw.prev_count, now);
+
+	delta = now - prev;
+
+	atomic64_add(delta, &counter->count);
+}
+
+static void cpu_migrations_perf_counter_read(struct perf_counter *counter)
+{
+	cpu_migrations_perf_counter_update(counter);
+}
+
+static int cpu_migrations_perf_counter_enable(struct perf_counter *counter)
+{
+	/*
+	 * se.nr_migrations is a per-task value already,
+	 * so we dont have to clear it on switch-in.
+	 */
+
+	return 0;
+}
+
+static void cpu_migrations_perf_counter_disable(struct perf_counter *counter)
+{
+	cpu_migrations_perf_counter_update(counter);
+}
+
+static const struct hw_perf_counter_ops perf_ops_cpu_migrations = {
+	.enable		= cpu_migrations_perf_counter_enable,
+	.disable	= cpu_migrations_perf_counter_disable,
+	.read		= cpu_migrations_perf_counter_read,
+};
+
+static const struct hw_perf_counter_ops *
+sw_perf_counter_init(struct perf_counter *counter)
+{
+	const struct hw_perf_counter_ops *hw_ops = NULL;
+
+	switch (counter->hw_event.type) {
+	case PERF_COUNT_CPU_CLOCK:
+		hw_ops = &perf_ops_cpu_clock;
+		break;
+	case PERF_COUNT_TASK_CLOCK:
+		hw_ops = &perf_ops_task_clock;
+		break;
+	case PERF_COUNT_PAGE_FAULTS:
+		hw_ops = &perf_ops_page_faults;
+		break;
+	case PERF_COUNT_CONTEXT_SWITCHES:
+		hw_ops = &perf_ops_context_switches;
+		break;
+	case PERF_COUNT_CPU_MIGRATIONS:
+		hw_ops = &perf_ops_cpu_migrations;
+		break;
+	default:
+		break;
+	}
+	return hw_ops;
+}
+
+/*
+ * Allocate and initialize a counter structure
+ */
+static struct perf_counter *
+perf_counter_alloc(struct perf_counter_hw_event *hw_event,
+		   int cpu,
+		   struct perf_counter *group_leader,
+		   gfp_t gfpflags)
+{
+	const struct hw_perf_counter_ops *hw_ops;
+	struct perf_counter *counter;
+
+	counter = kzalloc(sizeof(*counter), gfpflags);
+	if (!counter)
+		return NULL;
+
+	/*
+	 * Single counters are their own group leaders, with an
+	 * empty sibling list:
+	 */
+	if (!group_leader)
+		group_leader = counter;
+
+	mutex_init(&counter->mutex);
+	INIT_LIST_HEAD(&counter->list_entry);
+	INIT_LIST_HEAD(&counter->sibling_list);
+	init_waitqueue_head(&counter->waitq);
+
+	INIT_LIST_HEAD(&counter->child_list);
+
+	counter->irqdata		= &counter->data[0];
+	counter->usrdata		= &counter->data[1];
+	counter->cpu			= cpu;
+	counter->hw_event		= *hw_event;
+	counter->wakeup_pending		= 0;
+	counter->group_leader		= group_leader;
+	counter->hw_ops			= NULL;
+
+	counter->state = PERF_COUNTER_STATE_INACTIVE;
+	if (hw_event->disabled)
+		counter->state = PERF_COUNTER_STATE_OFF;
+
+	hw_ops = NULL;
+	if (!hw_event->raw && hw_event->type < 0)
+		hw_ops = sw_perf_counter_init(counter);
+	if (!hw_ops)
+		hw_ops = hw_perf_counter_init(counter);
+
+	if (!hw_ops) {
+		kfree(counter);
+		return NULL;
+	}
+	counter->hw_ops = hw_ops;
+
+	return counter;
+}
+
+/**
+ * sys_perf_task_open - open a performance counter, associate it to a task/cpu
+ *
+ * @hw_event_uptr:	event type attributes for monitoring/sampling
+ * @pid:		target pid
+ * @cpu:		target cpu
+ * @group_fd:		group leader counter fd
+ */
+asmlinkage int
+sys_perf_counter_open(struct perf_counter_hw_event *hw_event_uptr __user,
+		      pid_t pid, int cpu, int group_fd)
+{
+	struct perf_counter *counter, *group_leader;
+	struct perf_counter_hw_event hw_event;
+	struct perf_counter_context *ctx;
+	struct file *counter_file = NULL;
+	struct file *group_file = NULL;
+	int fput_needed = 0;
+	int fput_needed2 = 0;
+	int ret;
+
+	if (copy_from_user(&hw_event, hw_event_uptr, sizeof(hw_event)) != 0)
+		return -EFAULT;
+
+	/*
+	 * Get the target context (task or percpu):
+	 */
+	ctx = find_get_context(pid, cpu);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	/*
+	 * Look up the group leader (we will attach this counter to it):
+	 */
+	group_leader = NULL;
+	if (group_fd != -1) {
+		ret = -EINVAL;
+		group_file = fget_light(group_fd, &fput_needed);
+		if (!group_file)
+			goto err_put_context;
+		if (group_file->f_op != &perf_fops)
+			goto err_put_context;
+
+		group_leader = group_file->private_data;
+		/*
+		 * Do not allow a recursive hierarchy (this new sibling
+		 * becoming part of another group-sibling):
+		 */
+		if (group_leader->group_leader != group_leader)
+			goto err_put_context;
+		/*
+		 * Do not allow to attach to a group in a different
+		 * task or CPU context:
+		 */
+		if (group_leader->ctx != ctx)
+			goto err_put_context;
+		/*
+		 * Only a group leader can be exclusive or pinned
+		 */
+		if (hw_event.exclusive || hw_event.pinned)
+			goto err_put_context;
+	}
+
+	ret = -EINVAL;
+	counter = perf_counter_alloc(&hw_event, cpu, group_leader, GFP_KERNEL);
+	if (!counter)
+		goto err_put_context;
+
+	ret = anon_inode_getfd("[perf_counter]", &perf_fops, counter, 0);
+	if (ret < 0)
+		goto err_free_put_context;
+
+	counter_file = fget_light(ret, &fput_needed2);
+	if (!counter_file)
+		goto err_free_put_context;
+
+	counter->filp = counter_file;
+	mutex_lock(&ctx->mutex);
+	perf_install_in_context(ctx, counter, cpu);
+	mutex_unlock(&ctx->mutex);
+
+	fput_light(counter_file, fput_needed2);
+
+out_fput:
+	fput_light(group_file, fput_needed);
+
+	return ret;
+
+err_free_put_context:
+	kfree(counter);
+
+err_put_context:
+	put_context(ctx);
+
+	goto out_fput;
+}
+
+/*
+ * Initialize the perf_counter context in a task_struct:
+ */
+static void
+__perf_counter_init_context(struct perf_counter_context *ctx,
+			    struct task_struct *task)
+{
+	memset(ctx, 0, sizeof(*ctx));
+	spin_lock_init(&ctx->lock);
+	mutex_init(&ctx->mutex);
+	INIT_LIST_HEAD(&ctx->counter_list);
+	ctx->task = task;
+}
+
+/*
+ * inherit a counter from parent task to child task:
+ */
+static struct perf_counter *
+inherit_counter(struct perf_counter *parent_counter,
+	      struct task_struct *parent,
+	      struct perf_counter_context *parent_ctx,
+	      struct task_struct *child,
+	      struct perf_counter *group_leader,
+	      struct perf_counter_context *child_ctx)
+{
+	struct perf_counter *child_counter;
+
+	/*
+	 * Instead of creating recursive hierarchies of counters,
+	 * we link inherited counters back to the original parent,
+	 * which has a filp for sure, which we use as the reference
+	 * count:
+	 */
+	if (parent_counter->parent)
+		parent_counter = parent_counter->parent;
+
+	child_counter = perf_counter_alloc(&parent_counter->hw_event,
+					    parent_counter->cpu, group_leader,
+					    GFP_KERNEL);
+	if (!child_counter)
+		return NULL;
+
+	/*
+	 * Link it up in the child's context:
+	 */
+	child_counter->ctx = child_ctx;
+	child_counter->task = child;
+	list_add_counter(child_counter, child_ctx);
+	child_ctx->nr_counters++;
+
+	child_counter->parent = parent_counter;
+	/*
+	 * inherit into child's child as well:
+	 */
+	child_counter->hw_event.inherit = 1;
+
+	/*
+	 * Get a reference to the parent filp - we will fput it
+	 * when the child counter exits. This is safe to do because
+	 * we are in the parent and we know that the filp still
+	 * exists and has a nonzero count:
+	 */
+	atomic_long_inc(&parent_counter->filp->f_count);
+
+	/*
+	 * Link this into the parent counter's child list
+	 */
+	mutex_lock(&parent_counter->mutex);
+	list_add_tail(&child_counter->child_list, &parent_counter->child_list);
+
+	/*
+	 * Make the child state follow the state of the parent counter,
+	 * not its hw_event.disabled bit.  We hold the parent's mutex,
+	 * so we won't race with perf_counter_{en,dis}able_family.
+	 */
+	if (parent_counter->state >= PERF_COUNTER_STATE_INACTIVE)
+		child_counter->state = PERF_COUNTER_STATE_INACTIVE;
+	else
+		child_counter->state = PERF_COUNTER_STATE_OFF;
+
+	mutex_unlock(&parent_counter->mutex);
+
+	return child_counter;
+}
+
+static int inherit_group(struct perf_counter *parent_counter,
+	      struct task_struct *parent,
+	      struct perf_counter_context *parent_ctx,
+	      struct task_struct *child,
+	      struct perf_counter_context *child_ctx)
+{
+	struct perf_counter *leader;
+	struct perf_counter *sub;
+
+	leader = inherit_counter(parent_counter, parent, parent_ctx,
+				 child, NULL, child_ctx);
+	if (!leader)
+		return -ENOMEM;
+	list_for_each_entry(sub, &parent_counter->sibling_list, list_entry) {
+		if (!inherit_counter(sub, parent, parent_ctx,
+				     child, leader, child_ctx))
+			return -ENOMEM;
+	}
+	return 0;
+}
+
+static void sync_child_counter(struct perf_counter *child_counter,
+			       struct perf_counter *parent_counter)
+{
+	u64 parent_val, child_val;
+
+	parent_val = atomic64_read(&parent_counter->count);
+	child_val = atomic64_read(&child_counter->count);
+
+	/*
+	 * Add back the child's count to the parent's count:
+	 */
+	atomic64_add(child_val, &parent_counter->count);
+
+	/*
+	 * Remove this counter from the parent's list
+	 */
+	mutex_lock(&parent_counter->mutex);
+	list_del_init(&child_counter->child_list);
+	mutex_unlock(&parent_counter->mutex);
+
+	/*
+	 * Release the parent counter, if this was the last
+	 * reference to it.
+	 */
+	fput(parent_counter->filp);
+}
+
+static void
+__perf_counter_exit_task(struct task_struct *child,
+			 struct perf_counter *child_counter,
+			 struct perf_counter_context *child_ctx)
+{
+	struct perf_counter *parent_counter;
+	struct perf_counter *sub, *tmp;
+
+	/*
+	 * If we do not self-reap then we have to wait for the
+	 * child task to unschedule (it will happen for sure),
+	 * so that its counter is at its final count. (This
+	 * condition triggers rarely - child tasks usually get
+	 * off their CPU before the parent has a chance to
+	 * get this far into the reaping action)
+	 */
+	if (child != current) {
+		wait_task_inactive(child, 0);
+		list_del_init(&child_counter->list_entry);
+	} else {
+		struct perf_cpu_context *cpuctx;
+		unsigned long flags;
+		u64 perf_flags;
+
+		/*
+		 * Disable and unlink this counter.
+		 *
+		 * Be careful about zapping the list - IRQ/NMI context
+		 * could still be processing it:
+		 */
+		curr_rq_lock_irq_save(&flags);
+		perf_flags = hw_perf_save_disable();
+
+		cpuctx = &__get_cpu_var(perf_cpu_context);
+
+		group_sched_out(child_counter, cpuctx, child_ctx);
+
+		list_del_init(&child_counter->list_entry);
+
+		child_ctx->nr_counters--;
+
+		hw_perf_restore(perf_flags);
+		curr_rq_unlock_irq_restore(&flags);
+	}
+
+	parent_counter = child_counter->parent;
+	/*
+	 * It can happen that parent exits first, and has counters
+	 * that are still around due to the child reference. These
+	 * counters need to be zapped - but otherwise linger.
+	 */
+	if (parent_counter) {
+		sync_child_counter(child_counter, parent_counter);
+		list_for_each_entry_safe(sub, tmp, &child_counter->sibling_list,
+					 list_entry) {
+			if (sub->parent)
+				sync_child_counter(sub, sub->parent);
+			kfree(sub);
+		}
+	}
+
+	kfree(child_counter);
+}
+
+/*
+ * When a child task exits, feed back counter values to parent counters.
+ *
+ * Note: we may be running in child context, but the PID is not hashed
+ * anymore so new counters will not be added.
+ */
+void perf_counter_exit_task(struct task_struct *child)
+{
+	struct perf_counter *child_counter, *tmp;
+	struct perf_counter_context *child_ctx;
+
+	child_ctx = &child->perf_counter_ctx;
+
+	if (likely(!child_ctx->nr_counters))
+		return;
+
+	list_for_each_entry_safe(child_counter, tmp, &child_ctx->counter_list,
+				 list_entry)
+		__perf_counter_exit_task(child, child_counter, child_ctx);
+}
+
+/*
+ * Initialize the perf_counter context in task_struct
+ */
+void perf_counter_init_task(struct task_struct *child)
+{
+	struct perf_counter_context *child_ctx, *parent_ctx;
+	struct perf_counter *counter;
+	struct task_struct *parent = current;
+
+	child_ctx  =  &child->perf_counter_ctx;
+	parent_ctx = &parent->perf_counter_ctx;
+
+	__perf_counter_init_context(child_ctx, child);
+
+	/*
+	 * This is executed from the parent task context, so inherit
+	 * counters that have been marked for cloning:
+	 */
+
+	if (likely(!parent_ctx->nr_counters))
+		return;
+
+	/*
+	 * Lock the parent list. No need to lock the child - not PID
+	 * hashed yet and not running, so nobody can access it.
+	 */
+	mutex_lock(&parent_ctx->mutex);
+
+	/*
+	 * We dont have to disable NMIs - we are only looking at
+	 * the list, not manipulating it:
+	 */
+	list_for_each_entry(counter, &parent_ctx->counter_list, list_entry) {
+		if (!counter->hw_event.inherit)
+			continue;
+
+		if (inherit_group(counter, parent,
+				  parent_ctx, child, child_ctx))
+			break;
+	}
+
+	mutex_unlock(&parent_ctx->mutex);
+}
+
+static void __cpuinit perf_counter_init_cpu(int cpu)
+{
+	struct perf_cpu_context *cpuctx;
+
+	cpuctx = &per_cpu(perf_cpu_context, cpu);
+	__perf_counter_init_context(&cpuctx->ctx, NULL);
+
+	mutex_lock(&perf_resource_mutex);
+	cpuctx->max_pertask = perf_max_counters - perf_reserved_percpu;
+	mutex_unlock(&perf_resource_mutex);
+
+	hw_perf_counter_setup(cpu);
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+static void __perf_counter_exit_cpu(void *info)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter_context *ctx = &cpuctx->ctx;
+	struct perf_counter *counter, *tmp;
+
+	list_for_each_entry_safe(counter, tmp, &ctx->counter_list, list_entry)
+		__perf_counter_remove_from_context(counter);
+}
+static void perf_counter_exit_cpu(int cpu)
+{
+	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct perf_counter_context *ctx = &cpuctx->ctx;
+
+	mutex_lock(&ctx->mutex);
+	smp_call_function_single(cpu, __perf_counter_exit_cpu, NULL, 1);
+	mutex_unlock(&ctx->mutex);
+}
+#else
+static inline void perf_counter_exit_cpu(int cpu) { }
+#endif
+
+static int __cpuinit
+perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (long)hcpu;
+
+	switch (action) {
+
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		perf_counter_init_cpu(cpu);
+		break;
+
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		perf_counter_exit_cpu(cpu);
+		break;
+
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata perf_cpu_nb = {
+	.notifier_call		= perf_cpu_notify,
+};
+
+static int __init perf_counter_init(void)
+{
+	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_UP_PREPARE,
+			(void *)(long)smp_processor_id());
+	register_cpu_notifier(&perf_cpu_nb);
+
+	return 0;
+}
+early_initcall(perf_counter_init);
+
+static ssize_t perf_show_reserve_percpu(struct sysdev_class *class, char *buf)
+{
+	return sprintf(buf, "%d\n", perf_reserved_percpu);
+}
+
+static ssize_t
+perf_set_reserve_percpu(struct sysdev_class *class,
+			const char *buf,
+			size_t count)
+{
+	struct perf_cpu_context *cpuctx;
+	unsigned long val;
+	int err, cpu, mpt;
+
+	err = strict_strtoul(buf, 10, &val);
+	if (err)
+		return err;
+	if (val > perf_max_counters)
+		return -EINVAL;
+
+	mutex_lock(&perf_resource_mutex);
+	perf_reserved_percpu = val;
+	for_each_online_cpu(cpu) {
+		cpuctx = &per_cpu(perf_cpu_context, cpu);
+		spin_lock_irq(&cpuctx->ctx.lock);
+		mpt = min(perf_max_counters - cpuctx->ctx.nr_counters,
+			  perf_max_counters - perf_reserved_percpu);
+		cpuctx->max_pertask = mpt;
+		spin_unlock_irq(&cpuctx->ctx.lock);
+	}
+	mutex_unlock(&perf_resource_mutex);
+
+	return count;
+}
+
+static ssize_t perf_show_overcommit(struct sysdev_class *class, char *buf)
+{
+	return sprintf(buf, "%d\n", perf_overcommit);
+}
+
+static ssize_t
+perf_set_overcommit(struct sysdev_class *class, const char *buf, size_t count)
+{
+	unsigned long val;
+	int err;
+
+	err = strict_strtoul(buf, 10, &val);
+	if (err)
+		return err;
+	if (val > 1)
+		return -EINVAL;
+
+	mutex_lock(&perf_resource_mutex);
+	perf_overcommit = val;
+	mutex_unlock(&perf_resource_mutex);
+
+	return count;
+}
+
+static SYSDEV_CLASS_ATTR(
+				reserve_percpu,
+				0644,
+				perf_show_reserve_percpu,
+				perf_set_reserve_percpu
+			);
+
+static SYSDEV_CLASS_ATTR(
+				overcommit,
+				0644,
+				perf_show_overcommit,
+				perf_set_overcommit
+			);
+
+static struct attribute *perfclass_attrs[] = {
+	&attr_reserve_percpu.attr,
+	&attr_overcommit.attr,
+	NULL
+};
+
+static struct attribute_group perfclass_attr_group = {
+	.attrs			= perfclass_attrs,
+	.name			= "perf_counters",
+};
+
+static int __init perf_counter_sysfs_init(void)
+{
+	return sysfs_create_group(&cpu_sysdev_class.kset.kobj,
+				  &perfclass_attr_group);
+}
+device_initcall(perf_counter_sysfs_init);
diff --git a/kernel/sched.c b/kernel/sched.c
index 52bbf1c..40d70d9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -668,7 +668,7 @@ static inline int cpu_of(struct rq *rq)
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 
-static inline void update_rq_clock(struct rq *rq)
+inline void update_rq_clock(struct rq *rq)
 {
 	rq->clock = sched_clock_cpu(cpu_of(rq));
 }
@@ -979,6 +979,26 @@ static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
 	}
 }
 
+void curr_rq_lock_irq_save(unsigned long *flags)
+	__acquires(rq->lock)
+{
+	struct rq *rq;
+
+	local_irq_save(*flags);
+	rq = cpu_rq(smp_processor_id());
+	spin_lock(&rq->lock);
+}
+
+void curr_rq_unlock_irq_restore(unsigned long *flags)
+	__releases(rq->lock)
+{
+	struct rq *rq;
+
+	rq = cpu_rq(smp_processor_id());
+	spin_unlock(&rq->lock);
+	local_irq_restore(*flags);
+}
+
 void task_rq_unlock_wait(struct task_struct *p)
 {
 	struct rq *rq = task_rq(p);
@@ -1885,12 +1905,14 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 		p->se.sleep_start -= clock_offset;
 	if (p->se.block_start)
 		p->se.block_start -= clock_offset;
+#endif
 	if (old_cpu != new_cpu) {
-		schedstat_inc(p, se.nr_migrations);
+		p->se.nr_migrations++;
+#ifdef CONFIG_SCHEDSTATS
 		if (task_hot(p, old_rq->clock, NULL))
 			schedstat_inc(p, se.nr_forced2_migrations);
-	}
 #endif
+	}
 	p->se.vruntime -= old_cfsrq->min_vruntime -
 					 new_cfsrq->min_vruntime;
 
@@ -2242,6 +2264,27 @@ static int sched_balance_self(int cpu, int flag)
 
 #endif /* CONFIG_SMP */
 
+/**
+ * task_oncpu_function_call - call a function on the cpu on which a task runs
+ * @p:		the task to evaluate
+ * @func:	the function to be called
+ * @info:	the function call argument
+ *
+ * Calls the function @func when the task is currently running. This might
+ * be on the current CPU, which just calls the function directly
+ */
+void task_oncpu_function_call(struct task_struct *p,
+			      void (*func) (void *info), void *info)
+{
+	int cpu;
+
+	preempt_disable();
+	cpu = task_cpu(p);
+	if (task_curr(p))
+		smp_call_function_single(cpu, func, info, 1);
+	preempt_enable();
+}
+
 /***
  * try_to_wake_up - wake up a thread
  * @p: the to-be-woken-up thread
@@ -2384,6 +2427,7 @@ static void __sched_fork(struct task_struct *p)
 	p->se.exec_start		= 0;
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
+	p->se.nr_migrations		= 0;
 	p->se.last_wakeup		= 0;
 	p->se.avg_overlap		= 0;
 
@@ -2604,6 +2648,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 */
 	prev_state = prev->state;
 	finish_arch_switch(prev);
+	perf_counter_task_sched_in(current, cpu_of(rq));
 	finish_lock_switch(rq, prev);
 #ifdef CONFIG_SMP
 	if (current->sched_class->post_schedule)
@@ -4132,6 +4177,29 @@ EXPORT_PER_CPU_SYMBOL(kstat);
  * Return any ns on the sched_clock that have not yet been banked in
  * @p in case that task is currently running.
  */
+unsigned long long __task_delta_exec(struct task_struct *p, int update)
+{
+	s64 delta_exec;
+	struct rq *rq;
+
+	rq = task_rq(p);
+	WARN_ON_ONCE(!runqueue_is_locked());
+	WARN_ON_ONCE(!task_current(rq, p));
+
+	if (update)
+		update_rq_clock(rq);
+
+	delta_exec = rq->clock - p->se.exec_start;
+
+	WARN_ON_ONCE(delta_exec < 0);
+
+	return delta_exec;
+}
+
+/*
+ * Return any ns on the sched_clock that have not yet been banked in
+ * @p in case that task is currently running.
+ */
 unsigned long long task_delta_exec(struct task_struct *p)
 {
 	unsigned long flags;
@@ -4391,6 +4459,7 @@ void scheduler_tick(void)
 	update_rq_clock(rq);
 	update_cpu_load(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
+	perf_counter_task_tick(curr, cpu);
 	spin_unlock(&rq->lock);
 
 #ifdef CONFIG_SMP
@@ -4586,6 +4655,7 @@ need_resched_nonpreemptible:
 
 	if (likely(prev != next)) {
 		sched_info_switch(prev, next);
+		perf_counter_task_sched_out(prev, cpu);
 
 		rq->nr_switches++;
 		rq->curr = next;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 954e1a8..da932f4 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -960,16 +960,17 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
 
 static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
 
-static inline int pick_optimal_cpu(int this_cpu, cpumask_t *mask)
+static inline int pick_optimal_cpu(int this_cpu,
+				   const struct cpumask *mask)
 {
 	int first;
 
 	/* "this_cpu" is cheaper to preempt than a remote processor */
-	if ((this_cpu != -1) && cpu_isset(this_cpu, *mask))
+	if ((this_cpu != -1) && cpumask_test_cpu(this_cpu, mask))
 		return this_cpu;
 
-	first = first_cpu(*mask);
-	if (first != NR_CPUS)
+	first = cpumask_first(mask);
+	if (first < nr_cpu_ids)
 		return first;
 
 	return -1;
@@ -981,6 +982,7 @@ static int find_lowest_rq(struct task_struct *task)
 	struct cpumask *lowest_mask = __get_cpu_var(local_cpu_mask);
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);
+	cpumask_var_t domain_mask;
 
 	if (task->rt.nr_cpus_allowed == 1)
 		return -1; /* No other targets possible */
@@ -1013,19 +1015,25 @@ static int find_lowest_rq(struct task_struct *task)
 	if (this_cpu == cpu)
 		this_cpu = -1; /* Skip this_cpu opt if the same */
 
-	for_each_domain(cpu, sd) {
-		if (sd->flags & SD_WAKE_AFFINE) {
-			cpumask_t domain_mask;
-			int       best_cpu;
+	if (alloc_cpumask_var(&domain_mask, GFP_ATOMIC)) {
+		for_each_domain(cpu, sd) {
+			if (sd->flags & SD_WAKE_AFFINE) {
+				int best_cpu;
 
-			cpumask_and(&domain_mask, sched_domain_span(sd),
-				    lowest_mask);
+				cpumask_and(domain_mask,
+					    sched_domain_span(sd),
+					    lowest_mask);
 
-			best_cpu = pick_optimal_cpu(this_cpu,
-						    &domain_mask);
-			if (best_cpu != -1)
-				return best_cpu;
+				best_cpu = pick_optimal_cpu(this_cpu,
+							    domain_mask);
+
+				if (best_cpu != -1) {
+					free_cpumask_var(domain_mask);
+					return best_cpu;
+				}
+			}
 		}
+		free_cpumask_var(domain_mask);
 	}
 
 	/*
diff --git a/kernel/softirq.c b/kernel/softirq.c
index bdbe9de..0365b48 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -795,6 +795,11 @@ int __init __weak early_irq_init(void)
 	return 0;
 }
 
+int __init __weak arch_probe_nr_irqs(void)
+{
+	return 0;
+}
+
 int __init __weak arch_early_irq_init(void)
 {
 	return 0;
diff --git a/kernel/sys.c b/kernel/sys.c
index e7dc0e1..87ca037 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -14,6 +14,7 @@
 #include <linux/prctl.h>
 #include <linux/highuid.h>
 #include <linux/fs.h>
+#include <linux/perf_counter.h>
 #include <linux/resource.h>
 #include <linux/kernel.h>
 #include <linux/kexec.h>
@@ -1799,6 +1800,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		case PR_SET_TSC:
 			error = SET_TSC_CTL(arg2);
 			break;
+		case PR_TASK_PERF_COUNTERS_DISABLE:
+			error = perf_counter_task_disable();
+			break;
+		case PR_TASK_PERF_COUNTERS_ENABLE:
+			error = perf_counter_task_enable();
+			break;
 		case PR_GET_TIMERSLACK:
 			error = current->timer_slack_ns;
 			break;
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 27dad29..68320f6 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -175,3 +175,6 @@ cond_syscall(compat_sys_timerfd_settime);
 cond_syscall(compat_sys_timerfd_gettime);
 cond_syscall(sys_eventfd);
 cond_syscall(sys_eventfd2);
+
+/* performance counters: */
+cond_syscall(sys_perf_counter_open);
diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
index 0f8fc22..4689cb0 100644
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -22,7 +22,7 @@ notrace unsigned int debug_smp_processor_id(void)
 	 * Kernel threads bound to a single CPU can safely use
 	 * smp_processor_id():
 	 */
-	if (cpus_equal(current->cpus_allowed, cpumask_of_cpu(this_cpu)))
+	if (cpumask_equal(&current->cpus_allowed, cpumask_of(this_cpu)))
 		goto out;
 
 	/*
