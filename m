Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbZIKHSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbZIKHSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZIKHSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:18:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:49629 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbZIKHSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:18:18 -0400
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, FUJITA Tomonori <tomof@acm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Sep 2009 17:17:53 +1000
Message-Id: <1252653473.8566.98.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

This is the powerpc batch for 2.6.32.

You will notice a bunch of generic swiotlb changes along with
corresponding changes to arch/sparc and arch/x86 from Fujita Tomonori.

There are due to my tree having pulled Ingo's iommu tree do sort out
various dependencies. If you pull Ingo's first, you'll already have
all these.

I'm happy for you to defer the pulling of my tree until you have those
bits via Ingo if you prefer, and I'll then send a pull request cleared
of that noise.

Among other non-arch/powerpc patches: Some PS3 and PowerMac specific
driver changes (yes, I think we are still the only users of
generic_nvram), some changes to HVC console and that should be it.

Cheers,
Ben.

The following changes since commit e07cccf4046978df10f2e13fe2b99b2f9b3a65db:
  Linus Torvalds (1):
        Linux 2.6.31-rc9

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

Anton Blanchard (3):
      powerpc: Move 64bit VDSO to improve context switch performance
      powerpc: Rearrange SLB preload code
      powerpc: Preload application text segment instead of TASK_UNMAPPED_BASE

Anton Vorontsov (7):
      powerpc/83xx: Add support for MPC8377E-WLAN boards
      powerpc/85xx: Add support for I2C EEPROMs on MPC8548CDS boards
      powerpc/83xx: Add eSDHC support for MPC837xE-RDB/WLAN boards
      powerpc/85xx: Add eSDHC support for MPC8536DS boards
      powerpc/82xx: Fix BCSR bits for MPC8272ADS boards
      powerpc/82xx: Add CPM USB Gadget support for MPC8272ADS boards
      powerpc/85xx: Add QE USB support for MPC8569E-MDS boards

Arnd Bergmann (1):
      dma-ops: Remove flush_write_buffers() in dma-mapping-common.h

Bastian Blank (1):
      powerpc: Remove SMP warning from PowerMac cpufreq

Becky Bruce (1):
      powerpc: Name xpn & x fields in HW Hash PTE format

