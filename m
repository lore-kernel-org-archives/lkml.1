Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbYLYLeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbYLYLeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 06:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYLYLem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 06:34:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49847 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbYLYLek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 06:34:40 -0500
Date: Thu, 25 Dec 2008 12:34:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Nick Piggin <npiggin@suse.de>
Subject: [git pull] x86 updates for v2.6.29
Message-ID: <20081225113419.GA29986@elte.hu>
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

Please pull the latest x86-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-core-for-linus

This includes updates from 32 (mostly independent) x86 topic 
trees/branches:

   x86/apic                 x86/cleanups             x86/core
   x86/cpufeature           x86/crashdump            x86/debug
   x86/defconfig            x86/detect-hyper         x86/doc
   x86/dumpstack            x86/early-printk         x86/fpu
   x86/idle                 x86/io                   x86/iommu
   x86/irq                  x86/memory-corruption-check
   x86/microcode            x86/mm                   x86/mtrr                 
   x86/nmi-watchdog         x86/pat2                 
   x86/pci-ioapic-boot-irq-quirks                    x86/ptrace               
   x86/quirks               x86/reboot               x86/setup-memory
   x86/signal               x86/sparse-fixes         x86/time
   x86/tsc                  x86/uv                   x86/xen

[ There are more "dependent" x86 changes in the sparseirq and cpus4096 
  tree. ]

x86/pci-ioapic-boot-irq-quirks has been tentatively acked by Jesse a few 
months ago - the topic was left out of v28 due to merge window time 
constraints. The generic MM bits in x86/pat2 have been seen and acked by 
MM folks (Nick and Andrew). These two topics generate most of the 
out-of-tree impact:

out-of-topic modifications in x86-core-for-linus:
-------------------------------------------------
drivers/acpi/pci_irq.c             # e1d3a90: pci, acpi: reroute PCI interrupt 
drivers/acpi/processor_idle.c      # 40fb171: x86: support always running TSC o
drivers/firmware/dmi_scan.c        # fd8cd7e: x86: vmware: look for DMI string 
drivers/pci/quirks.c               # 41b9eb2: x86, pci: introduce config option
                                   # 88d1dce: PCI quirks: call boot IRQ quirks 
                                   # 542622d: PCI quirks: disable AMD/ATI legac
                                   # 7725118: PCI quirks: add quirk to disable 
                                   # b0356cd: pci, acpi: reroute PCI interrupt 
                                   # e1d3a90: pci, acpi: reroute PCI interrupt 
                                   # 426b3b8: pci: add quirk to disable boot in
include/asm-generic/bug.h          # b93a531: allow bug table entries to use re
include/asm-generic/pgtable.h      # 34801ba: x86: PAT: move track untrack pfnm
                                   # 2520bd3: x86: PAT: add pgprot_writecombine
include/linux/dmi.h                # fd8cd7e: x86: vmware: look for DMI string 
include/linux/kexec.h              # 92be3d6: kexec/i386: allocate page table p
include/linux/linkage.h            # d211af0: i386: get rid of the use of KPROB
include/linux/mm.h                 # 34801ba: x86: PAT: move track untrack pfnm
                                   # 982d789: x86: PAT: remove follow_pfnmap_pt
                                   # d87fe66: x86: PAT: modify follow_phys to r
                                   # 6bd9cd5: x86: PAT: clarify is_linear_pfn_m
                                   # 2ab6403: x86: PAT: hooks in generic vm cod
                                   # e121e41: x86: PAT: add follow_pfnmp_pte ro
                                   # 3c8bb73: x86: PAT: store vm_pgoff for all 
include/linux/pci.h                # e1d3a90: pci, acpi: reroute PCI interrupt 
include/linux/pci_ids.h            # 747ada3: pci: add PCI IDs for devices that
lib/bug.c                          # b93a531: allow bug table entries to use re
mm/memory.c                        # 34801ba: x86: PAT: move track untrack pfnm
                                   # 982d789: x86: PAT: remove follow_pfnmap_pt
                                   # d87fe66: x86: PAT: modify follow_phys to r
                                   # 2ab6403: x86: PAT: hooks in generic vm cod
                                   # e121e41: x86: PAT: add follow_pfnmp_pte ro
                                   # 3c8bb73: x86: PAT: store vm_pgoff for all 
mm/swapfile.c                      # 1796316: x86: consolidate __swp_XXX() macr


 Thanks,

	Ingo

