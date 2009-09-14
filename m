Return-Path: <linux-kernel-owner+w=401wt.eu-S1751880AbZINFtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbZINFtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 01:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbZINFtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 01:49:10 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43458 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbZINFtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 01:49:07 -0400
Date: Mon, 14 Sep 2009 14:48:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: What's in sh-2.6.git for 2.6.32?
Message-ID: <20090914054854.GF15078@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better late than never.. here is a brief summary of the bits queued up
for the 2.6.32 merge window.

	- New board support (SH7724-based EcoVec)
	- New CPU support (SH7757)
	- Runtime PM support for all SH-Mobile CPUs, platform devices,
	  etc..
	- A shiny new dwarf unwinder.
	- ftrace function graph and syscall tracing support.
	- R8A66597 USB gadget support.
	- Board updates (ms7724se, kfr2409, sh7785lcr 32-bit mode, etc.)
	- A new romimage boot target, used in tandem with kexec jump.
	- Generic NMI debugging (decoupled from kgdb).
	- LMB support.
	- A fairly big reorg and cleanup of the cache and TLB routines,
	  in preparation for newer cores and mixed coherency protocols.
	- .. as well as more _64/_32 consolidation, and various bugfixes/
	  optimizations/misc updates from the ST tree.

There are a few merge order dependencies here, so this will go out once
the suspend tree and parts of the v4l tree have merged.

The tree is at:

	git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git

and contains:

Alessandro Zummo (2):
      rtc: rtc-ds1302 fixes
      rtc: rtc-sh fixes

Andre Draszik (3):
      sh: ratelimit unaligned fixups
      sh: Allow user control over misaligned fixup handling
      sh: cleanup of do_address_error()

Carl Shaw (1):
      sh: Improve unwind info for signals

Christoph Hellwig (1):
      sh: convert to asm-generic/hardirq.h

David McKay (1):
      sh: Allow use of GENERIC_IOMAP

Giuseppe Cavallaro (2):
      sh: kgdb: do not reload VBR while handling debugger breackpoint
      sh: fix sys_cacheflush error checking

Jon Frosdick (1):
      sh: Use internal watchdog timer to perform reset

Kuninori Morimoto (22):
      sh: ms7724se: add 1280x720 lcdc output support
      sh: Add SH7724 DMAC support.
      sh: mach-kfr2409: add FLLFRQ value for PLL correction.
      sh: clkfwk: Support additional IFC divisor on SH7724.
      sh: Prevent heartbeat from scribbling over non-LED bits.
      sh: USB0 resource area fix for ms7724se
      sh: Add SH7724 support to NR_ONCHIP_DMA_CHANNELS
      sh: Add EcoVec (SH7724) board support
      sh: fix CPU_SH7723/7724 numbering bug
      sh: modify to enable boot for EcoVec24
      sh: Add SH-ETH support for EcoVec24
      sh: Add USB support for EcoVec24
      sh: Add support LCDC for EcoVec24
      sh: Add CEU support for EcoVec24
      sh: Add LCDC Panel support for EcoVec24
      sh: Add I2C device support for EcoVec24
      sh: add romimage-macros.h
      sh: Add romImage support for EcoVec24
      sh: EcoVec24: write MAC address in boot
      sh: EcoVec24: add HIZA setting for LED
      sh: USB disable process is needed if romImage boot for EcoVec24
      sh: Add EcoVec24 romImage defconfig