Benjamin Herrenschmidt (37):
      powerpc: Rename exception.h to exception-64s.h
      powerpc: Use names rather than numbers for SPRGs (v2)
      powerpc: Remove use of a second scratch SPRG in STAB code
      powerpc/mm: Fix definitions of FORCE_MAX_ZONEORDER in Kconfig
      powerpc/pmac: Fix PowerSurge SMP IPI allocation
      powerpc: Change PACA from SPRG3 to SPRG1
      powerpc: Add compat_sys_truncate
      powerpc/mm: Fix misplaced #endif in pgtable-ppc64-64k.h
      powerpc/of: Remove useless register save/restore when calling OF back
      powerpc/mm: Add HW threads support to no_hash TLB management
      powerpc/mm: Add opcode definitions for tlbivax and tlbsrx.
      powerpc/mm: Add more bit definitions for Book3E MMU registers
      powerpc/mm: Add support for early ioremap on non-hash 64-bit processors
      powerpc: Modify some ppc_asm.h macros to accomodate 64-bits Book3E
      powerpc/mm: Make low level TLB flush ops on BookE take additional args
      powerpc/mm: Call mmu_context_init() from ppc64
      powerpc: Clean ifdef usage in copy_thread()
      powerpc: Move definitions of secondary CPU spinloop to header file
      powerpc/mm: Rework & cleanup page table freeing code path
      powerpc: Add SPR definitions for new 64-bit BookE
      powerpc: Add memory management headers for new 64-bit BookE
      powerpc: Add definitions used by exception handling on 64-bit Book3E
      powerpc: Add PACA fields specific to 64-bit Book3E processors
      powerpc/mm: Move around mmu_gathers definition on 64-bit
      powerpc: Add TLB management code for 64-bit Book3E
      powerpc/mm: Add support for SPARSEMEM_VMEMMAP on 64-bit Book3E
      powerpc: Remaining 64-bit Book3E support
      powerpc/mm: Fix encoding of page table cache numbers
      Merge commit 'paulus-perf/master' into next
      Merge commit 'origin/master' into next
      powerpc/mm: Cleanup handling of execute permission
      Merge commit 'kumar/next' into next
      Merge commit 'tip/iommu-for-powerpc' into next
      powerpc: Properly start decrementer on BookE secondary CPUs
      powerpc: Fix some late PowerMac G5 with PCIe ATI graphics
      powerpc/booke: Don't set DABR on 64-bit BookE, use DAC1 instead
      powerpc/iseries: Fix oops reading from /proc/iSeries/mf/*/cmdline

Benjamin Krill (1):
      powerpc/prom_init: Evaluate mem kernel parameter for early allocation

Brian King (1):
      powerpc/pseries: Fix to handle slb resize across migration

Casey Dahlin (1):
      lib/swiotlb.c: Fix strange panic message selection logic when swiotlb fills up

Christoph Hellwig (2):
      powerpc/sputrace: Use the generic event tracer
      powerpc: Switch to asm-generic/hardirq.h

FUJITA Tomonori (29):
      swiotlb: remove unused swiotlb_alloc_boot()
      swiotlb: remove unused swiotlb_alloc()
      swiotlb: remove swiotlb_arch_range_needs_mapping
      swiotlb: remove unnecessary swiotlb_bus_to_virt
      x86: add dma_capable() to replace is_buffer_dma_capable()
      x86: replace is_buffer_dma_capable() with dma_capable
      ia64: add dma_capable() to replace is_buffer_dma_capable()
      powerpc: add dma_capable() to replace is_buffer_dma_capable()
      swiotlb: use dma_capable()
      powerpc: remove unncesary swiotlb_arch_address_needs_mapping
      remove is_buffer_dma_capable()
      x86, IA64, powerpc: add phys_to_dma() and dma_to_phys()
      swiotlb: use phys_to_dma and dma_to_phys
      powerpc: remove unused swiotlb_phys_to_bus() and swiotlb_bus_to_phys()
      x86: remove unused swiotlb_phys_to_bus() and swiotlb_bus_to_phys()
      IA64: Remove NULL flush_write_buffers
      sparc: Use dma_map_ops struct
      sparc: Use asm-generic/dma-mapping-common.h
      sparc: Remove no-op dma_4v_sync_single_for_cpu and dma_4v_sync_sg_for_cpu
      sparc: Replace sbus_map_single and sbus_unmap_single with sbus_map_page and sbus_unmap_page
      sparc: Use asm-generic/pci-dma-compat
      sparc: Add CONFIG_DMA_API_DEBUG support
      powerpc: Remove addr_needs_map in struct dma_mapping_ops
      powerpc: Remove swiotlb_pci_dma_ops
      dma: Add set_dma_mask hook to struct dma_map_ops
      powerpc: use dma_map_ops struct
      powerpc: Use asm-generic/dma-mapping-common.h
      powerpc: Handle SWIOTLB mapping error properly
      powerpc: Add CONFIG_DMA_API_DEBUG support

Frans Pop (1):
      powerpc: Makefile simplification through use of cc-ifversion

Gautham R Shenoy (1):
      powerpc/pseries: Reduce the polling interval in __cpu_up()

Geert Uytterhoeven (1):
      powerpc/cell: Move CBE_IOPTE_* to <asm/cell-regs.h>

Geoff Levand (1):
      powerpc/ps3: Workaround for flash memory I/O error

Geoff Thorpe (1):
      powerpc: expose the multi-bit ops that underlie single-bit ops.

Gerhard Pircher (1):
      powerpc/amigaone: Convert amigaone_init() to a machine_device_initcall()

Grant Likely (3):
      powerpc/pci: Remove dead checks for CONFIG_PPC_OF
      powerpc/pci: move pci_64.c device tree scanning code into pci-common.c
      powerpc/pci: Merge ppc32 and ppc64 versions of phb_scan()

Heiko Schocher (2):
      powerpc/82xx: mgcoge - updates for 2.6.32
      powerpc/82xx: mgcoge - updated defconfig

Josh Boyer (1):
      powerpc: Fix __flush_icache_range on 44x

Julia Lawall (5):
      powerpc/fsl_rio: Add kmalloc NULL tests
      powerpc/ipic: introduce missing kfree
      powerpc/qe: introduce missing kfree
      hvc_console: Drop unnecessary NULL test
      powerpc: Use DIV_ROUND_CLOSEST in time init code

Kumar Gala (14):
      powerpc/mm: Fix switch_mmu_context to iterate of the proper list of cpus
      powerpc/85xx: Move mpc8536ds.dts to address-cells/size-cells = <2>
      powerpc/85xx: Added 36-bit physical device tree for mpc8536ds board
      powerpc/mm: Fix assert_pte_locked to work properly on uniprocessor
      powerpc/booke: Move MMUCSR definition into mmu-book3e.h
      powerpc/mm: Add MMU features for TLB reservation & Paired MAS registers
      powerpc/book3e-64: Move the default cpu table entry
      powerpc/book3e-64: Wait til generic_calibrate_decr to enable decrementer
      powerpc/book3e-64: Add helper function to setup IVORs
      powerpc/book3e-64: Add support to initial_tlb_book3e for non-HES TLB
      powerpc/pci: Pull ppc32 PCI features into common
      powerpc/book3e: Add missing page sizes
      powerpc/fsl-booke: Use HW PTE format if CONFIG_PTE_64BIT
      powerpc/85xx: Fix SMP compile error and allow NULL for smp_ops

Liang Li (4):
      powerpc/83xx: Remove second USB node from SBC834x DTS
      powerpc/83xx: Add localbus node and MTD partitions for SBC834x
      powerpc/83xx: Fix incorrect PCI interrupt map in SBC834x DTS
      powerpc/85xx: sbc8560 - Fix warm reboot with board specific reset function

Lucian Adrian Grijincu (1):
      powerpc: Update boot wrapper script with the new location of dtc

Lyonel Vincent (1):
      powerpc/powermac: Thermal control turns system off too eagerly

Martyn Welch (5):
      powerpc/86xx: Correct reading of information presented in cpuinfo
      powerpc/86xx: Enable XMC site on GE Fanuc SBC310
      powerpc/86xx: Update GE Fanuc sbc310 DTS
      powerpc/nvram: Allow byte length reads from mmio NVRAM driver
      powerpc/nvram: Enable use Generic NVRAM driver for different size chips

Michael Barkowski (1):
      powerpc/qe_lib: Set gpio data before changing the direction to output

Michael Ellerman (4):
      powerpc/mpic: Fix MPIC_BROKEN_REGREAD on non broken MPICs
      kmemleak: Allow kmemleak to be built on powerpc
      powerpc: Enable GCOV
      powerpc/vmlinux.lds: Move _edata down

Michael Wolf (1):
      powerpc: Adjust base and index registers in Altivec macros

Michel Dänzer (2):
      agp/uninorth: Allow larger aperture sizes on pre-U3 bridges.
      agp/uninorth: Simplify cache flushing.

Paul Gortmaker (4):
      powerpc/83xx: sbc8349 - update defconfig, enable MTD, USB storage
      powerpc/85xx: issue fsl_soc reboot warning only when applicable
      powerpc/85xx: sbc8560 - remove "has-rstcr" from global utilities block
      powerpc: derive COMMAND_LINE_SIZE from asm-generic

Paul Mackerras (5):
      powerpc/32: Always order writes to halves of 64-bit PTEs
      powerpc: Allow perf_counters to access user memory at interrupt time
      perf_counter: powerpc: Add callchain support
      powerpc: Fix bug where perf_counters breaks oprofile
      powerpc/perf_counters: Reduce stack usage of power_check_constraints

Peter Huewe (1):
      hvc_console: Add __init and __exit to hvc_vio

Poonam Aggrwal (1):
      powerpc/85xx: Add support for P2020RDB board

Roel Kluin (2):
      powerpc/fsl-booke: read buffer overflow
      powerpc/hvsi: Avoid calculating possibly-invalid address

Sebastian Andrzej Siewior (1):
      powerpc/ipic: unmask all interrupt sources

Solomon Peachy (1):
      powerpc/40x: Add support for the ESTeem 195E (PPC405EP) SBC

Stefan Roese (7):
      powerpc: Add AMCC 460EX/460GT Rev. B support to cputable.c
      powerpc/44x: Add NAND support to Canyonlands dts
      powerpc/40x: Update Kilauea dts to support NAND, RTC and HWMON
      powerpc/44x: Update Canyonlands defconfig to support NOR, NAND and RTC
      powerpc/40x: Update kilauea defconfig to support NAND, RTC and HWMON
      powerpc/44x: Update Arches dts
      powerpc/44x: Update Arches defconfig

Stephen Rothwell (1):
      powerpc: use consistent types in mktree

Stoyan Gaydarov (1):
      powerpc: ARRAY_SIZE changes in pasemi and powermac code

Tiejun Chen (2):
      powerpc/405ex: provide necessary fixup function to support cuImage
      powerpc/405ex: support cuImage via included dtb

Wolfram Sang (1):
      powerpc/irq: Improve nanodoc

fkan@amcc.com (1):
      powerpc/44x: Add Eiger AMCC (AppliedMicro) PPC460SX evaluation board support.

roel kluin (3):
      powerpc/cell: Replace strncpy by strlcpy
      powerpc: Missing tests for NULL after ioremap()
      powerpc/macio: Don't the address of an array element before boundchecking

 arch/ia64/include/asm/dma-mapping.h                |   19 +-
 arch/powerpc/Kconfig                               |   29 +-
 arch/powerpc/Makefile                              |    2 +-
 arch/powerpc/boot/4xx.c                            |  142 +++
 arch/powerpc/boot/4xx.h                            |    1 +
 arch/powerpc/boot/Makefile                         |    6 +-
 arch/powerpc/boot/cuboot-hotfoot.c                 |  142 +++
 arch/powerpc/boot/cuboot-kilauea.c                 |   49 +
 arch/powerpc/boot/dcr.h                            |    4 +-
 arch/powerpc/boot/dts/arches.dts                   |   50 +
 arch/powerpc/boot/dts/canyonlands.dts              |   49 +-
 arch/powerpc/boot/dts/eiger.dts                    |  421 +++++++
 arch/powerpc/boot/dts/gef_sbc310.dts               |   64 +-
 arch/powerpc/boot/dts/hotfoot.dts                  |  294 +++++
 arch/powerpc/boot/dts/kilauea.dts                  |   44 +-
 arch/powerpc/boot/dts/mgcoge.dts                   |   53 +
 arch/powerpc/boot/dts/mpc8272ads.dts               |    8 +
 arch/powerpc/boot/dts/mpc8377_rdb.dts              |    2 +-
 arch/powerpc/boot/dts/mpc8377_wlan.dts             |  464 ++++++++
 arch/powerpc/boot/dts/mpc8378_rdb.dts              |    2 +-
 arch/powerpc/boot/dts/mpc8379_rdb.dts              |    2 +-
 arch/powerpc/boot/dts/mpc8536ds.dts                |   40 +-
 arch/powerpc/boot/dts/mpc8536ds_36b.dts            |  475 ++++++++
 arch/powerpc/boot/dts/mpc8548cds.dts               |   20 +
 arch/powerpc/boot/dts/mpc8569mds.dts               |   45 +
 arch/powerpc/boot/dts/p2020rdb.dts                 |  586 +++++++++
 arch/powerpc/boot/dts/sbc8349.dts                  |   60 +-
 arch/powerpc/boot/dts/sbc8560.dts                  |    1 -
 arch/powerpc/boot/mktree.c                         |   10 +-
 arch/powerpc/boot/ppcboot-hotfoot.h                |  133 +++
 arch/powerpc/boot/wrapper                          |    3 +-
 arch/powerpc/configs/40x/kilauea_defconfig         |  298 ++++-
 arch/powerpc/configs/44x/arches_defconfig          |  382 ++++++-
 arch/powerpc/configs/44x/canyonlands_defconfig     |  350 +++++-
 arch/powerpc/configs/44x/eiger_defconfig           | 1252 ++++++++++++++++++++
 arch/powerpc/configs/83xx/sbc834x_defconfig        |  320 +++++-
 arch/powerpc/configs/mgcoge_defconfig              |   86 ++-
 arch/powerpc/configs/mpc85xx_defconfig             |    1 +
 arch/powerpc/include/asm/bitops.h                  |  194 +---
 arch/powerpc/include/asm/cell-regs.h               |   11 +
 arch/powerpc/include/asm/cputhreads.h              |   16 +
 arch/powerpc/include/asm/device.h                  |    7 +-
 arch/powerpc/include/asm/dma-mapping.h             |  323 +-----
 arch/powerpc/include/asm/exception-64e.h           |  205 ++++
 .../include/asm/{exception.h => exception-64s.h}   |   25 +-
 arch/powerpc/include/asm/hardirq.h                 |   30 +-
 arch/powerpc/include/asm/hw_irq.h                  |    5 +
 arch/powerpc/include/asm/iommu.h                   |   10 -
 arch/powerpc/include/asm/irq.h                     |    7 +-
 arch/powerpc/include/asm/machdep.h                 |    6 +-
 arch/powerpc/include/asm/mmu-40x.h                 |    3 +
 arch/powerpc/include/asm/mmu-44x.h                 |    6 +
 arch/powerpc/include/asm/mmu-8xx.h                 |    3 +
 arch/powerpc/include/asm/mmu-book3e.h              |  208 +++-
 arch/powerpc/include/asm/mmu-hash32.h              |   16 +-
 arch/powerpc/include/asm/mmu-hash64.h              |   22 +-
 arch/powerpc/include/asm/mmu.h                     |   46 +
 arch/powerpc/include/asm/mmu_context.h             |   15 +-
 arch/powerpc/include/asm/nvram.h                   |    3 +
 arch/powerpc/include/asm/paca.h                    |   23 +-
 arch/powerpc/include/asm/page.h                    |    4 +
 arch/powerpc/include/asm/page_64.h                 |   10 +
 arch/powerpc/include/asm/pci-bridge.h              |   40 +-
 arch/powerpc/include/asm/pci.h                     |   11 +-
 arch/powerpc/include/asm/pgalloc.h                 |   46 +-
 arch/powerpc/include/asm/pgtable-ppc32.h           |    9 +-
 arch/powerpc/include/asm/pgtable-ppc64-64k.h       |    4 +-
 arch/powerpc/include/asm/pgtable-ppc64.h           |   67 +-
 arch/powerpc/include/asm/pgtable.h                 |    6 +-
 arch/powerpc/include/asm/pmc.h                     |   16 +-
 arch/powerpc/include/asm/ppc-opcode.h              |    6 +
 arch/powerpc/include/asm/ppc-pci.h                 |    1 -
 arch/powerpc/include/asm/ppc_asm.h                 |   26 +-
 arch/powerpc/include/asm/pte-40x.h                 |    2 +-
 arch/powerpc/include/asm/pte-44x.h                 |    2 +-
 arch/powerpc/include/asm/pte-8xx.h                 |    1 -
 arch/powerpc/include/asm/pte-book3e.h              |   84 ++
 arch/powerpc/include/asm/pte-common.h              |   25 +-
 arch/powerpc/include/asm/pte-fsl-booke.h           |    9 +-
 arch/powerpc/include/asm/pte-hash32.h              |    1 -
 arch/powerpc/include/asm/reg.h                     |  141 +++-
 arch/powerpc/include/asm/reg_booke.h               |   50 +-
 arch/powerpc/include/asm/setup.h                   |    2 +-
 arch/powerpc/include/asm/smp.h                     |   10 +
 arch/powerpc/include/asm/swiotlb.h                 |    8 +-
 arch/powerpc/include/asm/systbl.h                  |    4 +-
 arch/powerpc/include/asm/tlb.h                     |   38 +-
 arch/powerpc/include/asm/tlbflush.h                |   11 +-
 arch/powerpc/include/asm/vdso.h                    |    3 +-
 arch/powerpc/kernel/Makefile                       |   21 +-
 arch/powerpc/kernel/asm-offsets.c                  |   21 +-
 arch/powerpc/kernel/cpu_setup_6xx.S                |    2 +-
 arch/powerpc/kernel/cputable.c                     |   62 +-
 arch/powerpc/kernel/dma-iommu.c                    |    2 +-
 arch/powerpc/kernel/dma-swiotlb.c                  |   99 +--
 arch/powerpc/kernel/dma.c                          |   13 +-
 arch/powerpc/kernel/entry_32.S                     |   20 +-
 arch/powerpc/kernel/entry_64.S                     |  102 +-
 arch/powerpc/kernel/exceptions-64e.S               | 1001 ++++++++++++++++
 arch/powerpc/kernel/exceptions-64s.S               |   97 +-
 arch/powerpc/kernel/fpu.S                          |    2 +-
 arch/powerpc/kernel/head_32.S                      |   40 +-
 arch/powerpc/kernel/head_40x.S                     |  124 +-
 arch/powerpc/kernel/head_44x.S                     |   58 +-
 arch/powerpc/kernel/head_64.S                      |   83 ++-
 arch/powerpc/kernel/head_8xx.S                     |   13 +-
 arch/powerpc/kernel/head_booke.h                   |   50 +-
 arch/powerpc/kernel/head_fsl_booke.S               |  100 +-
 arch/powerpc/kernel/ibmebus.c                      |    2 +-
 arch/powerpc/kernel/lparcfg.c                      |    3 +
 arch/powerpc/kernel/misc_32.S                      |    7 +
 arch/powerpc/kernel/of_platform.c                  |    2 +-
 arch/powerpc/kernel/paca.c                         |    3 +
 arch/powerpc/kernel/pci-common.c                   |  133 ++-
 arch/powerpc/kernel/pci_32.c                       |  105 +--
 arch/powerpc/kernel/pci_64.c                       |  335 +-----
 arch/powerpc/kernel/pci_of_scan.c                  |  358 ++++++
 arch/powerpc/kernel/perf_callchain.c               |  527 ++++++++
 arch/powerpc/kernel/perf_counter.c                 |   68 +-
 arch/powerpc/kernel/process.c                      |   16 +-
 arch/powerpc/kernel/prom_init.c                    |  107 ++-
 arch/powerpc/kernel/rtas.c                         |    7 +-
 arch/powerpc/kernel/setup_32.c                     |    8 +
 arch/powerpc/kernel/setup_64.c                     |   34 +-
 arch/powerpc/kernel/smp.c                          |   15 +-
 arch/powerpc/kernel/sys_ppc32.c                    |   12 +
 arch/powerpc/kernel/sysfs.c                        |    3 +
 arch/powerpc/kernel/time.c                         |   33 +-
 arch/powerpc/kernel/vdso.c                         |    7 +-
 arch/powerpc/kernel/vdso32/Makefile                |    1 +
 arch/powerpc/kernel/vdso64/Makefile                |    2 +
 arch/powerpc/kernel/vector.S                       |    2 +-
 arch/powerpc/kernel/vio.c                          |    2 +-
 arch/powerpc/kernel/vmlinux.lds.S                  |    8 +-
 arch/powerpc/kvm/booke_interrupts.S                |   18 +-
 arch/powerpc/mm/40x_mmu.c                          |    4 +-
 arch/powerpc/mm/Makefile                           |    1 +
 arch/powerpc/mm/fsl_booke_mmu.c                    |    2 +-
 arch/powerpc/mm/hash_low_32.S                      |    4 +-
 arch/powerpc/mm/hugetlbpage.c                      |    8 +-
 arch/powerpc/mm/init_32.c                          |    2 -
 arch/powerpc/mm/init_64.c                          |   55 +-
 arch/powerpc/mm/mmu_context_nohash.c               |   96 +-
 arch/powerpc/mm/mmu_decl.h                         |   37 +-
 arch/powerpc/mm/pgtable.c                          |  179 ++-
 arch/powerpc/mm/pgtable_32.c                       |    2 +-
 arch/powerpc/mm/pgtable_64.c                       |   59 +-
 arch/powerpc/mm/slb.c                              |   83 +-
 arch/powerpc/mm/stab.c                             |   11 +-
 arch/powerpc/mm/tlb_hash32.c                       |    3 +
 arch/powerpc/mm/tlb_hash64.c                       |   20 +-
 arch/powerpc/mm/tlb_low_64e.S                      |  770 ++++++++++++
 arch/powerpc/mm/tlb_nohash.c                       |  268 ++++-
 arch/powerpc/mm/tlb_nohash_low.S                   |   87 ++-
 arch/powerpc/platforms/40x/Kconfig                 |   10 +
 arch/powerpc/platforms/40x/ppc40x_simple.c         |    3 +-
 arch/powerpc/platforms/44x/Kconfig                 |   12 +
 arch/powerpc/platforms/44x/ppc44x_simple.c         |    1 +
 arch/powerpc/platforms/82xx/mgcoge.c               |   69 +-
 arch/powerpc/platforms/82xx/mpc8272_ads.c          |   22 +-
 arch/powerpc/platforms/83xx/Kconfig                |    4 +-
 arch/powerpc/platforms/83xx/mpc837x_rdb.c          |   28 +-
 arch/powerpc/platforms/83xx/mpc83xx.h              |    4 +
 arch/powerpc/platforms/85xx/Kconfig                |    9 +
 arch/powerpc/platforms/85xx/Makefile               |    3 +-
 arch/powerpc/platforms/85xx/mpc8536_ds.c           |    3 +-
 arch/powerpc/platforms/85xx/mpc85xx_ds.c           |    3 +-
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |    7 +-
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c          |  141 +++
 arch/powerpc/platforms/85xx/sbc8560.c              |   39 +-
 arch/powerpc/platforms/85xx/smp.c                  |   23 -
 arch/powerpc/platforms/86xx/gef_ppc9a.c            |   37 +-
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c         |    3 +-
 arch/powerpc/platforms/86xx/mpc86xx_smp.c          |    1 -
 arch/powerpc/platforms/Kconfig.cputype             |   38 +-
 arch/powerpc/platforms/amigaone/setup.c            |    6 +-
 arch/powerpc/platforms/cell/Kconfig                |    7 -
 arch/powerpc/platforms/cell/celleb_setup.c         |    3 +-
 arch/powerpc/platforms/cell/iommu.c                |    2 +-
 arch/powerpc/platforms/cell/smp.c                  |    2 -
 arch/powerpc/platforms/cell/spufs/Makefile         |    3 +-
 arch/powerpc/platforms/cell/spufs/context.c        |    1 +
 arch/powerpc/platforms/cell/spufs/file.c           |    1 +
 arch/powerpc/platforms/cell/spufs/sched.c          |    2 +
 arch/powerpc/platforms/cell/spufs/spufs.h          |    5 -
 arch/powerpc/platforms/cell/spufs/sputrace.c       |  272 -----
 arch/powerpc/platforms/cell/spufs/sputrace.h       |   39 +
 arch/powerpc/platforms/iseries/exception.S         |   59 +-
 arch/powerpc/platforms/iseries/exception.h         |    6 +-
 arch/powerpc/platforms/iseries/mf.c                |    2 +-
 arch/powerpc/platforms/pasemi/idle.c               |    2 +-
 arch/powerpc/platforms/powermac/cpufreq_32.c       |    8 -
 arch/powerpc/platforms/powermac/feature.c          |   13 +-
 arch/powerpc/platforms/powermac/pci.c              |   61 +
 arch/powerpc/platforms/powermac/smp.c              |    2 +-
 arch/powerpc/platforms/ps3/mm.c                    |    2 +-
 arch/powerpc/platforms/ps3/system-bus.c            |    6 +-
 arch/powerpc/platforms/pseries/pci_dlpar.c         |    2 +-
 arch/powerpc/platforms/pseries/reconfig.c          |    9 +-
 arch/powerpc/platforms/pseries/setup.c             |    4 -
 arch/powerpc/platforms/pseries/smp.c               |    2 -
 arch/powerpc/sysdev/fsl_rio.c                      |   18 +-
 arch/powerpc/sysdev/fsl_soc.c                      |    6 +-
 arch/powerpc/sysdev/ipic.c                         |    7 +-
 arch/powerpc/sysdev/mmio_nvram.c                   |   32 +
 arch/powerpc/sysdev/mpic.c                         |   13 +-
 arch/powerpc/sysdev/qe_lib/gpio.c                  |    4 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c                 |    5 +-
 arch/powerpc/xmon/Makefile                         |    2 +
 arch/powerpc/xmon/xmon.c                           |    2 +-
 arch/sparc/Kconfig                                 |    2 +
 arch/sparc/include/asm/dma-mapping.h               |  145 +--
 arch/sparc/include/asm/pci.h                       |    3 +
 arch/sparc/include/asm/pci_32.h                    |  105 --
 arch/sparc/include/asm/pci_64.h                    |   88 --
 arch/sparc/kernel/Makefile                         |    2 +-
 arch/sparc/kernel/dma.c                            |  175 +---
 arch/sparc/kernel/dma.h                            |   14 -
 arch/sparc/kernel/iommu.c                          |   20 +-
 arch/sparc/kernel/ioport.c                         |  190 ++--
 arch/sparc/kernel/pci.c                            |    2 +-
 arch/sparc/kernel/pci_sun4v.c                      |   30 +-
 arch/x86/include/asm/dma-mapping.h                 |   18 +
 arch/x86/kernel/pci-dma.c                          |    2 +-
 arch/x86/kernel/pci-gart_64.c                      |    5 +-
 arch/x86/kernel/pci-nommu.c                        |   29 +-
 arch/x86/kernel/pci-swiotlb.c                      |   25 -
 drivers/block/ps3vram.c                            |    2 +-
 drivers/char/agp/uninorth-agp.c                    |   49 +-
 drivers/char/generic_nvram.c                       |   27 +-
 drivers/char/hvc_console.c                         |    2 -
 drivers/char/hvc_vio.c                             |    4 +-
 drivers/char/hvsi.c                                |    3 +-
 drivers/macintosh/macio_asic.c                     |    6 +-
 drivers/macintosh/therm_windtunnel.c               |    4 +-
 drivers/ps3/ps3stor_lib.c                          |   65 +-
 drivers/video/ps3fb.c                              |    2 +-
 include/asm-generic/dma-mapping-common.h           |    6 -
 include/linux/dma-mapping.h                        |    6 +-
 include/linux/pci_ids.h                            |    1 +
 include/linux/swiotlb.h                            |   11 -
 kernel/gcov/Kconfig                                |    2 +-
 lib/Kconfig.debug                                  |    2 +-
 lib/swiotlb.c                                      |  124 +--
 244 files changed, 12124 insertions(+), 3266 deletions(-)
 create mode 100644 arch/powerpc/boot/cuboot-hotfoot.c
 create mode 100644 arch/powerpc/boot/cuboot-kilauea.c
 create mode 100644 arch/powerpc/boot/dts/eiger.dts
 create mode 100644 arch/powerpc/boot/dts/hotfoot.dts
 create mode 100644 arch/powerpc/boot/dts/mpc8377_wlan.dts
 create mode 100644 arch/powerpc/boot/dts/mpc8536ds_36b.dts
 create mode 100644 arch/powerpc/boot/dts/p2020rdb.dts
 create mode 100644 arch/powerpc/boot/ppcboot-hotfoot.h
 create mode 100644 arch/powerpc/configs/44x/eiger_defconfig
 create mode 100644 arch/powerpc/include/asm/exception-64e.h
 rename arch/powerpc/include/asm/{exception.h => exception-64s.h} (94%)
 create mode 100644 arch/powerpc/include/asm/pte-book3e.h
 create mode 100644 arch/powerpc/kernel/exceptions-64e.S
 create mode 100644 arch/powerpc/kernel/pci_of_scan.c
 create mode 100644 arch/powerpc/kernel/perf_callchain.c
 create mode 100644 arch/powerpc/mm/tlb_low_64e.S
 create mode 100644 arch/powerpc/platforms/85xx/mpc85xx_rdb.c
 delete mode 100644 arch/powerpc/platforms/cell/spufs/sputrace.c
 create mode 100644 arch/powerpc/platforms/cell/spufs/sputrace.h
 delete mode 100644 arch/sparc/kernel/dma.h


