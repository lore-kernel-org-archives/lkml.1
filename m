Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYGUPEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYGUPEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYGUPEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:04:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33709 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbYGUPEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:04:33 -0400
Date: Mon, 21 Jul 2008 17:04:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] x86 updates for v2.6.27, phase #2
Message-ID: <20080721150415.GA19921@elte.hu>
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

Please pull the latest x86/for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/for-linus

This contains updates from the following 21 x86 topics:

  x86/urgent,  x86/amd-iommu,  x86/apic,   x86/cleanups, x86/core,
  x86/cpu,     x86/fixmap,     x86/gart,   x86/kprobes,  x86/memtest, 
  x86/modules, x86/nmi,        x86/pat,    x86/reboot,   x86/setup, 
  x86/step,    x86/unify-pci,  x86/uv,     x86/xen,      xen-64bit,
  x86/paravirt-spinlocks.

The biggest one is xen-64bit+paravirt-spinlocks - these were done in 
time for the merge window and were stable and mergable, they just 
depended massively on topics that are now upstream.

x86/unify-pci has been acked by Jesse. x86/modules bears special mention 
as well (commit 5e5a29bf2). I'd like to also give a special mention to:

  # 3f9b5cc01, x86: re-enable OPTIMIZE_INLINING

this change became possible due to UML fix 4f81c535 from Jeff Dike. It 
defaults to off, it just moves out from under the scope of 
CONFIG_BROKEN. (now that all known breakages have been fixed)

out-of-topic modifications in x86/for-linus:
--------------------------------------------
include/linux/debugfs.h            # ae79cda: x86: Add a arch directory for x86
kernel/power/Kconfig               # 93a0886: x86, xen, power: fix up config de
                                   # 6717ef1: Revert "suspend, xen: enable PM_S
                                   # 0775b3d: suspend, xen: enable PM_SLEEP for

Thanks,

	Ingo

------------------>
Akinobu Mita (1):
      x86, intel_cacheinfo: fix use-after-free cache_kobject

Alexander Beregalov (2):
      x86 setup.c: cleanup includes
      arch/x86/kernel/cpu/common_64.c: remove double inclusions

Alexander van Heukelum (3):
      x86, cleanup: fix description of __fls(): __fls(0) is undefined
      x86: traps_xx: refactor die() like in x86_64
      x86: traps_xx: modify x86_64 to use _log_lvl variants

Anders H Kaseorg (1):
      x86, 64-bit: patch paravirt inline replacements when loading modules

Cyrill Gorcunov (5):
      x86: idle process - add checking for NULL early param
      x86: io delay - add checking for NULL early param
      x86: smpboot maxcpus - add checking for NULL early param
      x86: apic_64 - make calibrate_APIC_clock to return error code
      x86: apic_32 - introduce calibrate_APIC_clock

Eduardo Habkost (6):
      x86/paravirt: call paravirt_pagetable_setup_{start, done}
      pvops-64: call paravirt_post_allocator_init() on setup_arch()
      xen64: xen_write_idt_entry() and cvt_gate_to_trap()
      Xen64: HYPERVISOR_set_segment_base() implementation
      xen64: implement xen_load_gs_index()
      xen64: Clear %fs on xen_load_tls()

FUJITA Tomonori (4):
      x86: make only GART code include gart.h
      x86: remove ifdef CONFIG_GART_IOMMU in pci-dma.c
      x86: remove ifdef CONFIG_CALGARY_IOMMU in pci-dma.c
      x86: remove ifdef CONFIG_SWIOTLB in pci-dma.c

H. Peter Anvin (2):
      x86: unify and correct the GDT_ENTRY() macro
      x86: unify and correct the GDT_ENTRY() macro

Harvey Harrison (1):
      x86: suppress sparse returning void warnings

Herton Ronaldo Krzesinski (1):
      Fix typos from signal_32/64.h merge

Hiroshi Shimamoto (3):
      x86_64: ia32_signal.c: use macro instead of immediate
      x86_32: remove redundant KERN_INFO
      x86_64: ia32_signal.c: remove signal number conversion