------------------>
Alexander van Heukelum (19):
      i386, dumpstack: move crash_kexec before bust_spinlocks(0) in oops_end
      x86, dumpstack: let signr=0 signal no do_exit
      x86_64, dumpstack: move kexec_crash from __die to oops_end
      x86, dumpstack: always call oops_exit from oops_end
      i386, dumpstack: use x86_64's method to account die_nest_count
      i386, dumpstack: use oops_begin/oops_end in die_nmi
      i386, dumpstack: unify die()
      x86: irq: fix apicinterrupts on 64 bits
      x86: entry_64.S: remove whitespace at end of lines
      x86: move entry_64.S register saving out of the macros
      x86: clean up after: move entry_64.S register saving out of the macros
      x86: introduce save_rest and restructure the PTREGSCALL macro in entry_64.S
      x86: entry_64.S: factor out save_paranoid and paranoid_exit
      x86: entry_64.S: split out some macro's and move common code to paranoid_exit
      x86: split out some macro's and move common code to paranoid_exit, fix
      x86: include ENTRY/END in entry handlers in entry_64.S
      x86: KPROBE_ENTRY should be paired wth KPROBE_END
      x86_64: get rid of the use of KPROBE_ENTRY / KPROBE_END
      i386: get rid of the use of KPROBE_ENTRY / KPROBE_END

Alok Kataria (7):
      x86: add a synthetic TSC_RELIABLE feature bit
      x86: add X86_FEATURE_HYPERVISOR feature bit
      x86: Hypervisor detection and get tsc_freq from hypervisor
      x86: Add a synthetic TSC_RELIABLE feature bit.
      x86: Skip verification by the watchdog for TSC clocksource.
      x86: VMware: Fix vmware_get_tsc code
      x86: vmware: look for DMI string in the product serial key

Andi Kleen (1):
      x86: remove simnow earlyprintk support

Andreas Herrmann (10):
      x86: microcode_amd: fix wrong handling of equivalent CPU id
      x86: microcode_amd: fix typos and trailing whitespaces in log messages
      x86: microcode_amd: fix checkpatch warnings/errors
      x86: microcode_amd: fix compile warning
      x86: microcode_amd: don't pass superfluous function pointer for get_ucode_data
      x86: microcode_amd: replace inline asm by common rdmsr/wrmsr functions
      x86: microcode_amd: consolidate macro definitions
      x86: microcode_amd: remove (wrong) chipset deivce ID checks
      x86: microcode_amd: use 'packed' attribute for structs
      x86: microcode_amd: modify log messages

Aristeu Rozanski (3):
      x86, NMI watchdog: add support to enable and disable IOAPIC NMI
      x86, NMI watchdog: disable NMIs on LVT0 in case NMI watchdog is not working
      x86, nmi-watchdog: update procfs nmi_watchdog file documentation v2

Arjan van de Ven (4):
      x86: corruption-check: fix some style issues
      x86: corruption check: move the corruption checks into their own file
      x86: corruption check: run the corruption checks from a work queue
      x86: corruption-check: some post-move cleanups

Bernhard Walle (1):
      pci, acpi: reroute PCI interrupt to legacy boot interrupt equivalent, warning fix

Cliff Wickman (1):
      x86, UV: fix redundant creation of sgi_uv

Cyrill Gorcunov (9):
      x86: nmi - add sensible names to nmi_watchdog boot param
      x86: nmi - nmi_watchdog boot param docs cleanup
      x86: apic - calibrate_APIC_clock remove redundant irq-enable-disable
      x86: apic - use pr_ macros for logging
      x86: move dwarf2 related macro to dwarf2.h
      x86: introduce ENTRY(KPROBE_ENTRY)_X86 assembly helpers to catch unbalanced declaration v3
      x86: entry_64.S - use ENTRY to define child_rip
      x86: uv bau interrupt -- use proper interrupt number
      x86: entry_64.S - trivial: space, comments fixup

Dan McGee (1):
      x86: remove dead IRQBALANCE code

Dave Jones (1):
      x86: remove init_mm export as planned for 2.6.26

Dean Nelson (4):
      sgi-xp: define xp_expand_memprotect() and xp_restrict_memprotect()
      sgi-xp: create activate and notify gru message queues
      sgi-xp: define xp_partition_id and xp_region_size
      sgi-xp: support getting the address of a partition's reserved page

