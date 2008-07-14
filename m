Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbYGNNvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbYGNNvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 09:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYGNNvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 09:51:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57367 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbYGNNvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 09:51:01 -0400
Date: Mon, 14 Jul 2008 15:50:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] x86 changes for v2.6.27
Message-ID: <20080714135034.GA7013@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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

Please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/for-linus

this is our first merge window since we migrated over to a pure Git 
based patch management setup and integrated x86.git into the -tip tree. 
Going from Quilt to Git was quite hard for this 
1000-patches-per-kernel-cycle tree, so please bear with us :-)

42 individual x86 topic trees arose in the past development cycle:

 x86/amd-iommu, x86/apic, x86/apm, x86/bitops, x86/build, x86/cleanups,
 x86/core, x86/cpa, x86/cpu, x86/debug, x86/defconfig, x86/delay,
 x86/fixmap, x86/gart, x86/generalize-visws, x86/i8259, x86/idle, x86/intel,
 x86/irq, x86/irqstats, x86/kconfig, x86/ldt, x86/mce, x86/memtest, x86/mmio,
 x86/mpparse, x86/nmi, x86/numa, x86/numa-fixes, x86/oprofile, x86/pat,
 x86/ptemask, x86/ptrace, x86/resumetrace, x86/setup, x86/threadinfo,
 x86/timers, x86/unify-lib, x86/unify-pci, x86/uv, x86/vdso, x86/xen.

.. carrying a total of 820 (non-git-merge) commits from 70 authors.

[ There is one non-x86 topic that was merged into x86/core:
  tip/sysfs/firmware. This is a two-commit feature acked by Greg which had
  dependencies to the e820 changes in x86/core. ]

We hoped to be able to send pull requests for all the topics separately 
but near the end of the cycle most of the topics were merged together to 
reduce conflicts. We expect this to be different in the next merge 
window - topics should be able to survive up to the merge window, and be 
mergable in isolation.

Of the 42 topics, 15 have out-of-topic impact, covering 41 commits. All 
but 4 of those 41 commits are in linux-next. (those 4 commits are simply 
fresh and will be in the next iteration of linux-next)

Here's a (semi-)automated output of which topic created what type of 
generic impact:

out-of-topic modifications in x86/xen:
--------------------------------------
drivers/lguest/lg.h                # a15af1c: x86/paravirt: add pte_flags to ju
include/asm-generic/pgtable.h      # 1ea0704: mm: add a ptep_modify_prot transa
include/linux/console.h            # 9e124fe: xen: Enable console tty by defaul
include/linux/page-flags.h         # 0e91398: xen: implement save/restore
kernel/printk.c                    # 9e124fe: xen: Enable console tty by defaul
                                   # a29d1cf: printk: export console_drivers
mm/mprotect.c                      # 1ea0704: mm: add a ptep_modify_prot transa


out-of-topic modifications in x86/resumetrace:
----------------------------------------------
drivers/base/power/trace.c         # 63687a5: x86: move tracedata to RODATA
include/asm-generic/vmlinux.lds.h  # 63687a5: x86: move tracedata to RODATA
include/linux/resume-trace.h       # 63687a5: x86: move tracedata to RODATA


out-of-topic modifications in x86/irqstats:
-------------------------------------------
fs/proc/proc_misc.c                # a2eddfa: x86: make /proc/stat account for 


out-of-topic modifications in x86/gart:
---------------------------------------
drivers/char/agp/amd64-agp.c       # 0abbc78: x86, aperture_64: use symbolic co
                                   # 3bb6fbf: x86 gart: factor out common code
                                   # 8c9fd91: x86: checking aperture size order
                                   # 1edc1ab: x86: agp_gart size checking for b
                                   # aa134f1: x86: iommu: use symbolic constant

out-of-topic modifications in x86/cpu:
--------------------------------------
kernel/time/tick-broadcast.c       # aa276e1: x86, clockevents: add C1E aware i


out-of-topic modifications in x86/cpa:
--------------------------------------
fs/proc/proc_misc.c                # ce0c0e5: x86, generic: CPA add statistics 


out-of-topic modifications in x86/amd-iommu:
--------------------------------------------
MAINTAINERS                        # 919ee7d: x86, AMD IOMMU: add MAINTAINERS e


out-of-topic modifications in x86/delay:
----------------------------------------
include/linux/delay.h              # f3f3149: x86: use cpu_khz for loops_per_ji
                                   # 3da757d: x86: use cpu_khz for loops_per_ji
init/calibrate.c                   # f3f3149: x86: use cpu_khz for loops_per_ji
                                   # 3da757d: x86: use cpu_khz for loops_per_ji


out-of-topic modifications in x86/irq:
--------------------------------------
include/linux/kernel_stat.h        # 6859a84: x86: resize NR_IRQS for large mac


out-of-topic modifications in x86/mpparse:
------------------------------------------
drivers/acpi/Kconfig               # d49c428: x86: make generic arch support NU
drivers/firmware/dmi_scan.c        # cb5dd7c: x86 boot: add header comment to d
include/linux/acpi.h               # 3c999f1: x86: check command line when CONF
include/linux/bootmem.h            # d2dbf34: x86: clean up reserve_bootmem_gen include/linux/mm.h                 # b5bc6c0: x86, mm: use add_highpages_with_a
                                   # cc1050b: x86: replace shrink_active_range(
                                   # cc1a9d8: mm, x86: shrink_active_range() sh
include/linux/pageblock-flags.h    # c801ed3: x86 boot: simplify pageblock_bits
mm/page_alloc.c                    # b5bc6c0: x86, mm: use add_highpages_with_a
                                   # cc1050b: x86: replace shrink_active_range(
                                   # cc1a9d8: mm, x86: shrink_active_range() sh
                                   # e8c27ac: x86, numa, 32-bit: print out debu


out-of-topic modifications in x86/numa:
---------------------------------------
drivers/base/topology.c            # 23ca4bb: x86: cleanup early per cpu variab
include/linux/mm.h                 # 3461b0a: x86: remove static boot_cpu_pda a
kernel/sched.c                     # 076ac2a: sched, numa: replace MAX_NUMNODES


out-of-topic modifications in x86/uv:
-------------------------------------
include/linux/kernel_stat.h        # 6859a84: x86: resize NR_IRQS for large mac


out-of-topic modifications in x86/generalize-visws:
---------------------------------------------------
drivers/acpi/Kconfig               # 15e551d: x86, VisWS: turn into generic arc
drivers/lguest/Kconfig             # 15e551d: x86, VisWS: turn into generic arc
drivers/video/sgivwfb.c            # efd746b: x86, VisWS: turn into generic arc
sound/oss/vwsnd.c                  # 8a55a00: x86, VisWS: turn into generic arc


out-of-topic modifications in sysfs/firmware-mmap [acked by Greg]:
------------------------------------------------------------------
drivers/firmware/Kconfig           # 69ac9cd: sysfs: add /sys/firmware/memmap
drivers/firmware/Makefile          # 69ac9cd: sysfs: add /sys/firmware/memmap
drivers/firmware/memmap.c          # 69ac9cd: sysfs: add /sys/firmware/memmap
include/linux/firmware-map.h       # 69ac9cd: sysfs: add /sys/firmware/memmap


out-of-topic modifications in x86/core:
---------------------------------------
fs/Kconfig                         # 383bc5c: x86, crashdump, /proc/vmcore: rem
include/asm-generic/topology.h     # 11369f3: x86: change _node_to_cpumask_ptr
include/linux/linkage.h            # a7bf0bd: build: add __page_aligned_data an
include/linux/mm.h                 # d52d53b: RFC x86: try to remove arch_get_r
mm/page_alloc.c                    # 5dab8ec: mm, generic, x86 boot: more tweak
                                   # 2bc0d26: x86 boot: more consistently use t
                                   # e2fc252: x86 boot: show pfn addresses in h
                                   # d52d53b: RFC x86: try to remove arch_get_r

Find the full shortlog and diffstat below.

Thanks,

	Ingo

------------------>
Adrian Bunk (2):
      x86: kernel/pci-dma.c cleanups
      xen: drivers/xen/balloon.c: make a function static

Alan Cox (1):
      x86: Switch apm to unlocked_kernel

Alan Mayer (3):
      x86: resize NR_IRQS for large machines
      x86: change FIRST_SYSTEM_VECTOR to a variable
      x86: change FIRST_SYSTEM_VECTOR to a variable, fix

Alexander van Heukelum (8):
      x86: move i386 memory setup code to e820_32.c
      x86: initial changes to unify traps_32.c and traps_64.c
      x86: traps_xx: shuffle headers and globals
      x86: traps_xx: modify __die
      x86: traps_xx: modify do_trap
      x86: traps_xx: restructure do_general_protection()
      x86: traps_xx: modify default_do_nmi
      x86: traps_xx: various small changes

Alexey Starikovskiy (12):
      x86: move es7000_plat out of mpparse.c
      x86: complete move ACPI from mpparse.c
      x86: make mp_ioapic_routing definition local
      x86: make struct config_ioapic not MPspec specific
      x86: make config_irqsrc not MPspec specific
      x86: fix mpparse/acpi interaction
      x86: Set pic_mode only if local apic code is present
      x86: move pic_mode to apic_32.c
      x86: move smp_found_config
      x86: mp_bus_id_to_pci_bus is not needed
      x86: move mp_bus_not_pci from mpparse.c
      x86: allow MPPARSE to be deselected in SMP configs

Alok Kataria (9):
      x86: use cpu_khz for loops_per_jiffy calculation
      x86: use cpu_khz for loops_per_jiffy calculation, cleanup
      x86: cleanup e820_setup_gap(), add e820_search_gap(), v2
      x86: cleanup e820_setup_gap(), v2
      x86: merge sched_clock handling
      x86: merge tsc calibration
      x86: merge the TSC cpu-freq code
      x86: merge tsc_init and clocksource code
      x86: rename paravirtualized TSC functions

Andi Kleen (2):
      i386: Execute stack overflow warning on interrupt stack v2
      x86, generic: CPA add statistics about state of direct mapping v4

Andreas Herrmann (14):
      x86: enable hpet=force for AMD SB400
      x86: fix compile warning in io_apic_{32,64}.c
      x86: unconditionally enable PAT for AMD CPUs
      x86: PAT: fix ambiguous paranoia check in pat_init()
      x86: PAT: fixed checkpatch errors (and whitespaces)
      x86: rename pat_wc_enabled to pat_enabled
      x86: shrink pat_x_mtrr_type to its essentials
      x86: introduce macro to check whether an address range is in the ISA range
      x86: pat.c choose more crisp variable names
      x86: pat.c more trivial changes
      x86: pat.c consolidate error/debug messages in reserve_memtype
      x86: pat.c consolidate list_add handling in reserve_memtype
      x86: pat.c introduce function to check for conflicts with existing memtypes
      x86: pat.c final cleanup of loop body in reserve_memtype