Ingo Molnar (15):
      xen64: fix !HVC_XEN build dependency
      xen64: fix build error on 32-bit + !HIGHMEM
      Revert "suspend, xen: enable PM_SLEEP for CONFIG_XEN"
      Revert "x86_64: there's no need to preallocate level1_fixmap_pgt"
      x86, xen, vdso: fix build error
      x86: paravirt spinlocks, !CONFIG_SMP build fixes
      x86: paravirt spinlocks, modular build fix
      x86, paravirt-spinlocks: fix boot hang
      x86 reboot quirks: add Dell Precision WorkStation T5400
      x86: rename CONFIG_NONPROMISC_DEVMEM to CONFIG_PROMISC_DEVMEM
      x86: remove arch/x86/kernel/smpcommon_32.c
      x86: re-enable OPTIMIZE_INLINING
      Subject: devmem, x86: fix rename of CONFIG_NONPROMISC_DEVMEM
      x86, VisWS: turn into generic arch, eliminate leftover files
      KVM: fix exception entry / build bug, on 64-bit

Isaku Yamahata (2):
      xen-netfront: fix xennet_release_tx_bufs()
      xen: add xen_arch_resume()/xen_timer_resume hook for ia64 support

Jan Beulich (6):
      x86: check function status in EDD boot code
      x86: fix two modpost warnings
      x86: reduce forbid_dac's visibility
      x86: reduce force_mwait visibility
      i386/xen: add proper unwind annotations to xen_sysenter_target
      x86: i386: reduce boot fixmap space

Jaswinder Singh (1):
      x86: introducing asm-x86/traps.h

Jeremy Fitzhardinge (57):
      x86_64: there's no need to preallocate level1_fixmap_pgt
      x86: clean up formatting of __switch_to
      x86: use __page_aligned_data/bss
      x86_64: adjust exception frame in ia32entry
      x86_64: unstatic get_local_pda
      xen: print backtrace on multicall failure
      xen: define set_pte from the outset
      xen64: define asm/xen/interface for 64-bit
      xen: make ELF notes work for 32 and 64 bit
      xen: fix 64-bit hypercall variants
      xen64: fix calls into hypercall page
      xen64: add extra pv_mmu_ops
      xen64: random ifdefs to mask out 32-bit only code
      xen64: get active_mm from the pda
      xen: move smp setup into smp.c
      x86_64: add workaround for no %gs-based percpu
      xen64: smp.c compile hacking
      xen64: add xen-head code to head_64.S
      xen64: add asm-offsets
      xen64: add 64-bit assembler
      xen64: use set_fixmap for shared_info structure
      xen: cpu_detect is 32-bit only
      xen64: add hypervisor callbacks for events, etc
      xen64: early mapping setup
      xen64: 64-bit starts using set_pte from very early
      xen64: map an initial chunk of physical memory
      xen32: create initial mappings like 64-bit
      xen: fix truncation of machine address
      xen64: use arbitrary_virt_to_machine for xen_set_pmd
      xen: set num_processors
      xen64: defer setting pagetable alloc/release ops
      xen: use set_pte_vaddr
      xen64: deal with extra words Xen pushes onto exception frames
      xen64: add pvop for swapgs
      xen64: register callbacks in arch-independent way
      xen64: add identity irq->vector map
      xen: rework pgd_walk to deal with 32/64 bit
      xen: make sure the kernel command line is right
      suspend, xen: enable PM_SLEEP for CONFIG_XEN
      xen64: implement failsafe callback
      xen64: implement 64-bit update_descriptor
      xen64: save lots of registers
      xen64: allocate and manage user pagetables
      xen64: set up syscall and sysenter entrypoints for 64-bit
      xen64: set up userspace syscall patch
      xen: implement Xen write_msr operation
      xen: update Kconfig to allow 64-bit Xen
      xen64: disable 32-bit syscall/sysenter if not supported.
      x86_64: further cleanup of 32-bit compat syscall mechanisms
      x86: xen: no need to disable vdso32
      x86_64: adjust exception frame on paranoid exceptions
      x86/paravirt: add hooks for spinlock operations
      paravirt: introduce a "lock-byte" spinlock implementation
      xen: use lock-byte spinlock implementation
      xen: implement Xen-specific spinlocks
      x86, xen, power: fix up config dependencies on PM
      xen: report hypervisor version

Joerg Roedel (18):
      x86, AMD IOMMU: ignore detection of GART IOMMU
      x86, AMD IOMMU: add comments to amd_iommu_types.h
      x86, AMD IOMMU: add comments to the initialization code
      x86, AMD IOMMU: add comments to core code
      x86, AMD IOMMU: replace HIGH_U32 macro with upper_32_bits function
      x86, AMD IOMMU: replace UPDATE_LAST_BDF macro with a function
      x86, AMD IOMMU: replace TBL_SIZE macro with a function
      x86, AMD IOMMU: remove unnecessary free checks from init code
      x86, AMD IOMMU: add an emergency exit to the completion wait loop
      x86, AMD IOMMU: rename struct command to iommu_cmd
      x86, AMD IOMMU: remove unneeded initializations from command buffer allocation
      x86, AMD IOMMU: use true/false instead of 0/1 for bool value
      x86, AMD IOMMU: do runtime list initialization at compile time
      x86, AMD IOMMU: replace memset with __GFP_ZERO for table allocation
      x86, AMD IOMMU: replace self made size parsing with memparse call
      x86, AMD IOMMU: fix device table entry size
      x86, AMD IOMMU: replace DEVID macro with a function
      AMD IOMMU: set iommu for device from ACPI code too