Eduardo Habkost (8):
      x86 kdump: extract kdump-specific code from crash_nmi_callback()
      x86 kdump: move crashing_cpu assignment to nmi_shootdown_cpus()
      x86 kdump: create kdump_nmi_shootdown_cpus()
      x86 kdump: make kdump_nmi_callback() a function ptr on crash_nmi_callback()
      x86 kdump: make nmi_shootdown_cpus() non-static
      x86: move nmi_shootdown_cpus() to reboot.c
      x86: make nmi_shootdown_cpus() available on !SMP and !X86_LOCAL_APIC
      x86: disable IRQs before doing anything on nmi_shootdown_cpus()

FUJITA Tomonori (2):
      x86: fix dma_mapping_error for 32bit x86, cleanup
      x86: remove dead BIO_VMERGE_BOUNDARY definition

Gary Hade (1):
      x86: add memory hotremove config option

H. Peter Anvin (9):
      x86: 32 bit: interrupt stub consistency with 64 bit
      x86: 32 bits: shrink and align IRQ stubs
      x86: 64 bits: shrink and align IRQ stubs
      x86: attempt reboot via port CF9 if we have standard PCI ports
      x86: fix up the new IRQ code for older versions of gas
      x86: revert default reboot method to REBOOT_KBD
      x86: drop REBOOT_CF9_COND from reboot fallback chain
      x86: prioritize the FPU traps for the error code
      x86: PAT: fix address types in track_pfn_vma_new()

Hannes Eder (6):
      x86: vmware - fix sparse warnings
      x86: hypervisor - fix sparse warnings
      x86: remove duplicate #define from 'cpufeature.h'
      x86: boot - fix sparse warnings
      x86: HPET: fix sparse warning
      x86: microcode: fix sparse warnings

Harvey Harrison (2):
      x86: use the new byteorder headers
      x86: x86_32 has its own irq_regs definition

Hiroshi Shimamoto (45):
      x86: signal: cosmetic unification of restore_sigcontext()
      x86: signal_64.c: get_stack() doesn't need entire regs
      x86: signal: cosmetic unification of signr_convert()
      x86: signal: cosmetic unification of macros for setup_rt_frame()
      x86: signal: cosmetic unification of NR_restart_syscall
      x86: signal_64: remove unused code in __setup_rt_frame()
      x86: signal_32: do save_i387_xstate() at get_sigframe()
      x86: ia32_signal: do save_i387_xstate_ia32 at get_sigframe()
      x86: signal_64: setup fpstate in setup_sigcontext()
      x86: signal_64: make setup_sigcontext() similar
      x86: signal: cosmetic unification of setup_sigcontext()
      x86: signal_32: introduce retcode and rt_retcode
      x86: ia32_signal: remove unnecessary padding
      x86: ia32_signal: cleanup macro COPY
      x86: ia32_signal: introduce COPY_SEG_CPL3
      x86: ia32_signal: cleanup macro RELOAD_SEG
      x86: ia32_signal: remove using temporary variable
      x86: ia32_signal: change order of storing in setup_sigcontext()
      x86: signal: rename COPY_SEG_STRICT to COPY_SEG_CPL3
      x86: signal: cosmetic unification of including headers
      x86: signal: cosmetic unification of sys_sigaltstack()
      x86: signal: cosmetic unification of sys_rt_sigreturn()
      x86: signal: move {setup|restore}_sigcontext()
      x86: signal: cosmetic unification of __setup_sigframe() and __setup_rt_sigframe()
      x86: signal: unify signal_{32|64}.c, prepare
      x86: signal: unify signal_{32|64}.c
      x86: signal: change type of paramter for sys_rt_sigreturn()
      x86: uaccess: return value of __{get|put}_user() can be int
      x86: kill #ifdef for exit_idle()
      x86: hardirq: introduce inc_irq_stat()
      x86: hardirq: use inc_irq_stat() in non-unified functions
      x86: signal: use signal_fault() in sys_sigreturn()
      x86: ia32_signal: use __put_user() instead of __copy_to_user()
      x86: ia32_signal: use proper macro __USER32_DS
      x86: signal: move ia32 func declarations into arch/x86/kernel/signal.c
      x86: signal: rename sigframe and rt_sigframe on 32-bit
      x86: signal: move sigframe.h to arch/x86/include/asm
      x86: signal: prepare to include from ia32_signal.c
      x86: ia32_signal: rename struct sigframe and rt_sigframe
      x86: ia32_signal: use sigframe.h
      x86: sigframe.h: add guard macro
      x86: sigframe.h: include headers for dependency
      x86: asm-offset_64: use rt_sigframe_ia32
      x86: ia32.h: remove unused struct sigfram32 and rt_sigframe32
      x86: ia32_signal: remove unnecessary declaration

