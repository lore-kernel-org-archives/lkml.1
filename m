Return-Path: <linux-kernel-owner+w=401wt.eu-S1761393AbZC1WDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393AbZC1WDw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 18:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761058AbZC1WDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 18:03:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41464 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbZC1WDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 18:03:33 -0400
Date: Sat, 28 Mar 2009 23:03:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 updates for v2.6.30, final bits
Message-ID: <20090328220307.GA16314@elte.hu>
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

Please pull the latest x86-stage-3-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-stage-3-for-linus

This concludes the x86 merge window.

The MM PAT bits touching mm/memory.c and include/linux/mm.h were 
reviewed and acked by Nick, the DMAR bits are part of a longer 
x2apic fix series from Suresh. (Jesse Cc:-ed)

[ The sched.c bit is an odd one out: due to previous cpumask changes 
  it developed a dependency/conflict on the cpumask tree which 
  depended on the x86 tree. Should i have started a separate branch 
  for it? I didnt want to merge the x86 tree into the scheduler 
  tree. We had really excessive dependencies and cross-merges in
  this cycle around the x86 tree and i very much hope this is an
  exception - there's been too many infrastructure projects going on
  in parallel. Nothing of this scale will happen in the .31 cycle -
  with the TLB, APIC, percpu unification in this cycle we've
  modernized and unified the whole x86 infrastructure. Future work
  will interact a lot less. ]

out-of-topic modifications in x86-stage-3-for-linus:
----------------------------------------------------
drivers/pci/dmar.c                 # fa4b57c: x86, dmar: use atomic allocations
                                   # 1531a6a: x86, dmar: start with sane state 
                                   # eba67e5: x86, dmar: routines for disabling
                                   # 9d783ba: x86, x2apic: enable fault handlin
                                   # 0ac2491: x86, dmar: move page fault handli
drivers/pci/intel-iommu.c          # 1531a6a: x86, dmar: start with sane state 
                                   # 9d783ba: x86, x2apic: enable fault handlin
                                   # 0ac2491: x86, dmar: move page fault handli
drivers/pci/intr_remapping.c       # fa4b57c: x86, dmar: use atomic allocations
                                   # 2e93456: x86, intr-remapping: fix free_irt
                                   # 1531a6a: x86, dmar: start with sane state 
                                   # eba67e5: x86, dmar: routines for disabling
                                   # 9d783ba: x86, x2apic: enable fault handlin
                                   # 4c5502b: x86, x2apic: fix lock ordering du
include/linux/dmar.h               # 29b61be: x86, x2apic: cleanup ifdef CONFIG
                                   # 1531a6a: x86, dmar: start with sane state 
                                   # 9d783ba: x86, x2apic: enable fault handlin
include/linux/intel-iommu.h        # eba67e5: x86, dmar: routines for disabling
                                   # 9d783ba: x86, x2apic: enable fault handlin
include/linux/mm.h                 # 895791d: VM, x86, PAT: add a new vm flag t
                                   # 4bb9c5c: VM, x86, PAT: Change is_linear_pf
kernel/sched.c                     # 7a46c59: cpuacct: reduce one NULL check in
mm/memory.c                        # 895791d: VM, x86, PAT: add a new vm flag t
                                   # 4bb9c5c: VM, x86, PAT: Change is_linear_pf

Known risks:

 - We had some boot regression trouble with the e820 changes, on 
   systems with odd/small memory layouts:

      x86: fix e820_update_range()
      x86: make e820_update_range() handle small range update

 - The very-early-brk changes had several regressions along the way:

      x86: add brk allocation for very, very early allocations

 - The IO-APIC/APIC cleanups were relatively trouble-free, but that 
   code is always a risk area.

 - No known regressions at the moment.

 Thanks,

	Ingo

------------------>
Akinobu Mita (3):
      x86: unify kmap_atomic_pfn() and iomap_atomic_prot_pfn()
      x86: debug check for kmap_atomic_pfn and iomap_atomic_prot_pfn()
      x86, mm: remove unnecessary include file from iomap_32.c

Américo Wang (1):
      x86: ptrace, bts: fix an unreachable statement