Magnus Damm (56):
      sh: hwblk base implementation
      sh: hwblk for sh7722
      sh: cpuidle for SuperH Mobile using hwblk
      usb: m66592-udc buffer management update
      sh: Add support for multiple hwblk counters
      sh: hwblk support for sh7723
      usb: convert r8a66597-hcd to dev_pm_ops
      usb: r8a66597-hcd platform data on_chip support
      usb: move r8a66597 register defines
      usb: m66592-udc platform data on_chip support
      i2c: change i2c-sh_mobile.c module_init() to subsys_initcall()
      sh: convert processor device setup functions to arch_initcall()
      sh: kfr2r09 board support - SCIF console
      sh: kfr2r09 board support - NOR flash
      sh: kfr2r09 board support - KEYSC keypad
      sh: kfr2r09 board support - mach-type and defconfig
      sh: romImage support V2
      sh: kfr2r09 romImage support V2
      sh: hwblk support for sh7724
      sh: clean up MSTPCRn register definitions
      sh: Runtime PM pdev hwblk
      sh: Runtime PM pdev hwblk - sh7722
      sh: Runtime PM pdev hwblk - Migo-R
      sh: Runtime PM pdev hwblk - Solution Engine 7722
      sh: Runtime PM pdev hwblk - sh7723
      sh: Runtime PM pdev hwblk - AP325RXA
      sh: Runtime PM pdev hwblk - sh7724
      sh: Runtime PM pdev hwblk - kfr2r09
      sh: Runtime PM pdev hwblk - Solution Engine 7724
      sh: LCDC SYS bus access wait fix
      sh: 18-bit SYS panel fix for SuperH Mobile LCDC
      sh: kfr2r09 board support - LCDC panel
      sh: kfr2r09 board support - NAND flash
      sh: LED9, LED10 and LED11 support for Solution Engine 7724
      sh: fix romImage mach dir usage
      sh: clean up Migo-R header file
      sh: Runtime PM pdev hwblk - kfr2r09 LCDC
      sh: rework SuperH Mobile sleep code exception handling
      sh: SuperH Mobile Software Standby support for cpuidle
      usb: add clock support to r8a66597 gadget driver
      usb: r8a66597-udc buffer management update
      usb: r8a66597-udc disable interrupts on shutdown fix
      sh: add r8a66597 usb0 gadget to the kfr2r09 board
      sh: add r8a66597 usb1 gadget to the se7724 board
      sh: i2c compile fix for kfr2r09
      sh: invalidate icache and tlbs during boot on kfr2r09
      sh: jump to p1 during boot on kfr2r09
      sh: add kfr2r09 romimage defconfig
      sh: update kfr2r09 defconfig
      sh: Runtime PM for SuperH Mobile platform bus devices
      i2c: Runtime PM for SuperH Mobile I2C
      video: Runtime PM for SuperH Mobile LCDC
      v4l2: Runtime PM for SuperH Mobile CEU
      uio: Runtime PM for UIO devices
      sh: let ARCH_SHMOBILE select PM and PM_RUNTIME
      sh: drop static UIO clocks for sh7722, sh7723 and sh7724

Marcin Slusarz (1):
      sh: use printk_once

Matt Fleming (28):
      sh: Use bootmem ontop of lmb
      sh: Use bootmem ontop of lmb for NUMA
      sh: Fix the value of MCOUNT_INSN_OFFSET
      sh: Define HAVE_FUNCTION_TRACE_MCOUNT_TEST
      sh: Add ftrace syscall tracing support
      sh: Provide diagnostic kernel stack checks
      sh: Function graph tracer support
      sh: Mark __switch_to() as __notrace_funcgraph
      sh: Restore previous behaviour on kernel fault
      sh: Use the generalized stacktrace ops
      sh: Allow multiple stack unwinders to be setup
      sh: Use the new stack unwinder API
      sh: dwarf unwinder support.
      sh: Setup the frame register in asm code
      sh: Add CFI annotations for exception return.
      sh: Delete DWARF_ARCH_UNWIND_OFFSET
      sh: Set the cfa_offset to 0 if we see a DW_CFA_def_cfa_register op
      sh: Try again at getting the initial return address for an unwind
      sh: Add support for DWARF GNU extensions
      sh: Add a few missing irqflags tracing markers.
      sh: unwinder: Fix memory leak and create our own kmem cache
      sh: unwinder: Set the flags for DW_CFA_val_offset ops as DWARF_VAL_OFFSET
      sh: unwinder: Introduce UNWINDER_BUG() and UNWINDER_BUG_ON()
      sh: Setup the frame pointer in handle_interrupt
      sh: Fix bug calculating the end of the FDE instructions
      sh: Handle the DWARF op, DW_CFA_undefined
      sh: Only shout about fixing up unexpected unaligned accesses
      sh: Fix dcache flushing for N-way write-through caches.

Michael Trimarchi (1):
      sh: Better description of SH-4 PTEA register update.