Maciej W. Rozycki (5):
      x86: APIC: remove apic_write_around(); use alternatives
      x86: I/O APIC: Include <asm/i8259.h> required by some code
      x86: APIC: Make apic_verbosity unsigned
      x86: I/O APIC: Always report how the timer has been set up
      x86: more apic debugging

Peter Zijlstra (1):
      Kprobe smoke test lockdep warning

Robert Richter (5):
      x86/pci: Removing pci-y in Makefile
      x86/pci: Changing subsystem initialization order for NUMA
      x86/pci: renamed: numa.c -> numaq_32.c
      x86/pci: renaming numa into numaq
      x86/pci: Changing subsystem init for visws

Roland McGrath (4):
      x86 ptrace: block-step fix
      x86 ptrace: unify TIF_SINGLESTEP
      x86 ptrace: unify syscall tracing
      x86 ptrace: user-sets-TF nits

Russ Anderson (1):
      x86 BIOS interface for RTC on SGI UV

Sebastian Siewior (1):
      ftrace: copy + paste typo in asm/ftrace.h

Simon Arlott (1):
      x86: add unknown_nmi_panic kernel parameter

Stephen Rothwell (1):
      linux-next: pci tree build failure

Thomas Petazzoni (1):
      x86: consolidate the definition of the force_mwait variable

Yinghai Lu (10):
      x86: use cpu_clear in remove_cpu_from_maps
      x86: seperate memtest from init_64.c
      x86: enable memory tester support on 32-bit
      x86: remove arch_get_ram_range
      x86: improve debug printout: add target bootmem range in early_res_to_bootmem()
      x86: introduce x86_quirks
      x86: extend and use x86_quirks to clean up NUMAQ code
      x86: add ->pre_time_init to x86_quirks
      x86: use setup_clear_cpu_cap() when disabling the lapic
      x86: remove extra calling to get ext cpuid level

