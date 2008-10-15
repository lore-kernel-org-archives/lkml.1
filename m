Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbYJOBRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbYJOBRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 21:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYJOBRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 21:17:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:49931 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbYJOBRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 21:17:09 -0400
Subject: [git pull] Please pull from powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 12:16:36 +1100
Message-Id: <1224033396.8157.386.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's the powerpc main batch for 2.6.28. It's a bit late mostly due to both
Paul and I being distracted by other things at the wrong time, and me trying
to run some more tests (& fixing regressions) before sending it all to you.

There's a bunch of stuff in there, most of it in arch/powerpc, but you'll
notice a few things touching files out of it. Here's a short summary of
these:

 - These are just a trivial change of CONFIG_PPC_MERGE -> CONFIG_PPC
since the former is no longer useful now that arch/ppc is gone

	drivers/block/floppy.c
	drivers/char/ipmi/ipmi_si_intf.c
	drivers/i2c/busses/i2c-pca-isa.c
	drivers/input/serio/i8042-io.h
	drivers/pnp/isapnp/core.c
	drivers/pnp/pnpbios/core.c

 - Some other trivial #include fixes for the move of of_device.h from
   asm/ to linux/

	drivers/hwmon/ams/ams.h
	sound/aoa/soundbus/soundbus.h

 - The math-emu changes are two fold. Some trivial compile warning
   fixes and some changes to improve exception reporting acked by
   davem. Now powerpc uses the generic math-emu code too

 - Some powerpc specific drivers. They should all have appropriate acks
   with the possible exception of the pata_of_platform.c one which I
   merged in while jeff was away and hvc_console for which I believe
   we are still maintainers of.

 - Some drivers/of additions that should (hopefully) be of no impact to
   other users of the OF stuff

 - a procfs change removing our obsolete ppc_htab stuff

And that should be it, hopefully I didn't miss anything :-) 

I did a merge with your tree to fixup a couple of conflicts so it should
be a smooth merge on your side.

Cheers,
Ben.

The following changes since commit 8acd3a60bcca17c6d89c73cee3ad6057eb83ba1e:
  Linus Torvalds (1):
        Merge branch 'for-2.6.28' of git://linux-nfs.org/~bfields/linux

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

Adrian Bunk (1):
      powerpc: Use bcd2bin/bin2bcd

Anton Vorontsov (12):
      powerpc/83xx: mpc836x_mds: add support for the nor flash
      powerpc/fsl_soc: remove mpc83xx_wdt code
      OF: add fsl,mcu-mpc8349emitx to the exception list
      powerpc: Fix no interrupt handling in pata_of_platform
      of: Add new helper of_parse_phandles_with_args()
      powerpc/QE: move QE_GPIO Kconfig symbol into the platforms/Kconfig
      powerpc/83xx: don't probe broken PCI on mpc837x_mds boards
      powerpc/83xx: add DS1374 RTC support for the MPC837xE-MDS boards
      OF: add fsl,mcu-mpc8349emitx to the exception list
      i2c: MPC8349E-mITX Power Management and GPIO expander driver
      powerpc/83xx: add NAND support for the MPC8360E-RDK boards
      powerpc: fix fsl_upm nand driver modular build

Becky Bruce (10):
      powerpc: Rename PTE_SIZE to HPTE_SIZE
      powerpc/85xx: fix build warning, remove silly cast
      cpm_uart: Pass actual dev ptr to dma_* in ucc and cpm_uart serial
      powerpc: Rename dma_64.c to dma.c
      powerpc: Move iommu dma ops from dma.c to dma-iommu.c
      powerpc: Drop archdata numa_node
      powerpc: Merge 32 and 64-bit dma code
      powerpc: Make dma_addr_t a u64 if CONFIG_PHYS_64BIT is set
      POWERPC: Allow 32-bit hashed pgtable code to support 36-bit physical
      powerpc: Drop redundant machine type print in show_cpuinfo

Benjamin Herrenschmidt (16):
      powerpc: Turn get/set_hard_smp_proccessor_id into inlines
      powerpc: Expose PMCs & cache topology in sysfs on 32-bit
      Merge commit 'kumar/kumar-dma'
      Merge commit 'kumar/kumar-mmu'
      Merge commit 'jwb/jwb-next'
      powerpc: Fix sysfs pci mmap on 32-bit machines with 64-bit PCI
      Merge commit 'jk/jk-merge'
      Merge commit 'gcl/gcl-next'
      Merge commit 'kumar/kumar-next'
      powerpc: Fix DMA offset for non-coherent DMA
      powerpc/pci: Improve detection of unassigned bridge resources
      powerpc: Fix link errors on 32-bit machines using legacy DMA
      powerpc: Fix 32-bit SMP boot on CHRP
      powerpc/chrp: Fix detection of Python PCI host bridge on IBM CHRPs
      powerpc: Fix CHRP PCI config access for indirect_pci
      Merge commit 'origin'

Chandru (1):
      powerpc: Add support for dynamic reconfiguration memory in kexec/kdump kernels

Christian Borntraeger (1):
      hvc_console: Fix free_irq in spinlocked section

Christoph Hellwig (1):
      powerpc: Use sys_pause for 32-bit pause entry point