Andi Kleen (19):
      x86, mce: disable machine checks on suspend
      x86, mce: don't disable machine checks during code patching
      x86, mce: always use separate work queue to run trigger
      x86, mce: switch machine check polling to per CPU timer
      x86, mce: don't set up mce sysdev devices with mce=off
      x86, mce: disable machine checks on offlined CPUs
      x86, mce: enable machine checks in 64-bit defconfig
      x86, mce: implement dynamic machine check banks support
      x86, mce: factor out duplicated struct mce setup into one function
      x86, mce: separate correct machine check poller and fatal exception handler
      x86, mce, cmci: export MAX_NR_BANKS
      x86, mce, cmci: factor out threshold interrupt handler
      x86, mce, cmci: avoid potential reentry of threshold interrupt
      x86, mce: replace machine check events logged interval with ratelimit
      x86, mce, cmci: use polled banks bitmap in machine check poller
      x86, mce, cmci: define MSR names and fields for new CMCI registers
      x86, mce, cmci: add CMCI support
      x86, mce, cmci: disable CMCI on rebooting
      x86, mce, cmci: recheck CMCI banks after APIC has been enabled on CPU #0

Andreas Herrmann (1):
      x86: mtrr: don't modify RdDram/WrDram bits of fixed MTRRs

Andrew Morton (1):
      x86: use smp_call_function_single() in arch/x86/kernel/cpu/mcheck/mce_amd_64.c

Bartlomiej Zolnierkiewicz (1):
      x86: fix IO APIC resource allocation error message

Cyrill Gorcunov (2):
      x86: linkage.h - guard assembler specifics by __ASSEMBLY__
      x86: shrink __ALIGN and __ALIGN_STR definitions

Dimitri Sivanich (4):
      x86: UV, SGI RTC: add generic system vector
      x86: UV, SGI RTC: loop through installed UV blades
      x86: UV, SGI RTC: add UV RTC clocksource/clockevents
      x86: UV, SGI RTC: fix uv_time.c for UP

Dmitri Vorobiev (1):
      x86: Fix a couple of sparse warnings in arch/x86/kernel/apic/io_apic.c

H. Peter Anvin (11):
      x86, mce: use %ll instead of %L for 64-bit numbers
      x86, mce: remove invalid __cpuinit/__cpuexit annotations
      x86, mce, cmci: remove incorrect __cpuinit/__cpuexit annotations
      x86: remove zImage support
      x86: remove additional vestiges of the zImage/bzImage split
      x86: use targets in the boot Makefile instead of CLEAN_FILES
      x86: move brk initialization out of #ifdef CONFIG_BLK_DEV_INITRD
      x86-32: tighten the bound on additional memory to map
      x86-32: move _end to a dummy section
      x86, setup: move 32-bit code to .text32
      x86, setup: fix the setting of 480-line VGA modes

Hidetoshi Seto (1):
      x86, mce: remove incorrect __cpuinit for intel_init_cmci()

Hiroshi Shimamoto (1):
      x86: signal: check signal stack overflow properly

Huang Ying (4):
      x86, mce: fix a race condition in mce_read()
      x86, kexec: fix kexec x86 coding style
      x86, kexec: x86_64: add identity map for pages at image->start
      x86, kexec: x86_64: add kexec jump support for x86_64

Ingo Molnar (7):
      x86, mce: fix build failure in arch/x86/kernel/cpu/mcheck/threshold.c
      x86: move init_memory_mapping() to common mm/init.c, build fix on 32-bit PAE
      x86: UV, SGI RTC: add generic system vector, build fix on UP
      x86: memcpy, clean up
      x86: unify kmap_atomic_pfn() and iomap_atomic_prot_pfn(), fix
      x86: cpu/common.c more cleanups
      x86: mpparse: clean up code by introducing a few helper functions, fix

Jan Beulich (14):
      x86: remove leftover unwind annotations
      x86-64: move save_paranoid into .kprobes.text
      x86-64: remove unnecessary spill/reload of rbx from memcpy
      x86: fix HYPERVISOR_update_descriptor()
      x86: move a few device initialization objects into .devinit.rodata
      x86: move various CPU initialization objects into .cpuinit.rodata
      x86: smarten /proc/interrupts output
      x86, 32-bit: also limit NODES_HIGH_SHIFT here
      x86, 32-bit: also use cpuinfo_x86's x86_{phys,virt}_bits members
      x86: move save_mr() into .meminit.text
      x86: properly __init-annotate recent early_printk additions
      x86: clean up output resulting from update_mptable option
      x86: fix code paths used by update_mptable
      x86: create a non-zero sized bm_pte only when needed