venkatesh.pallipadi@intel.com (2):
      x86: Add a arch directory for x86 under debugfs
      x86: Add a debugfs interface to dump PAT memtype


 Documentation/kernel-parameters.txt        |    6 +-
 arch/x86/Kconfig                           |    1 -
 arch/x86/Kconfig.cpu                       |    4 -
 arch/x86/Kconfig.debug                     |   11 +-
 arch/x86/boot/edd.c                        |    5 +-
 arch/x86/boot/pm.c                         |    6 -
 arch/x86/configs/i386_defconfig            |    2 +-
 arch/x86/configs/x86_64_defconfig          |    2 +-
 arch/x86/ia32/ia32_signal.c                |   11 +-
 arch/x86/ia32/ia32entry.S                  |   18 +-
 arch/x86/kernel/Makefile                   |    4 +-
 arch/x86/kernel/acpi/sleep.c               |   10 +-
 arch/x86/kernel/amd_iommu.c                |  231 +++++++++-
 arch/x86/kernel/amd_iommu_init.c           |  357 +++++++++++----
 arch/x86/kernel/aperture_64.c              |    1 +
 arch/x86/kernel/apic_32.c                  |  175 ++++----
 arch/x86/kernel/apic_64.c                  |   26 +-
 arch/x86/kernel/asm-offsets_64.c           |   11 +
 arch/x86/kernel/bios_uv.c                  |   48 ++
 arch/x86/kernel/cpu/amd.c                  |    2 -
 arch/x86/kernel/cpu/amd_64.c               |    2 +
 arch/x86/kernel/cpu/bugs.c                 |   23 +-
 arch/x86/kernel/cpu/common_64.c            |   15 +-
 arch/x86/kernel/cpu/intel.c                |   10 +
 arch/x86/kernel/cpu/intel_cacheinfo.c      |    7 +-
 arch/x86/kernel/cpu/mcheck/p4.c            |    4 +-
 arch/x86/kernel/e820.c                     |   33 +--
 arch/x86/kernel/early-quirks.c             |    5 +-
 arch/x86/kernel/entry_32.S                 |   24 +-
 arch/x86/kernel/entry_64.S                 |  120 +++++-
 arch/x86/kernel/genx2apic_uv_x.c           |   23 +
 arch/x86/kernel/head64.c                   |   11 +-
 arch/x86/kernel/head_64.S                  |    1 +
 arch/x86/kernel/io_apic_32.c               |   53 ++-
 arch/x86/kernel/io_apic_64.c               |   41 +-
 arch/x86/kernel/io_delay.c                 |    3 +
 arch/x86/kernel/ipi.c                      |    6 +-
 arch/x86/kernel/irq_32.c                   |    7 +-
 arch/x86/kernel/kdebugfs.c                 |    8 +
 arch/x86/kernel/kprobes.c                  |    1 -
 arch/x86/kernel/module_64.c                |   10 +-
 arch/x86/kernel/mpparse.c                  |  208 +--------
 arch/x86/kernel/nmi.c                      |   11 +-
 arch/x86/kernel/numaq_32.c                 |  197 ++++++++-
 arch/x86/kernel/paravirt.c                 |   29 ++-
 arch/x86/kernel/pci-calgary_64.c           |    2 +-
 arch/x86/kernel/pci-dma.c                  |   17 +-
 arch/x86/kernel/pci-gart_64.c              |    1 +
 arch/x86/kernel/pci-nommu.c                |    2 +-
 arch/x86/kernel/pci-swiotlb_64.c           |    2 +-
 arch/x86/kernel/process.c                  |    5 +
 arch/x86/kernel/process_64.c               |   56 ++--
 arch/x86/kernel/ptrace.c                   |  151 +++----
 arch/x86/kernel/reboot.c                   |    8 +
 arch/x86/kernel/setup.c                    |   22 +-
 arch/x86/kernel/signal_32.c                |    8 +-
 arch/x86/kernel/signal_64.c                |    6 -
 arch/x86/kernel/smpboot.c                  |   56 +--
 arch/x86/kernel/smpcommon_32.c             |    1 -
 arch/x86/kernel/step.c                     |   35 ++-
 arch/x86/kernel/time_32.c                  |    1 +
 arch/x86/kernel/traps_32.c                 |  118 +++---
 arch/x86/kernel/traps_64.c                 |   48 +--
 arch/x86/kernel/visws_quirks.c             |   42 +-
 arch/x86/kernel/vmi_32.c                   |    1 -
 arch/x86/lguest/boot.c                     |    1 -
 arch/x86/mach-default/setup.c              |   34 +-
 arch/x86/mm/Makefile                       |    1 +
 arch/x86/mm/init_32.c                      |    5 +-
 arch/x86/mm/init_64.c                      |  112 -----
 arch/x86/mm/memtest.c                      |  123 +++++
 arch/x86/mm/pat.c                          |   94 ++++-
 arch/x86/pci/Makefile                      |   12 +-
 arch/x86/pci/legacy.c                      |    9 +-
 arch/x86/pci/{numa.c => numaq_32.c}        |    4 +-
 arch/x86/pci/pci.h                         |    3 +-
 arch/x86/pci/visws.c                       |   23 +-
 arch/x86/vdso/Makefile                     |    2 +-
 arch/x86/vdso/vdso32-setup.c               |   19 +-
 arch/x86/vdso/vdso32.S                     |   13 +-
 arch/x86/vdso/vma.c                        |   11 +-
 arch/x86/xen/Kconfig                       |   14 +-
 arch/x86/xen/Makefile                      |    2 +-
 arch/x86/xen/enlighten.c                   |  697 ++++++++++++++++++++++------
 arch/x86/xen/mmu.c                         |  316 +++++++++----
 arch/x86/xen/mmu.h                         |   29 +-
 arch/x86/xen/multicalls.c                  |    1 +
 arch/x86/xen/setup.c                       |   79 +++-
 arch/x86/xen/smp.c                         |  306 ++++++++++--
 arch/x86/xen/suspend.c                     |    5 +-
 arch/x86/xen/{xen-asm.S => xen-asm_32.S}   |    0
 arch/x86/xen/xen-asm_64.S                  |  271 +++++++++++
 arch/x86/xen/xen-head.S                    |   28 +-
 arch/x86/xen/xen-ops.h                     |   21 +-
 drivers/char/mem.c                         |    2 +-
 drivers/net/xen-netfront.c                 |   19 +-
 drivers/pci/intel-iommu.c                  |    2 +-
 drivers/xen/events.c                       |   27 ++
 drivers/xen/manage.c                       |   10 +-
 include/asm-x86/amd_iommu_types.h          |  114 +++++-
 include/asm-x86/apic.h                     |   28 +-
 include/asm-x86/arch_hooks.h               |    1 +
 include/asm-x86/bitops.h                   |    2 +-
 include/asm-x86/calling.h                  |    6 +-
 include/asm-x86/cpufeature.h               |    1 +
 include/asm-x86/dma-mapping.h              |    1 -
 include/asm-x86/e820.h                     |    8 +
 include/asm-x86/fixmap_32.h                |    6 +-
 include/asm-x86/ftrace.h                   |    2 +-
 include/asm-x86/gart.h                     |    1 -
 include/asm-x86/iommu.h                    |   10 +-
 include/asm-x86/kvm_host.h                 |    8 +-
 include/asm-x86/mach-bigsmp/mach_apic.h    |    4 +-
 include/asm-x86/mach-default/mach_apic.h   |    4 +-
 include/asm-x86/mach-es7000/mach_apic.h    |    4 +-
 include/asm-x86/mach-generic/mach_mpspec.h |    2 +
 include/asm-x86/mach-summit/mach_apic.h    |    4 +-
 include/asm-x86/mach-visws/entry_arch.h    |    5 -
 include/asm-x86/mach-visws/mach_apic.h     |    1 -
 include/asm-x86/mach-visws/mach_apicdef.h  |    1 -
 include/asm-x86/mach-visws/setup_arch.h    |    1 -
 include/asm-x86/mach-visws/smpboot_hooks.h |    1 -
 include/asm-x86/paravirt.h                 |   75 +++-
 include/asm-x86/percpu.h                   |   26 +
 include/asm-x86/pgtable.h                  |   18 +
 include/asm-x86/pgtable_32.h               |   15 -
 include/asm-x86/pgtable_64.h               |    2 +
 include/asm-x86/processor.h                |    2 -
 include/asm-x86/ptrace-abi.h               |    6 +-
 include/asm-x86/segment.h                  |    9 +
 include/asm-x86/setup.h                    |   30 +-
 include/asm-x86/signal.h                   |    4 +-
 include/asm-x86/smp.h                      |    2 +
 include/asm-x86/spinlock.h                 |  118 ++++-
 include/asm-x86/spinlock_types.h           |    2 +-
 include/asm-x86/swiotlb.h                  |    6 +-
 include/asm-x86/thread_info.h              |   21 +-
 include/asm-x86/traps.h                    |   66 +++
 include/asm-x86/uv/bios.h                  |   68 +++
 include/asm-x86/vdso.h                     |    8 +
 include/asm-x86/xen/events.h               |    1 +
 include/asm-x86/xen/hypercall.h            |  263 ++++++++----
 include/asm-x86/xen/interface.h            |  139 ++----
 include/asm-x86/xen/interface_32.h         |   97 ++++
 include/asm-x86/xen/interface_64.h         |  159 +++++++
 include/asm-x86/xen/page.h                 |    6 +-
 include/linux/debugfs.h                    |    2 +
 include/xen/events.h                       |    7 +
 include/xen/hvc-console.h                  |    7 +-
 include/xen/interface/callback.h           |    6 +-
 include/xen/xen-ops.h                      |    3 +
 kernel/power/Kconfig                       |    2 +-
 152 files changed, 4292 insertions(+), 1753 deletions(-)
 create mode 100644 arch/x86/kernel/bios_uv.c
 delete mode 100644 arch/x86/kernel/smpcommon_32.c
 create mode 100644 arch/x86/mm/memtest.c
 rename arch/x86/pci/{numa.c => numaq_32.c} (97%)
 rename arch/x86/xen/{xen-asm.S => xen-asm_32.S} (100%)
 create mode 100644 arch/x86/xen/xen-asm_64.S
 delete mode 100644 include/asm-x86/mach-visws/entry_arch.h
 delete mode 100644 include/asm-x86/mach-visws/mach_apic.h
 delete mode 100644 include/asm-x86/mach-visws/mach_apicdef.h
 delete mode 100644 include/asm-x86/mach-visws/setup_arch.h
 delete mode 100644 include/asm-x86/mach-visws/smpboot_hooks.h
 create mode 100644 include/asm-x86/traps.h
 create mode 100644 include/asm-x86/uv/bios.h
 create mode 100644 include/asm-x86/xen/interface_32.h
 create mode 100644 include/asm-x86/xen/interface_64.h
