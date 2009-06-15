Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbZFOCJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbZFOCJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 22:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbZFOCJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 22:09:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:35830 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbZFOCJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 22:09:10 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Jun 2009 12:08:56 +1000
Message-Id: <1245031736.19217.15.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's the first half of the powerpc merge for 2.6.31. I'll have the
rest in a couple of days, just dealing with some of my own backlog here
plus some collisions.

The few things outside of arch/powerpc are powerpc-specific drivers (and
an addition to pci_ids.h). There's also a cleanup of
drivers/pci/Makefile removing another unused ppc specific bit.

No major highlight this time around. Lots of minor fixes, tweaks and
cleanups, swiotlb is now available on some crazy embedded platforms (not
something to be -that- happy about), some new embedded boards, ...

There's a rather big ps3 update queued up for the next batch, but it
didn't make it here. Pauls atomic64_t for 32-bit platforms is in the
next batch too. Hopefully I'll have it ready for you in a day or two (I
want to let it simmer in -next for a couple of days).

Cheers,
Ben.
  
The following changes since commit 45e3e1935e2857c54783291107d33323b3ef33c8:
  Linus Torvalds (1):
        Merge branch 'master' of git://git.kernel.org/.../sam/kbuild-next

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

Anton Blanchard (2):
      powerpc: Improve decrementer accuracy
      powerpc: Convert RTAS event scan from kernel thread to workqueue

Anton Vorontsov (6):
      powerpc/85xx: Add PCI IDs for MPC8569 family processors
      powerpc/85xx: Fix mpc8569emds crypto node to include SNOW unit
      powerpc/85xx: Fix reg & interrupts for mpc8569emds localbus added NAND
      powerpc/85xx: Add eSDHC support for MPC8569E-MDS boards
      powerpc/85xx: Enable Serial RapidIO for MPC85xx MDS boards
      powerpc/85xx: Add STMicro M25P40 serial flash support for MPC8569E-MDS

Becky Bruce (4):
      powerpc/86xx: Add 36-bit device tree for mpc8641hpcn
      powerpc: make dma_window_* in pci_controller struct avail on 32b
      powerpc: Use sg->dma_length in sg_dma_len() macro on 32-bit
      powerpc: Add support for swiotlb on 32-bit

Benjamin Herrenschmidt (12):
      Merge branch 'merge' into next
      powerpc/mm: Fix some SMP issues with MMU context handling
      powerpc/mm: Fix a AB->BA deadlock scenario with nohash MMU context lock
      powerpc: Set init_bootmem_done on NUMA platforms as well
      powerpc: Move VMX and VSX asm code to vector.S
      powerpc: Introduce CONFIG_PPC_BOOK3S
      powerpc: Split exception handling out of head_64.S
      powerpc: Separate PACA fields for server CPUs
      powerpc: Shield code specific to 64-bit server processors
      Merge commit 'jwb/next' into next
      powerpc: Fix bug in move of altivec code to vector.S
      Merge commit 'origin/master' into next

Geert Uytterhoeven (1):
      powerpc: Keep track of emulated instructions

Geoff Levand (1):
      powerpc/ps3: Use smp_request_message_ipi

Grant Likely (1):
      powerpc/virtex: refactor intc driver and add support for i8259 cascading

Haiying Wang (7):
      powerpc/85xx: clean up for mpc8568_mds name
      powerpc/qe: update risc allocation for QE
      net/ucc_geth: update riscTx and riscRx in ucc_geth
      powerpc/qe: update QE Serial Number
      net/ucc_geth: Assign six threads to Rx for UEC
      powerpc/85xx: Add MPC8569MDS board support
      powerpc/qe: add new qe properties for QE based chips

Jan Blunck (1):
      powerpc/spufs: Remove double check for non-negative dentry

John Linn (1):
      fbdev: Add PLB support and cleanup DCR in xilinxfb driver.

Josh Boyer (3):
      powerpc/4xx: Disable PCI_LEGACY
      powerpc/40x: Convert AMCC Makalu board to ppc40x_simple
      powerpc/40x: Convert AMCC Kilauea/Halekala boards to ppc40x_simple