Jaswinder Singh Rajput (22):
      x86: cpu architecture debug code
      x86: cpu architecture debug code, build fix, cleanup
      x86: cpu_debug add write support for MSRs
      x86: cpu/common.c cleanups
      x86: entry_32.S fix compile warnings - fix work mask bit width
      x86: cpu_debug add support for various AMD CPUs
      x86: cpu/mttr/cleanup.c fix compilation warning
      x86: kprobes.c fix compilation warning
      x86: mpparse: clean up code by introducing a few helper functions
      x86: mpparse.c introduce smp_dump_mptable helper function
      x86: mpparse.c introduce check_physptr helper function
      x86: topology.c cleanup
      x86: kdebugfs.c cleanup
      x86: i8253 cleanup
      x86: rtc.c cleanup
      x86: io_delay.c cleanup
      x86: pci-nommu.c cleanup
      x86: cpu/cpu.h cleanup
      x86: irq.c use same path for show_interrupts
      x86: irq.c keep CONFIG_X86_LOCAL_APIC interrupts together
      x86: apic/io_apic.c define msi_ir_chip and ir_ioapic_chip all the time
      x86: e820 fix various signedness issues in setup.c and e820.c

Jeremy Fitzhardinge (18):
      x86: clean up old gcc warnings
      x86-32: use specific __vmalloc_start_set flag in __virt_addr_valid
      x86: pre-initialize boot_cpu_data.x86_phys_bits to avoid system_state tests
      x86-32: make sure virt_addr_valid() returns false for fixmap addresses
      x86: make section delimiter symbols part of their section
      x86: add brk allocation for very, very early allocations
      x86-32: use brk segment for allocating initial kernel pagetable
      x86: use brk allocation for DMI
      x86: allow extend_brk users to reserve brk space
      x86, paravirt: prevent gcc from generating the wrong addressing mode
      x86-32: make sure we map enough to fit linear map pagetables
      x86-32: remove ALLOCATOR_SLOP from head_32.S
      x86/brk: make the brk reservation symbols inaccessible from C
      x86/brk: put the brk reservations in their own section
      x86/32: no need to use set_pte_present in set_pte_vaddr
      x86: with the last user gone, remove set_pte_present
      Revert "x86: create a non-zero sized bm_pte only when needed"
      x86/dmi: fix dmi_alloc() section mismatches

KOSAKI Motohiro (1):
      x86, mce: use round_jiffies() instead round_jiffies_relative()

Li Zefan (1):
      cpuacct: reduce one NULL check in fast-path

Pallipadi, Venkatesh (3):
      VM, x86, PAT: Change is_linear_pfn_mapping to not use vm_pgoff
      VM, x86, PAT: add a new vm flag to track full pfnmap at mmap
      x86, PAT, PCI: Change vma prot in pci_mmap to reflect inherited prot

Pekka Enberg (22):
      x86: move devmem_is_allowed() to common mm/init.c
      x86: set_highmem_pages_init() cleanup, #2
      x86: move free_initrd_mem() to common mm/init.c
      x86: init_memory_mapping() trivial cleanups
      x86: add gbpages support to 32-bit init_memory_mapping()
      x86: find_early_table_space() unification
      x86: move pgd_base out of init_memory_mapping()
      x86: ifdef 32-bit specific setup in init_memory_mapping()
      x86: remove unnecessary save_mr() sanity check
      x86: rename after_init_bootmem to after_bootmem in mm/init_32.c
      x86: unify kernel_physical_mapping_init() call in init_memory_mapping()
      x86: add table start and end sanity checks to 32-bit init_memory_mapping()
      x86: ifdef 32-bit and 64-bit setup in init_memory_mapping()
      x86: ifdef 32-bit and 64-bit pfn setup in init_memory_mapping()
      x86: ifdef 32-bit and 64-bit NR_RANGE_MR for save_mr() unification
      x86: add stub init_gbpages() for 32-bit init_memory_mapping()
      x86: move init_memory_mapping() to common mm/init.c
      x86: fix up some bad global variable names in mm/init.c
      x86: unify kernel_physical_mapping_init() function signatures
      x86: move function and variable declarations to asm/init.h
      x86: fix uninitialized variable in init_memory_mapping()
      x86: rename do_not_nx to disable_nx in mm/init_64.c

Ravikiran G Thirumalai (1):
      Revert "x86: don't compile vsmp_64 for 32bit"

Rusty Russell (2):
      x86, uv: fix cpumask iterator in uv_bau_init()
      x86: Correct behaviour of irq affinity