Hitoshi Mitake (1):
      x86: provide readq()/writeq() on 32-bit too

Huang Ying (3):
      kexec/i386: remove PAGE_SIZE alignment from relocate_kernel
      kexec/i386: allocate page table pages dynamically
      kexec/i386: setup kexec page table in C

Ingo Molnar (19):
      x86: boot IRQ quirks and rerouting, fix
      x86 debug: mark early_printk.o as notrace
      x86: clean up rdtsc_barrier() use
      x86: clean up vget_cycles()
      x86: fix documentation typo in arch/x86/Kconfig
      x86: fix wakeup_cpu with numaq/es7000, v2, fix #2
      x86: clean up after: move entry_64.S register saving out of the macros, fix
      x86: entry_64.S: rename
      x86: clean up stack overflow debug check
      x86 defconfig: increase CONFIG_LOG_BUF_SHIFT
      x86: fix unused variable warning in arch/x86/kernel/hpet.c
      x86: ret_from_fork - get rid of jump back
      x86: provide readq()/writeq() on 32-bit too, cleanup
      x86: provide readq()/writeq() on 32-bit too, complete
      x86: soften multi-BAR mapping sanity check warning message
      x86, debug: remove EBDA debug printk
      x86, mm: limit MAXMEM on 64-bit
      x86: support always running TSC on Intel CPUs, add cpufeature definition
      x86: fix warning in arch/x86/kernel/microcode_amd.c

Ivan Vecera (1):
      x86: call machine_shutdown and stop all CPUs in native_machine_halt

Jack Steiner (1):
      x86: UV fix for global physical addresses

Jan Beulich (7):
      x86: simplify X86_MPPARSE config option
      x86: add two missing unwind annotations
      x86: consolidate __swp_XXX() macros
      allow bug table entries to use relative pointers (and use it on x86-64)
      x86, 32-bit: simplify alloc_low_page()
      x86, 32-bit: add some compile time checks to mem_init()
      x86, 32-bit: improve lazy TLB handling code

Jaswinder Singh (10):
      x86: process_64.c declare __switch_to() and sys_arch_prctl before they get used
      x86: signal.c declare do_notify_resume before they get used
      x86: ldt.c declare sys_modify_ldt before they get used
      x86: setup.c find_and_reserve_crashkernel should be static
      x86: time_64.c timer_interrupt() should be static
      x86: tls.c declare sys_set_thread_area and sys_get_thread_area before they get used
      x86: process.c declare c1e_remove_cpu before they get used
      x86: traps.c declare functions before they get used
      x86: common.c boot_cpu_stack and boot_exception_stacks should be static
      x86: traps.c replace #if CONFIG_X86_32 with #ifdef CONFIG_X86_32

Jeremy Fitzhardinge (1):
      xen: clean up asm/xen/hypervisor.h

Jike Song (1):
      x86: clean up comments wrt. rd{msr|tsc|pmc}

Jiri Slaby (2):
      x86, 64-bit: update address space documentation
      x86: intel_cacheinfo, minor show_type cleanup

Joe Korty (1):
      x86: change thread_info's flag field back to 32 bits

Joerg Roedel (3):
      x86: default to SWIOTLB=y on x86_64
      x86: move GART specific stuff from iommu.h to gart.h
      x86: fix broken flushing in GART nofullflush path

KOSAKI Motohiro (2):
      x86: update CONFIG_NUMA description
      x86/doc: spelling fix for grub

Ken Chen (1):
      x86: convert rdtscll() to use __native_read_tsc

Markus Metzger (1):
      x86, bts: DS and BTS initialization

Michael Tokarev (2):
      x86: fix missing space in printk
      x86: fix missing space in printk, #2

Mikael Pettersson (1):
      x86, signals: remove duplicated register setup code in ia32 signal delivery

Mike Travis (2):
      x86/uv: provide a System Activity Indicator driver
      x86/uv: update SCIR driver to use the idle_cpu() function

Neil Horman (1):
      x86: unify appropriate bits from dumpstack_32 and dumpstack_64

Nick Piggin (1):
      x86, mm: enable GBPAGES option by default

Niels de Vos (1):
      x86, apm: remove CONFIG_APM_REAL_MODE_POWER_OFF in favor of a kernel parameter