Kumar Gala (32):
      powerpc/fsl: Remove cell-index from PCI nodes
      powerpc: Refactor board check for PCI quirks on FSL boards with uli1575
      powerpc/fsl: use of_iomap() for rstcr mapping
      powerpc/85xx: Add binding for LAWs and ECM
      powerpc/85xx: Add new LAW & ECM device tree nodes for all 85xx systems
      powerpc/86xx: Add binding for LAWs and MCM
      powerpc/86xx: Add new LAW & MCM device tree nodes for all 86xx systems
      powerpc/cpm: Remove some cruft code and defines
      powerpc/86xx: clean up smp init code
      powerpc/fsl: Removed reg property from 85xx/86xx soc node
      fsldma: Fix compile warnings
      powerpc/85xx: Add MSI nodes for MPC8568/9 MDS systems
      powerpc/fsl: Support unique MSI addresses per PCIe Root Complex
      powerpc/8xxx: Update PCI outbound window addresses for 36-bit configs
      powerpc/fsl_rio: Fix compile warnings
      powerpc/fsl: Update FSL esdhc binding
      powerpc/85xx: Add P2020DS board support
      powerpc/fsl: Setup PCI inbound window based on actual amount of memory
      powerpc: Fix up elf_read_implies_exec() usage
      powerpc/pci: Clean up direct access to sysdata by indirect ops
      powerpc/pci: Clean up direct access to sysdata by FSL platforms
      powerpc/pci: Clean up direct access to sysdata by 52xx platforms
      powerpc/pci: Clean up direct access to sysdata by 4xx platforms
      powerpc/pci: Clean up direct access to sysdata by CHRP platforms
      powerpc/pci: Clean up direct access to sysdata on tsi108 platforms
      powerpc/pci: Clean up direct access to sysdata by powermac platforms
      powerpc/pci: Clean up direct access to sysdata by RTAS
      powerpc/pci: Clean up direct access to sysdata by celleb platforms
      powerpc/pci: Move pseries code into pseries platform specific area
      powerpc/pci: Cleanup some minor cruft
      powerpc/pci: Remove redundant pcnet32 fixup
      powerpc/pci: clean up direct access to sysdata by iseries platform

Li Yang (2):
      powerpc/fsl_rio: use LAW address from device tree
      rapidio: fix section mismatch warnings

Michael Ellerman (10):
      powerpc/oprofile: Remove unused dump_pmcs() in FSL oprofile
      powerpc/irq: Move #ifdef'ed body of do_IRQ() into a separate function
      powerpc/irq: Move stack overflow check into a separate function
      powerpc/irq: Move get_irq() comment into header
      powerpc/irq: Remove fallback to __do_IRQ()
      powerpc/powermac: Use generic_handle_irq() in gatwick_action()
      powerpc/irq: We don't need __do_IRQ() anymore
      powerpc/ftrace: Use ppc_function_entry() instead of GET_ADDR
      powerpc/ftrace: Remove unused macros
      powerpc/ftrace: Use PPC_INST_NOP directly

Michael Neuling (3):
      powerpc: Cleanup macros in ppc-opcode.h
      powerpc: Move VSX load/stores into ppc-opcode.h
      powerpc: Make the NR_CPUS max 8192

Michel Dänzer (1):
      therm_adt746x: Always clear hardware bit which inverts fan speed range.

Milton Miller (2):
      powerpc: Enable MMU feature sections for inline asm
      powerpc: Add 2.06 tlbie mnemonics

Nathan Fontenot (1):
      powerpc: Display processor virtualization resource allocs in lparcfg

Robert Jennings (1):
      powerpc/pseries: CMO unused page hinting

Roderick Colenbrander (3):
      powerpc/virtex: Add support for Xilinx PCI host bridge
      powerpc/virtex: Add Xilinx ML510 reference design support
      powerpc/virtex: Add ml510 reference design device tree

Roland McGrath (1):
      powerpc: Add PTRACE_SINGLEBLOCK support

Sean MacLennan (2):
      powerpc: Update Warp to use leds-gpio driver
      i2c: Fix confusing i2c-ibm_iic message