Sebastian Andrzej Siewior (1):
      x86/centaur: merge 32 & 64 bit version

Stoyan Gaydarov (1):
      x86: BUG to BUG_ON changes

Stuart Bennett (1):
      x86: mmiotrace: quieten spurious warning message

Suresh Siddha (14):
      x86, x2apic: fix lock ordering during IRQ migration
      x86, dmar: move page fault handling code to dmar.c
      x86, x2apic: enable fault handling for intr-remapping
      x86, dmar: routines for disabling queued invalidation and intr remapping
      x86, dmar: start with sane state while enabling dma and interrupt-remapping
      x86, intr-remapping: fix free_irte() to clear all the IRTE entries
      x86, x2apic: use virtual wire A mode in disable_IO_APIC() with interrupt-remapping
      x86, x2apic: fix clear_local_APIC() in the presence of x2apic
      x86, x2apic: cleanup the IO-APIC level migration with interrupt-remapping
      x86, x2apic: cleanup ifdef CONFIG_INTR_REMAP in io_apic code
      x86, ioapic: Fix non atomic allocation with interrupts disabled
      x86: fix broken irq migration logic while cleaning up multiple vectors
      x86, dmar: use atomic allocations for QI and Intr-remapping init
      x86: add x2apic_wrmsr_fence() to x2apic flush tlb paths

Thomas Gleixner (3):
      x86: convert obsolete irq_desc_t typedef to struct irq_desc
      x86: disable __do_IRQ support
      x86: reduce preemption off section in exit thread

Wang Chen (2):
      x86: don't define __this_fixmap_does_not_exist()
      x86: early_ioremap_init(), use __fix_to_virt(), because we are sure it's safe

Yinghai Lu (23):
      x86: fix bootmem cross node for 32bit numa
      x86: make 32-bit init_memory_mapping range change more like 64-bit
      x86: ioremap mptable
      x86: reserve exact size of mptable
      x86: fix bootmem cross node for 32bit numa, cleanup
      x86/doc: mini-howto for using earlyprintk=dbgp
      x86: make "memtest" like "memtest=17"
      x86: remove smp_apply_quirks()/smp_checks()
      x86: fix warning about nodeid
      x86: more MTRR debug printouts
      x86: print out mtrr_range_state when user specify size
      x86: separate mtrr cleanup/mtrr_e820 trim to separate file
      x86: fix e820_update_range()
      x86: make e820_update_range() handle small range update
      x86: fix get_mtrr() warning about smp_processor_id() with CONFIG_PREEMPT=y
      x86: print the continous part of fixed mtrrs together
      x86-32: compute initial mapping size more accurately
      x86: put initial_pg_tables into .bss
      x86: fix 64k corruption-check
      x86: print out more info in e820_update_range()
      x86: MTRR workaround for system with stange var MTRRs
      x86: fix set_extra_move_desc calling
      x86: use default_cpu_mask_to_apicid for 64bit

