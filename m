Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbYAPHEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbYAPHEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 02:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYAPHEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 02:04:37 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:54013 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752076AbYAPHEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 02:04:34 -0500
Date: Wed, 16 Jan 2008 16:04:03 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: What's in sh-2.6.git for 2.6.25?
Message-ID: <20080116070403.GA14107@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a brief summary of the changes that are sitting in the sh queue
for 2.6.25.

The main points to note are as follows:

	- sh64->sh integration.
	- A handful of new CPUs (SH7721, SH7763, SH7203, SH7263).
	- SH-2A FPU support.
	- Board support updates (R2D, R7785RP).

The sh64->sh integration is basically the only thing that's really
interesting, and so it's worth summarizing that a bit.

The sh64 and sh ports had both areas of considerable divergence, and
areas of considerable overlap. In the past consolidation has not been
possible since there was no clean way to abstract the differences with
a common implementation (the obvious case is that the SH-5 and the other
parts use a totally different instruction and register set). With the
work in the nommu area, we've already had to abstract most of the
exception handling code, disjoint syscall ABIs, incompatible instruction
sets, and so on. As a result of that work, the SH-5 integration was
finally at a point where it could be done with minimal pain. The fact
that the sh64 port itself was bitrotting was also a motivator for just
getting the integration done and over with.

There is still more work to do on unifying the _32/_64 splits, especially
as we have to start supporting new CPUs that sit somewhere between the
SH-4A and the SH-5 architecturally. The integration work is an ongoing
effort, and there will likely still be a bit of churn in this area
throughout 2.6.25 and in to 2.6.26.

These changes have basically been in -mm for a few iterations, and so
nothing here should be much of a surprise. We do manage to kill off quite
a bit of code in the process, and this is obviously a number that will go
up considerably as more _32/_64 split unification is done going in to
2.6.25 proper. Most of this is just a reorganization of existing in-tree
code, so there's very little in the way of new code or surprises here.

The tree in question can be found at:

	git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Andrew Murray (2):
      sh: sh7712 clock support
      sh: Update SE7712 PCLK definition.

Harvey Harrison (1):
      sh: Use def_bool where possible.

Joe Perches (2):
      sh: arch/sh/: Spelling fixes.
      sh: include/asm-sh/: Spelling fixes.

Magnus Damm (4):
      sh: intc - remove default interrupt priority tables
      sh: r2d - add lcd planel timings to sm501 platform data
      sh: remove voyagergx
      sh: r2d - enable sm501 usb host function

Nobuhiro Iwamatsu (1):
      sh: Fix compile error of arch/sh/mm/pmb.c