Olaf Dabrunz (4):
      pci: add PCI IDs for devices that need boot irq quirks
      PCI quirks: add quirk to disable boot interrupt generation on broadcom HT1000
      PCI quirks: disable AMD/ATI legacy boot interrupt generation
      PCI quirks: call boot IRQ quirks at end of device init and during resume

Pavel Machek (1):
      aperture_64.c: clarify that too small aperture is valid reason for this code

Philipp Kohlbecher (1):
      x86: documentation fix regarding boot protocol

Prarit Bhargava (1):
      x86: warn of incorrect cpu_khz on AMD systems

Rafael J. Wysocki (1):
      x86: change static allocation of trampoline area

Richard A. Holden III (2):
      x86: fix arch/x86/kernel/genx2apic_uv_x.c build warning when !CONFIG_HOTPLUG_CPU
      x86: fix arch/x86/kernel/setup.c build warning when !CONFIG_X86_RESERVE_LOW_64K

Russ Anderson (5):
      x86, uv: use consistent names for region size and conherence id on x86 and ia64
      x86: uv: Add UV watchlist bios call
      x86: uv: Add UV memory protection bios call
      x86: uv: Add UV reserved page bios call
      sgi-xp: xpc needs to pass the physical address, not virtual

Sitsofe Wheeler (1):
      x86: change OPTIMIZE_INLINING help to say enabling makes smaller kernels

Stefan Assmann (5):
      x86, pci: introduce pci=noioapicquirk kernel cmdline option
      x86, pci: introduce pci=ioapicreroute kernel cmdline option
      pci: add quirk to disable boot interrupt generation on intel 6300ESB
      pci, acpi: reroute PCI interrupt to legacy boot interrupt equivalent
      x86, pci: introduce config option for pci reroute quirks (was: [PATCH 0/3] Boot IRQ quirks for Broadcom and AMD/ATI)

Suresh Siddha (1):
      x86: fix intel x86_64 llc_shared_map/cpu_llc_id anomolies

Tej (1):
      xen: whitespace/checkpatch cleanup

Thomas Gleixner (1):
      x86: apic reset counter on shutdown

Uros Bizjak (1):
      x86: Implement change_bit with immediate operand as "lock xorb"

Vegard Nossum (1):
      x86: revert CONFIG_RELOCATABLE=y defconfig change

Venki Pallipadi (1):
      x86: support always running TSC on Intel CPUs

Yinghai Lu (6):
      x86: break up mtrr_cleanup() into several small functions.
      x86: fix wakeup_cpu with numaq/es7000, v2
      x86: fix wakeup_cpu with numaq/es7000, v2, fix
      x86: use update_genapic to get rid of ES7000_CLUSTERED_APIC v2
      x86: fix wakeup_cpu with numaq/es7000 v2 - call ->update_genapic()
      x86: clean up get_smp_config()

Zachary Amsden (1):
      x86: clean up dead code in vmi_32.c

Zhaolei (1):
      x86: avoid duplicate running of pud_offset and pmd_offset in one_md_table_init()

gorcunov@gmail.com (1):
      x86: entry_64.S - use X86_EFLAGS_IF instead of hardcoded number

jia zhang (2):
      x86_64: fix the check in stack_overflow_check
      x86, debug: remove the confusing entry in call trace