David Gibson (3):
      powerpc: Update in-kernel dtc and libfdt to version 1.2.0
      powerpc: Clean up hugepage pagetable allocation for powerpc with 16G pages
      powerpc: Get USE_STRICT_MM_TYPECHECKS working again

Geert Uytterhoeven (2):
      powerpc: Remove remains of /proc/ppc_htab
      powerpc: Remove outdated Documentation/powerpc/smp.txt

Grant Likely (2):
      powerpc/mpc5200: fix build warnings on mpc52xx_psc_spi driver
      powerpc/of-bindings: Don't support linux,<modalias> "compatible" values

Harvey Harrison (2):
      powerpc: Use the common ascii hex helpers
      powerpc: Replace __FUNCTION__ with __func__

Heiko Schocher (2):
      powerpc: Add support for the MPC852 based mgsuvd board from keymile.
      powerpc: Add support for mpc8247 based board MGCOGE from keymile.

Ilya Yanok (1):
      powerpc/4xx: Necessary fixes to PCI for 4GB RAM size

Jeremy Kerr (2):
      powerpc/spufs: set nlink count for spufs root correctly
      powerpc/spufs: use inc_nlink

Jochen Friedrich (1):
      powerpc/cpm1: Fix race condition in CPM1 GPIO library.

Johann Felix Soden (1):
      powerpc/iseries: Remove unused variable in viodasd.c

Johannes Berg (2):
      powerpc: Fix 64-bit hibernation with 64k pages
      powerpc: Enforce sane MAX_ORDER

John Rigby (3):
      powerpc/fsl: Hide MPC5121 pci bridge.
      powerpc: 83xx: pci: Remove need for get_immrbase from mpc83xx_add_bridge.
      powerpc/5121: Add PCI support.

Jon Tollefson (1):
      powerpc: Reserve in bootmem lmb reserved regions that cross NUMA nodes

Josh Boyer (13):
      powerpc/44x: Add PowerPC 44x simple platform support
      powerpc/44x: Migrate Bamboo support to ppc44x_simple
      powerpc/44x: Migrate Canyonlands support to ppc44x_simple
      powerpc/44x: Migrate Katmai support to ppc44x_simple
      powerpc/44x: Migrate Rainier support to ppc44x_simple
      powerpc/44x: Migrate Sequoia support to ppc44x_simple
      powerpc/44x: Migrate Taishan support to ppc44x_simple
      powerpc/44x: Add explicit support for AMCC Glacier
      powerpc/44x: Add explicit Yosemite support
      ibm_newemac: Allow the "no flow control" EMAC feature to work
      ibm_newemac: Introduce mal_has_feature
      ibm_newemac: MAL support for PowerPC 405EZ
      powerpc: Remove old Makefile workaround for arch/ppc

Josh Poimboeuf (1):
      powerpc: Fix error path in kernel_thread function

Kou Ishizaki (1):
      powerpc/spufs: add a missing mutex_unlock

Kumar Gala (16):
      serial/cpm_uart: Remove dead Kconfig options
      math-emu: Fix compiler warnings
      math-emu: Add support for reporting exact invalid exception
      powerpc: Fix build warnings introduced by PMC support on 32-bit
      powerpc/fsl-booke: Fixup 64-bit PTE reading for SMP support
      powerpc: convert CONFIG_PPC_MERGE to CONFIG_PPC for legacy io checks
      powerpc/83xx: Add missing cell-index to dma-channel device nodes
      powerpc/86xx: Introduce a generic mpc86xx_defconfig
      powerpc: Move 8xxx GPIO Kconfig under the platform menu
      powerpc: Introduce local (non-broadcast) forms of tlb invalidates
      powerpc: Fixes for CONFIG_PTE_64BIT for SMP support
      powerpc/mm: Implement _PAGE_SPECIAL & pte_special() for 32-bit
      serial/mpc52xx_uart: remove code associated with !CONFIG_PPC_MERGE
      powerpc/math-emu: Use kernel generic math-emu code
      powerpc: Make ppc32 respect the boot cpu id for !CONFIG_SMP
      powerpc/85xx: Wire up RTC interrupt on MPC8536DS

Mark Nelson (2):
      powerpc: Add new CPU feature: CPU_FTR_CP_USE_DCBTZ
      powerpc: New copy_4K_page()

Martin Langer (1):
      powerpc: Fix major revision number for Freescale cores

Martyn Welch (5):
      powerpc: Board support for GE Fanuc SBC610
      powerpc: Default configuration for GE Fanuc SBC610
      powerpc: Correct USB support for GE Fanuc SBC610
      powerpc: GE Fanuc's FPGA based PIC controller on the SBC610
      powerpc: FPGA support for GE Fanuc SBC610

Matthias Fuchs (2):
      powerpc/44x: Add hwmon support to Sequoia device tree
      powerpc/4xx: Allow 4xx PCI bridge to be disabled via device tree

Michael Ellerman (5):
      powerpc: Streamline ret_from_except_lite for non-iSeries platforms
      powerpc: fsl_msi doesn't need it's own of_node
      powerpc: Split-out common MSI bitmap logic into msi_bitmap.c
      powerpc: Convert the FSL MSI code to use msi_bitmap
      powerpc: Convert the MPIC MSI code to use msi_bitmap

