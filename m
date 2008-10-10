Return-Path: <linux-kernel-owner+w=401wt.eu-S1761571AbYJJSmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761571AbYJJSmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 14:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758981AbYJJSmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 14:42:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52954 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758159AbYJJSmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 14:42:14 -0400
Date: Fri, 10 Oct 2008 20:41:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull, take 2] x86 updates for v2.6.28, phase #6, misc
Message-ID: <20081010184135.GC21876@elte.hu>
References: <20081010000817.GA9266@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010000817.GA9266@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Linus,
> 
> Please pull the latest x86-v28-for-linus-phase6 git tree from:
> 
> tip/x86/core: various x86 updates independent of the sparse irqs support 
> tree.

updated pull request below. Beyond the x86/pat updates, it grew these 
fresh commits:

 43603c8: x86, debug: print more information about unknown CPUs
 6bee185: Merge branch 'x86/quirks' into x86/core
 8d89adf: x86: SB450: deprioritize DMI quirks
 33fb0e4: x86: SB450: skip IRQ0 override if it is not routed to INT2 of IOAPIC

pull request is relative to x86-v28-for-linus-phase5-B.

	Ingo

----------------->
Linus,

Please pull the latest x86-v28-for-linus-phase6-B git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-v28-for-linus-phase6-B


out-of-topic modifications in x86-v28-for-linus-phase6-B:
---------------------------------------------------------
include/linux/kernel.h             # d974ae3: generic, memparse(): constify arg
include/linux/mm.h                 # f7d0b92: mm: define USE_SPLIT_PTLOCKS rath
                                   # 59ea746: MM: virtual address debug
include/linux/mm_types.h           # f7d0b92: mm: define USE_SPLIT_PTLOCKS rath
include/linux/mmdebug.h            # 7aa413d: x86, MM: virtual address debug, c
                                   # 59ea746: MM: virtual address debug
lib/cmdline.c                      # d974ae3: generic, memparse(): constify arg
mm/vmalloc.c                       # 7aa413d: x86, MM: virtual address debug, c
                                   # 59ea746: MM: virtual address debug

 Thanks,

	Ingo

------------------>
Alex Nixon (10):
      x86: add cpu hotplug hooks into smp_ops
      x86_32: clean up play_dead
      x86: unify x86_32 and x86_64 play_dead into one function
      x86: separate generic cpu disabling code from APIC writes in cpu_disable
      xen: implement CPU hotplugging
      Xen: fix cpu_hotplug.c build by replacing is_running_on_xen() with xen_pv_domain()
      Xen: fix cpu_hotplug build when !CONFIG_SMP
      x86: build fix for !CONFIG_SMP
      x86, xen: fix build when !CONFIG_HOTPLUG_CPU
      xen: make CPU hotplug functions static

Alexander van Heukelum (47):
      i386: remove kprobes' restore_interrupts in favour of conditional_sti
      i386: prepare to convert exceptions to interrupts
      i386: convert hardware exception 0 to an interrupt gate
      i386: expand exception 3 DO_TRAP macro
      i386: convert hardware exception 4 to an interrupt gate
      i386: convert hardware exception 5 to an interrupt gate
      i386: convert hardware exception 6 to an interrupt gate
      i386: convert hardware exception 7 to an interrupt gate
      i386: convert hardware exception 9 to an interrupt gate
      i386: convert hardware exception 10 to an interrupt gate
      i386: convert hardware exception 11 to an interrupt gate
      i386: convert hardware exception 12 to an interrupt gate
      i386: convert hardware exception 13 to an interrupt gate
      i386: convert hardware exception 15 to an interrupt gate
      i386: convert hardware exception 16 to an interrupt gate
      i386: convert hardware exception 17 to an interrupt gate
      i386: convert hardware exception 18 to an interrupt gate
      i386: convert hardware exception 19 to an interrupt gate
      i386: remove temporary DO_TRAP macros, expanding the last one used
      i386: add TRACE_IRQS_OFF to entry_32.S in 'error_code'
      i386: add TRACE_IRQS_OFF for exception 1 (debug)
      i386: add TRACE_IRQS_OFF for the nmi
      i386: add TRACE_IRQS_OFF for the exception 3 (int3)
      i386: trace_hardirqs_fixup should now not be necessary: irqs are off.
      traps: x86_64: add TRACE_IRQS_OFF in error_entry
      traps: x86_64: add TRACE_IRQS_OFF in paranoidentry macro
      traps: x86_64: remove trace_hardirqs_fixup from DO_ERROR_INFO macro
      traps: x86_64: remove trace_hardirqs_fixup from int3 handler
      traps: x86_64: remove trace_hardirqs_fixup from debug handler
      traps: x86: remove trace_hardirqs_fixup from pagefault handler
      traps: i386: make do_trap more like x86_64
      i386: split out dumpstack code from traps_32.c
      x86_64: split out dumpstack code from traps_64.c
      fix: x86: remove cpu_vendor_dev
      x86, traps: split out math_error and simd_math_error
      x86, traps, i386: factor out lazy io-bitmap copy
      x86, traps: introduce dotraplinkage
      x86, traps: converge do_debug handlers
      traps: x86: converge trap_init functions
      traps: x86_64: make math_state_restore more like i386
      traps: i386: use preempt_conditional_sti/cli in do_int3
      traps: x86_64: make io_check_error equal to the one on i386
      traps: i386: expand clear_mem_error and remove from mach_traps.h
      traps: x86_64: use task_pid_nr(tsk) instead of tsk->pid in do_general_protection
      traps: x86: various noop-changes preparing for unification of traps_xx.c
      traps: x86: make traps_32.c and traps_64.c equal
      traps: x86: finalize unification of traps.c

Andreas Herrmann (1):
      x86: SB450: skip IRQ0 override if it is not routed to INT2 of IOAPIC

Chuck Ebbert (2):
      x86: move prefill_possible_map calling early, fix, V2
      x86: allow number of additional hotplug CPUs to be set at compile time, V2

Cyrill Gorcunov (1):
      x86: smpboot - check if we have ESR register in wakeup_secondary_cpu

Eduardo Habkost (2):
      x86, xen: Use native_pte_flags instead of native_pte_val for .pte_flags
      xen_alloc_ptpage: cast PFN_PHYS() argument to unsigned long

Ingo Molnar (11):
      x86, MM: virtual address debug, cleanups
      x86: x86_{phys,virt}_bits field also for i386, fix
      Revert "x86: x86_{phys,virt}_bits field also for i386, fix"
      Revert "x86: x86_{phys,virt}_bits field also for i386 (v2)"
      x86: print out EBDA/lowmem address
      x86: add PCI IDs for AMD Barcelona PCI devices
      x86: __show_registers() and __show_regs() API unification, fixlet
      x86: remove additional_cpus configurability
      Revert "acpi/x86: introduce __apci_map_table, v4"
      Revert "acpi: remove final __acpi_map_table mapping before setting acpi_gbl_permanent_mmap"
      x86: SB450: deprioritize DMI quirks

Jack Steiner (1):
      x86, UV: new UV genapic functions for x2apic

Jan Beulich (7):
      x86: adjust vmalloc_sync_all() for Xen (2nd try)
      x86-64: reduce boot fixmap space
      x86-64: slightly stream-line 32-bit syscall entry code
      x86: x86_{phys,virt}_bits field also for i386 (v2)
      x86-64: fix combining of regions in init_memory_mapping()
      x86: make mm/gup.c more virtualization friendly
      x86: adjust dependencies for CONFIG_X86_CMOV

Jeremy Fitzhardinge (30):
      x86/paravirt/xen: properly fill out the ldt ops
      x86: split spinlock implementations out into their own files
      x86: fix initialization of 'l' bit in ldt descriptors
      xen: fix allocation and use of large ldts
      generic, memparse(): constify argument
      xen-balloon: fix up sysfs issues
      xen-balloon: clean up unused functions
      xen: suppress known wrmsrs
      xen: compile irq functions without -pg for ftrace
      xen: fix allocation and use of large ldts, cleanup
      xen: clean up domain mode predicates
      x86/paravirt: add spin_lock_flags lock op
      xen: clarify locking used when pinning a pagetable.
      xen: add xen_ prefixes to make tracing with ftrace easier
      xen: save previous spinlock when blocking
      xen: add debugfs support
      xen: allow interrupts to be enabled while doing a blocking spin
      xen: measure how long spinlocks spend blocking
      x86: build fix in "xen spinlock updates and performance measurements"
      x86: export pv_lock_ops non-GPL
      x86: add _PAGE_IOMAP pte flag for IO mappings
      x86: remove duplicate early_ioremap declarations
      x86: add early_memremap()
      x86: use early_memremap() in setup.c
      x86-64: don't check for map replacement
      x86: use early_ioremap in __acpi_map_table
      x86: always explicitly map acpi memory
      mm: define USE_SPLIT_PTLOCKS rather than repeating expression
      xen: fix pinning when not using split pte locks
      acpi: remove final __acpi_map_table mapping before setting acpi_gbl_permanent_mmap

Jiri Slaby (2):
      MM: virtual address debug
      x86, MM: virtual address debug, v2

Krzysztof Helt (2):
      x86: merge winchip-2 and winchip-2a cpu choices
      x86: do not allow to optimize flag_is_changeable_p() (rev. 2)

Manfred Spraul (1):
      arch/x86/kernel/smpboot.c: Clarify when irq processing begins.

Pekka Enberg (1):
      x86: __show_registers() and __show_regs() API unification

Thomas Gleixner (2):
      x86: improve UP kernel when CPU-hotplug and SMP is enabled
      x86: remove additional_cpus

Vegard Nossum (2):
      x86: add memory clobber in switch_to()
      x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y, v2

Yinghai Lu (5):
      x86: rename discontig_32.c to numa_32.c
      x86: change early_ioremap to use slots instead of nesting
      acpi/x86: introduce __apci_map_table, v4
      x86: check dsdt before find oem table for es7000, v2
      x86: cpu don't print duplicated vendor string


 arch/x86/Kconfig.cpu                      |   29 +-
 arch/x86/Makefile_32.cpu                  |    1 -
 arch/x86/configs/i386_defconfig           |    1 -
 arch/x86/configs/x86_64_defconfig         |    1 -
 arch/x86/ia32/ia32entry.S                 |   26 +-
 arch/x86/kernel/Makefile                  |    6 +-
 arch/x86/kernel/acpi/boot.c               |   42 +-
 arch/x86/kernel/alternative.c             |    2 +-
 arch/x86/kernel/cpu/common.c              |   48 +-
 arch/x86/kernel/doublefault_32.c          |    2 +-
 arch/x86/kernel/dumpstack_32.c            |  422 ++++++++++
 arch/x86/kernel/dumpstack_64.c            |  565 ++++++++++++++
 arch/x86/kernel/early-quirks.c            |   48 ++
 arch/x86/kernel/entry_32.S                |   22 +-
 arch/x86/kernel/entry_64.S                |    8 +-
 arch/x86/kernel/es7000_32.c               |   28 +-
 arch/x86/kernel/genx2apic_uv_x.c          |   10 +-
 arch/x86/kernel/head.c                    |    1 +
 arch/x86/kernel/ldt.c                     |    9 +-
 arch/x86/kernel/paravirt-spinlocks.c      |   37 +
 arch/x86/kernel/paravirt.c                |   27 +-
 arch/x86/kernel/process_32.c              |  768 ------------------
 arch/x86/kernel/process_64.c              |   37 +-
 arch/x86/kernel/setup.c                   |    8 +-
 arch/x86/kernel/smp.c                     |    6 +-
 arch/x86/kernel/smpboot.c                 |  164 +++--
 arch/x86/kernel/tlb_32.c                  |    8 +
 arch/x86/kernel/{traps_32.c => traps.c}   |  860 ++++++++-------------
 arch/x86/kernel/traps_64.c                | 1214 -----------------------------
 arch/x86/kernel/vmlinux_64.lds.S          |    2 +-
 arch/x86/mach-generic/es7000.c            |   20 +-
 arch/x86/mm/Makefile                      |    6 +-
 arch/x86/mm/fault.c                       |   19 +-
 arch/x86/mm/gup.c                         |   10 +-
 arch/x86/mm/init_32.c                     |    2 +-
 arch/x86/mm/init_64.c                     |    9 +-
 arch/x86/mm/ioremap.c                     |  168 ++++-
 arch/x86/mm/{discontig_32.c => numa_32.c} |    0
 arch/x86/xen/Kconfig                      |   10 +-
 arch/x86/xen/Makefile                     |   12 +-
 arch/x86/xen/debugfs.c                    |  123 +++
 arch/x86/xen/debugfs.h                    |   10 +
 arch/x86/xen/enlighten.c                  |  189 ++---
 arch/x86/xen/irq.c                        |  143 ++++
 arch/x86/xen/mmu.c                        |  270 ++++++-
 arch/x86/xen/multicalls.c                 |  115 +++-
 arch/x86/xen/smp.c                        |  245 ++-----
 arch/x86/xen/spinlock.c                   |  428 ++++++++++
 arch/x86/xen/time.c                       |   12 +-
 arch/x86/xen/xen-asm_32.S                 |    2 +-
 arch/x86/xen/xen-asm_64.S                 |    2 +-
 arch/x86/xen/xen-ops.h                    |    8 +
 drivers/block/xen-blkfront.c              |    2 +-
 drivers/char/hvc_xen.c                    |    6 +-
 drivers/input/xen-kbdfront.c              |    4 +-
 drivers/net/xen-netfront.c                |    6 +-
 drivers/video/xen-fbfront.c               |    4 +-
 drivers/xen/Makefile                      |    1 +
 drivers/xen/balloon.c                     |  174 +----
 drivers/xen/cpu_hotplug.c                 |   90 +++
 drivers/xen/events.c                      |   40 +-
 drivers/xen/grant-table.c                 |    2 +-
 drivers/xen/xenbus/xenbus_probe.c         |    8 +-
 include/asm-x86/acpi.h                    |    3 -
 include/asm-x86/desc.h                    |   29 +-
 include/asm-x86/dma-mapping.h             |    1 -
 include/asm-x86/es7000/mpparse.h          |    1 +
 include/asm-x86/fixmap_32.h               |    8 +-
 include/asm-x86/fixmap_64.h               |   16 +-
 include/asm-x86/io.h                      |   15 +-
 include/asm-x86/io_64.h                   |    3 -
 include/asm-x86/irqflags.h                |   21 -
 include/asm-x86/kdebug.h                  |    3 +-
 include/asm-x86/kprobes.h                 |    9 -
 include/asm-x86/mach-default/mach_traps.h |    6 -
 include/asm-x86/mmzone_64.h               |    3 +-
 include/asm-x86/module.h                  |    2 -
 include/asm-x86/nmi.h                     |    4 -
 include/asm-x86/page.h                    |    8 +-
 include/asm-x86/page_32.h                 |   13 +-
 include/asm-x86/paravirt.h                |   20 +
 include/asm-x86/pgtable.h                 |   16 +-
 include/asm-x86/ptrace.h                  |    4 -
 include/asm-x86/smp.h                     |   40 +-
 include/asm-x86/spinlock.h                |    9 +-
 include/asm-x86/system.h                  |    5 +-
 include/asm-x86/tlbflush.h                |   10 +
 include/asm-x86/traps.h                   |   73 +-
 include/asm-x86/xen/hypervisor.h          |   14 +-
 include/linux/kernel.h                    |    2 +-
 include/linux/mm.h                        |   13 +-
 include/linux/mm_types.h                  |   10 +-
 include/linux/mmdebug.h                   |   18 +
 include/linux/sched.h                     |    6 +-
 include/xen/events.h                      |    2 +
 lib/Kconfig.debug                         |    9 +
 lib/cmdline.c                             |    2 +-
 mm/vmalloc.c                              |    7 +
 98 files changed, 3425 insertions(+), 3522 deletions(-)
 create mode 100644 arch/x86/kernel/dumpstack_32.c
 create mode 100644 arch/x86/kernel/dumpstack_64.c
 create mode 100644 arch/x86/kernel/paravirt-spinlocks.c
 delete mode 100644 arch/x86/kernel/process_32.c
 rename arch/x86/kernel/{traps_32.c => traps.c} (60%)
 delete mode 100644 arch/x86/kernel/traps_64.c
 rename arch/x86/mm/{discontig_32.c => numa_32.c} (100%)
 create mode 100644 arch/x86/xen/debugfs.c
 create mode 100644 arch/x86/xen/debugfs.h
 create mode 100644 arch/x86/xen/irq.c
 create mode 100644 arch/x86/xen/spinlock.c
 create mode 100644 drivers/xen/cpu_hotplug.c
 create mode 100644 include/linux/mmdebug.h

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index f8843c3..52763b7 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -38,8 +38,7 @@ config M386
 	  - "Crusoe" for the Transmeta Crusoe series.
 	  - "Efficeon" for the Transmeta Efficeon series.
 	  - "Winchip-C6" for original IDT Winchip.
-	  - "Winchip-2" for IDT Winchip 2.
-	  - "Winchip-2A" for IDT Winchips with 3dNow! capabilities.
+	  - "Winchip-2" for IDT Winchips with 3dNow! capabilities.
 	  - "GeodeGX1" for Geode GX1 (Cyrix MediaGX).
 	  - "Geode GX/LX" For AMD Geode GX and LX processors.
 	  - "CyrixIII/VIA C3" for VIA Cyrix III or VIA C3.
@@ -194,19 +193,11 @@ config MWINCHIPC6
 	  treat this chip as a 586TSC with some extended instructions
 	  and alignment requirements.
 
-config MWINCHIP2
-	bool "Winchip-2"
-	depends on X86_32
-	help
-	  Select this for an IDT Winchip-2.  Linux and GCC
-	  treat this chip as a 586TSC with some extended instructions
-	  and alignment requirements.
-
 config MWINCHIP3D
-	bool "Winchip-2A/Winchip-3"
+	bool "Winchip-2/Winchip-2A/Winchip-3"
 	depends on X86_32
 	help
-	  Select this for an IDT Winchip-2A or 3.  Linux and GCC
+	  Select this for an IDT Winchip-2, 2A or 3.  Linux and GCC
 	  treat this chip as a 586TSC with some extended instructions
 	  and alignment requirements.  Also enable out of order memory
 	  stores for this CPU, which can increase performance of some
@@ -318,7 +309,7 @@ config X86_L1_CACHE_SHIFT
 	int
 	default "7" if MPENTIUM4 || X86_GENERIC || GENERIC_CPU || MPSC
 	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
-	default "5" if MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
+	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
 	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MVIAC7
 
 config X86_XADD
@@ -360,7 +351,7 @@ config X86_POPAD_OK
 
 config X86_ALIGNMENT_16
 	def_bool y
-	depends on MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCYRIXIII || X86_ELAN || MK6 || M586MMX || M586TSC || M586 || M486 || MVIAC3_2 || MGEODEGX1
+	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || X86_ELAN || MK6 || M586MMX || M586TSC || M586 || M486 || MVIAC3_2 || MGEODEGX1
 
 config X86_INTEL_USERCOPY
 	def_bool y
@@ -368,7 +359,7 @@ config X86_INTEL_USERCOPY
 
 config X86_USE_PPRO_CHECKSUM
 	def_bool y
-	depends on MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MEFFICEON || MGEODE_LX || MCORE2
+	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MEFFICEON || MGEODE_LX || MCORE2
 
 config X86_USE_3DNOW
 	def_bool y
@@ -376,7 +367,7 @@ config X86_USE_3DNOW
 
 config X86_OOSTORE
 	def_bool y
-	depends on (MWINCHIP3D || MWINCHIP2 || MWINCHIPC6) && MTRR
+	depends on (MWINCHIP3D || MWINCHIPC6) && MTRR
 
 #
 # P6_NOPs are a relatively minor optimization that require a family >=
@@ -396,7 +387,7 @@ config X86_P6_NOP
 
 config X86_TSC
 	def_bool y
-	depends on ((MWINCHIP3D || MWINCHIP2 || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ) || X86_64
+	depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ) || X86_64
 
 config X86_CMPXCHG64
 	def_bool y
@@ -406,7 +397,7 @@ config X86_CMPXCHG64
 # generates cmov.
 config X86_CMOV
 	def_bool y
-	depends on (MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || X86_64)
+	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64)
 
 config X86_MINIMUM_CPU_FAMILY
 	int
@@ -417,7 +408,7 @@ config X86_MINIMUM_CPU_FAMILY
 
 config X86_DEBUGCTLMSR
 	def_bool y
-	depends on !(MK6 || MWINCHIPC6 || MWINCHIP2 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386)
+	depends on !(MK6 || MWINCHIPC6 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386)
 
 menuconfig PROCESSOR_SELECT
 	default y
diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index e372b58..12bdd85 100644
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -28,7 +28,6 @@ cflags-$(CONFIG_MK8)		+= $(call cc-option,-march=k8,-march=athlon)
 cflags-$(CONFIG_MCRUSOE)	+= -march=i686 $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
 cflags-$(CONFIG_MEFFICEON)	+= -march=i686 $(call tune,pentium3) $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
 cflags-$(CONFIG_MWINCHIPC6)	+= $(call cc-option,-march=winchip-c6,-march=i586)
-cflags-$(CONFIG_MWINCHIP2)	+= $(call cc-option,-march=winchip2,-march=i586)
 cflags-$(CONFIG_MWINCHIP3D)	+= $(call cc-option,-march=winchip2,-march=i586)
 cflags-$(CONFIG_MCYRIXIII)	+= $(call cc-option,-march=c3,-march=i486) $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
 cflags-$(CONFIG_MVIAC3_2)	+= $(call cc-option,-march=c3-2,-march=i686)
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index ef9a520..9269ef4 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -213,7 +213,6 @@ CONFIG_M686=y
 # CONFIG_MCRUSOE is not set
 # CONFIG_MEFFICEON is not set
 # CONFIG_MWINCHIPC6 is not set
-# CONFIG_MWINCHIP2 is not set
 # CONFIG_MWINCHIP3D is not set
 # CONFIG_MGEODEGX1 is not set
 # CONFIG_MGEODE_LX is not set
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index e620ea6..638bc85 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -210,7 +210,6 @@ CONFIG_X86_PC=y
 # CONFIG_MCRUSOE is not set
 # CONFIG_MEFFICEON is not set
 # CONFIG_MWINCHIPC6 is not set
-# CONFIG_MWINCHIP2 is not set
 # CONFIG_MWINCHIP3D is not set
 # CONFIG_MGEODEGX1 is not set
 # CONFIG_MGEODE_LX is not set
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index ffc1bb4..eb43147 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -39,11 +39,11 @@
 	.endm 
 
 	/* clobbers %eax */	
-	.macro  CLEAR_RREGS
+	.macro  CLEAR_RREGS _r9=rax
 	xorl 	%eax,%eax
 	movq	%rax,R11(%rsp)
 	movq	%rax,R10(%rsp)
-	movq	%rax,R9(%rsp)
+	movq	%\_r9,R9(%rsp)
 	movq	%rax,R8(%rsp)
 	.endm
 
@@ -52,11 +52,10 @@
 	 * We don't reload %eax because syscall_trace_enter() returned
 	 * the value it wants us to use in the table lookup.
 	 */
-	.macro LOAD_ARGS32 offset
-	movl \offset(%rsp),%r11d
-	movl \offset+8(%rsp),%r10d
+	.macro LOAD_ARGS32 offset, _r9=0
+	.if \_r9
 	movl \offset+16(%rsp),%r9d
-	movl \offset+24(%rsp),%r8d
+	.endif
 	movl \offset+40(%rsp),%ecx
 	movl \offset+48(%rsp),%edx
 	movl \offset+56(%rsp),%esi
@@ -145,7 +144,7 @@ ENTRY(ia32_sysenter_target)
 	SAVE_ARGS 0,0,1
  	/* no need to do an access_ok check here because rbp has been
  	   32bit zero extended */ 
-1:	movl	(%rbp),%r9d
+1:	movl	(%rbp),%ebp
  	.section __ex_table,"a"
  	.quad 1b,ia32_badarg
  	.previous	
@@ -157,7 +156,7 @@ ENTRY(ia32_sysenter_target)
 	cmpl	$(IA32_NR_syscalls-1),%eax
 	ja	ia32_badsys
 sysenter_do_call:
-	IA32_ARG_FIXUP 1
+	IA32_ARG_FIXUP
 sysenter_dispatch:
 	call	*ia32_sys_call_table(,%rax,8)
 	movq	%rax,RAX-ARGOFFSET(%rsp)
@@ -234,20 +233,17 @@ sysexit_audit:
 #endif
 
 sysenter_tracesys:
-	xchgl	%r9d,%ebp
 #ifdef CONFIG_AUDITSYSCALL
 	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
 	jz	sysenter_auditsys
 #endif
 	SAVE_REST
 	CLEAR_RREGS
-	movq	%r9,R9(%rsp)
 	movq	$-ENOSYS,RAX(%rsp)/* ptrace can change this for a bad syscall */
 	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
 	call	syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	xchgl	%ebp,%r9d
 	cmpl	$(IA32_NR_syscalls-1),%eax
 	ja	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
 	jmp	sysenter_do_call
@@ -314,9 +310,9 @@ ENTRY(ia32_cstar_target)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
-cstar_do_call:	
 	cmpl $IA32_NR_syscalls-1,%eax
 	ja  ia32_badsys
+cstar_do_call:
 	IA32_ARG_FIXUP 1
 cstar_dispatch:
 	call *ia32_sys_call_table(,%rax,8)
@@ -357,15 +353,13 @@ cstar_tracesys:
 #endif
 	xchgl %r9d,%ebp
 	SAVE_REST
-	CLEAR_RREGS
-	movq %r9,R9(%rsp)
+	CLEAR_RREGS r9
 	movq $-ENOSYS,RAX(%rsp)	/* ptrace can change this for a bad syscall */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
-	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	LOAD_ARGS32 ARGOFFSET, 1  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	xchgl %ebp,%r9d
-	movl RSP-ARGOFFSET(%rsp), %r8d
 	cmpl $(IA32_NR_syscalls-1),%eax
 	ja int_ret_from_sys_call /* cstar_tracesys has set RAX(%rsp) */
 	jmp cstar_do_call
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index c9be69f..f6160cc 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -10,7 +10,7 @@ ifdef CONFIG_FTRACE
 # Do not profile debug and lowlevel utilities
 CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
-CFLAGS_REMOVE_paravirt.o = -pg
+CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
 endif
 
 #
@@ -23,7 +23,7 @@ CFLAGS_hpet.o		:= $(nostackp)
 CFLAGS_tsc.o		:= $(nostackp)
 
 obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
-obj-y			+= traps_$(BITS).o irq_$(BITS).o
+obj-y			+= traps.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time_$(BITS).o ioport.o ldt.o
 obj-y			+= setup.o i8259.o irqinit_$(BITS).o setup_percpu.o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
@@ -90,7 +90,7 @@ obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o
 obj-$(CONFIG_KVM_CLOCK)		+= kvmclock.o
-obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
+obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o paravirt-spinlocks.o
 obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
 
 obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index c2ac1b4..0f5b567 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -121,35 +121,19 @@ enum acpi_irq_model_id acpi_irq_model = ACPI_IRQ_MODEL_PIC;
  */
 char *__init __acpi_map_table(unsigned long phys, unsigned long size)
 {
-	unsigned long base, offset, mapped_size;
-	int idx;
+	static char *prev_map;
+	static unsigned long prev_size;
 
 	if (!phys || !size)
 		return NULL;
 
-	if (phys+size <= (max_low_pfn_mapped << PAGE_SHIFT))
-		return __va(phys);
+	if (prev_map)
+		early_iounmap(prev_map, prev_size);
 
-	offset = phys & (PAGE_SIZE - 1);
-	mapped_size = PAGE_SIZE - offset;
-	clear_fixmap(FIX_ACPI_END);
-	set_fixmap(FIX_ACPI_END, phys);
-	base = fix_to_virt(FIX_ACPI_END);
+	prev_size = size;
+	prev_map = early_ioremap(phys, size);
 
-	/*
-	 * Most cases can be covered by the below.
-	 */
-	idx = FIX_ACPI_END;
-	while (mapped_size < size) {
-		if (--idx < FIX_ACPI_BEGIN)
-			return NULL;	/* cannot handle this */
-		phys += PAGE_SIZE;
-		clear_fixmap(idx);
-		set_fixmap(idx, phys);
-		mapped_size += PAGE_SIZE;
-	}
-
-	return ((unsigned char *)base + offset);
+	return prev_map;
 }
 
 #ifdef CONFIG_PCI_MMCONFIG
@@ -1418,8 +1402,16 @@ static int __init force_acpi_ht(const struct dmi_system_id *d)
  */
 static int __init dmi_ignore_irq0_timer_override(const struct dmi_system_id *d)
 {
-	pr_notice("%s detected: Ignoring BIOS IRQ0 pin2 override\n", d->ident);
-	acpi_skip_timer_override = 1;
+	/*
+	 * The ati_ixp4x0_rev() early PCI quirk should have set
+	 * the acpi_skip_timer_override flag already:
+	 */
+	if (!acpi_skip_timer_override) {
+		WARN(1, KERN_ERR "ati_ixp4x0 quirk not complete.\n");
+		pr_notice("%s detected: Ignoring BIOS IRQ0 pin2 override\n",
+			d->ident);
+		acpi_skip_timer_override = 1;
+	}
 	return 0;
 }
 
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index fb04e49..a84ac7b 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -444,7 +444,7 @@ void __init alternative_instructions(void)
 					    _text, _etext);
 
 		/* Only switch to UP mode if we don't immediately boot others */
-		if (num_possible_cpus() == 1 || setup_max_cpus <= 1)
+		if (num_present_cpus() == 1 || setup_max_cpus <= 1)
 			alternatives_smp_switch(0);
 	}
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 7581b62..c0b279f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -124,18 +124,25 @@ static inline int flag_is_changeable_p(u32 flag)
 {
 	u32 f1, f2;
 
-	asm("pushfl\n\t"
-	    "pushfl\n\t"
-	    "popl %0\n\t"
-	    "movl %0,%1\n\t"
-	    "xorl %2,%0\n\t"
-	    "pushl %0\n\t"
-	    "popfl\n\t"
-	    "pushfl\n\t"
-	    "popl %0\n\t"
-	    "popfl\n\t"
-	    : "=&r" (f1), "=&r" (f2)
-	    : "ir" (flag));
+	/*
+	 * Cyrix and IDT cpus allow disabling of CPUID
+	 * so the code below may return different results
+	 * when it is executed before and after enabling
+	 * the CPUID. Add "volatile" to not allow gcc to
+	 * optimize the subsequent calls to this function.
+	 */
+	asm volatile ("pushfl\n\t"
+		      "pushfl\n\t"
+		      "popl %0\n\t"
+		      "movl %0,%1\n\t"
+		      "xorl %2,%0\n\t"
+		      "pushl %0\n\t"
+		      "popfl\n\t"
+		      "pushfl\n\t"
+		      "popl %0\n\t"
+		      "popfl\n\t"
+		      : "=&r" (f1), "=&r" (f2)
+		      : "ir" (flag));
 
 	return ((f1^f2) & flag) != 0;
 }
@@ -574,6 +581,10 @@ void __init early_cpu_init(void)
  * The NOPL instruction is supposed to exist on all CPUs with
  * family >= 6; unfortunately, that's not true in practice because
  * of early VIA chips and (more importantly) broken virtualizers that
+ *
+ * Note: no 64-bit chip is known to lack these, but put the code here
+ * for consistency with 32 bits, and to make it utterly trivial to
+ * diagnose the problem should it ever surface.
  * are not easy to detect.  In the latter case it doesn't even *fail*
  * reliably, so probing for it doesn't even work.  Disable it completely
  * unless we can find a reliable way to detect all the broken cases.
@@ -797,7 +808,7 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 	else if (c->cpuid_level >= 0)
 		vendor = c->x86_vendor_id;
 
-	if (vendor && strncmp(c->x86_model_id, vendor, strlen(vendor)))
+	if (vendor && !strstr(c->x86_model_id, vendor))
 		printk(KERN_CONT "%s ", vendor);
 
 	if (c->x86_model_id[0])
@@ -1121,16 +1132,5 @@ void __cpuinit cpu_init(void)
 	xsave_init();
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-void __cpuinit cpu_uninit(void)
-{
-	int cpu = raw_smp_processor_id();
-	cpu_clear(cpu, cpu_initialized);
-
-	/* lazy TLB state */
-	per_cpu(cpu_tlbstate, cpu).state = 0;
-	per_cpu(cpu_tlbstate, cpu).active_mm = &init_mm;
-}
-#endif
 
 #endif
diff --git a/arch/x86/kernel/doublefault_32.c b/arch/x86/kernel/doublefault_32.c
index a47798b..b4f14c6 100644
--- a/arch/x86/kernel/doublefault_32.c
+++ b/arch/x86/kernel/doublefault_32.c
@@ -66,6 +66,6 @@ struct tss_struct doublefault_tss __cacheline_aligned = {
 		.ds		= __USER_DS,
 		.fs		= __KERNEL_PERCPU,
 
-		.__cr3		= __pa(swapper_pg_dir)
+		.__cr3		= __pa_nodebug(swapper_pg_dir),
 	}
 };
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
new file mode 100644
index 0000000..c398b27
--- /dev/null
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -0,0 +1,422 @@
+/*
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
+ */
+#include <linux/kallsyms.h>
+#include <linux/kprobes.h>
+#include <linux/uaccess.h>
+#include <linux/utsname.h>
+#include <linux/hardirq.h>
+#include <linux/kdebug.h>
+#include <linux/module.h>
+#include <linux/ptrace.h>
+#include <linux/kexec.h>
+#include <linux/bug.h>
+#include <linux/nmi.h>
+
+#include <asm/stacktrace.h>
+
+int panic_on_unrecovered_nmi;
+int kstack_depth_to_print = 24;
+static unsigned int code_bytes = 64;
+static int die_counter;
+
+void printk_address(unsigned long address, int reliable)
+{
+#ifdef CONFIG_KALLSYMS
+	unsigned long offset = 0;
+	unsigned long symsize;
+	const char *symname;
+	char *modname;
+	char *delim = ":";
+	char namebuf[KSYM_NAME_LEN];
+	char reliab[4] = "";
+
+	symname = kallsyms_lookup(address, &symsize, &offset,
+					&modname, namebuf);
+	if (!symname) {
+		printk(" [<%08lx>]\n", address);
+		return;
+	}
+	if (!reliable)
+		strcpy(reliab, "? ");
+
+	if (!modname)
+		modname = delim = "";
+	printk(" [<%08lx>] %s%s%s%s%s+0x%lx/0x%lx\n",
+		address, reliab, delim, modname, delim, symname, offset, symsize);
+#else
+	printk(" [<%08lx>]\n", address);
+#endif
+}
+
+static inline int valid_stack_ptr(struct thread_info *tinfo,
+			void *p, unsigned int size)
+{
+	void *t = tinfo;
+	return	p > t && p <= t + THREAD_SIZE - size;
+}
+
+/* The form of the top of the frame on the stack */
+struct stack_frame {
+	struct stack_frame *next_frame;
+	unsigned long return_address;
+};
+
+static inline unsigned long
+print_context_stack(struct thread_info *tinfo,
+		unsigned long *stack, unsigned long bp,
+		const struct stacktrace_ops *ops, void *data)
+{
+	struct stack_frame *frame = (struct stack_frame *)bp;
+
+	while (valid_stack_ptr(tinfo, stack, sizeof(*stack))) {
+		unsigned long addr;
+
+		addr = *stack;
+		if (__kernel_text_address(addr)) {
+			if ((unsigned long) stack == bp + 4) {
+				ops->address(data, addr, 1);
+				frame = frame->next_frame;
+				bp = (unsigned long) frame;
+			} else {
+				ops->address(data, addr, bp == 0);
+			}
+		}
+		stack++;
+	}
+	return bp;
+}
+
+void dump_trace(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp,
+		const struct stacktrace_ops *ops, void *data)
+{
+	if (!task)
+		task = current;
+
+	if (!stack) {
+		unsigned long dummy;
+		stack = &dummy;
+		if (task != current)
+			stack = (unsigned long *)task->thread.sp;
+	}
+
+#ifdef CONFIG_FRAME_POINTER
+	if (!bp) {
+		if (task == current) {
+			/* Grab bp right from our regs */
+			asm("movl %%ebp, %0" : "=r" (bp) :);
+		} else {
+			/* bp is the last reg pushed by switch_to */
+			bp = *(unsigned long *) task->thread.sp;
+		}
+	}
+#endif
+
+	for (;;) {
+		struct thread_info *context;
+
+		context = (struct thread_info *)
+			((unsigned long)stack & (~(THREAD_SIZE - 1)));
+		bp = print_context_stack(context, stack, bp, ops, data);
+		/*
+		 * Should be after the line below, but somewhere
+		 * in early boot context comes out corrupted and we
+		 * can't reference it:
+		 */
+		if (ops->stack(data, "IRQ") < 0)
+			break;
+		stack = (unsigned long *)context->previous_esp;
+		if (!stack)
+			break;
+		touch_nmi_watchdog();
+	}
+}
+EXPORT_SYMBOL(dump_trace);
+
+static void
+print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
+{
+	printk(data);
+	print_symbol(msg, symbol);
+	printk("\n");
+}
+
+static void print_trace_warning(void *data, char *msg)
+{
+	printk("%s%s\n", (char *)data, msg);
+}
+
+static int print_trace_stack(void *data, char *name)
+{
+	return 0;
+}
+
+/*
+ * Print one address/symbol entries per line.
+ */
+static void print_trace_address(void *data, unsigned long addr, int reliable)
+{
+	printk("%s [<%08lx>] ", (char *)data, addr);
+	if (!reliable)
+		printk("? ");
+	print_symbol("%s\n", addr);
+	touch_nmi_watchdog();
+}
+
+static const struct stacktrace_ops print_trace_ops = {
+	.warning = print_trace_warning,
+	.warning_symbol = print_trace_warning_symbol,
+	.stack = print_trace_stack,
+	.address = print_trace_address,
+};
+
+static void
+show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp, char *log_lvl)
+{
+	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
+	printk("%s =======================\n", log_lvl);
+}
+
+void show_trace(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp)
+{
+	show_trace_log_lvl(task, regs, stack, bp, "");
+}
+
+static void
+show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
+		   unsigned long *sp, unsigned long bp, char *log_lvl)
+{
+	unsigned long *stack;
+	int i;
+
+	if (sp == NULL) {
+		if (task)
+			sp = (unsigned long *)task->thread.sp;
+		else
+			sp = (unsigned long *)&sp;
+	}
+
+	stack = sp;
+	for (i = 0; i < kstack_depth_to_print; i++) {
+		if (kstack_end(stack))
+			break;
+		if (i && ((i % 8) == 0))
+			printk("\n%s       ", log_lvl);
+		printk("%08lx ", *stack++);
+	}
+	printk("\n%sCall Trace:\n", log_lvl);
+
+	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
+}
+
+void show_stack(struct task_struct *task, unsigned long *sp)
+{
+	printk("       ");
+	show_stack_log_lvl(task, NULL, sp, 0, "");
+}
+
+/*
+ * The architecture-independent dump_stack generator
+ */
+void dump_stack(void)
+{
+	unsigned long bp = 0;
+	unsigned long stack;
+
+#ifdef CONFIG_FRAME_POINTER
+	if (!bp)
+		asm("movl %%ebp, %0" : "=r" (bp):);
+#endif
+
+	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
+		current->pid, current->comm, print_tainted(),
+		init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version);
+
+	show_trace(current, NULL, &stack, bp);
+}
+
+EXPORT_SYMBOL(dump_stack);
+
+void show_registers(struct pt_regs *regs)
+{
+	int i;
+
+	print_modules();
+	__show_regs(regs, 0);
+
+	printk(KERN_EMERG "Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)",
+		TASK_COMM_LEN, current->comm, task_pid_nr(current),
+		current_thread_info(), current, task_thread_info(current));
+	/*
+	 * When in-kernel, we also print out the stack and code at the
+	 * time of the fault..
+	 */
+	if (!user_mode_vm(regs)) {
+		unsigned int code_prologue = code_bytes * 43 / 64;
+		unsigned int code_len = code_bytes;
+		unsigned char c;
+		u8 *ip;
+
+		printk("\n" KERN_EMERG "Stack: ");
+		show_stack_log_lvl(NULL, regs, &regs->sp, 0, KERN_EMERG);
+
+		printk(KERN_EMERG "Code: ");
+
+		ip = (u8 *)regs->ip - code_prologue;
+		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
+			/* try starting at EIP */
+			ip = (u8 *)regs->ip;
+			code_len = code_len - code_prologue + 1;
+		}
+		for (i = 0; i < code_len; i++, ip++) {
+			if (ip < (u8 *)PAGE_OFFSET ||
+					probe_kernel_address(ip, c)) {
+				printk(" Bad EIP value.");
+				break;
+			}
+			if (ip == (u8 *)regs->ip)
+				printk("<%02x> ", c);
+			else
+				printk("%02x ", c);
+		}
+	}
+	printk("\n");
+}
+
+int is_valid_bugaddr(unsigned long ip)
+{
+	unsigned short ud2;
+
+	if (ip < PAGE_OFFSET)
+		return 0;
+	if (probe_kernel_address((unsigned short *)ip, ud2))
+		return 0;
+
+	return ud2 == 0x0b0f;
+}
+
+static raw_spinlock_t die_lock = __RAW_SPIN_LOCK_UNLOCKED;
+static int die_owner = -1;
+static unsigned int die_nest_count;
+
+unsigned __kprobes long oops_begin(void)
+{
+	unsigned long flags;
+
+	oops_enter();
+
+	if (die_owner != raw_smp_processor_id()) {
+		console_verbose();
+		raw_local_irq_save(flags);
+		__raw_spin_lock(&die_lock);
+		die_owner = smp_processor_id();
+		die_nest_count = 0;
+		bust_spinlocks(1);
+	} else {
+		raw_local_irq_save(flags);
+	}
+	die_nest_count++;
+	return flags;
+}
+
+void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
+{
+	bust_spinlocks(0);
+	die_owner = -1;
+	add_taint(TAINT_DIE);
+	__raw_spin_unlock(&die_lock);
+	raw_local_irq_restore(flags);
+
+	if (!regs)
+		return;
+
+	if (kexec_should_crash(current))
+		crash_kexec(regs);
+
+	if (in_interrupt())
+		panic("Fatal exception in interrupt");
+
+	if (panic_on_oops)
+		panic("Fatal exception");
+
+	oops_exit();
+	do_exit(signr);
+}
+
+int __kprobes __die(const char *str, struct pt_regs *regs, long err)
+{
+	unsigned short ss;
+	unsigned long sp;
+
+	printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);
+#ifdef CONFIG_PREEMPT
+	printk("PREEMPT ");
+#endif
+#ifdef CONFIG_SMP
+	printk("SMP ");
+#endif
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	printk("DEBUG_PAGEALLOC");
+#endif
+	printk("\n");
+	if (notify_die(DIE_OOPS, str, regs, err,
+			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
+		return 1;
+
+	show_registers(regs);
+	/* Executive summary in case the oops scrolled away */
+	sp = (unsigned long) (&regs->sp);
+	savesegment(ss, ss);
+	if (user_mode(regs)) {
+		sp = regs->sp;
+		ss = regs->ss & 0xffff;
+	}
+	printk(KERN_EMERG "EIP: [<%08lx>] ", regs->ip);
+	print_symbol("%s", regs->ip);
+	printk(" SS:ESP %04x:%08lx\n", ss, sp);
+	return 0;
+}
+
+/*
+ * This is gone through when something in the kernel has done something bad
+ * and is about to be terminated:
+ */
+void die(const char *str, struct pt_regs *regs, long err)
+{
+	unsigned long flags = oops_begin();
+
+	if (die_nest_count < 3) {
+		report_bug(regs->ip, regs);
+
+		if (__die(str, regs, err))
+			regs = NULL;
+	} else {
+		printk(KERN_EMERG "Recursive die() failure, output suppressed\n");
+	}
+
+	oops_end(flags, regs, SIGSEGV);
+}
+
+static int __init kstack_setup(char *s)
+{
+	kstack_depth_to_print = simple_strtoul(s, NULL, 0);
+
+	return 1;
+}
+__setup("kstack=", kstack_setup);
+
+static int __init code_bytes_setup(char *s)
+{
+	code_bytes = simple_strtoul(s, NULL, 0);
+	if (code_bytes > 8192)
+		code_bytes = 8192;
+
+	return 1;
+}
+__setup("code_bytes=", code_bytes_setup);
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
new file mode 100644
index 0000000..6f15050
--- /dev/null
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -0,0 +1,565 @@
+/*
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
+ */
+#include <linux/kallsyms.h>
+#include <linux/kprobes.h>
+#include <linux/uaccess.h>
+#include <linux/utsname.h>
+#include <linux/hardirq.h>
+#include <linux/kdebug.h>
+#include <linux/module.h>
+#include <linux/ptrace.h>
+#include <linux/kexec.h>
+#include <linux/bug.h>
+#include <linux/nmi.h>
+
+#include <asm/stacktrace.h>
+
+int panic_on_unrecovered_nmi;
+int kstack_depth_to_print = 12;
+static unsigned int code_bytes = 64;
+static int die_counter;
+
+void printk_address(unsigned long address, int reliable)
+{
+	printk(" [<%016lx>] %s%pS\n",
+			address, reliable ?	"" : "? ", (void *) address);
+}
+
+static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
+					unsigned *usedp, char **idp)
+{
+	static char ids[][8] = {
+		[DEBUG_STACK - 1] = "#DB",
+		[NMI_STACK - 1] = "NMI",
+		[DOUBLEFAULT_STACK - 1] = "#DF",
+		[STACKFAULT_STACK - 1] = "#SS",
+		[MCE_STACK - 1] = "#MC",
+#if DEBUG_STKSZ > EXCEPTION_STKSZ
+		[N_EXCEPTION_STACKS ...
+			N_EXCEPTION_STACKS + DEBUG_STKSZ / EXCEPTION_STKSZ - 2] = "#DB[?]"
+#endif
+	};
+	unsigned k;
+
+	/*
+	 * Iterate over all exception stacks, and figure out whether
+	 * 'stack' is in one of them:
+	 */
+	for (k = 0; k < N_EXCEPTION_STACKS; k++) {
+		unsigned long end = per_cpu(orig_ist, cpu).ist[k];
+		/*
+		 * Is 'stack' above this exception frame's end?
+		 * If yes then skip to the next frame.
+		 */
+		if (stack >= end)
+			continue;
+		/*
+		 * Is 'stack' above this exception frame's start address?
+		 * If yes then we found the right frame.
+		 */
+		if (stack >= end - EXCEPTION_STKSZ) {
+			/*
+			 * Make sure we only iterate through an exception
+			 * stack once. If it comes up for the second time
+			 * then there's something wrong going on - just
+			 * break out and return NULL:
+			 */
+			if (*usedp & (1U << k))
+				break;
+			*usedp |= 1U << k;
+			*idp = ids[k];
+			return (unsigned long *)end;
+		}
+		/*
+		 * If this is a debug stack, and if it has a larger size than
+		 * the usual exception stacks, then 'stack' might still
+		 * be within the lower portion of the debug stack:
+		 */
+#if DEBUG_STKSZ > EXCEPTION_STKSZ
+		if (k == DEBUG_STACK - 1 && stack >= end - DEBUG_STKSZ) {
+			unsigned j = N_EXCEPTION_STACKS - 1;
+
+			/*
+			 * Black magic. A large debug stack is composed of
+			 * multiple exception stack entries, which we
+			 * iterate through now. Dont look:
+			 */
+			do {
+				++j;
+				end -= EXCEPTION_STKSZ;
+				ids[j][4] = '1' + (j - N_EXCEPTION_STACKS);
+			} while (stack < end - EXCEPTION_STKSZ);
+			if (*usedp & (1U << j))
+				break;
+			*usedp |= 1U << j;
+			*idp = ids[j];
+			return (unsigned long *)end;
+		}
+#endif
+	}
+	return NULL;
+}
+
+/*
+ * x86-64 can have up to three kernel stacks:
+ * process stack
+ * interrupt stack
+ * severe exception (double fault, nmi, stack fault, debug, mce) hardware stack
+ */
+
+static inline int valid_stack_ptr(struct thread_info *tinfo,
+			void *p, unsigned int size, void *end)
+{
+	void *t = tinfo;
+	if (end) {
+		if (p < end && p >= (end-THREAD_SIZE))
+			return 1;
+		else
+			return 0;
+	}
+	return p > t && p < t + THREAD_SIZE - size;
+}
+
+/* The form of the top of the frame on the stack */
+struct stack_frame {
+	struct stack_frame *next_frame;
+	unsigned long return_address;
+};
+
+static inline unsigned long
+print_context_stack(struct thread_info *tinfo,
+		unsigned long *stack, unsigned long bp,
+		const struct stacktrace_ops *ops, void *data,
+		unsigned long *end)
+{
+	struct stack_frame *frame = (struct stack_frame *)bp;
+
+	while (valid_stack_ptr(tinfo, stack, sizeof(*stack), end)) {
+		unsigned long addr;
+
+		addr = *stack;
+		if (__kernel_text_address(addr)) {
+			if ((unsigned long) stack == bp + 8) {
+				ops->address(data, addr, 1);
+				frame = frame->next_frame;
+				bp = (unsigned long) frame;
+			} else {
+				ops->address(data, addr, bp == 0);
+			}
+		}
+		stack++;
+	}
+	return bp;
+}
+
+void dump_trace(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp,
+		const struct stacktrace_ops *ops, void *data)
+{
+	const unsigned cpu = get_cpu();
+	unsigned long *irqstack_end = (unsigned long *)cpu_pda(cpu)->irqstackptr;
+	unsigned used = 0;
+	struct thread_info *tinfo;
+
+	if (!task)
+		task = current;
+
+	if (!stack) {
+		unsigned long dummy;
+		stack = &dummy;
+		if (task && task != current)
+			stack = (unsigned long *)task->thread.sp;
+	}
+
+#ifdef CONFIG_FRAME_POINTER
+	if (!bp) {
+		if (task == current) {
+			/* Grab bp right from our regs */
+			asm("movq %%rbp, %0" : "=r" (bp) : );
+		} else {
+			/* bp is the last reg pushed by switch_to */
+			bp = *(unsigned long *) task->thread.sp;
+		}
+	}
+#endif
+
+	/*
+	 * Print function call entries in all stacks, starting at the
+	 * current stack address. If the stacks consist of nested
+	 * exceptions
+	 */
+	tinfo = task_thread_info(task);
+	for (;;) {
+		char *id;
+		unsigned long *estack_end;
+		estack_end = in_exception_stack(cpu, (unsigned long)stack,
+						&used, &id);
+
+		if (estack_end) {
+			if (ops->stack(data, id) < 0)
+				break;
+
+			bp = print_context_stack(tinfo, stack, bp, ops,
+							data, estack_end);
+			ops->stack(data, "<EOE>");
+			/*
+			 * We link to the next stack via the
+			 * second-to-last pointer (index -2 to end) in the
+			 * exception stack:
+			 */
+			stack = (unsigned long *) estack_end[-2];
+			continue;
+		}
+		if (irqstack_end) {
+			unsigned long *irqstack;
+			irqstack = irqstack_end -
+				(IRQSTACKSIZE - 64) / sizeof(*irqstack);
+
+			if (stack >= irqstack && stack < irqstack_end) {
+				if (ops->stack(data, "IRQ") < 0)
+					break;
+				bp = print_context_stack(tinfo, stack, bp,
+						ops, data, irqstack_end);
+				/*
+				 * We link to the next stack (which would be
+				 * the process stack normally) the last
+				 * pointer (index -1 to end) in the IRQ stack:
+				 */
+				stack = (unsigned long *) (irqstack_end[-1]);
+				irqstack_end = NULL;
+				ops->stack(data, "EOI");
+				continue;
+			}
+		}
+		break;
+	}
+
+	/*
+	 * This handles the process stack:
+	 */
+	bp = print_context_stack(tinfo, stack, bp, ops, data, NULL);
+	put_cpu();
+}
+EXPORT_SYMBOL(dump_trace);
+
+static void
+print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
+{
+	print_symbol(msg, symbol);
+	printk("\n");
+}
+
+static void print_trace_warning(void *data, char *msg)
+{
+	printk("%s\n", msg);
+}
+
+static int print_trace_stack(void *data, char *name)
+{
+	printk(" <%s> ", name);
+	return 0;
+}
+
+static void print_trace_address(void *data, unsigned long addr, int reliable)
+{
+	touch_nmi_watchdog();
+	printk_address(addr, reliable);
+}
+
+static const struct stacktrace_ops print_trace_ops = {
+	.warning = print_trace_warning,
+	.warning_symbol = print_trace_warning_symbol,
+	.stack = print_trace_stack,
+	.address = print_trace_address,
+};
+
+static void
+show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp, char *log_lvl)
+{
+	printk("Call Trace:\n");
+	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
+}
+
+void show_trace(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp)
+{
+	show_trace_log_lvl(task, regs, stack, bp, "");
+}
+
+static void
+show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *sp, unsigned long bp, char *log_lvl)
+{
+	unsigned long *stack;
+	int i;
+	const int cpu = smp_processor_id();
+	unsigned long *irqstack_end =
+		(unsigned long *) (cpu_pda(cpu)->irqstackptr);
+	unsigned long *irqstack =
+		(unsigned long *) (cpu_pda(cpu)->irqstackptr - IRQSTACKSIZE);
+
+	/*
+	 * debugging aid: "show_stack(NULL, NULL);" prints the
+	 * back trace for this cpu.
+	 */
+
+	if (sp == NULL) {
+		if (task)
+			sp = (unsigned long *)task->thread.sp;
+		else
+			sp = (unsigned long *)&sp;
+	}
+
+	stack = sp;
+	for (i = 0; i < kstack_depth_to_print; i++) {
+		if (stack >= irqstack && stack <= irqstack_end) {
+			if (stack == irqstack_end) {
+				stack = (unsigned long *) (irqstack_end[-1]);
+				printk(" <EOI> ");
+			}
+		} else {
+		if (((long) stack & (THREAD_SIZE-1)) == 0)
+			break;
+		}
+		if (i && ((i % 4) == 0))
+			printk("\n");
+		printk(" %016lx", *stack++);
+		touch_nmi_watchdog();
+	}
+	printk("\n");
+	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
+}
+
+void show_stack(struct task_struct *task, unsigned long *sp)
+{
+	show_stack_log_lvl(task, NULL, sp, 0, "");
+}
+
+/*
+ * The architecture-independent dump_stack generator
+ */
+void dump_stack(void)
+{
+	unsigned long bp = 0;
+	unsigned long stack;
+
+#ifdef CONFIG_FRAME_POINTER
+	if (!bp)
+		asm("movq %%rbp, %0" : "=r" (bp) : );
+#endif
+
+	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
+		current->pid, current->comm, print_tainted(),
+		init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version);
+	show_trace(NULL, NULL, &stack, bp);
+}
+EXPORT_SYMBOL(dump_stack);
+
+void show_registers(struct pt_regs *regs)
+{
+	int i;
+	unsigned long sp;
+	const int cpu = smp_processor_id();
+	struct task_struct *cur = cpu_pda(cpu)->pcurrent;
+
+	sp = regs->sp;
+	printk("CPU %d ", cpu);
+	__show_regs(regs, 1);
+	printk("Process %s (pid: %d, threadinfo %p, task %p)\n",
+		cur->comm, cur->pid, task_thread_info(cur), cur);
+
+	/*
+	 * When in-kernel, we also print out the stack and code at the
+	 * time of the fault..
+	 */
+	if (!user_mode(regs)) {
+		unsigned int code_prologue = code_bytes * 43 / 64;
+		unsigned int code_len = code_bytes;
+		unsigned char c;
+		u8 *ip;
+
+		printk("Stack: ");
+		show_stack_log_lvl(NULL, regs, (unsigned long *)sp,
+				regs->bp, "");
+
+		printk(KERN_EMERG "Code: ");
+
+		ip = (u8 *)regs->ip - code_prologue;
+		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
+			/* try starting at RIP */
+			ip = (u8 *)regs->ip;
+			code_len = code_len - code_prologue + 1;
+		}
+		for (i = 0; i < code_len; i++, ip++) {
+			if (ip < (u8 *)PAGE_OFFSET ||
+					probe_kernel_address(ip, c)) {
+				printk(" Bad RIP value.");
+				break;
+			}
+			if (ip == (u8 *)regs->ip)
+				printk("<%02x> ", c);
+			else
+				printk("%02x ", c);
+		}
+	}
+	printk("\n");
+}
+
+int is_valid_bugaddr(unsigned long ip)
+{
+	unsigned short ud2;
+
+	if (__copy_from_user(&ud2, (const void __user *) ip, sizeof(ud2)))
+		return 0;
+
+	return ud2 == 0x0b0f;
+}
+
+static raw_spinlock_t die_lock = __RAW_SPIN_LOCK_UNLOCKED;
+static int die_owner = -1;
+static unsigned int die_nest_count;
+
+unsigned __kprobes long oops_begin(void)
+{
+	int cpu;
+	unsigned long flags;
+
+	oops_enter();
+
+	/* racy, but better than risking deadlock. */
+	raw_local_irq_save(flags);
+	cpu = smp_processor_id();
+	if (!__raw_spin_trylock(&die_lock)) {
+		if (cpu == die_owner)
+			/* nested oops. should stop eventually */;
+		else
+			__raw_spin_lock(&die_lock);
+	}
+	die_nest_count++;
+	die_owner = cpu;
+	console_verbose();
+	bust_spinlocks(1);
+	return flags;
+}
+
+void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
+{
+	die_owner = -1;
+	bust_spinlocks(0);
+	die_nest_count--;
+	if (!die_nest_count)
+		/* Nest count reaches zero, release the lock. */
+		__raw_spin_unlock(&die_lock);
+	raw_local_irq_restore(flags);
+	if (!regs) {
+		oops_exit();
+		return;
+	}
+	if (in_interrupt())
+		panic("Fatal exception in interrupt");
+	if (panic_on_oops)
+		panic("Fatal exception");
+	oops_exit();
+	do_exit(signr);
+}
+
+int __kprobes __die(const char *str, struct pt_regs *regs, long err)
+{
+	printk(KERN_EMERG "%s: %04lx [%u] ", str, err & 0xffff, ++die_counter);
+#ifdef CONFIG_PREEMPT
+	printk("PREEMPT ");
+#endif
+#ifdef CONFIG_SMP
+	printk("SMP ");
+#endif
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	printk("DEBUG_PAGEALLOC");
+#endif
+	printk("\n");
+	if (notify_die(DIE_OOPS, str, regs, err,
+			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
+		return 1;
+
+	show_registers(regs);
+	add_taint(TAINT_DIE);
+	/* Executive summary in case the oops scrolled away */
+	printk(KERN_ALERT "RIP ");
+	printk_address(regs->ip, 1);
+	printk(" RSP <%016lx>\n", regs->sp);
+	if (kexec_should_crash(current))
+		crash_kexec(regs);
+	return 0;
+}
+
+void die(const char *str, struct pt_regs *regs, long err)
+{
+	unsigned long flags = oops_begin();
+
+	if (!user_mode(regs))
+		report_bug(regs->ip, regs);
+
+	if (__die(str, regs, err))
+		regs = NULL;
+	oops_end(flags, regs, SIGSEGV);
+}
+
+notrace __kprobes void
+die_nmi(char *str, struct pt_regs *regs, int do_panic)
+{
+	unsigned long flags;
+
+	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
+		return;
+
+	flags = oops_begin();
+	/*
+	 * We are in trouble anyway, lets at least try
+	 * to get a message out.
+	 */
+	printk(KERN_EMERG "%s", str);
+	printk(" on CPU%d, ip %08lx, registers:\n",
+		smp_processor_id(), regs->ip);
+	show_registers(regs);
+	if (kexec_should_crash(current))
+		crash_kexec(regs);
+	if (do_panic || panic_on_oops)
+		panic("Non maskable interrupt");
+	oops_end(flags, NULL, SIGBUS);
+	nmi_exit();
+	local_irq_enable();
+	do_exit(SIGBUS);
+}
+
+static int __init oops_setup(char *s)
+{
+	if (!s)
+		return -EINVAL;
+	if (!strcmp(s, "panic"))
+		panic_on_oops = 1;
+	return 0;
+}
+early_param("oops", oops_setup);
+
+static int __init kstack_setup(char *s)
+{
+	if (!s)
+		return -EINVAL;
+	kstack_depth_to_print = simple_strtoul(s, NULL, 0);
+	return 0;
+}
+early_param("kstack", kstack_setup);
+
+static int __init code_bytes_setup(char *s)
+{
+	code_bytes = simple_strtoul(s, NULL, 0);
+	if (code_bytes > 8192)
+		code_bytes = 8192;
+
+	return 1;
+}
+__setup("code_bytes=", code_bytes_setup);
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 24bb5fa..733c4f8 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -95,6 +95,52 @@ static void __init nvidia_bugs(int num, int slot, int func)
 
 }
 
+static u32 ati_ixp4x0_rev(int num, int slot, int func)
+{
+	u32 d;
+	u8  b;
+
+	b = read_pci_config_byte(num, slot, func, 0xac);
+	b &= ~(1<<5);
+	write_pci_config_byte(num, slot, func, 0xac, b);
+
+	d = read_pci_config(num, slot, func, 0x70);
+	d |= 1<<8;
+	write_pci_config(num, slot, func, 0x70, d);
+
+	d = read_pci_config(num, slot, func, 0x8);
+	d &= 0xff;
+	return d;
+}
+
+static void __init ati_bugs(int num, int slot, int func)
+{
+#if defined(CONFIG_ACPI) && defined (CONFIG_X86_IO_APIC)
+	u32 d;
+	u8  b;
+
+	if (acpi_use_timer_override)
+		return;
+
+	d = ati_ixp4x0_rev(num, slot, func);
+	if (d  < 0x82)
+		acpi_skip_timer_override = 1;
+	else {
+		/* check for IRQ0 interrupt swap */
+		outb(0x72, 0xcd6); b = inb(0xcd7);
+		if (!(b & 0x2))
+			acpi_skip_timer_override = 1;
+	}
+
+	if (acpi_skip_timer_override) {
+		printk(KERN_INFO "SB4X0 revision 0x%x\n", d);
+		printk(KERN_INFO "Ignoring ACPI timer override.\n");
+		printk(KERN_INFO "If you got timer trouble "
+		       "try acpi_use_timer_override\n");
+	}
+#endif
+}
+
 #ifdef CONFIG_DMAR
 static void __init intel_g33_dmar(int num, int slot, int func)
 {
@@ -128,6 +174,8 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, via_bugs },
 	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB,
 	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, fix_hypertransport_config },
+	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS,
+	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
 #ifdef CONFIG_DMAR
 	{ PCI_VENDOR_ID_INTEL, 0x29c0,
 	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, intel_g33_dmar },
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 109792b..b21fbfa 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -730,6 +730,7 @@ error_code:
 	movl $(__USER_DS), %ecx
 	movl %ecx, %ds
 	movl %ecx, %es
+	TRACE_IRQS_OFF
 	movl %esp,%eax			# pt_regs pointer
 	call *%edi
 	jmp ret_from_exception
@@ -760,20 +761,9 @@ ENTRY(device_not_available)
 	RING0_INT_FRAME
 	pushl $-1			# mark this as an int
 	CFI_ADJUST_CFA_OFFSET 4
-	SAVE_ALL
-	GET_CR0_INTO_EAX
-	testl $0x4, %eax		# EM (math emulation bit)
-	jne device_not_available_emulate
-	preempt_stop(CLBR_ANY)
-	call math_state_restore
-	jmp ret_from_exception
-device_not_available_emulate:
-	pushl $0			# temporary storage for ORIG_EIP
+	pushl $do_device_not_available
 	CFI_ADJUST_CFA_OFFSET 4
-	call math_emulate
-	addl $4, %esp
-	CFI_ADJUST_CFA_OFFSET -4
-	jmp ret_from_exception
+	jmp error_code
 	CFI_ENDPROC
 END(device_not_available)
 
@@ -814,6 +804,7 @@ debug_stack_correct:
 	pushl $-1			# mark this as an int
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
+	TRACE_IRQS_OFF
 	xorl %edx,%edx			# error code 0
 	movl %esp,%eax			# pt_regs pointer
 	call do_debug
@@ -858,6 +849,7 @@ nmi_stack_correct:
 	pushl %eax
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
+	TRACE_IRQS_OFF
 	xorl %edx,%edx		# zero error code
 	movl %esp,%eax		# pt_regs pointer
 	call do_nmi
@@ -898,6 +890,7 @@ nmi_espfix_stack:
 	pushl %eax
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
+	TRACE_IRQS_OFF
 	FIXUP_ESPFIX_STACK		# %eax == %esp
 	xorl %edx,%edx			# zero error code
 	call do_nmi
@@ -928,6 +921,7 @@ KPROBE_ENTRY(int3)
 	pushl $-1			# mark this as an int
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
+	TRACE_IRQS_OFF
 	xorl %edx,%edx		# zero error code
 	movl %esp,%eax		# pt_regs pointer
 	call do_int3
@@ -1030,7 +1024,7 @@ ENTRY(machine_check)
 	RING0_INT_FRAME
 	pushl $0
 	CFI_ADJUST_CFA_OFFSET 4
-	pushl machine_check_vector
+	pushl $do_machine_check
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index cf3a0b2..104fa65 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -932,6 +932,9 @@ END(spurious_interrupt)
 	.if \ist
 	movq	%gs:pda_data_offset, %rbp
 	.endif
+	.if \irqtrace
+	TRACE_IRQS_OFF
+	.endif
 	movq %rsp,%rdi
 	movq ORIG_RAX(%rsp),%rsi
 	movq $-1,ORIG_RAX(%rsp)
@@ -1058,7 +1061,8 @@ KPROBE_ENTRY(error_entry)
 	je  error_kernelspace
 error_swapgs:	
 	SWAPGS
-error_sti:	
+error_sti:
+	TRACE_IRQS_OFF
 	movq %rdi,RDI(%rsp) 	
 	CFI_REL_OFFSET	rdi,RDI
 	movq %rsp,%rdi
@@ -1232,7 +1236,7 @@ ENTRY(simd_coprocessor_error)
 END(simd_coprocessor_error)
 
 ENTRY(device_not_available)
-	zeroentry math_state_restore
+	zeroentry do_device_not_available
 END(device_not_available)
 
 	/* runs on exception stack */
diff --git a/arch/x86/kernel/es7000_32.c b/arch/x86/kernel/es7000_32.c
index 849e5cd..f454c78 100644
--- a/arch/x86/kernel/es7000_32.c
+++ b/arch/x86/kernel/es7000_32.c
@@ -109,6 +109,7 @@ struct oem_table {
 };
 
 extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
+extern void unmap_unisys_acpi_oem_table(unsigned long oem_addr);
 #endif
 
 struct mip_reg {
@@ -243,21 +244,38 @@ parse_unisys_oem (char *oemptr)
 }
 
 #ifdef CONFIG_ACPI
-int __init
-find_unisys_acpi_oem_table(unsigned long *oem_addr)
+static unsigned long oem_addrX;
+static unsigned long oem_size;
+int __init find_unisys_acpi_oem_table(unsigned long *oem_addr)
 {
 	struct acpi_table_header *header = NULL;
 	int i = 0;
-	while (ACPI_SUCCESS(acpi_get_table("OEM1", i++, &header))) {
+	acpi_size tbl_size;
+
+	while (ACPI_SUCCESS(acpi_get_table_with_size("OEM1", i++, &header, &tbl_size))) {
 		if (!memcmp((char *) &header->oem_id, "UNISYS", 6)) {
 			struct oem_table *t = (struct oem_table *)header;
-			*oem_addr = (unsigned long)__acpi_map_table(t->OEMTableAddr,
-								    t->OEMTableSize);
+
+			oem_addrX = t->OEMTableAddr;
+			oem_size = t->OEMTableSize;
+			early_acpi_os_unmap_memory(header, tbl_size);
+
+			*oem_addr = (unsigned long)__acpi_map_table(oem_addrX,
+								    oem_size);
 			return 0;
 		}
+		early_acpi_os_unmap_memory(header, tbl_size);
 	}
 	return -1;
 }
+
+void __init unmap_unisys_acpi_oem_table(unsigned long oem_addr)
+{
+	if (!oem_addr)
+		return;
+
+	__acpi_unmap_table((char *)oem_addr, oem_size);
+}
 #endif
 
 static void
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index ae2ffc8..7b0ff40 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -114,7 +114,7 @@ static void uv_send_IPI_one(int cpu, int vector)
 	unsigned long val, apicid, lapicid;
 	int pnode;
 
-	apicid = per_cpu(x86_cpu_to_apicid, cpu); /* ZZZ - cache node-local ? */
+	apicid = per_cpu(x86_cpu_to_apicid, cpu);
 	lapicid = apicid & 0x3f;		/* ZZZ macro needed */
 	pnode = uv_apicid_to_pnode(apicid);
 	val =
@@ -202,12 +202,10 @@ static unsigned int phys_pkg_id(int index_msb)
 	return uv_read_apic_id() >> index_msb;
 }
 
-#ifdef ZZZ		/* Needs x2apic patch */
 static void uv_send_IPI_self(int vector)
 {
 	apic_write(APIC_SELF_IPI, vector);
 }
-#endif
 
 struct genapic apic_x2apic_uv_x = {
 	.name = "UV large system",
@@ -215,15 +213,15 @@ struct genapic apic_x2apic_uv_x = {
 	.int_delivery_mode = dest_Fixed,
 	.int_dest_mode = (APIC_DEST_PHYSICAL != 0),
 	.target_cpus = uv_target_cpus,
-	.vector_allocation_domain = uv_vector_allocation_domain,/* Fixme ZZZ */
+	.vector_allocation_domain = uv_vector_allocation_domain,
 	.apic_id_registered = uv_apic_id_registered,
 	.init_apic_ldr = uv_init_apic_ldr,
 	.send_IPI_all = uv_send_IPI_all,
 	.send_IPI_allbutself = uv_send_IPI_allbutself,
 	.send_IPI_mask = uv_send_IPI_mask,
-	/* ZZZ.send_IPI_self = uv_send_IPI_self, */
+	.send_IPI_self = uv_send_IPI_self,
 	.cpu_mask_to_apicid = uv_cpu_mask_to_apicid,
-	.phys_pkg_id = phys_pkg_id,	/* Fixme ZZZ */
+	.phys_pkg_id = phys_pkg_id,
 	.get_apic_id = get_apic_id,
 	.set_apic_id = set_apic_id,
 	.apic_id_mask = (0xFFFFFFFFu),
diff --git a/arch/x86/kernel/head.c b/arch/x86/kernel/head.c
index 3e66bd3..1dcb0f1 100644
--- a/arch/x86/kernel/head.c
+++ b/arch/x86/kernel/head.c
@@ -35,6 +35,7 @@ void __init reserve_ebda_region(void)
 
 	/* start of EBDA area */
 	ebda_addr = get_bios_ebda();
+	printk(KERN_INFO "BIOS EBDA/lowmem at: %08x/%08x\n", ebda_addr, lowmem);
 
 	/* Fixup: bios puts an EBDA in the top 64K segment */
 	/* of conventional memory, but does not adjust lowmem. */
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index 0ed5f93..eee32b4 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -52,6 +52,8 @@ static int alloc_ldt(mm_context_t *pc, int mincount, int reload)
 	memset(newldt + oldsize * LDT_ENTRY_SIZE, 0,
 	       (mincount - oldsize) * LDT_ENTRY_SIZE);
 
+	paravirt_alloc_ldt(newldt, mincount);
+
 #ifdef CONFIG_X86_64
 	/* CHECKME: Do we really need this ? */
 	wmb();
@@ -74,6 +76,7 @@ static int alloc_ldt(mm_context_t *pc, int mincount, int reload)
 #endif
 	}
 	if (oldsize) {
+		paravirt_free_ldt(oldldt, oldsize);
 		if (oldsize * LDT_ENTRY_SIZE > PAGE_SIZE)
 			vfree(oldldt);
 		else
@@ -85,10 +88,13 @@ static int alloc_ldt(mm_context_t *pc, int mincount, int reload)
 static inline int copy_ldt(mm_context_t *new, mm_context_t *old)
 {
 	int err = alloc_ldt(new, old->size, 0);
+	int i;
 
 	if (err < 0)
 		return err;
-	memcpy(new->ldt, old->ldt, old->size * LDT_ENTRY_SIZE);
+
+	for(i = 0; i < old->size; i++)
+		write_ldt_entry(new->ldt, i, old->ldt + i * LDT_ENTRY_SIZE);
 	return 0;
 }
 
@@ -125,6 +131,7 @@ void destroy_context(struct mm_struct *mm)
 		if (mm == current->active_mm)
 			clear_LDT();
 #endif
+		paravirt_free_ldt(mm->context.ldt, mm->context.size);
 		if (mm->context.size * LDT_ENTRY_SIZE > PAGE_SIZE)
 			vfree(mm->context.ldt);
 		else
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
new file mode 100644
index 0000000..0e9f198
--- /dev/null
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -0,0 +1,37 @@
+/*
+ * Split spinlock implementation out into its own file, so it can be
+ * compiled in a FTRACE-compatible way.
+ */
+#include <linux/spinlock.h>
+#include <linux/module.h>
+
+#include <asm/paravirt.h>
+
+static void default_spin_lock_flags(struct raw_spinlock *lock, unsigned long flags)
+{
+	__raw_spin_lock(lock);
+}
+
+struct pv_lock_ops pv_lock_ops = {
+#ifdef CONFIG_SMP
+	.spin_is_locked = __ticket_spin_is_locked,
+	.spin_is_contended = __ticket_spin_is_contended,
+
+	.spin_lock = __ticket_spin_lock,
+	.spin_lock_flags = default_spin_lock_flags,
+	.spin_trylock = __ticket_spin_trylock,
+	.spin_unlock = __ticket_spin_unlock,
+#endif
+};
+EXPORT_SYMBOL(pv_lock_ops);
+
+void __init paravirt_use_bytelocks(void)
+{
+#ifdef CONFIG_SMP
+	pv_lock_ops.spin_is_locked = __byte_spin_is_locked;
+	pv_lock_ops.spin_is_contended = __byte_spin_is_contended;
+	pv_lock_ops.spin_lock = __byte_spin_lock;
+	pv_lock_ops.spin_trylock = __byte_spin_trylock;
+	pv_lock_ops.spin_unlock = __byte_spin_unlock;
+#endif
+}
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 6b0bb73..e4c8fb6 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -268,17 +268,6 @@ enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 	return __get_cpu_var(paravirt_lazy_mode);
 }
 
-void __init paravirt_use_bytelocks(void)
-{
-#ifdef CONFIG_SMP
-	pv_lock_ops.spin_is_locked = __byte_spin_is_locked;
-	pv_lock_ops.spin_is_contended = __byte_spin_is_contended;
-	pv_lock_ops.spin_lock = __byte_spin_lock;
-	pv_lock_ops.spin_trylock = __byte_spin_trylock;
-	pv_lock_ops.spin_unlock = __byte_spin_unlock;
-#endif
-}
-
 struct pv_info pv_info = {
 	.name = "bare hardware",
 	.paravirt_enabled = 0,
@@ -349,6 +338,10 @@ struct pv_cpu_ops pv_cpu_ops = {
 	.write_ldt_entry = native_write_ldt_entry,
 	.write_gdt_entry = native_write_gdt_entry,
 	.write_idt_entry = native_write_idt_entry,
+
+	.alloc_ldt = paravirt_nop,
+	.free_ldt = paravirt_nop,
+
 	.load_sp0 = native_load_sp0,
 
 #if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
@@ -460,18 +453,6 @@ struct pv_mmu_ops pv_mmu_ops = {
 	.set_fixmap = native_set_fixmap,
 };
 
-struct pv_lock_ops pv_lock_ops = {
-#ifdef CONFIG_SMP
-	.spin_is_locked = __ticket_spin_is_locked,
-	.spin_is_contended = __ticket_spin_is_contended,
-
-	.spin_lock = __ticket_spin_lock,
-	.spin_trylock = __ticket_spin_trylock,
-	.spin_unlock = __ticket_spin_unlock,
-#endif
-};
-EXPORT_SYMBOL(pv_lock_ops);
-
 EXPORT_SYMBOL_GPL(pv_time_ops);
 EXPORT_SYMBOL    (pv_cpu_ops);
 EXPORT_SYMBOL    (pv_mmu_ops);
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
deleted file mode 100644
index 205188d..0000000
--- a/arch/x86/kernel/process_32.c
+++ /dev/null
@@ -1,768 +0,0 @@
-/*
- *  Copyright (C) 1995  Linus Torvalds
- *
- *  Pentium III FXSR, SSE support
- *	Gareth Hughes <gareth@valinux.com>, May 2000
- */
-
-/*
- * This file handles the architecture-dependent parts of process handling..
- */
-
-#include <stdarg.h>
-
-#include <linux/cpu.h>
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/fs.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/elfcore.h>
-#include <linux/smp.h>
-#include <linux/stddef.h>
-#include <linux/slab.h>
-#include <linux/vmalloc.h>
-#include <linux/user.h>
-#include <linux/interrupt.h>
-#include <linux/utsname.h>
-#include <linux/delay.h>
-#include <linux/reboot.h>
-#include <linux/init.h>
-#include <linux/mc146818rtc.h>
-#include <linux/module.h>
-#include <linux/kallsyms.h>
-#include <linux/ptrace.h>
-#include <linux/random.h>
-#include <linux/personality.h>
-#include <linux/tick.h>
-#include <linux/percpu.h>
-#include <linux/prctl.h>
-#include <linux/dmi.h>
-
-#include <asm/uaccess.h>
-#include <asm/pgtable.h>
-#include <asm/system.h>
-#include <asm/io.h>
-#include <asm/ldt.h>
-#include <asm/processor.h>
-#include <asm/i387.h>
-#include <asm/desc.h>
-#ifdef CONFIG_MATH_EMULATION
-#include <asm/math_emu.h>
-#endif
-
-#include <linux/err.h>
-
-#include <asm/tlbflush.h>
-#include <asm/cpu.h>
-#include <asm/kdebug.h>
-#include <asm/idle.h>
-#include <asm/syscalls.h>
-#include <asm/smp.h>
-
-asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
-
-DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
-EXPORT_PER_CPU_SYMBOL(current_task);
-
-DEFINE_PER_CPU(int, cpu_number);
-EXPORT_PER_CPU_SYMBOL(cpu_number);
-
-/*
- * Return saved PC of a blocked thread.
- */
-unsigned long thread_saved_pc(struct task_struct *tsk)
-{
-	return ((unsigned long *)tsk->thread.sp)[3];
-}
-
-#ifdef CONFIG_HOTPLUG_CPU
-#include <asm/nmi.h>
-
-static void cpu_exit_clear(void)
-{
-	int cpu = raw_smp_processor_id();
-
-	idle_task_exit();
-
-	cpu_uninit();
-	irq_ctx_exit(cpu);
-
-	cpu_clear(cpu, cpu_callout_map);
-	cpu_clear(cpu, cpu_callin_map);
-
-	numa_remove_cpu(cpu);
-	c1e_remove_cpu(cpu);
-}
-
-/* We don't actually take CPU down, just spin without interrupts. */
-static inline void play_dead(void)
-{
-	/* This must be done before dead CPU ack */
-	cpu_exit_clear();
-	mb();
-	/* Ack it */
-	__get_cpu_var(cpu_state) = CPU_DEAD;
-
-	/*
-	 * With physical CPU hotplug, we should halt the cpu
-	 */
-	local_irq_disable();
-	/* mask all interrupts, flush any and all caches, and halt */
-	wbinvd_halt();
-}
-#else
-static inline void play_dead(void)
-{
-	BUG();
-}
-#endif /* CONFIG_HOTPLUG_CPU */
-
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle(void)
-{
-	int cpu = smp_processor_id();
-
-	current_thread_info()->status |= TS_POLLING;
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_stop_sched_tick(1);
-		while (!need_resched()) {
-
-			check_pgt_cache();
-			rmb();
-
-			if (rcu_pending(cpu))
-				rcu_check_callbacks(cpu, 0);
-
-			if (cpu_is_offline(cpu))
-				play_dead();
-
-			local_irq_disable();
-			__get_cpu_var(irq_stat).idle_timestamp = jiffies;
-			/* Don't trace irqs off for idle */
-			stop_critical_timings();
-			pm_idle();
-			start_critical_timings();
-		}
-		tick_nohz_restart_sched_tick();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
-	}
-}
-
-void __show_registers(struct pt_regs *regs, int all)
-{
-	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
-	unsigned long d0, d1, d2, d3, d6, d7;
-	unsigned long sp;
-	unsigned short ss, gs;
-	const char *board;
-
-	if (user_mode_vm(regs)) {
-		sp = regs->sp;
-		ss = regs->ss & 0xffff;
-		savesegment(gs, gs);
-	} else {
-		sp = (unsigned long) (&regs->sp);
-		savesegment(ss, ss);
-		savesegment(gs, gs);
-	}
-
-	printk("\n");
-
-	board = dmi_get_system_info(DMI_PRODUCT_NAME);
-	if (!board)
-		board = "";
-	printk("Pid: %d, comm: %s %s (%s %.*s) %s\n",
-			task_pid_nr(current), current->comm,
-			print_tainted(), init_utsname()->release,
-			(int)strcspn(init_utsname()->version, " "),
-			init_utsname()->version, board);
-
-	printk("EIP: %04x:[<%08lx>] EFLAGS: %08lx CPU: %d\n",
-			(u16)regs->cs, regs->ip, regs->flags,
-			smp_processor_id());
-	print_symbol("EIP is at %s\n", regs->ip);
-
-	printk("EAX: %08lx EBX: %08lx ECX: %08lx EDX: %08lx\n",
-		regs->ax, regs->bx, regs->cx, regs->dx);
-	printk("ESI: %08lx EDI: %08lx EBP: %08lx ESP: %08lx\n",
-		regs->si, regs->di, regs->bp, sp);
-	printk(" DS: %04x ES: %04x FS: %04x GS: %04x SS: %04x\n",
-	       (u16)regs->ds, (u16)regs->es, (u16)regs->fs, gs, ss);
-
-	if (!all)
-		return;
-
-	cr0 = read_cr0();
-	cr2 = read_cr2();
-	cr3 = read_cr3();
-	cr4 = read_cr4_safe();
-	printk("CR0: %08lx CR2: %08lx CR3: %08lx CR4: %08lx\n",
-			cr0, cr2, cr3, cr4);
-
-	get_debugreg(d0, 0);
-	get_debugreg(d1, 1);
-	get_debugreg(d2, 2);
-	get_debugreg(d3, 3);
-	printk("DR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
-			d0, d1, d2, d3);
-
-	get_debugreg(d6, 6);
-	get_debugreg(d7, 7);
-	printk("DR6: %08lx DR7: %08lx\n",
-			d6, d7);
-}
-
-void show_regs(struct pt_regs *regs)
-{
-	__show_registers(regs, 1);
-	show_trace(NULL, regs, &regs->sp, regs->bp);
-}
-
-/*
- * This gets run with %bx containing the
- * function to call, and %dx containing
- * the "args".
- */
-extern void kernel_thread_helper(void);
-
-/*
- * Create a kernel thread
- */
-int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
-{
-	struct pt_regs regs;
-
-	memset(&regs, 0, sizeof(regs));
-
-	regs.bx = (unsigned long) fn;
-	regs.dx = (unsigned long) arg;
-
-	regs.ds = __USER_DS;
-	regs.es = __USER_DS;
-	regs.fs = __KERNEL_PERCPU;
-	regs.orig_ax = -1;
-	regs.ip = (unsigned long) kernel_thread_helper;
-	regs.cs = __KERNEL_CS | get_kernel_rpl();
-	regs.flags = X86_EFLAGS_IF | X86_EFLAGS_SF | X86_EFLAGS_PF | 0x2;
-
-	/* Ok, create the new process.. */
-	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0, NULL, NULL);
-}
-EXPORT_SYMBOL(kernel_thread);
-
-/*
- * Free current thread data structures etc..
- */
-void exit_thread(void)
-{
-	/* The process may have allocated an io port bitmap... nuke it. */
-	if (unlikely(test_thread_flag(TIF_IO_BITMAP))) {
-		struct task_struct *tsk = current;
-		struct thread_struct *t = &tsk->thread;
-		int cpu = get_cpu();
-		struct tss_struct *tss = &per_cpu(init_tss, cpu);
-
-		kfree(t->io_bitmap_ptr);
-		t->io_bitmap_ptr = NULL;
-		clear_thread_flag(TIF_IO_BITMAP);
-		/*
-		 * Careful, clear this in the TSS too:
-		 */
-		memset(tss->io_bitmap, 0xff, tss->io_bitmap_max);
-		t->io_bitmap_max = 0;
-		tss->io_bitmap_owner = NULL;
-		tss->io_bitmap_max = 0;
-		tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
-		put_cpu();
-	}
-#ifdef CONFIG_X86_DS
-	/* Free any DS contexts that have not been properly released. */
-	if (unlikely(current->thread.ds_ctx)) {
-		/* we clear debugctl to make sure DS is not used. */
-		update_debugctlmsr(0);
-		ds_free(current->thread.ds_ctx);
-	}
-#endif /* CONFIG_X86_DS */
-}
-
-void flush_thread(void)
-{
-	struct task_struct *tsk = current;
-
-	tsk->thread.debugreg0 = 0;
-	tsk->thread.debugreg1 = 0;
-	tsk->thread.debugreg2 = 0;
-	tsk->thread.debugreg3 = 0;
-	tsk->thread.debugreg6 = 0;
-	tsk->thread.debugreg7 = 0;
-	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));	
-	clear_tsk_thread_flag(tsk, TIF_DEBUG);
-	/*
-	 * Forget coprocessor state..
-	 */
-	tsk->fpu_counter = 0;
-	clear_fpu(tsk);
-	clear_used_math();
-}
-
-void release_thread(struct task_struct *dead_task)
-{
-	BUG_ON(dead_task->mm);
-	release_vm86_irqs(dead_task);
-}
-
-/*
- * This gets called before we allocate a new thread and copy
- * the current task into it.
- */
-void prepare_to_copy(struct task_struct *tsk)
-{
-	unlazy_fpu(tsk);
-}
-
-int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
-	unsigned long unused,
-	struct task_struct * p, struct pt_regs * regs)
-{
-	struct pt_regs * childregs;
-	struct task_struct *tsk;
-	int err;
-
-	childregs = task_pt_regs(p);
-	*childregs = *regs;
-	childregs->ax = 0;
-	childregs->sp = sp;
-
-	p->thread.sp = (unsigned long) childregs;
-	p->thread.sp0 = (unsigned long) (childregs+1);
-
-	p->thread.ip = (unsigned long) ret_from_fork;
-
-	savesegment(gs, p->thread.gs);
-
-	tsk = current;
-	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
-		p->thread.io_bitmap_ptr = kmemdup(tsk->thread.io_bitmap_ptr,
-						IO_BITMAP_BYTES, GFP_KERNEL);
-		if (!p->thread.io_bitmap_ptr) {
-			p->thread.io_bitmap_max = 0;
-			return -ENOMEM;
-		}
-		set_tsk_thread_flag(p, TIF_IO_BITMAP);
-	}
-
-	err = 0;
-
-	/*
-	 * Set a new TLS for the child thread?
-	 */
-	if (clone_flags & CLONE_SETTLS)
-		err = do_set_thread_area(p, -1,
-			(struct user_desc __user *)childregs->si, 0);
-
-	if (err && p->thread.io_bitmap_ptr) {
-		kfree(p->thread.io_bitmap_ptr);
-		p->thread.io_bitmap_max = 0;
-	}
-	return err;
-}
-
-void
-start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
-{
-	__asm__("movl %0, %%gs" :: "r"(0));
-	regs->fs		= 0;
-	set_fs(USER_DS);
-	regs->ds		= __USER_DS;
-	regs->es		= __USER_DS;
-	regs->ss		= __USER_DS;
-	regs->cs		= __USER_CS;
-	regs->ip		= new_ip;
-	regs->sp		= new_sp;
-	/*
-	 * Free the old FP and other extended state
-	 */
-	free_thread_xstate(current);
-}
-EXPORT_SYMBOL_GPL(start_thread);
-
-static void hard_disable_TSC(void)
-{
-	write_cr4(read_cr4() | X86_CR4_TSD);
-}
-
-void disable_TSC(void)
-{
-	preempt_disable();
-	if (!test_and_set_thread_flag(TIF_NOTSC))
-		/*
-		 * Must flip the CPU state synchronously with
-		 * TIF_NOTSC in the current running context.
-		 */
-		hard_disable_TSC();
-	preempt_enable();
-}
-
-static void hard_enable_TSC(void)
-{
-	write_cr4(read_cr4() & ~X86_CR4_TSD);
-}
-
-static void enable_TSC(void)
-{
-	preempt_disable();
-	if (test_and_clear_thread_flag(TIF_NOTSC))
-		/*
-		 * Must flip the CPU state synchronously with
-		 * TIF_NOTSC in the current running context.
-		 */
-		hard_enable_TSC();
-	preempt_enable();
-}
-
-int get_tsc_mode(unsigned long adr)
-{
-	unsigned int val;
-
-	if (test_thread_flag(TIF_NOTSC))
-		val = PR_TSC_SIGSEGV;
-	else
-		val = PR_TSC_ENABLE;
-
-	return put_user(val, (unsigned int __user *)adr);
-}
-
-int set_tsc_mode(unsigned int val)
-{
-	if (val == PR_TSC_SIGSEGV)
-		disable_TSC();
-	else if (val == PR_TSC_ENABLE)
-		enable_TSC();
-	else
-		return -EINVAL;
-
-	return 0;
-}
-
-#ifdef CONFIG_X86_DS
-static int update_debugctl(struct thread_struct *prev,
-			struct thread_struct *next, unsigned long debugctl)
-{
-	unsigned long ds_prev = 0;
-	unsigned long ds_next = 0;
-
-	if (prev->ds_ctx)
-		ds_prev = (unsigned long)prev->ds_ctx->ds;
-	if (next->ds_ctx)
-		ds_next = (unsigned long)next->ds_ctx->ds;
-
-	if (ds_next != ds_prev) {
-		/* we clear debugctl to make sure DS
-		 * is not in use when we change it */
-		debugctl = 0;
-		update_debugctlmsr(0);
-		wrmsr(MSR_IA32_DS_AREA, ds_next, 0);
-	}
-	return debugctl;
-}
-#else
-static int update_debugctl(struct thread_struct *prev,
-			struct thread_struct *next, unsigned long debugctl)
-{
-	return debugctl;
-}
-#endif /* CONFIG_X86_DS */
-
-static noinline void
-__switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
-		 struct tss_struct *tss)
-{
-	struct thread_struct *prev, *next;
-	unsigned long debugctl;
-
-	prev = &prev_p->thread;
-	next = &next_p->thread;
-
-	debugctl = update_debugctl(prev, next, prev->debugctlmsr);
-
-	if (next->debugctlmsr != debugctl)
-		update_debugctlmsr(next->debugctlmsr);
-
-	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
-		set_debugreg(next->debugreg0, 0);
-		set_debugreg(next->debugreg1, 1);
-		set_debugreg(next->debugreg2, 2);
-		set_debugreg(next->debugreg3, 3);
-		/* no 4 and 5 */
-		set_debugreg(next->debugreg6, 6);
-		set_debugreg(next->debugreg7, 7);
-	}
-
-	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
-	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
-		/* prev and next are different */
-		if (test_tsk_thread_flag(next_p, TIF_NOTSC))
-			hard_disable_TSC();
-		else
-			hard_enable_TSC();
-	}
-
-#ifdef CONFIG_X86_PTRACE_BTS
-	if (test_tsk_thread_flag(prev_p, TIF_BTS_TRACE_TS))
-		ptrace_bts_take_timestamp(prev_p, BTS_TASK_DEPARTS);
-
-	if (test_tsk_thread_flag(next_p, TIF_BTS_TRACE_TS))
-		ptrace_bts_take_timestamp(next_p, BTS_TASK_ARRIVES);
-#endif /* CONFIG_X86_PTRACE_BTS */
-
-
-	if (!test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
-		/*
-		 * Disable the bitmap via an invalid offset. We still cache
-		 * the previous bitmap owner and the IO bitmap contents:
-		 */
-		tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
-		return;
-	}
-
-	if (likely(next == tss->io_bitmap_owner)) {
-		/*
-		 * Previous owner of the bitmap (hence the bitmap content)
-		 * matches the next task, we dont have to do anything but
-		 * to set a valid offset in the TSS:
-		 */
-		tss->x86_tss.io_bitmap_base = IO_BITMAP_OFFSET;
-		return;
-	}
-	/*
-	 * Lazy TSS's I/O bitmap copy. We set an invalid offset here
-	 * and we let the task to get a GPF in case an I/O instruction
-	 * is performed.  The handler of the GPF will verify that the
-	 * faulting task has a valid I/O bitmap and, it true, does the
-	 * real copy and restart the instruction.  This will save us
-	 * redundant copies when the currently switched task does not
-	 * perform any I/O during its timeslice.
-	 */
-	tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET_LAZY;
-}
-
-/*
- *	switch_to(x,yn) should switch tasks from x to y.
- *
- * We fsave/fwait so that an exception goes off at the right time
- * (as a call from the fsave or fwait in effect) rather than to
- * the wrong process. Lazy FP saving no longer makes any sense
- * with modern CPU's, and this simplifies a lot of things (SMP
- * and UP become the same).
- *
- * NOTE! We used to use the x86 hardware context switching. The
- * reason for not using it any more becomes apparent when you
- * try to recover gracefully from saved state that is no longer
- * valid (stale segment register values in particular). With the
- * hardware task-switch, there is no way to fix up bad state in
- * a reasonable manner.
- *
- * The fact that Intel documents the hardware task-switching to
- * be slow is a fairly red herring - this code is not noticeably
- * faster. However, there _is_ some room for improvement here,
- * so the performance issues may eventually be a valid point.
- * More important, however, is the fact that this allows us much
- * more flexibility.
- *
- * The return value (in %ax) will be the "prev" task after
- * the task-switch, and shows up in ret_from_fork in entry.S,
- * for example.
- */
-struct task_struct * __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
-{
-	struct thread_struct *prev = &prev_p->thread,
-				 *next = &next_p->thread;
-	int cpu = smp_processor_id();
-	struct tss_struct *tss = &per_cpu(init_tss, cpu);
-
-	/* never put a printk in __switch_to... printk() calls wake_up*() indirectly */
-
-	__unlazy_fpu(prev_p);
-
-
-	/* we're going to use this soon, after a few expensive things */
-	if (next_p->fpu_counter > 5)
-		prefetch(next->xstate);
-
-	/*
-	 * Reload esp0.
-	 */
-	load_sp0(tss, next);
-
-	/*
-	 * Save away %gs. No need to save %fs, as it was saved on the
-	 * stack on entry.  No need to save %es and %ds, as those are
-	 * always kernel segments while inside the kernel.  Doing this
-	 * before setting the new TLS descriptors avoids the situation
-	 * where we temporarily have non-reloadable segments in %fs
-	 * and %gs.  This could be an issue if the NMI handler ever
-	 * used %fs or %gs (it does not today), or if the kernel is
-	 * running inside of a hypervisor layer.
-	 */
-	savesegment(gs, prev->gs);
-
-	/*
-	 * Load the per-thread Thread-Local Storage descriptor.
-	 */
-	load_TLS(next, cpu);
-
-	/*
-	 * Restore IOPL if needed.  In normal use, the flags restore
-	 * in the switch assembly will handle this.  But if the kernel
-	 * is running virtualized at a non-zero CPL, the popf will
-	 * not restore flags, so it must be done in a separate step.
-	 */
-	if (get_kernel_rpl() && unlikely(prev->iopl != next->iopl))
-		set_iopl_mask(next->iopl);
-
-	/*
-	 * Now maybe handle debug registers and/or IO bitmaps
-	 */
-	if (unlikely(task_thread_info(prev_p)->flags & _TIF_WORK_CTXSW_PREV ||
-		     task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT))
-		__switch_to_xtra(prev_p, next_p, tss);
-
-	/*
-	 * Leave lazy mode, flushing any hypercalls made here.
-	 * This must be done before restoring TLS segments so
-	 * the GDT and LDT are properly updated, and must be
-	 * done before math_state_restore, so the TS bit is up
-	 * to date.
-	 */
-	arch_leave_lazy_cpu_mode();
-
-	/* If the task has used fpu the last 5 timeslices, just do a full
-	 * restore of the math state immediately to avoid the trap; the
-	 * chances of needing FPU soon are obviously high now
-	 *
-	 * tsk_used_math() checks prevent calling math_state_restore(),
-	 * which can sleep in the case of !tsk_used_math()
-	 */
-	if (tsk_used_math(next_p) && next_p->fpu_counter > 5)
-		math_state_restore();
-
-	/*
-	 * Restore %gs if needed (which is common)
-	 */
-	if (prev->gs | next->gs)
-		loadsegment(gs, next->gs);
-
-	x86_write_percpu(current_task, next_p);
-
-	return prev_p;
-}
-
-asmlinkage int sys_fork(struct pt_regs regs)
-{
-	return do_fork(SIGCHLD, regs.sp, &regs, 0, NULL, NULL);
-}
-
-asmlinkage int sys_clone(struct pt_regs regs)
-{
-	unsigned long clone_flags;
-	unsigned long newsp;
-	int __user *parent_tidptr, *child_tidptr;
-
-	clone_flags = regs.bx;
-	newsp = regs.cx;
-	parent_tidptr = (int __user *)regs.dx;
-	child_tidptr = (int __user *)regs.di;
-	if (!newsp)
-		newsp = regs.sp;
-	return do_fork(clone_flags, newsp, &regs, 0, parent_tidptr, child_tidptr);
-}
-
-/*
- * This is trivial, and on the face of it looks like it
- * could equally well be done in user mode.
- *
- * Not so, for quite unobvious reasons - register pressure.
- * In user mode vfork() cannot have a stack frame, and if
- * done by calling the "clone()" system call directly, you
- * do not have enough call-clobbered registers to hold all
- * the information you need.
- */
-asmlinkage int sys_vfork(struct pt_regs regs)
-{
-	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs.sp, &regs, 0, NULL, NULL);
-}
-
-/*
- * sys_execve() executes a new program.
- */
-asmlinkage int sys_execve(struct pt_regs regs)
-{
-	int error;
-	char * filename;
-
-	filename = getname((char __user *) regs.bx);
-	error = PTR_ERR(filename);
-	if (IS_ERR(filename))
-		goto out;
-	error = do_execve(filename,
-			(char __user * __user *) regs.cx,
-			(char __user * __user *) regs.dx,
-			&regs);
-	if (error == 0) {
-		/* Make sure we don't return using sysenter.. */
-		set_thread_flag(TIF_IRET);
-	}
-	putname(filename);
-out:
-	return error;
-}
-
-#define top_esp                (THREAD_SIZE - sizeof(unsigned long))
-#define top_ebp                (THREAD_SIZE - 2*sizeof(unsigned long))
-
-unsigned long get_wchan(struct task_struct *p)
-{
-	unsigned long bp, sp, ip;
-	unsigned long stack_page;
-	int count = 0;
-	if (!p || p == current || p->state == TASK_RUNNING)
-		return 0;
-	stack_page = (unsigned long)task_stack_page(p);
-	sp = p->thread.sp;
-	if (!stack_page || sp < stack_page || sp > top_esp+stack_page)
-		return 0;
-	/* include/asm-i386/system.h:switch_to() pushes bp last. */
-	bp = *(unsigned long *) sp;
-	do {
-		if (bp < stack_page || bp > top_ebp+stack_page)
-			return 0;
-		ip = *(unsigned long *) (bp+4);
-		if (!in_sched_functions(ip))
-			return ip;
-		bp = *(unsigned long *) bp;
-	} while (count++ < 16);
-	return 0;
-}
-
-unsigned long arch_align_stack(unsigned long sp)
-{
-	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
-		sp -= get_random_int() % 8192;
-	return sp & ~0xf;
-}
-
-unsigned long arch_randomize_brk(struct mm_struct *mm)
-{
-	unsigned long range_end = mm->brk + 0x02000000;
-	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
-}
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 2a8ccb9..410cc5f 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -86,30 +86,12 @@ void exit_idle(void)
 	__exit_idle();
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-DECLARE_PER_CPU(int, cpu_state);
-
-#include <linux/nmi.h>
-/* We halt the CPU with physical CPU hotplug */
-static inline void play_dead(void)
-{
-	idle_task_exit();
-	c1e_remove_cpu(raw_smp_processor_id());
-
-	mb();
-	/* Ack it */
-	__get_cpu_var(cpu_state) = CPU_DEAD;
-
-	local_irq_disable();
-	/* mask all interrupts, flush any and all caches, and halt */
-	wbinvd_halt();
-}
-#else
+#ifndef CONFIG_SMP
 static inline void play_dead(void)
 {
 	BUG();
 }
-#endif /* CONFIG_HOTPLUG_CPU */
+#endif
 
 /*
  * The idle thread. There's no useful work to be
@@ -154,7 +136,7 @@ void cpu_idle(void)
 }
 
 /* Prints also some state that isn't saved in the pt_regs */
-void __show_regs(struct pt_regs *regs)
+void __show_regs(struct pt_regs *regs, int all)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L, fs, gs, shadowgs;
 	unsigned long d0, d1, d2, d3, d6, d7;
@@ -193,13 +175,20 @@ void __show_regs(struct pt_regs *regs)
 	rdmsrl(MSR_GS_BASE, gs);
 	rdmsrl(MSR_KERNEL_GS_BASE, shadowgs);
 
+	if (!all)
+		return;
+
+	printk(KERN_INFO "FS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n",
+	       fs, fsindex, gs, gsindex, shadowgs);
+
+	if (!all)
+		return;
+
 	cr0 = read_cr0();
 	cr2 = read_cr2();
 	cr3 = read_cr3();
 	cr4 = read_cr4();
 
-	printk(KERN_INFO "FS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n",
-	       fs, fsindex, gs, gsindex, shadowgs);
 	printk(KERN_INFO "CS:  %04x DS: %04x ES: %04x CR0: %016lx\n", cs, ds,
 			es, cr0);
 	printk(KERN_INFO "CR2: %016lx CR3: %016lx CR4: %016lx\n", cr2, cr3,
@@ -218,7 +207,7 @@ void __show_regs(struct pt_regs *regs)
 void show_regs(struct pt_regs *regs)
 {
 	printk(KERN_INFO "CPU %d:", smp_processor_id());
-	__show_regs(regs);
+	__show_regs(regs, 1);
 	show_trace(NULL, regs, (void *)(regs + 1), regs->bp);
 }
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 46c98ef..09ee73a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -302,7 +302,7 @@ static void __init relocate_initrd(void)
 		if (clen > MAX_MAP_CHUNK-slop)
 			clen = MAX_MAP_CHUNK-slop;
 		mapaddr = ramdisk_image & PAGE_MASK;
-		p = early_ioremap(mapaddr, clen+slop);
+		p = early_memremap(mapaddr, clen+slop);
 		memcpy(q, p+slop, clen);
 		early_iounmap(p, clen+slop);
 		q += clen;
@@ -379,7 +379,7 @@ static void __init parse_setup_data(void)
 		return;
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
-		data = early_ioremap(pa_data, PAGE_SIZE);
+		data = early_memremap(pa_data, PAGE_SIZE);
 		switch (data->type) {
 		case SETUP_E820_EXT:
 			parse_e820_ext(data, pa_data);
@@ -402,7 +402,7 @@ static void __init e820_reserve_setup_data(void)
 		return;
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
-		data = early_ioremap(pa_data, sizeof(*data));
+		data = early_memremap(pa_data, sizeof(*data));
 		e820_update_range(pa_data, sizeof(*data)+data->len,
 			 E820_RAM, E820_RESERVED_KERN);
 		found = 1;
@@ -428,7 +428,7 @@ static void __init reserve_early_setup_data(void)
 		return;
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
-		data = early_ioremap(pa_data, sizeof(*data));
+		data = early_memremap(pa_data, sizeof(*data));
 		sprintf(buf, "setup data %x", data->type);
 		reserve_early(pa_data, pa_data+sizeof(*data)+data->len, buf);
 		pa_data = data->next;
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 361b7a4..18f9b19 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -214,12 +214,16 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 struct smp_ops smp_ops = {
 	.smp_prepare_boot_cpu = native_smp_prepare_boot_cpu,
 	.smp_prepare_cpus = native_smp_prepare_cpus,
-	.cpu_up = native_cpu_up,
 	.smp_cpus_done = native_smp_cpus_done,
 
 	.smp_send_stop = native_smp_send_stop,
 	.smp_send_reschedule = native_smp_send_reschedule,
 
+	.cpu_up = native_cpu_up,
+	.cpu_die = native_cpu_die,
+	.cpu_disable = native_cpu_disable,
+	.play_dead = native_play_dead,
+
 	.send_call_func_ipi = native_send_call_func_ipi,
 	.send_call_func_single_ipi = native_send_call_func_single_ipi,
 };
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2ff0bbc..d6a4d95 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -52,6 +52,7 @@
 #include <asm/desc.h>
 #include <asm/nmi.h>
 #include <asm/irq.h>
+#include <asm/idle.h>
 #include <asm/smp.h>
 #include <asm/trampoline.h>
 #include <asm/cpu.h>
@@ -332,14 +333,17 @@ static void __cpuinit start_secondary(void *unused)
 	 * does not change while we are assigning vectors to cpus.  Holding
 	 * this lock ensures we don't half assign or remove an irq from a cpu.
 	 */
-	ipi_call_lock_irq();
+	ipi_call_lock();
 	lock_vector_lock();
 	__setup_vector_irq(smp_processor_id());
 	cpu_set(smp_processor_id(), cpu_online_map);
 	unlock_vector_lock();
-	ipi_call_unlock_irq();
+	ipi_call_unlock();
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 
+	/* enable local interrupts */
+	local_irq_enable();
+
 	setup_secondary_clock();
 
 	wmb();
@@ -594,10 +598,12 @@ wakeup_secondary_cpu(int logical_apicid, unsigned long start_eip)
 	 * Give the other CPU some time to accept the IPI.
 	 */
 	udelay(200);
-	maxlvt = lapic_get_maxlvt();
-	if (maxlvt > 3)			/* Due to the Pentium erratum 3AP.  */
-		apic_write(APIC_ESR, 0);
-	accept_status = (apic_read(APIC_ESR) & 0xEF);
+	if (APIC_INTEGRATED(apic_version[phys_apicid])) {
+		maxlvt = lapic_get_maxlvt();
+		if (maxlvt > 3)			/* Due to the Pentium erratum 3AP.  */
+			apic_write(APIC_ESR, 0);
+		accept_status = (apic_read(APIC_ESR) & 0xEF);
+	}
 	pr_debug("NMI sent.\n");
 
 	if (send_status)
@@ -1254,39 +1260,6 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 	check_nmi_watchdog();
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-
-static void remove_siblinginfo(int cpu)
-{
-	int sibling;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-
-	for_each_cpu_mask_nr(sibling, per_cpu(cpu_core_map, cpu)) {
-		cpu_clear(cpu, per_cpu(cpu_core_map, sibling));
-		/*/
-		 * last thread sibling in this cpu core going down
-		 */
-		if (cpus_weight(per_cpu(cpu_sibling_map, cpu)) == 1)
-			cpu_data(sibling).booted_cores--;
-	}
-
-	for_each_cpu_mask_nr(sibling, per_cpu(cpu_sibling_map, cpu))
-		cpu_clear(cpu, per_cpu(cpu_sibling_map, sibling));
-	cpus_clear(per_cpu(cpu_sibling_map, cpu));
-	cpus_clear(per_cpu(cpu_core_map, cpu));
-	c->phys_proc_id = 0;
-	c->cpu_core_id = 0;
-	cpu_clear(cpu, cpu_sibling_setup_map);
-}
-
-static int additional_cpus __initdata = -1;
-
-static __init int setup_additional_cpus(char *s)
-{
-	return s && get_option(&s, &additional_cpus) ? 0 : -EINVAL;
-}
-early_param("additional_cpus", setup_additional_cpus);
-
 /*
  * cpu_possible_map should be static, it cannot change as cpu's
  * are onlined, or offlined. The reason is per-cpu data-structures
@@ -1306,21 +1279,13 @@ early_param("additional_cpus", setup_additional_cpus);
  */
 __init void prefill_possible_map(void)
 {
-	int i;
-	int possible;
+	int i, possible;
 
 	/* no processor from mptable or madt */
 	if (!num_processors)
 		num_processors = 1;
 
-	if (additional_cpus == -1) {
-		if (disabled_cpus > 0)
-			additional_cpus = disabled_cpus;
-		else
-			additional_cpus = 0;
-	}
-
-	possible = num_processors + additional_cpus;
+	possible = num_processors + disabled_cpus;
 	if (possible > NR_CPUS)
 		possible = NR_CPUS;
 
@@ -1333,6 +1298,31 @@ __init void prefill_possible_map(void)
 	nr_cpu_ids = possible;
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+
+static void remove_siblinginfo(int cpu)
+{
+	int sibling;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+
+	for_each_cpu_mask_nr(sibling, per_cpu(cpu_core_map, cpu)) {
+		cpu_clear(cpu, per_cpu(cpu_core_map, sibling));
+		/*/
+		 * last thread sibling in this cpu core going down
+		 */
+		if (cpus_weight(per_cpu(cpu_sibling_map, cpu)) == 1)
+			cpu_data(sibling).booted_cores--;
+	}
+
+	for_each_cpu_mask_nr(sibling, per_cpu(cpu_sibling_map, cpu))
+		cpu_clear(cpu, per_cpu(cpu_sibling_map, sibling));
+	cpus_clear(per_cpu(cpu_sibling_map, cpu));
+	cpus_clear(per_cpu(cpu_core_map, cpu));
+	c->phys_proc_id = 0;
+	c->cpu_core_id = 0;
+	cpu_clear(cpu, cpu_sibling_setup_map);
+}
+
 static void __ref remove_cpu_from_maps(int cpu)
 {
 	cpu_clear(cpu, cpu_online_map);
@@ -1343,25 +1333,9 @@ static void __ref remove_cpu_from_maps(int cpu)
 	numa_remove_cpu(cpu);
 }
 
-int __cpu_disable(void)
+void cpu_disable_common(void)
 {
 	int cpu = smp_processor_id();
-
-	/*
-	 * Perhaps use cpufreq to drop frequency, but that could go
-	 * into generic code.
-	 *
-	 * We won't take down the boot processor on i386 due to some
-	 * interrupts only being able to be serviced by the BSP.
-	 * Especially so if we're not using an IOAPIC	-zwane
-	 */
-	if (cpu == 0)
-		return -EBUSY;
-
-	if (nmi_watchdog == NMI_LOCAL_APIC)
-		stop_apic_nmi_watchdog(NULL);
-	clear_local_APIC();
-
 	/*
 	 * HACK:
 	 * Allow any queued timer interrupts to get serviced
@@ -1379,10 +1353,32 @@ int __cpu_disable(void)
 	remove_cpu_from_maps(cpu);
 	unlock_vector_lock();
 	fixup_irqs(cpu_online_map);
+}
+
+int native_cpu_disable(void)
+{
+	int cpu = smp_processor_id();
+
+	/*
+	 * Perhaps use cpufreq to drop frequency, but that could go
+	 * into generic code.
+	 *
+	 * We won't take down the boot processor on i386 due to some
+	 * interrupts only being able to be serviced by the BSP.
+	 * Especially so if we're not using an IOAPIC	-zwane
+	 */
+	if (cpu == 0)
+		return -EBUSY;
+
+	if (nmi_watchdog == NMI_LOCAL_APIC)
+		stop_apic_nmi_watchdog(NULL);
+	clear_local_APIC();
+
+	cpu_disable_common();
 	return 0;
 }
 
-void __cpu_die(unsigned int cpu)
+void native_cpu_die(unsigned int cpu)
 {
 	/* We don't do anything here: idle task is faking death itself. */
 	unsigned int i;
@@ -1399,15 +1395,45 @@ void __cpu_die(unsigned int cpu)
 	}
 	printk(KERN_ERR "CPU %u didn't die...\n", cpu);
 }
+
+void play_dead_common(void)
+{
+	idle_task_exit();
+	reset_lazy_tlbstate();
+	irq_ctx_exit(raw_smp_processor_id());
+	c1e_remove_cpu(raw_smp_processor_id());
+
+	mb();
+	/* Ack it */
+	__get_cpu_var(cpu_state) = CPU_DEAD;
+
+	/*
+	 * With physical CPU hotplug, we should halt the cpu
+	 */
+	local_irq_disable();
+}
+
+void native_play_dead(void)
+{
+	play_dead_common();
+	wbinvd_halt();
+}
+
 #else /* ... !CONFIG_HOTPLUG_CPU */
-int __cpu_disable(void)
+int native_cpu_disable(void)
 {
 	return -ENOSYS;
 }
 
-void __cpu_die(unsigned int cpu)
+void native_cpu_die(unsigned int cpu)
 {
 	/* We said "no" in __cpu_disable */
 	BUG();
 }
+
+void native_play_dead(void)
+{
+	BUG();
+}
+
 #endif
diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
index fec1ece..e00534b 100644
--- a/arch/x86/kernel/tlb_32.c
+++ b/arch/x86/kernel/tlb_32.c
@@ -241,3 +241,11 @@ void flush_tlb_all(void)
 	on_each_cpu(do_flush_tlb_all, NULL, 1);
 }
 
+void reset_lazy_tlbstate(void)
+{
+	int cpu = raw_smp_processor_id();
+
+	per_cpu(cpu_tlbstate, cpu).state = 0;
+	per_cpu(cpu_tlbstate, cpu).active_mm = &init_mm;
+}
+
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps.c
similarity index 60%
rename from arch/x86/kernel/traps_32.c
rename to arch/x86/kernel/traps.c
index 0429c5d..ffb131f 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps.c
@@ -7,13 +7,11 @@
  */
 
 /*
- * 'Traps.c' handles hardware traps and faults after we have saved some
- * state in 'asm.s'.
+ * Handle hardware traps and faults.
  */
 #include <linux/interrupt.h>
 #include <linux/kallsyms.h>
 #include <linux/spinlock.h>
-#include <linux/highmem.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/utsname.h>
@@ -32,6 +30,8 @@
 #include <linux/bug.h>
 #include <linux/nmi.h>
 #include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/io.h>
 
 #ifdef CONFIG_EISA
 #include <linux/ioport.h>
@@ -46,21 +46,31 @@
 #include <linux/edac.h>
 #endif
 
-#include <asm/arch_hooks.h>
 #include <asm/stacktrace.h>
 #include <asm/processor.h>
 #include <asm/debugreg.h>
 #include <asm/atomic.h>
 #include <asm/system.h>
 #include <asm/unwind.h>
+#include <asm/traps.h>
 #include <asm/desc.h>
 #include <asm/i387.h>
+
+#include <mach_traps.h>
+
+#ifdef CONFIG_X86_64
+#include <asm/pgalloc.h>
+#include <asm/proto.h>
+#include <asm/pda.h>
+#else
+#include <asm/processor-flags.h>
+#include <asm/arch_hooks.h>
 #include <asm/nmi.h>
 #include <asm/smp.h>
 #include <asm/io.h>
 #include <asm/traps.h>
 
-#include "mach_traps.h"
+#include "cpu/mcheck/mce.h"
 
 DECLARE_BITMAP(used_vectors, NR_VECTORS);
 EXPORT_SYMBOL_GPL(used_vectors);
@@ -77,418 +87,104 @@ char ignore_fpu_irq;
  */
 gate_desc idt_table[256]
 	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
-
-int panic_on_unrecovered_nmi;
-int kstack_depth_to_print = 24;
-static unsigned int code_bytes = 64;
-static int ignore_nmis;
-static int die_counter;
-
-void printk_address(unsigned long address, int reliable)
-{
-#ifdef CONFIG_KALLSYMS
-	unsigned long offset = 0;
-	unsigned long symsize;
-	const char *symname;
-	char *modname;
-	char *delim = ":";
-	char namebuf[KSYM_NAME_LEN];
-	char reliab[4] = "";
-
-	symname = kallsyms_lookup(address, &symsize, &offset,
-					&modname, namebuf);
-	if (!symname) {
-		printk(" [<%08lx>]\n", address);
-		return;
-	}
-	if (!reliable)
-		strcpy(reliab, "? ");
-
-	if (!modname)
-		modname = delim = "";
-	printk(" [<%08lx>] %s%s%s%s%s+0x%lx/0x%lx\n",
-		address, reliab, delim, modname, delim, symname, offset, symsize);
-#else
-	printk(" [<%08lx>]\n", address);
-#endif
-}
-
-static inline int valid_stack_ptr(struct thread_info *tinfo,
-			void *p, unsigned int size)
-{
-	void *t = tinfo;
-	return	p > t && p <= t + THREAD_SIZE - size;
-}
-
-/* The form of the top of the frame on the stack */
-struct stack_frame {
-	struct stack_frame *next_frame;
-	unsigned long return_address;
-};
-
-static inline unsigned long
-print_context_stack(struct thread_info *tinfo,
-		unsigned long *stack, unsigned long bp,
-		const struct stacktrace_ops *ops, void *data)
-{
-	struct stack_frame *frame = (struct stack_frame *)bp;
-
-	while (valid_stack_ptr(tinfo, stack, sizeof(*stack))) {
-		unsigned long addr;
-
-		addr = *stack;
-		if (__kernel_text_address(addr)) {
-			if ((unsigned long) stack == bp + 4) {
-				ops->address(data, addr, 1);
-				frame = frame->next_frame;
-				bp = (unsigned long) frame;
-			} else {
-				ops->address(data, addr, bp == 0);
-			}
-		}
-		stack++;
-	}
-	return bp;
-}
-
-void dump_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp,
-		const struct stacktrace_ops *ops, void *data)
-{
-	if (!task)
-		task = current;
-
-	if (!stack) {
-		unsigned long dummy;
-		stack = &dummy;
-		if (task != current)
-			stack = (unsigned long *)task->thread.sp;
-	}
-
-#ifdef CONFIG_FRAME_POINTER
-	if (!bp) {
-		if (task == current) {
-			/* Grab bp right from our regs */
-			asm("movl %%ebp, %0" : "=r" (bp) :);
-		} else {
-			/* bp is the last reg pushed by switch_to */
-			bp = *(unsigned long *) task->thread.sp;
-		}
-	}
 #endif
 
-	for (;;) {
-		struct thread_info *context;
-
-		context = (struct thread_info *)
-			((unsigned long)stack & (~(THREAD_SIZE - 1)));
-		bp = print_context_stack(context, stack, bp, ops, data);
-		/*
-		 * Should be after the line below, but somewhere
-		 * in early boot context comes out corrupted and we
-		 * can't reference it:
-		 */
-		if (ops->stack(data, "IRQ") < 0)
-			break;
-		stack = (unsigned long *)context->previous_esp;
-		if (!stack)
-			break;
-		touch_nmi_watchdog();
-	}
-}
-EXPORT_SYMBOL(dump_trace);
-
-static void
-print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-	printk(data);
-	print_symbol(msg, symbol);
-	printk("\n");
-}
-
-static void print_trace_warning(void *data, char *msg)
-{
-	printk("%s%s\n", (char *)data, msg);
-}
-
-static int print_trace_stack(void *data, char *name)
-{
-	return 0;
-}
-
-/*
- * Print one address/symbol entries per line.
- */
-static void print_trace_address(void *data, unsigned long addr, int reliable)
-{
-	printk("%s [<%08lx>] ", (char *)data, addr);
-	if (!reliable)
-		printk("? ");
-	print_symbol("%s\n", addr);
-	touch_nmi_watchdog();
-}
-
-static const struct stacktrace_ops print_trace_ops = {
-	.warning = print_trace_warning,
-	.warning_symbol = print_trace_warning_symbol,
-	.stack = print_trace_stack,
-	.address = print_trace_address,
-};
+static int ignore_nmis;
 
-static void
-show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp, char *log_lvl)
+static inline void conditional_sti(struct pt_regs *regs)
 {
-	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
-	printk("%s =======================\n", log_lvl);
+	if (regs->flags & X86_EFLAGS_IF)
+		local_irq_enable();
 }
 
-void show_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp)
+static inline void preempt_conditional_sti(struct pt_regs *regs)
 {
-	show_trace_log_lvl(task, regs, stack, bp, "");
+	inc_preempt_count();
+	if (regs->flags & X86_EFLAGS_IF)
+		local_irq_enable();
 }
 
-static void
-show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		   unsigned long *sp, unsigned long bp, char *log_lvl)
+static inline void preempt_conditional_cli(struct pt_regs *regs)
 {
-	unsigned long *stack;
-	int i;
-
-	if (sp == NULL) {
-		if (task)
-			sp = (unsigned long *)task->thread.sp;
-		else
-			sp = (unsigned long *)&sp;
-	}
-
-	stack = sp;
-	for (i = 0; i < kstack_depth_to_print; i++) {
-		if (kstack_end(stack))
-			break;
-		if (i && ((i % 8) == 0))
-			printk("\n%s       ", log_lvl);
-		printk("%08lx ", *stack++);
-	}
-	printk("\n%sCall Trace:\n", log_lvl);
-
-	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
+	if (regs->flags & X86_EFLAGS_IF)
+		local_irq_disable();
+	dec_preempt_count();
 }
 
-void show_stack(struct task_struct *task, unsigned long *sp)
+#ifdef CONFIG_X86_32
+static inline void
+die_if_kernel(const char *str, struct pt_regs *regs, long err)
 {
-	printk("       ");
-	show_stack_log_lvl(task, NULL, sp, 0, "");
+	if (!user_mode_vm(regs))
+		die(str, regs, err);
 }
 
 /*
- * The architecture-independent dump_stack generator
+ * Perform the lazy TSS's I/O bitmap copy. If the TSS has an
+ * invalid offset set (the LAZY one) and the faulting thread has
+ * a valid I/O bitmap pointer, we copy the I/O bitmap in the TSS,
+ * we set the offset field correctly and return 1.
  */
-void dump_stack(void)
+static int lazy_iobitmap_copy(void)
 {
-	unsigned long bp = 0;
-	unsigned long stack;
-
-#ifdef CONFIG_FRAME_POINTER
-	if (!bp)
-		asm("movl %%ebp, %0" : "=r" (bp):);
-#endif
-
-	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
-		current->pid, current->comm, print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
-
-	show_trace(current, NULL, &stack, bp);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
-void show_registers(struct pt_regs *regs)
-{
-	int i;
-
-	print_modules();
-	__show_registers(regs, 0);
-
-	printk(KERN_EMERG "Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)",
-		TASK_COMM_LEN, current->comm, task_pid_nr(current),
-		current_thread_info(), current, task_thread_info(current));
-	/*
-	 * When in-kernel, we also print out the stack and code at the
-	 * time of the fault..
-	 */
-	if (!user_mode_vm(regs)) {
-		unsigned int code_prologue = code_bytes * 43 / 64;
-		unsigned int code_len = code_bytes;
-		unsigned char c;
-		u8 *ip;
-
-		printk("\n" KERN_EMERG "Stack: ");
-		show_stack_log_lvl(NULL, regs, &regs->sp, 0, KERN_EMERG);
+	struct thread_struct *thread;
+	struct tss_struct *tss;
+	int cpu;
 
-		printk(KERN_EMERG "Code: ");
+	cpu = get_cpu();
+	tss = &per_cpu(init_tss, cpu);
+	thread = &current->thread;
 
-		ip = (u8 *)regs->ip - code_prologue;
-		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
-			/* try starting at EIP */
-			ip = (u8 *)regs->ip;
-			code_len = code_len - code_prologue + 1;
-		}
-		for (i = 0; i < code_len; i++, ip++) {
-			if (ip < (u8 *)PAGE_OFFSET ||
-					probe_kernel_address(ip, c)) {
-				printk(" Bad EIP value.");
-				break;
-			}
-			if (ip == (u8 *)regs->ip)
-				printk("<%02x> ", c);
-			else
-				printk("%02x ", c);
+	if (tss->x86_tss.io_bitmap_base == INVALID_IO_BITMAP_OFFSET_LAZY &&
+	    thread->io_bitmap_ptr) {
+		memcpy(tss->io_bitmap, thread->io_bitmap_ptr,
+		       thread->io_bitmap_max);
+		/*
+		 * If the previously set map was extending to higher ports
+		 * than the current one, pad extra space with 0xff (no access).
+		 */
+		if (thread->io_bitmap_max < tss->io_bitmap_max) {
+			memset((char *) tss->io_bitmap +
+				thread->io_bitmap_max, 0xff,
+				tss->io_bitmap_max - thread->io_bitmap_max);
 		}
-	}
-	printk("\n");
-}
-
-int is_valid_bugaddr(unsigned long ip)
-{
-	unsigned short ud2;
-
-	if (ip < PAGE_OFFSET)
-		return 0;
-	if (probe_kernel_address((unsigned short *)ip, ud2))
-		return 0;
-
-	return ud2 == 0x0b0f;
-}
-
-static raw_spinlock_t die_lock = __RAW_SPIN_LOCK_UNLOCKED;
-static int die_owner = -1;
-static unsigned int die_nest_count;
-
-unsigned __kprobes long oops_begin(void)
-{
-	unsigned long flags;
-
-	oops_enter();
-
-	if (die_owner != raw_smp_processor_id()) {
-		console_verbose();
-		raw_local_irq_save(flags);
-		__raw_spin_lock(&die_lock);
-		die_owner = smp_processor_id();
-		die_nest_count = 0;
-		bust_spinlocks(1);
-	} else {
-		raw_local_irq_save(flags);
-	}
-	die_nest_count++;
-	return flags;
-}
-
-void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
-{
-	bust_spinlocks(0);
-	die_owner = -1;
-	add_taint(TAINT_DIE);
-	__raw_spin_unlock(&die_lock);
-	raw_local_irq_restore(flags);
-
-	if (!regs)
-		return;
-
-	if (kexec_should_crash(current))
-		crash_kexec(regs);
-
-	if (in_interrupt())
-		panic("Fatal exception in interrupt");
-
-	if (panic_on_oops)
-		panic("Fatal exception");
-
-	oops_exit();
-	do_exit(signr);
-}
-
-int __kprobes __die(const char *str, struct pt_regs *regs, long err)
-{
-	unsigned short ss;
-	unsigned long sp;
+		tss->io_bitmap_max = thread->io_bitmap_max;
+		tss->x86_tss.io_bitmap_base = IO_BITMAP_OFFSET;
+		tss->io_bitmap_owner = thread;
+		put_cpu();
 
-	printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);
-#ifdef CONFIG_PREEMPT
-	printk("PREEMPT ");
-#endif
-#ifdef CONFIG_SMP
-	printk("SMP ");
-#endif
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	printk("DEBUG_PAGEALLOC");
-#endif
-	printk("\n");
-	if (notify_die(DIE_OOPS, str, regs, err,
-			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
 		return 1;
-
-	show_registers(regs);
-	/* Executive summary in case the oops scrolled away */
-	sp = (unsigned long) (&regs->sp);
-	savesegment(ss, ss);
-	if (user_mode(regs)) {
-		sp = regs->sp;
-		ss = regs->ss & 0xffff;
 	}
-	printk(KERN_EMERG "EIP: [<%08lx>] ", regs->ip);
-	print_symbol("%s", regs->ip);
-	printk(" SS:ESP %04x:%08lx\n", ss, sp);
-	return 0;
-}
-
-/*
- * This is gone through when something in the kernel has done something bad
- * and is about to be terminated:
- */
-void die(const char *str, struct pt_regs *regs, long err)
-{
-	unsigned long flags = oops_begin();
-
-	if (die_nest_count < 3) {
-		report_bug(regs->ip, regs);
-
-		if (__die(str, regs, err))
-			regs = NULL;
-	} else {
-		printk(KERN_EMERG "Recursive die() failure, output suppressed\n");
-	}
-
-	oops_end(flags, regs, SIGSEGV);
-}
+	put_cpu();
 
-static inline void
-die_if_kernel(const char *str, struct pt_regs *regs, long err)
-{
-	if (!user_mode_vm(regs))
-		die(str, regs, err);
+	return 0;
 }
+#endif
 
 static void __kprobes
-do_trap(int trapnr, int signr, char *str, int vm86, struct pt_regs *regs,
+do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	long error_code, siginfo_t *info)
 {
 	struct task_struct *tsk = current;
 
+#ifdef CONFIG_X86_32
 	if (regs->flags & X86_VM_MASK) {
-		if (vm86)
+		/*
+		 * traps 0, 1, 3, 4, and 5 should be forwarded to vm86.
+		 * On nmi (interrupt 2), do_trap should not be called.
+		 */
+		if (trapnr < 6)
 			goto vm86_trap;
 		goto trap_signal;
 	}
+#endif
 
 	if (!user_mode(regs))
 		goto kernel_trap;
 
+#ifdef CONFIG_X86_32
 trap_signal:
+#endif
 	/*
 	 * We want error_code and trap_no set for userspace faults and
 	 * kernelspace faults which result in die(), but not
@@ -501,6 +197,18 @@ trap_signal:
 	tsk->thread.error_code = error_code;
 	tsk->thread.trap_no = trapnr;
 
+#ifdef CONFIG_X86_64
+	if (show_unhandled_signals && unhandled_signal(tsk, signr) &&
+	    printk_ratelimit()) {
+		printk(KERN_INFO
+		       "%s[%d] trap %s ip:%lx sp:%lx error:%lx",
+		       tsk->comm, tsk->pid, str,
+		       regs->ip, regs->sp, error_code);
+		print_vma_addr(" in ", regs->ip);
+		printk("\n");
+	}
+#endif
+
 	if (info)
 		force_sig_info(signr, info, tsk);
 	else
@@ -515,120 +223,98 @@ kernel_trap:
 	}
 	return;
 
+#ifdef CONFIG_X86_32
 vm86_trap:
 	if (handle_vm86_trap((struct kernel_vm86_regs *) regs,
 						error_code, trapnr))
 		goto trap_signal;
 	return;
+#endif
 }
 
 #define DO_ERROR(trapnr, signr, str, name)				\
-void do_##name(struct pt_regs *regs, long error_code)			\
-{									\
-	trace_hardirqs_fixup();						\
-	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-							== NOTIFY_STOP)	\
-		return;							\
-	do_trap(trapnr, signr, str, 0, regs, error_code, NULL);		\
-}
-
-#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr, irq)	\
-void do_##name(struct pt_regs *regs, long error_code)			\
-{									\
-	siginfo_t info;							\
-	if (irq)							\
-		local_irq_enable();					\
-	info.si_signo = signr;						\
-	info.si_errno = 0;						\
-	info.si_code = sicode;						\
-	info.si_addr = (void __user *)siaddr;				\
-	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-							== NOTIFY_STOP)	\
-		return;							\
-	do_trap(trapnr, signr, str, 0, regs, error_code, &info);	\
-}
-
-#define DO_VM86_ERROR(trapnr, signr, str, name)				\
-void do_##name(struct pt_regs *regs, long error_code)			\
+dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
 							== NOTIFY_STOP)	\
 		return;							\
-	do_trap(trapnr, signr, str, 1, regs, error_code, NULL);		\
+	conditional_sti(regs);						\
+	do_trap(trapnr, signr, str, regs, error_code, NULL);		\
 }
 
-#define DO_VM86_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)	\
-void do_##name(struct pt_regs *regs, long error_code)			\
+#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)		\
+dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
 	siginfo_t info;							\
 	info.si_signo = signr;						\
 	info.si_errno = 0;						\
 	info.si_code = sicode;						\
 	info.si_addr = (void __user *)siaddr;				\
-	trace_hardirqs_fixup();						\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
 							== NOTIFY_STOP)	\
 		return;							\
-	do_trap(trapnr, signr, str, 1, regs, error_code, &info);	\
+	conditional_sti(regs);						\
+	do_trap(trapnr, signr, str, regs, error_code, &info);		\
 }
 
-DO_VM86_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
-#ifndef CONFIG_KPROBES
-DO_VM86_ERROR(3, SIGTRAP, "int3", int3)
-#endif
-DO_VM86_ERROR(4, SIGSEGV, "overflow", overflow)
-DO_VM86_ERROR(5, SIGSEGV, "bounds", bounds)
-DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip, 0)
+DO_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
+DO_ERROR(4, SIGSEGV, "overflow", overflow)
+DO_ERROR(5, SIGSEGV, "bounds", bounds)
+DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip)
 DO_ERROR(9, SIGFPE, "coprocessor segment overrun", coprocessor_segment_overrun)
 DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
 DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
+#ifdef CONFIG_X86_32
 DO_ERROR(12, SIGBUS, "stack segment", stack_segment)
-DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0, 0)
-DO_ERROR_INFO(32, SIGILL, "iret exception", iret_error, ILL_BADSTK, 0, 1)
+#endif
+DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
+
+#ifdef CONFIG_X86_64
+/* Runs on IST stack */
+dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
+{
+	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
+			12, SIGBUS) == NOTIFY_STOP)
+		return;
+	preempt_conditional_sti(regs);
+	do_trap(12, SIGBUS, "stack segment", regs, error_code, NULL);
+	preempt_conditional_cli(regs);
+}
 
-void __kprobes
+dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
+{
+	static const char str[] = "double fault";
+	struct task_struct *tsk = current;
+
+	/* Return not checked because double check cannot be ignored */
+	notify_die(DIE_TRAP, str, regs, error_code, 8, SIGSEGV);
+
+	tsk->thread.error_code = error_code;
+	tsk->thread.trap_no = 8;
+
+	/* This is always a kernel trap and never fixable (and thus must
+	   never return). */
+	for (;;)
+		die(str, regs, error_code);
+}
+#endif
+
+dotraplinkage void __kprobes
 do_general_protection(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk;
-	struct thread_struct *thread;
-	struct tss_struct *tss;
-	int cpu;
 
-	cpu = get_cpu();
-	tss = &per_cpu(init_tss, cpu);
-	thread = &current->thread;
-
-	/*
-	 * Perform the lazy TSS's I/O bitmap copy. If the TSS has an
-	 * invalid offset set (the LAZY one) and the faulting thread has
-	 * a valid I/O bitmap pointer, we copy the I/O bitmap in the TSS
-	 * and we set the offset field correctly. Then we let the CPU to
-	 * restart the faulting instruction.
-	 */
-	if (tss->x86_tss.io_bitmap_base == INVALID_IO_BITMAP_OFFSET_LAZY &&
-	    thread->io_bitmap_ptr) {
-		memcpy(tss->io_bitmap, thread->io_bitmap_ptr,
-		       thread->io_bitmap_max);
-		/*
-		 * If the previously set map was extending to higher ports
-		 * than the current one, pad extra space with 0xff (no access).
-		 */
-		if (thread->io_bitmap_max < tss->io_bitmap_max) {
-			memset((char *) tss->io_bitmap +
-				thread->io_bitmap_max, 0xff,
-				tss->io_bitmap_max - thread->io_bitmap_max);
-		}
-		tss->io_bitmap_max = thread->io_bitmap_max;
-		tss->x86_tss.io_bitmap_base = IO_BITMAP_OFFSET;
-		tss->io_bitmap_owner = thread;
-		put_cpu();
+	conditional_sti(regs);
 
+#ifdef CONFIG_X86_32
+	if (lazy_iobitmap_copy()) {
+		/* restart the faulting instruction */
 		return;
 	}
-	put_cpu();
 
 	if (regs->flags & X86_VM_MASK)
 		goto gp_in_vm86;
+#endif
 
 	tsk = current;
 	if (!user_mode(regs))
@@ -650,10 +336,12 @@ do_general_protection(struct pt_regs *regs, long error_code)
 	force_sig(SIGSEGV, tsk);
 	return;
 
+#ifdef CONFIG_X86_32
 gp_in_vm86:
 	local_irq_enable();
 	handle_vm86_fault((struct kernel_vm86_regs *) regs, error_code);
 	return;
+#endif
 
 gp_in_kernel:
 	if (fixup_exception(regs))
@@ -690,7 +378,8 @@ mem_parity_error(unsigned char reason, struct pt_regs *regs)
 	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
 
 	/* Clear and disable the memory parity error line. */
-	clear_mem_error(reason);
+	reason = (reason & 0xf) | 4;
+	outb(reason, 0x61);
 }
 
 static notrace __kprobes void
@@ -716,7 +405,8 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 static notrace __kprobes void
 unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 {
-	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) == NOTIFY_STOP)
+	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
+			NOTIFY_STOP)
 		return;
 #ifdef CONFIG_MCA
 	/*
@@ -739,6 +429,7 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
 }
 
+#ifdef CONFIG_X86_32
 static DEFINE_SPINLOCK(nmi_print_lock);
 
 void notrace __kprobes die_nmi(char *str, struct pt_regs *regs, int do_panic)
@@ -773,6 +464,7 @@ void notrace __kprobes die_nmi(char *str, struct pt_regs *regs, int do_panic)
 
 	do_exit(SIGSEGV);
 }
+#endif
 
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
@@ -812,22 +504,25 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		mem_parity_error(reason, regs);
 	if (reason & 0x40)
 		io_check_error(reason, regs);
+#ifdef CONFIG_X86_32
 	/*
 	 * Reassert NMI in case it became active meanwhile
 	 * as it's edge-triggered:
 	 */
 	reassert_nmi();
+#endif
 }
 
-notrace __kprobes void do_nmi(struct pt_regs *regs, long error_code)
+dotraplinkage notrace __kprobes void
+do_nmi(struct pt_regs *regs, long error_code)
 {
-	int cpu;
-
 	nmi_enter();
 
-	cpu = smp_processor_id();
-
-	++nmi_count(cpu);
+#ifdef CONFIG_X86_32
+	{ int cpu; cpu = smp_processor_id(); ++nmi_count(cpu); }
+#else
+	add_pda(__nmi_count, 1);
+#endif
 
 	if (!ignore_nmis)
 		default_do_nmi(regs);
@@ -847,21 +542,44 @@ void restart_nmi(void)
 	acpi_nmi_enable();
 }
 
-#ifdef CONFIG_KPROBES
-void __kprobes do_int3(struct pt_regs *regs, long error_code)
+/* May run on IST stack. */
+dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
-	trace_hardirqs_fixup();
-
+#ifdef CONFIG_KPROBES
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
 		return;
-	/*
-	 * This is an interrupt gate, because kprobes wants interrupts
-	 * disabled. Normal trap handlers don't.
-	 */
-	restore_interrupts(regs);
+#else
+	if (notify_die(DIE_TRAP, "int3", regs, error_code, 3, SIGTRAP)
+			== NOTIFY_STOP)
+		return;
+#endif
+
+	preempt_conditional_sti(regs);
+	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
+	preempt_conditional_cli(regs);
+}
 
-	do_trap(3, SIGTRAP, "int3", 1, regs, error_code, NULL);
+#ifdef CONFIG_X86_64
+/* Help handler running on IST stack to switch back to user stack
+   for scheduling or signal handling. The actual stack switch is done in
+   entry.S */
+asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
+{
+	struct pt_regs *regs = eregs;
+	/* Did already sync */
+	if (eregs == (struct pt_regs *)eregs->sp)
+		;
+	/* Exception from user space */
+	else if (user_mode(eregs))
+		regs = task_pt_regs(current);
+	/* Exception from kernel and interrupts are enabled. Move to
+	   kernel process stack. */
+	else if (eregs->flags & X86_EFLAGS_IF)
+		regs = (struct pt_regs *)(eregs->sp -= sizeof(struct pt_regs));
+	if (eregs != regs)
+		*regs = *eregs;
+	return regs;
 }
 #endif
 
@@ -886,15 +604,15 @@ void __kprobes do_int3(struct pt_regs *regs, long error_code)
  * about restoring all the debug state, and ptrace doesn't have to
  * find every occurrence of the TF bit that could be saved away even
  * by user code)
+ *
+ * May run on IST stack.
  */
-void __kprobes do_debug(struct pt_regs *regs, long error_code)
+dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
-	unsigned int condition;
+	unsigned long condition;
 	int si_code;
 
-	trace_hardirqs_fixup();
-
 	get_debugreg(condition, 6);
 
 	/*
@@ -906,9 +624,9 @@ void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
 						SIGTRAP) == NOTIFY_STOP)
 		return;
+
 	/* It's safe to allow irq's after DR6 has been saved */
-	if (regs->flags & X86_EFLAGS_IF)
-		local_irq_enable();
+	preempt_conditional_sti(regs);
 
 	/* Mask out spurious debug traps due to lazy DR7 setting */
 	if (condition & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) {
@@ -916,8 +634,10 @@ void __kprobes do_debug(struct pt_regs *regs, long error_code)
 			goto clear_dr7;
 	}
 
+#ifdef CONFIG_X86_32
 	if (regs->flags & X86_VM_MASK)
 		goto debug_vm86;
+#endif
 
 	/* Save debug status register where ptrace can see it */
 	tsk->thread.debugreg6 = condition;
@@ -927,16 +647,11 @@ void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	 * kernel space (but re-enable TF when returning to user mode).
 	 */
 	if (condition & DR_STEP) {
-		/*
-		 * We already checked v86 mode above, so we can
-		 * check for kernel mode by just checking the CPL
-		 * of CS.
-		 */
 		if (!user_mode(regs))
 			goto clear_TF_reenable;
 	}
 
-	si_code = get_si_code((unsigned long)condition);
+	si_code = get_si_code(condition);
 	/* Ok, finally something we can handle */
 	send_sigtrap(tsk, regs, error_code, si_code);
 
@@ -946,18 +661,37 @@ void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	 */
 clear_dr7:
 	set_debugreg(0, 7);
+	preempt_conditional_cli(regs);
 	return;
 
+#ifdef CONFIG_X86_32
 debug_vm86:
 	handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code, 1);
+	preempt_conditional_cli(regs);
 	return;
+#endif
 
 clear_TF_reenable:
 	set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
 	regs->flags &= ~X86_EFLAGS_TF;
+	preempt_conditional_cli(regs);
 	return;
 }
 
+#ifdef CONFIG_X86_64
+static int kernel_math_error(struct pt_regs *regs, const char *str, int trapnr)
+{
+	if (fixup_exception(regs))
+		return 1;
+
+	notify_die(DIE_GPF, str, regs, 0, trapnr, SIGFPE);
+	/* Illegal floating point operation in the kernel */
+	current->thread.trap_no = trapnr;
+	die(str, regs, 0);
+	return 0;
+}
+#endif
+
 /*
  * Note that we play around with the 'TS' bit in an attempt to get
  * the correct behaviour even in the presence of the asynchronous
@@ -994,7 +728,9 @@ void math_error(void __user *ip)
 	swd = get_fpu_swd(task);
 	switch (swd & ~cwd & 0x3f) {
 	case 0x000: /* No unmasked exception */
+#ifdef CONFIG_X86_32
 		return;
+#endif
 	default: /* Multiple exceptions */
 		break;
 	case 0x001: /* Invalid Op */
@@ -1022,9 +758,18 @@ void math_error(void __user *ip)
 	force_sig_info(SIGFPE, &info, task);
 }
 
-void do_coprocessor_error(struct pt_regs *regs, long error_code)
+dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 {
+	conditional_sti(regs);
+
+#ifdef CONFIG_X86_32
 	ignore_fpu_irq = 1;
+#else
+	if (!user_mode(regs) &&
+	    kernel_math_error(regs, "kernel x87 math error", 16))
+		return;
+#endif
+
 	math_error((void __user *)regs->ip);
 }
 
@@ -1076,8 +821,12 @@ static void simd_math_error(void __user *ip)
 	force_sig_info(SIGFPE, &info, task);
 }
 
-void do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
+dotraplinkage void
+do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 {
+	conditional_sti(regs);
+
+#ifdef CONFIG_X86_32
 	if (cpu_has_xmm) {
 		/* Handle SIMD FPU exceptions on PIII+ processors. */
 		ignore_fpu_irq = 1;
@@ -1096,16 +845,25 @@ void do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 	current->thread.error_code = error_code;
 	die_if_kernel("cache flush denied", regs, error_code);
 	force_sig(SIGSEGV, current);
+#else
+	if (!user_mode(regs) &&
+			kernel_math_error(regs, "kernel simd math error", 19))
+		return;
+	simd_math_error((void __user *)regs->ip);
+#endif
 }
 
-void do_spurious_interrupt_bug(struct pt_regs *regs, long error_code)
+dotraplinkage void
+do_spurious_interrupt_bug(struct pt_regs *regs, long error_code)
 {
+	conditional_sti(regs);
 #if 0
 	/* No need to warn about this any longer. */
 	printk(KERN_INFO "Ignoring P6 Local APIC Spurious Interrupt Bug...\n");
 #endif
 }
 
+#ifdef CONFIG_X86_32
 unsigned long patch_espfix_desc(unsigned long uesp, unsigned long kesp)
 {
 	struct desc_struct *gdt = get_cpu_gdt_table(smp_processor_id());
@@ -1124,6 +882,15 @@ unsigned long patch_espfix_desc(unsigned long uesp, unsigned long kesp)
 
 	return new_kesp;
 }
+#else
+asmlinkage void __attribute__((weak)) smp_thermal_interrupt(void)
+{
+}
+
+asmlinkage void __attribute__((weak)) mce_threshold_interrupt(void)
+{
+}
+#endif
 
 /*
  * 'math_state_restore()' saves the current math information in the
@@ -1156,14 +923,24 @@ asmlinkage void math_state_restore(void)
 	}
 
 	clts();				/* Allow maths ops (or we recurse) */
+#ifdef CONFIG_X86_32
 	restore_fpu(tsk);
+#else
+	/*
+	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
+	 */
+	if (unlikely(restore_fpu_checking(tsk))) {
+		stts();
+		force_sig(SIGSEGV, tsk);
+		return;
+	}
+#endif
 	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
 	tsk->fpu_counter++;
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
 
 #ifndef CONFIG_MATH_EMULATION
-
 asmlinkage void math_emulate(long arg)
 {
 	printk(KERN_EMERG
@@ -1172,12 +949,54 @@ asmlinkage void math_emulate(long arg)
 	force_sig(SIGFPE, current);
 	schedule();
 }
-
 #endif /* CONFIG_MATH_EMULATION */
 
+dotraplinkage void __kprobes
+do_device_not_available(struct pt_regs *regs, long error)
+{
+#ifdef CONFIG_X86_32
+	if (read_cr0() & X86_CR0_EM) {
+		conditional_sti(regs);
+		math_emulate(0);
+	} else {
+		math_state_restore(); /* interrupts still off */
+		conditional_sti(regs);
+	}
+#else
+	math_state_restore();
+#endif
+}
+
+#ifdef CONFIG_X86_32
+#ifdef CONFIG_X86_MCE
+dotraplinkage void __kprobes do_machine_check(struct pt_regs *regs, long error)
+{
+	conditional_sti(regs);
+	machine_check_vector(regs, error);
+}
+#endif
+
+dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
+{
+	siginfo_t info;
+	local_irq_enable();
+
+	info.si_signo = SIGILL;
+	info.si_errno = 0;
+	info.si_code = ILL_BADSTK;
+	info.si_addr = 0;
+	if (notify_die(DIE_TRAP, "iret exception",
+			regs, error_code, 32, SIGILL) == NOTIFY_STOP)
+		return;
+	do_trap(32, SIGILL, "iret exception", regs, error_code, &info);
+}
+#endif
+
 void __init trap_init(void)
 {
+#ifdef CONFIG_X86_32
 	int i;
+#endif
 
 #ifdef CONFIG_EISA
 	void __iomem *p = early_ioremap(0x0FFFD9, 4);
@@ -1187,29 +1006,40 @@ void __init trap_init(void)
 	early_iounmap(p, 4);
 #endif
 
-	set_trap_gate(0, &divide_error);
-	set_intr_gate(1, &debug);
-	set_intr_gate(2, &nmi);
-	set_system_intr_gate(3, &int3); /* int3 can be called from all */
-	set_system_gate(4, &overflow); /* int4 can be called from all */
-	set_trap_gate(5, &bounds);
-	set_trap_gate(6, &invalid_op);
-	set_trap_gate(7, &device_not_available);
+	set_intr_gate(0, &divide_error);
+	set_intr_gate_ist(1, &debug, DEBUG_STACK);
+	set_intr_gate_ist(2, &nmi, NMI_STACK);
+	/* int3 can be called from all */
+	set_system_intr_gate_ist(3, &int3, DEBUG_STACK);
+	/* int4 can be called from all */
+	set_system_intr_gate(4, &overflow);
+	set_intr_gate(5, &bounds);
+	set_intr_gate(6, &invalid_op);
+	set_intr_gate(7, &device_not_available);
+#ifdef CONFIG_X86_32
 	set_task_gate(8, GDT_ENTRY_DOUBLEFAULT_TSS);
-	set_trap_gate(9, &coprocessor_segment_overrun);
-	set_trap_gate(10, &invalid_TSS);
-	set_trap_gate(11, &segment_not_present);
-	set_trap_gate(12, &stack_segment);
-	set_trap_gate(13, &general_protection);
+#else
+	set_intr_gate_ist(8, &double_fault, DOUBLEFAULT_STACK);
+#endif
+	set_intr_gate(9, &coprocessor_segment_overrun);
+	set_intr_gate(10, &invalid_TSS);
+	set_intr_gate(11, &segment_not_present);
+	set_intr_gate_ist(12, &stack_segment, STACKFAULT_STACK);
+	set_intr_gate(13, &general_protection);
 	set_intr_gate(14, &page_fault);
-	set_trap_gate(15, &spurious_interrupt_bug);
-	set_trap_gate(16, &coprocessor_error);
-	set_trap_gate(17, &alignment_check);
+	set_intr_gate(15, &spurious_interrupt_bug);
+	set_intr_gate(16, &coprocessor_error);
+	set_intr_gate(17, &alignment_check);
 #ifdef CONFIG_X86_MCE
-	set_trap_gate(18, &machine_check);
+	set_intr_gate_ist(18, &machine_check, MCE_STACK);
 #endif
-	set_trap_gate(19, &simd_coprocessor_error);
+	set_intr_gate(19, &simd_coprocessor_error);
 
+#ifdef CONFIG_IA32_EMULATION
+	set_system_intr_gate(IA32_SYSCALL_VECTOR, ia32_syscall);
+#endif
+
+#ifdef CONFIG_X86_32
 	if (cpu_has_fxsr) {
 		printk(KERN_INFO "Enabling fast FPU save and restore... ");
 		set_in_cr4(X86_CR4_OSFXSR);
@@ -1222,36 +1052,20 @@ void __init trap_init(void)
 		printk("done.\n");
 	}
 
-	set_system_gate(SYSCALL_VECTOR, &system_call);
+	set_system_trap_gate(SYSCALL_VECTOR, &system_call);
 
 	/* Reserve all the builtin and the syscall vector: */
 	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
 		set_bit(i, used_vectors);
 
 	set_bit(SYSCALL_VECTOR, used_vectors);
-
+#endif
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
 	cpu_init();
 
+#ifdef CONFIG_X86_32
 	trap_init_hook();
+#endif
 }
-
-static int __init kstack_setup(char *s)
-{
-	kstack_depth_to_print = simple_strtoul(s, NULL, 0);
-
-	return 1;
-}
-__setup("kstack=", kstack_setup);
-
-static int __init code_bytes_setup(char *s)
-{
-	code_bytes = simple_strtoul(s, NULL, 0);
-	if (code_bytes > 8192)
-		code_bytes = 8192;
-
-	return 1;
-}
-__setup("code_bytes=", code_bytes_setup);
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
deleted file mode 100644
index 9c0ac0c..0000000
--- a/arch/x86/kernel/traps_64.c
+++ /dev/null
@@ -1,1214 +0,0 @@
-/*
- *  Copyright (C) 1991, 1992  Linus Torvalds
- *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
- *
- *  Pentium III FXSR, SSE support
- *	Gareth Hughes <gareth@valinux.com>, May 2000
- */
-
-/*
- * 'Traps.c' handles hardware traps and faults after we have saved some
- * state in 'entry.S'.
- */
-#include <linux/moduleparam.h>
-#include <linux/interrupt.h>
-#include <linux/kallsyms.h>
-#include <linux/spinlock.h>
-#include <linux/kprobes.h>
-#include <linux/uaccess.h>
-#include <linux/utsname.h>
-#include <linux/kdebug.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/ptrace.h>
-#include <linux/string.h>
-#include <linux/unwind.h>
-#include <linux/delay.h>
-#include <linux/errno.h>
-#include <linux/kexec.h>
-#include <linux/sched.h>
-#include <linux/timer.h>
-#include <linux/init.h>
-#include <linux/bug.h>
-#include <linux/nmi.h>
-#include <linux/mm.h>
-#include <linux/smp.h>
-#include <linux/io.h>
-
-#if defined(CONFIG_EDAC)
-#include <linux/edac.h>
-#endif
-
-#include <asm/stacktrace.h>
-#include <asm/processor.h>
-#include <asm/debugreg.h>
-#include <asm/atomic.h>
-#include <asm/system.h>
-#include <asm/unwind.h>
-#include <asm/desc.h>
-#include <asm/i387.h>
-#include <asm/pgalloc.h>
-#include <asm/proto.h>
-#include <asm/pda.h>
-#include <asm/traps.h>
-
-#include <mach_traps.h>
-
-int panic_on_unrecovered_nmi;
-int kstack_depth_to_print = 12;
-static unsigned int code_bytes = 64;
-static int ignore_nmis;
-static int die_counter;
-
-static inline void conditional_sti(struct pt_regs *regs)
-{
-	if (regs->flags & X86_EFLAGS_IF)
-		local_irq_enable();
-}
-
-static inline void preempt_conditional_sti(struct pt_regs *regs)
-{
-	inc_preempt_count();
-	if (regs->flags & X86_EFLAGS_IF)
-		local_irq_enable();
-}
-
-static inline void preempt_conditional_cli(struct pt_regs *regs)
-{
-	if (regs->flags & X86_EFLAGS_IF)
-		local_irq_disable();
-	/* Make sure to not schedule here because we could be running
-	   on an exception stack. */
-	dec_preempt_count();
-}
-
-void printk_address(unsigned long address, int reliable)
-{
-	printk(" [<%016lx>] %s%pS\n",
-			address, reliable ?	"" : "? ", (void *) address);
-}
-
-static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
-					unsigned *usedp, char **idp)
-{
-	static char ids[][8] = {
-		[DEBUG_STACK - 1] = "#DB",
-		[NMI_STACK - 1] = "NMI",
-		[DOUBLEFAULT_STACK - 1] = "#DF",
-		[STACKFAULT_STACK - 1] = "#SS",
-		[MCE_STACK - 1] = "#MC",
-#if DEBUG_STKSZ > EXCEPTION_STKSZ
-		[N_EXCEPTION_STACKS ...
-			N_EXCEPTION_STACKS + DEBUG_STKSZ / EXCEPTION_STKSZ - 2] = "#DB[?]"
-#endif
-	};
-	unsigned k;
-
-	/*
-	 * Iterate over all exception stacks, and figure out whether
-	 * 'stack' is in one of them:
-	 */
-	for (k = 0; k < N_EXCEPTION_STACKS; k++) {
-		unsigned long end = per_cpu(orig_ist, cpu).ist[k];
-		/*
-		 * Is 'stack' above this exception frame's end?
-		 * If yes then skip to the next frame.
-		 */
-		if (stack >= end)
-			continue;
-		/*
-		 * Is 'stack' above this exception frame's start address?
-		 * If yes then we found the right frame.
-		 */
-		if (stack >= end - EXCEPTION_STKSZ) {
-			/*
-			 * Make sure we only iterate through an exception
-			 * stack once. If it comes up for the second time
-			 * then there's something wrong going on - just
-			 * break out and return NULL:
-			 */
-			if (*usedp & (1U << k))
-				break;
-			*usedp |= 1U << k;
-			*idp = ids[k];
-			return (unsigned long *)end;
-		}
-		/*
-		 * If this is a debug stack, and if it has a larger size than
-		 * the usual exception stacks, then 'stack' might still
-		 * be within the lower portion of the debug stack:
-		 */
-#if DEBUG_STKSZ > EXCEPTION_STKSZ
-		if (k == DEBUG_STACK - 1 && stack >= end - DEBUG_STKSZ) {
-			unsigned j = N_EXCEPTION_STACKS - 1;
-
-			/*
-			 * Black magic. A large debug stack is composed of
-			 * multiple exception stack entries, which we
-			 * iterate through now. Dont look:
-			 */
-			do {
-				++j;
-				end -= EXCEPTION_STKSZ;
-				ids[j][4] = '1' + (j - N_EXCEPTION_STACKS);
-			} while (stack < end - EXCEPTION_STKSZ);
-			if (*usedp & (1U << j))
-				break;
-			*usedp |= 1U << j;
-			*idp = ids[j];
-			return (unsigned long *)end;
-		}
-#endif
-	}
-	return NULL;
-}
-
-/*
- * x86-64 can have up to three kernel stacks:
- * process stack
- * interrupt stack
- * severe exception (double fault, nmi, stack fault, debug, mce) hardware stack
- */
-
-static inline int valid_stack_ptr(struct thread_info *tinfo,
-			void *p, unsigned int size, void *end)
-{
-	void *t = tinfo;
-	if (end) {
-		if (p < end && p >= (end-THREAD_SIZE))
-			return 1;
-		else
-			return 0;
-	}
-	return p > t && p < t + THREAD_SIZE - size;
-}
-
-/* The form of the top of the frame on the stack */
-struct stack_frame {
-	struct stack_frame *next_frame;
-	unsigned long return_address;
-};
-
-static inline unsigned long
-print_context_stack(struct thread_info *tinfo,
-		unsigned long *stack, unsigned long bp,
-		const struct stacktrace_ops *ops, void *data,
-		unsigned long *end)
-{
-	struct stack_frame *frame = (struct stack_frame *)bp;
-
-	while (valid_stack_ptr(tinfo, stack, sizeof(*stack), end)) {
-		unsigned long addr;
-
-		addr = *stack;
-		if (__kernel_text_address(addr)) {
-			if ((unsigned long) stack == bp + 8) {
-				ops->address(data, addr, 1);
-				frame = frame->next_frame;
-				bp = (unsigned long) frame;
-			} else {
-				ops->address(data, addr, bp == 0);
-			}
-		}
-		stack++;
-	}
-	return bp;
-}
-
-void dump_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp,
-		const struct stacktrace_ops *ops, void *data)
-{
-	const unsigned cpu = get_cpu();
-	unsigned long *irqstack_end = (unsigned long *)cpu_pda(cpu)->irqstackptr;
-	unsigned used = 0;
-	struct thread_info *tinfo;
-
-	if (!task)
-		task = current;
-
-	if (!stack) {
-		unsigned long dummy;
-		stack = &dummy;
-		if (task && task != current)
-			stack = (unsigned long *)task->thread.sp;
-	}
-
-#ifdef CONFIG_FRAME_POINTER
-	if (!bp) {
-		if (task == current) {
-			/* Grab bp right from our regs */
-			asm("movq %%rbp, %0" : "=r" (bp) : );
-		} else {
-			/* bp is the last reg pushed by switch_to */
-			bp = *(unsigned long *) task->thread.sp;
-		}
-	}
-#endif
-
-	/*
-	 * Print function call entries in all stacks, starting at the
-	 * current stack address. If the stacks consist of nested
-	 * exceptions
-	 */
-	tinfo = task_thread_info(task);
-	for (;;) {
-		char *id;
-		unsigned long *estack_end;
-		estack_end = in_exception_stack(cpu, (unsigned long)stack,
-						&used, &id);
-
-		if (estack_end) {
-			if (ops->stack(data, id) < 0)
-				break;
-
-			bp = print_context_stack(tinfo, stack, bp, ops,
-							data, estack_end);
-			ops->stack(data, "<EOE>");
-			/*
-			 * We link to the next stack via the
-			 * second-to-last pointer (index -2 to end) in the
-			 * exception stack:
-			 */
-			stack = (unsigned long *) estack_end[-2];
-			continue;
-		}
-		if (irqstack_end) {
-			unsigned long *irqstack;
-			irqstack = irqstack_end -
-				(IRQSTACKSIZE - 64) / sizeof(*irqstack);
-
-			if (stack >= irqstack && stack < irqstack_end) {
-				if (ops->stack(data, "IRQ") < 0)
-					break;
-				bp = print_context_stack(tinfo, stack, bp,
-						ops, data, irqstack_end);
-				/*
-				 * We link to the next stack (which would be
-				 * the process stack normally) the last
-				 * pointer (index -1 to end) in the IRQ stack:
-				 */
-				stack = (unsigned long *) (irqstack_end[-1]);
-				irqstack_end = NULL;
-				ops->stack(data, "EOI");
-				continue;
-			}
-		}
-		break;
-	}
-
-	/*
-	 * This handles the process stack:
-	 */
-	bp = print_context_stack(tinfo, stack, bp, ops, data, NULL);
-	put_cpu();
-}
-EXPORT_SYMBOL(dump_trace);
-
-static void
-print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-	print_symbol(msg, symbol);
-	printk("\n");
-}
-
-static void print_trace_warning(void *data, char *msg)
-{
-	printk("%s\n", msg);
-}
-
-static int print_trace_stack(void *data, char *name)
-{
-	printk(" <%s> ", name);
-	return 0;
-}
-
-static void print_trace_address(void *data, unsigned long addr, int reliable)
-{
-	touch_nmi_watchdog();
-	printk_address(addr, reliable);
-}
-
-static const struct stacktrace_ops print_trace_ops = {
-	.warning = print_trace_warning,
-	.warning_symbol = print_trace_warning_symbol,
-	.stack = print_trace_stack,
-	.address = print_trace_address,
-};
-
-static void
-show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp, char *log_lvl)
-{
-	printk("Call Trace:\n");
-	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
-}
-
-void show_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp)
-{
-	show_trace_log_lvl(task, regs, stack, bp, "");
-}
-
-static void
-show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *sp, unsigned long bp, char *log_lvl)
-{
-	unsigned long *stack;
-	int i;
-	const int cpu = smp_processor_id();
-	unsigned long *irqstack_end =
-		(unsigned long *) (cpu_pda(cpu)->irqstackptr);
-	unsigned long *irqstack =
-		(unsigned long *) (cpu_pda(cpu)->irqstackptr - IRQSTACKSIZE);
-
-	/*
-	 * debugging aid: "show_stack(NULL, NULL);" prints the
-	 * back trace for this cpu.
-	 */
-
-	if (sp == NULL) {
-		if (task)
-			sp = (unsigned long *)task->thread.sp;
-		else
-			sp = (unsigned long *)&sp;
-	}
-
-	stack = sp;
-	for (i = 0; i < kstack_depth_to_print; i++) {
-		if (stack >= irqstack && stack <= irqstack_end) {
-			if (stack == irqstack_end) {
-				stack = (unsigned long *) (irqstack_end[-1]);
-				printk(" <EOI> ");
-			}
-		} else {
-		if (((long) stack & (THREAD_SIZE-1)) == 0)
-			break;
-		}
-		if (i && ((i % 4) == 0))
-			printk("\n");
-		printk(" %016lx", *stack++);
-		touch_nmi_watchdog();
-	}
-	printk("\n");
-	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
-}
-
-void show_stack(struct task_struct *task, unsigned long *sp)
-{
-	show_stack_log_lvl(task, NULL, sp, 0, "");
-}
-
-/*
- * The architecture-independent dump_stack generator
- */
-void dump_stack(void)
-{
-	unsigned long bp = 0;
-	unsigned long stack;
-
-#ifdef CONFIG_FRAME_POINTER
-	if (!bp)
-		asm("movq %%rbp, %0" : "=r" (bp) : );
-#endif
-
-	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
-		current->pid, current->comm, print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
-	show_trace(NULL, NULL, &stack, bp);
-}
-EXPORT_SYMBOL(dump_stack);
-
-void show_registers(struct pt_regs *regs)
-{
-	int i;
-	unsigned long sp;
-	const int cpu = smp_processor_id();
-	struct task_struct *cur = cpu_pda(cpu)->pcurrent;
-
-	sp = regs->sp;
-	printk("CPU %d ", cpu);
-	__show_regs(regs);
-	printk("Process %s (pid: %d, threadinfo %p, task %p)\n",
-		cur->comm, cur->pid, task_thread_info(cur), cur);
-
-	/*
-	 * When in-kernel, we also print out the stack and code at the
-	 * time of the fault..
-	 */
-	if (!user_mode(regs)) {
-		unsigned int code_prologue = code_bytes * 43 / 64;
-		unsigned int code_len = code_bytes;
-		unsigned char c;
-		u8 *ip;
-
-		printk("Stack: ");
-		show_stack_log_lvl(NULL, regs, (unsigned long *)sp,
-				regs->bp, "");
-
-		printk(KERN_EMERG "Code: ");
-
-		ip = (u8 *)regs->ip - code_prologue;
-		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
-			/* try starting at RIP */
-			ip = (u8 *)regs->ip;
-			code_len = code_len - code_prologue + 1;
-		}
-		for (i = 0; i < code_len; i++, ip++) {
-			if (ip < (u8 *)PAGE_OFFSET ||
-					probe_kernel_address(ip, c)) {
-				printk(" Bad RIP value.");
-				break;
-			}
-			if (ip == (u8 *)regs->ip)
-				printk("<%02x> ", c);
-			else
-				printk("%02x ", c);
-		}
-	}
-	printk("\n");
-}
-
-int is_valid_bugaddr(unsigned long ip)
-{
-	unsigned short ud2;
-
-	if (__copy_from_user(&ud2, (const void __user *) ip, sizeof(ud2)))
-		return 0;
-
-	return ud2 == 0x0b0f;
-}
-
-static raw_spinlock_t die_lock = __RAW_SPIN_LOCK_UNLOCKED;
-static int die_owner = -1;
-static unsigned int die_nest_count;
-
-unsigned __kprobes long oops_begin(void)
-{
-	int cpu;
-	unsigned long flags;
-
-	oops_enter();
-
-	/* racy, but better than risking deadlock. */
-	raw_local_irq_save(flags);
-	cpu = smp_processor_id();
-	if (!__raw_spin_trylock(&die_lock)) {
-		if (cpu == die_owner)
-			/* nested oops. should stop eventually */;
-		else
-			__raw_spin_lock(&die_lock);
-	}
-	die_nest_count++;
-	die_owner = cpu;
-	console_verbose();
-	bust_spinlocks(1);
-	return flags;
-}
-
-void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
-{
-	die_owner = -1;
-	bust_spinlocks(0);
-	die_nest_count--;
-	if (!die_nest_count)
-		/* Nest count reaches zero, release the lock. */
-		__raw_spin_unlock(&die_lock);
-	raw_local_irq_restore(flags);
-	if (!regs) {
-		oops_exit();
-		return;
-	}
-	if (panic_on_oops)
-		panic("Fatal exception");
-	oops_exit();
-	do_exit(signr);
-}
-
-int __kprobes __die(const char *str, struct pt_regs *regs, long err)
-{
-	printk(KERN_EMERG "%s: %04lx [%u] ", str, err & 0xffff, ++die_counter);
-#ifdef CONFIG_PREEMPT
-	printk("PREEMPT ");
-#endif
-#ifdef CONFIG_SMP
-	printk("SMP ");
-#endif
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	printk("DEBUG_PAGEALLOC");
-#endif
-	printk("\n");
-	if (notify_die(DIE_OOPS, str, regs, err,
-			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
-		return 1;
-
-	show_registers(regs);
-	add_taint(TAINT_DIE);
-	/* Executive summary in case the oops scrolled away */
-	printk(KERN_ALERT "RIP ");
-	printk_address(regs->ip, 1);
-	printk(" RSP <%016lx>\n", regs->sp);
-	if (kexec_should_crash(current))
-		crash_kexec(regs);
-	return 0;
-}
-
-void die(const char *str, struct pt_regs *regs, long err)
-{
-	unsigned long flags = oops_begin();
-
-	if (!user_mode(regs))
-		report_bug(regs->ip, regs);
-
-	if (__die(str, regs, err))
-		regs = NULL;
-	oops_end(flags, regs, SIGSEGV);
-}
-
-notrace __kprobes void
-die_nmi(char *str, struct pt_regs *regs, int do_panic)
-{
-	unsigned long flags;
-
-	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
-		return;
-
-	flags = oops_begin();
-	/*
-	 * We are in trouble anyway, lets at least try
-	 * to get a message out.
-	 */
-	printk(KERN_EMERG "%s", str);
-	printk(" on CPU%d, ip %08lx, registers:\n",
-		smp_processor_id(), regs->ip);
-	show_registers(regs);
-	if (kexec_should_crash(current))
-		crash_kexec(regs);
-	if (do_panic || panic_on_oops)
-		panic("Non maskable interrupt");
-	oops_end(flags, NULL, SIGBUS);
-	nmi_exit();
-	local_irq_enable();
-	do_exit(SIGBUS);
-}
-
-static void __kprobes
-do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
-	long error_code, siginfo_t *info)
-{
-	struct task_struct *tsk = current;
-
-	if (!user_mode(regs))
-		goto kernel_trap;
-
-	/*
-	 * We want error_code and trap_no set for userspace faults and
-	 * kernelspace faults which result in die(), but not
-	 * kernelspace faults which are fixed up.  die() gives the
-	 * process no chance to handle the signal and notice the
-	 * kernel fault information, so that won't result in polluting
-	 * the information about previously queued, but not yet
-	 * delivered, faults.  See also do_general_protection below.
-	 */
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = trapnr;
-
-	if (show_unhandled_signals && unhandled_signal(tsk, signr) &&
-	    printk_ratelimit()) {
-		printk(KERN_INFO
-		       "%s[%d] trap %s ip:%lx sp:%lx error:%lx",
-		       tsk->comm, tsk->pid, str,
-		       regs->ip, regs->sp, error_code);
-		print_vma_addr(" in ", regs->ip);
-		printk("\n");
-	}
-
-	if (info)
-		force_sig_info(signr, info, tsk);
-	else
-		force_sig(signr, tsk);
-	return;
-
-kernel_trap:
-	if (!fixup_exception(regs)) {
-		tsk->thread.error_code = error_code;
-		tsk->thread.trap_no = trapnr;
-		die(str, regs, error_code);
-	}
-	return;
-}
-
-#define DO_ERROR(trapnr, signr, str, name) \
-asmlinkage void do_##name(struct pt_regs *regs, long error_code)	\
-{									\
-	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-							== NOTIFY_STOP)	\
-		return;							\
-	conditional_sti(regs);						\
-	do_trap(trapnr, signr, str, regs, error_code, NULL);		\
-}
-
-#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)		\
-asmlinkage void do_##name(struct pt_regs *regs, long error_code)	\
-{									\
-	siginfo_t info;							\
-	info.si_signo = signr;						\
-	info.si_errno = 0;						\
-	info.si_code = sicode;						\
-	info.si_addr = (void __user *)siaddr;				\
-	trace_hardirqs_fixup();						\
-	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-							== NOTIFY_STOP)	\
-		return;							\
-	conditional_sti(regs);						\
-	do_trap(trapnr, signr, str, regs, error_code, &info);		\
-}
-
-DO_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
-DO_ERROR(4, SIGSEGV, "overflow", overflow)
-DO_ERROR(5, SIGSEGV, "bounds", bounds)
-DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip)
-DO_ERROR(9, SIGFPE, "coprocessor segment overrun", coprocessor_segment_overrun)
-DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
-DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
-DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
-
-/* Runs on IST stack */
-asmlinkage void do_stack_segment(struct pt_regs *regs, long error_code)
-{
-	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
-			12, SIGBUS) == NOTIFY_STOP)
-		return;
-	preempt_conditional_sti(regs);
-	do_trap(12, SIGBUS, "stack segment", regs, error_code, NULL);
-	preempt_conditional_cli(regs);
-}
-
-asmlinkage void do_double_fault(struct pt_regs *regs, long error_code)
-{
-	static const char str[] = "double fault";
-	struct task_struct *tsk = current;
-
-	/* Return not checked because double check cannot be ignored */
-	notify_die(DIE_TRAP, str, regs, error_code, 8, SIGSEGV);
-
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 8;
-
-	/* This is always a kernel trap and never fixable (and thus must
-	   never return). */
-	for (;;)
-		die(str, regs, error_code);
-}
-
-asmlinkage void __kprobes
-do_general_protection(struct pt_regs *regs, long error_code)
-{
-	struct task_struct *tsk;
-
-	conditional_sti(regs);
-
-	tsk = current;
-	if (!user_mode(regs))
-		goto gp_in_kernel;
-
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 13;
-
-	if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
-			printk_ratelimit()) {
-		printk(KERN_INFO
-			"%s[%d] general protection ip:%lx sp:%lx error:%lx",
-			tsk->comm, tsk->pid,
-			regs->ip, regs->sp, error_code);
-		print_vma_addr(" in ", regs->ip);
-		printk("\n");
-	}
-
-	force_sig(SIGSEGV, tsk);
-	return;
-
-gp_in_kernel:
-	if (fixup_exception(regs))
-		return;
-
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 13;
-	if (notify_die(DIE_GPF, "general protection fault", regs,
-				error_code, 13, SIGSEGV) == NOTIFY_STOP)
-		return;
-	die("general protection fault", regs, error_code);
-}
-
-static notrace __kprobes void
-mem_parity_error(unsigned char reason, struct pt_regs *regs)
-{
-	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x.\n",
-		reason);
-	printk(KERN_EMERG "You have some hardware problem, likely on the PCI bus.\n");
-
-#if defined(CONFIG_EDAC)
-	if (edac_handler_set()) {
-		edac_atomic_assert_error();
-		return;
-	}
-#endif
-
-	if (panic_on_unrecovered_nmi)
-		panic("NMI: Not continuing");
-
-	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
-
-	/* Clear and disable the memory parity error line. */
-	reason = (reason & 0xf) | 4;
-	outb(reason, 0x61);
-}
-
-static notrace __kprobes void
-io_check_error(unsigned char reason, struct pt_regs *regs)
-{
-	printk("NMI: IOCK error (debug interrupt?)\n");
-	show_registers(regs);
-
-	/* Re-enable the IOCK line, wait for a few seconds */
-	reason = (reason & 0xf) | 8;
-	outb(reason, 0x61);
-	mdelay(2000);
-	reason &= ~8;
-	outb(reason, 0x61);
-}
-
-static notrace __kprobes void
-unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
-{
-	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
-			NOTIFY_STOP)
-		return;
-	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x.\n",
-		reason);
-	printk(KERN_EMERG "Do you have a strange power saving mode enabled?\n");
-
-	if (panic_on_unrecovered_nmi)
-		panic("NMI: Not continuing");
-
-	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
-}
-
-/* Runs on IST stack. This code must keep interrupts off all the time.
-   Nested NMIs are prevented by the CPU. */
-asmlinkage notrace __kprobes void default_do_nmi(struct pt_regs *regs)
-{
-	unsigned char reason = 0;
-	int cpu;
-
-	cpu = smp_processor_id();
-
-	/* Only the BSP gets external NMIs from the system. */
-	if (!cpu)
-		reason = get_nmi_reason();
-
-	if (!(reason & 0xc0)) {
-		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
-								== NOTIFY_STOP)
-			return;
-		/*
-		 * Ok, so this is none of the documented NMI sources,
-		 * so it must be the NMI watchdog.
-		 */
-		if (nmi_watchdog_tick(regs, reason))
-			return;
-		if (!do_nmi_callback(regs, cpu))
-			unknown_nmi_error(reason, regs);
-
-		return;
-	}
-	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT) == NOTIFY_STOP)
-		return;
-
-	/* AK: following checks seem to be broken on modern chipsets. FIXME */
-	if (reason & 0x80)
-		mem_parity_error(reason, regs);
-	if (reason & 0x40)
-		io_check_error(reason, regs);
-}
-
-asmlinkage notrace __kprobes void
-do_nmi(struct pt_regs *regs, long error_code)
-{
-	nmi_enter();
-
-	add_pda(__nmi_count, 1);
-
-	if (!ignore_nmis)
-		default_do_nmi(regs);
-
-	nmi_exit();
-}
-
-void stop_nmi(void)
-{
-	acpi_nmi_disable();
-	ignore_nmis++;
-}
-
-void restart_nmi(void)
-{
-	ignore_nmis--;
-	acpi_nmi_enable();
-}
-
-/* runs on IST stack. */
-asmlinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
-{
-	trace_hardirqs_fixup();
-
-	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
-			== NOTIFY_STOP)
-		return;
-
-	preempt_conditional_sti(regs);
-	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
-	preempt_conditional_cli(regs);
-}
-
-/* Help handler running on IST stack to switch back to user stack
-   for scheduling or signal handling. The actual stack switch is done in
-   entry.S */
-asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
-{
-	struct pt_regs *regs = eregs;
-	/* Did already sync */
-	if (eregs == (struct pt_regs *)eregs->sp)
-		;
-	/* Exception from user space */
-	else if (user_mode(eregs))
-		regs = task_pt_regs(current);
-	/* Exception from kernel and interrupts are enabled. Move to
-	   kernel process stack. */
-	else if (eregs->flags & X86_EFLAGS_IF)
-		regs = (struct pt_regs *)(eregs->sp -= sizeof(struct pt_regs));
-	if (eregs != regs)
-		*regs = *eregs;
-	return regs;
-}
-
-/* runs on IST stack. */
-asmlinkage void __kprobes do_debug(struct pt_regs *regs,
-				   unsigned long error_code)
-{
-	struct task_struct *tsk = current;
-	unsigned long condition;
-	siginfo_t info;
-
-	trace_hardirqs_fixup();
-
-	get_debugreg(condition, 6);
-
-	/*
-	 * The processor cleared BTF, so don't mark that we need it set.
-	 */
-	clear_tsk_thread_flag(tsk, TIF_DEBUGCTLMSR);
-	tsk->thread.debugctlmsr = 0;
-
-	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
-						SIGTRAP) == NOTIFY_STOP)
-		return;
-
-	preempt_conditional_sti(regs);
-
-	/* Mask out spurious debug traps due to lazy DR7 setting */
-	if (condition & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) {
-		if (!tsk->thread.debugreg7)
-			goto clear_dr7;
-	}
-
-	tsk->thread.debugreg6 = condition;
-
-	/*
-	 * Single-stepping through TF: make sure we ignore any events in
-	 * kernel space (but re-enable TF when returning to user mode).
-	 */
-	if (condition & DR_STEP) {
-		if (!user_mode(regs))
-			goto clear_TF_reenable;
-	}
-
-	/* Ok, finally something we can handle */
-	tsk->thread.trap_no = 1;
-	tsk->thread.error_code = error_code;
-	info.si_signo = SIGTRAP;
-	info.si_errno = 0;
-	info.si_code = get_si_code(condition);
-	info.si_addr = user_mode(regs) ? (void __user *)regs->ip : NULL;
-	force_sig_info(SIGTRAP, &info, tsk);
-
-clear_dr7:
-	set_debugreg(0, 7);
-	preempt_conditional_cli(regs);
-	return;
-
-clear_TF_reenable:
-	set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
-	regs->flags &= ~X86_EFLAGS_TF;
-	preempt_conditional_cli(regs);
-	return;
-}
-
-static int kernel_math_error(struct pt_regs *regs, const char *str, int trapnr)
-{
-	if (fixup_exception(regs))
-		return 1;
-
-	notify_die(DIE_GPF, str, regs, 0, trapnr, SIGFPE);
-	/* Illegal floating point operation in the kernel */
-	current->thread.trap_no = trapnr;
-	die(str, regs, 0);
-	return 0;
-}
-
-/*
- * Note that we play around with the 'TS' bit in an attempt to get
- * the correct behaviour even in the presence of the asynchronous
- * IRQ13 behaviour
- */
-asmlinkage void do_coprocessor_error(struct pt_regs *regs)
-{
-	void __user *ip = (void __user *)(regs->ip);
-	struct task_struct *task;
-	siginfo_t info;
-	unsigned short cwd, swd;
-
-	conditional_sti(regs);
-	if (!user_mode(regs) &&
-	    kernel_math_error(regs, "kernel x87 math error", 16))
-		return;
-
-	/*
-	 * Save the info for the exception handler and clear the error.
-	 */
-	task = current;
-	save_init_fpu(task);
-	task->thread.trap_no = 16;
-	task->thread.error_code = 0;
-	info.si_signo = SIGFPE;
-	info.si_errno = 0;
-	info.si_code = __SI_FAULT;
-	info.si_addr = ip;
-	/*
-	 * (~cwd & swd) will mask out exceptions that are not set to unmasked
-	 * status.  0x3f is the exception bits in these regs, 0x200 is the
-	 * C1 reg you need in case of a stack fault, 0x040 is the stack
-	 * fault bit.  We should only be taking one exception at a time,
-	 * so if this combination doesn't produce any single exception,
-	 * then we have a bad program that isn't synchronizing its FPU usage
-	 * and it will suffer the consequences since we won't be able to
-	 * fully reproduce the context of the exception
-	 */
-	cwd = get_fpu_cwd(task);
-	swd = get_fpu_swd(task);
-	switch (swd & ~cwd & 0x3f) {
-	case 0x000: /* No unmasked exception */
-	default: /* Multiple exceptions */
-		break;
-	case 0x001: /* Invalid Op */
-		/*
-		 * swd & 0x240 == 0x040: Stack Underflow
-		 * swd & 0x240 == 0x240: Stack Overflow
-		 * User must clear the SF bit (0x40) if set
-		 */
-		info.si_code = FPE_FLTINV;
-		break;
-	case 0x002: /* Denormalize */
-	case 0x010: /* Underflow */
-		info.si_code = FPE_FLTUND;
-		break;
-	case 0x004: /* Zero Divide */
-		info.si_code = FPE_FLTDIV;
-		break;
-	case 0x008: /* Overflow */
-		info.si_code = FPE_FLTOVF;
-		break;
-	case 0x020: /* Precision */
-		info.si_code = FPE_FLTRES;
-		break;
-	}
-	force_sig_info(SIGFPE, &info, task);
-}
-
-asmlinkage void bad_intr(void)
-{
-	printk("bad interrupt");
-}
-
-asmlinkage void do_simd_coprocessor_error(struct pt_regs *regs)
-{
-	void __user *ip = (void __user *)(regs->ip);
-	struct task_struct *task;
-	siginfo_t info;
-	unsigned short mxcsr;
-
-	conditional_sti(regs);
-	if (!user_mode(regs) &&
-			kernel_math_error(regs, "kernel simd math error", 19))
-		return;
-
-	/*
-	 * Save the info for the exception handler and clear the error.
-	 */
-	task = current;
-	save_init_fpu(task);
-	task->thread.trap_no = 19;
-	task->thread.error_code = 0;
-	info.si_signo = SIGFPE;
-	info.si_errno = 0;
-	info.si_code = __SI_FAULT;
-	info.si_addr = ip;
-	/*
-	 * The SIMD FPU exceptions are handled a little differently, as there
-	 * is only a single status/control register.  Thus, to determine which
-	 * unmasked exception was caught we must mask the exception mask bits
-	 * at 0x1f80, and then use these to mask the exception bits at 0x3f.
-	 */
-	mxcsr = get_fpu_mxcsr(task);
-	switch (~((mxcsr & 0x1f80) >> 7) & (mxcsr & 0x3f)) {
-	case 0x000:
-	default:
-		break;
-	case 0x001: /* Invalid Op */
-		info.si_code = FPE_FLTINV;
-		break;
-	case 0x002: /* Denormalize */
-	case 0x010: /* Underflow */
-		info.si_code = FPE_FLTUND;
-		break;
-	case 0x004: /* Zero Divide */
-		info.si_code = FPE_FLTDIV;
-		break;
-	case 0x008: /* Overflow */
-		info.si_code = FPE_FLTOVF;
-		break;
-	case 0x020: /* Precision */
-		info.si_code = FPE_FLTRES;
-		break;
-	}
-	force_sig_info(SIGFPE, &info, task);
-}
-
-asmlinkage void do_spurious_interrupt_bug(struct pt_regs *regs)
-{
-}
-
-asmlinkage void __attribute__((weak)) smp_thermal_interrupt(void)
-{
-}
-
-asmlinkage void __attribute__((weak)) mce_threshold_interrupt(void)
-{
-}
-
-/*
- * 'math_state_restore()' saves the current math information in the
- * old math state array, and gets the new ones from the current task
- *
- * Careful.. There are problems with IBM-designed IRQ13 behaviour.
- * Don't touch unless you *really* know how it works.
- */
-asmlinkage void math_state_restore(void)
-{
-	struct task_struct *me = current;
-
-	if (!used_math()) {
-		local_irq_enable();
-		/*
-		 * does a slab alloc which can sleep
-		 */
-		if (init_fpu(me)) {
-			/*
-			 * ran out of memory!
-			 */
-			do_group_exit(SIGKILL);
-			return;
-		}
-		local_irq_disable();
-	}
-
-	clts();				/* Allow maths ops (or we recurse) */
-	/*
-	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
-	 */
-	if (unlikely(restore_fpu_checking(me))) {
-		stts();
-		force_sig(SIGSEGV, me);
-		return;
-	}
-	task_thread_info(me)->status |= TS_USEDFPU;
-	me->fpu_counter++;
-}
-EXPORT_SYMBOL_GPL(math_state_restore);
-
-void __init trap_init(void)
-{
-	set_intr_gate(0, &divide_error);
-	set_intr_gate_ist(1, &debug, DEBUG_STACK);
-	set_intr_gate_ist(2, &nmi, NMI_STACK);
-	/* int3 can be called from all */
-	set_system_gate_ist(3, &int3, DEBUG_STACK);
-	/* int4 can be called from all */
-	set_system_gate(4, &overflow);
-	set_intr_gate(5, &bounds);
-	set_intr_gate(6, &invalid_op);
-	set_intr_gate(7, &device_not_available);
-	set_intr_gate_ist(8, &double_fault, DOUBLEFAULT_STACK);
-	set_intr_gate(9, &coprocessor_segment_overrun);
-	set_intr_gate(10, &invalid_TSS);
-	set_intr_gate(11, &segment_not_present);
-	set_intr_gate_ist(12, &stack_segment, STACKFAULT_STACK);
-	set_intr_gate(13, &general_protection);
-	set_intr_gate(14, &page_fault);
-	set_intr_gate(15, &spurious_interrupt_bug);
-	set_intr_gate(16, &coprocessor_error);
-	set_intr_gate(17, &alignment_check);
-#ifdef CONFIG_X86_MCE
-	set_intr_gate_ist(18, &machine_check, MCE_STACK);
-#endif
-	set_intr_gate(19, &simd_coprocessor_error);
-
-#ifdef CONFIG_IA32_EMULATION
-	set_system_gate(IA32_SYSCALL_VECTOR, ia32_syscall);
-#endif
-	/*
-	 * Should be a barrier for any external CPU state:
-	 */
-	cpu_init();
-}
-
-static int __init oops_setup(char *s)
-{
-	if (!s)
-		return -EINVAL;
-	if (!strcmp(s, "panic"))
-		panic_on_oops = 1;
-	return 0;
-}
-early_param("oops", oops_setup);
-
-static int __init kstack_setup(char *s)
-{
-	if (!s)
-		return -EINVAL;
-	kstack_depth_to_print = simple_strtoul(s, NULL, 0);
-	return 0;
-}
-early_param("kstack", kstack_setup);
-
-static int __init code_bytes_setup(char *s)
-{
-	code_bytes = simple_strtoul(s, NULL, 0);
-	if (code_bytes > 8192)
-		code_bytes = 8192;
-
-	return 1;
-}
-__setup("code_bytes=", code_bytes_setup);
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 201e81a..46e0544 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -172,8 +172,8 @@ SECTIONS
   .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
 	*(.x86_cpu_dev.init)
   }
-  SECURITY_INIT
   __x86_cpu_dev_end = .;
+  SECURITY_INIT
 
   . = ALIGN(8);
   .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 520cca0..6513d41 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -47,16 +47,26 @@ static __init int mps_oem_check(struct mp_config_table *mpc, char *oem,
 /* Hook from generic ACPI tables.c */
 static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	unsigned long oem_addr;
+	unsigned long oem_addr = 0;
+	int check_dsdt;
+	int ret = 0;
+
+	/* check dsdt at first to avoid clear fix_map for oem_addr */
+	check_dsdt = es7000_check_dsdt();
+
 	if (!find_unisys_acpi_oem_table(&oem_addr)) {
-		if (es7000_check_dsdt())
-			return parse_unisys_oem((char *)oem_addr);
+		if (check_dsdt)
+			ret = parse_unisys_oem((char *)oem_addr);
 		else {
 			setup_unisys();
-			return 1;
+			ret = 1;
 		}
+		/*
+		 * we need to unmap it
+		 */
+		unmap_unisys_acpi_oem_table(oem_addr);
 	}
-	return 0;
+	return ret;
 }
 #else
 static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index dfb932d..59f89b4 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -13,12 +13,8 @@ obj-$(CONFIG_MMIOTRACE)		+= mmiotrace.o
 mmiotrace-y			:= pf_in.o mmio-mod.o
 obj-$(CONFIG_MMIOTRACE_TEST)	+= testmmiotrace.o
 
-ifeq ($(CONFIG_X86_32),y)
-obj-$(CONFIG_NUMA)		+= discontig_32.o
-else
-obj-$(CONFIG_NUMA)		+= numa_64.o
+obj-$(CONFIG_NUMA)		+= numa_$(BITS).o
 obj-$(CONFIG_K8_NUMA)		+= k8topology_64.o
-endif
 obj-$(CONFIG_ACPI_NUMA)		+= srat_$(BITS).o
 
 obj-$(CONFIG_MEMTEST)		+= memtest.o
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 8f92cac..3f2b896 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -592,11 +592,6 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	unsigned long flags;
 #endif
 
-	/*
-	 * We can fault from pretty much anywhere, with unknown IRQ state.
-	 */
-	trace_hardirqs_fixup();
-
 	tsk = current;
 	mm = tsk->mm;
 	prefetchw(&mm->mmap_sem);
@@ -914,15 +909,15 @@ LIST_HEAD(pgd_list);
 
 void vmalloc_sync_all(void)
 {
-#ifdef CONFIG_X86_32
-	unsigned long start = VMALLOC_START & PGDIR_MASK;
 	unsigned long address;
 
+#ifdef CONFIG_X86_32
 	if (SHARED_KERNEL_PMD)
 		return;
 
-	BUILD_BUG_ON(TASK_SIZE & ~PGDIR_MASK);
-	for (address = start; address >= TASK_SIZE; address += PGDIR_SIZE) {
+	for (address = VMALLOC_START & PMD_MASK;
+	     address >= TASK_SIZE && address < FIXADDR_TOP;
+	     address += PMD_SIZE) {
 		unsigned long flags;
 		struct page *page;
 
@@ -935,10 +930,8 @@ void vmalloc_sync_all(void)
 		spin_unlock_irqrestore(&pgd_lock, flags);
 	}
 #else /* CONFIG_X86_64 */
-	unsigned long start = VMALLOC_START & PGDIR_MASK;
-	unsigned long address;
-
-	for (address = start; address <= VMALLOC_END; address += PGDIR_SIZE) {
+	for (address = VMALLOC_START & PGDIR_MASK; address <= VMALLOC_END;
+	     address += PGDIR_SIZE) {
 		const pgd_t *pgd_ref = pgd_offset_k(address);
 		unsigned long flags;
 		struct page *page;
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 007bb06..4ba373c 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -82,7 +82,7 @@ static noinline int gup_pte_range(pmd_t pmd, unsigned long addr,
 		pte_t pte = gup_get_pte(ptep);
 		struct page *page;
 
-		if ((pte_val(pte) & (mask | _PAGE_SPECIAL)) != mask) {
+		if ((pte_flags(pte) & (mask | _PAGE_SPECIAL)) != mask) {
 			pte_unmap(ptep);
 			return 0;
 		}
@@ -116,10 +116,10 @@ static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
 	mask = _PAGE_PRESENT|_PAGE_USER;
 	if (write)
 		mask |= _PAGE_RW;
-	if ((pte_val(pte) & mask) != mask)
+	if ((pte_flags(pte) & mask) != mask)
 		return 0;
 	/* hugepages are never "special" */
-	VM_BUG_ON(pte_val(pte) & _PAGE_SPECIAL);
+	VM_BUG_ON(pte_flags(pte) & _PAGE_SPECIAL);
 	VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 
 	refs = 0;
@@ -173,10 +173,10 @@ static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
 	mask = _PAGE_PRESENT|_PAGE_USER;
 	if (write)
 		mask |= _PAGE_RW;
-	if ((pte_val(pte) & mask) != mask)
+	if ((pte_flags(pte) & mask) != mask)
 		return 0;
 	/* hugepages are never "special" */
-	VM_BUG_ON(pte_val(pte) & _PAGE_SPECIAL);
+	VM_BUG_ON(pte_flags(pte) & _PAGE_SPECIAL);
 	VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 
 	refs = 0;
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index c3789bb..c67d78d 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -557,7 +557,7 @@ void zap_low_mappings(void)
 
 int nx_enabled;
 
-pteval_t __supported_pte_mask __read_mostly = ~(_PAGE_NX | _PAGE_GLOBAL);
+pteval_t __supported_pte_mask __read_mostly = ~(_PAGE_NX | _PAGE_GLOBAL | _PAGE_IOMAP);
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
 #ifdef CONFIG_X86_PAE
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 83e13f2..8bd797b 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -88,7 +88,7 @@ early_param("gbpages", parse_direct_gbpages_on);
 
 int after_bootmem;
 
-unsigned long __supported_pte_mask __read_mostly = ~0UL;
+pteval_t __supported_pte_mask __read_mostly = ~_PAGE_IOMAP;
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
 static int do_not_nx __cpuinitdata;
@@ -195,9 +195,6 @@ set_pte_vaddr_pud(pud_t *pud_page, unsigned long vaddr, pte_t new_pte)
 	}
 
 	pte = pte_offset_kernel(pmd, vaddr);
-	if (!pte_none(*pte) && pte_val(new_pte) &&
-	    pte_val(*pte) != (pte_val(new_pte) & __supported_pte_mask))
-		pte_ERROR(*pte);
 	set_pte(pte, new_pte);
 
 	/*
@@ -312,7 +309,7 @@ static __ref void *alloc_low_page(unsigned long *phys)
 	if (pfn >= table_top)
 		panic("alloc_low_page: ran out of memory");
 
-	adr = early_ioremap(pfn * PAGE_SIZE, PAGE_SIZE);
+	adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
 	memset(adr, 0, PAGE_SIZE);
 	*phys  = pfn * PAGE_SIZE;
 	return adr;
@@ -748,7 +745,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		old_start = mr[i].start;
 		memmove(&mr[i], &mr[i+1],
 			 (nr_range - 1 - i) * sizeof (struct map_range));
-		mr[i].start = old_start;
+		mr[i--].start = old_start;
 		nr_range--;
 	}
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 6ab3196..ddb3751 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -24,18 +24,47 @@
 
 #ifdef CONFIG_X86_64
 
+static inline int phys_addr_valid(unsigned long addr)
+{
+	return addr < (1UL << boot_cpu_data.x86_phys_bits);
+}
+
 unsigned long __phys_addr(unsigned long x)
 {
-	if (x >= __START_KERNEL_map)
-		return x - __START_KERNEL_map + phys_base;
-	return x - PAGE_OFFSET;
+	if (x >= __START_KERNEL_map) {
+		x -= __START_KERNEL_map;
+		VIRTUAL_BUG_ON(x >= KERNEL_IMAGE_SIZE);
+		x += phys_base;
+	} else {
+		VIRTUAL_BUG_ON(x < PAGE_OFFSET);
+		x -= PAGE_OFFSET;
+		VIRTUAL_BUG_ON(system_state == SYSTEM_BOOTING ? x > MAXMEM :
+					!phys_addr_valid(x));
+	}
+	return x;
 }
 EXPORT_SYMBOL(__phys_addr);
 
-static inline int phys_addr_valid(unsigned long addr)
+bool __virt_addr_valid(unsigned long x)
 {
-	return addr < (1UL << boot_cpu_data.x86_phys_bits);
+	if (x >= __START_KERNEL_map) {
+		x -= __START_KERNEL_map;
+		if (x >= KERNEL_IMAGE_SIZE)
+			return false;
+		x += phys_base;
+	} else {
+		if (x < PAGE_OFFSET)
+			return false;
+		x -= PAGE_OFFSET;
+		if (system_state == SYSTEM_BOOTING ?
+				x > MAXMEM : !phys_addr_valid(x)) {
+			return false;
+		}
+	}
+
+	return pfn_valid(x >> PAGE_SHIFT);
 }
+EXPORT_SYMBOL(__virt_addr_valid);
 
 #else
 
@@ -44,6 +73,28 @@ static inline int phys_addr_valid(unsigned long addr)
 	return 1;
 }
 
+#ifdef CONFIG_DEBUG_VIRTUAL
+unsigned long __phys_addr(unsigned long x)
+{
+	/* VMALLOC_* aren't constants; not available at the boot time */
+	VIRTUAL_BUG_ON(x < PAGE_OFFSET);
+	VIRTUAL_BUG_ON(system_state != SYSTEM_BOOTING &&
+		is_vmalloc_addr((void *) x));
+	return x - PAGE_OFFSET;
+}
+EXPORT_SYMBOL(__phys_addr);
+#endif
+
+bool __virt_addr_valid(unsigned long x)
+{
+	if (x < PAGE_OFFSET)
+		return false;
+	if (system_state != SYSTEM_BOOTING && is_vmalloc_addr((void *) x))
+		return false;
+	return pfn_valid((x - PAGE_OFFSET) >> PAGE_SHIFT);
+}
+EXPORT_SYMBOL(__virt_addr_valid);
+
 #endif
 
 int page_is_ram(unsigned long pagenr)
@@ -223,16 +274,16 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	switch (prot_val) {
 	case _PAGE_CACHE_UC:
 	default:
-		prot = PAGE_KERNEL_NOCACHE;
+		prot = PAGE_KERNEL_IO_NOCACHE;
 		break;
 	case _PAGE_CACHE_UC_MINUS:
-		prot = PAGE_KERNEL_UC_MINUS;
+		prot = PAGE_KERNEL_IO_UC_MINUS;
 		break;
 	case _PAGE_CACHE_WC:
-		prot = PAGE_KERNEL_WC;
+		prot = PAGE_KERNEL_IO_WC;
 		break;
 	case _PAGE_CACHE_WB:
-		prot = PAGE_KERNEL;
+		prot = PAGE_KERNEL_IO;
 		break;
 	}
 
@@ -549,12 +600,12 @@ static void __init __early_set_fixmap(enum fixed_addresses idx,
 }
 
 static inline void __init early_set_fixmap(enum fixed_addresses idx,
-					unsigned long phys)
+					   unsigned long phys, pgprot_t prot)
 {
 	if (after_paging_init)
-		set_fixmap(idx, phys);
+		__set_fixmap(idx, phys, prot);
 	else
-		__early_set_fixmap(idx, phys, PAGE_KERNEL);
+		__early_set_fixmap(idx, phys, prot);
 }
 
 static inline void __init early_clear_fixmap(enum fixed_addresses idx)
@@ -565,16 +616,22 @@ static inline void __init early_clear_fixmap(enum fixed_addresses idx)
 		__early_set_fixmap(idx, 0, __pgprot(0));
 }
 
-
-static int __initdata early_ioremap_nested;
-
+static void *prev_map[FIX_BTMAPS_SLOTS] __initdata;
+static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
 static int __init check_early_ioremap_leak(void)
 {
-	if (!early_ioremap_nested)
+	int count = 0;
+	int i;
+
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
+		if (prev_map[i])
+			count++;
+
+	if (!count)
 		return 0;
 	WARN(1, KERN_WARNING
 	       "Debug warning: early ioremap leak of %d areas detected.\n",
-		early_ioremap_nested);
+		count);
 	printk(KERN_WARNING
 		"please boot with early_ioremap_debug and report the dmesg.\n");
 
@@ -582,18 +639,33 @@ static int __init check_early_ioremap_leak(void)
 }
 late_initcall(check_early_ioremap_leak);
 
-void __init *early_ioremap(unsigned long phys_addr, unsigned long size)
+static void __init *__early_ioremap(unsigned long phys_addr, unsigned long size, pgprot_t prot)
 {
 	unsigned long offset, last_addr;
-	unsigned int nrpages, nesting;
+	unsigned int nrpages;
 	enum fixed_addresses idx0, idx;
+	int i, slot;
 
 	WARN_ON(system_state != SYSTEM_BOOTING);
 
-	nesting = early_ioremap_nested;
+	slot = -1;
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		if (!prev_map[i]) {
+			slot = i;
+			break;
+		}
+	}
+
+	if (slot < 0) {
+		printk(KERN_INFO "early_iomap(%08lx, %08lx) not found slot\n",
+			 phys_addr, size);
+		WARN_ON(1);
+		return NULL;
+	}
+
 	if (early_ioremap_debug) {
 		printk(KERN_INFO "early_ioremap(%08lx, %08lx) [%d] => ",
-		       phys_addr, size, nesting);
+		       phys_addr, size, slot);
 		dump_stack();
 	}
 
@@ -604,11 +676,7 @@ void __init *early_ioremap(unsigned long phys_addr, unsigned long size)
 		return NULL;
 	}
 
-	if (nesting >= FIX_BTMAPS_NESTING) {
-		WARN_ON(1);
-		return NULL;
-	}
-	early_ioremap_nested++;
+	prev_size[slot] = size;
 	/*
 	 * Mappings have to be page-aligned
 	 */
@@ -628,10 +696,10 @@ void __init *early_ioremap(unsigned long phys_addr, unsigned long size)
 	/*
 	 * Ok, go for it..
 	 */
-	idx0 = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*nesting;
+	idx0 = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
 	idx = idx0;
 	while (nrpages > 0) {
-		early_set_fixmap(idx, phys_addr);
+		early_set_fixmap(idx, phys_addr, prot);
 		phys_addr += PAGE_SIZE;
 		--idx;
 		--nrpages;
@@ -639,7 +707,20 @@ void __init *early_ioremap(unsigned long phys_addr, unsigned long size)
 	if (early_ioremap_debug)
 		printk(KERN_CONT "%08lx + %08lx\n", offset, fix_to_virt(idx0));
 
-	return (void *) (offset + fix_to_virt(idx0));
+	prev_map[slot] = (void *) (offset + fix_to_virt(idx0));
+	return prev_map[slot];
+}
+
+/* Remap an IO device */
+void __init *early_ioremap(unsigned long phys_addr, unsigned long size)
+{
+	return __early_ioremap(phys_addr, size, PAGE_KERNEL_IO);
+}
+
+/* Remap memory */
+void __init *early_memremap(unsigned long phys_addr, unsigned long size)
+{
+	return __early_ioremap(phys_addr, size, PAGE_KERNEL);
 }
 
 void __init early_iounmap(void *addr, unsigned long size)
@@ -648,15 +729,33 @@ void __init early_iounmap(void *addr, unsigned long size)
 	unsigned long offset;
 	unsigned int nrpages;
 	enum fixed_addresses idx;
-	int nesting;
+	int i, slot;
+
+	slot = -1;
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		if (prev_map[i] == addr) {
+			slot = i;
+			break;
+		}
+	}
 
-	nesting = --early_ioremap_nested;
-	if (WARN_ON(nesting < 0))
+	if (slot < 0) {
+		printk(KERN_INFO "early_iounmap(%p, %08lx) not found slot\n",
+			 addr, size);
+		WARN_ON(1);
 		return;
+	}
+
+	if (prev_size[slot] != size) {
+		printk(KERN_INFO "early_iounmap(%p, %08lx) [%d] size not consistent %08lx\n",
+			 addr, size, slot, prev_size[slot]);
+		WARN_ON(1);
+		return;
+	}
 
 	if (early_ioremap_debug) {
 		printk(KERN_INFO "early_iounmap(%p, %08lx) [%d]\n", addr,
-		       size, nesting);
+		       size, slot);
 		dump_stack();
 	}
 
@@ -668,12 +767,13 @@ void __init early_iounmap(void *addr, unsigned long size)
 	offset = virt_addr & ~PAGE_MASK;
 	nrpages = PAGE_ALIGN(offset + size - 1) >> PAGE_SHIFT;
 
-	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*nesting;
+	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
 	while (nrpages > 0) {
 		early_clear_fixmap(idx);
 		--idx;
 		--nrpages;
 	}
+	prev_map[slot] = 0;
 }
 
 void __this_fixmap_does_not_exist(void)
diff --git a/arch/x86/mm/discontig_32.c b/arch/x86/mm/numa_32.c
similarity index 100%
rename from arch/x86/mm/discontig_32.c
rename to arch/x86/mm/numa_32.c
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 3815e42..d3e6846 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -27,4 +27,12 @@ config XEN_MAX_DOMAIN_MEMORY
 config XEN_SAVE_RESTORE
        bool
        depends on PM
-       default y
\ No newline at end of file
+       default y
+
+config XEN_DEBUG_FS
+	bool "Enable Xen debug and tuning parameters in debugfs"
+	depends on XEN && DEBUG_FS
+	default n
+	help
+	  Enable statistics output and various tuning options in debugfs.
+	  Enabling this option may incur a significant performance overhead.
\ No newline at end of file
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 59c1e53..3139479 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -1,4 +1,12 @@
-obj-y		:= enlighten.o setup.o multicalls.o mmu.o \
+ifdef CONFIG_FTRACE
+# Do not profile debug and lowlevel utilities
+CFLAGS_REMOVE_spinlock.o = -pg
+CFLAGS_REMOVE_time.o = -pg
+CFLAGS_REMOVE_irq.o = -pg
+endif
+
+obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 			time.o xen-asm_$(BITS).o grant-table.o suspend.o
 
-obj-$(CONFIG_SMP)	+= smp.o
+obj-$(CONFIG_SMP)		+= smp.o spinlock.o
+obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
\ No newline at end of file
diff --git a/arch/x86/xen/debugfs.c b/arch/x86/xen/debugfs.c
new file mode 100644
index 0000000..b53225d
--- /dev/null
+++ b/arch/x86/xen/debugfs.c
@@ -0,0 +1,123 @@
+#include <linux/init.h>
+#include <linux/debugfs.h>
+#include <linux/module.h>
+
+#include "debugfs.h"
+
+static struct dentry *d_xen_debug;
+
+struct dentry * __init xen_init_debugfs(void)
+{
+	if (!d_xen_debug) {
+		d_xen_debug = debugfs_create_dir("xen", NULL);
+
+		if (!d_xen_debug)
+			pr_warning("Could not create 'xen' debugfs directory\n");
+	}
+
+	return d_xen_debug;
+}
+
+struct array_data
+{
+	void *array;
+	unsigned elements;
+};
+
+static int u32_array_open(struct inode *inode, struct file *file)
+{
+	file->private_data = NULL;
+	return nonseekable_open(inode, file);
+}
+
+static size_t format_array(char *buf, size_t bufsize, const char *fmt,
+			   u32 *array, unsigned array_size)
+{
+	size_t ret = 0;
+	unsigned i;
+
+	for(i = 0; i < array_size; i++) {
+		size_t len;
+
+		len = snprintf(buf, bufsize, fmt, array[i]);
+		len++;	/* ' ' or '\n' */
+		ret += len;
+
+		if (buf) {
+			buf += len;
+			bufsize -= len;
+			buf[-1] = (i == array_size-1) ? '\n' : ' ';
+		}
+	}
+
+	ret++;		/* \0 */
+	if (buf)
+		*buf = '\0';
+
+	return ret;
+}
+
+static char *format_array_alloc(const char *fmt, u32 *array, unsigned array_size)
+{
+	size_t len = format_array(NULL, 0, fmt, array, array_size);
+	char *ret;
+
+	ret = kmalloc(len, GFP_KERNEL);
+	if (ret == NULL)
+		return NULL;
+
+	format_array(ret, len, fmt, array, array_size);
+	return ret;
+}
+
+static ssize_t u32_array_read(struct file *file, char __user *buf, size_t len,
+			      loff_t *ppos)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct array_data *data = inode->i_private;
+	size_t size;
+
+	if (*ppos == 0) {
+		if (file->private_data) {
+			kfree(file->private_data);
+			file->private_data = NULL;
+		}
+
+		file->private_data = format_array_alloc("%u", data->array, data->elements);
+	}
+
+	size = 0;
+	if (file->private_data)
+		size = strlen(file->private_data);
+
+	return simple_read_from_buffer(buf, len, ppos, file->private_data, size);
+}
+
+static int xen_array_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+
+	return 0;
+}
+
+static struct file_operations u32_array_fops = {
+	.owner	= THIS_MODULE,
+	.open	= u32_array_open,
+	.release= xen_array_release,
+	.read	= u32_array_read,
+};
+
+struct dentry *xen_debugfs_create_u32_array(const char *name, mode_t mode,
+					    struct dentry *parent,
+					    u32 *array, unsigned elements)
+{
+	struct array_data *data = kmalloc(sizeof(*data), GFP_KERNEL);
+
+	if (data == NULL)
+		return NULL;
+
+	data->array = array;
+	data->elements = elements;
+
+	return debugfs_create_file(name, mode, parent, data, &u32_array_fops);
+}
diff --git a/arch/x86/xen/debugfs.h b/arch/x86/xen/debugfs.h
new file mode 100644
index 0000000..e281320
--- /dev/null
+++ b/arch/x86/xen/debugfs.h
@@ -0,0 +1,10 @@
+#ifndef _XEN_DEBUGFS_H
+#define _XEN_DEBUGFS_H
+
+struct dentry * __init xen_init_debugfs(void);
+
+struct dentry *xen_debugfs_create_u32_array(const char *name, mode_t mode,
+					    struct dentry *parent,
+					    u32 *array, unsigned elements);
+
+#endif /* _XEN_DEBUGFS_H */
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index a27d562..708b8ea 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -30,7 +30,6 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/physdev.h>
 #include <xen/interface/vcpu.h>
-#include <xen/interface/sched.h>
 #include <xen/features.h>
 #include <xen/page.h>
 #include <xen/hvc-console.h>
@@ -58,6 +57,9 @@ EXPORT_SYMBOL_GPL(hypercall_page);
 DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
 DEFINE_PER_CPU(struct vcpu_info, xen_vcpu_info);
 
+enum xen_domain_type xen_domain_type = XEN_NATIVE;
+EXPORT_SYMBOL_GPL(xen_domain_type);
+
 /*
  * Identity map, in addition to plain kernel map.  This needs to be
  * large enough to allocate page table pages to allocate the rest.
@@ -227,103 +229,68 @@ static unsigned long xen_get_debugreg(int reg)
 	return HYPERVISOR_get_debugreg(reg);
 }
 
-static unsigned long xen_save_fl(void)
+static void xen_leave_lazy(void)
 {
-	struct vcpu_info *vcpu;
-	unsigned long flags;
-
-	vcpu = x86_read_percpu(xen_vcpu);
-
-	/* flag has opposite sense of mask */
-	flags = !vcpu->evtchn_upcall_mask;
-
-	/* convert to IF type flag
-	   -0 -> 0x00000000
-	   -1 -> 0xffffffff
-	*/
-	return (-flags) & X86_EFLAGS_IF;
+	paravirt_leave_lazy(paravirt_get_lazy_mode());
+	xen_mc_flush();
 }
 
-static void xen_restore_fl(unsigned long flags)
+static unsigned long xen_store_tr(void)
 {
-	struct vcpu_info *vcpu;
-
-	/* convert from IF type flag */
-	flags = !(flags & X86_EFLAGS_IF);
-
-	/* There's a one instruction preempt window here.  We need to
-	   make sure we're don't switch CPUs between getting the vcpu
-	   pointer and updating the mask. */
-	preempt_disable();
-	vcpu = x86_read_percpu(xen_vcpu);
-	vcpu->evtchn_upcall_mask = flags;
-	preempt_enable_no_resched();
-
-	/* Doesn't matter if we get preempted here, because any
-	   pending event will get dealt with anyway. */
-
-	if (flags == 0) {
-		preempt_check_resched();
-		barrier(); /* unmask then check (avoid races) */
-		if (unlikely(vcpu->evtchn_upcall_pending))
-			force_evtchn_callback();
-	}
+	return 0;
 }
 
-static void xen_irq_disable(void)
+/*
+ * Set the page permissions for a particular virtual address.  If the
+ * address is a vmalloc mapping (or other non-linear mapping), then
+ * find the linear mapping of the page and also set its protections to
+ * match.
+ */
+static void set_aliased_prot(void *v, pgprot_t prot)
 {
-	/* There's a one instruction preempt window here.  We need to
-	   make sure we're don't switch CPUs between getting the vcpu
-	   pointer and updating the mask. */
-	preempt_disable();
-	x86_read_percpu(xen_vcpu)->evtchn_upcall_mask = 1;
-	preempt_enable_no_resched();
-}
+	int level;
+	pte_t *ptep;
+	pte_t pte;
+	unsigned long pfn;
+	struct page *page;
 
-static void xen_irq_enable(void)
-{
-	struct vcpu_info *vcpu;
+	ptep = lookup_address((unsigned long)v, &level);
+	BUG_ON(ptep == NULL);
 
-	/* We don't need to worry about being preempted here, since
-	   either a) interrupts are disabled, so no preemption, or b)
-	   the caller is confused and is trying to re-enable interrupts
-	   on an indeterminate processor. */
+	pfn = pte_pfn(*ptep);
+	page = pfn_to_page(pfn);
 
-	vcpu = x86_read_percpu(xen_vcpu);
-	vcpu->evtchn_upcall_mask = 0;
+	pte = pfn_pte(pfn, prot);
 
-	/* Doesn't matter if we get preempted here, because any
-	   pending event will get dealt with anyway. */
+	if (HYPERVISOR_update_va_mapping((unsigned long)v, pte, 0))
+		BUG();
 
-	barrier(); /* unmask then check (avoid races) */
-	if (unlikely(vcpu->evtchn_upcall_pending))
-		force_evtchn_callback();
-}
+	if (!PageHighMem(page)) {
+		void *av = __va(PFN_PHYS(pfn));
 
-static void xen_safe_halt(void)
-{
-	/* Blocking includes an implicit local_irq_enable(). */
-	if (HYPERVISOR_sched_op(SCHEDOP_block, NULL) != 0)
-		BUG();
+		if (av != v)
+			if (HYPERVISOR_update_va_mapping((unsigned long)av, pte, 0))
+				BUG();
+	} else
+		kmap_flush_unused();
 }
 
-static void xen_halt(void)
+static void xen_alloc_ldt(struct desc_struct *ldt, unsigned entries)
 {
-	if (irqs_disabled())
-		HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);
-	else
-		xen_safe_halt();
-}
+	const unsigned entries_per_page = PAGE_SIZE / LDT_ENTRY_SIZE;
+	int i;
 
-static void xen_leave_lazy(void)
-{
-	paravirt_leave_lazy(paravirt_get_lazy_mode());
-	xen_mc_flush();
+	for(i = 0; i < entries; i += entries_per_page)
+		set_aliased_prot(ldt + i, PAGE_KERNEL_RO);
 }
 
-static unsigned long xen_store_tr(void)
+static void xen_free_ldt(struct desc_struct *ldt, unsigned entries)
 {
-	return 0;
+	const unsigned entries_per_page = PAGE_SIZE / LDT_ENTRY_SIZE;
+	int i;
+
+	for(i = 0; i < entries; i += entries_per_page)
+		set_aliased_prot(ldt + i, PAGE_KERNEL);
 }
 
 static void xen_set_ldt(const void *addr, unsigned entries)
@@ -426,8 +393,7 @@ static void xen_load_gs_index(unsigned int idx)
 static void xen_write_ldt_entry(struct desc_struct *dt, int entrynum,
 				const void *ptr)
 {
-	unsigned long lp = (unsigned long)&dt[entrynum];
-	xmaddr_t mach_lp = virt_to_machine(lp);
+	xmaddr_t mach_lp = arbitrary_virt_to_machine(&dt[entrynum]);
 	u64 entry = *(u64 *)ptr;
 
 	preempt_disable();
@@ -560,7 +526,7 @@ static void xen_write_gdt_entry(struct desc_struct *dt, int entry,
 }
 
 static void xen_load_sp0(struct tss_struct *tss,
-			  struct thread_struct *thread)
+			 struct thread_struct *thread)
 {
 	struct multicall_space mcs = xen_mc_entry(0);
 	MULTI_stack_switch(mcs.mc, __KERNEL_DS, thread->sp0);
@@ -835,6 +801,19 @@ static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
 			ret = -EFAULT;
 		break;
 #endif
+
+	case MSR_STAR:
+	case MSR_CSTAR:
+	case MSR_LSTAR:
+	case MSR_SYSCALL_MASK:
+	case MSR_IA32_SYSENTER_CS:
+	case MSR_IA32_SYSENTER_ESP:
+	case MSR_IA32_SYSENTER_EIP:
+		/* Fast syscall setup is all done in hypercalls, so
+		   these are all ignored.  Stub them out here to stop
+		   Xen console noise. */
+		break;
+
 	default:
 		ret = native_write_msr_safe(msr, low, high);
 	}
@@ -878,8 +857,8 @@ static void xen_alloc_ptpage(struct mm_struct *mm, unsigned long pfn, unsigned l
 		SetPagePinned(page);
 
 		if (!PageHighMem(page)) {
-			make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
-			if (level == PT_PTE)
+			make_lowmem_page_readonly(__va(PFN_PHYS((unsigned long)pfn)));
+			if (level == PT_PTE && USE_SPLIT_PTLOCKS)
 				pin_pagetable_pfn(MMUEXT_PIN_L1_TABLE, pfn);
 		} else
 			/* make sure there are no stray mappings of
@@ -947,7 +926,7 @@ static void xen_release_ptpage(unsigned long pfn, unsigned level)
 
 	if (PagePinned(page)) {
 		if (!PageHighMem(page)) {
-			if (level == PT_PTE)
+			if (level == PT_PTE && USE_SPLIT_PTLOCKS)
 				pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, pfn);
 			make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
 		}
@@ -1252,6 +1231,9 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
 	.load_gs_index = xen_load_gs_index,
 #endif
 
+	.alloc_ldt = xen_alloc_ldt,
+	.free_ldt = xen_free_ldt,
+
 	.store_gdt = native_store_gdt,
 	.store_idt = native_store_idt,
 	.store_tr = xen_store_tr,
@@ -1273,36 +1255,6 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
 	},
 };
 
-static void __init __xen_init_IRQ(void)
-{
-#ifdef CONFIG_X86_64
-	int i;
-
-	/* Create identity vector->irq map */
-	for(i = 0; i < NR_VECTORS; i++) {
-		int cpu;
-
-		for_each_possible_cpu(cpu)
-			per_cpu(vector_irq, cpu)[i] = i;
-	}
-#endif	/* CONFIG_X86_64 */
-
-	xen_init_IRQ();
-}
-
-static const struct pv_irq_ops xen_irq_ops __initdata = {
-	.init_IRQ = __xen_init_IRQ,
-	.save_fl = xen_save_fl,
-	.restore_fl = xen_restore_fl,
-	.irq_disable = xen_irq_disable,
-	.irq_enable = xen_irq_enable,
-	.safe_halt = xen_safe_halt,
-	.halt = xen_halt,
-#ifdef CONFIG_X86_64
-	.adjust_exception_frame = xen_adjust_exception_frame,
-#endif
-};
-
 static const struct pv_apic_ops xen_apic_ops __initdata = {
 #ifdef CONFIG_X86_LOCAL_APIC
 	.setup_boot_clock = paravirt_nop,
@@ -1694,6 +1646,8 @@ asmlinkage void __init xen_start_kernel(void)
 	if (!xen_start_info)
 		return;
 
+	xen_domain_type = XEN_PV_DOMAIN;
+
 	BUG_ON(memcmp(xen_start_info->magic, "xen-3", 5) != 0);
 
 	xen_setup_features();
@@ -1703,10 +1657,11 @@ asmlinkage void __init xen_start_kernel(void)
 	pv_init_ops = xen_init_ops;
 	pv_time_ops = xen_time_ops;
 	pv_cpu_ops = xen_cpu_ops;
-	pv_irq_ops = xen_irq_ops;
 	pv_apic_ops = xen_apic_ops;
 	pv_mmu_ops = xen_mmu_ops;
 
+	xen_init_irq_ops();
+
 #ifdef CONFIG_X86_LOCAL_APIC
 	/*
 	 * set up the basic apic ops.
@@ -1737,7 +1692,7 @@ asmlinkage void __init xen_start_kernel(void)
 
 	/* Prevent unwanted bits from being set in PTEs. */
 	__supported_pte_mask &= ~_PAGE_GLOBAL;
-	if (!is_initial_xendomain())
+	if (!xen_initial_domain())
 		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
 
 	/* Don't do the full vcpu_info placement stuff until we have a
@@ -1772,7 +1727,7 @@ asmlinkage void __init xen_start_kernel(void)
 	boot_params.hdr.ramdisk_size = xen_start_info->mod_len;
 	boot_params.hdr.cmd_line_ptr = __pa(xen_start_info->cmd_line);
 
-	if (!is_initial_xendomain()) {
+	if (!xen_initial_domain()) {
 		add_preferred_console("xenboot", 0, NULL);
 		add_preferred_console("tty", 0, NULL);
 		add_preferred_console("hvc", 0, NULL);
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
new file mode 100644
index 0000000..28b85ab
--- /dev/null
+++ b/arch/x86/xen/irq.c
@@ -0,0 +1,143 @@
+#include <linux/hardirq.h>
+
+#include <xen/interface/xen.h>
+#include <xen/interface/sched.h>
+#include <xen/interface/vcpu.h>
+
+#include <asm/xen/hypercall.h>
+#include <asm/xen/hypervisor.h>
+
+#include "xen-ops.h"
+
+/*
+ * Force a proper event-channel callback from Xen after clearing the
+ * callback mask. We do this in a very simple manner, by making a call
+ * down into Xen. The pending flag will be checked by Xen on return.
+ */
+void xen_force_evtchn_callback(void)
+{
+	(void)HYPERVISOR_xen_version(0, NULL);
+}
+
+static void __init __xen_init_IRQ(void)
+{
+#ifdef CONFIG_X86_64
+	int i;
+
+	/* Create identity vector->irq map */
+	for(i = 0; i < NR_VECTORS; i++) {
+		int cpu;
+
+		for_each_possible_cpu(cpu)
+			per_cpu(vector_irq, cpu)[i] = i;
+	}
+#endif	/* CONFIG_X86_64 */
+
+	xen_init_IRQ();
+}
+
+static unsigned long xen_save_fl(void)
+{
+	struct vcpu_info *vcpu;
+	unsigned long flags;
+
+	vcpu = x86_read_percpu(xen_vcpu);
+
+	/* flag has opposite sense of mask */
+	flags = !vcpu->evtchn_upcall_mask;
+
+	/* convert to IF type flag
+	   -0 -> 0x00000000
+	   -1 -> 0xffffffff
+	*/
+	return (-flags) & X86_EFLAGS_IF;
+}
+
+static void xen_restore_fl(unsigned long flags)
+{
+	struct vcpu_info *vcpu;
+
+	/* convert from IF type flag */
+	flags = !(flags & X86_EFLAGS_IF);
+
+	/* There's a one instruction preempt window here.  We need to
+	   make sure we're don't switch CPUs between getting the vcpu
+	   pointer and updating the mask. */
+	preempt_disable();
+	vcpu = x86_read_percpu(xen_vcpu);
+	vcpu->evtchn_upcall_mask = flags;
+	preempt_enable_no_resched();
+
+	/* Doesn't matter if we get preempted here, because any
+	   pending event will get dealt with anyway. */
+
+	if (flags == 0) {
+		preempt_check_resched();
+		barrier(); /* unmask then check (avoid races) */
+		if (unlikely(vcpu->evtchn_upcall_pending))
+			xen_force_evtchn_callback();
+	}
+}
+
+static void xen_irq_disable(void)
+{
+	/* There's a one instruction preempt window here.  We need to
+	   make sure we're don't switch CPUs between getting the vcpu
+	   pointer and updating the mask. */
+	preempt_disable();
+	x86_read_percpu(xen_vcpu)->evtchn_upcall_mask = 1;
+	preempt_enable_no_resched();
+}
+
+static void xen_irq_enable(void)
+{
+	struct vcpu_info *vcpu;
+
+	/* We don't need to worry about being preempted here, since
+	   either a) interrupts are disabled, so no preemption, or b)
+	   the caller is confused and is trying to re-enable interrupts
+	   on an indeterminate processor. */
+
+	vcpu = x86_read_percpu(xen_vcpu);
+	vcpu->evtchn_upcall_mask = 0;
+
+	/* Doesn't matter if we get preempted here, because any
+	   pending event will get dealt with anyway. */
+
+	barrier(); /* unmask then check (avoid races) */
+	if (unlikely(vcpu->evtchn_upcall_pending))
+		xen_force_evtchn_callback();
+}
+
+static void xen_safe_halt(void)
+{
+	/* Blocking includes an implicit local_irq_enable(). */
+	if (HYPERVISOR_sched_op(SCHEDOP_block, NULL) != 0)
+		BUG();
+}
+
+static void xen_halt(void)
+{
+	if (irqs_disabled())
+		HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);
+	else
+		xen_safe_halt();
+}
+
+static const struct pv_irq_ops xen_irq_ops __initdata = {
+	.init_IRQ = __xen_init_IRQ,
+	.save_fl = xen_save_fl,
+	.restore_fl = xen_restore_fl,
+	.irq_disable = xen_irq_disable,
+	.irq_enable = xen_irq_enable,
+	.safe_halt = xen_safe_halt,
+	.halt = xen_halt,
+#ifdef CONFIG_X86_64
+	.adjust_exception_frame = xen_adjust_exception_frame,
+#endif
+};
+
+void __init xen_init_irq_ops()
+{
+	pv_irq_ops = xen_irq_ops;
+}
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index aa37469..64e5868 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -40,6 +40,7 @@
  */
 #include <linux/sched.h>
 #include <linux/highmem.h>
+#include <linux/debugfs.h>
 #include <linux/bug.h>
 
 #include <asm/pgtable.h>
@@ -57,6 +58,61 @@
 
 #include "multicalls.h"
 #include "mmu.h"
+#include "debugfs.h"
+
+#define MMU_UPDATE_HISTO	30
+
+#ifdef CONFIG_XEN_DEBUG_FS
+
+static struct {
+	u32 pgd_update;
+	u32 pgd_update_pinned;
+	u32 pgd_update_batched;
+
+	u32 pud_update;
+	u32 pud_update_pinned;
+	u32 pud_update_batched;
+
+	u32 pmd_update;
+	u32 pmd_update_pinned;
+	u32 pmd_update_batched;
+
+	u32 pte_update;
+	u32 pte_update_pinned;
+	u32 pte_update_batched;
+
+	u32 mmu_update;
+	u32 mmu_update_extended;
+	u32 mmu_update_histo[MMU_UPDATE_HISTO];
+
+	u32 prot_commit;
+	u32 prot_commit_batched;
+
+	u32 set_pte_at;
+	u32 set_pte_at_batched;
+	u32 set_pte_at_pinned;
+	u32 set_pte_at_current;
+	u32 set_pte_at_kernel;
+} mmu_stats;
+
+static u8 zero_stats;
+
+static inline void check_zero(void)
+{
+	if (unlikely(zero_stats)) {
+		memset(&mmu_stats, 0, sizeof(mmu_stats));
+		zero_stats = 0;
+	}
+}
+
+#define ADD_STATS(elem, val)			\
+	do { check_zero(); mmu_stats.elem += (val); } while(0)
+
+#else  /* !CONFIG_XEN_DEBUG_FS */
+
+#define ADD_STATS(elem, val)	do { (void)(val); } while(0)
+
+#endif /* CONFIG_XEN_DEBUG_FS */
 
 /*
  * Just beyond the highest usermode address.  STACK_TOP_MAX has a
@@ -229,25 +285,35 @@ void make_lowmem_page_readwrite(void *vaddr)
 }
 
 
-static bool page_pinned(void *ptr)
+static bool xen_page_pinned(void *ptr)
 {
 	struct page *page = virt_to_page(ptr);
 
 	return PagePinned(page);
 }
 
-static void extend_mmu_update(const struct mmu_update *update)
+static void xen_extend_mmu_update(const struct mmu_update *update)
 {
 	struct multicall_space mcs;
 	struct mmu_update *u;
 
 	mcs = xen_mc_extend_args(__HYPERVISOR_mmu_update, sizeof(*u));
 
-	if (mcs.mc != NULL)
+	if (mcs.mc != NULL) {
+		ADD_STATS(mmu_update_extended, 1);
+		ADD_STATS(mmu_update_histo[mcs.mc->args[1]], -1);
+
 		mcs.mc->args[1]++;
-	else {
+
+		if (mcs.mc->args[1] < MMU_UPDATE_HISTO)
+			ADD_STATS(mmu_update_histo[mcs.mc->args[1]], 1);
+		else
+			ADD_STATS(mmu_update_histo[0], 1);
+	} else {
+		ADD_STATS(mmu_update, 1);
 		mcs = __xen_mc_entry(sizeof(*u));
 		MULTI_mmu_update(mcs.mc, mcs.args, 1, NULL, DOMID_SELF);
+		ADD_STATS(mmu_update_histo[1], 1);
 	}
 
 	u = mcs.args;
@@ -265,7 +331,9 @@ void xen_set_pmd_hyper(pmd_t *ptr, pmd_t val)
 	/* ptr may be ioremapped for 64-bit pagetable setup */
 	u.ptr = arbitrary_virt_to_machine(ptr).maddr;
 	u.val = pmd_val_ma(val);
-	extend_mmu_update(&u);
+	xen_extend_mmu_update(&u);
+
+	ADD_STATS(pmd_update_batched, paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU);
 
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 
@@ -274,13 +342,17 @@ void xen_set_pmd_hyper(pmd_t *ptr, pmd_t val)
 
 void xen_set_pmd(pmd_t *ptr, pmd_t val)
 {
+	ADD_STATS(pmd_update, 1);
+
 	/* If page is not pinned, we can just update the entry
 	   directly */
-	if (!page_pinned(ptr)) {
+	if (!xen_page_pinned(ptr)) {
 		*ptr = val;
 		return;
 	}
 
+	ADD_STATS(pmd_update_pinned, 1);
+
 	xen_set_pmd_hyper(ptr, val);
 }
 
@@ -300,12 +372,18 @@ void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 	if (mm == &init_mm)
 		preempt_disable();
 
+	ADD_STATS(set_pte_at, 1);
+//	ADD_STATS(set_pte_at_pinned, xen_page_pinned(ptep));
+	ADD_STATS(set_pte_at_current, mm == current->mm);
+	ADD_STATS(set_pte_at_kernel, mm == &init_mm);
+
 	if (mm == current->mm || mm == &init_mm) {
 		if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
 			struct multicall_space mcs;
 			mcs = xen_mc_entry(0);
 
 			MULTI_update_va_mapping(mcs.mc, addr, pteval, 0);
+			ADD_STATS(set_pte_at_batched, 1);
 			xen_mc_issue(PARAVIRT_LAZY_MMU);
 			goto out;
 		} else
@@ -334,7 +412,10 @@ void xen_ptep_modify_prot_commit(struct mm_struct *mm, unsigned long addr,
 
 	u.ptr = virt_to_machine(ptep).maddr | MMU_PT_UPDATE_PRESERVE_AD;
 	u.val = pte_val_ma(pte);
-	extend_mmu_update(&u);
+	xen_extend_mmu_update(&u);
+
+	ADD_STATS(prot_commit, 1);
+	ADD_STATS(prot_commit_batched, paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU);
 
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 }
@@ -400,7 +481,9 @@ void xen_set_pud_hyper(pud_t *ptr, pud_t val)
 	/* ptr may be ioremapped for 64-bit pagetable setup */
 	u.ptr = arbitrary_virt_to_machine(ptr).maddr;
 	u.val = pud_val_ma(val);
-	extend_mmu_update(&u);
+	xen_extend_mmu_update(&u);
+
+	ADD_STATS(pud_update_batched, paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU);
 
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 
@@ -409,18 +492,26 @@ void xen_set_pud_hyper(pud_t *ptr, pud_t val)
 
 void xen_set_pud(pud_t *ptr, pud_t val)
 {
+	ADD_STATS(pud_update, 1);
+
 	/* If page is not pinned, we can just update the entry
 	   directly */
-	if (!page_pinned(ptr)) {
+	if (!xen_page_pinned(ptr)) {
 		*ptr = val;
 		return;
 	}
 
+	ADD_STATS(pud_update_pinned, 1);
+
 	xen_set_pud_hyper(ptr, val);
 }
 
 void xen_set_pte(pte_t *ptep, pte_t pte)
 {
+	ADD_STATS(pte_update, 1);
+//	ADD_STATS(pte_update_pinned, xen_page_pinned(ptep));
+	ADD_STATS(pte_update_batched, paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU);
+
 #ifdef CONFIG_X86_PAE
 	ptep->pte_high = pte.pte_high;
 	smp_wmb();
@@ -490,7 +581,7 @@ static void __xen_set_pgd_hyper(pgd_t *ptr, pgd_t val)
 
 	u.ptr = virt_to_machine(ptr).maddr;
 	u.val = pgd_val_ma(val);
-	extend_mmu_update(&u);
+	xen_extend_mmu_update(&u);
 }
 
 /*
@@ -517,17 +608,22 @@ void xen_set_pgd(pgd_t *ptr, pgd_t val)
 {
 	pgd_t *user_ptr = xen_get_user_pgd(ptr);
 
+	ADD_STATS(pgd_update, 1);
+
 	/* If page is not pinned, we can just update the entry
 	   directly */
-	if (!page_pinned(ptr)) {
+	if (!xen_page_pinned(ptr)) {
 		*ptr = val;
 		if (user_ptr) {
-			WARN_ON(page_pinned(user_ptr));
+			WARN_ON(xen_page_pinned(user_ptr));
 			*user_ptr = val;
 		}
 		return;
 	}
 
+	ADD_STATS(pgd_update_pinned, 1);
+	ADD_STATS(pgd_update_batched, paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU);
+
 	/* If it's pinned, then we can at least batch the kernel and
 	   user updates together. */
 	xen_mc_batch();
@@ -555,8 +651,8 @@ void xen_set_pgd(pgd_t *ptr, pgd_t val)
  * For 64-bit, we must skip the Xen hole in the middle of the address
  * space, just after the big x86-64 virtual hole.
  */
-static int pgd_walk(pgd_t *pgd, int (*func)(struct page *, enum pt_level),
-		    unsigned long limit)
+static int xen_pgd_walk(pgd_t *pgd, int (*func)(struct page *, enum pt_level),
+			unsigned long limit)
 {
 	int flush = 0;
 	unsigned hole_low, hole_high;
@@ -590,8 +686,6 @@ static int pgd_walk(pgd_t *pgd, int (*func)(struct page *, enum pt_level),
 	pmdidx_limit = 0;
 #endif
 
-	flush |= (*func)(virt_to_page(pgd), PT_PGD);
-
 	for (pgdidx = 0; pgdidx <= pgdidx_limit; pgdidx++) {
 		pud_t *pud;
 
@@ -637,16 +731,22 @@ static int pgd_walk(pgd_t *pgd, int (*func)(struct page *, enum pt_level),
 			}
 		}
 	}
+
 out:
+	/* Do the top level last, so that the callbacks can use it as
+	   a cue to do final things like tlb flushes. */
+	flush |= (*func)(virt_to_page(pgd), PT_PGD);
 
 	return flush;
 }
 
-static spinlock_t *lock_pte(struct page *page)
+/* If we're using split pte locks, then take the page's lock and
+   return a pointer to it.  Otherwise return NULL. */
+static spinlock_t *xen_pte_lock(struct page *page)
 {
 	spinlock_t *ptl = NULL;
 
-#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+#if USE_SPLIT_PTLOCKS
 	ptl = __pte_lockptr(page);
 	spin_lock(ptl);
 #endif
@@ -654,7 +754,7 @@ static spinlock_t *lock_pte(struct page *page)
 	return ptl;
 }
 
-static void do_unlock(void *v)
+static void xen_pte_unlock(void *v)
 {
 	spinlock_t *ptl = v;
 	spin_unlock(ptl);
@@ -672,7 +772,7 @@ static void xen_do_pin(unsigned level, unsigned long pfn)
 	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
 }
 
-static int pin_page(struct page *page, enum pt_level level)
+static int xen_pin_page(struct page *page, enum pt_level level)
 {
 	unsigned pgfl = TestSetPagePinned(page);
 	int flush;
@@ -691,21 +791,40 @@ static int pin_page(struct page *page, enum pt_level level)
 
 		flush = 0;
 
+		/*
+		 * We need to hold the pagetable lock between the time
+		 * we make the pagetable RO and when we actually pin
+		 * it.  If we don't, then other users may come in and
+		 * attempt to update the pagetable by writing it,
+		 * which will fail because the memory is RO but not
+		 * pinned, so Xen won't do the trap'n'emulate.
+		 *
+		 * If we're using split pte locks, we can't hold the
+		 * entire pagetable's worth of locks during the
+		 * traverse, because we may wrap the preempt count (8
+		 * bits).  The solution is to mark RO and pin each PTE
+		 * page while holding the lock.  This means the number
+		 * of locks we end up holding is never more than a
+		 * batch size (~32 entries, at present).
+		 *
+		 * If we're not using split pte locks, we needn't pin
+		 * the PTE pages independently, because we're
+		 * protected by the overall pagetable lock.
+		 */
 		ptl = NULL;
 		if (level == PT_PTE)
-			ptl = lock_pte(page);
+			ptl = xen_pte_lock(page);
 
 		MULTI_update_va_mapping(mcs.mc, (unsigned long)pt,
 					pfn_pte(pfn, PAGE_KERNEL_RO),
 					level == PT_PGD ? UVMF_TLB_FLUSH : 0);
 
-		if (level == PT_PTE)
+		if (ptl) {
 			xen_do_pin(MMUEXT_PIN_L1_TABLE, pfn);
 
-		if (ptl) {
 			/* Queue a deferred unlock for when this batch
 			   is completed. */
-			xen_mc_callback(do_unlock, ptl);
+			xen_mc_callback(xen_pte_unlock, ptl);
 		}
 	}
 
@@ -719,7 +838,7 @@ void xen_pgd_pin(pgd_t *pgd)
 {
 	xen_mc_batch();
 
-	if (pgd_walk(pgd, pin_page, USER_LIMIT)) {
+	if (xen_pgd_walk(pgd, xen_pin_page, USER_LIMIT)) {
 		/* re-enable interrupts for kmap_flush_unused */
 		xen_mc_issue(0);
 		kmap_flush_unused();
@@ -733,14 +852,14 @@ void xen_pgd_pin(pgd_t *pgd)
 		xen_do_pin(MMUEXT_PIN_L4_TABLE, PFN_DOWN(__pa(pgd)));
 
 		if (user_pgd) {
-			pin_page(virt_to_page(user_pgd), PT_PGD);
+			xen_pin_page(virt_to_page(user_pgd), PT_PGD);
 			xen_do_pin(MMUEXT_PIN_L4_TABLE, PFN_DOWN(__pa(user_pgd)));
 		}
 	}
 #else /* CONFIG_X86_32 */
 #ifdef CONFIG_X86_PAE
 	/* Need to make sure unshared kernel PMD is pinnable */
-	pin_page(virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])), PT_PMD);
+	xen_pin_page(virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])), PT_PMD);
 #endif
 	xen_do_pin(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(pgd)));
 #endif /* CONFIG_X86_64 */
@@ -775,7 +894,7 @@ void xen_mm_pin_all(void)
  * that's before we have page structures to store the bits.  So do all
  * the book-keeping now.
  */
-static __init int mark_pinned(struct page *page, enum pt_level level)
+static __init int xen_mark_pinned(struct page *page, enum pt_level level)
 {
 	SetPagePinned(page);
 	return 0;
@@ -783,10 +902,10 @@ static __init int mark_pinned(struct page *page, enum pt_level level)
 
 void __init xen_mark_init_mm_pinned(void)
 {
-	pgd_walk(init_mm.pgd, mark_pinned, FIXADDR_TOP);
+	xen_pgd_walk(init_mm.pgd, xen_mark_pinned, FIXADDR_TOP);
 }
 
-static int unpin_page(struct page *page, enum pt_level level)
+static int xen_unpin_page(struct page *page, enum pt_level level)
 {
 	unsigned pgfl = TestClearPagePinned(page);
 
@@ -796,10 +915,18 @@ static int unpin_page(struct page *page, enum pt_level level)
 		spinlock_t *ptl = NULL;
 		struct multicall_space mcs;
 
+		/*
+		 * Do the converse to pin_page.  If we're using split
+		 * pte locks, we must be holding the lock for while
+		 * the pte page is unpinned but still RO to prevent
+		 * concurrent updates from seeing it in this
+		 * partially-pinned state.
+		 */
 		if (level == PT_PTE) {
-			ptl = lock_pte(page);
+			ptl = xen_pte_lock(page);
 
-			xen_do_pin(MMUEXT_UNPIN_TABLE, pfn);
+			if (ptl)
+				xen_do_pin(MMUEXT_UNPIN_TABLE, pfn);
 		}
 
 		mcs = __xen_mc_entry(0);
@@ -810,7 +937,7 @@ static int unpin_page(struct page *page, enum pt_level level)
 
 		if (ptl) {
 			/* unlock when batch completed */
-			xen_mc_callback(do_unlock, ptl);
+			xen_mc_callback(xen_pte_unlock, ptl);
 		}
 	}
 
@@ -830,17 +957,17 @@ static void xen_pgd_unpin(pgd_t *pgd)
 
 		if (user_pgd) {
 			xen_do_pin(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(user_pgd)));
-			unpin_page(virt_to_page(user_pgd), PT_PGD);
+			xen_unpin_page(virt_to_page(user_pgd), PT_PGD);
 		}
 	}
 #endif
 
 #ifdef CONFIG_X86_PAE
 	/* Need to make sure unshared kernel PMD is unpinned */
-	pin_page(virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])), PT_PMD);
+	xen_unpin_page(virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])), PT_PMD);
 #endif
 
-	pgd_walk(pgd, unpin_page, USER_LIMIT);
+	xen_pgd_walk(pgd, xen_unpin_page, USER_LIMIT);
 
 	xen_mc_issue(0);
 }
@@ -907,7 +1034,7 @@ static void drop_other_mm_ref(void *info)
 	}
 }
 
-static void drop_mm_ref(struct mm_struct *mm)
+static void xen_drop_mm_ref(struct mm_struct *mm)
 {
 	cpumask_t mask;
 	unsigned cpu;
@@ -937,7 +1064,7 @@ static void drop_mm_ref(struct mm_struct *mm)
 		smp_call_function_mask(mask, drop_other_mm_ref, mm, 1);
 }
 #else
-static void drop_mm_ref(struct mm_struct *mm)
+static void xen_drop_mm_ref(struct mm_struct *mm)
 {
 	if (current->active_mm == mm)
 		load_cr3(swapper_pg_dir);
@@ -961,14 +1088,77 @@ static void drop_mm_ref(struct mm_struct *mm)
 void xen_exit_mmap(struct mm_struct *mm)
 {
 	get_cpu();		/* make sure we don't move around */
-	drop_mm_ref(mm);
+	xen_drop_mm_ref(mm);
 	put_cpu();
 
 	spin_lock(&mm->page_table_lock);
 
 	/* pgd may not be pinned in the error exit path of execve */
-	if (page_pinned(mm->pgd))
+	if (xen_page_pinned(mm->pgd))
 		xen_pgd_unpin(mm->pgd);
 
 	spin_unlock(&mm->page_table_lock);
 }
+
+#ifdef CONFIG_XEN_DEBUG_FS
+
+static struct dentry *d_mmu_debug;
+
+static int __init xen_mmu_debugfs(void)
+{
+	struct dentry *d_xen = xen_init_debugfs();
+
+	if (d_xen == NULL)
+		return -ENOMEM;
+
+	d_mmu_debug = debugfs_create_dir("mmu", d_xen);
+
+	debugfs_create_u8("zero_stats", 0644, d_mmu_debug, &zero_stats);
+
+	debugfs_create_u32("pgd_update", 0444, d_mmu_debug, &mmu_stats.pgd_update);
+	debugfs_create_u32("pgd_update_pinned", 0444, d_mmu_debug,
+			   &mmu_stats.pgd_update_pinned);
+	debugfs_create_u32("pgd_update_batched", 0444, d_mmu_debug,
+			   &mmu_stats.pgd_update_pinned);
+
+	debugfs_create_u32("pud_update", 0444, d_mmu_debug, &mmu_stats.pud_update);
+	debugfs_create_u32("pud_update_pinned", 0444, d_mmu_debug,
+			   &mmu_stats.pud_update_pinned);
+	debugfs_create_u32("pud_update_batched", 0444, d_mmu_debug,
+			   &mmu_stats.pud_update_pinned);
+
+	debugfs_create_u32("pmd_update", 0444, d_mmu_debug, &mmu_stats.pmd_update);
+	debugfs_create_u32("pmd_update_pinned", 0444, d_mmu_debug,
+			   &mmu_stats.pmd_update_pinned);
+	debugfs_create_u32("pmd_update_batched", 0444, d_mmu_debug,
+			   &mmu_stats.pmd_update_pinned);
+
+	debugfs_create_u32("pte_update", 0444, d_mmu_debug, &mmu_stats.pte_update);
+//	debugfs_create_u32("pte_update_pinned", 0444, d_mmu_debug,
+//			   &mmu_stats.pte_update_pinned);
+	debugfs_create_u32("pte_update_batched", 0444, d_mmu_debug,
+			   &mmu_stats.pte_update_pinned);
+
+	debugfs_create_u32("mmu_update", 0444, d_mmu_debug, &mmu_stats.mmu_update);
+	debugfs_create_u32("mmu_update_extended", 0444, d_mmu_debug,
+			   &mmu_stats.mmu_update_extended);
+	xen_debugfs_create_u32_array("mmu_update_histo", 0444, d_mmu_debug,
+				     mmu_stats.mmu_update_histo, 20);
+
+	debugfs_create_u32("set_pte_at", 0444, d_mmu_debug, &mmu_stats.set_pte_at);
+	debugfs_create_u32("set_pte_at_batched", 0444, d_mmu_debug,
+			   &mmu_stats.set_pte_at_batched);
+	debugfs_create_u32("set_pte_at_current", 0444, d_mmu_debug,
+			   &mmu_stats.set_pte_at_current);
+	debugfs_create_u32("set_pte_at_kernel", 0444, d_mmu_debug,
+			   &mmu_stats.set_pte_at_kernel);
+
+	debugfs_create_u32("prot_commit", 0444, d_mmu_debug, &mmu_stats.prot_commit);
+	debugfs_create_u32("prot_commit_batched", 0444, d_mmu_debug,
+			   &mmu_stats.prot_commit_batched);
+
+	return 0;
+}
+fs_initcall(xen_mmu_debugfs);
+
+#endif	/* CONFIG_XEN_DEBUG_FS */
diff --git a/arch/x86/xen/multicalls.c b/arch/x86/xen/multicalls.c
index 9efd1c6..8ea8a0d 100644
--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
@@ -21,16 +21,20 @@
  */
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
+#include <linux/debugfs.h>
 
 #include <asm/xen/hypercall.h>
 
 #include "multicalls.h"
+#include "debugfs.h"
+
+#define MC_BATCH	32
 
 #define MC_DEBUG	1
 
-#define MC_BATCH	32
 #define MC_ARGS		(MC_BATCH * 16)
 
+
 struct mc_buffer {
 	struct multicall_entry entries[MC_BATCH];
 #if MC_DEBUG
@@ -47,6 +51,76 @@ struct mc_buffer {
 static DEFINE_PER_CPU(struct mc_buffer, mc_buffer);
 DEFINE_PER_CPU(unsigned long, xen_mc_irq_flags);
 
+/* flush reasons 0- slots, 1- args, 2- callbacks */
+enum flush_reasons
+{
+	FL_SLOTS,
+	FL_ARGS,
+	FL_CALLBACKS,
+
+	FL_N_REASONS
+};
+
+#ifdef CONFIG_XEN_DEBUG_FS
+#define NHYPERCALLS	40		/* not really */
+
+static struct {
+	unsigned histo[MC_BATCH+1];
+
+	unsigned issued;
+	unsigned arg_total;
+	unsigned hypercalls;
+	unsigned histo_hypercalls[NHYPERCALLS];
+
+	unsigned flush[FL_N_REASONS];
+} mc_stats;
+
+static u8 zero_stats;
+
+static inline void check_zero(void)
+{
+	if (unlikely(zero_stats)) {
+		memset(&mc_stats, 0, sizeof(mc_stats));
+		zero_stats = 0;
+	}
+}
+
+static void mc_add_stats(const struct mc_buffer *mc)
+{
+	int i;
+
+	check_zero();
+
+	mc_stats.issued++;
+	mc_stats.hypercalls += mc->mcidx;
+	mc_stats.arg_total += mc->argidx;
+
+	mc_stats.histo[mc->mcidx]++;
+	for(i = 0; i < mc->mcidx; i++) {
+		unsigned op = mc->entries[i].op;
+		if (op < NHYPERCALLS)
+			mc_stats.histo_hypercalls[op]++;
+	}
+}
+
+static void mc_stats_flush(enum flush_reasons idx)
+{
+	check_zero();
+
+	mc_stats.flush[idx]++;
+}
+
+#else  /* !CONFIG_XEN_DEBUG_FS */
+
+static inline void mc_add_stats(const struct mc_buffer *mc)
+{
+}
+
+static inline void mc_stats_flush(enum flush_reasons idx)
+{
+}
+#endif	/* CONFIG_XEN_DEBUG_FS */
+
 void xen_mc_flush(void)
 {
 	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
@@ -60,6 +134,8 @@ void xen_mc_flush(void)
 	   something in the middle */
 	local_irq_save(flags);
 
+	mc_add_stats(b);
+
 	if (b->mcidx) {
 #if MC_DEBUG
 		memcpy(b->debug, b->entries,
@@ -115,6 +191,7 @@ struct multicall_space __xen_mc_entry(size_t args)
 
 	if (b->mcidx == MC_BATCH ||
 	    (argidx + args) > MC_ARGS) {
+		mc_stats_flush(b->mcidx == MC_BATCH ? FL_SLOTS : FL_ARGS);
 		xen_mc_flush();
 		argidx = roundup(b->argidx, sizeof(u64));
 	}
@@ -158,10 +235,44 @@ void xen_mc_callback(void (*fn)(void *), void *data)
 	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
 	struct callback *cb;
 
-	if (b->cbidx == MC_BATCH)
+	if (b->cbidx == MC_BATCH) {
+		mc_stats_flush(FL_CALLBACKS);
 		xen_mc_flush();
+	}
 
 	cb = &b->callbacks[b->cbidx++];
 	cb->fn = fn;
 	cb->data = data;
 }
+
+#ifdef CONFIG_XEN_DEBUG_FS
+
+static struct dentry *d_mc_debug;
+
+static int __init xen_mc_debugfs(void)
+{
+	struct dentry *d_xen = xen_init_debugfs();
+
+	if (d_xen == NULL)
+		return -ENOMEM;
+
+	d_mc_debug = debugfs_create_dir("multicalls", d_xen);
+
+	debugfs_create_u8("zero_stats", 0644, d_mc_debug, &zero_stats);
+
+	debugfs_create_u32("batches", 0444, d_mc_debug, &mc_stats.issued);
+	debugfs_create_u32("hypercalls", 0444, d_mc_debug, &mc_stats.hypercalls);
+	debugfs_create_u32("arg_total", 0444, d_mc_debug, &mc_stats.arg_total);
+
+	xen_debugfs_create_u32_array("batch_histo", 0444, d_mc_debug,
+				     mc_stats.histo, MC_BATCH);
+	xen_debugfs_create_u32_array("hypercall_histo", 0444, d_mc_debug,
+				     mc_stats.histo_hypercalls, NHYPERCALLS);
+	xen_debugfs_create_u32_array("flush_reasons", 0444, d_mc_debug,
+				     mc_stats.flush, FL_N_REASONS);
+
+	return 0;
+}
+fs_initcall(xen_mc_debugfs);
+
+#endif	/* CONFIG_XEN_DEBUG_FS */
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index d8faf79..d77da61 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -11,11 +11,8 @@
  * useful topology information for the kernel to make use of.  As a
  * result, all CPUs are treated as if they're single-core and
  * single-threaded.
- *
- * This does not handle HOTPLUG_CPU yet.
  */
 #include <linux/sched.h>
-#include <linux/kernel_stat.h>
 #include <linux/err.h>
 #include <linux/smp.h>
 
@@ -36,8 +33,6 @@
 #include "xen-ops.h"
 #include "mmu.h"
 
-static void __cpuinit xen_init_lock_cpu(int cpu);
-
 cpumask_t xen_cpu_initialized_map;
 
 static DEFINE_PER_CPU(int, resched_irq);
@@ -64,11 +59,12 @@ static irqreturn_t xen_reschedule_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static __cpuinit void cpu_bringup_and_idle(void)
+static __cpuinit void cpu_bringup(void)
 {
 	int cpu = smp_processor_id();
 
 	cpu_init();
+	touch_softlockup_watchdog();
 	preempt_disable();
 
 	xen_enable_sysenter();
@@ -89,6 +85,11 @@ static __cpuinit void cpu_bringup_and_idle(void)
 	local_irq_enable();
 
 	wmb();			/* make sure everything is out */
+}
+
+static __cpuinit void cpu_bringup_and_idle(void)
+{
+	cpu_bringup();
 	cpu_idle();
 }
 
@@ -212,8 +213,6 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 
 		cpu_set(cpu, cpu_present_map);
 	}
-
-	//init_xenbus_allowed_cpumask();
 }
 
 static __cpuinit int
@@ -281,12 +280,6 @@ static int __cpuinit xen_cpu_up(unsigned int cpu)
 	struct task_struct *idle = idle_task(cpu);
 	int rc;
 
-#if 0
-	rc = cpu_up_check(cpu);
-	if (rc)
-		return rc;
-#endif
-
 #ifdef CONFIG_X86_64
 	/* Allocate node local memory for AP pdas */
 	WARN_ON(cpu == 0);
@@ -339,6 +332,60 @@ static void xen_smp_cpus_done(unsigned int max_cpus)
 {
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+static int xen_cpu_disable(void)
+{
+	unsigned int cpu = smp_processor_id();
+	if (cpu == 0)
+		return -EBUSY;
+
+	cpu_disable_common();
+
+	load_cr3(swapper_pg_dir);
+	return 0;
+}
+
+static void xen_cpu_die(unsigned int cpu)
+{
+	while (HYPERVISOR_vcpu_op(VCPUOP_is_up, cpu, NULL)) {
+		current->state = TASK_UNINTERRUPTIBLE;
+		schedule_timeout(HZ/10);
+	}
+	unbind_from_irqhandler(per_cpu(resched_irq, cpu), NULL);
+	unbind_from_irqhandler(per_cpu(callfunc_irq, cpu), NULL);
+	unbind_from_irqhandler(per_cpu(debug_irq, cpu), NULL);
+	unbind_from_irqhandler(per_cpu(callfuncsingle_irq, cpu), NULL);
+	xen_uninit_lock_cpu(cpu);
+	xen_teardown_timer(cpu);
+
+	if (num_online_cpus() == 1)
+		alternatives_smp_switch(0);
+}
+
+static void xen_play_dead(void)
+{
+	play_dead_common();
+	HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);
+	cpu_bringup();
+}
+
+#else /* !CONFIG_HOTPLUG_CPU */
+static int xen_cpu_disable(void)
+{
+	return -ENOSYS;
+}
+
+static void xen_cpu_die(unsigned int cpu)
+{
+	BUG();
+}
+
+static void xen_play_dead(void)
+{
+	BUG();
+}
+
+#endif
 static void stop_self(void *v)
 {
 	int cpu = smp_processor_id();
@@ -419,176 +466,16 @@ static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-struct xen_spinlock {
-	unsigned char lock;		/* 0 -> free; 1 -> locked */
-	unsigned short spinners;	/* count of waiting cpus */
-};
-
-static int xen_spin_is_locked(struct raw_spinlock *lock)
-{
-	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
-
-	return xl->lock != 0;
-}
-
-static int xen_spin_is_contended(struct raw_spinlock *lock)
-{
-	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
-
-	/* Not strictly true; this is only the count of contended
-	   lock-takers entering the slow path. */
-	return xl->spinners != 0;
-}
-
-static int xen_spin_trylock(struct raw_spinlock *lock)
-{
-	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
-	u8 old = 1;
-
-	asm("xchgb %b0,%1"
-	    : "+q" (old), "+m" (xl->lock) : : "memory");
-
-	return old == 0;
-}
-
-static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
-static DEFINE_PER_CPU(struct xen_spinlock *, lock_spinners);
-
-static inline void spinning_lock(struct xen_spinlock *xl)
-{
-	__get_cpu_var(lock_spinners) = xl;
-	wmb();			/* set lock of interest before count */
-	asm(LOCK_PREFIX " incw %0"
-	    : "+m" (xl->spinners) : : "memory");
-}
-
-static inline void unspinning_lock(struct xen_spinlock *xl)
-{
-	asm(LOCK_PREFIX " decw %0"
-	    : "+m" (xl->spinners) : : "memory");
-	wmb();			/* decrement count before clearing lock */
-	__get_cpu_var(lock_spinners) = NULL;
-}
-
-static noinline int xen_spin_lock_slow(struct raw_spinlock *lock)
-{
-	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
-	int irq = __get_cpu_var(lock_kicker_irq);
-	int ret;
-
-	/* If kicker interrupts not initialized yet, just spin */
-	if (irq == -1)
-		return 0;
-
-	/* announce we're spinning */
-	spinning_lock(xl);
-
-	/* clear pending */
-	xen_clear_irq_pending(irq);
-
-	/* check again make sure it didn't become free while
-	   we weren't looking  */
-	ret = xen_spin_trylock(lock);
-	if (ret)
-		goto out;
-
-	/* block until irq becomes pending */
-	xen_poll_irq(irq);
-	kstat_this_cpu.irqs[irq]++;
-
-out:
-	unspinning_lock(xl);
-	return ret;
-}
-
-static void xen_spin_lock(struct raw_spinlock *lock)
-{
-	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
-	int timeout;
-	u8 oldval;
-
-	do {
-		timeout = 1 << 10;
-
-		asm("1: xchgb %1,%0\n"
-		    "   testb %1,%1\n"
-		    "   jz 3f\n"
-		    "2: rep;nop\n"
-		    "   cmpb $0,%0\n"
-		    "   je 1b\n"
-		    "   dec %2\n"
-		    "   jnz 2b\n"
-		    "3:\n"
-		    : "+m" (xl->lock), "=q" (oldval), "+r" (timeout)
-		    : "1" (1)
-		    : "memory");
-
-	} while (unlikely(oldval != 0 && !xen_spin_lock_slow(lock)));
-}
-
-static noinline void xen_spin_unlock_slow(struct xen_spinlock *xl)
-{
-	int cpu;
-
-	for_each_online_cpu(cpu) {
-		/* XXX should mix up next cpu selection */
-		if (per_cpu(lock_spinners, cpu) == xl) {
-			xen_send_IPI_one(cpu, XEN_SPIN_UNLOCK_VECTOR);
-			break;
-		}
-	}
-}
-
-static void xen_spin_unlock(struct raw_spinlock *lock)
-{
-	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
-
-	smp_wmb();		/* make sure no writes get moved after unlock */
-	xl->lock = 0;		/* release lock */
-
-	/* make sure unlock happens before kick */
-	barrier();
-
-	if (unlikely(xl->spinners))
-		xen_spin_unlock_slow(xl);
-}
-
-static __cpuinit void xen_init_lock_cpu(int cpu)
-{
-	int irq;
-	const char *name;
-
-	name = kasprintf(GFP_KERNEL, "spinlock%d", cpu);
-	irq = bind_ipi_to_irqhandler(XEN_SPIN_UNLOCK_VECTOR,
-				     cpu,
-				     xen_reschedule_interrupt,
-				     IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
-				     name,
-				     NULL);
-
-	if (irq >= 0) {
-		disable_irq(irq); /* make sure it's never delivered */
-		per_cpu(lock_kicker_irq, cpu) = irq;
-	}
-
-	printk("cpu %d spinlock event irq %d\n", cpu, irq);
-}
-
-static void __init xen_init_spinlocks(void)
-{
-	pv_lock_ops.spin_is_locked = xen_spin_is_locked;
-	pv_lock_ops.spin_is_contended = xen_spin_is_contended;
-	pv_lock_ops.spin_lock = xen_spin_lock;
-	pv_lock_ops.spin_trylock = xen_spin_trylock;
-	pv_lock_ops.spin_unlock = xen_spin_unlock;
-}
-
 static const struct smp_ops xen_smp_ops __initdata = {
 	.smp_prepare_boot_cpu = xen_smp_prepare_boot_cpu,
 	.smp_prepare_cpus = xen_smp_prepare_cpus,
-	.cpu_up = xen_cpu_up,
 	.smp_cpus_done = xen_smp_cpus_done,
 
+	.cpu_up = xen_cpu_up,
+	.cpu_die = xen_cpu_die,
+	.cpu_disable = xen_cpu_disable,
+	.play_dead = xen_play_dead,
+
 	.smp_send_stop = xen_smp_send_stop,
 	.smp_send_reschedule = xen_smp_send_reschedule,
 
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
new file mode 100644
index 0000000..dd71e3a
--- /dev/null
+++ b/arch/x86/xen/spinlock.c
@@ -0,0 +1,428 @@
+/*
+ * Split spinlock implementation out into its own file, so it can be
+ * compiled in a FTRACE-compatible way.
+ */
+#include <linux/kernel_stat.h>
+#include <linux/spinlock.h>
+#include <linux/debugfs.h>
+#include <linux/log2.h>
+
+#include <asm/paravirt.h>
+
+#include <xen/interface/xen.h>
+#include <xen/events.h>
+
+#include "xen-ops.h"
+#include "debugfs.h"
+
+#ifdef CONFIG_XEN_DEBUG_FS
+static struct xen_spinlock_stats
+{
+	u64 taken;
+	u32 taken_slow;
+	u32 taken_slow_nested;
+	u32 taken_slow_pickup;
+	u32 taken_slow_spurious;
+	u32 taken_slow_irqenable;
+
+	u64 released;
+	u32 released_slow;
+	u32 released_slow_kicked;
+
+#define HISTO_BUCKETS	30
+	u32 histo_spin_total[HISTO_BUCKETS+1];
+	u32 histo_spin_spinning[HISTO_BUCKETS+1];
+	u32 histo_spin_blocked[HISTO_BUCKETS+1];
+
+	u64 time_total;
+	u64 time_spinning;
+	u64 time_blocked;
+} spinlock_stats;
+
+static u8 zero_stats;
+
+static unsigned lock_timeout = 1 << 10;
+#define TIMEOUT lock_timeout
+
+static inline void check_zero(void)
+{
+	if (unlikely(zero_stats)) {
+		memset(&spinlock_stats, 0, sizeof(spinlock_stats));
+		zero_stats = 0;
+	}
+}
+
+#define ADD_STATS(elem, val)			\
+	do { check_zero(); spinlock_stats.elem += (val); } while(0)
+
+static inline u64 spin_time_start(void)
+{
+	return xen_clocksource_read();
+}
+
+static void __spin_time_accum(u64 delta, u32 *array)
+{
+	unsigned index = ilog2(delta);
+
+	check_zero();
+
+	if (index < HISTO_BUCKETS)
+		array[index]++;
+	else
+		array[HISTO_BUCKETS]++;
+}
+
+static inline void spin_time_accum_spinning(u64 start)
+{
+	u32 delta = xen_clocksource_read() - start;
+
+	__spin_time_accum(delta, spinlock_stats.histo_spin_spinning);
+	spinlock_stats.time_spinning += delta;
+}
+
+static inline void spin_time_accum_total(u64 start)
+{
+	u32 delta = xen_clocksource_read() - start;
+
+	__spin_time_accum(delta, spinlock_stats.histo_spin_total);
+	spinlock_stats.time_total += delta;
+}
+
+static inline void spin_time_accum_blocked(u64 start)
+{
+	u32 delta = xen_clocksource_read() - start;
+
+	__spin_time_accum(delta, spinlock_stats.histo_spin_blocked);
+	spinlock_stats.time_blocked += delta;
+}
+#else  /* !CONFIG_XEN_DEBUG_FS */
+#define TIMEOUT			(1 << 10)
+#define ADD_STATS(elem, val)	do { (void)(val); } while(0)
+
+static inline u64 spin_time_start(void)
+{
+	return 0;
+}
+
+static inline void spin_time_accum_total(u64 start)
+{
+}
+static inline void spin_time_accum_spinning(u64 start)
+{
+}
+static inline void spin_time_accum_blocked(u64 start)
+{
+}
+#endif  /* CONFIG_XEN_DEBUG_FS */
+
+struct xen_spinlock {
+	unsigned char lock;		/* 0 -> free; 1 -> locked */
+	unsigned short spinners;	/* count of waiting cpus */
+};
+
+static int xen_spin_is_locked(struct raw_spinlock *lock)
+{
+	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+
+	return xl->lock != 0;
+}
+
+static int xen_spin_is_contended(struct raw_spinlock *lock)
+{
+	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+
+	/* Not strictly true; this is only the count of contended
+	   lock-takers entering the slow path. */
+	return xl->spinners != 0;
+}
+
+static int xen_spin_trylock(struct raw_spinlock *lock)
+{
+	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+	u8 old = 1;
+
+	asm("xchgb %b0,%1"
+	    : "+q" (old), "+m" (xl->lock) : : "memory");
+
+	return old == 0;
+}
+
+static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
+static DEFINE_PER_CPU(struct xen_spinlock *, lock_spinners);
+
+/*
+ * Mark a cpu as interested in a lock.  Returns the CPU's previous
+ * lock of interest, in case we got preempted by an interrupt.
+ */
+static inline struct xen_spinlock *spinning_lock(struct xen_spinlock *xl)
+{
+	struct xen_spinlock *prev;
+
+	prev = __get_cpu_var(lock_spinners);
+	__get_cpu_var(lock_spinners) = xl;
+
+	wmb();			/* set lock of interest before count */
+
+	asm(LOCK_PREFIX " incw %0"
+	    : "+m" (xl->spinners) : : "memory");
+
+	return prev;
+}
+
+/*
+ * Mark a cpu as no longer interested in a lock.  Restores previous
+ * lock of interest (NULL for none).
+ */
+static inline void unspinning_lock(struct xen_spinlock *xl, struct xen_spinlock *prev)
+{
+	asm(LOCK_PREFIX " decw %0"
+	    : "+m" (xl->spinners) : : "memory");
+	wmb();			/* decrement count before restoring lock */
+	__get_cpu_var(lock_spinners) = prev;
+}
+
+static noinline int xen_spin_lock_slow(struct raw_spinlock *lock, bool irq_enable)
+{
+	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+	struct xen_spinlock *prev;
+	int irq = __get_cpu_var(lock_kicker_irq);
+	int ret;
+	unsigned long flags;
+	u64 start;
+
+	/* If kicker interrupts not initialized yet, just spin */
+	if (irq == -1)
+		return 0;
+
+	start = spin_time_start();
+
+	/* announce we're spinning */
+	prev = spinning_lock(xl);
+
+	flags = __raw_local_save_flags();
+	if (irq_enable) {
+		ADD_STATS(taken_slow_irqenable, 1);
+		raw_local_irq_enable();
+	}
+
+	ADD_STATS(taken_slow, 1);
+	ADD_STATS(taken_slow_nested, prev != NULL);
+
+	do {
+		/* clear pending */
+		xen_clear_irq_pending(irq);
+
+		/* check again make sure it didn't become free while
+		   we weren't looking  */
+		ret = xen_spin_trylock(lock);
+		if (ret) {
+			ADD_STATS(taken_slow_pickup, 1);
+
+			/*
+			 * If we interrupted another spinlock while it
+			 * was blocking, make sure it doesn't block
+			 * without rechecking the lock.
+			 */
+			if (prev != NULL)
+				xen_set_irq_pending(irq);
+			goto out;
+		}
+
+		/*
+		 * Block until irq becomes pending.  If we're
+		 * interrupted at this point (after the trylock but
+		 * before entering the block), then the nested lock
+		 * handler guarantees that the irq will be left
+		 * pending if there's any chance the lock became free;
+		 * xen_poll_irq() returns immediately if the irq is
+		 * pending.
+		 */
+		xen_poll_irq(irq);
+		ADD_STATS(taken_slow_spurious, !xen_test_irq_pending(irq));
+	} while (!xen_test_irq_pending(irq)); /* check for spurious wakeups */
+
+	kstat_this_cpu.irqs[irq]++;
+
+out:
+	raw_local_irq_restore(flags);
+	unspinning_lock(xl, prev);
+	spin_time_accum_blocked(start);
+
+	return ret;
+}
+
+static inline void __xen_spin_lock(struct raw_spinlock *lock, bool irq_enable)
+{
+	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+	unsigned timeout;
+	u8 oldval;
+	u64 start_spin;
+
+	ADD_STATS(taken, 1);
+
+	start_spin = spin_time_start();
+
+	do {
+		u64 start_spin_fast = spin_time_start();
+
+		timeout = TIMEOUT;
+
+		asm("1: xchgb %1,%0\n"
+		    "   testb %1,%1\n"
+		    "   jz 3f\n"
+		    "2: rep;nop\n"
+		    "   cmpb $0,%0\n"
+		    "   je 1b\n"
+		    "   dec %2\n"
+		    "   jnz 2b\n"
+		    "3:\n"
+		    : "+m" (xl->lock), "=q" (oldval), "+r" (timeout)
+		    : "1" (1)
+		    : "memory");
+
+		spin_time_accum_spinning(start_spin_fast);
+
+	} while (unlikely(oldval != 0 &&
+			  (TIMEOUT == ~0 || !xen_spin_lock_slow(lock, irq_enable))));
+
+	spin_time_accum_total(start_spin);
+}
+
+static void xen_spin_lock(struct raw_spinlock *lock)
+{
+	__xen_spin_lock(lock, false);
+}
+
+static void xen_spin_lock_flags(struct raw_spinlock *lock, unsigned long flags)
+{
+	__xen_spin_lock(lock, !raw_irqs_disabled_flags(flags));
+}
+
+static noinline void xen_spin_unlock_slow(struct xen_spinlock *xl)
+{
+	int cpu;
+
+	ADD_STATS(released_slow, 1);
+
+	for_each_online_cpu(cpu) {
+		/* XXX should mix up next cpu selection */
+		if (per_cpu(lock_spinners, cpu) == xl) {
+			ADD_STATS(released_slow_kicked, 1);
+			xen_send_IPI_one(cpu, XEN_SPIN_UNLOCK_VECTOR);
+			break;
+		}
+	}
+}
+
+static void xen_spin_unlock(struct raw_spinlock *lock)
+{
+	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+
+	ADD_STATS(released, 1);
+
+	smp_wmb();		/* make sure no writes get moved after unlock */
+	xl->lock = 0;		/* release lock */
+
+	/* make sure unlock happens before kick */
+	barrier();
+
+	if (unlikely(xl->spinners))
+		xen_spin_unlock_slow(xl);
+}
+
+static irqreturn_t dummy_handler(int irq, void *dev_id)
+{
+	BUG();
+	return IRQ_HANDLED;
+}
+
+void __cpuinit xen_init_lock_cpu(int cpu)
+{
+	int irq;
+	const char *name;
+
+	name = kasprintf(GFP_KERNEL, "spinlock%d", cpu);
+	irq = bind_ipi_to_irqhandler(XEN_SPIN_UNLOCK_VECTOR,
+				     cpu,
+				     dummy_handler,
+				     IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				     name,
+				     NULL);
+
+	if (irq >= 0) {
+		disable_irq(irq); /* make sure it's never delivered */
+		per_cpu(lock_kicker_irq, cpu) = irq;
+	}
+
+	printk("cpu %d spinlock event irq %d\n", cpu, irq);
+}
+
+void xen_uninit_lock_cpu(int cpu)
+{
+	unbind_from_irqhandler(per_cpu(lock_kicker_irq, cpu), NULL);
+}
+
+void __init xen_init_spinlocks(void)
+{
+	pv_lock_ops.spin_is_locked = xen_spin_is_locked;
+	pv_lock_ops.spin_is_contended = xen_spin_is_contended;
+	pv_lock_ops.spin_lock = xen_spin_lock;
+	pv_lock_ops.spin_lock_flags = xen_spin_lock_flags;
+	pv_lock_ops.spin_trylock = xen_spin_trylock;
+	pv_lock_ops.spin_unlock = xen_spin_unlock;
+}
+
+#ifdef CONFIG_XEN_DEBUG_FS
+
+static struct dentry *d_spin_debug;
+
+static int __init xen_spinlock_debugfs(void)
+{
+	struct dentry *d_xen = xen_init_debugfs();
+
+	if (d_xen == NULL)
+		return -ENOMEM;
+
+	d_spin_debug = debugfs_create_dir("spinlocks", d_xen);
+
+	debugfs_create_u8("zero_stats", 0644, d_spin_debug, &zero_stats);
+
+	debugfs_create_u32("timeout", 0644, d_spin_debug, &lock_timeout);
+
+	debugfs_create_u64("taken", 0444, d_spin_debug, &spinlock_stats.taken);
+	debugfs_create_u32("taken_slow", 0444, d_spin_debug,
+			   &spinlock_stats.taken_slow);
+	debugfs_create_u32("taken_slow_nested", 0444, d_spin_debug,
+			   &spinlock_stats.taken_slow_nested);
+	debugfs_create_u32("taken_slow_pickup", 0444, d_spin_debug,
+			   &spinlock_stats.taken_slow_pickup);
+	debugfs_create_u32("taken_slow_spurious", 0444, d_spin_debug,
+			   &spinlock_stats.taken_slow_spurious);
+	debugfs_create_u32("taken_slow_irqenable", 0444, d_spin_debug,
+			   &spinlock_stats.taken_slow_irqenable);
+
+	debugfs_create_u64("released", 0444, d_spin_debug, &spinlock_stats.released);
+	debugfs_create_u32("released_slow", 0444, d_spin_debug,
+			   &spinlock_stats.released_slow);
+	debugfs_create_u32("released_slow_kicked", 0444, d_spin_debug,
+			   &spinlock_stats.released_slow_kicked);
+
+	debugfs_create_u64("time_spinning", 0444, d_spin_debug,
+			   &spinlock_stats.time_spinning);
+	debugfs_create_u64("time_blocked", 0444, d_spin_debug,
+			   &spinlock_stats.time_blocked);
+	debugfs_create_u64("time_total", 0444, d_spin_debug,
+			   &spinlock_stats.time_total);
+
+	xen_debugfs_create_u32_array("histo_total", 0444, d_spin_debug,
+				     spinlock_stats.histo_spin_total, HISTO_BUCKETS + 1);
+	xen_debugfs_create_u32_array("histo_spinning", 0444, d_spin_debug,
+				     spinlock_stats.histo_spin_spinning, HISTO_BUCKETS + 1);
+	xen_debugfs_create_u32_array("histo_blocked", 0444, d_spin_debug,
+				     spinlock_stats.histo_spin_blocked, HISTO_BUCKETS + 1);
+
+	return 0;
+}
+fs_initcall(xen_spinlock_debugfs);
+
+#endif	/* CONFIG_XEN_DEBUG_FS */
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 685b774..004ba86 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -30,8 +30,6 @@
 #define TIMER_SLOP	100000
 #define NS_PER_TICK	(1000000000LL / HZ)
 
-static cycle_t xen_clocksource_read(void);
-
 /* runstate info updated by Xen */
 static DEFINE_PER_CPU(struct vcpu_runstate_info, runstate);
 
@@ -213,7 +211,7 @@ unsigned long xen_tsc_khz(void)
 	return xen_khz;
 }
 
-static cycle_t xen_clocksource_read(void)
+cycle_t xen_clocksource_read(void)
 {
         struct pvclock_vcpu_time_info *src;
 	cycle_t ret;
@@ -452,6 +450,14 @@ void xen_setup_timer(int cpu)
 	setup_runstate_info(cpu);
 }
 
+void xen_teardown_timer(int cpu)
+{
+	struct clock_event_device *evt;
+	BUG_ON(cpu == 0);
+	evt = &per_cpu(xen_clock_events, cpu);
+	unbind_from_irqhandler(evt->irq, NULL);
+}
+
 void xen_setup_cpu_clockevents(void)
 {
 	BUG_ON(preemptible());
diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
index 2497a30..42786f5 100644
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -298,7 +298,7 @@ check_events:
 	push %eax
 	push %ecx
 	push %edx
-	call force_evtchn_callback
+	call xen_force_evtchn_callback
 	pop %edx
 	pop %ecx
 	pop %eax
diff --git a/arch/x86/xen/xen-asm_64.S b/arch/x86/xen/xen-asm_64.S
index 7f58304..3b9bda4 100644
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -122,7 +122,7 @@ check_events:
 	push %r9
 	push %r10
 	push %r11
-	call force_evtchn_callback
+	call xen_force_evtchn_callback
 	pop %r11
 	pop %r10
 	pop %r9
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index dd3c231..d7422dc 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -2,6 +2,7 @@
 #define XEN_OPS_H
 
 #include <linux/init.h>
+#include <linux/clocksource.h>
 #include <linux/irqreturn.h>
 #include <xen/xen-ops.h>
 
@@ -31,7 +32,10 @@ void xen_vcpu_restore(void);
 
 void __init xen_build_dynamic_phys_to_machine(void);
 
+void xen_init_irq_ops(void);
 void xen_setup_timer(int cpu);
+void xen_teardown_timer(int cpu);
+cycle_t xen_clocksource_read(void);
 void xen_setup_cpu_clockevents(void);
 unsigned long xen_tsc_khz(void);
 void __init xen_time_init(void);
@@ -50,6 +54,10 @@ void __init xen_setup_vcpu_info_placement(void);
 #ifdef CONFIG_SMP
 void xen_smp_init(void);
 
+void __init xen_init_spinlocks(void);
+__cpuinit void xen_init_lock_cpu(int cpu);
+void xen_uninit_lock_cpu(int cpu);
+
 extern cpumask_t xen_cpu_initialized_map;
 #else
 static inline void xen_smp_init(void) {}
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 3ca643c..d5e7532 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1032,7 +1032,7 @@ static struct xenbus_driver blkfront = {
 
 static int __init xlblk_init(void)
 {
-	if (!is_running_on_xen())
+	if (!xen_domain())
 		return -ENODEV;
 
 	if (register_blkdev(XENVBD_MAJOR, DEV_NAME)) {
diff --git a/drivers/char/hvc_xen.c b/drivers/char/hvc_xen.c
index 6b70aa6..538ceea 100644
--- a/drivers/char/hvc_xen.c
+++ b/drivers/char/hvc_xen.c
@@ -108,8 +108,8 @@ static int __init xen_init(void)
 {
 	struct hvc_struct *hp;
 
-	if (!is_running_on_xen() ||
-	    is_initial_xendomain() ||
+	if (!xen_pv_domain() ||
+	    xen_initial_domain() ||
 	    !xen_start_info->console.domU.evtchn)
 		return -ENODEV;
 
@@ -142,7 +142,7 @@ static void __exit xen_fini(void)
 
 static int xen_cons_init(void)
 {
-	if (!is_running_on_xen())
+	if (!xen_pv_domain())
 		return 0;
 
 	hvc_instantiate(HVC_COOKIE, 0, &hvc_ops);
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index 9ce3b3b..3ab6362 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -335,11 +335,11 @@ static struct xenbus_driver xenkbd = {
 
 static int __init xenkbd_init(void)
 {
-	if (!is_running_on_xen())
+	if (!xen_domain())
 		return -ENODEV;
 
 	/* Nothing to do if running in dom0. */
-	if (is_initial_xendomain())
+	if (xen_initial_domain())
 		return -ENODEV;
 
 	return xenbus_register_frontend(&xenkbd);
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index c749bdb..3c3dd40 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1794,10 +1794,10 @@ static struct xenbus_driver netfront = {
 
 static int __init netif_init(void)
 {
-	if (!is_running_on_xen())
+	if (!xen_domain())
 		return -ENODEV;
 
-	if (is_initial_xendomain())
+	if (xen_initial_domain())
 		return 0;
 
 	printk(KERN_INFO "Initialising Xen virtual ethernet driver.\n");
@@ -1809,7 +1809,7 @@ module_init(netif_init);
 
 static void __exit netif_exit(void)
 {
-	if (is_initial_xendomain())
+	if (xen_initial_domain())
 		return;
 
 	xenbus_unregister_driver(&netfront);
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 47ed39b..a463b3d 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -680,11 +680,11 @@ static struct xenbus_driver xenfb = {
 
 static int __init xenfb_init(void)
 {
-	if (!is_running_on_xen())
+	if (!xen_domain())
 		return -ENODEV;
 
 	/* Nothing to do if running in dom0. */
-	if (is_initial_xendomain())
+	if (xen_initial_domain())
 		return -ENODEV;
 
 	return xenbus_register_frontend(&xenfb);
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 363286c..d2a8fdf 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,4 +1,5 @@
 obj-y	+= grant-table.o features.o events.o manage.o
 obj-y	+= xenbus/
+obj-$(CONFIG_HOTPLUG_CPU)	+= cpu_hotplug.o
 obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
 obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 2e15da5..a51f3e1 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -226,9 +226,8 @@ static int increase_reservation(unsigned long nr_pages)
 	}
 
 	set_xen_guest_handle(reservation.extent_start, frame_list);
-	reservation.nr_extents   = nr_pages;
-	rc = HYPERVISOR_memory_op(
-		XENMEM_populate_physmap, &reservation);
+	reservation.nr_extents = nr_pages;
+	rc = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
 	if (rc < nr_pages) {
 		if (rc > 0) {
 			int ret;
@@ -236,7 +235,7 @@ static int increase_reservation(unsigned long nr_pages)
 			/* We hit the Xen hard limit: reprobe. */
 			reservation.nr_extents = rc;
 			ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation,
-					&reservation);
+						   &reservation);
 			BUG_ON(ret != rc);
 		}
 		if (rc >= 0)
@@ -420,7 +419,7 @@ static int __init balloon_init(void)
 	unsigned long pfn;
 	struct page *page;
 
-	if (!is_running_on_xen())
+	if (!xen_pv_domain())
 		return -ENODEV;
 
 	pr_info("xen_balloon: Initialising balloon driver.\n");
@@ -464,136 +463,13 @@ static void balloon_exit(void)
 
 module_exit(balloon_exit);
 
-static void balloon_update_driver_allowance(long delta)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&balloon_lock, flags);
-	balloon_stats.driver_pages += delta;
-	spin_unlock_irqrestore(&balloon_lock, flags);
-}
-
-static int dealloc_pte_fn(
-	pte_t *pte, struct page *pmd_page, unsigned long addr, void *data)
-{
-	unsigned long mfn = pte_mfn(*pte);
-	int ret;
-	struct xen_memory_reservation reservation = {
-		.nr_extents   = 1,
-		.extent_order = 0,
-		.domid        = DOMID_SELF
-	};
-	set_xen_guest_handle(reservation.extent_start, &mfn);
-	set_pte_at(&init_mm, addr, pte, __pte_ma(0ull));
-	set_phys_to_machine(__pa(addr) >> PAGE_SHIFT, INVALID_P2M_ENTRY);
-	ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation, &reservation);
-	BUG_ON(ret != 1);
-	return 0;
-}
-
-static struct page **alloc_empty_pages_and_pagevec(int nr_pages)
-{
-	unsigned long vaddr, flags;
-	struct page *page, **pagevec;
-	int i, ret;
-
-	pagevec = kmalloc(sizeof(page) * nr_pages, GFP_KERNEL);
-	if (pagevec == NULL)
-		return NULL;
-
-	for (i = 0; i < nr_pages; i++) {
-		page = pagevec[i] = alloc_page(GFP_KERNEL);
-		if (page == NULL)
-			goto err;
-
-		vaddr = (unsigned long)page_address(page);
-
-		scrub_page(page);
-
-		spin_lock_irqsave(&balloon_lock, flags);
-
-		if (xen_feature(XENFEAT_auto_translated_physmap)) {
-			unsigned long gmfn = page_to_pfn(page);
-			struct xen_memory_reservation reservation = {
-				.nr_extents   = 1,
-				.extent_order = 0,
-				.domid        = DOMID_SELF
-			};
-			set_xen_guest_handle(reservation.extent_start, &gmfn);
-			ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation,
-						   &reservation);
-			if (ret == 1)
-				ret = 0; /* success */
-		} else {
-			ret = apply_to_page_range(&init_mm, vaddr, PAGE_SIZE,
-						  dealloc_pte_fn, NULL);
-		}
-
-		if (ret != 0) {
-			spin_unlock_irqrestore(&balloon_lock, flags);
-			__free_page(page);
-			goto err;
-		}
-
-		totalram_pages = --balloon_stats.current_pages;
-
-		spin_unlock_irqrestore(&balloon_lock, flags);
-	}
-
- out:
-	schedule_work(&balloon_worker);
-	flush_tlb_all();
-	return pagevec;
-
- err:
-	spin_lock_irqsave(&balloon_lock, flags);
-	while (--i >= 0)
-		balloon_append(pagevec[i]);
-	spin_unlock_irqrestore(&balloon_lock, flags);
-	kfree(pagevec);
-	pagevec = NULL;
-	goto out;
-}
-
-static void free_empty_pages_and_pagevec(struct page **pagevec, int nr_pages)
-{
-	unsigned long flags;
-	int i;
-
-	if (pagevec == NULL)
-		return;
-
-	spin_lock_irqsave(&balloon_lock, flags);
-	for (i = 0; i < nr_pages; i++) {
-		BUG_ON(page_count(pagevec[i]) != 1);
-		balloon_append(pagevec[i]);
-	}
-	spin_unlock_irqrestore(&balloon_lock, flags);
-
-	kfree(pagevec);
-
-	schedule_work(&balloon_worker);
-}
-
-static void balloon_release_driver_page(struct page *page)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&balloon_lock, flags);
-	balloon_append(page);
-	balloon_stats.driver_pages--;
-	spin_unlock_irqrestore(&balloon_lock, flags);
-
-	schedule_work(&balloon_worker);
-}
-
-
-#define BALLOON_SHOW(name, format, args...)			\
-	static ssize_t show_##name(struct sys_device *dev,	\
-				   char *buf)			\
-	{							\
-		return sprintf(buf, format, ##args);		\
-	}							\
+#define BALLOON_SHOW(name, format, args...)				\
+	static ssize_t show_##name(struct sys_device *dev,		\
+				   struct sysdev_attribute *attr,	\
+				   char *buf)				\
+	{								\
+		return sprintf(buf, format, ##args);			\
+	}								\
 	static SYSDEV_ATTR(name, S_IRUGO, show_##name, NULL)
 
 BALLOON_SHOW(current_kb, "%lu\n", PAGES2KB(balloon_stats.current_pages));
@@ -604,7 +480,8 @@ BALLOON_SHOW(hard_limit_kb,
 	     (balloon_stats.hard_limit!=~0UL) ? PAGES2KB(balloon_stats.hard_limit) : 0);
 BALLOON_SHOW(driver_kb, "%lu\n", PAGES2KB(balloon_stats.driver_pages));
 
-static ssize_t show_target_kb(struct sys_device *dev, char *buf)
+static ssize_t show_target_kb(struct sys_device *dev, struct sysdev_attribute *attr,
+			      char *buf)
 {
 	return sprintf(buf, "%lu\n", PAGES2KB(balloon_stats.target_pages));
 }
@@ -614,19 +491,14 @@ static ssize_t store_target_kb(struct sys_device *dev,
 			       const char *buf,
 			       size_t count)
 {
-	char memstring[64], *endchar;
+	char *endchar;
 	unsigned long long target_bytes;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (count <= 1)
-		return -EBADMSG; /* runt */
-	if (count > sizeof(memstring))
-		return -EFBIG;   /* too long */
-	strcpy(memstring, buf);
+	target_bytes = memparse(buf, &endchar);
 
-	target_bytes = memparse(memstring, &endchar);
 	balloon_set_new_target(target_bytes >> PAGE_SHIFT);
 
 	return count;
@@ -694,20 +566,4 @@ static int register_balloon(struct sys_device *sysdev)
 	return error;
 }
 
-static void unregister_balloon(struct sys_device *sysdev)
-{
-	int i;
-
-	sysfs_remove_group(&sysdev->kobj, &balloon_info_group);
-	for (i = 0; i < ARRAY_SIZE(balloon_attrs); i++)
-		sysdev_remove_file(sysdev, balloon_attrs[i]);
-	sysdev_unregister(sysdev);
-	sysdev_class_unregister(&balloon_sysdev_class);
-}
-
-static void balloon_sysfs_exit(void)
-{
-	unregister_balloon(&balloon_sysdev);
-}
-
 MODULE_LICENSE("GPL");
diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
new file mode 100644
index 0000000..565280e
--- /dev/null
+++ b/drivers/xen/cpu_hotplug.c
@@ -0,0 +1,90 @@
+#include <linux/notifier.h>
+
+#include <xen/xenbus.h>
+
+#include <asm-x86/xen/hypervisor.h>
+#include <asm/cpu.h>
+
+static void enable_hotplug_cpu(int cpu)
+{
+	if (!cpu_present(cpu))
+		arch_register_cpu(cpu);
+
+	cpu_set(cpu, cpu_present_map);
+}
+
+static void disable_hotplug_cpu(int cpu)
+{
+	if (cpu_present(cpu))
+		arch_unregister_cpu(cpu);
+
+	cpu_clear(cpu, cpu_present_map);
+}
+
+static void vcpu_hotplug(unsigned int cpu)
+{
+	int err;
+	char dir[32], state[32];
+
+	if (!cpu_possible(cpu))
+		return;
+
+	sprintf(dir, "cpu/%u", cpu);
+	err = xenbus_scanf(XBT_NIL, dir, "availability", "%s", state);
+	if (err != 1) {
+		printk(KERN_ERR "XENBUS: Unable to read cpu state\n");
+		return;
+	}
+
+	if (strcmp(state, "online") == 0) {
+		enable_hotplug_cpu(cpu);
+	} else if (strcmp(state, "offline") == 0) {
+		(void)cpu_down(cpu);
+		disable_hotplug_cpu(cpu);
+	} else {
+		printk(KERN_ERR "XENBUS: unknown state(%s) on CPU%d\n",
+		       state, cpu);
+	}
+}
+
+static void handle_vcpu_hotplug_event(struct xenbus_watch *watch,
+					const char **vec, unsigned int len)
+{
+	unsigned int cpu;
+	char *cpustr;
+	const char *node = vec[XS_WATCH_PATH];
+
+	cpustr = strstr(node, "cpu/");
+	if (cpustr != NULL) {
+		sscanf(cpustr, "cpu/%u", &cpu);
+		vcpu_hotplug(cpu);
+	}
+}
+
+static int setup_cpu_watcher(struct notifier_block *notifier,
+			      unsigned long event, void *data)
+{
+	static struct xenbus_watch cpu_watch = {
+		.node = "cpu",
+		.callback = handle_vcpu_hotplug_event};
+
+	(void)register_xenbus_watch(&cpu_watch);
+
+	return NOTIFY_DONE;
+}
+
+static int __init setup_vcpu_hotplug_event(void)
+{
+	static struct notifier_block xsn_cpu = {
+		.notifier_call = setup_cpu_watcher };
+
+	if (!xen_pv_domain())
+		return -ENODEV;
+
+	register_xenstore_notifier(&xsn_cpu);
+
+	return 0;
+}
+
+arch_initcall(setup_vcpu_hotplug_event);
+
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 0e0c285..c3290bc 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -84,17 +84,6 @@ static int irq_bindcount[NR_IRQS];
 /* Xen will never allocate port zero for any purpose. */
 #define VALID_EVTCHN(chn)	((chn) != 0)
 
-/*
- * Force a proper event-channel callback from Xen after clearing the
- * callback mask. We do this in a very simple manner, by making a call
- * down into Xen. The pending flag will be checked by Xen on return.
- */
-void force_evtchn_callback(void)
-{
-	(void)HYPERVISOR_xen_version(0, NULL);
-}
-EXPORT_SYMBOL_GPL(force_evtchn_callback);
-
 static struct irq_chip xen_dynamic_chip;
 
 /* Constructor for packed IRQ information. */
@@ -175,6 +164,12 @@ static inline void set_evtchn(int port)
 	sync_set_bit(port, &s->evtchn_pending[0]);
 }
 
+static inline int test_evtchn(int port)
+{
+	struct shared_info *s = HYPERVISOR_shared_info;
+	return sync_test_bit(port, &s->evtchn_pending[0]);
+}
+
 
 /**
  * notify_remote_via_irq - send event to remote end of event channel via irq
@@ -365,6 +360,10 @@ static void unbind_from_irq(unsigned int irq)
 			per_cpu(virq_to_irq, cpu_from_evtchn(evtchn))
 				[index_from_irq(irq)] = -1;
 			break;
+		case IRQT_IPI:
+			per_cpu(ipi_to_irq, cpu_from_evtchn(evtchn))
+				[index_from_irq(irq)] = -1;
+			break;
 		default:
 			break;
 		}
@@ -743,6 +742,25 @@ void xen_clear_irq_pending(int irq)
 		clear_evtchn(evtchn);
 }
 
+void xen_set_irq_pending(int irq)
+{
+	int evtchn = evtchn_from_irq(irq);
+
+	if (VALID_EVTCHN(evtchn))
+		set_evtchn(evtchn);
+}
+
+bool xen_test_irq_pending(int irq)
+{
+	int evtchn = evtchn_from_irq(irq);
+	bool ret = false;
+
+	if (VALID_EVTCHN(evtchn))
+		ret = test_evtchn(evtchn);
+
+	return ret;
+}
+
 /* Poll waiting for an irq to become pending.  In the usual case, the
    irq will be disabled so it won't deliver an interrupt. */
 void xen_poll_irq(int irq)
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index e9e1116..06592b9 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -508,7 +508,7 @@ static int __devinit gnttab_init(void)
 	unsigned int max_nr_glist_frames, nr_glist_frames;
 	unsigned int nr_init_grefs;
 
-	if (!is_running_on_xen())
+	if (!xen_domain())
 		return -ENODEV;
 
 	nr_grant_frames = 1;
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 57ceb53..7f24a98 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -814,7 +814,7 @@ static int __init xenbus_probe_init(void)
 	DPRINTK("");
 
 	err = -ENODEV;
-	if (!is_running_on_xen())
+	if (!xen_domain())
 		goto out_error;
 
 	/* Register ourselves with the kernel bus subsystem */
@@ -829,7 +829,7 @@ static int __init xenbus_probe_init(void)
 	/*
 	 * Domain0 doesn't have a store_evtchn or store_mfn yet.
 	 */
-	if (is_initial_xendomain()) {
+	if (xen_initial_domain()) {
 		/* dom0 not yet supported */
 	} else {
 		xenstored_ready = 1;
@@ -846,7 +846,7 @@ static int __init xenbus_probe_init(void)
 		goto out_unreg_back;
 	}
 
-	if (!is_initial_xendomain())
+	if (!xen_initial_domain())
 		xenbus_probe(NULL);
 
 	return 0;
@@ -937,7 +937,7 @@ static void wait_for_devices(struct xenbus_driver *xendrv)
 	unsigned long timeout = jiffies + 10*HZ;
 	struct device_driver *drv = xendrv ? &xendrv->driver : NULL;
 
-	if (!ready_to_wait_for_devices || !is_running_on_xen())
+	if (!ready_to_wait_for_devices || !xen_domain())
 		return;
 
 	while (exists_disconnected_device(drv)) {
diff --git a/include/asm-x86/acpi.h b/include/asm-x86/acpi.h
index 392e173..672e1e1 100644
--- a/include/asm-x86/acpi.h
+++ b/include/asm-x86/acpi.h
@@ -102,9 +102,6 @@ static inline void disable_acpi(void)
 	acpi_noirq = 1;
 }
 
-/* Fixmap pages to reserve for ACPI boot-time tables (see fixmap.h) */
-#define FIX_ACPI_PAGES 4
-
 extern int acpi_gsi_to_irq(u32 gsi, unsigned int *irq);
 
 static inline void acpi_noirq_set(void) { acpi_noirq = 1; }
diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index b73fea5..f06adac 100644
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -24,6 +24,11 @@ static inline void fill_ldt(struct desc_struct *desc,
 	desc->d = info->seg_32bit;
 	desc->g = info->limit_in_pages;
 	desc->base2 = (info->base_addr & 0xff000000) >> 24;
+	/*
+	 * Don't allow setting of the lm bit. It is useless anyway
+	 * because 64bit system calls require __USER_CS:
+	 */
+	desc->l = 0;
 }
 
 extern struct desc_ptr idt_descr;
@@ -97,7 +102,15 @@ static inline int desc_empty(const void *ptr)
 	native_write_gdt_entry(dt, entry, desc, type)
 #define write_idt_entry(dt, entry, g)		\
 	native_write_idt_entry(dt, entry, g)
-#endif
+
+static inline void paravirt_alloc_ldt(struct desc_struct *ldt, unsigned entries)
+{
+}
+
+static inline void paravirt_free_ldt(struct desc_struct *ldt, unsigned entries)
+{
+}
+#endif	/* CONFIG_PARAVIRT */
 
 static inline void native_write_idt_entry(gate_desc *idt, int entry,
 					  const gate_desc *gate)
@@ -338,20 +351,16 @@ static inline void set_system_intr_gate(unsigned int n, void *addr)
 	_set_gate(n, GATE_INTERRUPT, addr, 0x3, 0, __KERNEL_CS);
 }
 
-static inline void set_trap_gate(unsigned int n, void *addr)
+static inline void set_system_trap_gate(unsigned int n, void *addr)
 {
 	BUG_ON((unsigned)n > 0xFF);
-	_set_gate(n, GATE_TRAP, addr, 0, 0, __KERNEL_CS);
+	_set_gate(n, GATE_TRAP, addr, 0x3, 0, __KERNEL_CS);
 }
 
-static inline void set_system_gate(unsigned int n, void *addr)
+static inline void set_trap_gate(unsigned int n, void *addr)
 {
 	BUG_ON((unsigned)n > 0xFF);
-#ifdef CONFIG_X86_32
-	_set_gate(n, GATE_TRAP, addr, 0x3, 0, __KERNEL_CS);
-#else
-	_set_gate(n, GATE_INTERRUPT, addr, 0x3, 0, __KERNEL_CS);
-#endif
+	_set_gate(n, GATE_TRAP, addr, 0, 0, __KERNEL_CS);
 }
 
 static inline void set_task_gate(unsigned int n, unsigned int gdt_entry)
@@ -366,7 +375,7 @@ static inline void set_intr_gate_ist(int n, void *addr, unsigned ist)
 	_set_gate(n, GATE_INTERRUPT, addr, 0, ist, __KERNEL_CS);
 }
 
-static inline void set_system_gate_ist(int n, void *addr, unsigned ist)
+static inline void set_system_intr_gate_ist(int n, void *addr, unsigned ist)
 {
 	BUG_ON((unsigned)n > 0xFF);
 	_set_gate(n, GATE_INTERRUPT, addr, 0x3, ist, __KERNEL_CS);
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 0fff2e0..219c33d 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -306,4 +306,3 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 }
 
 #endif
-#endif /* ASM_X86__DMA_MAPPING_H */
diff --git a/include/asm-x86/es7000/mpparse.h b/include/asm-x86/es7000/mpparse.h
index 7b5c889..ed5a3ca 100644
--- a/include/asm-x86/es7000/mpparse.h
+++ b/include/asm-x86/es7000/mpparse.h
@@ -5,6 +5,7 @@
 
 extern int parse_unisys_oem (char *oemptr);
 extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
+extern void unmap_unisys_acpi_oem_table(unsigned long oem_addr);
 extern void setup_unisys(void);
 
 #ifndef CONFIG_X86_GENERICARCH
diff --git a/include/asm-x86/fixmap_32.h b/include/asm-x86/fixmap_32.h
index 784e3e7..c6fde10 100644
--- a/include/asm-x86/fixmap_32.h
+++ b/include/asm-x86/fixmap_32.h
@@ -94,15 +94,11 @@ enum fixed_addresses {
 	 * can have a single pgd entry and a single pte table:
 	 */
 #define NR_FIX_BTMAPS		64
-#define FIX_BTMAPS_NESTING	4
+#define FIX_BTMAPS_SLOTS	4
 	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
 			(__end_of_permanent_fixed_addresses & 255),
-	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_NESTING - 1,
+	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_SLOTS - 1,
 	FIX_WP_TEST,
-#ifdef CONFIG_ACPI
-	FIX_ACPI_BEGIN,
-	FIX_ACPI_END = FIX_ACPI_BEGIN + FIX_ACPI_PAGES - 1,
-#endif
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif
diff --git a/include/asm-x86/fixmap_64.h b/include/asm-x86/fixmap_64.h
index dafb24b..a6ff01d 100644
--- a/include/asm-x86/fixmap_64.h
+++ b/include/asm-x86/fixmap_64.h
@@ -49,26 +49,22 @@ enum fixed_addresses {
 #ifdef CONFIG_PARAVIRT
 	FIX_PARAVIRT_BOOTMAP,
 #endif
-#ifdef CONFIG_ACPI
-	FIX_ACPI_BEGIN,
-	FIX_ACPI_END = FIX_ACPI_BEGIN + FIX_ACPI_PAGES - 1,
-#endif
+	__end_of_permanent_fixed_addresses,
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif
-	__end_of_permanent_fixed_addresses,
 	/*
 	 * 256 temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.
 	 *
-	 * We round it up to the next 512 pages boundary so that we
+	 * We round it up to the next 256 pages boundary so that we
 	 * can have a single pgd entry and a single pte table:
 	 */
 #define NR_FIX_BTMAPS		64
-#define FIX_BTMAPS_NESTING	4
-	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 512 -
-			(__end_of_permanent_fixed_addresses & 511),
-	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_NESTING - 1,
+#define FIX_BTMAPS_SLOTS	4
+	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
+			(__end_of_permanent_fixed_addresses & 255),
+	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_SLOTS - 1,
 	__end_of_fixed_addresses
 };
 
diff --git a/include/asm-x86/io.h b/include/asm-x86/io.h
index 72b7719..a233f83 100644
--- a/include/asm-x86/io.h
+++ b/include/asm-x86/io.h
@@ -5,20 +5,6 @@
 
 #include <linux/compiler.h>
 
-/*
- * early_ioremap() and early_iounmap() are for temporary early boot-time
- * mappings, before the real ioremap() is functional.
- * A boot-time mapping is currently limited to at most 16 pages.
- */
-#ifndef __ASSEMBLY__
-extern void early_ioremap_init(void);
-extern void early_ioremap_clear(void);
-extern void early_ioremap_reset(void);
-extern void *early_ioremap(unsigned long offset, unsigned long size);
-extern void early_iounmap(void *addr, unsigned long size);
-extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
-#endif
-
 #define build_mmio_read(name, size, type, reg, barrier) \
 static inline type name(const volatile void __iomem *addr) \
 { type ret; asm volatile("mov" size " %1,%0":reg (ret) \
@@ -97,6 +83,7 @@ extern void early_ioremap_init(void);
 extern void early_ioremap_clear(void);
 extern void early_ioremap_reset(void);
 extern void *early_ioremap(unsigned long offset, unsigned long size);
+extern void *early_memremap(unsigned long offset, unsigned long size);
 extern void early_iounmap(void *addr, unsigned long size);
 extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 
diff --git a/include/asm-x86/io_64.h b/include/asm-x86/io_64.h
index 64429e9..ee6e086 100644
--- a/include/asm-x86/io_64.h
+++ b/include/asm-x86/io_64.h
@@ -165,9 +165,6 @@ static inline void *phys_to_virt(unsigned long address)
 
 #include <asm-generic/iomap.h>
 
-extern void *early_ioremap(unsigned long addr, unsigned long size);
-extern void early_iounmap(void *addr, unsigned long size);
-
 /*
  * This one maps high address device memory and turns off caching for that area.
  * it's useful if some control registers are in such an area and write combining
diff --git a/include/asm-x86/irqflags.h b/include/asm-x86/irqflags.h
index 424acb4..2bdab21 100644
--- a/include/asm-x86/irqflags.h
+++ b/include/asm-x86/irqflags.h
@@ -166,27 +166,6 @@ static inline int raw_irqs_disabled(void)
 	return raw_irqs_disabled_flags(flags);
 }
 
-/*
- * makes the traced hardirq state match with the machine state
- *
- * should be a rarely used function, only in places where its
- * otherwise impossible to know the irq state, like in traps.
- */
-static inline void trace_hardirqs_fixup_flags(unsigned long flags)
-{
-	if (raw_irqs_disabled_flags(flags))
-		trace_hardirqs_off();
-	else
-		trace_hardirqs_on();
-}
-
-static inline void trace_hardirqs_fixup(void)
-{
-	unsigned long flags = __raw_local_save_flags();
-
-	trace_hardirqs_fixup_flags(flags);
-}
-
 #else
 
 #ifdef CONFIG_X86_64
diff --git a/include/asm-x86/kdebug.h b/include/asm-x86/kdebug.h
index 5ec3ad3..fbbab66 100644
--- a/include/asm-x86/kdebug.h
+++ b/include/asm-x86/kdebug.h
@@ -27,10 +27,9 @@ extern void printk_address(unsigned long address, int reliable);
 extern void die(const char *, struct pt_regs *,long);
 extern int __must_check __die(const char *, struct pt_regs *, long);
 extern void show_registers(struct pt_regs *regs);
-extern void __show_registers(struct pt_regs *, int all);
 extern void show_trace(struct task_struct *t, struct pt_regs *regs,
 		       unsigned long *sp, unsigned long bp);
-extern void __show_regs(struct pt_regs *regs);
+extern void __show_regs(struct pt_regs *regs, int all);
 extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
diff --git a/include/asm-x86/kprobes.h b/include/asm-x86/kprobes.h
index bd84078..8a0748d 100644
--- a/include/asm-x86/kprobes.h
+++ b/include/asm-x86/kprobes.h
@@ -82,15 +82,6 @@ struct kprobe_ctlblk {
 	struct prev_kprobe prev_kprobe;
 };
 
-/* trap3/1 are intr gates for kprobes.  So, restore the status of IF,
- * if necessary, before executing the original int3/1 (trap) handler.
- */
-static inline void restore_interrupts(struct pt_regs *regs)
-{
-	if (regs->flags & X86_EFLAGS_IF)
-		local_irq_enable();
-}
-
 extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
diff --git a/include/asm-x86/mach-default/mach_traps.h b/include/asm-x86/mach-default/mach_traps.h
index de9ac3f..ff8778f 100644
--- a/include/asm-x86/mach-default/mach_traps.h
+++ b/include/asm-x86/mach-default/mach_traps.h
@@ -7,12 +7,6 @@
 
 #include <asm/mc146818rtc.h>
 
-static inline void clear_mem_error(unsigned char reason)
-{
-	reason = (reason & 0xf) | 4;
-	outb(reason, 0x61);
-}
-
 static inline unsigned char get_nmi_reason(void)
 {
 	return inb(0x61);
diff --git a/include/asm-x86/mmzone_64.h b/include/asm-x86/mmzone_64.h
index 626b03a..6480f33 100644
--- a/include/asm-x86/mmzone_64.h
+++ b/include/asm-x86/mmzone_64.h
@@ -7,7 +7,7 @@
 
 #ifdef CONFIG_NUMA
 
-#define VIRTUAL_BUG_ON(x)
+#include <linux/mmdebug.h>
 
 #include <asm/smp.h>
 
@@ -29,7 +29,6 @@ static inline __attribute__((pure)) int phys_to_nid(unsigned long addr)
 {
 	unsigned nid;
 	VIRTUAL_BUG_ON(!memnodemap);
-	VIRTUAL_BUG_ON((addr >> memnode_shift) >= memnodemapsize);
 	nid = memnodemap[addr >> memnode_shift];
 	VIRTUAL_BUG_ON(nid >= MAX_NUMNODES || !node_data[nid]);
 	return nid;
diff --git a/include/asm-x86/module.h b/include/asm-x86/module.h
index 48dc3e0..864f200 100644
--- a/include/asm-x86/module.h
+++ b/include/asm-x86/module.h
@@ -52,8 +52,6 @@ struct mod_arch_specific {};
 #define MODULE_PROC_FAMILY "EFFICEON "
 #elif defined CONFIG_MWINCHIPC6
 #define MODULE_PROC_FAMILY "WINCHIPC6 "
-#elif defined CONFIG_MWINCHIP2
-#define MODULE_PROC_FAMILY "WINCHIP2 "
 #elif defined CONFIG_MWINCHIP3D
 #define MODULE_PROC_FAMILY "WINCHIP3D "
 #elif defined CONFIG_MCYRIXIII
diff --git a/include/asm-x86/nmi.h b/include/asm-x86/nmi.h
index d5e715f..a53f829 100644
--- a/include/asm-x86/nmi.h
+++ b/include/asm-x86/nmi.h
@@ -15,10 +15,6 @@
  */
 int do_nmi_callback(struct pt_regs *regs, int cpu);
 
-#ifdef CONFIG_X86_64
-extern void default_do_nmi(struct pt_regs *);
-#endif
-
 extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int check_nmi_watchdog(void);
 extern int nmi_watchdog_enabled;
diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
index c915747..d4f1d57 100644
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -179,6 +179,7 @@ static inline pteval_t native_pte_flags(pte_t pte)
 #endif	/* CONFIG_PARAVIRT */
 
 #define __pa(x)		__phys_addr((unsigned long)(x))
+#define __pa_nodebug(x)	__phys_addr_nodebug((unsigned long)(x))
 /* __pa_symbol should be used for C visible symbols.
    This seems to be the official gcc blessed way to do such arithmetic. */
 #define __pa_symbol(x)	__pa(__phys_reloc_hide((unsigned long)(x)))
@@ -188,9 +189,14 @@ static inline pteval_t native_pte_flags(pte_t pte)
 #define __boot_va(x)		__va(x)
 #define __boot_pa(x)		__pa(x)
 
+/*
+ * virt_to_page(kaddr) returns a valid pointer if and only if
+ * virt_addr_valid(kaddr) returns true.
+ */
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 #define pfn_to_kaddr(pfn)      __va((pfn) << PAGE_SHIFT)
-#define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
+extern bool __virt_addr_valid(unsigned long kaddr);
+#define virt_addr_valid(kaddr)	__virt_addr_valid((unsigned long) (kaddr))
 
 #endif	/* __ASSEMBLY__ */
 
diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
index 72f7305..e8d80d1 100644
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -20,6 +20,12 @@
 #endif
 #define THREAD_SIZE 	(PAGE_SIZE << THREAD_ORDER)
 
+#define STACKFAULT_STACK 0
+#define DOUBLEFAULT_STACK 1
+#define NMI_STACK 0
+#define DEBUG_STACK 0
+#define MCE_STACK 0
+#define N_EXCEPTION_STACKS 1
 
 #ifdef CONFIG_X86_PAE
 /* 44=32+12, the limit we can fit into an unsigned long pfn */
@@ -73,7 +79,12 @@ typedef struct page *pgtable_t;
 #endif
 
 #ifndef __ASSEMBLY__
-#define __phys_addr(x)		((x) - PAGE_OFFSET)
+#define __phys_addr_nodebug(x)	((x) - PAGE_OFFSET)
+#ifdef CONFIG_DEBUG_VIRTUAL
+extern unsigned long __phys_addr(unsigned long);
+#else
+#define __phys_addr(x)		__phys_addr_nodebug(x)
+#endif
 #define __phys_reloc_hide(x)	RELOC_HIDE((x), 0)
 
 #ifdef CONFIG_FLATMEM
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index d7d358a..8d6ae2f 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -124,6 +124,9 @@ struct pv_cpu_ops {
 				int entrynum, const void *desc, int size);
 	void (*write_idt_entry)(gate_desc *,
 				int entrynum, const gate_desc *gate);
+	void (*alloc_ldt)(struct desc_struct *ldt, unsigned entries);
+	void (*free_ldt)(struct desc_struct *ldt, unsigned entries);
+
 	void (*load_sp0)(struct tss_struct *tss, struct thread_struct *t);
 
 	void (*set_iopl_mask)(unsigned mask);
@@ -325,6 +328,7 @@ struct pv_lock_ops {
 	int (*spin_is_locked)(struct raw_spinlock *lock);
 	int (*spin_is_contended)(struct raw_spinlock *lock);
 	void (*spin_lock)(struct raw_spinlock *lock);
+	void (*spin_lock_flags)(struct raw_spinlock *lock, unsigned long flags);
 	int (*spin_trylock)(struct raw_spinlock *lock);
 	void (*spin_unlock)(struct raw_spinlock *lock);
 };
@@ -830,6 +834,16 @@ do {							\
 	(aux) = __aux;					\
 } while (0)
 
+static inline void paravirt_alloc_ldt(struct desc_struct *ldt, unsigned entries)
+{
+	PVOP_VCALL2(pv_cpu_ops.alloc_ldt, ldt, entries);
+}
+
+static inline void paravirt_free_ldt(struct desc_struct *ldt, unsigned entries)
+{
+	PVOP_VCALL2(pv_cpu_ops.free_ldt, ldt, entries);
+}
+
 static inline void load_TR_desc(void)
 {
 	PVOP_VCALL0(pv_cpu_ops.load_tr_desc);
@@ -1394,6 +1408,12 @@ static __always_inline void __raw_spin_lock(struct raw_spinlock *lock)
 	PVOP_VCALL1(pv_lock_ops.spin_lock, lock);
 }
 
+static __always_inline void __raw_spin_lock_flags(struct raw_spinlock *lock,
+						  unsigned long flags)
+{
+	PVOP_VCALL2(pv_lock_ops.spin_lock_flags, lock, flags);
+}
+
 static __always_inline int __raw_spin_trylock(struct raw_spinlock *lock)
 {
 	return PVOP_CALL1(int, pv_lock_ops.spin_trylock, lock);
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index ed93245..182f9d4 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -15,7 +15,7 @@
 #define _PAGE_BIT_PAT		7	/* on 4KB pages */
 #define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
 #define _PAGE_BIT_UNUSED1	9	/* available for programmer */
-#define _PAGE_BIT_UNUSED2	10
+#define _PAGE_BIT_IOMAP		10	/* flag used to indicate IO mapping */
 #define _PAGE_BIT_UNUSED3	11
 #define _PAGE_BIT_PAT_LARGE	12	/* On 2MB or 1GB pages */
 #define _PAGE_BIT_SPECIAL	_PAGE_BIT_UNUSED1
@@ -32,7 +32,7 @@
 #define _PAGE_PSE	(_AT(pteval_t, 1) << _PAGE_BIT_PSE)
 #define _PAGE_GLOBAL	(_AT(pteval_t, 1) << _PAGE_BIT_GLOBAL)
 #define _PAGE_UNUSED1	(_AT(pteval_t, 1) << _PAGE_BIT_UNUSED1)
-#define _PAGE_UNUSED2	(_AT(pteval_t, 1) << _PAGE_BIT_UNUSED2)
+#define _PAGE_IOMAP	(_AT(pteval_t, 1) << _PAGE_BIT_IOMAP)
 #define _PAGE_UNUSED3	(_AT(pteval_t, 1) << _PAGE_BIT_UNUSED3)
 #define _PAGE_PAT	(_AT(pteval_t, 1) << _PAGE_BIT_PAT)
 #define _PAGE_PAT_LARGE (_AT(pteval_t, 1) << _PAGE_BIT_PAT_LARGE)
@@ -99,6 +99,11 @@
 #define __PAGE_KERNEL_LARGE_NOCACHE	(__PAGE_KERNEL | _PAGE_CACHE_UC | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
 
+#define __PAGE_KERNEL_IO		(__PAGE_KERNEL | _PAGE_IOMAP)
+#define __PAGE_KERNEL_IO_NOCACHE	(__PAGE_KERNEL_NOCACHE | _PAGE_IOMAP)
+#define __PAGE_KERNEL_IO_UC_MINUS	(__PAGE_KERNEL_UC_MINUS | _PAGE_IOMAP)
+#define __PAGE_KERNEL_IO_WC		(__PAGE_KERNEL_WC | _PAGE_IOMAP)
+
 #define PAGE_KERNEL			__pgprot(__PAGE_KERNEL)
 #define PAGE_KERNEL_RO			__pgprot(__PAGE_KERNEL_RO)
 #define PAGE_KERNEL_EXEC		__pgprot(__PAGE_KERNEL_EXEC)
@@ -113,6 +118,11 @@
 #define PAGE_KERNEL_VSYSCALL		__pgprot(__PAGE_KERNEL_VSYSCALL)
 #define PAGE_KERNEL_VSYSCALL_NOCACHE	__pgprot(__PAGE_KERNEL_VSYSCALL_NOCACHE)
 
+#define PAGE_KERNEL_IO			__pgprot(__PAGE_KERNEL_IO)
+#define PAGE_KERNEL_IO_NOCACHE		__pgprot(__PAGE_KERNEL_IO_NOCACHE)
+#define PAGE_KERNEL_IO_UC_MINUS		__pgprot(__PAGE_KERNEL_IO_UC_MINUS)
+#define PAGE_KERNEL_IO_WC		__pgprot(__PAGE_KERNEL_IO_WC)
+
 /*         xwr */
 #define __P000	PAGE_NONE
 #define __P001	PAGE_READONLY
@@ -196,7 +206,7 @@ static inline int pte_exec(pte_t pte)
 
 static inline int pte_special(pte_t pte)
 {
-	return pte_val(pte) & _PAGE_SPECIAL;
+	return pte_flags(pte) & _PAGE_SPECIAL;
 }
 
 static inline unsigned long pte_pfn(pte_t pte)
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index ac578f1..a202552 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -174,12 +174,8 @@ extern unsigned long profile_pc(struct pt_regs *regs);
 
 extern unsigned long
 convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
-
-#ifdef CONFIG_X86_32
 extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 			 int error_code, int si_code);
-#endif
-
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 
 extern long syscall_trace_enter(struct pt_regs *);
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 29324c1..a6afc29 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -50,12 +50,16 @@ extern struct {
 struct smp_ops {
 	void (*smp_prepare_boot_cpu)(void);
 	void (*smp_prepare_cpus)(unsigned max_cpus);
-	int (*cpu_up)(unsigned cpu);
 	void (*smp_cpus_done)(unsigned max_cpus);
 
 	void (*smp_send_stop)(void);
 	void (*smp_send_reschedule)(int cpu);
 
+	int (*cpu_up)(unsigned cpu);
+	int (*cpu_disable)(void);
+	void (*cpu_die)(unsigned int cpu);
+	void (*play_dead)(void);
+
 	void (*send_call_func_ipi)(cpumask_t mask);
 	void (*send_call_func_single_ipi)(int cpu);
 };
@@ -94,6 +98,21 @@ static inline int __cpu_up(unsigned int cpu)
 	return smp_ops.cpu_up(cpu);
 }
 
+static inline int __cpu_disable(void)
+{
+	return smp_ops.cpu_disable();
+}
+
+static inline void __cpu_die(unsigned int cpu)
+{
+	smp_ops.cpu_die(cpu);
+}
+
+static inline void play_dead(void)
+{
+	smp_ops.play_dead();
+}
+
 static inline void smp_send_reschedule(int cpu)
 {
 	smp_ops.smp_send_reschedule(cpu);
@@ -109,15 +128,20 @@ static inline void arch_send_call_function_ipi(cpumask_t mask)
 	smp_ops.send_call_func_ipi(mask);
 }
 
+void cpu_disable_common(void);
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
 int native_cpu_up(unsigned int cpunum);
+int native_cpu_disable(void);
+void native_cpu_die(unsigned int cpu);
+void native_play_dead(void);
+void play_dead_common(void);
+
 void native_send_call_func_ipi(cpumask_t mask);
 void native_send_call_func_single_ipi(int cpu);
 
-extern int __cpu_disable(void);
-extern void __cpu_die(unsigned int cpu);
+extern void prefill_possible_map(void);
 
 void smp_store_cpu_info(int id);
 #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
@@ -127,15 +151,11 @@ static inline int num_booting_cpus(void)
 {
 	return cpus_weight(cpu_callout_map);
 }
-#endif /* CONFIG_SMP */
-
-#if defined(CONFIG_SMP) && defined(CONFIG_HOTPLUG_CPU)
-extern void prefill_possible_map(void);
 #else
 static inline void prefill_possible_map(void)
 {
 }
-#endif
+#endif /* CONFIG_SMP */
 
 extern unsigned disabled_cpus __cpuinitdata;
 
@@ -205,9 +225,5 @@ static inline int hard_smp_processor_id(void)
 
 #endif /* CONFIG_X86_LOCAL_APIC */
 
-#ifdef CONFIG_HOTPLUG_CPU
-extern void cpu_uninit(void);
-#endif
-
 #endif /* __ASSEMBLY__ */
 #endif /* ASM_X86__SMP_H */
diff --git a/include/asm-x86/spinlock.h b/include/asm-x86/spinlock.h
index 93adae3..8badab0 100644
--- a/include/asm-x86/spinlock.h
+++ b/include/asm-x86/spinlock.h
@@ -182,8 +182,6 @@ static __always_inline void __ticket_spin_unlock(raw_spinlock_t *lock)
 }
 #endif
 
-#define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
-
 #ifdef CONFIG_PARAVIRT
 /*
  * Define virtualization-friendly old-style lock byte lock, for use in
@@ -272,6 +270,13 @@ static __always_inline void __raw_spin_unlock(raw_spinlock_t *lock)
 {
 	__ticket_spin_unlock(lock);
 }
+
+static __always_inline void __raw_spin_lock_flags(raw_spinlock_t *lock,
+						  unsigned long flags)
+{
+	__raw_spin_lock(lock);
+}
+
 #endif	/* CONFIG_PARAVIRT */
 
 static inline void __raw_spin_unlock_wait(raw_spinlock_t *lock)
diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index 34505dd..b20c894 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -64,7 +64,10 @@ do {									\
 		       							\
 		       /* regparm parameters for __switch_to(): */	\
 		       [prev]     "a" (prev),				\
-		       [next]     "d" (next));				\
+		       [next]     "d" (next)				\
+									\
+		     : /* reloaded segment registers */			\
+			"memory");					\
 } while (0)
 
 /*
diff --git a/include/asm-x86/tlbflush.h b/include/asm-x86/tlbflush.h
index ef68b76..3cdd08b 100644
--- a/include/asm-x86/tlbflush.h
+++ b/include/asm-x86/tlbflush.h
@@ -119,6 +119,10 @@ static inline void native_flush_tlb_others(const cpumask_t *cpumask,
 {
 }
 
+static inline void reset_lazy_tlbstate(void)
+{
+}
+
 #else  /* SMP */
 
 #include <asm/smp.h>
@@ -151,6 +155,12 @@ struct tlb_state {
 	char __cacheline_padding[L1_CACHE_BYTES-8];
 };
 DECLARE_PER_CPU(struct tlb_state, cpu_tlbstate);
+
+void reset_lazy_tlbstate(void);
+#else
+static inline void reset_lazy_tlbstate(void)
+{
+}
 #endif
 
 #endif	/* SMP */
diff --git a/include/asm-x86/traps.h b/include/asm-x86/traps.h
index 7a692ba..6c3dc2c 100644
--- a/include/asm-x86/traps.h
+++ b/include/asm-x86/traps.h
@@ -3,7 +3,12 @@
 
 #include <asm/debugreg.h>
 
-/* Common in X86_32 and X86_64 */
+#ifdef CONFIG_X86_32
+#define dotraplinkage
+#else
+#define dotraplinkage asmlinkage
+#endif
+
 asmlinkage void divide_error(void);
 asmlinkage void debug(void);
 asmlinkage void nmi(void);
@@ -12,31 +17,47 @@ asmlinkage void overflow(void);
 asmlinkage void bounds(void);
 asmlinkage void invalid_op(void);
 asmlinkage void device_not_available(void);
+#ifdef CONFIG_X86_64
+asmlinkage void double_fault(void);
+#endif
 asmlinkage void coprocessor_segment_overrun(void);
 asmlinkage void invalid_TSS(void);
 asmlinkage void segment_not_present(void);
 asmlinkage void stack_segment(void);
 asmlinkage void general_protection(void);
 asmlinkage void page_fault(void);
+asmlinkage void spurious_interrupt_bug(void);
 asmlinkage void coprocessor_error(void);
-asmlinkage void simd_coprocessor_error(void);
 asmlinkage void alignment_check(void);
-asmlinkage void spurious_interrupt_bug(void);
 #ifdef CONFIG_X86_MCE
 asmlinkage void machine_check(void);
 #endif /* CONFIG_X86_MCE */
+asmlinkage void simd_coprocessor_error(void);
 
-void do_divide_error(struct pt_regs *, long);
-void do_overflow(struct pt_regs *, long);
-void do_bounds(struct pt_regs *, long);
-void do_coprocessor_segment_overrun(struct pt_regs *, long);
-void do_invalid_TSS(struct pt_regs *, long);
-void do_segment_not_present(struct pt_regs *, long);
-void do_stack_segment(struct pt_regs *, long);
-void do_alignment_check(struct pt_regs *, long);
-void do_invalid_op(struct pt_regs *, long);
-void do_general_protection(struct pt_regs *, long);
-void do_nmi(struct pt_regs *, long);
+dotraplinkage void do_divide_error(struct pt_regs *, long);
+dotraplinkage void do_debug(struct pt_regs *, long);
+dotraplinkage void do_nmi(struct pt_regs *, long);
+dotraplinkage void do_int3(struct pt_regs *, long);
+dotraplinkage void do_overflow(struct pt_regs *, long);
+dotraplinkage void do_bounds(struct pt_regs *, long);
+dotraplinkage void do_invalid_op(struct pt_regs *, long);
+dotraplinkage void do_device_not_available(struct pt_regs *, long);
+dotraplinkage void do_coprocessor_segment_overrun(struct pt_regs *, long);
+dotraplinkage void do_invalid_TSS(struct pt_regs *, long);
+dotraplinkage void do_segment_not_present(struct pt_regs *, long);
+dotraplinkage void do_stack_segment(struct pt_regs *, long);
+dotraplinkage void do_general_protection(struct pt_regs *, long);
+dotraplinkage void do_page_fault(struct pt_regs *, unsigned long);
+dotraplinkage void do_spurious_interrupt_bug(struct pt_regs *, long);
+dotraplinkage void do_coprocessor_error(struct pt_regs *, long);
+dotraplinkage void do_alignment_check(struct pt_regs *, long);
+#ifdef CONFIG_X86_MCE
+dotraplinkage void do_machine_check(struct pt_regs *, long);
+#endif
+dotraplinkage void do_simd_coprocessor_error(struct pt_regs *, long);
+#ifdef CONFIG_X86_32
+dotraplinkage void do_iret_error(struct pt_regs *, long);
+#endif
 
 static inline int get_si_code(unsigned long condition)
 {
@@ -52,31 +73,9 @@ extern int panic_on_unrecovered_nmi;
 extern int kstack_depth_to_print;
 
 #ifdef CONFIG_X86_32
-
-void do_iret_error(struct pt_regs *, long);
-void do_int3(struct pt_regs *, long);
-void do_debug(struct pt_regs *, long);
 void math_error(void __user *);
-void do_coprocessor_error(struct pt_regs *, long);
-void do_simd_coprocessor_error(struct pt_regs *, long);
-void do_spurious_interrupt_bug(struct pt_regs *, long);
 unsigned long patch_espfix_desc(unsigned long, unsigned long);
 asmlinkage void math_emulate(long);
+#endif
 
-void do_page_fault(struct pt_regs *regs, unsigned long error_code);
-
-#else /* CONFIG_X86_32 */
-
-asmlinkage void double_fault(void);
-
-asmlinkage void do_int3(struct pt_regs *, long);
-asmlinkage void do_stack_segment(struct pt_regs *, long);
-asmlinkage void do_debug(struct pt_regs *, unsigned long);
-asmlinkage void do_coprocessor_error(struct pt_regs *);
-asmlinkage void do_simd_coprocessor_error(struct pt_regs *);
-asmlinkage void do_spurious_interrupt_bug(struct pt_regs *);
-
-asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long error_code);
-
-#endif /* CONFIG_X86_32 */
 #endif /* ASM_X86__TRAPS_H */
diff --git a/include/asm-x86/xen/hypervisor.h b/include/asm-x86/xen/hypervisor.h
index 0ef3a88..445a247 100644
--- a/include/asm-x86/xen/hypervisor.h
+++ b/include/asm-x86/xen/hypervisor.h
@@ -54,7 +54,6 @@
 /* arch/i386/kernel/setup.c */
 extern struct shared_info *HYPERVISOR_shared_info;
 extern struct start_info *xen_start_info;
-#define is_initial_xendomain() (xen_start_info->flags & SIF_INITDOMAIN)
 
 /* arch/i386/mach-xen/evtchn.c */
 /* Force a proper event-channel callback from Xen. */
@@ -67,6 +66,17 @@ u64 jiffies_to_st(unsigned long jiffies);
 #define MULTI_UVMFLAGS_INDEX 3
 #define MULTI_UVMDOMID_INDEX 4
 
-#define is_running_on_xen()	(xen_start_info ? 1 : 0)
+enum xen_domain_type {
+	XEN_NATIVE,
+	XEN_PV_DOMAIN,
+	XEN_HVM_DOMAIN,
+};
+
+extern enum xen_domain_type xen_domain_type;
+
+#define xen_domain()		(xen_domain_type != XEN_NATIVE)
+#define xen_pv_domain()		(xen_domain_type == XEN_PV_DOMAIN)
+#define xen_initial_domain()	(xen_pv_domain() && xen_start_info->flags & SIF_INITDOMAIN)
+#define xen_hvm_domain()	(xen_domain_type == XEN_HVM_DOMAIN)
 
 #endif /* ASM_X86__XEN__HYPERVISOR_H */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2651f80..75d81f1 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -182,7 +182,7 @@ extern int vsscanf(const char *, const char *, va_list)
 
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
-extern unsigned long long memparse(char *ptr, char **retptr);
+extern unsigned long long memparse(const char *ptr, char **retptr);
 
 extern int core_kernel_text(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 72a15dc..c61ba10 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -7,6 +7,7 @@
 
 #include <linux/gfp.h>
 #include <linux/list.h>
+#include <linux/mmdebug.h>
 #include <linux/mmzone.h>
 #include <linux/rbtree.h>
 #include <linux/prio_tree.h>
@@ -219,12 +220,6 @@ struct inode;
  */
 #include <linux/page-flags.h>
 
-#ifdef CONFIG_DEBUG_VM
-#define VM_BUG_ON(cond) BUG_ON(cond)
-#else
-#define VM_BUG_ON(condition) do { } while(0)
-#endif
-
 /*
  * Methods to modify the page usage count.
  *
@@ -919,7 +914,7 @@ static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long a
 }
 #endif /* CONFIG_MMU && !__ARCH_HAS_4LEVEL_HACK */
 
-#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+#if USE_SPLIT_PTLOCKS
 /*
  * We tuck a spinlock to guard each pagetable page into its struct page,
  * at page->private, with BUILD_BUG_ON to make sure that this will not
@@ -932,14 +927,14 @@ static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long a
 } while (0)
 #define pte_lock_deinit(page)	((page)->mapping = NULL)
 #define pte_lockptr(mm, pmd)	({(void)(mm); __pte_lockptr(pmd_page(*(pmd)));})
-#else
+#else	/* !USE_SPLIT_PTLOCKS */
 /*
  * We use mm->page_table_lock to guard all pagetable pages of the mm.
  */
 #define pte_lock_init(page)	do {} while (0)
 #define pte_lock_deinit(page)	do {} while (0)
 #define pte_lockptr(mm, pmd)	({(void)(pmd); &(mm)->page_table_lock;})
-#endif /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
+#endif /* USE_SPLIT_PTLOCKS */
 
 static inline void pgtable_page_ctor(struct page *page)
 {
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index bf33413..9d49fa3 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -21,11 +21,13 @@
 
 struct address_space;
 
-#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+#define USE_SPLIT_PTLOCKS	(NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS)
+
+#if USE_SPLIT_PTLOCKS
 typedef atomic_long_t mm_counter_t;
-#else  /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
+#else  /* !USE_SPLIT_PTLOCKS */
 typedef unsigned long mm_counter_t;
-#endif /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
+#endif /* !USE_SPLIT_PTLOCKS */
 
 /*
  * Each physical page in the system has a struct page associated with
@@ -65,7 +67,7 @@ struct page {
 						 * see PAGE_MAPPING_ANON below.
 						 */
 	    };
-#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+#if USE_SPLIT_PTLOCKS
 	    spinlock_t ptl;
 #endif
 	    struct kmem_cache *slab;	/* SLUB: Pointer to slab */
diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
new file mode 100644
index 0000000..8a55098
--- /dev/null
+++ b/include/linux/mmdebug.h
@@ -0,0 +1,18 @@
+#ifndef LINUX_MM_DEBUG_H
+#define LINUX_MM_DEBUG_H 1
+
+#include <linux/autoconf.h>
+
+#ifdef CONFIG_DEBUG_VM
+#define VM_BUG_ON(cond) BUG_ON(cond)
+#else
+#define VM_BUG_ON(cond) do { } while (0)
+#endif
+
+#ifdef CONFIG_DEBUG_VIRTUAL
+#define VIRTUAL_BUG_ON(cond) BUG_ON(cond)
+#else
+#define VIRTUAL_BUG_ON(cond) do { } while (0)
+#endif
+
+#endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3d9120c..272c353 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -352,7 +352,7 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 extern void arch_unmap_area(struct mm_struct *, unsigned long);
 extern void arch_unmap_area_topdown(struct mm_struct *, unsigned long);
 
-#if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
+#if USE_SPLIT_PTLOCKS
 /*
  * The mm counters are not protected by its page_table_lock,
  * so must be incremented atomically.
@@ -363,7 +363,7 @@ extern void arch_unmap_area_topdown(struct mm_struct *, unsigned long);
 #define inc_mm_counter(mm, member) atomic_long_inc(&(mm)->_##member)
 #define dec_mm_counter(mm, member) atomic_long_dec(&(mm)->_##member)
 
-#else  /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
+#else  /* !USE_SPLIT_PTLOCKS */
 /*
  * The mm counters are protected by its page_table_lock,
  * so can be incremented directly.
@@ -374,7 +374,7 @@ extern void arch_unmap_area_topdown(struct mm_struct *, unsigned long);
 #define inc_mm_counter(mm, member) (mm)->_##member++
 #define dec_mm_counter(mm, member) (mm)->_##member--
 
-#endif /* NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS */
+#endif /* !USE_SPLIT_PTLOCKS */
 
 #define get_mm_rss(mm)					\
 	(get_mm_counter(mm, file_rss) + get_mm_counter(mm, anon_rss))
diff --git a/include/xen/events.h b/include/xen/events.h
index 4680ff3..0d5f1ad 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -46,6 +46,8 @@ extern void xen_irq_resume(void);
 
 /* Clear an irq's pending state, in preparation for polling on it */
 void xen_clear_irq_pending(int irq);
+void xen_set_irq_pending(int irq);
+bool xen_test_irq_pending(int irq);
 
 /* Poll waiting for an irq to become pending.  In the usual case, the
    irq will be disabled so it won't deliver an interrupt. */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 0b50481..082235b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -495,6 +495,15 @@ config DEBUG_VM
 
 	  If unsure, say N.
 
+config DEBUG_VIRTUAL
+	bool "Debug VM translations"
+	depends on DEBUG_KERNEL && X86
+	help
+	  Enable some costly sanity checks in virtual to page code. This can
+	  catch mistakes with virt_to_page() and friends.
+
+	  If unsure, say N.
+
 config DEBUG_WRITECOUNT
 	bool "Debug filesystem writers count"
 	depends on DEBUG_KERNEL
diff --git a/lib/cmdline.c b/lib/cmdline.c
index 5ba8a94..f5f3ad8 100644
--- a/lib/cmdline.c
+++ b/lib/cmdline.c
@@ -126,7 +126,7 @@ char *get_options(const char *str, int nints, int *ints)
  *	megabyte, or one gigabyte, respectively.
  */
 
-unsigned long long memparse(char *ptr, char **retptr)
+unsigned long long memparse(const char *ptr, char **retptr)
 {
 	char *endptr;	/* local pointer to end of parsed string */
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 85b9a0d..bba06c4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -180,6 +180,13 @@ struct page *vmalloc_to_page(const void *vmalloc_addr)
 	pmd_t *pmd;
 	pte_t *ptep, pte;
 
+	/*
+	 * XXX we might need to change this if we add VIRTUAL_BUG_ON for
+	 * architectures that do not vmalloc module space
+	 */
+	VIRTUAL_BUG_ON(!is_vmalloc_addr(vmalloc_addr) &&
+			!is_module_address(addr));
+
 	if (!pgd_none(*pgd)) {
 		pud = pud_offset(pgd, addr);
 		if (!pud_none(*pud)) {