Paul Mundt (160):
      rtc: rtc-sh: SH-5 support.
      sh64: Use the generic rtc-sh driver.
      sh: Rename Kconfig to Kconfig.sh.
      sh: Move CPU subtypes to Kconfig.sh.
      sh: Add a SUPERH32 config symbol.
      sh: Split out PXSEG segmentation per-CPU family.
      sh: Split out cache status bits per-CPU family.
      sh: Move the sh64 Kconfig to arch/sh/Kconfig.sh64.
      sh: Move arch/sh64/lib to arch/sh/lib64.
      sh: Plug SH-5 in to arch/sh/Makefile.
      sh: Switch Kconfig.sh64 to use arch/sh/mm/Kconfig.
      sh: Add SH-5 support to asm/module.h.
      sh: Fix up fixmap location for SH-5.
      sh: BUGFLAG_WARNING needs GENERIC_BUG.
      sh: Add addrspace.h segmentation stub for SH-5.
      sh: Add cache definitions for SH-5.
      sh: Correct SH-5 instruction size value.
      sh: Move sh64 boards to arch/sh/.
      sh: Move sh64 board defconfigs to arch/sh/configs.
      sh64: Kill off arch/sh64/oprofile.
      sh: Add in cacheflush and DMA headers for SH-5.
      sh: Add SH-5 support to io.h.
      sh: Split out asm/string.h for sh32 and sh64.
      sh: Split out irqflags.h in to _32 and _64 variants.
      sh: SH-5 version of current_thread_info().
      sh: Consolidate CPU features in Kconfig.cpu.
      sh: SH-5 byteorder routines.
      sh: Move sh32 optimized I/O routines to arch/sh/lib/
      sh: Kill off lib64 version of io.c.
      sh: Move in the SH-5 mmu_context headers.
      sh: Have 32-bit use arch/sh/kernel/Makefile_32.
      sh: Split out arch/sh/kernel/process.c for _32 and _64 variants.
      sh: SH-5 pt_regs.
      sh: Split out processor.h in to _32 and _64 variants.
      sh: Split out 29-bit and 32-bit physical mode definitions.
      sh: Split out system.h in to _32 and _64 variants.
      sh: Move in the SH-5 ptrace impl.
      sh: SH-5 also uses the ASID cache.
      sh: Split out uaccess.h in to _32 and _64 variants.
      sh: Consolidate slab/kmalloc minalign values.
      sh: More SH-5 cpuinfo tidying.
      sh: Move in the SH-5 signal trampoline impl.
      sh: Move arch/sh64/kernel/sys_sh64.c to arch/sh/kernel/
      sh: timer.h stub for SH-5.
      sh: Move in the SH-5 traps.c impl.
      sh: imask IRQ depends on sh32.
      sh: Don't reference UBC code in CPU init on sh64.
      sh: Disable initial cache flush on SH-5.
      sh: Have SH-5 provide an {en,dis}able_fpu() impl.
      sh: Move over the SH-5 head.S and tlb.h.
      sh: Fix up VMALLOC_START for SH-5.
      sh: Nopped out p3_cache_init() on SH-5 also.
      sh: Move vsyscall_init() defs up one level.
      sh: flush_cache_sigtramp() takes 1 arg only.
      sh: Add SH-5 support to the consistent DMA impl.
      sh: Split out extable.c _32 and _64 variants.
      sh: Fix up 64kB page size selection on SH-5.
      sh: Plug in SH-5 ffz()/__ffs() bitops.
      sh: Split out checksum.h in to _32 and _64 variants.
      sh: Kill off lib64 version of iomap wrappers.
      sh: Fix up header reference for arch/sh/lib64/panic.c.
      sh: Fix up the head-y targets for _32 and _64.
      sh: Split out syscall ABI for _32 and _64 variants.
      sh: Split out linker script to _32 and _64 variants.
      sh: Move over the SH-5 entry.S.
      sh: Split out sh_ksyms.c in to _32 and _64 variants.
      sh: Split out ioremap in to _32 and _64 variants.
      sh: ioremap_64 needs proc_fs.h.
      sh: Split out pgtable.h in to _32 and _64 variants.
      sh: Split out tlb-flush in to _32 and _64 variants.
      sh: Move over sh64 switch_to and stack unwinder.
      sh: Provide dummy swapper pt_regs for SH-5 ctx switch.
      sh: Common swapper_pg_dir usage for SH-5.
      sh: Move over and enable FPU support for SH-5.
      sh: Tidy up lib64 udelay impl.
      sh: Plug in the SHmedia ELF relocations.
      sh: ioremap_64 needs after_bootmem.
      sh: Merge sh and sh64 module.c.
      sh: Sync up the _64 linker script with the _32 version.
      sh: Fix up the _stext references for SH-5.
      sh: Kill off SH-5 enter_deep_standby() cruft.
      sh: Share the ELF dump_task interfaces.
      sh: sys_sh consolidation for arch_get_unmapped_area().
      sh: Tidy up various clear_page()/copy_page() definitions.
      sh: Move in the SH-5 TLB miss.
      sh: Share bug/debug traps across _32 and _64.
      sh: Move quad-word real-address I/O defs to io.h.
      sh: Kill off do_NMI stub in SH-5 ex table.
      sh: Plug in simple SH-5 subtype probing.
      sh: Add the SH-5 cpu type symbolic names.
      sh: Stub in CPU subtype setup code for SH5-101/103.
      sh: Stubs for fpu disabled on SH-5.
      sh: Update cayman defconfig.
      sh: Set HPAGE_SHIFT for 512MB hugetlb pages.
      sh: Move PXSEG comments to addrspace.h.
      sh: Switch SH-5 to use CONFIG_PAGE_OFFSET.
      sh: Kill off some dead sh64 kconfig symbols.
      sh: Bump the MEMORY_SIZE default to something reasonable.
      sh: Consolidate Kconfig.sh/Kconfig.sh64.
      sh: Fix up generic BUG build for SH-5.
      sh: Use existing CONFIG_CACHE_xx options in head_64.S.
      sh: SH-5 uses a 64-bit PTE_MAGNITUDE, as X2 TLB.
      sh: Merge the sh64 zImage bits.
      sh: Kill off a stray proc tlb reference in fault_64.
      sh: Merge sh64 Kconfig.debug options.
      sh: Move over SH-5 TLB and cache support code.
      sh: Fix up proc ASIDs for CPU-local ASID cache accessors.
      sh: Kill off arch/sh64/mm.
      sh: Purge dead sh64 headers.
      sh: Special layout for SH-5 stat.h and user.h.
      sh: Mark some IRQ debug options sh32 only.
      sh: Fix up user_fpu_struct typo for SH-5.
      sh: Copy over special CFLAGS for SH-5 TLB miss.
      sh: Add onchip remap prototypes, kill old sh64 io.h.
      sh: Generic BUG only works for sh32.
      sh: Remove duplicate SUPERH64 symbol.
      sh: Tidy up KBUILD_IMAGE for sh64.
      sh: Consolidate sh/sh64 Makefiles.
      sh: Rename the _32 and _64 TLB flush variants.
      sh: clear/copy_page renames in lib and lib64.
      sh: Kill off the last of the sh64 headers.
      sh: Get the mach-cayman IRQ support building.
      sh: Kill off the rest of arch/sh64/kernel/.
      sh: Add SH-5 subtypes to check_bugs() for utsname.
      sh: Bump number of quicklists for SH-5.
      sh: Get the SH-5 PCI support building.
      sh: Bring the SH-5 FPU in line with the SH-4 FPU API.
      sh: Fix up default zImage target for sh32.
      sh: Build fixes for lib32 clear_page.
      sh: Fix up bug trap handler build for sh32.
      sh: Kill off the mach-harp and mach-sim machtypes.
      sh: Move mach-cayman in with the rest of the boards.
      sh: Fix up uname -m matching for native sh64.
      rtc: rtc-sh: SH-2A support.
      sh: Add SH7203 CPU support.
      sh: Fix the arch/sh/kernel/traps.c build for sh32.
      sh: Add SH7263 CPU support.
      sh: SH-2A FPU support.
      sh: Bump up ARCH_KMALLOC_MINALIGN for DMA cases.
      sh: CCR1->CCR renaming for SH-2 parts.
      rtc: rtc-sh: Split out the CPU defs to asm/cpu/.
      sh: syscall auditing for sh5, too.
      sh: comment tidying for sh64->sh migration.
      sh: Explicit alignment for PAGE_SIZE in copy/clear_page().
      sh: Encode L1/L2 cache shape in auxvt.
      sh: Use utsname()->machine for ELF_PLATFORM.
      sh: Provide the FPSCR init through AT_FPUCW.
      sh: Kill off superfluous __KERNEL__ check in asm/elf.h.
      sh: Stub in page_table_range_init() on nommu.
      sh: Fix up switch_to() type casts.
      sh: Kill off pgtable.h from scatterlist.h.
      sh: Fix up binfmt_flat compile warnings.
      sh: Fix up KERNEL_ENTRY calculation for uImage.
      sh: Always use CONFIG_HZ for HZ.
      sh: Provide a stubbed __set_fixmap() for nommu.
      sh: Fix get_user()/put_user() build error.
      sh: Fix posix_types.h userspace breakage from sh64 merge.
      sh: Correct pte size mismatch for X2 TLB.
      sh: r7785rp: Hook up the rest of the HL7785 FPGA IRQ vectors.
      sh: r7785rp: Fix up DECLARE_INTC_DESC() arg mismatch.