venkatesh.pallipadi@intel.com (12):
      x86: PAT: store vm_pgoff for all linear_over_vma_region mappings - v3
      x86: PAT: add follow_pfnmp_pte routine to help tracking pfnmap pages - v3
      x86: PAT: hooks in generic vm code to help archs to track pfnmap regions - v3
      x86: PAT: implement track/untrack of pfnmap regions for x86 - v3
      x86: PAT: change pgprot_noncached to uc_minus instead of strong uc - v3
      x86: PAT: add pgprot_writecombine() interface for drivers - v3
      x86: PAT: update documentation to cover pgprot and remap_pfn related changes - v3
      x86: PAT: clarify is_linear_pfn_mapping() interface
      x86: PAT: modify follow_phys to return phys_addr prot and return value
      x86: PAT: remove follow_pfnmap_pte in favor of follow_phys
      x86: PAT: move track untrack pfnmap stubs to asm-generic
      x86: PAT: pfnmap documentation update changes


 Documentation/feature-removal-schedule.txt        |   12 -
 Documentation/filesystems/proc.txt                |    9 +-
 Documentation/kernel-parameters.txt               |   33 +-
 Documentation/nmi_watchdog.txt                    |    5 +
 Documentation/x86/boot.txt                        |    6 +-
 Documentation/x86/pat.txt                         |   24 +
 Documentation/x86/x86_64/boot-options.txt         |   11 -
 Documentation/x86/x86_64/mm.txt                   |    2 +-
 arch/x86/Kconfig                                  |   84 +-
 arch/x86/Kconfig.debug                            |   20 +-
 arch/x86/boot/video-vga.c                         |    4 +-
 arch/x86/boot/video.c                             |    2 +-
 arch/x86/configs/i386_defconfig                   |    4 +-
 arch/x86/configs/x86_64_defconfig                 |    4 +-
 arch/x86/ia32/ia32_signal.c                       |  109 +--
 arch/x86/include/asm/apic.h                       |    1 +
 arch/x86/include/asm/bigsmp/apic.h                |    2 -
 arch/x86/include/asm/bitops.h                     |   10 +-
 arch/x86/include/asm/bug.h                        |    2 +-
 arch/x86/include/asm/byteorder.h                  |   74 +-
 arch/x86/include/asm/cpufeature.h                 |    5 +-
 arch/x86/include/asm/dma-mapping.h                |    2 -
 arch/x86/include/asm/dwarf2.h                     |   97 +-
 arch/x86/include/asm/emergency-restart.h          |    4 +-
 arch/x86/include/asm/es7000/apic.h                |   79 +-
 arch/x86/include/asm/es7000/wakecpu.h             |   41 +-
 arch/x86/include/asm/gart.h                       |   33 +
 arch/x86/include/asm/genapic_32.h                 |   19 +-
 arch/x86/include/asm/genapic_64.h                 |    2 +
 arch/x86/include/asm/hardirq_32.h                 |    2 +
 arch/x86/include/asm/hardirq_64.h                 |    2 +
 arch/x86/include/asm/hw_irq.h                     |    4 +-
 arch/x86/include/asm/hypervisor.h                 |   26 +
 arch/x86/include/asm/ia32.h                       |   18 -
 arch/x86/include/asm/idle.h                       |    5 +
 arch/x86/include/asm/io.h                         |   37 +-
 arch/x86/include/asm/io_64.h                      |    2 -
 arch/x86/include/asm/io_apic.h                    |   10 +
 arch/x86/include/asm/iommu.h                      |   33 -
 arch/x86/include/asm/irq.h                        |    4 -
 arch/x86/include/asm/irq_regs_32.h                |    2 +
 arch/x86/include/asm/kexec.h                      |   31 +-
 arch/x86/include/asm/linkage.h                    |   60 +
 arch/x86/include/asm/mach-default/mach_apic.h     |    2 +
 arch/x86/include/asm/mach-default/mach_wakecpu.h  |   24 +-
 arch/x86/include/asm/mach-default/smpboot_hooks.h |    8 +-
 arch/x86/include/asm/mach-generic/mach_apic.h     |    1 +
 arch/x86/include/asm/mach-generic/mach_wakecpu.h  |   12 +
 arch/x86/include/asm/mmu_context_32.h             |   13 +-
 arch/x86/include/asm/msr-index.h                  |    2 +
 arch/x86/include/asm/msr.h                        |   12 +-
 arch/x86/include/asm/numaq/wakecpu.h              |   24 +-
 arch/x86/include/asm/pci.h                        |    2 +
 arch/x86/include/asm/pgtable-2level.h             |   50 +-
 arch/x86/include/asm/pgtable-3level.h             |    1 +
 arch/x86/include/asm/pgtable.h                    |   28 +-
 arch/x86/include/asm/pgtable_32.h                 |    9 -
 arch/x86/include/asm/pgtable_64.h                 |   28 +-
 arch/x86/include/asm/prctl.h                      |    3 +
 arch/x86/include/asm/processor.h                  |    4 +
 arch/x86/include/asm/reboot.h                     |    5 +
 arch/x86/include/asm/setup.h                      |    7 +
 arch/x86/include/asm/sigframe.h                   |   70 ++
 arch/x86/include/asm/signal.h                     |    6 +-
 arch/x86/include/asm/sparsemem.h                  |    2 +-
 arch/x86/include/asm/syscalls.h                   |   16 +-
 arch/x86/include/asm/system.h                     |    6 +-
 arch/x86/include/asm/thread_info.h                |    2 +-
 arch/x86/include/asm/trampoline.h                 |    7 +
 arch/x86/include/asm/traps.h                      |   11 +-
 arch/x86/include/asm/tsc.h                        |    8 +-
 arch/x86/include/asm/uaccess.h                    |    4 +-
 arch/x86/include/asm/uv/bios.h                    |   34 +-
 arch/x86/include/asm/uv/uv_hub.h                  |  103 ++-
 arch/x86/include/asm/vmware.h                     |   27 +
 arch/x86/include/asm/xen/hypercall.h              |    6 +
 arch/x86/include/asm/xen/hypervisor.h             |   39 +-
 arch/x86/include/asm/xen/page.h                   |    5 +
 arch/x86/kernel/Makefile                          |    7 +-
 arch/x86/kernel/acpi/boot.c                       |   11 +
 arch/x86/kernel/amd_iommu.c                       |    1 +
 arch/x86/kernel/amd_iommu_init.c                  |    1 +
 arch/x86/kernel/aperture_64.c                     |    5 +-
 arch/x86/kernel/apic.c                            |  140 +--
 arch/x86/kernel/apm_32.c                          |    4 -
 arch/x86/kernel/asm-offsets_32.c                  |    2 +-
 arch/x86/kernel/asm-offsets_64.c                  |    4 +-
 arch/x86/kernel/bios_uv.c                         |   58 +-
 arch/x86/kernel/check.c                           |  161 +++
 arch/x86/kernel/cpu/Makefile                      |    1 +
 arch/x86/kernel/cpu/addon_cpuid_features.c        |    8 +
 arch/x86/kernel/cpu/amd.c                         |    9 +-
 arch/x86/kernel/cpu/common.c                      |    8 +-
 arch/x86/kernel/cpu/hypervisor.c                  |   58 +
 arch/x86/kernel/cpu/intel.c                       |   21 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c             |   17 +-
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c           |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c         |    2 +-
 arch/x86/kernel/cpu/mtrr/main.c                   |  346 +++---
 arch/x86/kernel/cpu/vmware.c                      |  112 ++
 arch/x86/kernel/crash.c                           |   70 +-
 arch/x86/kernel/ds.c                              |    9 +-
 arch/x86/kernel/dumpstack.c                       |  319 +++++
 arch/x86/kernel/dumpstack.h                       |   39 +
 arch/x86/kernel/dumpstack_32.c                    |  302 +-----
 arch/x86/kernel/dumpstack_64.c                    |  282 +-----
 arch/x86/kernel/e820.c                            |   16 -
 arch/x86/kernel/early-quirks.c                    |    1 +
 arch/x86/kernel/early_printk.c                    |   47 -
 arch/x86/kernel/entry_32.S                        |  477 ++++----
 arch/x86/kernel/entry_64.S                        | 1360 +++++++++++----------
 arch/x86/kernel/es7000_32.c                       |   62 +-
 arch/x86/kernel/genapic_64.c                      |    4 +
 arch/x86/kernel/genx2apic_uv_x.c                  |  111 ++-
 arch/x86/kernel/head.c                            |    1 -
 arch/x86/kernel/head32.c                          |    3 +
 arch/x86/kernel/head64.c                          |    3 +
 arch/x86/kernel/hpet.c                            |    4 +-
 arch/x86/kernel/init_task.c                       |    1 -
 arch/x86/kernel/io_apic.c                         |    3 +-
 arch/x86/kernel/irq_64.c                          |   24 +-
 arch/x86/kernel/irqinit_32.c                      |    2 +-
 arch/x86/kernel/irqinit_64.c                      |   66 -
 arch/x86/kernel/machine_kexec_32.c                |  104 ++-
 arch/x86/kernel/microcode_amd.c                   |  232 ++---
 arch/x86/kernel/microcode_core.c                  |    6 +-
 arch/x86/kernel/microcode_intel.c                 |    2 +-
 arch/x86/kernel/mpparse.c                         |   25 +-
 arch/x86/kernel/nmi.c                             |   58 +-
 arch/x86/kernel/numaq_32.c                        |   10 +-
 arch/x86/kernel/pci-dma.c                         |   11 +-
 arch/x86/kernel/process.c                         |   19 +-
 arch/x86/kernel/ptrace.c                          |    9 +-
 arch/x86/kernel/reboot.c                          |  126 ++-
 arch/x86/kernel/relocate_kernel_32.S              |  115 --
 arch/x86/kernel/setup.c                           |  169 +---
 arch/x86/kernel/sigframe.h                        |   42 -
 arch/x86/kernel/{signal_32.c => signal.c}         |  567 ++++++---
 arch/x86/kernel/signal_64.c                       |  516 --------
 arch/x86/kernel/smp.c                             |   31 +-
 arch/x86/kernel/smpboot.c                         |   23 +-
 arch/x86/kernel/time_32.c                         |    2 +-
 arch/x86/kernel/time_64.c                         |    6 +-
 arch/x86/kernel/tlb_32.c                          |   13 +-
 arch/x86/kernel/tlb_64.c                          |    2 +-
 arch/x86/kernel/tlb_uv.c                          |    4 -
 arch/x86/kernel/trampoline.c                      |   19 +-
 arch/x86/kernel/traps.c                           |   38 +-
 arch/x86/kernel/tsc.c                             |   42 +-
 arch/x86/kernel/tsc_sync.c                        |    8 +-
 arch/x86/kernel/vmi_32.c                          |  119 --
 arch/x86/kernel/vsyscall_64.c                     |    9 +
 arch/x86/lguest/boot.c                            |    3 +-
 arch/x86/mach-generic/bigsmp.c                    |    1 +
 arch/x86/mach-generic/default.c                   |    1 +
 arch/x86/mach-generic/es7000.c                    |   14 +-
 arch/x86/mach-generic/probe.c                     |   16 +-
 arch/x86/mach-generic/summit.c                    |    1 +
 arch/x86/mm/fault.c                               |   11 +-
 arch/x86/mm/init_32.c                             |   32 +-
 arch/x86/mm/init_64.c                             |    2 -
 arch/x86/mm/ioremap.c                             |    3 +-
 arch/x86/mm/pat.c                                 |  236 ++++
 arch/x86/pci/common.c                             |   17 +
 arch/x86/pci/direct.c                             |    4 +-
 arch/x86/pci/pci.h                                |    1 +
 arch/x86/xen/enlighten.c                          |   17 +-
 arch/x86/xen/mmu.c                                |   17 +-
 arch/x86/xen/multicalls.c                         |    2 +-
 arch/x86/xen/setup.c                              |    9 +-
 drivers/acpi/pci_irq.c                            |   56 +
 drivers/acpi/processor_idle.c                     |    6 +-
 drivers/firmware/dmi_scan.c                       |   11 +
 drivers/misc/sgi-gru/gruprocfs.c                  |    1 -
 drivers/misc/sgi-xp/xp.h                          |    7 +-
 drivers/misc/sgi-xp/xp_main.c                     |    7 +
 drivers/misc/sgi-xp/xp_sn2.c                      |   34 +
 drivers/misc/sgi-xp/xp_uv.c                       |   70 +-
 drivers/misc/sgi-xp/xpc.h                         |   12 +
 drivers/misc/sgi-xp/xpc_sn2.c                     |   15 +-
 drivers/misc/sgi-xp/xpc_uv.c                      |  290 ++++-
 drivers/pci/quirks.c                              |  170 +++-
 drivers/xen/balloon.c                             |    4 +-
 drivers/xen/features.c                            |    6 +-
 drivers/xen/grant-table.c                         |    1 +
 include/asm-generic/bug.h                         |    8 +
 include/asm-generic/pgtable.h                     |   50 +
 include/linux/dmi.h                               |    2 +
 include/linux/kexec.h                             |    4 +
 include/linux/linkage.h                           |    8 -
 include/linux/mm.h                                |   19 +
 include/linux/pci.h                               |    6 +
 include/linux/pci_ids.h                           |    5 +
 include/xen/interface/event_channel.h             |    2 +
 lib/bug.c                                         |   19 +-
 mm/memory.c                                       |   70 +-
 mm/swapfile.c                                     |    9 +
 197 files changed, 5182 insertions(+), 4125 deletions(-)
 create mode 100644 arch/x86/include/asm/hypervisor.h
 create mode 100644 arch/x86/include/asm/mach-generic/mach_wakecpu.h
 create mode 100644 arch/x86/include/asm/sigframe.h
 create mode 100644 arch/x86/include/asm/vmware.h
 create mode 100644 arch/x86/kernel/check.c
 create mode 100644 arch/x86/kernel/cpu/hypervisor.c
 create mode 100644 arch/x86/kernel/cpu/vmware.c
 create mode 100644 arch/x86/kernel/dumpstack.c
 create mode 100644 arch/x86/kernel/dumpstack.h
 delete mode 100644 arch/x86/kernel/sigframe.h
 rename arch/x86/kernel/{signal_32.c => signal.c} (73%)
 delete mode 100644 arch/x86/kernel/signal_64.c
