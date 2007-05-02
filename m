Return-Path: <linux-kernel-owner+w=401wt.eu-S1766878AbXEBRhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766878AbXEBRhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766890AbXEBRhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:37:33 -0400
Received: from ns2.suse.de ([195.135.220.15]:42406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766878AbXEBRh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:37:28 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: torvalds@osdl.org
Subject: Please pull x86 updates for .22
Date: Wed, 2 May 2007 19:37:17 +0200
User-Agent: KMail/1.9.6
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705021937.17141.ak@suse.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, 

Please pull from  

git://one.firstfloor.org/home/andi/git/linux-2.6 for-linus

There are a few changes in other architectures, that is mostly because
the 64bit relocatable patches code moved a few functions into architecture
dependent code. No real functional changes. Also a few more similar changes.

This is the first batch, there might be another later. I delayed
some features like vDSO or new x86 sched_clock().  Also Xen might come
later too: this patchkit has near all of the prepartionary work
needed for it, so it would then only add new xen-only code.

Adrian Bunk (6):
      i386: make struct vmi_ops static
      i386: workaround for a -Wmissing-prototypes warning
      x86-64: make simnow_init() static
      i386: vmi_pmd_clear() static
      x86: sys_ioperm() prototype cleanup
      x86: remove UNEXPECTED_IO_APIC()

Ahmed S. Darwish (1):
      i386: fix GDT's number of quadwords in comment

Andi Kleen (45):
      x86-64: Update defconfig
      i386: Update defconfig
      x86: Fix i386 and x86_64 fault information pollution
      x86-64: Some cleanup in time.c
      x86-64: Correct max number of CPUs in Kconfig
      i386: Support Oprofile for AMD Family 10 CPUs
      x86: Drop cc-options call for all options supported in gcc 3.2+
      x86-64: Don't disable basic block reordering
      x86-64: Allow sys_uselib unconditionally
      x86-64: Minor white space cleanup in traps.c
      i386: Use X86_EFLAGS_IF in irqflags.h.
      x86-64: Remove unused stext symbol
      x86-64: Change my email address
      i386: Remove unneeded externs in nmi.c
      x86-64: Use X86_EFLAGS_IF in x86-64/irqflags.h.
      x86-64: Fix vmalloc_32 to really allocate <4GB on 64bit platforms
      x86: Don't use MWAIT on AMD Family 10
      i386: Enable bank 0 on non K7 Athlon
      i386: PARAVIRT: Export paravirt_ops for non GPL modules too
      x86-64: Move mtrr prototypes from proto.h to mtrr.h
      x86-64: Auto compute __NR_syscall_max at compile time
      i386: fix wrong comment for syscall stack layout
      i386: Clean up NMI watchdog code
      x86-64: Use the 32bit wd_ops for 64bit too.
      x86-64: Define IGNORE_IOCTL() macro for compat_ioctls
      x86-64: Shut up 32bit emulation for SIOCGIFCOUNT
      x86-64: Use symbolic CPU features in early CPUID check
      x86-64: Drop -traditional for arch/x86_64/boot
      i386: Drop -traditional in arch/i386/boot
      i386: Verify important CPUID bits in real mode
      i386: Evaluate constant cpu features at runtime
      i386: Implement alternative_io for i386
      i386: Implement X86_FEATURE_SYNC_RDTSC on i386
      i386: Add X86_FEATURE_RDTSCP
      x86: Use RDTSCP for synchronous get_cycles if possible
      x86-64: Don't enable NUMA for a single node in K8 NUMA scanning
      i386: Little cleanups in smpboot.c
      i386: Remove copy_*_user BUG_ONs for (size < 0)
      x86-64: Print type and size correctly for unknown compat ioctls
      x86-64: Remove CONFIG_REORDER
      x86-64: Share identical video.S between i386 and x86-64
      x86-64: Shut up warnings for vfat compat ioctls on other file systems
      x86-64: Fix allnoconfig error in genapic_flat.c
      i386: Drop noisy e820 debugging printks
      x86-64: Don't exclude asm-offsets.c in Documentation/dontdiff

Andrew Morton (6):
      i386: revert i386-fix-the-verify_quirk_intel_irqbalance
      x86-64: revert x86_64-mm-add-genapic_force
      x86: revert x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525
      x86-64: fix x86_64-mm-sched-clock-share
      i386: VDSO_PRELINK warning fix
      x86-64: unexport cpu_llc_id

Aneesh Kumar K.V (1):
      i386: Update __copy_to_user_inatomic linuxdoc description

Avi Kivity (1):
      x86-64: fix arithmetic in comment

Bernhard Kaindl (4):
      x86: Adds mtrr_save_fixed_ranges() for use in two later patches.
      x86: Save the MTRRs of the BSP before booting an AP
      x86: Save and restore the fixed-range MTRRs of the BSP when suspending
      i386: Enable support for fixed-range IORRs to keep RdMem & WrMem in sync

Bernhard Walle (2):
      x86: add command line length to boot protocol
      x86-64: Fix "Section mismatch" compile warning

Bill Irwin (1):
      i386: Add missing !X86_PAE dependincy to the 2G/2G split.

Christoph Lameter (1):
      x86-64: use lru instead of page->index and page->private for pgd lists management.

Daniel Walker (1):
      i386: remove xtime_lock'ing around cpufreq notifier

David P. Reed (1):
      x86-64: Avoid overflows during apic timer calibration

David Rientjes (5):
      x86-64: configurable fake numa node sizes
      x86-64: split remaining fake nodes equally
      x86-64: fixed size remaining fake nodes
      x86-64: fake numa for cpusets document
      i386: type may be unused

Eric Dumazet (3):
      x86-64: fix vtime() vsyscall
      x86-64: vsyscall_gtod_data diet and vgettimeofday() fix
      x86-64: move __vgetcpu_mode & __jiffies to the vsyscall_2 zone

Eric W. Biederman (1):
      i386: convert to the kthread API

Fernando Luis VazquezCao (6):
      i386: safe_apic_wait_icr_idle - i386
      x86-64: safe_apic_wait_icr_idle - x86_64
      i386: use safe_apic_wait_icr_idle - i386
      x86-64: use safe_apic_wait_icr_idle in smpboot.c - x86_64
      i386: use safe_apic_wait_icr_idle in smpboot.c
      x86-64: use safe_apic_wait_icr_idle in smpboot.c - x86_64

Fernando Luis [** ISO-8859-1 charset **] VázquezCao (4):
      i386: __send_IPI_dest_field - i386
      x86-64: __send_IPI_dest_field - x86_64
      i386: Use safe_apic_wait_icr_idle in safe_apic_wait_icr_idle - i386
      x86-64: Use safe_apic_wait_icr_idle in __send_IPI_dest_field - x86_64

Gerd Hoffmann (1):
      x86-64: ignore vgacon if hardware not present

Glauber de Oliveira Costa (2):
      x86-64: Remove duplicated code for reading control registers
      x86-64: Fix x86_64 compilation with DEBUG_SIG on

H. Peter Anvin (1):
      x86: Clean up x86 control register and MSR macros (corrected)

Hisashi Hifumi (1):
      i386: replace spin_lock_irqsave with spin_lock

Ian Campbell (1):
      i386: Allow i386 crash kernels to handle x86_64 dumps

Ingo Molnar (4):
      x86-64: optimize & fix APIC mode setup
      x86-64: always use physical delivery mode on > 8 CPUs
      x86-64: remove clustered APIC mode
      x86: default to physical mode on hotplug CPU kernels

James Puthukattukaran (1):
      x86-64: x86-64 system crashes when no memory populating Node 0

Jan Beulich (11):
      i386: adjustments to page table dump during oops (v4)
      x86: adjust inclusion of asm/fixmap.h
      x86-64: adjust inclusion of asm/vsyscall32.h
      x86: consolidate smp_send_stop()
      i386: mtrr range check correction
      x86-64: a few missing entry.S annotations
      i386: Add dwarf2 annotations to *_user and checksum functions
      x86: Improve handling of kernel mappings in change_page_attr
      x86: tighten kernel image page access rights
      x86-64: adjust EDID retrieval
      x86: fix amd64-agp aperture validation

Jan Engelhardt (1):
      i386: Use menuconfig objects - APM

Jan Kiszka (2):
      i386: white space fixes in i387.h
      i386: avoid redundant preempt_disable in __unlazy_fpu

Jeremy Fitzhardinge (49):
      i386: No need to use -traditional for processing asm in i386/kernel/
      i386: clean up mach_reboot_fixups
      i386: Simplify smp_call_function*() by using common implementation
      i386: Add smp_ops interface
      i386: Add machine_ops interface to abstract halting and rebooting
      x86-64: Account for module percpu space separately from kernel percpu
      i386: Clean up asm-i386/bugs.h
      i386: clean up identify_cpu
      i386: Relocate VDSO ELF headers to match mapped location with COMPAT_VDSO
      i386: Make COMPAT_VDSO runtime selectable.
      x86-64: Clean up asm-x86_64/bugs.h
      i386: Update smp_call_function* comments
      x86: Allow percpu variables to be page-aligned
      i386: Remove smp_alt_instructions
      i386: Allow boot-time disable of SMP altinstructions
      x86-64: update MAINTAINERS
      i386: PARAVIRT: Remove CONFIG_DEBUG_PARAVIRT
      i386: PARAVIRT: use paravirt_nop to consistently mark no-op operations
      i386: PARAVIRT: Add pagetable accessors to pack and unpack pagetable entries
      i386: PARAVIRT: Hooks to set up initial pagetable
      i386: PARAVIRT: Allocate a fixmap slot
      i386: PARAVIRT: Allow paravirt backend to choose kernel PMD sharing
      x86: PARAVIRT: add hooks to intercept mm creation and destruction
      i386: PARAVIRT: rename struct paravirt_patch to paravirt_patch_site for clarity
      i386: PARAVIRT: Use patch site IDs computed from offset in paravirt_ops structure
      i386: PARAVIRT: Fix patch site clobbers to include return register
      i386: PARAVIRT: Consistently wrap paravirt ops callsites to make them patchable
      i386: PARAVIRT: Document asm-i386/paravirt.h
      i386: PARAVIRT: add common patching machinery
      i386: PARAVIRT: add flush_tlb_others paravirt_op
      i386: PARAVIRT: revert map_pt_hook.
      i386: PARAVIRT: add kmap_atomic_pte for mapping highpte pages
      i386: PARAVIRT: flush lazy mmu updates on kunmap_atomic
      i386: PARAVIRT: Use enums for paravirt lazy flush modi
      i386: PARAVIRT: Clean up paravirt patchable wrappers
      i386: PARAVIRT: drop unused ptep_get_and_clear
      x86: deflate stack usage in lib/inflate.c
      x86-64: deflate inflate_dynamic too
      i386: Page-align the GDT
      i386: Convert PDA into the percpu section
      i386: cleanups to help using per-cpu variables from asm
      i386: Define per_cpu_offset
      i386: Fix UP gdt bugs
      i386: map enough initial memory to create lowmem mappings
      x86: update for i386 and x86-64 check_bugs
      i386: PARAVIRT: Allow boot-time disable of paravirt_ops patching
      x86: PARAVIRT: Jeremy Fitzhardinge <jeremy@goop.org>
      i386: Clean up ELF note generation
      i386: PARAVIRT: fix startup_ipi_hook config dependency

Joachim Deguara (1):
      i386: check capability

Joerg Roedel (2):
      x86-64: fix cpu MHz reporting on constant_tsc cpus
      x86: remove constant_tsc reporting from /proc/cpuinfo' power flags

John Stultz (1):
      x86: Log reason why TSC was marked unstable

Ken Chen (1):
      i386: type cast clean up for find_next_zero_bit

Keshavamurthy, Anil S (2):
      i386: avoid checking for cpu gone when CONFIG_HOTPLUG_CPU not defined
      i386: clean up flush_tlb_others fn

Konrad Rzeszutek (1):
      x86-64: Inhibit machine from asserting an NMI when doing Alt-SysRq-M operation.

Lasse Collin (1):
      i386: Fix usage of -mtune when X86_GENERIC=y or CONFIG_MCORE2=y

Olivier Galibert (1):
      i386: Some additional chipset register values validation.

Parag Warudkar (2):
      i386: get rid of unused variables
      i386: remove the APM_RTC_IS_GMT config option.

Prarit Bhargava (2):
      i386: Add __init to probe_bigsmp
      i386: Change sysenter_setup to __cpuinit & improve __INIT, __INITDATA

Ralf Baechle (1):
      x86-64: fix ia32_binfmt.c build error

Randy Dunlap (1):
      i386: fix mtrr sections

Ravikiran G Thirumalai (1):
      x86-64: Set HASHDIST_DEFAULT to 1 for x86_64 NUMA

Rene Herman (1):
      i386: probe_roms() cleanup

Rusty Russell (9):
      x86-64: Remove unused set_seg_base
      i386: Initialize esp0 properly all the time
      x86-64: Introduce load_TLS to the "for" loop.
      i386: Use per-cpu variables for GDT, PDA
      i386: Use per-cpu GDT immediately upon boot
      i386: clean up cpu_init()
      i386: rationalize paravirt wrappers
      i386: cleanup GDT Access
      i386: i386 separate hardware-defined TSS from Linux additions

Sebastien Dugue (1):
      i386: Rename boot_gdt_table to boot_gdt

Siddha, Suresh B (1):
      x86-64: skip cache_free_alien() on non NUMA

Simon Arlott (1):
      i386: Add an option for the VIA C7 which sets appropriate L1 cache

Stephane Eranian (2):
      i386: i386 make NMI use PERFCTR1 for architectural perfmon (take 2)
      x86-64: x86_64 make NMI use PERFCTR1 for architectural perfmon (take 2)

Stephen Hemminger (1):
      x86-64: dma_ops as const

Suresh Siddha (1):
      x86-64: set node_possible_map at runtime - try 2

takada (1):
      i386: pit_latch_buggy has no effect

Thomas Renninger (1):
      i386: Don't delete cpu_devs data to identify different x86 types in late_initcall

Tim Hockin (1):
      x86-64: Dynamically adjust machine check interval

Vivek Goyal (22):
      x86-64: Assembly safe page.h and pgtable.h
      x86-64: Kill temp boot pmds
      x86-64: Clean up the early boot page table
      x86-64: Fix early printk to use standard ISA mapping
      x86-64: modify copy_bootdata to use virtual addresses
      x86-64: cleanup segments
      x86-64: Add EFER to the register set saved by save_processor_state
      x86-64: 64bit PIC SMP trampoline
      x86-64: Get rid of dead code in suspend resume
      x86-64: wakeup.S rename registers to reflect right names
      x86-64: wakeup.S misc cleanups
      x86-64: 64bit ACPI wakeup trampoline
      x86-64: Modify discover_ebda to use virtual addresses
      x86-64: Remove the identity mapping as early as possible
      x86: Move swsusp __pa() dependent code to arch portion
      x86-64: do not use virt_to_page on kernel data address
      x86: __pa and __pa_symbol address space separation
      x86-64: Relocatable Kernel Support
      x86-64: build-time checking
      x86-64: Extend bzImage protocol for relocatable bzImage
      x86-64: Move cpu verification code to common file
      i386: modpost apic related warning fixes

Yinghai Lu (1):
      x86-64: remove extra smp_processor_id calling

Zachary Amsden (8):
      i386: In compat mode, the return value here was uninitialized.
      i386: Clean up arch/i386/kernel/cpu/mcheck/p4.c
      i386: Now that the VDSO can be relocated, we can support it in VMI configurations.
      i386: Implement vmi_kmap_atomic_pte
      i386: Convert VMI timer to use clock events
      i386: pte clear optimization
      i386: pte xchg optimization
      i386: pte simplify ops

 CREDITS                                     |    5 +-
 Documentation/dontdiff                      |    4 +-
 Documentation/i386/boot.txt                 |   23 +-
 Documentation/kernel-parameters.txt         |   21 +-
 Documentation/x86_64/boot-options.txt       |   14 +-
 Documentation/x86_64/fake-numa-for-cpusets  |   66 +
 Documentation/x86_64/machinecheck           |    7 +-
 MAINTAINERS                                 |   24 +-
 Makefile                                    |    2 +-
 arch/alpha/boot/misc.c                      |    2 +-
 arch/alpha/kernel/vmlinux.lds.S             |    2 +-
 arch/arm/boot/compressed/misc.c             |    2 +-
 arch/arm/kernel/vmlinux.lds.S               |    2 +-
 arch/arm26/boot/compressed/misc.c           |    2 +-
 arch/cris/arch-v32/vmlinux.lds.S            |    1 +
 arch/frv/kernel/vmlinux.lds.S               |    1 +
 arch/i386/Kconfig                           |   38 +-
 arch/i386/Kconfig.cpu                       |   35 +-
 arch/i386/Kconfig.debug                     |   10 -
 arch/i386/Makefile                          |    2 +-
 arch/i386/Makefile.cpu                      |    9 +-
 arch/i386/boot/Makefile                     |    4 +-
 arch/i386/boot/compressed/misc.c            |    2 +-
 arch/i386/boot/setup.S                      |   24 +-
 arch/i386/defconfig                         |   73 +-
 arch/i386/kernel/Makefile                   |    4 +-
 arch/i386/kernel/acpi/boot.c                |    2 +-
 arch/i386/kernel/acpi/earlyquirk.c          |   21 -
 arch/i386/kernel/alternative.c              |  102 +-
 arch/i386/kernel/apic.c                     |   22 +
 arch/i386/kernel/apm.c                      |   10 +-
 arch/i386/kernel/asm-offsets.c              |   18 +-
 arch/i386/kernel/cpu/Makefile               |    4 +-
 arch/i386/kernel/cpu/amd.c                  |   15 +-
 arch/i386/kernel/cpu/bugs.c                 |  191 +++
 arch/i386/kernel/cpu/centaur.c              |   10 -
 arch/i386/kernel/cpu/common.c               |  217 +--
 arch/i386/kernel/cpu/cyrix.c                |   21 +-
 arch/i386/kernel/cpu/intel.c                |    4 +-
 arch/i386/kernel/cpu/mcheck/k7.c            |   13 +-
 arch/i386/kernel/cpu/mcheck/mce.c           |    3 +-
 arch/i386/kernel/cpu/mcheck/p4.c            |   16 +-
 arch/i386/kernel/cpu/mtrr/generic.c         |  101 +-
 arch/i386/kernel/cpu/mtrr/main.c            |   11 +
 arch/i386/kernel/cpu/nexgen.c               |   10 -
 arch/i386/kernel/cpu/perfctr-watchdog.c     |  658 +++++++++
 arch/i386/kernel/cpu/proc.c                 |    3 +-
 arch/i386/kernel/cpu/rise.c                 |    9 -
 arch/i386/kernel/cpu/transmeta.c            |   10 -
 arch/i386/kernel/cpu/umc.c                  |   10 -
 arch/i386/kernel/doublefault.c              |   29 +-
 arch/i386/kernel/e820.c                     |   64 +-
 arch/i386/kernel/efi.c                      |   16 +-
 arch/i386/kernel/entry.S                    |   23 +-
 arch/i386/kernel/head.S                     |  118 +--
 arch/i386/kernel/i386_ksyms.c               |    2 -
 arch/i386/kernel/io_apic.c                  |   38 +-
 arch/i386/kernel/ioport.c                   |    3 +-
 arch/i386/kernel/irq.c                      |    3 +
 arch/i386/kernel/mpparse.c                  |    2 +-
 arch/i386/kernel/nmi.c                      |  832 +----------
 arch/i386/kernel/paravirt.c                 |  522 ++-----
 arch/i386/kernel/process.c                  |   37 +-
 arch/i386/kernel/quirks.c                   |   69 +-
 arch/i386/kernel/reboot.c                   |   55 +-
 arch/i386/kernel/reboot_fixups.c            |    2 +-
 arch/i386/kernel/smp.c                      |  304 +++--
 arch/i386/kernel/smpboot.c                  |  146 +--
 arch/i386/kernel/sysenter.c                 |  269 +++-
 arch/i386/kernel/time.c                     |    2 -
 arch/i386/kernel/trampoline.S               |   12 +-
 arch/i386/kernel/traps.c                    |   32 +-
 arch/i386/kernel/tsc.c                      |   13 +-
 arch/i386/kernel/verify_cpu.S               |   65 +
 arch/i386/kernel/vmi.c                      |  131 +--
 arch/i386/kernel/vmiclock.c                 |  318 +++++
 arch/i386/kernel/vmitime.c                  |  482 -------
 arch/i386/kernel/vmlinux.lds.S              |   24 +-
 arch/i386/kernel/vsyscall.lds.S             |    4 +-
 arch/i386/lib/bitops.c                      |    4 +-
 arch/i386/lib/checksum.S                    |   69 +-
 arch/i386/lib/getuser.S                     |   26 +-
 arch/i386/lib/putuser.S                     |   39 +-
 arch/i386/lib/usercopy.c                    |    7 -
 arch/i386/mach-generic/bigsmp.c             |    2 +-
 arch/i386/mach-generic/es7000.c             |   41 +
 arch/i386/mach-voyager/voyager_smp.c        |   16 +-
 arch/i386/mm/fault.c                        |   60 +-
 arch/i386/mm/highmem.c                      |   10 +-
 arch/i386/mm/init.c                         |  196 ++-
 arch/i386/mm/pageattr.c                     |    6 +-
 arch/i386/mm/pgtable.c                      |   94 +-
 arch/i386/oprofile/nmi_int.c                |    4 +
 arch/i386/pci/init.c                        |    2 +-
 arch/i386/pci/mmconfig-shared.c             |   25 +-
 arch/i386/power/cpu.c                       |    1 +
 arch/i386/power/suspend.c                   |   14 +
 arch/m32r/kernel/vmlinux.lds.S              |    2 +-
 arch/mips/kernel/vmlinux.lds.S              |    2 +-
 arch/parisc/kernel/vmlinux.lds.S            |    2 +-
 arch/powerpc/kernel/Makefile                |    1 +
 arch/powerpc/kernel/setup_64.c              |    4 +-
 arch/powerpc/kernel/suspend.c               |   24 +
 arch/powerpc/kernel/vmlinux.lds.S           |    6 +-
 arch/ppc/kernel/vmlinux.lds.S               |    2 +-
 arch/s390/kernel/vmlinux.lds.S              |    2 +-
 arch/sh/kernel/vmlinux.lds.S                |    2 +-
 arch/sh64/kernel/vmlinux.lds.S              |    2 +-
 arch/sparc/kernel/vmlinux.lds.S             |    2 +-
 arch/sparc64/kernel/smp.c                   |    6 +-
 arch/um/defconfig                           |    1 +
 arch/x86_64/Kconfig                         |   61 +-
 arch/x86_64/Makefile                        |    4 -
 arch/x86_64/boot/Makefile                   |    2 +-
 arch/x86_64/boot/compressed/Makefile        |   12 +-
 arch/x86_64/boot/compressed/head.S          |  339 ++++--
 arch/x86_64/boot/compressed/misc.c          |  247 ++--
 arch/x86_64/boot/compressed/vmlinux.lds     |   44 +
 arch/x86_64/boot/compressed/vmlinux.scr     |    9 +-
 arch/x86_64/boot/setup.S                    |   85 +-
 arch/x86_64/boot/video.S                    | 2043 ---------------------------
 arch/x86_64/defconfig                       |  183 +--
 arch/x86_64/ia32/ia32_binfmt.c              |   10 +-
 arch/x86_64/ia32/ia32entry.S                |    4 -
 arch/x86_64/ia32/syscall32.c                |    1 +
 arch/x86_64/kernel/Makefile                 |    7 +-
 arch/x86_64/kernel/acpi/sleep.c             |   24 +-
 arch/x86_64/kernel/acpi/wakeup.S            |  286 ++---
 arch/x86_64/kernel/aperture.c               |    5 +-
 arch/x86_64/kernel/apic.c                   |   35 +-
 arch/x86_64/kernel/asm-offsets.c            |   10 +
 arch/x86_64/kernel/bugs.c                   |   21 +
 arch/x86_64/kernel/e820.c                   |    5 +-
 arch/x86_64/kernel/early-quirks.c           |   13 -
 arch/x86_64/kernel/early_printk.c           |    5 +-
 arch/x86_64/kernel/entry.S                  |    5 +
 arch/x86_64/kernel/functionlist             | 1284 -----------------
 arch/x86_64/kernel/genapic.c                |  104 +--
 arch/x86_64/kernel/genapic_cluster.c        |  137 --
 arch/x86_64/kernel/genapic_flat.c           |   25 +-
 arch/x86_64/kernel/head.S                   |  340 +++---
 arch/x86_64/kernel/head64.c                 |   41 +-
 arch/x86_64/kernel/io_apic.c                |   31 +-
 arch/x86_64/kernel/ioport.c                 |    1 +
 arch/x86_64/kernel/machine_kexec.c          |   14 +-
 arch/x86_64/kernel/mce.c                    |   32 +-
 arch/x86_64/kernel/mpparse.c                |    2 +-
 arch/x86_64/kernel/nmi.c                    |  678 +---------
 arch/x86_64/kernel/pci-calgary.c            |    2 +-
 arch/x86_64/kernel/pci-gart.c               |    2 +-
 arch/x86_64/kernel/pci-nommu.c              |    2 +-
 arch/x86_64/kernel/pci-swiotlb.c            |    2 +-
 arch/x86_64/kernel/process.c                |   12 +-
 arch/x86_64/kernel/setup.c                  |   35 +-
 arch/x86_64/kernel/setup64.c                |    5 +-
 arch/x86_64/kernel/signal.c                 |    6 +-
 arch/x86_64/kernel/smp.c                    |   30 +-
 arch/x86_64/kernel/smpboot.c                |   47 +-
 arch/x86_64/kernel/suspend.c                |   19 +-
 arch/x86_64/kernel/suspend_asm.S            |    7 +-
 arch/x86_64/kernel/syscall.c                |    1 +
 arch/x86_64/kernel/time.c                   |   71 +-
 arch/x86_64/kernel/trampoline.S             |  123 ++-
 arch/x86_64/kernel/traps.c                  |   34 +-
 arch/x86_64/kernel/tsc.c                    |   17 +-
 arch/x86_64/kernel/tsc_sync.c               |    4 +-
 arch/x86_64/kernel/verify_cpu.S             |  119 ++
 arch/x86_64/kernel/vmlinux.lds.S            |   20 +-
 arch/x86_64/kernel/vsyscall.c               |   68 +-
 arch/x86_64/mm/fault.c                      |    5 +-
 arch/x86_64/mm/init.c                       |  172 +--
 arch/x86_64/mm/k8topology.c                 |    9 +-
 arch/x86_64/mm/numa.c                       |  306 +++--
 arch/x86_64/mm/pageattr.c                   |   32 +-
 arch/x86_64/mm/srat.c                       |    8 +-
 arch/xtensa/kernel/vmlinux.lds.S            |    2 +-
 drivers/acpi/processor_idle.c               |    4 +-
 drivers/char/agp/amd64-agp.c                |   13 +-
 drivers/video/console/vgacon.c              |    3 +-
 fs/compat.c                                 |    5 +-
 fs/compat_ioctl.c                           |   19 +
 fs/proc/vmcore.c                            |    2 +-
 include/asm-alpha/mmu_context.h             |    1 +
 include/asm-alpha/percpu.h                  |   14 -
 include/asm-arm/mmu_context.h               |    1 +
 include/asm-arm26/mmu_context.h             |    2 +
 include/asm-avr32/mmu_context.h             |    1 +
 include/asm-cris/mmu_context.h              |    2 +
 include/asm-frv/mmu_context.h               |    1 +
 include/asm-generic/mm_hooks.h              |   18 +
 include/asm-generic/percpu.h                |    1 +
 include/asm-generic/vmlinux.lds.h           |    2 +-
 include/asm-h8300/mmu_context.h             |    1 +
 include/asm-i386/Kbuild                     |    2 +
 include/asm-i386/alternative.h              |   34 +-
 include/asm-i386/apic.h                     |    9 +-
 include/asm-i386/bugs.h                     |  194 +---
 include/asm-i386/cpufeature.h               |   13 +-
 include/asm-i386/current.h                  |    5 +-
 include/asm-i386/desc.h                     |   95 +-
 include/asm-i386/e820.h                     |    1 +
 include/asm-i386/elf.h                      |   28 +-
 include/asm-i386/fixmap.h                   |   11 +-
 include/asm-i386/genapic.h                  |    6 +-
 include/asm-i386/highmem.h                  |    6 +
 include/asm-i386/hpet.h                     |    2 -
 include/asm-i386/i387.h                     |   17 +-
 include/asm-i386/io.h                       |   15 +-
 include/asm-i386/irq.h                      |    2 -
 include/asm-i386/irq_regs.h                 |   12 +-
 include/asm-i386/irqflags.h                 |   64 +-
 include/asm-i386/kexec.h                    |    8 +-
 include/asm-i386/mach-bigsmp/mach_apic.h    |    2 +-
 include/asm-i386/mach-default/mach_apic.h   |    2 +-
 include/asm-i386/mach-es7000/mach_apic.h    |    9 +-
 include/asm-i386/mach-es7000/mach_mpparse.h |   32 -
 include/asm-i386/mach-generic/mach_apic.h   |    2 +-
 include/asm-i386/mach-numaq/mach_apic.h     |    2 +-
 include/asm-i386/mach-summit/mach_apic.h    |    2 +-
 include/asm-i386/mach-summit/mach_mpparse.h |    4 +-
 include/asm-i386/mach-visws/mach_apic.h     |    2 +-
 include/asm-i386/mmu_context.h              |   17 +-
 include/asm-i386/module.h                   |    2 +
 include/asm-i386/msr-index.h                |  278 ++++
 include/asm-i386/msr.h                      |  400 ++----
 include/asm-i386/mtrr.h                     |    4 +
 include/asm-i386/nmi.h                      |    8 +
 include/asm-i386/page.h                     |   81 +-
 include/asm-i386/paravirt.h                 |  957 ++++++++++---
 include/asm-i386/pda.h                      |  100 --
 include/asm-i386/percpu.h                   |  136 ++-
 include/asm-i386/pgalloc.h                  |    1 -
 include/asm-i386/pgtable-2level-defs.h      |    2 +
 include/asm-i386/pgtable-2level.h           |   37 +-
 include/asm-i386/pgtable-3level-defs.h      |    6 +
 include/asm-i386/pgtable-3level.h           |   69 +-
 include/asm-i386/pgtable.h                  |   62 +-
 include/asm-i386/processor-flags.h          |   91 ++
 include/asm-i386/processor.h                |  187 ++--
 include/asm-i386/reboot.h                   |   20 +
 include/asm-i386/reboot_fixups.h            |    6 +
 include/asm-i386/required-features.h        |   34 +
 include/asm-i386/segment.h                  |   10 +-
 include/asm-i386/smp.h                      |   64 +-
 include/asm-i386/system.h                   |  139 ++-
 include/asm-i386/timer.h                    |    2 -
 include/asm-i386/tlbflush.h                 |   19 +-
 include/asm-i386/tsc.h                      |   15 +-
 include/asm-i386/uaccess.h                  |   14 +-
 include/asm-i386/vmi_time.h                 |   18 +-
 include/asm-ia64/mmu_context.h              |    1 +
 include/asm-m32r/mmu_context.h              |    1 +
 include/asm-m68k/mmu_context.h              |    1 +
 include/asm-m68knommu/mmu_context.h         |    1 +
 include/asm-mips/mmu_context.h              |    1 +
 include/asm-parisc/mmu_context.h            |    1 +
 include/asm-powerpc/mmu_context.h           |    1 +
 include/asm-ppc/mmu_context.h               |    1 +
 include/asm-s390/mmu_context.h              |    2 +
 include/asm-sh/mmu_context.h                |    1 +
 include/asm-sh64/mmu_context.h              |    2 +-
 include/asm-sparc/mmu_context.h             |    2 +
 include/asm-sparc64/mmu_context.h           |    1 +
 include/asm-sparc64/percpu.h                |   10 -
 include/asm-um/mmu_context.h                |    2 +
 include/asm-v850/mmu_context.h              |    2 +
 include/asm-x86_64/Kbuild                   |    4 +-
 include/asm-x86_64/alternative.h            |    5 +-
 include/asm-x86_64/apic.h                   |   10 +-
 include/asm-x86_64/bugs.h                   |   30 +-
 include/asm-x86_64/const.h                  |   20 +
 include/asm-x86_64/desc.h                   |   21 +-
 include/asm-x86_64/dma-mapping.h            |    2 +-
 include/asm-x86_64/fixmap.h                 |    1 -
 include/asm-x86_64/genapic.h                |    4 +-
 include/asm-x86_64/ipi.h                    |   61 +-
 include/asm-x86_64/irqflags.h               |    9 +-
 include/asm-x86_64/mmu_context.h            |    1 +
 include/asm-x86_64/mmzone.h                 |    2 +-
 include/asm-x86_64/msr-index.h              |    1 +
 include/asm-x86_64/msr.h                    |  274 +----
 include/asm-x86_64/mtrr.h                   |   12 +
 include/asm-x86_64/nmi.h                    |    9 +
 include/asm-x86_64/page.h                   |   39 +-
 include/asm-x86_64/percpu.h                 |   10 -
 include/asm-x86_64/pgalloc.h                |   15 +-
 include/asm-x86_64/pgtable.h                |   42 +-
 include/asm-x86_64/processor-flags.h        |    1 +
 include/asm-x86_64/processor.h              |   55 +-
 include/asm-x86_64/proto.h                  |   15 +-
 include/asm-x86_64/segment.h                |    2 +-
 include/asm-x86_64/smp.h                    |    4 +-
 include/asm-x86_64/suspend.h                |   13 +-
 include/asm-x86_64/system.h                 |    7 +-
 include/asm-x86_64/timex.h                  |    2 +-
 include/asm-x86_64/tlbflush.h               |   33 +-
 include/asm-x86_64/unistd.h                 |    3 -
 include/asm-xtensa/mmu_context.h            |    1 +
 include/linux/bootmem.h                     |    4 +-
 include/linux/cpufreq.h                     |   19 +-
 include/linux/crash_dump.h                  |    8 +
 include/linux/elf.h                         |   17 +
 include/linux/elfnote.h                     |    4 +-
 include/linux/highmem.h                     |    6 +
 include/linux/init.h                        |    7 +-
 include/linux/percpu.h                      |    9 +-
 include/linux/poison.h                      |    3 -
 include/linux/reboot_fixups.h               |   10 -
 init/main.c                                 |    8 +-
 kernel/fork.c                               |    2 +
 kernel/module.c                             |   10 +-
 kernel/power/power.h                        |    5 +-
 kernel/power/snapshot.c                     |   11 -
 kernel/power/swap.c                         |   42 +-
 lib/inflate.c                               |  129 ++-
 mm/highmem.c                                |    9 +
 mm/mmap.c                                   |    4 +
 mm/slab.c                                   |    7 +-
 mm/vmalloc.c                                |   14 +-
 scripts/mod/modpost.c                       |    1 +
 320 files changed, 7571 insertions(+), 10406 deletions(-)
 create mode 100644 Documentation/x86_64/fake-numa-for-cpusets
 create mode 100644 arch/i386/kernel/cpu/bugs.c
 create mode 100644 arch/i386/kernel/cpu/perfctr-watchdog.c
 create mode 100644 arch/i386/kernel/verify_cpu.S
 create mode 100644 arch/i386/kernel/vmiclock.c
 delete mode 100644 arch/i386/kernel/vmitime.c
 create mode 100644 arch/powerpc/kernel/suspend.c
 create mode 100644 arch/x86_64/boot/compressed/vmlinux.lds
 delete mode 100644 arch/x86_64/boot/video.S
 create mode 100644 arch/x86_64/kernel/bugs.c
 delete mode 100644 arch/x86_64/kernel/functionlist
 delete mode 100644 arch/x86_64/kernel/genapic_cluster.c
 create mode 100644 arch/x86_64/kernel/verify_cpu.S
 create mode 100644 include/asm-generic/mm_hooks.h
 create mode 100644 include/asm-i386/msr-index.h
 delete mode 100644 include/asm-i386/pda.h
 create mode 100644 include/asm-i386/processor-flags.h
 create mode 100644 include/asm-i386/reboot.h
 create mode 100644 include/asm-i386/reboot_fixups.h
 create mode 100644 include/asm-i386/required-features.h
 create mode 100644 include/asm-x86_64/const.h
 create mode 100644 include/asm-x86_64/msr-index.h
 create mode 100644 include/asm-x86_64/processor-flags.h
 delete mode 100644 include/linux/reboot_fixups.h