Milton Miller (14):
      powerpc/xics: EOI unmapped irqs after disabling them
      powerpc/xics: Update default_server during migrate_irqs_away
      powerpc/xics: Consolidate ipi message encode and decode
      powerpc/xics: Rearrange file to group code by function
      powerpc/xics: Change *_xirr_info_set() prototype to avoid casts
      powerpc/xics: Trim #include list
      powerpc/xics: Initialization code cleanups
      powerpc/xics: Factor out cpu joining/unjoining the GIQ
      powerpc/xics: EOI xics ipi by hand in kexec
      powerpc/xics: Mark xics IPI interrupt as per-cpu
      powerpc/xics: Make printk format strings fit on one line
      powerpc/xics: Reduce and comment xics IPI use of memory barriers
      powerpc/smp: No need to set_need_resched when getting a resched IPI
      powerpc: remove non-dependent load fsl_booke PTE_64BIT

Nathan Fontenot (2):
      powerpc: Check rc of notifier chain for memory remove
      powerpc: Oops in pseries_lmb_remove()

Nathan Lynch (1):
      powerpc: Remove redundant sysfs_remove_file calls for cache info

Paul Gortmaker (1):
      powerpc/sbc8560: fix compile warning on CPM pin array

Paul Mackerras (8):
      Merge branch 'linux-2.6'
      powerpc: Rearrange head_64.S to move interrupt handler code to the beginning
      powerpc: Make it possible to move the interrupt handlers away from the kernel
      powerpc: Use LOAD_REG_IMMEDIATE only for constants on 64-bit
      powerpc: Make the 64-bit kernel as a position-independent executable
      Merge branch 'next' of ssh://master.kernel.org/.../jwboyer/powerpc-4xx
      Merge branch 'powerpc-next' of master.kernel.org:/.../galak/powerpc
      powerpc: Sync RPA note in zImage with kernel's RPA note

Peter Korsgaard (1):
      powerpc: gpio driver for mpc8349/8572/8610 and compatible

Roel Kluin (1):
      powerpc/cell/oprofile: Fix test on overlay_tbl_offset in vma_map

Roland Dreier (1):
      powerpc: Avoid integer overflow in page_is_ram()

Sebastian Andrzej Siewior (1):
      powerpc: Reflect the used arguments in machine_init() prototype

Sebastien Dugue (3):
      powerpc: Separate the irq radix tree insertion and lookup
      powerpc: Make the irq reverse mapping radix tree lockless
      powerpc: Ignore generated vmlinux.lds in git

Stephen Rothwell (4):
      powerpc: Remove include of linux/of_platform.h from asm/of_platform.h
      hotplug/rpaphp: Remove unused error path code
      powerpc/drivers: Use linux/of_device.h instead of asm/of_device.h
      powerpc: Remove include of linux/of_device.h from asm/of_device.h

Thiemo Seufer (1):
      powerpc: Enforce a non-spe kernel build even on broken compilers

Timur Tabi (7):
      powerpc: add SSI-to-DMA properties to Freescale MPC8610 HPCD device tree
      powerpc: Remove CHRP and PMAC support from FSL defconfigs
      powerpc: make Freescale QE support a selectable Kconfig option
      powerpc: remove support for bootmem-allocated memory for the DIU driver
      powerpc: disable CHRP and PMAC support in various defconfigs
      powerpc: document the "fsl,ssi-dma-channel" compatible property
      powerpc: reserve two DMA channels for audio in MPC8610 HPCD device tree

Tirumala R Marri (1):
      powerpc/44x: AMCC PPC460GT/EX PCI-E de-emphasis adjustment fix

Tony Breeds (4):
      powerpc: Guard htab_dt_scan_hugepage_blocks appropriately
      powerpc: Guard from_rtc_time() in platforms/powermac/time.c
      powerpc: Guard print_device_node_tree() with #if 0
      powerpc/mpc5200: Silence warnings in arch/powerpc/platforms/52xx/mpc52xx_pci.c

Victor Gallardo (4):
      ibm_newemac: Add support for GPCS, SGMII and M88E1112 PHY
      powerpc/44x: Add AMCC Arches eval board support
      powerpc/44x: Add AMCC Arches DTS
      powerpc/44x: Add AMCC Arches defconfig file

Vitaly Mayatskikh (1):
      powerpc: Honor O_NONBLOCK flag when reading RTAS log

Wolfgang Grandegger (1):
      i2c-mpc: suppress I2C device probing

Wolfram Sang (1):
      powerpc/mpc5200: trivial printk-fixes in mpc52xx_common