Andrew Morton (5):
      arch/x86/mm/pat.c: use boot_cpu_has()
      x86: bitops take an unsigned long *
      x86: setup_force_cpu_cap(): don't do clear_bit(non-unsigned-long)
      arch/x86/kernel/smpboot.c: fix warning
      arch/x86/mm/pgtable_32.c: remove unused variable `fixmaps'

Andy Whitcroft (2):
      x86: reinstate numa remap for SPARSEMEM on x86 NUMA systems
      x86: cope with no remap space being allocated for a numa node

Auke Kok (1):
      e1000e: set CONFIG_E1000E=y in x86 defconfigs

Ben Castricum (1):
      x86: microcode: cosmetic changes

Ben Collins (1):
      x86: config option to disable info from decompression of the kernel

Bernhard Walle (11):
      x86: add flags parameter to reserve_bootmem_generic()
      x86: use reserve_bootmem_generic() to reserve crashkernel memory on x86_64
      x86: add flags parameter to reserve_bootmem_generic()
      x86: use reserve_bootmem_generic() to reserve crashkernel memory on x86_64
      x86: unify crashkernel reservation for 32 and 64 bit
      x86, crashdump, /proc/vmcore: remove CONFIG_EXPERIMENTAL from kdump
      x86: limit E820 map when a user-defined memory map is specified
      x86: find offset for crashkernel reservation automatically
      x86: fix documentation bug about relocatability
      sysfs: add /sys/firmware/memmap
      x86: use FIRMWARE_MEMMAP on x86/E820

Carlos R. Mafra (1):
      x86: clean up computation of HPET .mult variables

Christoph Lameter (10):
      x86: merge thread_info.h
      x86: threadinfo: common include files
      x86: threadinfo: merge thread sync state definitions
      x86: common thread_info definitions
      x86: threadinfo: merge INIT_THREAD_INFO
      x86: thread_info: PREEMPT_ACTIVE
      x86: thread_info: merge TIF_ flags.
      x86: thread_info: merge tif masks
      x86: thread_info: merge thread_info allocation
      x86: unify current.h

Christophe Jaillet (1):
      x86, arch/x86/kernel/io_apic_32.c: use kzalloc instead of kmalloc/memset

Cliff Wickman (5):
      x86, SGI UV: TLB shootdown using broadcast assist unit
      x86 atomic operations: atomic_or_long() atomic_inc_short()
      SGI UV: TLB shootdown using broadcast assist unit, cleanups
      x86, SGI UV: TLB shootdown using broadcast assist unit, v6
      x86, SGI UV: uv_ptc_proc_write fix

Cyrill Gorcunov (32):
      x86: 64-bit defconfig remake
      x86 - hide X86_VM_MASK from userland programs v3
      x86: head_64.S cleanup - use predefined flags from processor-flags.h
      x86: compressed/head_64.S cleanup - use predefined flags from processor-flags.h
      x86: head_64.S cleanup - use straight move to CR4 register
      x86: head_64.S cleanup - use PMD_SHIFT instead of numeric constant
      x86: nmi - unify die_nmi() interface
      x86: nmi - die_nmi() output message unification
      x86: move do_nmi(), stop_nmi() and restart_nmi() to traps_64.c
      x86: nmi_32.c - add "panic" option
      x86: nmi_32.c - add nmi_watchdog_default helper
      x86: nmi_32/64.c - use apic_write_around instead of apic_write
      x86: nmi_32.c - unknown_nmi_panic_callback should always panic
      x86: nmi_64.c - use for_each_possible_cpu helper
      x86: nmi_32.c cleanup - use for_each_online_cpu helper
      x86: nmi_32/64.c - add helper functions to hide arch specific data
      x86: nmi_32/64.c - merge down nmi_32.c and nmi_64.c to nmi.c
      x86: nmi - fix incorrect NMI watchdog used by default
      x86: nmi - consolidate nmi_watchdog_default for 32bit mode
      x86: watchdog - check for CPU is being supported
      x86: touch_nmi_watchdog(): reset alert counters for supported nmi_watchdog modes only
      x86: IO-APIC - use NMI_NONE instead of numeric constant
      x86, io-apic: define names for redirection table entry fields
      x86, io-apic: use predefined names instead of numeric constants
      x86: perfctr-watchdog.c - coding style cleanup
      x86: nmi_watchdog - use nmi_watchdog variable for printing
      x86: nmi_watchdog - remove useless check
      x86: nmi_watchdog - use NMI_NONE by default
      x86: nmi_watchdog - introduce nmi_watchdog_active() helper
      x86: nmi_watchdog - documentation fix
      x86: apic_32.c - add lapic resource
      x86: e820 memmap - add checking for NULL early param

Daniel Rahn (1):
      x86: correctly report NR_BANKS in mce_64.c

Dave Jones (7):
      x86: add new cache descriptor
      x86: Add Centaur and Transmeta CPUs to PAT whitelist
      x86: Fix up silly i1586 boot message.
      x86: Move the AMD64 specific parts out of setup_64.c
      x86: Move the 64-bit Intel specific parts out of setup_64.c
      x86: Remove workaround for prescott (32bit P4) from 64-bit code.
      x86: Move the 64-bit Centaur specific parts out of setup_64.c

Dimitri Sivanich (1):
      x86, uv: update x86 mmr list for SGI uv

Eduardo Habkost (3):
      x86, 64-bit: use __pgd() on mk_kernel_pgd()
      paravirt/x86, 64-bit: move __PAGE_OFFSET to leave a space for hypervisor
      x86, 64-bit: split set_pte_vaddr()

FUJITA Tomonori (5):
      x86 gart: remove unnecessary set_bit_string
      x86: clean up amd_iommu documentation
      x86, iommu: replace CONFIG_IOMMU with CONFIG_GART_IOMMU in iommu.h
      x86: clean up iommu.h and gart.h
      x86, AMD IOMMU: clean up Kconfig entry

Fernando Luis Vazquez Cao (2):
      x86: cleanup, remove duplicate declaration of unknown_nmi_panic
      x86: remove duplicate declaration of unknown_nmi_panic

Glauber Costa (61):
      x86: fix typo CONFIX -> CONFIG
      x86: use stack_start in x86_64
      x86: don't use gdt_page openly.
      x86: move x86_64 gdt closer to i386
      x86: use initial_code for i386
      x86: boot secondary cpus through initial_code
      x86: clearing io_apic harmless for x86_64
      x86: remove ifdef from stepping
      x86: change __setup_vector_irq with setup_vector_irq
      x86: provide connect_bsp_APIC for x86_64
      x86: change naming to match x86_64
      x86: remove cpu from maps
      x86: move cpu_exit_clear to process_32.c
      x86: take load_sp0 out of smpboot.c
      x86: don't use size specifiers.
      x86: provide delay loop for x86_64.
      x86: use rdtscll in read_current_timer for i386.
      x86: explicitly use edx in const delay function.
      x86: integrate delay functions.
      x86: don't clobber r8 nor use rcx.
      x86: don't use word-size specifiers.
      x86: adapt x86_64 getuser functions.
      x86: rename threadinfo to TI.
      x86: don't use word-size specifiers on getuser_64.
      x86: introduce __ASM_REG macro.
      x86: use _ASM_PTR instead of explicit word-size pointers.
      x86: merge getuser asm functions.
      x86: don't save ebx in putuser_32.S.
      x86: user put_user_x instead of all variants.
      x86: clobber rbx in putuser_64.S.
      x86: pass argument to putuser_64 functions in ax register.
      x86: change testing logic in putuser_64.S.
      x86: replace function headers by macros.
      x86: don't use word-size specifiers in putuser files.
      x86: use macros from asm.h.
      x86: merge putuser asm functions.
      x86: commonize __range_not_ok.
      x86: change asm constraint.
      x86: introduce likely in macro.
      x86: use long instead of int.
      x86: use something common for both architectures.
      x86: merge common parts of uaccess.
      x86: merge getuser.
      x86: move __addr_ok to uaccess.h.
      x86: use k modifier for 4-byte access.
      x86: mark x86_64 as having a working WP.
      x86: don't always use EFAULT on __put_user_size.
      x86: merge __put_user_asm and its user.
      x86: don't always use EFAULT on __get_user_size.
      x86: merge __get_user_asm and its users.
      x86: be more explicit in __put_user_x.
      x86: turn __put_user_check directly into put_user.
      x86: merge put_user.
      x86: move __get_user and __put_user into uaccess.h.
      x86: put movsl_mask into uaccess.h.
      x86: define architectural characteristics in uaccess.h.
      x86: remove duplicate call to use_tsc_delay
      x86: use matching CFI_ENDPROC
      x86: use ignore macro instead of hash comment
      x86: use AS_CFI instead of UNWIND_INFO
      x86: merge dwarf2 headers

Gustavo Fernando Padovan (1):
      x86: remove unnecessary #ifdef CONFIG_X86_32...#else

H. Peter Anvin (7):
      x86: string_32.h: workaround for broken gcc 4.0
      x86: fix overlong line in arch/x86/kernel/cpu/amd_64.c
      x86: update Documentation/i386/boot.txt
      x86: move x86-specific documentation into Documentation/x86
      x86: setup: issue a null command after enabling A20 via KBC
      x86: remove arbitrary ELF section limit in i386 relocatable kernel
      x86: fix regression: boot failure on AMD Elan TS-5500

Hiroshi Shimamoto (4):
      x86: use per_cpu data in nmi_32
      x86: nmi and irq counters are unsigned in nmi_64.c
      x86: coding style fixes for nmi.c
      x86: move bugs_64.c to cpu/bugs_64.c

Huang Weiyi (2):
      x86: ipi.c: removed duplicated include
      x86: smpboot.c: removed duplicated include

Huang, Ying (6):
      x86: split out common code into find_overlapped_early()
      x86: reserve highmem pages via reserve_early
      x86: reserve EFI memory map with reserve_early
      x86: extract common part of head32.c and head64.c into head.c
      x86: linked list of setup_data for i386
      x86 boot: pass E820 memory map entries more than 128 via linked list of setup data

Hugh Dickins (1):
      x86: PAT: make pat_x_mtrr_type() more readable

Ingo Molnar (90):
      revert: thread_info.h change
      x86: redo thread_info.h change
      x86: defconfig updates
      bitops: fix build in struct thread_info
      x86: make NUMAQ depend on PCI
      x86: untangle pci dependencies
      xen: fix early bootup crash on native hardware
      xen: fix "xen: implement save/restore"
      - fix typo in include/asm-x86/nmi.h
      fix build bug in "x86: add PCI extended config space access for AMD Barcelona"
      fix build bug in "x86: add PCI extended config space access for AMD Barcelona"
      xen: export get_phys_to_machine
      x86: fix nmi.c build bug
      x86 mpparse: build fix
      x86: add acpi_numa_slit_init() dummy implementation on 32-bit
      x86: add dummy acpi_numa_processor_affinity_init() implementation on 32-bit
      x86, numaq: add pci_acpi_scan_root() stub
      x86: 32-bit numa, build fix
      x86, numaq 32-bit: build fix
      x86: mp build fix
      x86, 32-bit: SRAT fix
      Revert "x86, 32-bit: SRAT fix"
      Revert "x86, numaq: add pci_acpi_scan_root() stub"
      x86, mpparse: build fix
      x86, bitops: make constant-bit set/clear_bit ops faster, adapt, clean up
      x86: unify __set_fixmap, fix
      x86, bitops: make constant-bit set/clear_bit ops faster, gcc workaround
      x86: fix "x86: use cpu_khz for loops_per_jiffy calculation"
      x86, AMD IOMMU: build fix
      x86, AMD IOMMU, build fix #2
      x86, AMD IOMMU: build fix #3
      Revert "Revert "x86: fix ioapic bug again""
      x86 build fix:
      x86, io-apic: fix nmi_watchdog=1 bootup hang
      Revert "x86, io-apic: fix nmi_watchdog=1 bootup hang"
      Revert "x86: APIC/SMP: downgrade the NMI watchdog for "nosmp""
      x86: unify the reserve_bootmem() behavior of early_res_to_bootmem()
      Revert parts of "x86: update mptable"
      SGI UV: TLB shootdown using broadcast assist unit
      SGI UV: clean up arch/x86/kernel/tlb_uv.c
      SGI UV: TLB shootdown using broadcast assist unit, fix
      x86: fix sleep.c build error
      x86: build fix
      x86: remove extra newline from setup.c
      x86: build fix
      x86: nmi_watchdog - documentation fix - v2
      - x86: move early_ioremap prototypes to io.h
      x86: move prefill_possible_map calling early, fix
      x86: fix "x86: let setup_arch call init_apic_mappings for 32bit"
      printk: export console_drivers
      x86, uv: build fix for "x86, uv: update x86 mmr list for SGI uv"
      x86, uv: build fix #2 for "x86, uv: update x86 mmr list for SGI uv"
      x86: delay lib unification build fix
      x86: build fix for "x86: fix C1E && nx6325 stability problem"
      x86: build fix for "x86: fix C1E && nx6325 stability problem"
      Revert "x86: fix IO APIC breakage on HP nx6325, v2"
      Revert "x86: fix IO APIC breakage on HP nx6325"
      x86: fix visws and vsmp build
      x86: add early quirk support
      x86, VisWS: turn into generic arch, make VisWS boot on a regular PC
      x86, VisWS: turn into generic arch, add early init quirks
      x86, VisWS: turn into generic arch, use generic mpparse code
      x86, VisWS: turn into generic arch, install proper PCI quirk
      x86, VisWS: turn into generic arch, update asm-x86/mach-visws/mach_apic.h
      x86, VisWS: turn into generic arch, eliminate include/asm-x86/mach-visws/mach_apic.h
      x86, VisWS: turn into generic arch, enhance include/asm-x86/mach-default/smpboot_hooks.h
      x86, VisWS: turn into generic arch, update include/asm-x86/mach-visws/smpboot_hooks.h
      x86, VisWS: turn into generic arch, eliminate include/asm-x86/mach-visws/smpboot_hooks.h
      x86, VisWS: turn into generic arch, update asm-x86/mach-visws/mach_apicdef.h
      x86, VisWS: turn into generic arch, eliminate asm-x86/mach-visws/mach_apicdef.h
      x86, VisWS: turn into generic arch, create include/asm-x86/visws/
      x86, VisWS: turn into generic arch, move definitions
      x86, VisWS: turn into generic arch, eliminate include/asm-x86/mach-visws/setup_arch.h
      x86, VisWS: turn into generic arch, add NR_IRQS quirk
      x86, VisWS: turn into generic arch, add early quirks to default architectures
      x86, VisWS: turn into generic arch, copy visws files
      x86, VisWS: turn into generic arch, flip over VISWS to generic arch
      x86, VisWS: turn into generic arch, clean up
      x86, VisWS: turn into generic arch, IO-APIC setup fix
      x86, VisWS: turn into generic arch, clean up
      x86, VisWS: turn into generic arch, clean up
      x86, VisWS: turn into generic arch, remove leftover files
      x86, VisWS: turn into generic arch, eliminate Kconfig specials
      x86, VisWS: turn into generic arch, update include file change
      x86, VisWS: do not allow VisWS for Voyager
      x86, VisWS: build fix
      x86, VisWS: build fix
      x86, VisWS: fix pci_direct_conf1 dependency
      x86: fix tsc unification buglet with ftrace and stackprotector
      x86: fix savesegment() bug causing crashes on 64-bit

Isaku Yamahata (4):
      xen: Move manage.c to drivers/xen for ia64/xen support
      xen: compilation fix to balloon driver for ia64 support
      xen: add missing definitions in include/xen/interface/memory.h which ia64/xen needs
      xen: Use wmb instead of rmb in xen_evtchn_do_upcall().

Jack Steiner (5):
      x86, uv: update macros used by UV platform
      x86: fix stack overflow for large values of MAX_APICS
      x86: increase MAX_APICS for very large x86-64 configs
      x86: map UV chipset space - pagetable
      x86: map UV chipset space - UV support

Jan Beulich (10):
      x86: minor polishing to top-level arch Makefile
      x86: separate cmpxchg8b checking from PAE checking
      x86: avoid re-loading LDT in unrelated address spaces
      x86: move tracedata to RODATA
      x86: make /proc/stat account for all interrupts
      x86: eliminate duplicate consistency checks in init_32.c
      i386: move FIX_ACPI_* into non-permanent range
      x86: constify data in reboot.c
      x86: eliminate dead code in x86_64 entry.S
      x86-64: remove unnecessary ptregs call stubs

Jeremy Fitzhardinge (91):
      xen: remove support for non-PAE 32-bit
      x86: use pteval_t for _PAGE_FOO
      x86: use symbolic constant in stts()
      xen: add raw console write functions for debug
      xen: make early console also write to debug console
      xen: use hypercall rather than clts
      xen: use new sched_op
      xen: allow some cr4 updates
      xen: don't worry about preempt during xen_irq_enable()
      x86/paravirt: add pte_flags to just get pte flags
      xen: make earlyprintk=xen work again
      xen: count resched interrupts properly
      xen: make phys_to_machine structure dynamic
      xen: add configurable max domain size
      xen: efficiently support a holey p2m table
      xen: make dummy_shared_info non-static
      xen: add p2m mfn_list_list
      xen: add rebind_evtchn_irq
      xen: fix unbind_from_irq()
      xen-console: add save/restore
      xenbus: rebind irq on restore
      xen: implement save/restore
      xen: maintain clock offset over save/restore
      CONFIG_PM_SLEEP fix: xen: fix compilation when CONFIG_PM_SLEEP is disabled
      xen: avoid hypercalls when updating unpinned pud/pmd
      xen: restore vcpu_info mapping
      xen: resume timers on all vcpus
      xen: add new Xen elfnote types and use them appropriately
      x86: set PAE PHYSICAL_MASK_SHIFT to 44 bits.
      x86: make asm/asm.h work for asm code.
      xen: mask unwanted pte bits in __supported_pte_mask
      xen: don't drop NX bit
      x86: unify asm-x86/fixmap*.h
      x86: unify __set_fixmap
      x86: implement set_pte_vaddr
      x86/paravirt/xen: add set_fixmap pv_mmu_ops
      mm: add a ptep_modify_prot transaction abstraction
      paravirt: add hooks for ptep_modify_prot_start/commit
      xen: implement ptep_modify_prot_start/commit
      xen: add mechanism to extend existing multicalls
      x86: compile error fix for smpboot.c
      build: add __page_aligned_data and __page_aligned_bss
      xen: reserve Xen-specific memory in e820 map
      xen: reserve ISA space in e820 map
      xen: set max_pfn_mapped
      x86: asm-x86/pgtable.h: fix compiler warning
      x86: add memory clobber to save/loadsegment
      x86: add memory barriers to wrmsr
      x86: remove open-coded save/load segment operations
      x86, 64-bit: use write_gdt_entry in vsyscall_set_cpu
      x86, 64-bit: use p??_populate() to attach pages to pagetable
      x86, 64-bit: unify early_ioremap
      x86, 64-bit: add gate_offset() and gate_segment() macros
      x86: unify pgd_index
      x86: unify mmu_context.h
      x86, 64-bit: add prototype for x86_64_start_kernel()
      x86, 64-bit: add sync_cmpxchg
      x86: simplify vmalloc_sync_all
      x86/paravirt: add a pgd_alloc/free hooks
      x86: preallocate and prepopulate separately
      x86/paravirt: add debugging for missing operations
      x86/paravirt: define PARA_INDIRECT for indirect asm calls
      x86, 64-bit: add FIX_PARAVIRT_BOOTMAP fixmap slot
      x86, 64-bit: split x86_64_start_kernel
      x86, 64-bit: adjust mapping of physical pagetables to work with Xen
      x86, 64-bit: create small vmemmap mappings if PSE not available
      x86, 64-bit: PSE no longer a hard requirement
      x86, 64-bit: __switch_to(): move arch_leave_lazy_cpu_mode() to the right place
      x86: save %fs and %gs before load_TLS() and arch_leave_lazy_cpu_mode()
      x86: use __KERNEL_DS as SS when returning to a kernel thread
      x86/paravirt: split sysret and sysexit
      x86/paravirt, 64-bit: don't restore user rsp within sysret
      x86/paravirt: add sysret/sysexit pvops for returning to 32-bit compatibility userspace
      x86, 64-bit: ia32entry: replace privileged instructions with pvops
      x86, 64-bit: swapgs pvop with a user-stack can never be called
      x86/paravirt, 64-bit: add adjust_exception_frame
      x86/paravirt, 64-bit: make load_gs_index() a paravirt operation
      x86: fix pte allocation in "x86: introduce init_memory_mapping for 32bit"
      x86/paravirt: groundwork for 64-bit Xen support, fix
      x86/paravirt: groundwork for 64-bit Xen support, fix #2
      x86_64: fix non-paravirt compilation
      x86: setup_arch() && early_ioremap_init()
      x86, paravirt, 64-bit: fix compile errors with IA32_EMULATION off
      x86: fix CPA self-test for "x86/paravirt: groundwork for 64-bit Xen support"
      x86_64/setup: unconditionally populate the pgd
      x86: always set _PAGE_GLOBAL in _PAGE_KERNEL* flags
      x86_32: remove __PAGE_KERNEL(_EXEC)
      x86/cpa: use an undefined PTE bit for testing CPA
      x86: fix compile error in current tip.git
      x86_64: add pseudo-features for 32-bit compat syscall
      x86_64: vdso32 cleanup using feature flags

Jiri Hladky (1):
      x86: fix bug in arch/i386/lib/delay.c file, delay_loop function

Jiri Slaby (2):
      x86_64: fix mm.txt documentation
      x86_64: use PAGE_OFFSET in dump_pagetables

Joe Perches (1):
      x86: include/asm-x86/string_32.h - style only

Joerg Roedel (41):
      x86, AMD IOMMU: add Kconfig entry
      x86, AMD IOMMU: add header file for driver data structures and defines
      x86, AMD IOMMU: add defines and structures for ACPI scanning code
      x86, AMD IOMMU: add data structures to manage the IOMMUs in the system
      x86, AMD IOMMU: add functions to find last possible PCI device for IOMMU
      x86, AMD IOMMU: add amd_iommu_init.c to Makefile
      x86, AMD IOMMU: add functions for mapping/unmapping the MMIO space
      x86, AMD IOMMU: add functions for programming IOMMU MMIO space
      x86, AMD IOMMU: add command buffer (de-)allocation
      x86, AMD IOMMU: add device table initialization functions
      x86, AMD IOMMU: add functions for IOMMU hardware initialization from ACPI
      x86, AMD IOMMU: add detect code for AMD IOMMU hardware
      x86, AMD IOMMU: add functions to parse IOMMU memory mapping requirements for devices
      x86, AMD IOMMU: clue initialization code together
      x86, AMD IOMMU: add early detection code
      x86, AMD IOMMU: add kernel command line parameters for AMD IOMMU
      x86, AMD IOMMU: add generic defines and structures for mapping code
      x86, AMD IOMMU: add amd_iommu.c to Makefile
      x86, AMD IOMMU: add functions to send IOMMU commands
      x86, AMD IOMMU: add functions to initialize unity mappings
      x86, AMD IOMMU: add address allocation and deallocation functions
      x86, AMD IOMMU: add domain allocation and deallocation functions
      x86, AMD IOMMU: add functions to find IOMMU device resources
      x86, AMD IOMMU: add generic dma_ops mapping functions
      x86, AMD IOMMU: add dma_ops mapping functions for single mappings
      x86, AMD IOMMU: add mapping functions for scatter gather lists
      x86, AMD IOMMU: add mapping functions for coherent mappings
      x86, AMD IOMMU: add pre-allocation of protection domains
      x86, AMD IOMMU: add dma_ops initialization function
      x86, AMD IOMMU: add amd_iommu.h to export functions to the generic x86 dma code
      x86, AMD IOMMU: initialize dma_ops from IOMMU initialization and enable IOMMUs
      AMD_IOMMU: call detect and initialization functions from dma code
      x86, AMD IOMMU: add MAINTAINERS entry
      x86, AMD IOMMU: add documentation for kernel parameters
      x86, AMD IOMMU: disable suspend/resume with IOMMU enabled (for now)
      x86, AMD IOMMU: more verbose Kconfig description text
      x86, AMD IOMMU: remove unnecessary set_bit_string
      x86, AMD IOMMU: flush domain TLB when there is more than one page to flush
      x86, AMD IOMMU: honor iommu=off instead of amd_iommu=off
      x86, AMD IOMMU: don't try to init IOMMU if early detect code did not detect one
      x86, AMD IOMMU: remove unnecessary code from the iommu_enable function

Kristian Høgsberg (2):
      x86: Use structs instead of hardcoded offsets in x86 boot decompressor.
      x86: Honor 'quiet' command line option in real mode boot decompressor.

Krzysztof Oledzki (1):
      x86: add another PCI ID for ICH6 force hpet.

Linus Torvalds (2):
      x86: MMIO and gcc re-ordering issue
      x86, bitops: make constant-bit set/clear_bit ops faster

Maciej W. Rozycki (29):
      x86: I/O APIC: AEOI timer acknowledgement clean-ups
      x86: I/O APIC: remove parameters to fiddle with the 8259A
      x86: I/O APIC: clean up after a fasteoi failure
      x86: I/O APIC: keep IRQ off when changing LVT registers
      x86: APIC/SMP: correct the message for "nosmp"
      x86: APIC/SMP: downgrade the NMI watchdog for "nosmp"
      x86: I/O APIC: clean up the 8259A on a NMI watchdog failure
      x86: I/O APIC: fix the name of the L-APIC IRQ handler
      x86: I/O APIC: fix the name of the through-8259A handler
      x86: I/O APIC: remove redundant 8259A {,un}masking
      x86: I/O APIC: remove redundant LVT0 masking
      x86: I/O APIC: rename setup_ExtINT_IRQ0_pin()
      x86: I/O APIC: unmask the second-chance timer interrupt
      x86: I/O APIC: keep the timer IRQ masked during set-up
      x86: I/O APIC: timer through 8259A second-chance
      x86: NMI watchdog: Downgrade helper
      x86: APIC/UP: Downgrade the NMI watchdog for no I/O APIC
      x86: APIC/UP: Remove redundant NMI watchdog downgrade
      x86: APIC/SMP: Downgrade the NMI watchdog for "nosmp"
      x86: APIC/SMP: Downgrade the NMI watchdog for "noapic"
      x86: fix IO APIC breakage on HP nx6325
      x86: fix IO APIC breakage on HP nx6325, v2
      x86, ioapic, acpi: add a knob to disable IRQ 0 through I/O APIC
      x86: I/O APIC: Add a 64-bit variation of replace_pin_at_irq()
      x86: L-APIC: Set IRQ0 as edge-triggered
      x86: L-APIC: Always fully configure IRQ0
      x86: I/O APIC: Never configure IRQ2
      x86: Recover timer_ack lost in the merge of the NMI watchdog
      x86: I/O APIC: remove an IRQ2-mask hack

Markus Armbruster (5):
      xen: Enable console tty by default in domU if it's not a dummy
      xen pvfb: Pointer z-axis (mouse wheel) support
      xen pvfb: Module aliases to support module autoloading
      xen pvfb: Zero unused bytes in events sent to backend
      xen pvfb: Dynamic mode support (screen resizing)

Matthew Garrett (1):
      x86, ioapic, acpi quirk: disable IRQ 0 through I/O APIC for some HP systems

Matti Linnanvuori (1):
      x86: add compilation checks to pci_unmap_*() macros

Mike Travis (11):
      x86: change maximum NR_CPUS to 4096 and MAX_NUMNODES to 512
      x86: fix remove cpu_pda table patch
      x86: modify Kconfig to allow up to 4096 cpus
      x86: cleanup early per cpu variables/accesses v4
      x86: restore pda nodenumber field
      x86: remove the static 256k node_to_cpumask_map
      x86: remove static boot_cpu_pda array v2
      x86: leave initial __cpu_pda array in place until cpus are booted
      sched, numa: replace MAX_NUMNODES with nr_node_ids in kernel/sched.c
      x86: add check for node passed to node_to_cpumask, v3
      x86: change _node_to_cpumask_ptr to return const ptr

Miklos Vajna (2):
      x86: janitor work in bugs.c
      x86: janitor work in video-vga.c

OGAWA Hirofumi (1):
      x86: clean up vdso_enabled type on x86_64

Paolo Ciarrocchi (7):
      x86: coding style fixes to arch/x86/pci/irq.
      x86: coding style fixes to arch/x86/kernel/sys_i386_32.c
      x86: coding style fixes to arch/x86/kernel/cpu/mcheck/p4.c
      x86: coding style fixes to arch/x86/kernel/cpu/mcheck/k7.c
      x86: coding style fixes to arch/x86/math-emu/reg_constant
      x86: coding style fixes to x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
      x86: coding style fixes to arch/x86/kernel/io_apic_32.c

Paul Jackson (17):
      x86 boot: include missing smp.h header
      x86 boot: remove some unused extern function declarations
      x86 boot: add header comment to dmi.h stating what it is
      x86 boot: simplify pageblock_bits enum declaration
      x86 boot: minor code format fixes in e820 and efi routines
      x86 boot: proper use of ARRAY_SIZE instead of repeated E820MAX constant
      x86 boot: extend some internal memory map arrays to handle larger EFI input
      x86 boot: change sanitize_e820_map parameter from byte to int to allow bigger memory maps
      x86 boot: longer comment explaining sanitize_e820_map routine
      x86 boot: add code to add BIOS provided EFI memory entries to kernel
      x86 boot: e820 code indentation fix
      x86 boot: x86_64 efi compiler warning fix
      x86 boot: allow overlapping early reserve memory ranges
      x86 boot: show pfn addresses in hex not decimal in some kernel info printks
      x86 boot: more consistently use type int for node ids
      mm, generic, x86 boot: more tweaks to hex prints of some pfn addresses
      x86 boot: only pick up additional EFI memmap if add_efi_memmap flag

Pavel Machek (16):
      x86: iommu: use symbolic constants, not hardcoded numbers
      x86 gart: factor out common code
      x86, aperture_64: use symbolic constants
      x86: automatical unification of i8259.c
      x86: i8259.c: remove #ifdefs around includes
      x86: i8259.c: remove trivial ifdefs
      x86: i8259: cleanup codingstyle
      x86: automatical unification of i8259.c
      x86: i8259.c: remove #ifdefs around includes
      x86: i8259.c: remove trivial ifdefs
      x86: i8259: cleanup codingstyle
      x86: aperture_64.c: cleanups
      i8259: fix final ugliness
      aperture_64.c: duplicated code, buggy?
      x86: aperture_64.c: corner case wrong
      pci-gart_64.c: could we get better explanation?

Rafael J. Wysocki (4):
      x86: remove obsolete PM definitions from NMI header
      x86, gart: add resume handling
      x86: fix C1E && nx6325 stability problem
      x86: remove conflicting nx6325 and nx6125 quirks

Randy Dunlap (1):
      x86: fix setup.c printk format warning

Richard Kennedy (1):
      x86: cacheline_align tss_struct

Robert Richter (18):
      x86: add PCI extended config space access for AMD Barcelona
      fix build bug in "x86: add PCI extended config space access for AMD Barcelona"
      x86: add X86_FEATURE_IBS cpu feature
      x86/pci: Renaming k8-bus_64.c to amd_bus.c
      x86: Move PCI IO ECS code to x86/pci
      x86/pci: Makefile merge: Removing Makefile_*
      x86/pci: Makefile merge: removing include dir flag
      x86/pci: Makefile merge: whitespace changes only
      x86/pci: Makefile merge: decoupling options for mp_bus_to_node.o
      x86/pci: Makefile merge: changing 64bit ordering
      x86/pci: Makefile merge: creating pci-y for 64 bit
      x86/pci: mp_bus_to_node merge: moving code in amd_bus.c
      x86/pci: merge: moving mp_bus_to_node.c to amd_bus.c
      x86/pci: Makefile merge: coalescing 32 and 64 bit
      x86/pci: visws: renaming pcibios_init()
      x86/pci: removing subsys_initcall ordering dependencies
      x86/pci merge: fixing numaq initialization
      x86/pci: fix warnings in subsys_initcall functions

Roland McGrath (2):
      x86 ptrace: fix PTRACE_GETFPXREGS error
      x86_64: fix delayed signals

Soeren Sandmann (1):
      x86: initialize all fields of mp_irqs[mp_irq_entries]

Sven Wegener (1):
      x86: Remove obsolete LOCK macro from include/asm-x86/atomic_64.h

Thomas Gleixner (50):
      x86: print info about available HPET quirk
      x86: move common declarations to hw_irq.h
      x86: unify interrupt vector defines
      x86: move BUILD_IRQ macro magic to i8259_64.c
      x86: unify apic interrupt function declarations
      x86: unify hwirq.h
      x86: unify irq.h
      x86: declare setup_apic_routing
      x86: move eisa_set_level_irq declaration to header
      x86: janitor stack overflow warning patch
      x86: irq_32 move 4kstacks code to one place
      x86: remove useless static current_tsc_khz variable
      x86: rename the i8259_32/64.c leftovers to initirq_32/64.c
      x86: make init_ISA_irqs() static
      x86: make init_ISA_irqs() static
      x86: rename the i8259_32/64.c leftovers to irqinit_32/64.c
      x86: fixup the fallout of the bitops changes
      x86: tsc_64.c make constant UL
      x86: vsmp_64 add missing includes
      x86: boot/printfc use NULL instead 0
      x86: create prototype for (un)map_devmem
      x86: k8topology add missing header
      x86: k8topology fix shadow variable
      x86: k8topology cleanup variable declarations
      x86: move mmconfig declarations to header
      x86: init64.c include initrd.h
      x86: make command_line static in setup_64.c
      x86: make __pci_mmcfg_init static in mmconfig-shared.c
      x86: make memory_add_physaddr_to_nid depend on MEMORY_HOTPLUG
      x86: fixup the fallout of the bitops changes
      x86: fix sparse warning in mtrr/generic.c
      x86: move mp_ioapic_routing to mpparse and make it static
      x86: fix shadow variables of global end_pnf in e820_64.c
      x86: include pci.h in e820_64.c
      x86: fix mpparse fallout
      x86: move mmconfig declarations to header
      x86: simplify idle selection
      x86: cleanup C1E enabled detection
      x86: use cpuinfo to check for interrupt pending message msr
      x86: use cpuid to check MWAIT support for C1
      x86: move more common idle functions/variables to process.c
      x86, clockevents: add C1E aware idle function
      x86: add C1E aware idle function, fix
      x86: janitor CPA statistics patch
      x86: add sparse annotations to ioremap
      x86: move pci_routirq declaration to pci.h
      x86: make irq_cfg static
      x86: apic_64.c fix sparse warnings about shadowed variables
      x86: numa_64.c make local variables static
      x86: numa_64.c fix shadowed variable

Vegard Nossum (7):
      x86: fix incomplete include guard in include/asm-x86/seccomp_32.h
      x86: break mutual header inclusion
      x86: more header fixes
      x86/oprofile: disable preemption in nmi_shutdown
      x86: don't destroy %rbp on kernel-mode faults
      x86: small unifications of address printing
      x86: don't return invalid pointers from node_to_cpumask()

Venki Pallipadi (4):
      x86: remove 6 bank limitation in 64 bit MCE reporting code
      x86: add "debugpat" boot option
      x86: fix Xorg crash with xf86MapVidMem error
      x86, mce_64.c: mce_cpu_quirks being ignored

Vitaly Mayatskikh (2):
      x86: introduce copy_user_handle_tail() routine
      x86: fix copy_user on x86

WANG Cong (1):
      x86: arch/x86/kernel/machine_kexec_32.c: remove extra semicolons

Yinghai Lu (165):
      x86: agp_gart size checking for buggy device
      x86: checking aperture size order
      x86_64: allocate gart aperture from 512M
      x86: clean up aperture_64.c
      x86: reserve dma32 early for gart fix
      x86_64: simplify the memtest parameter setting
      x86: mtrr cleanup for converting continuous to discrete layout, v8
      x86: fix trimming e820 with MTRR holes.
      x86: fix trimming e820 with MTRR holes. - fix
      x86: mtrr cleanup for converting continuous to discrete layout v8 - fix
      x86: mtrr cleanup for converting continuous to discrete - auto detect v4
      x86: process fam 10h like k8 with fixed mtrr setting
      x86: make e820.c to have common functions
      x86: amd opteron TOM2 mask val fix
      x86: mtrr cleanup for converting continuous to discrete layout - fix #2
      x86: extend e820 ealy_res support 32bit
      x86: extend e820 ealy_res support 32bit - fix
      x86: cleanup print out for mptable
      x86: move e820_mark_nosave_regions to e820.c
      x86: extend e820 ealy_res support 32bit - fix #2
      x86: extend e820 early_res support 32bit -fix #3
      x86: extend e820 early_res support 32bit -fix #4
      x86: extend e820 early_res support 32bit -fix #5
      x86: 32bit numa srat fix early_ioremap leak
      x86: remove duplicated e820 func in setup.h
      x86, numa, 32-bit: increase max_elements to 1024
      x86: set node_remap_size[0] in fallback path
      x86, 32-bit: change propagate_e820_map() back to find_max_pfn()
      x86, numa, 32-bit: print out debug info on all kvas
      x86: update mptable
      x86, numa, 32-bit: avoid clash between ramdisk and kva
      x86: clean up max_pfn_mapped usage - 32-bit
      x86: clean up max_pfn_mapped usage - 64-bit
      x86: change propagate_e820_map() back to find_max_pfn(), 32-bit, fix
      x86: early check if a system is numaq
      x86, numa, 32-bit: make sure get we kva space
      x86: move e820_register_active() to e820.c
      x86: make 32-bit use e820_register_active_regions()
      x86: e820 max_arch_pfn typo fix for 64 bit
      x86: remove all active memory ranges before registering them again after trimming - 64bit
      mm, x86: shrink_active_range() should check all
      x86, numa, 32-bit: use find_e820_area() to find KVA RAM on node
      x86: fix boot failure with 64GB+ system with numa 32-bit
      x86: introduce max_physical_apicid for bigsmp switching
      x86: make generic arch support NUMAQ
      x86: update mptable, fix
      x86: change early_gart_iommu_check() back to any_mapped
      x86: make 64-bit identify_cpu use cpu_dev
      x86: make 64bit identify_cpu use cpu_dev v2
      x86: e820 merge parsing of the mem=/memmap= boot parameters
      x86: make generic arch support NUMAQ, fix
      x86: make generic arch support NUMAQ, fix #2
      x86: clean up reserve_bootmem_generic() and port it to 32-bit
      x86: replace shrink_active_range() with remove_active_range()
      x86: clean up relocate_initrd
      x86: keep MP_intsrc_info untouched if we do not update mptable
      x86: use dstapic in mp_config_acpi_legacy_irqs
      x86: rename two e820 related functions
      x86, mm: use add_highpages_with_active_regions() for high pages init v2
      x86: move e820_resource_resources to e820.c
      x86: kill bad_ppro
      x86: merge setup_memory_map with e820
      x86: move some function out of setup_bootmem_alloc
      x86: Kconfig cleanup with genericarch
      x86: use acpi_numa_init to parse on 32-bit numa
      x86: remove unused file after numaq etc depends on genericarch
      x86: cleanup machine_specific_memory_setup, v2
      x86: update mptable fix with no ioapic v2
      x86: let MPS support be selectable, v2
      x86: fix compiling when CONFIG_X86_MPPARSE is not set
      x86: simplify x86_mpparse dependency check
      x86: make dev_to_node return online node
      x86: don't call pxm_to_node again
      RFC x86: try to remove arch_get_ram_range
      x86: check command line when CONFIG_X86_MPPARSE is not set, v2
      x86: clean up init_amd()
      x86: remove some acpi ifdefs in setup_32/64
      x86: seperate funcs from setup_64 to cpu common_64.c
      x86: change identify_cpu to static
      x86: add e820_remove_range
      x86: seperate probe_roms into another file
      x86: merge setup64.c into common_64.c
      x86: remove two duplicated funcs in setup_32.c
      x86: move reserve_standard_io_resource to setup.c
      x86: move elfcorehdr parsing to setup.c
      x86: introduce initmem_init for 64 bit
      x86: introduce initmem_init for 32 bit
      x86: introduce reserve_initrd
      x86: move boot_params declaring to setup.c
      x86: move find_max_low_pfn to init_32.c
      x86: move reservetop and vmalloc parsing to pgtable_32.c
      x86: clean up using max_low_pfn on 32-bit
      x86: clean up min_low_pfn
      x86: fix compile warning in init_64.c
      x86: numa32 pfn print out using hex instead
      x86: move some func calling from setup_arch to paging_init
      x86: setup_arch 32bit move efi check later
      x86: setup_arch 32bit move command line copying early
      x86: setup_arch 32bit move kvm_guest_init later
      x86: introduce init_memory_mapping for 32bit #1
      x86: introduce init_memory_mapping for 32bit #2
      x86: introduce init_memory_mapping for 32bit #3
      x86: fix e820_update_range size when overlapping
      x86: get max_pfn_mapped in init_memory_mapping
      x86: add table_top check for alloc_low_page in 64 bit
      x86: change size if e820_update/remove_range
      x86: numa 32 using apicid_2_node to get node for logical_apicid
      x86: remove end_pfn in 64bit
      x86: fix memory setup bug
      x86: rename setup.c to setup_percpu.c
      x86: we can use full bootmem after have init_memory_mapping
      x86: update reserve_initrd to support 64bit
      x86: put global variable for 32bit all together
      x86: add extra includes for 64bit support
      x86: merge 64bit setup_arch into setup_32
      x86: space to tab in setup_arch
      x86: rename setup_32.c to setup.c
      x86: move boot_params back to setup.c
      x86: move parse_setup_data back to setup.c
      x86: move back crashkernel back to setup.c
      x86: move reserve_standard_io_resources back to setup.c
      x86: move parse elfvorehdr back to setup.c
      x86: make x86_find_smp_config depends on 64 bit too
      x86: change some functions in setup.c to static
      x86: we only have init_pg_tables_end for 32bit
      x86: clean up ARCH_SETUP
      x86: move fix mapping page table range early
      x86: early res print out alignment v2
      x86: let setup_arch call init_apic_mappings for 32bit
      x86: fix init_memory_mapping over boundary v3
      x86: fix warning in e820_reserve_resources with 32bit
      x86: fix init_memory_mapping over boundary, v4
      x86: use disable_apic in 32bit
      x86: move reserve_setup_data to setup.c
      x86: don't reallocate pgt for node0
      x86: change copy_e820_map to append_e820_map
      x86: make early_res_to_bootmem print out less 80 width chars
      x86: do not printout if we do not find setup_data
      x86: merge zones_sizes_init for numa and non numa on 32-bit
      x86: move init_cpu_to_node after get_smp_config
      x86: move prefill_possible_map calling early
      x86: remove have_arch_parse_srat -v2
      x86: remove acpi_srat config v2
      x86: move saving e820_saved to setup_memory_map
      x86: make e820_saved have update from setup_data
      x86: let early_reserve_e820 update e820_saved too
      x86: introduce page_size_mask for 64bit
      x86: fix vmemmap printout check
      x86: make max_pfn cover acpi table below 4g
      x86: not overmap more than the end of RAM in init_memory_mapping - 64bit
      x86: make e820_end return max ram type only for 32 bit
      x86: overmapped fix when 4K pages on tail, 64-bit
      x86, acpi: merge __acpi_map_table
      x86: make e820_end return end_of_ram again for 64bit
      x86: e820: user-defined memory maps: remove the range instead of update it to reserved
      x86: reserve SLIT
      x86: introduce max_low_pfn_mapped for 64-bit
      x86: max_low_pfn_mapped fix, #1
      x86: max_low_pfn_mapped fix, #2
      x86: max_low_pfn_mapped fix, #3
      x86, e820: remove end_user_pfn
      x86: fix numaq_tsc_disable calling
      x86: max_low_pfn_mapped fix #4
      x86: get x86_phys_bits early
      x86: make 64bit hpet_set_mapping to use ioremap too, v2

mingo@elte.hu (1):
      x86, nmi: fix build

venkatesh.pallipadi@intel.com (1):
      x86: PAT export resource_wc in pci sysfs


 Documentation/ABI/testing/sysfs-firmware-memmap    |   71 +
 Documentation/kdump/kdump.txt                      |    2 +-
 Documentation/kernel-parameters.txt                |   37 +
 Documentation/nmi_watchdog.txt                     |   16 +-
 Documentation/{ => x86}/i386/IO-APIC.txt           |    0
 Documentation/{ => x86}/i386/boot.txt              |   79 +-
 .../{ => x86}/i386/usb-legacy-support.txt          |    0
 Documentation/{ => x86}/i386/zero-page.txt         |    0
 Documentation/{ => x86}/x86_64/00-INDEX            |    0
 Documentation/{ => x86}/x86_64/boot-options.txt    |    0
 Documentation/{ => x86}/x86_64/cpu-hotplug-spec    |    0
 .../{ => x86}/x86_64/fake-numa-for-cpusets         |    0
 Documentation/{ => x86}/x86_64/kernel-stacks       |    0
 Documentation/{ => x86}/x86_64/machinecheck        |    0
 Documentation/{ => x86}/x86_64/mm.txt              |    5 +-
 Documentation/{ => x86}/x86_64/uefi.txt            |    4 +
 MAINTAINERS                                        |    6 +
 arch/x86/Kconfig                                   |  280 ++--
 arch/x86/Kconfig.cpu                               |    6 +-
 arch/x86/Kconfig.debug                             |   19 +-
 arch/x86/Makefile                                  |   27 +-
 arch/x86/boot/a20.c                                |    5 +-
 arch/x86/boot/compressed/head_64.S                 |    5 +-
 arch/x86/boot/compressed/misc.c                    |   59 +-
 arch/x86/boot/compressed/relocs.c                  |  198 ++-
 arch/x86/boot/cpu.c                                |    2 +
 arch/x86/boot/main.c                               |    4 +
 arch/x86/boot/memory.c                             |    3 +-
 arch/x86/boot/pmjump.S                             |    4 +-
 arch/x86/boot/video-vga.c                          |    3 +-
 arch/x86/configs/i386_defconfig                    | 1711 ++++++++++++++------
 arch/x86/configs/x86_64_defconfig                  | 1735 ++++++++++++++------
 arch/x86/ia32/ia32entry.S                          |   68 +-
 arch/x86/kernel/Makefile                           |   21 +-
 arch/x86/kernel/acpi/boot.c                        |  442 +++++-
 arch/x86/kernel/acpi/sleep.c                       |    4 +-
 arch/x86/kernel/amd_iommu.c                        |  962 +++++++++++
 arch/x86/kernel/amd_iommu_init.c                   |  875 ++++++++++
 arch/x86/kernel/aperture_64.c                      |  313 +++--
 arch/x86/kernel/apic_32.c                          |  123 +-
 arch/x86/kernel/apic_64.c                          |   68 +-
 arch/x86/kernel/apm_32.c                           |   25 +-
 arch/x86/kernel/asm-offsets_32.c                   |    2 +-
 arch/x86/kernel/asm-offsets_64.c                   |    7 +-
 arch/x86/kernel/cpu/Makefile                       |    4 +
 arch/x86/kernel/cpu/addon_cpuid_features.c         |   17 +-
 arch/x86/kernel/cpu/amd.c                          |   42 -
 arch/x86/kernel/cpu/amd_64.c                       |  222 +++
 arch/x86/kernel/cpu/bugs.c                         |   27 +-
 arch/x86/kernel/{ => cpu}/bugs_64.c                |    0
 arch/x86/kernel/cpu/centaur_64.c                   |   35 +
 arch/x86/kernel/cpu/common.c                       |    2 +-
 arch/x86/kernel/cpu/common_64.c                    |  681 ++++++++
 arch/x86/kernel/cpu/cpu.h                          |    5 +
 arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c      |   44 +-
 arch/x86/kernel/cpu/intel.c                        |    4 +
 arch/x86/kernel/cpu/intel_64.c                     |   95 ++
 arch/x86/kernel/cpu/intel_cacheinfo.c              |    1 +
 arch/x86/kernel/cpu/mcheck/k7.c                    |   36 +-
 arch/x86/kernel/cpu/mcheck/mce_64.c                |   24 +-
 arch/x86/kernel/cpu/mcheck/p4.c                    |   90 +-
 arch/x86/kernel/cpu/mtrr/generic.c                 |   38 +-
 arch/x86/kernel/cpu/mtrr/main.c                    |  901 ++++++++++-
 arch/x86/kernel/cpu/mtrr/mtrr.h                    |    3 +
 arch/x86/kernel/cpu/perfctr-watchdog.c             |  206 ++-
 arch/x86/kernel/e820.c                             | 1390 ++++++++++++++++
 arch/x86/kernel/e820_32.c                          |  775 ---------
 arch/x86/kernel/e820_64.c                          |  952 -----------
 arch/x86/kernel/early-quirks.c                     |   15 +-
 arch/x86/kernel/efi.c                              |   67 +-
 arch/x86/kernel/efi_64.c                           |    8 +-
 arch/x86/kernel/entry_32.S                         |   11 +-
 arch/x86/kernel/entry_64.S                         |   61 +-
 arch/x86/kernel/genapic_64.c                       |    2 +-
 arch/x86/kernel/genx2apic_uv_x.c                   |  214 ++-
 arch/x86/kernel/head.c                             |   55 +
 arch/x86/kernel/head32.c                           |   27 +
 arch/x86/kernel/head64.c                           |   96 +-
 arch/x86/kernel/head_32.S                          |   13 +-
 arch/x86/kernel/head_64.S                          |   99 +-
 arch/x86/kernel/hpet.c                             |   63 +-
 arch/x86/kernel/i387.c                             |    4 +-
 arch/x86/kernel/{i8259_32.c => i8259.c}            |  136 +--
 arch/x86/kernel/i8259_64.c                         |  512 ------
 arch/x86/kernel/io_apic_32.c                       |  676 +++++----
 arch/x86/kernel/io_apic_64.c                       |  280 ++--
 arch/x86/kernel/ipi.c                              |    1 -
 arch/x86/kernel/irq_32.c                           |  254 ++--
 arch/x86/kernel/irq_64.c                           |   28 +
 arch/x86/kernel/irqinit_32.c                       |  114 ++
 arch/x86/kernel/irqinit_64.c                       |  217 +++
 arch/x86/kernel/ldt.c                              |    6 +-
 arch/x86/kernel/machine_kexec_32.c                 |    4 +-
 arch/x86/kernel/machine_kexec_64.c                 |    2 +-
 arch/x86/kernel/microcode.c                        |   29 +-
 arch/x86/kernel/mmconf-fam10h_64.c                 |    1 +
 arch/x86/kernel/mpparse.c                          |  847 ++++++----
 arch/x86/kernel/{nmi_32.c => nmi.c}                |  227 ++-
 arch/x86/kernel/nmi_64.c                           |  482 ------
 arch/x86/kernel/numaq_32.c                         |   32 +-
 arch/x86/kernel/paravirt.c                         |   36 +-
 arch/x86/kernel/paravirt_patch_32.c                |    4 +-
 arch/x86/kernel/paravirt_patch_64.c                |    9 +-
 arch/x86/kernel/pci-calgary_64.c                   |    4 +-
 arch/x86/kernel/pci-dma.c                          |   22 +-
 arch/x86/kernel/pci-gart_64.c                      |   95 +-
 arch/x86/kernel/pci-swiotlb_64.c                   |    2 +-
 arch/x86/kernel/probe_roms_32.c                    |  166 ++
 arch/x86/kernel/process.c                          |  190 ++-
 arch/x86/kernel/process_32.c                       |   65 +-
 arch/x86/kernel/process_64.c                       |   85 +-
 arch/x86/kernel/ptrace.c                           |    4 +-
 arch/x86/kernel/quirks.c                           |   58 +-
 arch/x86/kernel/reboot.c                           |   18 +-
 arch/x86/kernel/reboot_fixups_32.c                 |    4 +-
 arch/x86/kernel/setup.c                            |  924 ++++++++++-
 arch/x86/kernel/setup64.c                          |  287 ----
 arch/x86/kernel/setup_32.c                         |  964 -----------
 arch/x86/kernel/setup_64.c                         | 1194 --------------
 arch/x86/kernel/setup_percpu.c                     |  399 +++++
 arch/x86/kernel/smpboot.c                          |  212 +--
 arch/x86/kernel/summit_32.c                        |    2 +
 arch/x86/kernel/sys_i386_32.c                      |   64 +-
 arch/x86/kernel/time_32.c                          |    6 +-
 arch/x86/kernel/time_64.c                          |   16 +-
 arch/x86/kernel/tlb_64.c                           |    5 +
 arch/x86/kernel/tlb_uv.c                           |  792 +++++++++
 arch/x86/kernel/trampoline.c                       |    2 +-
 arch/x86/kernel/traps_32.c                         |  190 ++--
 arch/x86/kernel/traps_64.c                         |  516 +++---
 arch/x86/kernel/tsc.c                              |  533 ++++++
 arch/x86/kernel/tsc_32.c                           |  451 -----
 arch/x86/kernel/tsc_64.c                           |  357 ----
 arch/x86/kernel/visws_quirks.c                     |  709 ++++++++
 arch/x86/kernel/vmi_32.c                           |    6 +-
 arch/x86/kernel/vmiclock_32.c                      |    7 +-
 arch/x86/kernel/vmlinux_32.lds.S                   |    7 -
 arch/x86/kernel/vmlinux_64.lds.S                   |    8 +-
 arch/x86/kernel/vsmp_64.c                          |    3 +
 arch/x86/kernel/vsyscall_64.c                      |   12 +-
 arch/x86/kernel/x8664_ksyms_64.c                   |    5 -
 arch/x86/lguest/Kconfig                            |    2 +-
 arch/x86/lguest/boot.c                             |   11 +-
 arch/x86/lib/Makefile                              |    4 +-
 arch/x86/lib/copy_user_64.S                        |  429 ++---
 arch/x86/lib/copy_user_nocache_64.S                |  283 ++--
 arch/x86/lib/{delay_32.c => delay.c}               |   38 +-
 arch/x86/lib/delay_64.c                            |   85 -
 arch/x86/lib/{getuser_64.S => getuser.S}           |   87 +-
 arch/x86/lib/getuser_32.S                          |   78 -
 arch/x86/lib/{putuser_32.S => putuser.S}           |   73 +-
 arch/x86/lib/putuser_64.S                          |  106 --
 arch/x86/lib/usercopy_64.c                         |   23 +
 arch/x86/mach-default/setup.c                      |   74 +-
 arch/x86/mach-es7000/Makefile                      |    1 -
 arch/x86/mach-es7000/es7000plat.c                  |   49 +-
 arch/x86/mach-generic/Makefile                     |   10 +-
 arch/x86/mach-generic/bigsmp.c                     |    4 +-
 arch/x86/mach-generic/numaq.c                      |   41 +
 arch/x86/mach-generic/probe.c                      |   15 +-
 arch/x86/mach-visws/Makefile                       |    8 -
 arch/x86/mach-visws/mpparse.c                      |   88 -
 arch/x86/mach-visws/reboot.c                       |   55 -
 arch/x86/mach-visws/setup.c                        |  183 --
 arch/x86/mach-visws/traps.c                        |   69 -
 arch/x86/mach-visws/visws_apic.c                   |  297 ----
 arch/x86/mach-voyager/setup.c                      |   37 +-
 arch/x86/mach-voyager/voyager_smp.c                |   14 -
 arch/x86/math-emu/reg_constant.c                   |    8 +-
 arch/x86/mm/Makefile                               |    3 +-
 arch/x86/mm/discontig_32.c                         |  285 ++--
 arch/x86/mm/dump_pagetables.c                      |    2 +-
 arch/x86/mm/fault.c                                |   97 +-
 arch/x86/mm/init_32.c                              |  523 +++++--
 arch/x86/mm/init_64.c                              |  552 +++++--
 arch/x86/mm/ioremap.c                              |   26 +-
 arch/x86/mm/k8topology_64.c                        |   21 +-
 arch/x86/mm/numa_64.c                              |   93 +-
 arch/x86/mm/pageattr-test.c                        |   21 +-
 arch/x86/mm/pageattr.c                             |   62 +-
 arch/x86/mm/pat.c                                  |  378 ++---
 arch/x86/mm/pgtable.c                              |  190 ++-
 arch/x86/mm/pgtable_32.c                           |   56 +-
 arch/x86/{kernel => mm}/srat_32.c                  |  222 +--
 arch/x86/mm/srat_64.c                              |   21 +-
 arch/x86/oprofile/nmi_int.c                        |    3 +-
 arch/x86/pci/Makefile                              |   22 +-
 arch/x86/pci/Makefile_32                           |   24 -
 arch/x86/pci/Makefile_64                           |   17 -
 arch/x86/pci/acpi.c                                |   21 +-
 arch/x86/pci/{k8-bus_64.c => amd_bus.c}            |  108 +-
 arch/x86/pci/common.c                              |    4 +-
 arch/x86/pci/direct.c                              |   25 +-
 arch/x86/pci/i386.c                                |    8 +-
 arch/x86/pci/init.c                                |    4 +-
 arch/x86/pci/irq.c                                 |  266 ++--
 arch/x86/pci/legacy.c                              |   16 +-
 arch/x86/pci/mmconfig-shared.c                     |    2 +-
 arch/x86/pci/mp_bus_to_node.c                      |   23 -
 arch/x86/pci/numa.c                                |   33 +-
 arch/x86/pci/pci.h                                 |   13 +-
 arch/x86/pci/visws.c                               |   28 +-
 arch/x86/power/hibernate_64.c                      |    2 +-
 arch/x86/vdso/vdso32-setup.c                       |   11 +-
 arch/x86/vdso/vma.c                                |    2 +-
 arch/x86/xen/Kconfig                               |   10 +
 arch/x86/xen/Makefile                              |    2 +-
 arch/x86/xen/enlighten.c                           |  176 ++-
 arch/x86/xen/manage.c                              |  143 --
 arch/x86/xen/mmu.c                                 |  270 +++-
 arch/x86/xen/mmu.h                                 |   12 +-
 arch/x86/xen/multicalls.c                          |   40 +-
 arch/x86/xen/multicalls.h                          |   12 +
 arch/x86/xen/setup.c                               |   30 +-
 arch/x86/xen/smp.c                                 |    8 +-
 arch/x86/xen/suspend.c                             |   45 +
 arch/x86/xen/time.c                                |   17 +-
 arch/x86/xen/xen-head.S                            |    5 +
 arch/x86/xen/xen-ops.h                             |   13 +-
 drivers/acpi/Kconfig                               |    2 -
 drivers/base/power/trace.c                         |    2 +-
 drivers/base/topology.c                            |   25 +-
 drivers/char/agp/amd64-agp.c                       |   85 +-
 drivers/char/hvc_xen.c                             |   61 +-
 drivers/firmware/Kconfig                           |   10 +
 drivers/firmware/Makefile                          |    1 +
 drivers/firmware/dmi_scan.c                        |    5 +
 drivers/firmware/memmap.c                          |  205 +++
 drivers/input/xen-kbdfront.c                       |   20 +-
 drivers/lguest/Kconfig                             |    2 +-
 drivers/lguest/lg.h                                |    1 -
 drivers/pci/intel-iommu.c                          |   51 +-
 drivers/video/sgivwfb.c                            |    3 +-
 drivers/video/xen-fbfront.c                        |  211 ++-
 drivers/xen/Makefile                               |    2 +-
 drivers/xen/balloon.c                              |   10 +-
 drivers/xen/events.c                               |  114 ++-
 drivers/xen/grant-table.c                          |    4 +-
 drivers/xen/manage.c                               |  252 +++
 drivers/xen/xenbus/xenbus_comms.c                  |   23 +-
 fs/Kconfig                                         |    2 +-
 fs/proc/proc_misc.c                                |   16 +
 include/asm-generic/pgtable.h                      |   57 +
 include/asm-generic/topology.h                     |    3 +-
 include/asm-generic/vmlinux.lds.h                  |   14 +
 include/asm-x86/acpi.h                             |    5 +-
 include/asm-x86/amd_iommu.h                        |   32 +
 include/asm-x86/amd_iommu_types.h                  |  244 +++
 include/asm-x86/apic.h                             |   14 +-
 include/asm-x86/asm.h                              |   55 +-
 include/asm-x86/atomic_64.h                        |   32 +-
 include/asm-x86/bios_ebda.h                        |    2 +
 include/asm-x86/bitops.h                           |   68 +-
 include/asm-x86/bootparam.h                        |    2 +
 include/asm-x86/cmpxchg_64.h                       |   37 +
 include/asm-x86/cpufeature.h                       |    9 +-
 include/asm-x86/current.h                          |   42 +-
 include/asm-x86/current_32.h                       |   17 -
 include/asm-x86/current_64.h                       |   27 -
 include/asm-x86/desc.h                             |   46 +-
 include/asm-x86/desc_defs.h                        |    4 +
 include/asm-x86/dmi.h                              |    8 -
 include/asm-x86/dwarf2.h                           |   62 +-
 include/asm-x86/dwarf2_32.h                        |   61 -
 include/asm-x86/dwarf2_64.h                        |   56 -
 include/asm-x86/e820.h                             |  107 ++-
 include/asm-x86/e820_32.h                          |   50 -
 include/asm-x86/e820_64.h                          |   56 -
 include/asm-x86/efi.h                              |    2 +-
 include/asm-x86/elf.h                              |    2 +-
 include/asm-x86/fixmap.h                           |   55 +
 include/asm-x86/fixmap_32.h                        |   50 +-
 include/asm-x86/fixmap_64.h                        |   59 +-
 include/asm-x86/gart.h                             |   84 +-
 include/asm-x86/genapic_64.h                       |    2 +
 include/asm-x86/hardirq.h                          |    6 +
 include/asm-x86/highmem.h                          |    3 +
 include/asm-x86/hpet.h                             |    2 +-
 include/asm-x86/hw_irq.h                           |  105 ++-
 include/asm-x86/hw_irq_32.h                        |   66 -
 include/asm-x86/hw_irq_64.h                        |  173 --
 include/asm-x86/i8259.h                            |    2 +
 include/asm-x86/io.h                               |   83 +
 include/asm-x86/io_32.h                            |   61 -
 include/asm-x86/io_64.h                            |   71 -
 include/asm-x86/io_apic.h                          |   39 +-
 include/asm-x86/iommu.h                            |   31 +-
 include/asm-x86/ipi.h                              |    1 +
 include/asm-x86/irq.h                              |   51 +-
 include/asm-x86/irq_32.h                           |   51 -
 include/asm-x86/irq_64.h                           |   51 -
 include/asm-x86/irq_vectors.h                      |  169 ++
 include/asm-x86/irqflags.h                         |   41 +-
 include/asm-x86/mach-bigsmp/mach_apic.h            |    2 +-
 include/asm-x86/mach-bigsmp/mach_mpspec.h          |    8 -
 include/asm-x86/mach-default/irq_vectors.h         |   96 --
 include/asm-x86/mach-default/irq_vectors_limits.h  |   16 -
 include/asm-x86/mach-default/mach_apic.h           |    4 +
 include/asm-x86/mach-default/setup_arch.h          |    4 -
 include/asm-x86/mach-default/smpboot_hooks.h       |   10 +-
 include/asm-x86/mach-es7000/mach_mpspec.h          |    8 -
 include/asm-x86/mach-generic/mach_mpparse.h        |    7 +-
 include/asm-x86/mach-numaq/mach_apic.h             |   39 +-
 include/asm-x86/mach-numaq/mach_mpparse.h          |   11 +-
 include/asm-x86/mach-numaq/mach_mpspec.h           |    8 -
 include/asm-x86/mach-summit/mach_mpspec.h          |    9 -
 include/asm-x86/mach-visws/irq_vectors.h           |   62 -
 include/asm-x86/mach-visws/mach_apic.h             |  104 +--
 include/asm-x86/mach-visws/mach_apicdef.h          |   13 +-
 include/asm-x86/mach-visws/setup_arch.h            |    9 +-
 include/asm-x86/mach-visws/smpboot_hooks.h         |   29 +-
 include/asm-x86/mach-voyager/irq_vectors.h         |   79 -
 include/asm-x86/mmconfig.h                         |   12 +
 include/asm-x86/mmu_context.h                      |   32 +
 include/asm-x86/mmu_context_32.h                   |   28 -
 include/asm-x86/mmu_context_64.h                   |   18 -
 include/asm-x86/mmzone_32.h                        |   26 +-
 include/asm-x86/mpspec.h                           |   36 +-
 include/asm-x86/mpspec_def.h                       |    9 +-
 include/asm-x86/msr-index.h                        |    4 +-
 include/asm-x86/msr.h                              |    5 +-
 include/asm-x86/nmi.h                              |   47 +-
 include/asm-x86/numa_32.h                          |    8 +-
 include/asm-x86/numa_64.h                          |   20 +-
 include/asm-x86/numaq.h                            |    8 +-
 include/asm-x86/page.h                             |   12 +-
 include/asm-x86/page_32.h                          |   15 +
 include/asm-x86/page_64.h                          |   18 +-
 include/asm-x86/paravirt.h                         |  197 ++-
 include/asm-x86/pat.h                              |    8 +-
 include/asm-x86/pci.h                              |    2 +
 include/asm-x86/pci_32.h                           |   14 +-
 include/asm-x86/pda.h                              |    5 +-
 include/asm-x86/percpu.h                           |   46 +
 include/asm-x86/pgalloc.h                          |    4 +
 include/asm-x86/pgtable.h                          |  141 +-
 include/asm-x86/pgtable_32.h                       |   20 -
 include/asm-x86/pgtable_64.h                       |    8 +-
 include/asm-x86/processor-flags.h                  |    6 +
 include/asm-x86/processor.h                        |    9 +-
 include/asm-x86/proto.h                            |    2 -
 include/asm-x86/ptrace.h                           |    8 +-
 include/asm-x86/reboot.h                           |    2 +-
 include/asm-x86/required-features.h                |    8 +-
 include/asm-x86/resume-trace.h                     |    2 +-
 include/asm-x86/seccomp_32.h                       |    1 +
 include/asm-x86/seccomp_64.h                       |    1 +
 include/asm-x86/segment.h                          |   23 +-
 include/asm-x86/setup.h                            |   37 +-
 include/asm-x86/smp.h                              |   27 +-
 include/asm-x86/srat.h                             |   12 +-
 include/asm-x86/string_32.h                        |  323 +++--
 include/asm-x86/suspend_32.h                       |    5 +
 include/asm-x86/system.h                           |   10 +-
 include/asm-x86/thread_info.h                      |  248 +++-
 include/asm-x86/thread_info_32.h                   |  205 ---
 include/asm-x86/thread_info_64.h                   |  195 ---
 include/asm-x86/time.h                             |    2 +
 include/asm-x86/timer.h                            |    4 +-
 include/asm-x86/topology.h                         |  157 ++-
 include/asm-x86/tsc.h                              |    2 -
 include/asm-x86/uaccess.h                          |  448 +++++
 include/asm-x86/uaccess_32.h                       |  422 -----
 include/asm-x86/uaccess_64.h                       |  263 +---
 include/asm-x86/unistd_64.h                        |    2 +-
 include/asm-x86/uv/uv_bau.h                        |  337 ++++
 include/asm-x86/uv/uv_hub.h                        |  190 ++-
 include/asm-x86/uv/uv_mmrs.h                       |  954 +++++++++++-
 include/asm-x86/{mach-visws => visws}/cobalt.h     |    0
 include/asm-x86/{mach-visws => visws}/lithium.h    |    0
 include/asm-x86/{mach-visws => visws}/piix4.h      |    0
 include/asm-x86/visws/sgivw.h                      |    5 +
 include/asm-x86/vm86.h                             |   11 +-
 include/asm-x86/vmi_time.h                         |    2 +-
 include/asm-x86/xen/hypercall.h                    |   11 +-
 include/asm-x86/xen/page.h                         |   25 +-
 include/asm-x86/xor_32.h                           |    5 +
 include/asm-x86/xor_64.h                           |    5 +
 include/linux/acpi.h                               |    6 +
 include/linux/bootmem.h                            |    2 +
 include/linux/console.h                            |    2 +
 include/linux/delay.h                              |    1 +
 include/linux/efi.h                                |    4 -
 include/linux/firmware-map.h                       |   74 +
 include/linux/kernel_stat.h                        |    2 +-
 include/linux/linkage.h                            |    4 +
 include/linux/mm.h                                 |    7 +-
 include/linux/page-flags.h                         |    1 +
 include/linux/pageblock-flags.h                    |    8 +-
 include/linux/resume-trace.h                       |    2 +-
 include/xen/events.h                               |    4 +
 include/xen/grant_table.h                          |    3 +
 include/xen/hvc-console.h                          |    9 +
 include/xen/interface/elfnote.h                    |   20 +
 include/xen/interface/features.h                   |    3 +
 include/xen/interface/io/fbif.h                    |   29 +-
 include/xen/interface/io/kbdif.h                   |    2 +
 include/xen/interface/memory.h                     |   12 +-
 include/xen/interface/xen.h                        |    9 +-
 include/xen/xen-ops.h                              |    6 +
 init/calibrate.c                                   |   60 +-
 kernel/printk.c                                    |    5 +
 kernel/sched.c                                     |   18 +-
 kernel/time/tick-broadcast.c                       |    6 +-
 mm/mprotect.c                                      |   10 +-
 mm/page_alloc.c                                    |   94 +-
 sound/oss/vwsnd.c                                  |    2 +-
 407 files changed, 24394 insertions(+), 16658 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-memmap
 rename Documentation/{ => x86}/i386/IO-APIC.txt (100%)
 rename Documentation/{ => x86}/i386/boot.txt (96%)
 rename Documentation/{ => x86}/i386/usb-legacy-support.txt (100%)
 rename Documentation/{ => x86}/i386/zero-page.txt (100%)
 rename Documentation/{ => x86}/x86_64/00-INDEX (100%)
 rename Documentation/{ => x86}/x86_64/boot-options.txt (100%)
 rename Documentation/{ => x86}/x86_64/cpu-hotplug-spec (100%)
 rename Documentation/{ => x86}/x86_64/fake-numa-for-cpusets (100%)
 rename Documentation/{ => x86}/x86_64/kernel-stacks (100%)
 rename Documentation/{ => x86}/x86_64/machinecheck (100%)
 rename Documentation/{ => x86}/x86_64/mm.txt (87%)
 rename Documentation/{ => x86}/x86_64/uefi.txt (84%)
 create mode 100644 arch/x86/kernel/amd_iommu.c
 create mode 100644 arch/x86/kernel/amd_iommu_init.c
 create mode 100644 arch/x86/kernel/cpu/amd_64.c
 rename arch/x86/kernel/{ => cpu}/bugs_64.c (100%)
 create mode 100644 arch/x86/kernel/cpu/centaur_64.c
 create mode 100644 arch/x86/kernel/cpu/common_64.c
 create mode 100644 arch/x86/kernel/cpu/intel_64.c
 create mode 100644 arch/x86/kernel/e820.c
 delete mode 100644 arch/x86/kernel/e820_32.c
 delete mode 100644 arch/x86/kernel/e820_64.c
 create mode 100644 arch/x86/kernel/head.c
 rename arch/x86/kernel/{i8259_32.c => i8259.c} (70%)
 delete mode 100644 arch/x86/kernel/i8259_64.c
 create mode 100644 arch/x86/kernel/irqinit_32.c
 create mode 100644 arch/x86/kernel/irqinit_64.c
 rename arch/x86/kernel/{nmi_32.c => nmi.c} (68%)
 delete mode 100644 arch/x86/kernel/nmi_64.c
 create mode 100644 arch/x86/kernel/probe_roms_32.c
 delete mode 100644 arch/x86/kernel/setup64.c
 delete mode 100644 arch/x86/kernel/setup_32.c
 delete mode 100644 arch/x86/kernel/setup_64.c
 create mode 100644 arch/x86/kernel/setup_percpu.c
 create mode 100644 arch/x86/kernel/tlb_uv.c
 create mode 100644 arch/x86/kernel/tsc.c
 delete mode 100644 arch/x86/kernel/tsc_32.c
 delete mode 100644 arch/x86/kernel/tsc_64.c
 create mode 100644 arch/x86/kernel/visws_quirks.c
 rename arch/x86/lib/{delay_32.c => delay.c} (88%)
 delete mode 100644 arch/x86/lib/delay_64.c
 rename arch/x86/lib/{getuser_64.S => getuser.S} (53%)
 delete mode 100644 arch/x86/lib/getuser_32.S
 rename arch/x86/lib/{putuser_32.S => putuser.S} (54%)
 delete mode 100644 arch/x86/lib/putuser_64.S
 create mode 100644 arch/x86/mach-generic/numaq.c
 delete mode 100644 arch/x86/mach-visws/Makefile
 delete mode 100644 arch/x86/mach-visws/mpparse.c
 delete mode 100644 arch/x86/mach-visws/reboot.c
 delete mode 100644 arch/x86/mach-visws/setup.c
 delete mode 100644 arch/x86/mach-visws/traps.c
 delete mode 100644 arch/x86/mach-visws/visws_apic.c
 rename arch/x86/{kernel => mm}/srat_32.c (56%)
 delete mode 100644 arch/x86/pci/Makefile_32
 delete mode 100644 arch/x86/pci/Makefile_64
 rename arch/x86/pci/{k8-bus_64.c => amd_bus.c} (91%)
 delete mode 100644 arch/x86/pci/mp_bus_to_node.c
 delete mode 100644 arch/x86/xen/manage.c
 create mode 100644 arch/x86/xen/suspend.c
 create mode 100644 drivers/firmware/memmap.c
 create mode 100644 drivers/xen/manage.c
 create mode 100644 include/asm-x86/amd_iommu.h
 create mode 100644 include/asm-x86/amd_iommu_types.h
 delete mode 100644 include/asm-x86/current_32.h
 delete mode 100644 include/asm-x86/current_64.h
 delete mode 100644 include/asm-x86/dwarf2_32.h
 delete mode 100644 include/asm-x86/dwarf2_64.h
 delete mode 100644 include/asm-x86/e820_32.h
 delete mode 100644 include/asm-x86/e820_64.h
 delete mode 100644 include/asm-x86/hw_irq_32.h
 delete mode 100644 include/asm-x86/hw_irq_64.h
 delete mode 100644 include/asm-x86/irq_32.h
 delete mode 100644 include/asm-x86/irq_64.h
 create mode 100644 include/asm-x86/irq_vectors.h
 delete mode 100644 include/asm-x86/mach-bigsmp/mach_mpspec.h
 delete mode 100644 include/asm-x86/mach-default/irq_vectors.h
 delete mode 100644 include/asm-x86/mach-default/irq_vectors_limits.h
 delete mode 100644 include/asm-x86/mach-es7000/mach_mpspec.h
 delete mode 100644 include/asm-x86/mach-numaq/mach_mpspec.h
 delete mode 100644 include/asm-x86/mach-summit/mach_mpspec.h
 delete mode 100644 include/asm-x86/mach-visws/irq_vectors.h
 delete mode 100644 include/asm-x86/mach-voyager/irq_vectors.h
 create mode 100644 include/asm-x86/mmconfig.h
 delete mode 100644 include/asm-x86/thread_info_32.h
 delete mode 100644 include/asm-x86/thread_info_64.h
 create mode 100644 include/asm-x86/uv/uv_bau.h
 rename include/asm-x86/{mach-visws => visws}/cobalt.h (100%)
 rename include/asm-x86/{mach-visws => visws}/lithium.h (100%)
 rename include/asm-x86/{mach-visws => visws}/piix4.h (100%)
 create mode 100644 include/asm-x86/visws/sgivw.h
 create mode 100644 include/linux/firmware-map.h