Paul Mundt (107):
      sh: use kprobes_built_in() for notify_page_fault().
      sh: Tidy up vmalloc fault handling.
      video: sh_mobile_lcdcfb: depends on HAVE_CLK.
      sh: Decouple mcount from ftrace.
      sh: Replace DEBUG_STACKOVERFLOW with STACK_DEBUG.
      sh: Use DECLARE_EXPORT() for mcount symbol export.
      sh: Fix up ftrace build error when STACK_DEBUG=n.
      sh: Fix up stack overflow check with ftrace disabled.
      sh: Tidy up gzip-based zImage decompression.
      sh: bzip2/lzma zImage support.
      sh: Consolidate the sh64 changes in arch/sh/boot/compressed/misc_32.c
      sh: rename arch/sh/boot/compressed/misc_32.c -> misc.c
      sh64: Don't use PHYSADDR() for output_addr calculation.
      sh: Kill off zero-sized vmlinux_64.lds.S
      sh: bzip2/lzma uImage support.
      sh: Provide _PAGE_SPECIAL for 32-bit.
      sh: Migrate from PG_mapped to PG_dcache_dirty.
      sh: wire up clear_user_highpage() for sh4, convert sh7705.
      sh: Rename arch/sh/lib/clear_page.S -> __clear_user.S.
      sh: Use the now generic SH-4 clear/copy page ops for all MMU platforms.
      sh: update_mmu_cache() consolidation.
      sh: Handle a NULL vma in __update_tlb() for the fast-path.
      Revert "sh: Bump the earlytimer bits back to time_init()."
      sh: Add romImage target to archhelp.
      sh: Fix up early printk build error.
      sh: Add a PG_dcache_dirty sanity check in kmap_coherent().
      sh: Bring kmap_coherent() out-of-line.
      sh: Drop unused arguments for kunmap_coherent().
      sh: Provide __flush_anon_page().
      sh: Tidy up NEFF-based sign extension for SH-5.
      sh64: Kill off special clear_page() implementation.
      sh: Split out SH-4 __flush_xxx_region() ops.
      sh: Partially unroll the SH-4 __flush_xxx_region() flushers.
      sh: unwinder: Fix up usage of unaligned accessors.
      sh: unwinder: Restore put_unaligned() for an unaligned destination.
      sh: oprofile: Kill off dead valid_kernel_stack().
      sh: unwinder: Convert frame allocations to GFP_ATOMIC.
      sh: stacktrace: Add reliability checks in address saving ops.
      sh: flag the default unwinder as reliable.
      sh: stacktrace: Properly terminate the trace entry buffer.
      sh: Add register alignment helpers for shared flushers.
      sh64: Wire up the shared __flush_xxx_region() flushers.
      sh: NO_CONTEXT ASID optimizations for SH-4 cache flush.
      sh: TLB protection violation exception optimizations.
      sh: TLB fast path optimizations for load/store exceptions.
      sh: Make sure rte delay slots are nopped out on all parts.
      sh: delay slot future proofing via EXPMASK on SH-4A parts.
      sh: Bail from kmap_coherent_init() if we have no dcache aliases.
      sh: Provide the kmap_coherent() interface generically.
      sh: rename pg-mmu.c -> cache.c, enable generically.
      sh: rework nommu for generic cache.c use.
      sh: consolidate nommu stubs in arch/sh/mm/nommu.c.
      sh: Track the CPU family in sh_cpuinfo.
      sh: Centralize the CPU cache initialization routines.
      sh: Move alias computation to shared cache init.
      sh: Don't export flush_dcache_all().
      sh: consolidate flush_dcache_mmap_lock/unlock() definitions.
      sh: Kill off unused flush_icache_user_range().
      sh: Migrate SH-4 cacheflush ops to function pointers.
      sh: Convert SH-2 to new cacheflush interface.
      sh: Convert SH-2A to new cacheflush interface.
      sh: Convert SH-3 to new cacheflush interface.
      sh: Convert SH7705 extended mode to new cacheflush interface.
      sh: Kill off the unhandled pvr case in SH-4 CPU probing.
      sh: Convert cache disabled SH-5 over to new cache interface.
      sh64: Build in support for generic stacktrace ops.
      sh: Fix up the SH-5 build with caches enabled.
      sh64: Kill off dead i/d-cache disabled bits.
      sh: Wire up sh5_cache_init().
      sh: Merge the _32/_64 variants of arch/sh/kernel/Makefile.
      sh: Merge the _32/_64 variants of arch/sh/mm/Makefile.
      sh: unwinder: Move initialization to early_initcall() and tidy up locking.
      sh: Build fix for disabled caches.
      sh: Fix up clockevents broadcasting.
      sh: Add mach-types entry for EcoVec board.
      sh: Fix up the CONFIG_FTRACE_SYSCALLS=n build.
      sh: DSP save/restore ordering and a0 sign extension fixups.
      rtc: rtc-ds1302: Kill off unused variables.
      sh: enable rtc-ds1302 in snapgear_defconfig.
      sh: Fix up cache-sh4 build on SMP.
      sh: Use local TLB flush for get_mmu_context() ASID exhaustion.
      sh: Kill off unused cpu/cacheflush.h.
      sh: Make cache flushers SMP-aware.
      sh: Kill off now redundant local irq disabling.
      sh: Export unwind_stack() to satisfy modular oprofile.
      sh: unwinder: Use a special bug flag for unwinder traps.
      sh64: dummy unwinder BUG wrappers.
      sh: unwinder: cacheline align slab cache objects.
      sh: Fix section mismatch in platform bus notifier.
      usb: gadget: m66592-udc needs linux/err.h.
      sh: Move the FTRACE_SYSCALL_MAX definition in to asm/ftrace.h.
      sh: Fix an off-by-1 in FTRACE_SYSCALL_MAX.
      sh: Fix up sh4_flush_dcache_page() build on UP.
      sh: Tidy up watchdog build for SH-2.
      sh: unwinder: Fix up uninitialized variable warnings on sh2a build.
      sh: Fix up simplified multi-evt handling under sparseirq.
      sh: nmi_debug support.
      sh: Kill off kgdb's magical NMI debouncing.
      Revert "sh: Kill off now redundant local irq disabling."
      sh: Fix up UP deadlock with SMP-aware cache ops.
      sh: disable trapped I/O on SH7785LCR.
      sh: Fix up build warning for SH7785LCR proto board.
      sh: Fix up and optimize the kmap_coherent() interface.
      sh: Use more aggressive dcache purging in kmap teardown.
      sh: Kill off dcache writeback from copy_page().
      rtc: rtc-sh: Fix up oops in early periodic freq assignment.
      sh: Cleanup whitespace damage in sh4_flush_icache_range().