roel kluin (1):
      powerpc: Fix duplicate test of MACIO_FLAG_SCCB_ON

 Documentation/powerpc/00-INDEX                     |    4 -
 .../powerpc/dts-bindings/fsl/83xx-512x-pci.txt     |   40 +
 .../powerpc/dts-bindings/fsl/8xxx_gpio.txt         |   40 +
 Documentation/powerpc/dts-bindings/fsl/dma.txt     |   13 +-
 Documentation/powerpc/dts-bindings/fsl/ssi.txt     |   23 +
 Documentation/powerpc/ppc_htab.txt                 |  118 ---
 Documentation/powerpc/smp.txt                      |   34 -
 arch/powerpc/Kconfig                               |   16 +
 arch/powerpc/Kconfig.debug                         |    5 +
 arch/powerpc/Makefile                              |    7 +-
 arch/powerpc/boot/Makefile                         |    3 +
 arch/powerpc/boot/addnote.c                        |  144 +++-
 arch/powerpc/boot/dtc-src/Makefile.dtc             |   18 +-
 arch/powerpc/boot/dtc-src/checks.c                 |  305 ++-----
 arch/powerpc/boot/dtc-src/data.c                   |   62 +-
 arch/powerpc/boot/dtc-src/dtc-lexer.l              |  120 ++--
 arch/powerpc/boot/dtc-src/dtc-lexer.lex.c_shipped  |  445 +++++-----
 arch/powerpc/boot/dtc-src/dtc-parser.tab.c_shipped |  387 +++++----
 arch/powerpc/boot/dtc-src/dtc-parser.tab.h_shipped |   12 +-
 arch/powerpc/boot/dtc-src/dtc-parser.y             |   67 ++-
 arch/powerpc/boot/dtc-src/dtc.c                    |   41 +-
 arch/powerpc/boot/dtc-src/dtc.h                    |   43 +-
 arch/powerpc/boot/dtc-src/flattree.c               |  232 ++----
 arch/powerpc/boot/dtc-src/fstree.c                 |    8 +-
 arch/powerpc/boot/dtc-src/libfdt_env.h             |   23 +
 arch/powerpc/boot/dtc-src/livetree.c               |    9 +-
 arch/powerpc/boot/dtc-src/srcpos.c                 |  121 ++--
 arch/powerpc/boot/dtc-src/srcpos.h                 |   30 +-
 arch/powerpc/boot/dtc-src/treesource.c             |   15 +-
 arch/powerpc/boot/dtc-src/version_gen.h            |    2 +-
 arch/powerpc/boot/dts/arches.dts                   |  293 +++++++
 arch/powerpc/boot/dts/asp834x-redboot.dts          |    4 +
 arch/powerpc/boot/dts/gef_sbc610.dts               |  293 +++++++
 arch/powerpc/boot/dts/glacier.dts                  |    2 +-
 arch/powerpc/boot/dts/mgcoge.dts                   |  174 ++++
 arch/powerpc/boot/dts/mgsuvd.dts                   |  163 ++++
 arch/powerpc/boot/dts/mpc5121ads.dts               |    3 +-
 arch/powerpc/boot/dts/mpc8313erdb.dts              |    7 +-
 arch/powerpc/boot/dts/mpc8315erdb.dts              |    7 +-
 arch/powerpc/boot/dts/mpc832x_mds.dts              |    7 +-
 arch/powerpc/boot/dts/mpc832x_rdb.dts              |    7 +-
 arch/powerpc/boot/dts/mpc8349emitx.dts             |   10 +-
 arch/powerpc/boot/dts/mpc8349emitxgp.dts           |    7 +-
 arch/powerpc/boot/dts/mpc834x_mds.dts              |   10 +-
 arch/powerpc/boot/dts/mpc836x_mds.dts              |   30 +-
 arch/powerpc/boot/dts/mpc836x_rdk.dts              |   19 +-
 arch/powerpc/boot/dts/mpc8377_mds.dts              |   14 +-
 arch/powerpc/boot/dts/mpc8377_rdb.dts              |    7 +-
 arch/powerpc/boot/dts/mpc8378_mds.dts              |   14 +-
 arch/powerpc/boot/dts/mpc8378_rdb.dts              |    7 +-
 arch/powerpc/boot/dts/mpc8379_mds.dts              |   14 +-
 arch/powerpc/boot/dts/mpc8379_rdb.dts              |    7 +-
 arch/powerpc/boot/dts/mpc8536ds.dts                |    2 +
 arch/powerpc/boot/dts/mpc8610_hpcd.dts             |   12 +-
 arch/powerpc/boot/dts/sbc8349.dts                  |    7 +-
 arch/powerpc/boot/dts/sequoia.dts                  |    9 +
 arch/powerpc/boot/dts/yosemite.dts                 |    2 +-
 arch/powerpc/boot/elf_util.c                       |    6 +-
 arch/powerpc/boot/libfdt/Makefile.libfdt           |    8 +-
 arch/powerpc/boot/libfdt/fdt.c                     |   61 ++-
 arch/powerpc/boot/libfdt/fdt_ro.c                  |  329 +++-----
 arch/powerpc/boot/libfdt/fdt_rw.c                  |  200 +++--
 arch/powerpc/boot/libfdt/fdt_strerror.c            |   34 +-
 arch/powerpc/boot/libfdt/fdt_sw.c                  |   55 +-
 arch/powerpc/boot/libfdt/fdt_wip.c                 |    9 +-
 arch/powerpc/boot/libfdt/libfdt.h                  |  383 ++++++++-
 arch/powerpc/boot/libfdt/libfdt_internal.h         |   24 +-
 arch/powerpc/boot/libfdt_env.h                     |    1 +
 arch/powerpc/boot/wrapper                          |    4 +-
 arch/powerpc/configs/44x/arches_defconfig          |  767 +++++++++++++++++
 arch/powerpc/configs/83xx/asp8347_defconfig        |    4 +-
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig    |    4 +-
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig    |    4 +-
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig    |    4 +-
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig    |    4 +-
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig    |    4 +-
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig  |    4 +-
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig    |    4 +-
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig    |   83 ++-
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig    |    4 +-
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig    |    4 +-
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig    |    4 +-
 arch/powerpc/configs/83xx/sbc834x_defconfig        |    4 +-
 .../gef_sbc610_defconfig}                          |  568 ++++++++-----
 .../configs/{ => 86xx}/mpc8610_hpcd_defconfig      |    4 +-
 .../configs/{ => 86xx}/mpc8641_hpcn_defconfig      |    4 +-
 arch/powerpc/configs/{ => 86xx}/sbc8641d_defconfig |    4 +-
 arch/powerpc/configs/ep8248e_defconfig             |    4 +-
 arch/powerpc/configs/mgcoge_defconfig              |  900 ++++++++++++++++++++
 arch/powerpc/configs/mgsuvd_defconfig              |  872 +++++++++++++++++++
 arch/powerpc/configs/mpc8272_ads_defconfig         |    4 +-
 arch/powerpc/configs/mpc83xx_defconfig             |    4 +-
 .../{mpc8641_hpcn_defconfig => mpc86xx_defconfig}  |   44 +-
 arch/powerpc/configs/pq2fads_defconfig             |    4 +-
 arch/powerpc/include/asm/cputable.h                |   10 +-
 arch/powerpc/include/asm/dcr-regs.h                |    7 +
 arch/powerpc/include/asm/device.h                  |    3 -
 arch/powerpc/include/asm/dma-mapping.h             |  187 ++---
 arch/powerpc/include/asm/exception.h               |   42 +-
 arch/powerpc/include/asm/fsl_lbc.h                 |   48 +-
 arch/powerpc/include/asm/highmem.h                 |    2 +-
 arch/powerpc/include/asm/io.h                      |    2 +-
 arch/powerpc/include/asm/irq.h                     |   18 +-
 arch/powerpc/include/asm/machdep.h                 |    5 +-
 arch/powerpc/include/asm/mman.h                    |    2 +-
 arch/powerpc/include/asm/mmu-hash64.h              |    2 +-
 arch/powerpc/include/asm/mpic.h                    |    4 +-
 arch/powerpc/include/asm/msi_bitmap.h              |   35 +
 arch/powerpc/include/asm/of_device.h               |    3 -
 arch/powerpc/include/asm/of_platform.h             |    3 -
 arch/powerpc/include/asm/paca.h                    |    2 +
 arch/powerpc/include/asm/page.h                    |   14 +-
 arch/powerpc/include/asm/page_32.h                 |    8 +-
 arch/powerpc/include/asm/pci.h                     |   14 +-
 arch/powerpc/include/asm/pgtable-ppc32.h           |   72 ++-
 arch/powerpc/include/asm/pgtable-ppc64.h           |   12 +-
 arch/powerpc/include/asm/ppc_asm.h                 |    2 +-
 arch/powerpc/include/asm/reg_booke.h               |    7 +
 arch/powerpc/include/asm/sections.h                |    6 +
 .../{math-emu => include/asm}/sfp-machine.h        |  114 +--
 arch/powerpc/include/asm/smp.h                     |   42 +-
 arch/powerpc/include/asm/systbl.h                  |    2 +-
 arch/powerpc/include/asm/tlbflush.h                |   13 +-
 arch/powerpc/include/asm/types.h                   |    2 +-
 arch/powerpc/kernel/.gitignore                     |    1 +
 arch/powerpc/kernel/Makefile                       |    9 +-
 arch/powerpc/kernel/asm-offsets.c                  |    3 +
 arch/powerpc/kernel/btext.c                        |   34 +-
 arch/powerpc/kernel/cpu_setup_ppc970.S             |    4 +-
 arch/powerpc/kernel/cputable.c                     |   24 +
 arch/powerpc/kernel/dma-iommu.c                    |  103 +++
 arch/powerpc/kernel/dma.c                          |  131 +++
 arch/powerpc/kernel/dma_64.c                       |  200 -----
 arch/powerpc/kernel/entry_64.S                     |   69 +-
 arch/powerpc/kernel/head_32.S                      |   10 +-
 arch/powerpc/kernel/head_64.S                      |  473 ++++++-----
 arch/powerpc/kernel/head_fsl_booke.S               |   26 +-
 arch/powerpc/kernel/irq.c                          |  169 ++--
 arch/powerpc/kernel/lparcfg.c                      |    8 +-
 arch/powerpc/kernel/misc.S                         |   10 +-
 arch/powerpc/kernel/misc_32.S                      |   62 ++-
 arch/powerpc/kernel/misc_64.S                      |    8 +-
 arch/powerpc/kernel/of_device.c                    |    2 +-
 arch/powerpc/kernel/paca.c                         |    3 +
 arch/powerpc/kernel/pci-common.c                   |  216 ++++--
 arch/powerpc/kernel/pci_32.c                       |   18 +-
 arch/powerpc/kernel/pci_64.c                       |   49 --
 arch/powerpc/kernel/ppc_ksyms.c                    |    3 +
 arch/powerpc/kernel/prom.c                         |   43 +-
 arch/powerpc/kernel/prom_init.c                    |   29 +-
 arch/powerpc/kernel/reloc_64.S                     |   87 ++
 arch/powerpc/kernel/setup-common.c                 |   17 +-
 arch/powerpc/kernel/setup_32.c                     |   13 +-
 arch/powerpc/kernel/setup_64.c                     |    9 +-
 arch/powerpc/kernel/smp.c                          |    3 +-
 arch/powerpc/kernel/swsusp_asm64.S                 |    2 +-
 arch/powerpc/kernel/sys_ppc32.c                    |    8 -
 arch/powerpc/kernel/sysfs.c                        |  119 ++-
 arch/powerpc/kernel/vio.c                          |    2 +-
 arch/powerpc/kernel/vmlinux.lds.S                  |   18 +
 arch/powerpc/lib/copypage_64.S                     |  198 ++---
 arch/powerpc/lib/dma-noncoherent.c                 |    2 +-
 arch/powerpc/math-emu/Makefile                     |    7 +-
 arch/powerpc/math-emu/double.h                     |  129 ---
 arch/powerpc/math-emu/fadd.c                       |   17 +-
 arch/powerpc/math-emu/fadds.c                      |   20 +-
 arch/powerpc/math-emu/fcmpo.c                      |   10 +-
 arch/powerpc/math-emu/fcmpu.c                      |   10 +-
 arch/powerpc/math-emu/fctiw.c                      |    8 +-
 arch/powerpc/math-emu/fctiwz.c                     |    8 +-
 arch/powerpc/math-emu/fdiv.c                       |   14 +-
 arch/powerpc/math-emu/fdivs.c                      |   16 +-
 arch/powerpc/math-emu/fmadd.c                      |   16 +-
 arch/powerpc/math-emu/fmadds.c                     |   18 +-
 arch/powerpc/math-emu/fmsub.c                      |   16 +-
 arch/powerpc/math-emu/fmsubs.c                     |   18 +-
 arch/powerpc/math-emu/fmul.c                       |   14 +-
 arch/powerpc/math-emu/fmuls.c                      |   16 +-
 arch/powerpc/math-emu/fnmadd.c                     |   16 +-
 arch/powerpc/math-emu/fnmadds.c                    |   18 +-
 arch/powerpc/math-emu/fnmsub.c                     |   16 +-
 arch/powerpc/math-emu/fnmsubs.c                    |   18 +-
 arch/powerpc/math-emu/frsp.c                       |   14 +-
 arch/powerpc/math-emu/fsel.c                       |    8 +-
 arch/powerpc/math-emu/fsqrt.c                      |   12 +-
 arch/powerpc/math-emu/fsqrts.c                     |   14 +-
 arch/powerpc/math-emu/fsub.c                       |   14 +-
 arch/powerpc/math-emu/fsubs.c                      |   16 +-
 arch/powerpc/math-emu/lfd.c                        |    4 +-
 arch/powerpc/math-emu/lfs.c                        |   19 +-
 arch/powerpc/math-emu/math.c                       |    8 +-
 arch/powerpc/math-emu/mcrfs.c                      |    3 +-
 arch/powerpc/math-emu/mffs.c                       |    3 +-
 arch/powerpc/math-emu/mtfsb0.c                     |    3 +-
 arch/powerpc/math-emu/mtfsb1.c                     |    3 +-
 arch/powerpc/math-emu/mtfsf.c                      |   20 +-
 arch/powerpc/math-emu/mtfsfi.c                     |    3 +-
 arch/powerpc/math-emu/op-1.h                       |  245 ------
 arch/powerpc/math-emu/op-2.h                       |  434 ----------
 arch/powerpc/math-emu/op-4.h                       |  317 -------
 arch/powerpc/math-emu/op-common.h                  |  688 ---------------
 arch/powerpc/math-emu/single.h                     |   66 --
 arch/powerpc/math-emu/soft-fp.h                    |  104 ---
 arch/powerpc/math-emu/stfs.c                       |   19 +-
 arch/powerpc/math-emu/types.c                      |   51 --
 arch/powerpc/math-emu/udivmodti4.c                 |    2 +-
 arch/powerpc/mm/fsl_booke_mmu.c                    |    5 +-
 arch/powerpc/mm/gup.c                              |    7 +-
 arch/powerpc/mm/hash_low_32.S                      |  122 ++-
 arch/powerpc/mm/hash_utils_64.c                    |    8 +-
 arch/powerpc/mm/hugetlbpage.c                      |   59 +-
 arch/powerpc/mm/init_64.c                          |    4 +-
 arch/powerpc/mm/mem.c                              |    5 +-
 arch/powerpc/mm/numa.c                             |  185 +++-
 arch/powerpc/mm/pgtable_32.c                       |    4 +-
 arch/powerpc/mm/tlb_32.c                           |    1 +
 arch/powerpc/oprofile/cell/vma_map.c               |    2 +-
 arch/powerpc/oprofile/op_model_power4.c            |    4 +-
 arch/powerpc/platforms/44x/Kconfig                 |   42 +-
 arch/powerpc/platforms/44x/Makefile                |    8 +-
 arch/powerpc/platforms/44x/bamboo.c                |   62 --
 arch/powerpc/platforms/44x/canyonlands.c           |   63 --
 arch/powerpc/platforms/44x/katmai.c                |   62 --
 arch/powerpc/platforms/44x/ppc44x_simple.c         |   88 ++
 arch/powerpc/platforms/44x/rainier.c               |   62 --
 arch/powerpc/platforms/44x/sequoia.c               |   63 --
 arch/powerpc/platforms/44x/taishan.c               |   72 --
 arch/powerpc/platforms/512x/Kconfig                |    2 +
 arch/powerpc/platforms/512x/mpc5121_ads.c          |   10 +
 arch/powerpc/platforms/52xx/mpc52xx_common.c       |    5 +-
 arch/powerpc/platforms/52xx/mpc52xx_pci.c          |   13 +-
 arch/powerpc/platforms/82xx/Kconfig                |    8 +
 arch/powerpc/platforms/82xx/Makefile               |    1 +
 arch/powerpc/platforms/82xx/mgcoge.c               |  129 +++
 arch/powerpc/platforms/83xx/Kconfig                |    5 -
 arch/powerpc/platforms/83xx/mpc837x_mds.c          |    8 +-
 arch/powerpc/platforms/85xx/Kconfig                |    1 -
 arch/powerpc/platforms/85xx/mpc85xx_ads.c          |    1 -
 arch/powerpc/platforms/85xx/sbc8560.c              |    3 +-
 arch/powerpc/platforms/86xx/Kconfig                |    9 +-
 arch/powerpc/platforms/86xx/Makefile               |    1 +
 arch/powerpc/platforms/86xx/gef_pic.c              |  258 ++++++
 arch/powerpc/platforms/86xx/gef_pic.h              |   11 +
 arch/powerpc/platforms/86xx/gef_sbc610.c           |  221 +++++
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c         |    1 -
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c         |    8 -
 arch/powerpc/platforms/86xx/sbc8641d.c             |    8 -
 arch/powerpc/platforms/8xx/Kconfig                 |    6 +
 arch/powerpc/platforms/8xx/Makefile                |    1 +
 arch/powerpc/platforms/8xx/mgsuvd.c                |   92 ++
 arch/powerpc/platforms/Kconfig                     |   21 +-
 arch/powerpc/platforms/Kconfig.cputype             |   17 +-
 arch/powerpc/platforms/cell/iommu.c                |    6 +-
 arch/powerpc/platforms/cell/spufs/inode.c          |   11 +-
 arch/powerpc/platforms/chrp/pci.c                  |    4 +-
 arch/powerpc/platforms/chrp/time.c                 |   24 +-
 arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c  |    1 -
 arch/powerpc/platforms/iseries/exception.S         |   23 +-
 arch/powerpc/platforms/iseries/mf.c                |   26 +-
 arch/powerpc/platforms/maple/time.c                |   24 +-
 arch/powerpc/platforms/powermac/feature.c          |    2 +-
 arch/powerpc/platforms/powermac/smp.c              |    4 +-
 arch/powerpc/platforms/powermac/time.c             |    3 +
 arch/powerpc/platforms/ps3/system-bus.c            |    2 +-
 arch/powerpc/platforms/pseries/cmm.c               |    4 +-
 arch/powerpc/platforms/pseries/eeh_driver.c        |    2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |    2 +-
 arch/powerpc/platforms/pseries/reconfig.c          |    6 +-
 arch/powerpc/platforms/pseries/rtasd.c             |   26 +-
 arch/powerpc/platforms/pseries/smp.c               |   32 +-
 arch/powerpc/platforms/pseries/xics.c              |  550 +++++++------
 arch/powerpc/platforms/pseries/xics.h              |   12 +-
 arch/powerpc/sysdev/Kconfig                        |    6 +
 arch/powerpc/sysdev/Makefile                       |    5 +-
 arch/powerpc/sysdev/cpm1.c                         |   74 ++-
 arch/powerpc/sysdev/fsl_lbc.c                      |   53 ++-
 arch/powerpc/sysdev/fsl_msi.c                      |  109 +--
 arch/powerpc/sysdev/fsl_msi.h                      |    8 +-
 arch/powerpc/sysdev/fsl_pci.c                      |   58 +-
 arch/powerpc/sysdev/fsl_soc.c                      |   85 +--
 arch/powerpc/sysdev/fsl_soc.h                      |    8 -
 arch/powerpc/sysdev/mpc8xxx_gpio.c                 |  171 ++++
 arch/powerpc/sysdev/mpic.h                         |    2 -
 arch/powerpc/sysdev/mpic_msi.c                     |  123 +---
 arch/powerpc/sysdev/mpic_pasemi_msi.c              |   24 +-
 arch/powerpc/sysdev/mpic_u3msi.c                   |   22 +-
 arch/powerpc/sysdev/msi_bitmap.c                   |  247 ++++++
 arch/powerpc/sysdev/ppc4xx_pci.c                   |   32 +-
 arch/powerpc/sysdev/qe_lib/Kconfig                 |    9 -
 drivers/ata/pata_of_platform.c                     |    2 +-
 drivers/block/floppy.c                             |    2 +-
 drivers/block/viodasd.c                            |    3 -
 drivers/char/hvc_console.c                         |   10 +-
 drivers/char/ipmi/ipmi_si_intf.c                   |    2 +-
 drivers/hwmon/ams/ams.h                            |    2 +-
 drivers/i2c/busses/i2c-mpc.c                       |    1 -
 drivers/i2c/busses/i2c-pca-isa.c                   |    2 +-
 drivers/i2c/chips/Kconfig                          |   11 +
 drivers/i2c/chips/Makefile                         |    1 +
 drivers/i2c/chips/mcu_mpc8349emitx.c               |  209 +++++
 drivers/input/serio/i8042-io.h                     |    2 +-
 drivers/net/ibm_newemac/Kconfig                    |   12 +
 drivers/net/ibm_newemac/core.c                     |   42 +-
 drivers/net/ibm_newemac/core.h                     |    6 +
 drivers/net/ibm_newemac/mal.c                      |   60 ++-
 drivers/net/ibm_newemac/mal.h                      |   34 +
 drivers/net/ibm_newemac/phy.c                      |   84 ++
 drivers/net/ibm_newemac/phy.h                      |    2 +
 drivers/of/base.c                                  |  136 +++-
 drivers/of/gpio.c                                  |   81 +--
 drivers/pci/hotplug/rpaphp_slot.c                  |    4 -
 drivers/pnp/isapnp/core.c                          |    2 +-
 drivers/pnp/pnpbios/core.c                         |    4 +-
 drivers/serial/Kconfig                             |   36 -
 drivers/serial/cpm_uart/cpm_uart_core.c            |    3 +
 drivers/serial/cpm_uart/cpm_uart_cpm1.c            |    6 +-
 drivers/serial/cpm_uart/cpm_uart_cpm2.c            |    6 +-
 drivers/serial/mpc52xx_uart.c                      |  181 +----
 drivers/serial/ucc_uart.c                          |    4 +-
 drivers/spi/mpc52xx_psc_spi.c                      |    6 +-
 include/linux/of.h                                 |    3 +
 include/linux/proc_fs.h                            |    1 -
 include/math-emu/op-2.h                            |    2 +-
 include/math-emu/op-common.h                       |   12 +-
 include/math-emu/soft-fp.h                         |   19 +
 sound/aoa/soundbus/soundbus.h                      |    2 +-
 326 files changed, 10837 insertions(+), 7011 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/83xx-512x-pci.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/8xxx_gpio.txt
 delete mode 100644 Documentation/powerpc/ppc_htab.txt
 delete mode 100644 Documentation/powerpc/smp.txt
 create mode 100644 arch/powerpc/boot/dtc-src/libfdt_env.h
 create mode 100644 arch/powerpc/boot/dts/arches.dts
 create mode 100644 arch/powerpc/boot/dts/gef_sbc610.dts
 create mode 100644 arch/powerpc/boot/dts/mgcoge.dts
 create mode 100644 arch/powerpc/boot/dts/mgsuvd.dts
 create mode 100644 arch/powerpc/configs/44x/arches_defconfig
 copy arch/powerpc/configs/{sbc8641d_defconfig => 86xx/gef_sbc610_defconfig} (76%)
 rename arch/powerpc/configs/{ => 86xx}/mpc8610_hpcd_defconfig (100%)
 copy arch/powerpc/configs/{ => 86xx}/mpc8641_hpcn_defconfig (100%)
 rename arch/powerpc/configs/{ => 86xx}/sbc8641d_defconfig (100%)
 create mode 100644 arch/powerpc/configs/mgcoge_defconfig
 create mode 100644 arch/powerpc/configs/mgsuvd_defconfig
 rename arch/powerpc/configs/{mpc8641_hpcn_defconfig => mpc86xx_defconfig} (98%)
 create mode 100644 arch/powerpc/include/asm/msi_bitmap.h
 rename arch/powerpc/{math-emu => include/asm}/sfp-machine.h (84%)
 create mode 100644 arch/powerpc/kernel/.gitignore
 create mode 100644 arch/powerpc/kernel/dma-iommu.c
 create mode 100644 arch/powerpc/kernel/dma.c
 delete mode 100644 arch/powerpc/kernel/dma_64.c
 create mode 100644 arch/powerpc/kernel/reloc_64.S
 delete mode 100644 arch/powerpc/math-emu/double.h
 delete mode 100644 arch/powerpc/math-emu/op-1.h
 delete mode 100644 arch/powerpc/math-emu/op-2.h
 delete mode 100644 arch/powerpc/math-emu/op-4.h
 delete mode 100644 arch/powerpc/math-emu/op-common.h
 delete mode 100644 arch/powerpc/math-emu/single.h
 delete mode 100644 arch/powerpc/math-emu/soft-fp.h
 delete mode 100644 arch/powerpc/math-emu/types.c
 delete mode 100644 arch/powerpc/platforms/44x/bamboo.c
 delete mode 100644 arch/powerpc/platforms/44x/canyonlands.c
 delete mode 100644 arch/powerpc/platforms/44x/katmai.c
 create mode 100644 arch/powerpc/platforms/44x/ppc44x_simple.c
 delete mode 100644 arch/powerpc/platforms/44x/rainier.c
 delete mode 100644 arch/powerpc/platforms/44x/sequoia.c
 delete mode 100644 arch/powerpc/platforms/44x/taishan.c
 create mode 100644 arch/powerpc/platforms/82xx/mgcoge.c
 create mode 100644 arch/powerpc/platforms/86xx/gef_pic.c
 create mode 100644 arch/powerpc/platforms/86xx/gef_pic.h
 create mode 100644 arch/powerpc/platforms/86xx/gef_sbc610.c
 create mode 100644 arch/powerpc/platforms/8xx/mgsuvd.c
 create mode 100644 arch/powerpc/sysdev/mpc8xxx_gpio.c
 create mode 100644 arch/powerpc/sysdev/msi_bitmap.c
 create mode 100644 drivers/i2c/chips/mcu_mpc8349emitx.c


