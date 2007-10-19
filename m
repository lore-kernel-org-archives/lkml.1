Return-Path: <linux-kernel-owner+w=401wt.eu-S1763598AbXJSVqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763598AbXJSVqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbXJSVqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:46:40 -0400
Received: from www.tglx.de ([62.245.132.106]:39405 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbXJSVqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:46:39 -0400
Date: Fri, 19 Oct 2007 23:46:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [Git pull] arch/x86 updates
Message-ID: <alpine.LFD.0.9999.0710192334440.22770@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from: 

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-x86.git

This tree contains

- another chunk of the -mm/ak pending patches
- some unification patches
- merge fallout fixups
- bugfixes fallout from automated testing
- trivial cleanups

A full log, including the patches is available here:

  http://userweb.kernel.org/~tglx/git-x86-changes

Thanks

	tglx
---

Adrian Knoth (1):
      Kconfig: Missing line breaks in arch/x86_64/Kconfig

Akinobu Mita (1):
      i386: do cpuid_device_create() in CPU_UP_PREPARE instead of CPU_ONLINE.

Andi Kleen (6):
      x86: remove page_fault_trace
      x86: don't zero pad addresses in segfault message
      x86: Unify i386 and x86-64 early quirks
      x86: enable iommu_merge by default
      x86: use raw locks during oopses
      x86 & generic: change to __builtin_prefetch()

Andres Salomon (1):
      GEODE: use symbolic constant in cs5536 reboot fixup

Glauber de Oliveira Costa (1):
      x86: use descriptor's functions instead of inline assembly

Hiroshi Shimamoto (1):
      x86: merge init_task_32/64.c

Ingo Molnar (1):
      x86: fix CONFIG_NUMA and nosmp | maxcpus=0/1 crash

Jan Beulich (1):
      x86: honor _PAGE_PSE bit on page walks

Jan Blunck (2):
      i386: make callgraph use dump_trace() on i386/x86_64
      x86: introduce frame_pointer() and stack_pointer()

Laurent Vivier (1):
      x86: implement missing x86_64 function smp_call_function_mask()

Mike Travis (4):
      x86: convert cpu_to_apicid to be a per cpu variable
      x86: convert cpu_llc_id to be a per cpu variable
      x86: acpi use cpu_physical_id
      x86: convert cpuinfo_x86 array to a per_cpu array

Pavel Emelyanov (1):
      i386: consolidate show_regs and show_registers for i386

Roland McGrath (1):
      x86: Use linux/elfcore-compat.h

Rusty Russell (1):
      i386: introduce "used_vectors" bitmap which can be used to reserve vectors.

Sam Ravnborg (1):
      x86: use relative symlink for bzImage

Siddha, Suresh B (1):
      x86, vsyscall: fix the oops crash with __pa_vsymbol()

Stephane Eranian (2):
      i386: i386 add AMD64 Barcelona PMU MSR definitions to msr.h
      i386: do not BUG_ON() when MSR is unknown

Thomas Gleixner (4):
      x86: update .gitignore entries
      x86: move cpufreq Kconfigs to the same directory
      x86: quirk.c trivial coding style and white space cleanup
      x86: add force_hpet boot option

Udo A. Steinberg (2):
      x86: force enable HPET on VT8235/8237 chipsets
      x86: enable HPET on ICH3 and ICH4

 .gitignore                                         |    1 +
 Documentation/kernel-parameters.txt                |    6 +-
 arch/i386/Kconfig                                  |    2 +-
 arch/i386/Makefile                                 |    6 +-
 arch/x86/ia32/ia32_binfmt.c                        |  124 +++++++------------
 arch/x86/kernel/Makefile_32                        |    3 +-
 arch/x86/kernel/Makefile_64                        |    4 +-
 arch/x86/kernel/acpi/Makefile_32                   |    3 -
 arch/x86/kernel/acpi/boot.c                        |    2 +-
 arch/x86/kernel/acpi/cstate.c                      |    4 +-
 arch/x86/kernel/acpi/earlyquirk_32.c               |   84 -------------
 arch/x86/kernel/acpi/processor.c                   |    2 +-
 arch/x86/kernel/alternative.c                      |    6 +-
 .../x86/kernel/cpu/cpufreq/{Kconfig => Kconfig_32} |    0 
 .../{cpufreq/Kconfig => cpu/cpufreq/Kconfig_64}    |    2 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c         |    4 +-
 arch/x86/kernel/cpu/cpufreq/e_powersaver.c         |    2 +-
 arch/x86/kernel/cpu/cpufreq/elanfreq.c             |    4 +-
 arch/x86/kernel/cpu/cpufreq/longhaul.c             |    4 +-
 arch/x86/kernel/cpu/cpufreq/longrun.c              |    4 +-
 arch/x86/kernel/cpu/cpufreq/p4-clockmod.c          |    4 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k6.c          |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k7.c          |    2 +-
 arch/x86/kernel/cpu/cpufreq/sc520_freq.c           |    4 +-
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c   |    6 +-
 arch/x86/kernel/cpu/cpufreq/speedstep-lib.c        |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c              |   12 +-
 arch/x86/kernel/cpu/perfctr-watchdog.c             |   16 ++-
 arch/x86/kernel/cpu/proc.c                         |   11 ++-
 arch/x86/kernel/cpuid.c                            |   34 +++---
 .../kernel/{early-quirks_64.c => early-quirks.c}   |   19 +++-
 arch/x86/kernel/genapic_64.c                       |   15 ++-
 arch/x86/kernel/genapic_flat_64.c                  |    2 +-
 arch/x86/kernel/head64.c                           |    2 +-
 arch/x86/kernel/hpet.c                             |    3 +
 arch/x86/kernel/i8259_32.c                         |    3 +-
 arch/x86/kernel/{init_task_32.c => init_task.c}    |   11 +-
 arch/x86/kernel/init_task_64.c                     |   54 ---------
 arch/x86/kernel/io_apic_32.c                       |   13 ++-
 arch/x86/kernel/mce_64.c                           |    3 +-
 arch/x86/kernel/mce_amd_64.c                       |    4 +-
 arch/x86/kernel/microcode.c                        |    6 +-
 arch/x86/kernel/mpparse_64.c                       |   17 +++-
 arch/x86/kernel/msr.c                              |    2 +-
 arch/x86/kernel/pci-dma_64.c                       |    2 +-
 arch/x86/kernel/process_32.c                       |   56 +++++++---
 arch/x86/kernel/quirks.c                           |  112 ++++++++++++++++--
 arch/x86/kernel/reboot_64.c                        |    3 +-
 arch/x86/kernel/reboot_fixups_32.c                 |    8 +-
 arch/x86/kernel/setup64.c                          |   10 ++-
 arch/x86/kernel/setup_32.c                         |    4 +-
 arch/x86/kernel/setup_64.c                         |   25 +++-
 arch/x86/kernel/smp_32.c                           |    4 +-
 arch/x86/kernel/smp_64.c                           |  119 ++++++++++---------
 arch/x86/kernel/smpboot_32.c                       |   81 +++++++------
 arch/x86/kernel/smpboot_64.c                       |   74 ++++++++----
 arch/x86/kernel/suspend_64.c                       |   11 +-
 arch/x86/kernel/traps_32.c                         |   54 ++++-----
 arch/x86/kernel/traps_64.c                         |   16 +--
 arch/x86/kernel/tsc_32.c                           |    8 +-
 arch/x86/kernel/tsc_64.c                           |    4 +-
 arch/x86/kernel/vsyscall_64.c                      |    4 +-
 arch/x86/lib/delay_32.c                            |    2 +-
 arch/x86/lib/delay_64.c                            |    3 +-
 arch/x86/mach-voyager/voyager_smp.c                |   12 +-
 arch/x86/mm/fault_32.c                             |    3 +-
 arch/x86/mm/fault_64.c                             |   16 +---
 arch/x86/mm/numa_64.c                              |    2 +-
 arch/x86/oprofile/backtrace.c                      |  110 ++++++------------
 arch/x86_64/.gitignore                             |    1 +
 arch/x86_64/Kconfig                                |    8 +-
 arch/x86_64/Makefile                               |    6 +-
 drivers/acpi/processor_core.c                      |    8 +-
 drivers/hwmon/coretemp.c                           |    6 +-
 drivers/hwmon/hwmon-vid.c                          |    2 +-
 drivers/input/gameport/gameport.c                  |    3 +-
 drivers/video/geode/video_gx.c                     |    2 +-
 include/asm-x86/acpi_32.h                          |    6 +-
 include/asm-x86/compat.h                           |    6 +
 include/asm-x86/desc_64.h                          |   30 +++++
 include/asm-x86/geode.h                            |    2 +
 include/asm-x86/hpet.h                             |    1 +
 include/asm-x86/io_apic_64.h                       |    2 +
 include/asm-x86/ipi.h                              |    2 +-
 include/asm-x86/irq_32.h                           |    3 +
 include/asm-x86/msr-index.h                        |   36 ++++--
 include/asm-x86/processor_32.h                     |   16 ++-
 include/asm-x86/processor_64.h                     |   16 +--
 include/asm-x86/proto.h                            |    2 -
 include/asm-x86/ptrace_32.h                        |    2 +
 include/asm-x86/ptrace_64.h                        |    2 +
 include/asm-x86/smp_32.h                           |    6 +-
 include/asm-x86/smp_64.h                           |   11 ++-
 include/asm-x86/system_32.h                        |    1 +
 include/asm-x86/topology_32.h                      |    4 +-
 include/asm-x86/topology_64.h                      |    4 +-
 include/linux/prefetch.h                           |    9 +-
 97 files changed, 754 insertions(+), 700 deletions(-)
 delete mode 100644 arch/x86/kernel/acpi/earlyquirk_32.c
 rename arch/x86/kernel/cpu/cpufreq/{Kconfig => Kconfig_32} (100%)
 rename arch/x86/kernel/{cpufreq/Kconfig => cpu/cpufreq/Kconfig_64} (98%)
 rename arch/x86/kernel/{early-quirks_64.c => early-quirks.c} (89%)
 rename arch/x86/kernel/{init_task_32.c => init_task.c} (80%)
 delete mode 100644 arch/x86/kernel/init_task_64.c
 create mode 100644 arch/x86_64/.gitignore