Pawel Moll (2):
      sh: Allow for kernel command line concatenation.
      sh: Simplify "multi-evt" interrupt handling.

Rafael Ignacio Zurita (2):
      sh: Add early printk support for SH770x CPUs.
      sh: clkfwk: remove bogus set_bus_parent() from SH7709.

Stuart Menefy (11):
      sh: Rework irqflags tracing to fix up CONFIG_PROVE_LOCKING.
      sh: Remove implicit sign extension from assembler immediates
      sh: Read from CCN_PVR instead of ROM for delay.
      sh: generic_in/outs{bwl} optimizations.
      sh: Optimise memcpy_to/fromio for SH4
      sh: Improve comments int SH4 cache flushing code
      sh: Add sys_cacheflush() call for SH CPUs.
      sh: Fix underflow in SH udelay() code.
      sh: Fixes some write posting issues in the interrupt handling for SH
      sh: Fix overzealous checking in __ioremap()
      sh: Fix problems with cache flushing when cache is in write-through mode

Tim Abbott (2):
      sh: Clean up linker script using new linker script macros.
      sh: Clean up linker script using new BSS_SECTION macro.

Yoshihiro Shimoda (5):
      usb: fix hibernate in r8a66597-hcd dev_pm_ops conversion.
      usb: gadget: R8A66597 peripheral controller support.
      usb: r8a66597-udc: implement the set_wedge method
      sh: Add initial support for SH7757 CPU subtype
      sh: sh7785lcr: fix prototype board on 32bit MMU mode.