venkatesh.pallipadi@intel.com (3):
      x86, CPA: Add a flag parameter to cpa set_clr()
      x86, PAT: Add support for struct page pointer array in cpa set_clr
      x86, CPA: Add set_pages_arrayuc and set_pages_array_wb


 Documentation/x86/earlyprintk.txt          |  101 +++
 arch/x86/Kconfig                           |   15 +-
 arch/x86/Kconfig.cpu                       |   17 +-
 arch/x86/Makefile                          |   29 +-
 arch/x86/boot/Makefile                     |   53 +-
 arch/x86/boot/header.S                     |   29 +-
 arch/x86/boot/pm.c                         |   44 --
 arch/x86/boot/pmjump.S                     |    1 +
 arch/x86/boot/setup.ld                     |    3 +-
 arch/x86/boot/tools/build.c                |    9 +-
 arch/x86/boot/video-vga.c                  |   22 +-
 arch/x86/include/asm/apic.h                |   37 +-
 arch/x86/include/asm/apicdef.h             |    1 +
 arch/x86/include/asm/boot.h                |    4 -
 arch/x86/include/asm/cacheflush.h          |    3 +
 arch/x86/include/asm/cpu_debug.h           |  226 ++++++
 arch/x86/include/asm/desc.h                |    3 +-
 arch/x86/include/asm/dmi.h                 |   19 +-
 arch/x86/include/asm/e820.h                |    2 +-
 arch/x86/include/asm/entry_arch.h          |    2 +
 arch/x86/include/asm/hardirq.h             |    1 +
 arch/x86/include/asm/highmem.h             |    1 +
 arch/x86/include/asm/hw_irq.h              |    1 +
 arch/x86/include/asm/init.h                |   18 +
 arch/x86/include/asm/io_apic.h             |    5 +-
 arch/x86/include/asm/irq.h                 |    1 +
 arch/x86/include/asm/irq_remapping.h       |    2 -
 arch/x86/include/asm/irq_vectors.h         |    5 +
 arch/x86/include/asm/kexec.h               |   13 +-
 arch/x86/include/asm/linkage.h             |   19 +-
 arch/x86/include/asm/mce.h                 |   35 +-
 arch/x86/include/asm/msidef.h              |    1 +
 arch/x86/include/asm/msr-index.h           |    5 +
 arch/x86/include/asm/page_32_types.h       |    5 +
 arch/x86/include/asm/page_types.h          |    6 -
 arch/x86/include/asm/paravirt.h            |   19 +-
 arch/x86/include/asm/pat.h                 |    5 +
 arch/x86/include/asm/pgtable-2level.h      |    7 -
 arch/x86/include/asm/pgtable-3level.h      |   17 -
 arch/x86/include/asm/pgtable.h             |    2 -
 arch/x86/include/asm/pgtable_32.h          |    3 -
 arch/x86/include/asm/pgtable_32_types.h    |    5 +
 arch/x86/include/asm/pgtable_types.h       |    1 +
 arch/x86/include/asm/processor.h           |    5 +-
 arch/x86/include/asm/sections.h            |    7 +
 arch/x86/include/asm/setup.h               |   39 +-
 arch/x86/include/asm/uv/uv_hub.h           |    4 +
 arch/x86/include/asm/xen/hypercall.h       |    2 +
 arch/x86/kernel/Makefile                   |    4 +-
 arch/x86/kernel/alternative.c              |   17 +-
 arch/x86/kernel/apic/apic.c                |   35 +-
 arch/x86/kernel/apic/apic_flat_64.c        |   18 +-
 arch/x86/kernel/apic/io_apic.c             |  292 ++++----
 arch/x86/kernel/apic/probe_64.c            |    7 +
 arch/x86/kernel/apic/x2apic_cluster.c      |    6 +
 arch/x86/kernel/apic/x2apic_phys.c         |    6 +
 arch/x86/kernel/check.c                    |    8 +-
 arch/x86/kernel/cpu/Makefile               |    5 +-
 arch/x86/kernel/cpu/addon_cpuid_features.c |    2 +-
 arch/x86/kernel/cpu/amd.c                  |   54 ++-
 arch/x86/kernel/cpu/centaur.c              |   36 +-
 arch/x86/kernel/cpu/centaur_64.c           |   37 -
 arch/x86/kernel/cpu/common.c               |  396 ++++++-----
 arch/x86/kernel/cpu/cpu.h                  |   25 +-
 arch/x86/kernel/cpu/cpu_debug.c            |  901 +++++++++++++++++++++++
 arch/x86/kernel/cpu/cyrix.c                |   16 +-
 arch/x86/kernel/cpu/intel.c                |   32 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c      |    8 +-
 arch/x86/kernel/cpu/mcheck/Makefile        |    1 +
 arch/x86/kernel/cpu/mcheck/mce_32.c        |   14 -
 arch/x86/kernel/cpu/mcheck/mce_64.c        |  530 ++++++++++----
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c    |   62 +-
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c  |  207 ++++++-
 arch/x86/kernel/cpu/mcheck/threshold.c     |   29 +
 arch/x86/kernel/cpu/mtrr/Makefile          |    2 +-
 arch/x86/kernel/cpu/mtrr/cleanup.c         | 1101 ++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mtrr/generic.c         |  202 ++++--
 arch/x86/kernel/cpu/mtrr/main.c            | 1069 +--------------------------
 arch/x86/kernel/cpu/mtrr/mtrr.h            |    4 +
 arch/x86/kernel/cpu/transmeta.c            |    2 +-
 arch/x86/kernel/cpu/umc.c                  |    2 +-
 arch/x86/kernel/e820.c                     |  142 +++--
 arch/x86/kernel/early_printk.c             |   20 +-
 arch/x86/kernel/entry_32.S                 |   18 +-
 arch/x86/kernel/entry_64.S                 |    6 +-
 arch/x86/kernel/head32.c                   |    5 +-
 arch/x86/kernel/head64.c                   |    2 +-
 arch/x86/kernel/head_32.S                  |   76 +-
 arch/x86/kernel/i8253.c                    |   68 +-
 arch/x86/kernel/io_delay.c                 |   27 +-
 arch/x86/kernel/irq.c                      |   88 ++-
 arch/x86/kernel/irqinit_32.c               |    3 +
 arch/x86/kernel/irqinit_64.c               |    3 +
 arch/x86/kernel/kdebugfs.c                 |   82 +--
 arch/x86/kernel/kprobes.c                  |    2 +-
 arch/x86/kernel/kvm.c                      |    7 -
 arch/x86/kernel/machine_kexec_32.c         |   17 +-
 arch/x86/kernel/machine_kexec_64.c         |   99 +++-
 arch/x86/kernel/mmconf-fam10h_64.c         |    2 +-
 arch/x86/kernel/mpparse.c                  |  384 +++++-----
 arch/x86/kernel/paravirt.c                 |    1 -
 arch/x86/kernel/pci-nommu.c                |   20 +-
 arch/x86/kernel/process.c                  |    5 +-
 arch/x86/kernel/ptrace.c                   |    3 +-
 arch/x86/kernel/quirks.c                   |    3 +-
 arch/x86/kernel/relocate_kernel_32.S       |   24 +-
 arch/x86/kernel/relocate_kernel_64.S       |  189 ++++-
 arch/x86/kernel/rtc.c                      |   20 +-
 arch/x86/kernel/setup.c                    |   58 +-
 arch/x86/kernel/signal.c                   |   48 +-
 arch/x86/kernel/smpboot.c                  |   78 --
 arch/x86/kernel/tlb_uv.c                   |    3 +-
 arch/x86/kernel/topology.c                 |   14 +-
 arch/x86/kernel/uv_time.c                  |  393 ++++++++++
 arch/x86/kernel/visws_quirks.c             |    2 +-
 arch/x86/kernel/vmi_32.c                   |    6 -
 arch/x86/kernel/vmlinux_32.lds.S           |   21 +-
 arch/x86/kernel/vmlinux_64.lds.S           |  101 ++-
 arch/x86/kernel/vsmp_64.c                  |   12 +-
 arch/x86/lguest/boot.c                     |    8 -
 arch/x86/lib/memcpy_64.S                   |  143 ++--
 arch/x86/mm/highmem_32.c                   |   24 +-
 arch/x86/mm/init.c                         |  344 +++++++++
 arch/x86/mm/init_32.c                      |  256 ++-----
 arch/x86/mm/init_64.c                      |  280 +-------
 arch/x86/mm/iomap_32.c                     |   26 +-
 arch/x86/mm/ioremap.c                      |   52 +-
 arch/x86/mm/kmmio.c                        |    2 +-
 arch/x86/mm/memtest.c                      |    3 +
 arch/x86/mm/numa_32.c                      |    5 +-
 arch/x86/mm/pageattr.c                     |  147 +++-
 arch/x86/mm/pat.c                          |    5 +-
 arch/x86/mm/pgtable_32.c                   |    2 +-
 arch/x86/mm/tlb.c                          |    5 -
 arch/x86/pci/common.c                      |    4 +-
 arch/x86/pci/fixup.c                       |    4 +-
 arch/x86/pci/i386.c                        |    3 +
 arch/x86/xen/mmu.c                         |    7 +-
 drivers/pci/dmar.c                         |  296 ++++++++-
 drivers/pci/intel-iommu.c                  |  220 +-----
 drivers/pci/intr_remapping.c               |  110 ++-
 include/linux/dmar.h                       |   52 ++-
 include/linux/intel-iommu.h                |    5 +-
 include/linux/mm.h                         |    3 +-
 kernel/sched.c                             |    5 +-
 mm/memory.c                                |    6 +-
 146 files changed, 6468 insertions(+), 3585 deletions(-)
 create mode 100644 Documentation/x86/earlyprintk.txt
 create mode 100755 arch/x86/include/asm/cpu_debug.h
 create mode 100644 arch/x86/include/asm/init.h
 delete mode 100644 arch/x86/kernel/cpu/centaur_64.c
 create mode 100755 arch/x86/kernel/cpu/cpu_debug.c
 create mode 100644 arch/x86/kernel/cpu/mcheck/threshold.c
 create mode 100644 arch/x86/kernel/cpu/mtrr/cleanup.c
 create mode 100644 arch/x86/kernel/uv_time.c