Stuart Menefy (10):
      sh: Add a printk() to warn legacy mem= growers.
      sh: Provide a 29/32-bit physical hint for bootloaders.
      sh: Invalidate the TLB after applying PMB mappings.
      sh: GUSA atomic rollback support.
      sh: Preparation for uncached jumps through PMB.
      sh: Clean up places that make 29-bit physical assumptions.
      sh: Populate swapper_pg_dir with fixmap range.
      sh: Document PTEL 31:29 use on PTEA-wielding parts.
      sh: get_user fixes and nommu consolidation.
      sh: Support denormalization on SH-4 FPU.

Thomas Betker (1):
      sh: Fix up uImage target entry point.

Yoshihiro Shimoda (3):
      sh: Add support for SH7721 CPU subtype.
      sh: Add support for SH7763 CPU subtype.
      sh: Add OHCI and UDC platform devices for SH7720.

Yuichi Nakamura (1):
      sh: syscall audit support.

 Makefile                                     |    2 +-
 arch/sh/Kconfig                              |  349 +++--
 arch/sh/Kconfig.cpu                          |  115 ++
 arch/sh/Kconfig.debug                        |   51 +-
 arch/sh/Makefile                             |   99 +-
 arch/sh/boards/cayman/Makefile               |    5 +
 arch/sh/boards/cayman/irq.c                  |  197 +++
 arch/sh/boards/cayman/led.c                  |   51 +
 arch/sh/boards/cayman/setup.c                |  187 +++
 arch/sh/boards/dreamcast/irq.c               |    2 +-
 arch/sh/boards/renesas/r7780rp/irq-r7780mp.c |    2 +-
 arch/sh/boards/renesas/r7780rp/irq-r7785rp.c |   45 +-
 arch/sh/boards/renesas/rts7751r2d/irq.c      |    8 +-
 arch/sh/boards/renesas/rts7751r2d/setup.c    |  119 +-
 arch/sh/boot/Makefile                        |   18 +-
 arch/sh/boot/compressed/Makefile             |   46 +-
 arch/sh/boot/compressed/Makefile_32          |   43 +
 arch/sh/boot/compressed/Makefile_64          |   45 +
 arch/sh/boot/compressed/cache.c              |   12 +
 arch/sh/boot/compressed/head.S               |  120 --
 arch/sh/boot/compressed/head_32.S            |  120 ++
 arch/sh/boot/compressed/head_64.S            |  163 ++
 arch/sh/boot/compressed/misc.c               |  241 ---
 arch/sh/boot/compressed/misc_32.c            |  244 +++
 arch/sh/boot/compressed/misc_64.c            |  250 +++
 arch/sh/boot/compressed/vmlinux_64.lds       |   64 +
 arch/sh/cchips/voyagergx/Makefile            |    9 -
 arch/sh/cchips/voyagergx/consistent.c        |  121 --
 arch/sh/cchips/voyagergx/irq.c               |  101 --
 arch/sh/cchips/voyagergx/setup.c             |   37 -
 arch/sh/configs/cayman_defconfig             | 1166 ++++++++++++++
 arch/sh/configs/r7785rp_defconfig            |   13 +-
 arch/sh/configs/se7712_defconfig             |    2 +-
 arch/sh/drivers/dma/Kconfig                  |    2 +-
 arch/sh/drivers/dma/dma-sh.c                 |    2 +
 arch/sh/drivers/pci/Makefile                 |    3 +
 arch/sh/drivers/pci/ops-cayman.c             |   94 ++
 arch/sh/drivers/pci/ops-sh5.c                |   93 ++
 arch/sh/drivers/pci/pci-sh4.h                |    4 +-
 arch/sh/drivers/pci/pci-sh5.c                |  228 +++
 arch/sh/drivers/pci/pci-sh5.h                |  113 ++
 arch/sh/drivers/pci/pci-sh7780.c             |    1 +
 arch/sh/drivers/pci/pci-sh7780.h             |    1 +
 arch/sh/drivers/pci/pci.c                    |    2 +-
 arch/sh/kernel/Makefile                      |   30 +-
 arch/sh/kernel/Makefile_32                   |   26 +
 arch/sh/kernel/Makefile_64                   |   22 +
 arch/sh/kernel/cpu/Makefile                  |    6 +
 arch/sh/kernel/cpu/init.c                    |   74 +-
 arch/sh/kernel/cpu/irq/Makefile              |    4 +-
 arch/sh/kernel/cpu/irq/intc-sh5.c            |  257 ++++
 arch/sh/kernel/cpu/irq/intc.c                |   31 +-
 arch/sh/kernel/cpu/sh2/entry.S               |   19 +-
 arch/sh/kernel/cpu/sh2/setup-sh7619.c        |    2 +-
 arch/sh/kernel/cpu/sh2a/Makefile             |    4 +
 arch/sh/kernel/cpu/sh2a/clock-sh7203.c       |   89 ++
 arch/sh/kernel/cpu/sh2a/fpu.c                |  633 ++++++++
 arch/sh/kernel/cpu/sh2a/probe.c              |   22 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7203.c       |  319 ++++
 arch/sh/kernel/cpu/sh2a/setup-sh7206.c       |    2 +-
 arch/sh/kernel/cpu/sh3/Makefile              |    2 +
 arch/sh/kernel/cpu/sh3/clock-sh7712.c        |   71 +
 arch/sh/kernel/cpu/sh3/entry.S               |   24 +-
 arch/sh/kernel/cpu/sh3/ex.S                  |    2 +-
 arch/sh/kernel/cpu/sh3/probe.c               |    9 +-
 arch/sh/kernel/cpu/sh3/setup-sh7705.c        |   10 +-
 arch/sh/kernel/cpu/sh3/setup-sh770x.c        |   11 +-
 arch/sh/kernel/cpu/sh3/setup-sh7710.c        |   16 +-
 arch/sh/kernel/cpu/sh3/setup-sh7720.c        |   78 +-
 arch/sh/kernel/cpu/sh4/Makefile              |    2 +-
 arch/sh/kernel/cpu/sh4/fpu.c                 |  537 +++++---
 arch/sh/kernel/cpu/sh4/probe.c               |    2 +
 arch/sh/kernel/cpu/sh4/setup-sh7750.c        |   18 +-
 arch/sh/kernel/cpu/sh4/setup-sh7760.c        |   13 +-
 arch/sh/kernel/cpu/sh4/softfloat.c           |  892 +++++++++++
 arch/sh/kernel/cpu/sh4a/Makefile             |    2 +
 arch/sh/kernel/cpu/sh4a/clock-sh7763.c       |  126 ++
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c       |   10 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7763.c       |  390 +++++
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c       |   13 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c       |   19 +-
 arch/sh/kernel/cpu/sh4a/setup-shx3.c         |   14 +-
 arch/sh/kernel/cpu/sh5/Makefile              |    7 +
 arch/sh/kernel/cpu/sh5/entry.S               | 2101 +++++++++++++++++++++++++
 arch/sh/kernel/cpu/sh5/fpu.c                 |  166 ++
 arch/sh/kernel/cpu/sh5/probe.c               |   76 +
 arch/sh/kernel/cpu/sh5/switchto.S            |  198 +++
 arch/sh/kernel/cpu/sh5/unwind.c              |  326 ++++
 arch/sh/kernel/dump_task.c                   |   31 +
 arch/sh/kernel/early_printk.c                |   12 +-
 arch/sh/kernel/entry-common.S                |   27 +-
 arch/sh/kernel/head.S                        |  120 --
 arch/sh/kernel/head_32.S                     |  124 ++
 arch/sh/kernel/head_64.S                     |  356 +++++
 arch/sh/kernel/init_task.c                   |    4 +-
 arch/sh/kernel/io.c                          |   67 -
 arch/sh/kernel/module.c                      |   62 +-
 arch/sh/kernel/process.c                     |  558 -------
 arch/sh/kernel/process_32.c                  |  465 ++++++
 arch/sh/kernel/process_64.c                  |  701 +++++++++
 arch/sh/kernel/ptrace.c                      |  274 ----
 arch/sh/kernel/ptrace_32.c                   |  287 ++++
 arch/sh/kernel/ptrace_64.c                   |  341 +++++
 arch/sh/kernel/setup.c                       |   37 +-
 arch/sh/kernel/sh_ksyms.c                    |  150 --
 arch/sh/kernel/sh_ksyms_32.c                 |  150 ++
 arch/sh/kernel/sh_ksyms_64.c                 |   55 +
 arch/sh/kernel/signal.c                      |  629 --------
 arch/sh/kernel/signal_32.c                   |  611 ++++++++
 arch/sh/kernel/signal_64.c                   |  751 +++++++++
 arch/sh/kernel/sys_sh.c                      |  100 +-
 arch/sh/kernel/sys_sh32.c                    |   84 +
 arch/sh/kernel/sys_sh64.c                    |   66 +
 arch/sh/kernel/syscalls.S                    |  343 -----
 arch/sh/kernel/syscalls_32.S                 |  343 +++++
 arch/sh/kernel/syscalls_64.S                 |  381 +++++
 arch/sh/kernel/time.c                        |  269 ----
 arch/sh/kernel/time_32.c                     |  269 ++++
 arch/sh/kernel/time_64.c                     |  519 +++++++
 arch/sh/kernel/timers/timer-cmt.c            |    4 +-
 arch/sh/kernel/timers/timer-tmu.c            |    1 +
 arch/sh/kernel/traps.c                       |  949 +-----------
 arch/sh/kernel/traps_32.c                    |  919 +++++++++++
 arch/sh/kernel/traps_64.c                    |  975 ++++++++++++
 arch/sh/kernel/vmlinux.lds.S                 |  139 +--
 arch/sh/kernel/vmlinux_32.lds.S              |  152 ++
 arch/sh/kernel/vmlinux_64.lds.S              |  164 ++
 arch/sh/lib/Makefile                         |    5 +-
 arch/sh/lib/clear_page.S                     |  154 ++
 arch/sh/lib/copy_page.S                      |  389 +++++
 arch/sh/lib/io.c                             |   82 +
 arch/sh/lib64/.gitignore                     |    1 +
 arch/sh/lib64/Makefile                       |   15 +
 arch/sh/lib64/c-checksum.c                   |  214 +++
 arch/sh/lib64/clear_page.S                   |   54 +
 arch/sh/lib64/copy_page.S                    |   89 ++
 arch/sh/lib64/copy_user_memcpy.S             |  217 +++
 arch/sh/lib64/dbg.c                          |  430 ++++++
 arch/sh/lib64/memcpy.c                       |   81 +
 arch/sh/lib64/panic.c                        |   58 +
 arch/sh/lib64/udelay.c                       |   56 +
 arch/sh/mm/Kconfig                           |  222 +---
 arch/sh/mm/Makefile                          |   40 +-
 arch/sh/mm/Makefile_32                       |   36 +
 arch/sh/mm/Makefile_64                       |   44 +
 arch/sh/mm/cache-debugfs.c                   |    9 +-
 arch/sh/mm/cache-sh4.c                       |   14 +-
 arch/sh/mm/cache-sh5.c                       | 1029 +++++++++++++
 arch/sh/mm/cache-sh7705.c                    |   12 +-
 arch/sh/mm/clear_page.S                      |  152 --
 arch/sh/mm/consistent.c                      |   46 +-
 arch/sh/mm/copy_page.S                       |  388 -----
 arch/sh/mm/extable.c                         |   21 -
 arch/sh/mm/extable_32.c                      |   21 +
 arch/sh/mm/extable_64.c                      |   82 +
 arch/sh/mm/fault.c                           |  303 ----
 arch/sh/mm/fault_32.c                        |  303 ++++
 arch/sh/mm/fault_64.c                        |  275 ++++
 arch/sh/mm/init.c                            |   68 +-
 arch/sh/mm/ioremap.c                         |  150 --
 arch/sh/mm/ioremap_32.c                      |  150 ++
 arch/sh/mm/ioremap_64.c                      |  404 +++++
 arch/sh/mm/pg-nommu.c                        |    4 +-
 arch/sh/mm/pmb.c                             |   26 +-
 arch/sh/mm/tlb-flush.c                       |  140 --
 arch/sh/mm/tlb-nommu.c                       |   10 +
 arch/sh/mm/tlb-sh4.c                         |    7 +-
 arch/sh/mm/tlb-sh5.c                         |  164 ++
 arch/sh/mm/tlbflush_32.c                     |  140 ++
 arch/sh/mm/tlbflush_64.c                     |  475 ++++++
 arch/sh/tools/mach-types                     |    1 +
 arch/sh64/Kconfig                            |  295 ----
 arch/sh64/Kconfig.debug                      |   33 -
 arch/sh64/Makefile                           |  111 --
 arch/sh64/boot/Makefile                      |   20 -
 arch/sh64/boot/compressed/Makefile           |   46 -
 arch/sh64/boot/compressed/cache.c            |   39 -
 arch/sh64/boot/compressed/head.S             |  164 --
 arch/sh64/boot/compressed/install.sh         |   56 -
 arch/sh64/boot/compressed/misc.c             |  250 ---
 arch/sh64/boot/compressed/vmlinux.lds.S      |   64 -
 arch/sh64/configs/cayman_defconfig           | 1126 --------------
 arch/sh64/configs/harp_defconfig             |  745 ---------
 arch/sh64/configs/sim_defconfig              |  558 -------
 arch/sh64/kernel/Makefile                    |   36 -
 arch/sh64/kernel/alphanum.c                  |   43 -
 arch/sh64/kernel/asm-offsets.c               |   33 -
 arch/sh64/kernel/dma.c                       |  297 ----
 arch/sh64/kernel/early_printk.c              |   99 --
 arch/sh64/kernel/entry.S                     | 2102 --------------------------
 arch/sh64/kernel/fpu.c                       |  170 ---
 arch/sh64/kernel/head.S                      |  372 -----
 arch/sh64/kernel/init_task.c                 |   46 -
 arch/sh64/kernel/irq.c                       |  115 --
 arch/sh64/kernel/irq_intc.c                  |  272 ----
 arch/sh64/kernel/led.c                       |   40 -
 arch/sh64/kernel/module.c                    |  161 --
 arch/sh64/kernel/pci_sh5.c                   |  536 -------
 arch/sh64/kernel/pci_sh5.h                   |  107 --
 arch/sh64/kernel/pcibios.c                   |  168 --
 arch/sh64/kernel/process.c                   |  691 ---------
 arch/sh64/kernel/ptrace.c                    |  332 ----
 arch/sh64/kernel/semaphore.c                 |  140 --
 arch/sh64/kernel/setup.c                     |  379 -----
 arch/sh64/kernel/sh_ksyms.c                  |   62 -
 arch/sh64/kernel/signal.c                    |  750 ---------
 arch/sh64/kernel/switchto.S                  |  198 ---
 arch/sh64/kernel/sys_sh64.c                  |  304 ----
 arch/sh64/kernel/syscalls.S                  |  381 -----
 arch/sh64/kernel/time.c                      |  593 --------
 arch/sh64/kernel/traps.c                     |  982 ------------
 arch/sh64/kernel/unwind.c                    |  326 ----
 arch/sh64/kernel/vmlinux.lds.S               |  140 --
 arch/sh64/lib/.gitignore                     |    1 -
 arch/sh64/lib/Makefile                       |   19 -
 arch/sh64/lib/c-checksum.c                   |  217 ---
 arch/sh64/lib/copy_user_memcpy.S             |  217 ---
 arch/sh64/lib/dbg.c                          |  430 ------
 arch/sh64/lib/io.c                           |  128 --
 arch/sh64/lib/iomap.c                        |   54 -
 arch/sh64/lib/memcpy.c                       |   81 -
 arch/sh64/lib/page_clear.S                   |   54 -
 arch/sh64/lib/page_copy.S                    |   91 --
 arch/sh64/lib/panic.c                        |   58 -
 arch/sh64/lib/udelay.c                       |   59 -
 arch/sh64/mach-cayman/Makefile               |   11 -
 arch/sh64/mach-cayman/iomap.c                |   22 -
 arch/sh64/mach-cayman/irq.c                  |  195 ---
 arch/sh64/mach-cayman/led.c                  |   51 -
 arch/sh64/mach-cayman/setup.c                |  239 ---
 arch/sh64/mach-harp/Makefile                 |    1 -
 arch/sh64/mach-harp/setup.c                  |  129 --
 arch/sh64/mach-sim/Makefile                  |    1 -
 arch/sh64/mach-sim/setup.c                   |  126 --
 arch/sh64/mm/Makefile                        |   44 -
 arch/sh64/mm/cache.c                         | 1032 -------------
 arch/sh64/mm/consistent.c                    |   53 -
 arch/sh64/mm/extable.c                       |   80 -
 arch/sh64/mm/fault.c                         |  602 --------
 arch/sh64/mm/hugetlbpage.c                   |  105 --
 arch/sh64/mm/init.c                          |  189 ---
 arch/sh64/mm/ioremap.c                       |  388 -----
 arch/sh64/mm/tlb.c                           |  166 --
 arch/sh64/mm/tlbmiss.c                       |  279 ----
 arch/sh64/oprofile/Makefile                  |   12 -
 arch/sh64/oprofile/op_model_null.c           |   23 -
 drivers/rtc/Kconfig                          |    2 +-
 drivers/rtc/rtc-sh.c                         |   24 +-
 drivers/serial/sh-sci.c                      |    6 +-
 drivers/serial/sh-sci.h                      |   48 +-
 include/asm-sh/Kbuild                        |    5 +
 include/asm-sh/addrspace.h                   |   43 +-
 include/asm-sh/atomic-grb.h                  |  169 ++
 include/asm-sh/atomic.h                      |   10 +-
 include/asm-sh/auxvec.h                      |   18 +
 include/asm-sh/bitops-grb.h                  |  169 ++
 include/asm-sh/bitops-irq.h                  |   91 ++
 include/asm-sh/bitops.h                      |  117 +-
 include/asm-sh/bug.h                         |    9 +-
 include/asm-sh/bugs.h                        |   17 +-
 include/asm-sh/byteorder.h                   |   45 +-
 include/asm-sh/cache.h                       |    5 -
 include/asm-sh/checksum.h                    |  216 +---
 include/asm-sh/checksum_32.h                 |  215 +++
 include/asm-sh/checksum_64.h                 |   78 +
 include/asm-sh/cmpxchg-grb.h                 |   70 +
 include/asm-sh/cmpxchg-irq.h                 |   40 +
 include/asm-sh/cpu-sh2/addrspace.h           |    7 +-
 include/asm-sh/cpu-sh2/cache.h               |    8 +-
 include/asm-sh/cpu-sh2/rtc.h                 |    8 +
 include/asm-sh/cpu-sh2a/addrspace.h          |   11 +-
 include/asm-sh/cpu-sh2a/cache.h              |   11 +-
 include/asm-sh/cpu-sh2a/freq.h               |    2 -
 include/asm-sh/cpu-sh2a/rtc.h                |    8 +
 include/asm-sh/cpu-sh3/addrspace.h           |    7 +-
 include/asm-sh/cpu-sh3/cache.h               |    8 +-
 include/asm-sh/cpu-sh3/dma.h                 |    4 +-
 include/asm-sh/cpu-sh3/freq.h                |    5 +
 include/asm-sh/cpu-sh3/gpio.h                |    3 +-
 include/asm-sh/cpu-sh3/mmu_context.h         |    3 +-
 include/asm-sh/cpu-sh3/rtc.h                 |    8 +
 include/asm-sh/cpu-sh3/timer.h               |    7 +-
 include/asm-sh/cpu-sh3/ubc.h                 |    3 +-
 include/asm-sh/cpu-sh4/addrspace.h           |    6 +
 include/asm-sh/cpu-sh4/cache.h               |    5 +
 include/asm-sh/cpu-sh4/fpu.h                 |   32 +
 include/asm-sh/cpu-sh4/freq.h                |    3 +-
 include/asm-sh/cpu-sh4/mmu_context.h         |   10 +-
 include/asm-sh/cpu-sh4/rtc.h                 |    8 +
 include/asm-sh/cpu-sh5/addrspace.h           |   11 +
 include/asm-sh/cpu-sh5/cache.h               |   97 ++
 include/asm-sh/cpu-sh5/cacheflush.h          |   35 +
 include/asm-sh/cpu-sh5/dma.h                 |    6 +
 include/asm-sh/cpu-sh5/irq.h                 |  117 ++
 include/asm-sh/cpu-sh5/mmu_context.h         |   27 +
 include/asm-sh/cpu-sh5/registers.h           |  106 ++
 include/asm-sh/cpu-sh5/rtc.h                 |    8 +
 include/asm-sh/cpu-sh5/timer.h               |    4 +
 include/asm-sh/delay.h                       |    8 +-
 include/asm-sh/dma-mapping.h                 |    4 +-
 include/asm-sh/elf.h                         |   75 +-
 include/asm-sh/fixmap.h                      |    5 +
 include/asm-sh/flat.h                        |    2 +-
 include/asm-sh/fpu.h                         |   46 +
 include/asm-sh/hd64461.h                     |   28 +-
 include/asm-sh/hw_irq.h                      |   12 +-
 include/asm-sh/io.h                          |   68 +-
 include/asm-sh/irqflags.h                    |   97 +--
 include/asm-sh/irqflags_32.h                 |   99 ++
 include/asm-sh/irqflags_64.h                 |   85 +
 include/asm-sh/microdev.h                    |    4 +-
 include/asm-sh/mmu_context.h                 |   87 +-
 include/asm-sh/mmu_context_32.h              |   47 +
 include/asm-sh/mmu_context_64.h              |   75 +
 include/asm-sh/module.h                      |    4 +
 include/asm-sh/page.h                        |  102 +-
 include/asm-sh/param.h                       |    6 +-
 include/asm-sh/pci.h                         |    5 +-
 include/asm-sh/pgtable.h                     |  518 +------
 include/asm-sh/pgtable_32.h                  |  474 ++++++
 include/asm-sh/pgtable_64.h                  |  299 ++++
 include/asm-sh/posix_types.h                 |  129 +--
 include/asm-sh/posix_types_32.h              |  122 ++
 include/asm-sh/posix_types_64.h              |  131 ++
 include/asm-sh/processor.h                   |  260 +---
 include/asm-sh/processor_32.h                |  215 +++
 include/asm-sh/processor_64.h                |  275 ++++
 include/asm-sh/ptrace.h                      |   28 +-
 include/asm-sh/r7780rp.h                     |   14 +-
 include/asm-sh/rtc.h                         |    2 +
 include/asm-sh/scatterlist.h                 |    2 +-
 include/asm-sh/sections.h                    |    1 +
 include/asm-sh/sigcontext.h                  |   16 +-
 include/asm-sh/stat.h                        |   63 +-
 include/asm-sh/string.h                      |  136 +--
 include/asm-sh/string_32.h                   |  131 ++
 include/asm-sh/string_64.h                   |   17 +
 include/asm-sh/system.h                      |  173 +--
 include/asm-sh/system_32.h                   |   99 ++
 include/asm-sh/system_64.h                   |   40 +
 include/asm-sh/thread_info.h                 |    8 +-
 include/asm-sh/tlb.h                         |   10 +-
 include/asm-sh/tlb_64.h                      |   69 +
 include/asm-sh/types.h                       |    6 +
 include/asm-sh/uaccess.h                     |  564 +-------
 include/asm-sh/uaccess_32.h                  |  510 +++++++
 include/asm-sh/uaccess_64.h                  |  302 ++++
 include/asm-sh/unistd.h                      |  379 +-----
 include/asm-sh/unistd_32.h                   |  376 +++++
 include/asm-sh/unistd_64.h                   |  415 +++++
 include/asm-sh/user.h                        |    7 +
 include/asm-sh/voyagergx.h                   |  341 -----
 include/asm-sh64/Kbuild                      |    1 -
 include/asm-sh64/a.out.h                     |   38 -
 include/asm-sh64/atomic.h                    |  158 --
 include/asm-sh64/auxvec.h                    |    4 -
 include/asm-sh64/bitops.h                    |  155 --
 include/asm-sh64/bug.h                       |   19 -
 include/asm-sh64/bugs.h                      |   38 -
 include/asm-sh64/byteorder.h                 |   49 -
 include/asm-sh64/cache.h                     |  139 --
 include/asm-sh64/cacheflush.h                |   50 -
 include/asm-sh64/cayman.h                    |   20 -
 include/asm-sh64/checksum.h                  |   82 -
 include/asm-sh64/cpumask.h                   |    6 -
 include/asm-sh64/cputime.h                   |    6 -
 include/asm-sh64/current.h                   |   28 -
 include/asm-sh64/delay.h                     |   11 -
 include/asm-sh64/device.h                    |    7 -
 include/asm-sh64/div64.h                     |    6 -
 include/asm-sh64/dma-mapping.h               |  194 ---
 include/asm-sh64/dma.h                       |   41 -
 include/asm-sh64/elf.h                       |  107 --
 include/asm-sh64/emergency-restart.h         |    6 -
 include/asm-sh64/errno.h                     |    6 -
 include/asm-sh64/fb.h                        |   19 -
 include/asm-sh64/fcntl.h                     |    1 -
 include/asm-sh64/futex.h                     |    6 -
 include/asm-sh64/gpio.h                      |    8 -
 include/asm-sh64/hardirq.h                   |   18 -
 include/asm-sh64/hardware.h                  |   22 -
 include/asm-sh64/hw_irq.h                    |   15 -
 include/asm-sh64/ide.h                       |   29 -
 include/asm-sh64/io.h                        |  196 ---
 include/asm-sh64/ioctl.h                     |    1 -
 include/asm-sh64/ioctls.h                    |  116 --
 include/asm-sh64/ipcbuf.h                    |   40 -
 include/asm-sh64/irq.h                       |  144 --
 include/asm-sh64/irq_regs.h                  |    1 -
 include/asm-sh64/kdebug.h                    |    1 -
 include/asm-sh64/keyboard.h                  |   70 -
 include/asm-sh64/kmap_types.h                |    7 -
 include/asm-sh64/linkage.h                   |    7 -
 include/asm-sh64/local.h                     |    7 -
 include/asm-sh64/mc146818rtc.h               |    7 -
 include/asm-sh64/mman.h                      |    6 -
 include/asm-sh64/mmu.h                       |    7 -
 include/asm-sh64/mmu_context.h               |  208 ---
 include/asm-sh64/module.h                    |   20 -
 include/asm-sh64/msgbuf.h                    |   42 -
 include/asm-sh64/mutex.h                     |    9 -
 include/asm-sh64/namei.h                     |   24 -
 include/asm-sh64/page.h                      |  119 --
 include/asm-sh64/param.h                     |   42 -
 include/asm-sh64/pci.h                       |  102 --
 include/asm-sh64/percpu.h                    |    6 -
 include/asm-sh64/pgalloc.h                   |  125 --
 include/asm-sh64/pgtable.h                   |  496 ------
 include/asm-sh64/platform.h                  |   64 -
 include/asm-sh64/poll.h                      |    8 -
 include/asm-sh64/posix_types.h               |  131 --
 include/asm-sh64/processor.h                 |  287 ----
 include/asm-sh64/ptrace.h                    |   35 -
 include/asm-sh64/registers.h                 |  106 --
 include/asm-sh64/resource.h                  |    6 -
 include/asm-sh64/scatterlist.h               |   37 -
 include/asm-sh64/sci.h                       |    1 -
 include/asm-sh64/sections.h                  |    7 -
 include/asm-sh64/segment.h                   |    6 -
 include/asm-sh64/semaphore-helper.h          |  101 --
 include/asm-sh64/semaphore.h                 |  119 --
 include/asm-sh64/sembuf.h                    |   36 -
 include/asm-sh64/serial.h                    |   31 -
 include/asm-sh64/setup.h                     |   22 -
 include/asm-sh64/shmbuf.h                    |   53 -
 include/asm-sh64/shmparam.h                  |   12 -
 include/asm-sh64/sigcontext.h                |   30 -
 include/asm-sh64/siginfo.h                   |    6 -
 include/asm-sh64/signal.h                    |  159 --
 include/asm-sh64/smp.h                       |   15 -
 include/asm-sh64/socket.h                    |    6 -
 include/asm-sh64/sockios.h                   |   25 -
 include/asm-sh64/spinlock.h                  |   17 -
 include/asm-sh64/stat.h                      |   88 --
 include/asm-sh64/statfs.h                    |    6 -
 include/asm-sh64/string.h                    |   21 -
 include/asm-sh64/system.h                    |  190 ---
 include/asm-sh64/termbits.h                  |    6 -
 include/asm-sh64/termios.h                   |   99 --
 include/asm-sh64/thread_info.h               |   91 --
 include/asm-sh64/timex.h                     |   31 -
 include/asm-sh64/tlb.h                       |   92 --
 include/asm-sh64/tlbflush.h                  |   27 -
 include/asm-sh64/topology.h                  |    6 -
 include/asm-sh64/types.h                     |   74 -
 include/asm-sh64/uaccess.h                   |  316 ----
 include/asm-sh64/ucontext.h                  |   23 -
 include/asm-sh64/unaligned.h                 |   17 -
 include/asm-sh64/unistd.h                    |  417 -----
 include/asm-sh64/user.h                      |   70 -
 init/Kconfig                                 |    2 +-
 mm/Kconfig                                   |    2 +-
 452 files changed, 28903 insertions(+), 33927 deletions(-)