Stefan Roese (1):
      powerpc/4xx: Sequoia: Enable NAND support

Stephen Rothwell (5):
      powerpc/pci: Fix annotation of pcibios_claim_one_bus
      powerpc/pseries: Fix warnings when printing resource_size_t
      powerpc/xmon: Remove unused variable in xmon.c
      powerpc: Fix warning when printing a resource_size_t
      powerpc/spufs: Remove unused error path

Tony Breeds (1):
      powerpc/mpic: Cleanup mpic_find() implementation

Vinay Sridhar (1):
      powerpc/xmon: Add dl command to dump contents of __log_buf

roel kluin (1):
      tape: beyond ARRAY_SIZE of viocd_diskinfo

 Documentation/kernel-parameters.txt                |    7 +
 Documentation/powerpc/dts-bindings/ecm.txt         |   64 ++
 .../powerpc/dts-bindings/fsl/cpm_qe/qe.txt         |    3 +
 Documentation/powerpc/dts-bindings/fsl/esdhc.txt   |    5 +-
 Documentation/powerpc/dts-bindings/fsl/mcm.txt     |   64 ++
 arch/powerpc/Kconfig                               |   16 +-
 arch/powerpc/Kconfig.debug                         |   13 +
 arch/powerpc/Makefile                              |    1 +
 arch/powerpc/boot/dts/gef_ppc9a.dts                |   14 +-
 arch/powerpc/boot/dts/gef_sbc310.dts               |   14 +-
 arch/powerpc/boot/dts/gef_sbc610.dts               |   14 +-
 arch/powerpc/boot/dts/ksi8560.dts                  |   13 +
 arch/powerpc/boot/dts/mpc832x_mds.dts              |    3 +-
 arch/powerpc/boot/dts/mpc832x_rdb.dts              |    3 +-
 arch/powerpc/boot/dts/mpc8349emitx.dts             |    2 -
 arch/powerpc/boot/dts/mpc8349emitxgp.dts           |    1 -
 arch/powerpc/boot/dts/mpc834x_mds.dts              |    2 -
 arch/powerpc/boot/dts/mpc836x_mds.dts              |    3 +-
 arch/powerpc/boot/dts/mpc836x_rdk.dts              |    2 +
 arch/powerpc/boot/dts/mpc8377_mds.dts              |    1 -
 arch/powerpc/boot/dts/mpc8378_mds.dts              |    1 -
 arch/powerpc/boot/dts/mpc8379_mds.dts              |    1 -
 arch/powerpc/boot/dts/mpc8536ds.dts                |   18 +-
 arch/powerpc/boot/dts/mpc8540ads.dts               |   15 +-
 arch/powerpc/boot/dts/mpc8541cds.dts               |   16 +-
 arch/powerpc/boot/dts/mpc8544ds.dts                |   18 +-
 arch/powerpc/boot/dts/mpc8548cds.dts               |   17 +-
 arch/powerpc/boot/dts/mpc8555cds.dts               |   16 +-
 arch/powerpc/boot/dts/mpc8560ads.dts               |   15 +-
 arch/powerpc/boot/dts/mpc8568mds.dts               |   51 +-
 arch/powerpc/boot/dts/mpc8569mds.dts               |  583 +++++++++++
 arch/powerpc/boot/dts/mpc8572ds.dts                |   17 +-
 arch/powerpc/boot/dts/mpc8572ds_36b.dts            |   39 +-
 arch/powerpc/boot/dts/mpc8572ds_camp_core0.dts     |   16 +-
 arch/powerpc/boot/dts/mpc8572ds_camp_core1.dts     |    2 -
 arch/powerpc/boot/dts/mpc8610_hpcd.dts             |   16 +-
 arch/powerpc/boot/dts/mpc8641_hpcn.dts             |   16 +-
 arch/powerpc/boot/dts/mpc8641_hpcn_36b.dts         |  609 +++++++++++
 arch/powerpc/boot/dts/p2020ds.dts                  |  704 +++++++++++++
 arch/powerpc/boot/dts/sbc8349.dts                  |    1 -
 arch/powerpc/boot/dts/sbc8548.dts                  |   16 +-
 arch/powerpc/boot/dts/sbc8560.dts                  |   15 +-
 arch/powerpc/boot/dts/sbc8641d.dts                 |   16 +-
 arch/powerpc/boot/dts/sequoia.dts                  |   22 +
 arch/powerpc/boot/dts/socrates.dts                 |   15 +-
 arch/powerpc/boot/dts/stx_gp3_8560.dts             |   15 +-
 arch/powerpc/boot/dts/tqm8540.dts                  |   15 +-
 arch/powerpc/boot/dts/tqm8541.dts                  |   15 +-
 arch/powerpc/boot/dts/tqm8548-bigflash.dts         |   16 +-
 arch/powerpc/boot/dts/tqm8548.dts                  |   16 +-
 arch/powerpc/boot/dts/tqm8555.dts                  |   15 +-
 arch/powerpc/boot/dts/tqm8560.dts                  |   15 +-
 arch/powerpc/boot/dts/virtex440-ml510.dts          |  465 +++++++++
 arch/powerpc/boot/dts/warp.dts                     |   27 +-
 arch/powerpc/configs/40x/acadia_defconfig          |    2 +-
 arch/powerpc/configs/40x/ep405_defconfig           |    2 +-
 arch/powerpc/configs/40x/kilauea_defconfig         |   81 ++-
 arch/powerpc/configs/40x/makalu_defconfig          |   81 ++-
 arch/powerpc/configs/40x/virtex_defconfig          |    2 +-
 arch/powerpc/configs/44x/arches_defconfig          |    2 +-
 arch/powerpc/configs/44x/bamboo_defconfig          |    2 +-
 arch/powerpc/configs/44x/canyonlands_defconfig     |    6 +-
 arch/powerpc/configs/44x/ebony_defconfig           |    2 +-
 arch/powerpc/configs/44x/katmai_defconfig          |    2 +-
 arch/powerpc/configs/44x/rainier_defconfig         |    2 +-
 arch/powerpc/configs/44x/redwood_defconfig         |    2 +-
 arch/powerpc/configs/44x/sam440ep_defconfig        |    2 +-
 arch/powerpc/configs/44x/sequoia_defconfig         |  111 ++-
 arch/powerpc/configs/44x/taishan_defconfig         |    2 +-
 arch/powerpc/configs/44x/virtex5_defconfig         |    2 +-
 arch/powerpc/include/asm/cpm2.h                    |    4 -
 arch/powerpc/include/asm/dma-mapping.h             |   11 +
 arch/powerpc/include/asm/elf.h                     |    4 +-
 arch/powerpc/include/asm/emulated_ops.h            |   73 ++
 arch/powerpc/include/asm/feature-fixups.h          |   25 +-
 arch/powerpc/include/asm/lppaca.h                  |    6 +
 arch/powerpc/include/asm/machdep.h                 |    4 +
 arch/powerpc/include/asm/mmu.h                     |    9 +-
 arch/powerpc/include/asm/mpc86xx.h                 |   33 -
 arch/powerpc/include/asm/paca.h                    |   12 +-
 arch/powerpc/include/asm/page.h                    |    5 +
 arch/powerpc/include/asm/pci-bridge.h              |   13 +-
 arch/powerpc/include/asm/pgtable-ppc64.h           |    5 +
 arch/powerpc/include/asm/ppc-opcode.h              |   25 +-
 arch/powerpc/include/asm/ppc_asm.h                 |   10 -
 arch/powerpc/include/asm/ptrace.h                  |    4 +
 arch/powerpc/include/asm/qe.h                      |   21 +-
 arch/powerpc/include/asm/scatterlist.h             |    6 +-
 arch/powerpc/include/asm/swiotlb.h                 |   27 +
 arch/powerpc/include/asm/system.h                  |    2 +-
 arch/powerpc/include/asm/xilinx_pci.h              |   21 +
 arch/powerpc/kernel/Makefile                       |    4 +-
 arch/powerpc/kernel/align.c                        |   20 +-
 arch/powerpc/kernel/asm-offsets.c                  |   32 +-
 arch/powerpc/kernel/cputable.c                     |    6 +-
 arch/powerpc/kernel/dma-swiotlb.c                  |  163 +++
 arch/powerpc/kernel/dma.c                          |    2 +-
 arch/powerpc/kernel/exceptions-64s.S               |  978 +++++++++++++++++
 arch/powerpc/kernel/ftrace.c                       |   29 +-
 arch/powerpc/kernel/head_32.S                      |  101 +--
 arch/powerpc/kernel/head_64.S                      | 1095 +-------------------
 arch/powerpc/kernel/head_booke.h                   |   10 +-
 arch/powerpc/kernel/irq.c                          |  127 ++--
 arch/powerpc/kernel/lparcfg.c                      |   40 +-
 arch/powerpc/kernel/misc_64.S                      |   92 --
 arch/powerpc/kernel/paca.c                         |   14 +-
 arch/powerpc/kernel/pci-common.c                   |    3 +-
 arch/powerpc/kernel/pci_32.c                       |   19 -
 arch/powerpc/kernel/pci_64.c                       |   17 +-
 arch/powerpc/kernel/pci_dn.c                       |   28 +-
 arch/powerpc/kernel/process.c                      |    2 +-
 arch/powerpc/kernel/prom.c                         |    2 +-
 arch/powerpc/kernel/ptrace.c                       |   23 +-
 arch/powerpc/kernel/rtas_pci.c                     |   10 +-
 arch/powerpc/kernel/setup_32.c                     |    6 +
 arch/powerpc/kernel/setup_64.c                     |   11 +-
 arch/powerpc/kernel/time.c                         |   21 +-
 arch/powerpc/kernel/traps.c                        |  130 +++-
 arch/powerpc/kernel/vector.S                       |  210 ++++
 arch/powerpc/mm/Makefile                           |    7 +-
 arch/powerpc/mm/hash_native_64.c                   |   13 +-
 arch/powerpc/mm/init_64.c                          |    2 +
 arch/powerpc/mm/mmu_context_nohash.c               |   19 +-
 arch/powerpc/mm/numa.c                             |    2 +
 arch/powerpc/oprofile/op_model_fsl_emb.c           |   14 -
 arch/powerpc/platforms/40x/Kconfig                 |    2 +
 arch/powerpc/platforms/40x/Makefile                |    2 -
 arch/powerpc/platforms/40x/kilauea.c               |   60 --
 arch/powerpc/platforms/40x/makalu.c                |   60 --
 arch/powerpc/platforms/40x/ppc40x_simple.c         |    5 +-
 arch/powerpc/platforms/40x/virtex.c                |    2 +
 arch/powerpc/platforms/44x/Kconfig                 |   13 +-
 arch/powerpc/platforms/44x/Makefile                |    1 +
 arch/powerpc/platforms/44x/virtex.c                |    2 +
 arch/powerpc/platforms/44x/virtex_ml510.c          |   29 +
 arch/powerpc/platforms/44x/warp.c                  |   76 +-
 arch/powerpc/platforms/52xx/efika.c                |    4 +-
 arch/powerpc/platforms/52xx/mpc52xx_pci.c          |    4 +-
 arch/powerpc/platforms/82xx/pq2ads.h               |   13 -
 arch/powerpc/platforms/85xx/Kconfig                |    1 +
 arch/powerpc/platforms/85xx/mpc85xx_ds.c           |   43 +-
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |   52 +-
 arch/powerpc/platforms/86xx/gef_ppc9a.c            |    1 -
 arch/powerpc/platforms/86xx/gef_sbc310.c           |    1 -
 arch/powerpc/platforms/86xx/gef_sbc610.c           |    1 -
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c         |    1 -
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c         |    1 -
 arch/powerpc/platforms/86xx/mpc86xx_smp.c          |    8 +-
 arch/powerpc/platforms/86xx/sbc8641d.c             |    1 -
 arch/powerpc/platforms/8xx/mpc885ads.h             |    4 -
 arch/powerpc/platforms/Kconfig                     |    4 +
 arch/powerpc/platforms/Kconfig.cputype             |   26 +-
 arch/powerpc/platforms/cell/celleb_pci.c           |   10 +-
 arch/powerpc/platforms/cell/celleb_scc_epci.c      |   13 +-
 arch/powerpc/platforms/cell/celleb_scc_pciex.c     |   12 +-
 arch/powerpc/platforms/cell/spufs/inode.c          |    6 -
 arch/powerpc/platforms/chrp/pci.c                  |    8 +-
 arch/powerpc/platforms/fsl_uli1575.c               |   24 +-
 arch/powerpc/platforms/iseries/iommu.c             |    2 +-
 arch/powerpc/platforms/iseries/pci.c               |    8 +-
 arch/powerpc/platforms/powermac/pic.c              |    2 +-
 arch/powerpc/platforms/powermac/setup.c            |    2 +-
 arch/powerpc/platforms/ps3/smp.c                   |   16 +-
 arch/powerpc/platforms/pseries/iommu.c             |    4 +-
 arch/powerpc/platforms/pseries/lpar.c              |   52 +
 arch/powerpc/platforms/pseries/rtasd.c             |   76 +-
 arch/powerpc/platforms/pseries/setup.c             |   25 +
 arch/powerpc/sysdev/Makefile                       |    1 +
 arch/powerpc/sysdev/cpm2.c                         |    2 +-
 arch/powerpc/sysdev/fsl_msi.c                      |    9 +-
 arch/powerpc/sysdev/fsl_pci.c                      |  138 +++-
 arch/powerpc/sysdev/fsl_pci.h                      |    6 +-
 arch/powerpc/sysdev/fsl_rio.c                      |   15 +-
 arch/powerpc/sysdev/fsl_soc.c                      |   14 +-
 arch/powerpc/sysdev/indirect_pci.c                 |    4 +-
 arch/powerpc/sysdev/mpic.c                         |   23 +-
 arch/powerpc/sysdev/ppc4xx_pci.c                   |    4 +-
 arch/powerpc/sysdev/qe_lib/qe.c                    |   75 ++-
 arch/powerpc/sysdev/tsi108_pci.c                   |    4 +-
 arch/powerpc/sysdev/xilinx_intc.c                  |   81 ++-
 arch/powerpc/sysdev/xilinx_pci.c                   |  132 +++
 arch/powerpc/xmon/xmon.c                           |   47 +
 drivers/char/viotape.c                             |    2 +-
 drivers/i2c/busses/i2c-ibm_iic.c                   |    6 +-
 drivers/macintosh/therm_adt746x.c                  |    4 +-
 drivers/net/ucc_geth.c                             |   24 +-
 drivers/net/ucc_geth.h                             |    4 +-
 drivers/of/base.c                                  |    1 +
 drivers/pci/Makefile                               |    1 -
 drivers/rapidio/rio-scan.c                         |    6 +-
 drivers/video/xilinxfb.c                           |  290 +++---
 include/linux/pci_ids.h                            |    4 +
 192 files changed, 6191 insertions(+), 2357 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/ecm.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/mcm.txt
 create mode 100644 arch/powerpc/boot/dts/mpc8569mds.dts
 create mode 100644 arch/powerpc/boot/dts/mpc8641_hpcn_36b.dts
 create mode 100644 arch/powerpc/boot/dts/p2020ds.dts
 create mode 100644 arch/powerpc/boot/dts/virtex440-ml510.dts
 create mode 100644 arch/powerpc/include/asm/emulated_ops.h
 delete mode 100644 arch/powerpc/include/asm/mpc86xx.h
 create mode 100644 arch/powerpc/include/asm/swiotlb.h
 create mode 100644 arch/powerpc/include/asm/xilinx_pci.h
 create mode 100644 arch/powerpc/kernel/dma-swiotlb.c
 create mode 100644 arch/powerpc/kernel/exceptions-64s.S
 delete mode 100644 arch/powerpc/platforms/40x/kilauea.c
 delete mode 100644 arch/powerpc/platforms/40x/makalu.c
 create mode 100644 arch/powerpc/platforms/44x/virtex_ml510.c
 create mode 100644 arch/powerpc/sysdev/xilinx_pci.c