Yusuke Goda (1):
      sh: Fix the indication point of the liquid crystal of AP-325RXA(AP3300)

 Documentation/kernel-parameters.txt                |    2 +-
 arch/sh/Kconfig                                    |   43 +-
 arch/sh/Kconfig.debug                              |   23 +-
 arch/sh/Makefile                                   |   26 +-
 arch/sh/boards/Kconfig                             |   22 +-
 arch/sh/boards/board-ap325rxa.c                    |    8 +-
 arch/sh/boards/board-sh7785lcr.c                   |   18 +
 arch/sh/boards/mach-ecovec24/Makefile              |    9 +
 arch/sh/boards/mach-ecovec24/setup.c               |  606 ++++++
 arch/sh/boards/mach-highlander/setup.c             |    7 +
 arch/sh/boards/mach-kfr2r09/Makefile               |    2 +
 arch/sh/boards/mach-kfr2r09/lcd_wqvga.c            |  332 ++++
 arch/sh/boards/mach-kfr2r09/setup.c                |  386 ++++
 arch/sh/boards/mach-migor/setup.c                  |    9 +
 arch/sh/boards/mach-se/7722/setup.c                |    4 +
 arch/sh/boards/mach-se/7724/setup.c                |  108 +-
 arch/sh/boards/mach-x3proto/setup.c                |    7 +
 arch/sh/boot/.gitignore                            |    5 +-
 arch/sh/boot/Makefile                              |   48 +-
 arch/sh/boot/compressed/.gitignore                 |    1 +
 arch/sh/boot/compressed/Makefile                   |   21 +-
 arch/sh/boot/compressed/head_32.S                  |    2 +-
 arch/sh/boot/compressed/misc.c                     |  149 ++
 arch/sh/boot/compressed/misc_32.c                  |  206 --
 arch/sh/boot/compressed/misc_64.c                  |  210 --
 arch/sh/boot/compressed/piggy.S                    |    8 -
 arch/sh/boot/compressed/vmlinux.scr                |   10 +
 arch/sh/boot/romimage/Makefile                     |   19 +
 arch/sh/boot/romimage/head.S                       |   10 +
 arch/sh/boot/romimage/vmlinux.scr                  |    6 +
 arch/sh/configs/ecovec24-romimage_defconfig        | 1032 ++++++++++
 arch/sh/configs/ecovec24_defconfig                 | 1558 +++++++++++++++
 arch/sh/configs/kfr2r09-romimage_defconfig         |  774 ++++++++
 arch/sh/configs/kfr2r09_defconfig                  | 1059 ++++++++++
 arch/sh/configs/snapgear_defconfig                 |   77 +-
 arch/sh/drivers/dma/Kconfig                        |    6 +-
 arch/sh/drivers/heartbeat.c                        |   10 +
 arch/sh/drivers/pci/pci.c                          |    4 +
 arch/sh/include/asm/Kbuild                         |    2 +-
 arch/sh/include/asm/bug.h                          |   31 +
 arch/sh/include/asm/bugs.h                         |   24 +-
 arch/sh/include/asm/cachectl.h                     |   19 +
 arch/sh/include/asm/cacheflush.h                   |  114 +-
 arch/sh/include/asm/device.h                       |   16 +-
 arch/sh/include/asm/dma-sh.h                       |    1 +
 arch/sh/include/asm/dwarf.h                        |  398 ++++
 arch/sh/include/asm/entry-macros.S                 |   86 +-
 arch/sh/include/asm/ftrace.h                       |    8 +-
 arch/sh/include/asm/hardirq.h                      |   13 +-
 arch/sh/include/asm/heartbeat.h                    |    1 +
 arch/sh/include/asm/hwblk.h                        |   72 +
 arch/sh/include/asm/io.h                           |   16 +-
 arch/sh/include/asm/kdebug.h                       |    1 +
 arch/sh/include/asm/kgdb.h                         |    3 -
 arch/sh/include/asm/lmb.h                          |    6 +
 arch/sh/include/asm/mmu_context.h                  |    2 +-
 arch/sh/include/asm/page.h                         |   24 +-
 arch/sh/include/asm/pgtable.h                      |   34 +-
 arch/sh/include/asm/pgtable_32.h                   |   30 +-
 arch/sh/include/asm/pgtable_64.h                   |    5 +
 arch/sh/include/asm/processor.h                    |   15 +-
 arch/sh/include/asm/romimage-macros.h              |   73 +
 arch/sh/include/asm/sections.h                     |    1 +
 arch/sh/include/asm/stacktrace.h                   |   25 +
 arch/sh/include/asm/suspend.h                      |    9 +
 arch/sh/include/asm/syscall_32.h                   |    1 +
 arch/sh/include/asm/system.h                       |   19 +-
 arch/sh/include/asm/system_32.h                    |   43 +-
 arch/sh/include/asm/system_64.h                    |   10 +
 arch/sh/include/asm/thread_info.h                  |   11 +-
 arch/sh/include/asm/types.h                        |    2 +
 arch/sh/include/asm/unistd_32.h                    |    2 +-
 arch/sh/include/asm/unistd_64.h                    |    2 +-
 arch/sh/include/asm/unwinder.h                     |   31 +
 arch/sh/include/asm/vmlinux.lds.h                  |   17 +
 arch/sh/include/asm/watchdog.h                     |   19 +-
 arch/sh/include/cpu-common/cpu/cacheflush.h        |   44 -
 arch/sh/include/cpu-sh2a/cpu/cacheflush.h          |   34 -
 arch/sh/include/cpu-sh3/cpu/cacheflush.h           |   46 -
 arch/sh/include/cpu-sh4/cpu/cacheflush.h           |   43 -
 arch/sh/include/cpu-sh4/cpu/dma-sh4a.h             |    3 +-
 arch/sh/include/cpu-sh4/cpu/freq.h                 |    4 +
 arch/sh/include/cpu-sh4/cpu/sh7722.h               |   14 +
 arch/sh/include/cpu-sh4/cpu/sh7723.h               |   17 +
 arch/sh/include/cpu-sh4/cpu/sh7724.h               |   17 +
 arch/sh/include/cpu-sh4/cpu/sh7757.h               |  243 +++
 arch/sh/include/cpu-sh5/cpu/cacheflush.h           |   33 -
 arch/sh/include/mach-common/mach/migor.h           |   64 -
 arch/sh/include/mach-common/mach/romimage.h        |    1 +
 arch/sh/include/mach-common/mach/sh7785lcr.h       |    2 +
 .../mach-ecovec24/mach/partner-jet-setup.txt       |   82 +
 arch/sh/include/mach-ecovec24/mach/romimage.h      |   20 +
 arch/sh/include/mach-kfr2r09/mach/kfr2r09.h        |   21 +
 .../mach-kfr2r09/mach/partner-jet-setup.txt        |  141 ++
 arch/sh/include/mach-kfr2r09/mach/romimage.h       |   20 +
 arch/sh/include/mach-migor/mach/migor.h            |   14 +
 arch/sh/kernel/Makefile                            |   44 +-
 arch/sh/kernel/Makefile_32                         |   37 -
 arch/sh/kernel/Makefile_64                         |   19 -
 arch/sh/kernel/asm-offsets.c                       |    1 +
 arch/sh/kernel/cpu/Makefile                        |    2 +-
 arch/sh/kernel/cpu/hwblk.c                         |  155 ++
 arch/sh/kernel/cpu/init.c                          |   36 +-
 arch/sh/kernel/cpu/irq/ipr.c                       |    1 +
 arch/sh/kernel/cpu/sh2/entry.S                     |    3 +-
 arch/sh/kernel/cpu/sh2/probe.c                     |    1 +
 arch/sh/kernel/cpu/sh2a/entry.S                    |    3 +-
 arch/sh/kernel/cpu/sh2a/probe.c                    |    2 +
 arch/sh/kernel/cpu/sh3/clock-sh7709.c              |   11 -
 arch/sh/kernel/cpu/sh3/entry.S                     |  102 +-
 arch/sh/kernel/cpu/sh3/ex.S                        |    4 +-
 arch/sh/kernel/cpu/sh3/probe.c                     |    2 +
 arch/sh/kernel/cpu/sh4/probe.c                     |   21 +-
 arch/sh/kernel/cpu/sh4a/Makefile                   |    9 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c             |   63 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7723.c             |  113 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c             |  124 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7757.c             |  130 ++
 arch/sh/kernel/cpu/sh4a/hwblk-sh7722.c             |  106 +
 arch/sh/kernel/cpu/sh4a/hwblk-sh7723.c             |  117 ++
 arch/sh/kernel/cpu/sh4a/hwblk-sh7724.c             |  121 ++
 arch/sh/kernel/cpu/sh4a/pinmux-sh7757.c            | 2019 ++++++++++++++++++++
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c             |    2 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c             |   39 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c             |   42 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c             |   43 +
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c             |  513 +++++
 arch/sh/kernel/cpu/sh4a/smp-shx3.c                 |    2 +
 arch/sh/kernel/cpu/sh5/probe.c                     |    2 +
 arch/sh/kernel/cpu/shmobile/Makefile               |    2 +
 arch/sh/kernel/cpu/shmobile/cpuidle.c              |  113 ++
 arch/sh/kernel/cpu/shmobile/pm.c                   |   42 +-
 arch/sh/kernel/cpu/shmobile/pm_runtime.c           |  303 +++
 arch/sh/kernel/cpu/shmobile/sleep.S                |  155 +-
 arch/sh/kernel/dumpstack.c                         |  123 ++
 arch/sh/kernel/dwarf.c                             |  972 ++++++++++
 arch/sh/kernel/early_printk.c                      |    5 +-
 arch/sh/kernel/entry-common.S                      |  103 +-
 arch/sh/kernel/ftrace.c                            |  188 ++
 arch/sh/kernel/io.c                                |   97 +-
 arch/sh/kernel/io_generic.c                        |   50 +-
 arch/sh/kernel/io_trapped.c                        |   10 +-
 arch/sh/kernel/irq.c                               |   19 +-
 arch/sh/kernel/kgdb.c                              |    4 -
 arch/sh/kernel/localtimer.c                        |    9 +-
 arch/sh/kernel/nmi_debug.c                         |   77 +
 arch/sh/kernel/process_32.c                        |   25 +-
 arch/sh/kernel/process_64.c                        |   24 +-
 arch/sh/kernel/ptrace_32.c                         |   12 +
 arch/sh/kernel/setup.c                             |   80 +-
 arch/sh/kernel/sh_ksyms_32.c                       |   10 +-
 arch/sh/kernel/sh_ksyms_64.c                       |    9 -
 arch/sh/kernel/signal_32.c                         |   12 +-
 arch/sh/kernel/signal_64.c                         |   38 +-
 arch/sh/kernel/stacktrace.c                        |   98 +-
 arch/sh/kernel/sys_sh.c                            |   43 +
 arch/sh/kernel/syscalls_32.S                       |    2 +-
 arch/sh/kernel/syscalls_64.S                       |    2 +-
 arch/sh/kernel/time.c                              |   31 +-
 arch/sh/kernel/traps.c                             |   45 +-
 arch/sh/kernel/traps_32.c                          |  220 ++-
 arch/sh/kernel/unwinder.c                          |  164 ++
 arch/sh/kernel/vmlinux.lds.S                       |   90 +-
 arch/sh/lib/Makefile                               |    4 +-
 arch/sh/lib/{clear_page.S => __clear_user.S}       |   48 +-
 arch/sh/lib/copy_page.S                            |   11 +-
 arch/sh/lib/delay.c                                |    5 +-
 arch/sh/lib/mcount.S                               |  228 +++-
 arch/sh/lib64/Makefile                             |    2 +-
 arch/sh/lib64/clear_page.S                         |   54 -
 arch/sh/mm/Kconfig                                 |    7 +-
 arch/sh/mm/Makefile                                |   68 +-
 arch/sh/mm/Makefile_32                             |   43 -
 arch/sh/mm/Makefile_64                             |   46 -
 arch/sh/mm/cache-sh2.c                             |   13 +-
 arch/sh/mm/cache-sh2a.c                            |   23 +-
 arch/sh/mm/cache-sh3.c                             |   25 +-
 arch/sh/mm/cache-sh4.c                             |  362 ++--
 arch/sh/mm/cache-sh5.c                             |  307 +---
 arch/sh/mm/cache-sh7705.c                          |   71 +-
 arch/sh/mm/cache.c                                 |  316 +++
 arch/sh/mm/fault_32.c                              |  196 ++-
 arch/sh/mm/fault_64.c                              |   11 +-
 arch/sh/mm/flush-sh4.c                             |  108 ++
 arch/sh/mm/init.c                                  |   50 +-
 arch/sh/mm/ioremap_32.c                            |    8 -
 arch/sh/mm/ioremap_64.c                            |    6 +-
 arch/sh/mm/kmap.c                                  |   65 +
 arch/sh/mm/mmap.c                                  |    2 +-
 arch/sh/mm/nommu.c                                 |   96 +
 arch/sh/mm/numa.c                                  |   36 +-
 arch/sh/mm/pg-nommu.c                              |   38 -
 arch/sh/mm/pg-sh4.c                                |  146 --
 arch/sh/mm/pg-sh7705.c                             |  138 --
 arch/sh/mm/tlb-nommu.c                             |   62 -
 arch/sh/mm/tlb-pteaex.c                            |   28 +-
 arch/sh/mm/tlb-sh3.c                               |   27 +-
 arch/sh/mm/tlb-sh4.c                               |   37 +-
 arch/sh/mm/tlb-sh5.c                               |   21 +-
 arch/sh/mm/tlbflush_64.c                           |   22 +-
 arch/sh/oprofile/backtrace.c                       |   84 +-
 arch/sh/tools/mach-types                           |    3 +
 drivers/block/aoe/aoe.h                            |    2 +-
 drivers/block/aoe/aoeblk.c                         |   12 +-
 drivers/block/aoe/aoedev.c                         |    1 -
 drivers/gpu/drm/i915/i915_gem.c                    |    6 +-
 drivers/gpu/drm/i915/intel_dp.c                    |    2 +-
 drivers/gpu/drm/i915/intel_drv.h                   |    1 -
 drivers/gpu/drm/i915/intel_tv.c                    |    1 -
 drivers/i2c/busses/i2c-sh_mobile.c                 |   39 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |   41 +-
 drivers/rtc/rtc-ds1302.c                           |   69 +-
 drivers/rtc/rtc-sh.c                               |   97 +-
 drivers/serial/sh-sci.c                            |    8 +-
 drivers/serial/sh-sci.h                            |   17 +
 drivers/sh/intc.c                                  |   71 +-
 drivers/uio/uio_pdrv_genirq.c                      |   54 +
 drivers/usb/gadget/Kconfig                         |   28 +-
 drivers/usb/gadget/Makefile                        |    1 +
 drivers/usb/gadget/gadget_chips.h                  |    8 +
 drivers/usb/gadget/m66592-udc.c                    |  286 ++--
 drivers/usb/gadget/m66592-udc.h                    |   90 +-
 drivers/usb/gadget/r8a66597-udc.c                  | 1689 ++++++++++++++++
 drivers/usb/gadget/r8a66597-udc.h                  |  256 +++
 drivers/usb/host/Kconfig                           |    7 -
 drivers/usb/host/r8a66597-hcd.c                    |  210 ++-
 drivers/usb/host/r8a66597.h                        |  442 +----
 drivers/video/Kconfig                              |    2 +-
 drivers/video/sh_mobile_lcdcfb.c                   |  175 ++-
 include/linux/sh_intc.h                            |    1 -
 include/linux/usb/m66592.h                         |   44 +
 include/linux/usb/r8a66597.h                       |  375 ++++-
 232 files changed, 18793 insertions(+), 4001 deletions(-)
 create mode 100644 arch/sh/boards/mach-ecovec24/Makefile
 create mode 100644 arch/sh/boards/mach-ecovec24/setup.c
 create mode 100644 arch/sh/boards/mach-kfr2r09/Makefile
 create mode 100644 arch/sh/boards/mach-kfr2r09/lcd_wqvga.c
 create mode 100644 arch/sh/boards/mach-kfr2r09/setup.c
 create mode 100644 arch/sh/boot/compressed/.gitignore
 create mode 100644 arch/sh/boot/compressed/misc.c
 delete mode 100644 arch/sh/boot/compressed/misc_32.c
 delete mode 100644 arch/sh/boot/compressed/misc_64.c
 delete mode 100644 arch/sh/boot/compressed/piggy.S
 create mode 100644 arch/sh/boot/compressed/vmlinux.scr
 create mode 100644 arch/sh/boot/romimage/Makefile
 create mode 100644 arch/sh/boot/romimage/head.S
 create mode 100644 arch/sh/boot/romimage/vmlinux.scr
 create mode 100644 arch/sh/configs/ecovec24-romimage_defconfig
 create mode 100644 arch/sh/configs/ecovec24_defconfig
 create mode 100644 arch/sh/configs/kfr2r09-romimage_defconfig
 create mode 100644 arch/sh/configs/kfr2r09_defconfig
 create mode 100644 arch/sh/include/asm/cachectl.h
 create mode 100644 arch/sh/include/asm/dwarf.h
 create mode 100644 arch/sh/include/asm/hwblk.h
 create mode 100644 arch/sh/include/asm/lmb.h
 create mode 100644 arch/sh/include/asm/romimage-macros.h
 create mode 100644 arch/sh/include/asm/stacktrace.h
 create mode 100644 arch/sh/include/asm/unwinder.h
 create mode 100644 arch/sh/include/asm/vmlinux.lds.h
 delete mode 100644 arch/sh/include/cpu-common/cpu/cacheflush.h
 delete mode 100644 arch/sh/include/cpu-sh2a/cpu/cacheflush.h
 delete mode 100644 arch/sh/include/cpu-sh3/cpu/cacheflush.h
 delete mode 100644 arch/sh/include/cpu-sh4/cpu/cacheflush.h
 create mode 100644 arch/sh/include/cpu-sh4/cpu/sh7757.h
 delete mode 100644 arch/sh/include/cpu-sh5/cpu/cacheflush.h
 delete mode 100644 arch/sh/include/mach-common/mach/migor.h
 create mode 100644 arch/sh/include/mach-common/mach/romimage.h
 create mode 100644 arch/sh/include/mach-ecovec24/mach/partner-jet-setup.txt
 create mode 100644 arch/sh/include/mach-ecovec24/mach/romimage.h
 create mode 100644 arch/sh/include/mach-kfr2r09/mach/kfr2r09.h
 create mode 100644 arch/sh/include/mach-kfr2r09/mach/partner-jet-setup.txt
 create mode 100644 arch/sh/include/mach-kfr2r09/mach/romimage.h
 create mode 100644 arch/sh/include/mach-migor/mach/migor.h
 delete mode 100644 arch/sh/kernel/Makefile_32
 delete mode 100644 arch/sh/kernel/Makefile_64
 create mode 100644 arch/sh/kernel/cpu/hwblk.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/clock-sh7757.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/hwblk-sh7722.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/hwblk-sh7723.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/hwblk-sh7724.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/pinmux-sh7757.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/setup-sh7757.c
 create mode 100644 arch/sh/kernel/cpu/shmobile/cpuidle.c
 create mode 100644 arch/sh/kernel/cpu/shmobile/pm_runtime.c
 create mode 100644 arch/sh/kernel/dumpstack.c
 create mode 100644 arch/sh/kernel/dwarf.c
 create mode 100644 arch/sh/kernel/nmi_debug.c
 create mode 100644 arch/sh/kernel/unwinder.c
 rename arch/sh/lib/{clear_page.S => __clear_user.S} (75%)
 delete mode 100644 arch/sh/lib64/clear_page.S
 delete mode 100644 arch/sh/mm/Makefile_32
 delete mode 100644 arch/sh/mm/Makefile_64
 create mode 100644 arch/sh/mm/cache.c
 create mode 100644 arch/sh/mm/flush-sh4.c
 create mode 100644 arch/sh/mm/kmap.c
 create mode 100644 arch/sh/mm/nommu.c
 delete mode 100644 arch/sh/mm/pg-nommu.c
 delete mode 100644 arch/sh/mm/pg-sh4.c
 delete mode 100644 arch/sh/mm/pg-sh7705.c
 delete mode 100644 arch/sh/mm/tlb-nommu.c
 create mode 100644 drivers/usb/gadget/r8a66597-udc.c
 create mode 100644 drivers/usb/gadget/r8a66597-udc.h
 create mode 100644 include/linux/usb/m66592.h
