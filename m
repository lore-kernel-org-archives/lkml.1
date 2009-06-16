Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZFPDGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZFPDGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 23:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZFPDGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 23:06:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:45798 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbZFPDGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 23:06:13 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 13:05:59 +1000
Message-Id: <1245121559.12400.51.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's the other batch of powerpc stuff, including adding a small
accessor to the generic BIO code (acked by Jens) and Paulus generic
atomic64 implementation. A lot of PS3 updates in there, though I held
back a couple for some purely mechanical merge reasons, so expect a 3rd
batch with these plus some bug fixes before the end of the merge window.

The following changes since commit 03347e2592078a90df818670fddf97a33eec70fb:
  Linus Torvalds (1):
        Merge branch 'release' of git://git.kernel.org/.../aegl/linux-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Benjamin Herrenschmidt (2):
      Merge commit 'origin/master' into next
      powerpc: Don't do generic calibrate_delay()

Geert Uytterhoeven (24):
      ps3vram: Fix error path (return -EIO) for short read/write
      ps3vram: Use proc_create_data() instead of proc_create()
      ps3fb: Remove useless debug checks in ps3fb_shutdown()
      ps3fb: Inline functions in ps3fb_probe(), to ease cleanup in the error path
      ps3fb: Correct handling of device opening in ps3fb_probe()
      powerpc/cell: Extract duplicated IOPTE_* to <asm/iommu.h>
      ps3fb: GPU memory mapping cleanup
      ps3vram: GPU memory mapping cleanup
      ps3fb/vram: Extract common GPU stuff into <asm/ps3gpu.h>
      ps3fb: Tear down FB setup during cleanup
      block: Add bio_list_peek()
      ps3vram: Replace mutex by spinlock + bio_list
      ps3vram: Remove no longer used ps3vram_priv.ddr_base
      ps3vram: Make ps3vram_priv.reports a void *
      ps3: Use dev_[gs]et_drvdata() instead of direct access for system bus devices
      ps3: shorten ps3_system_bus_[gs]et_driver_data to ps3_system_bus_[gs]et_drvdata
      ps3flash: Use ps3_system_bus_[gs]et_drvdata() instead of direct access
      ps3fb: Use ps3_system_bus_[gs]et_drvdata() instead of direct access
      drivers/ps3: Add missing annotations
      ps3: Correct debug message in dma_ioc0_map_pages()
      ps3: Switch ps3_os_area_[gs]et_rtc_diff to EXPORT_SYMBOL_GPL()
      ps3: Replace direct file operations by callback
      ps3flash: Cache the last accessed FLASH chunk
      ps3flash: Always read chunks of 256 KiB, and cache them

Grant Likely (1):
      powerpc/install: Bail with error code on error in install script

Jim Paris (1):
      ps3vram: Correct exchanged gotos in ps3vram_probe() error path

Michael Ellerman (5):
      powerpc: Fix warning in setup_64.c when CONFIG_RELOCATABLE=y
      powerpc/cell: Use driver_data acessors, not platform_data in Axon MSI
      powerpc: Only build prom_init.o when CONFIG_PPC_OF_BOOT_TRAMPOLINE=y
      powerpc/iseries: Fix unused function warning in iSeries DT code
      powerpc/iseries: Mark signal_vsp_instruction() as maybe unused

Paul Mackerras (3):
      powerpc: Add compiler memory barrier to mtmsr macro
      lib: Provide generic atomic64_t implementation
      powerpc: Use generic atomic64_t implementation on 32-bit processors

Roel Kluin (1):
      block/ps3: remove driver_data direct access of struct device

Stephen Rothwell (1):
      powerpc: Wire up sys_rt_tgsigqueueinfo

sebastian.blanes@gmail.com (1):
      ps3av: Set 16:9 aspect ratio for 720p video modes

 Documentation/kernel-parameters.txt                |    7 +
 Documentation/powerpc/dts-bindings/ecm.txt         |   64 ++
 .../powerpc/dts-bindings/fsl/cpm_qe/qe.txt         |    3 +
 Documentation/powerpc/dts-bindings/fsl/esdhc.txt   |    5 +-
 Documentation/powerpc/dts-bindings/fsl/mcm.txt     |   64 ++
 arch/powerpc/Kconfig                               |   21 +-
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
 arch/powerpc/boot/install.sh                       |    3 +
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
 arch/powerpc/include/asm/atomic.h                  |    3 +
 arch/powerpc/include/asm/cpm2.h                    |    4 -
 arch/powerpc/include/asm/dma-mapping.h             |   11 +
 arch/powerpc/include/asm/elf.h                     |    4 +-
 arch/powerpc/include/asm/emulated_ops.h            |   73 ++
 arch/powerpc/include/asm/feature-fixups.h          |   25 +-
 arch/powerpc/include/asm/hw_irq.h                  |    5 +-
 arch/powerpc/include/asm/iommu.h                   |   10 +
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
 arch/powerpc/include/asm/ps3.h                     |   18 +-
 arch/powerpc/include/asm/ps3gpu.h                  |   86 ++
 arch/powerpc/include/asm/ptrace.h                  |    4 +
 arch/powerpc/include/asm/qe.h                      |   21 +-
 arch/powerpc/include/asm/reg.h                     |    4 +-
 arch/powerpc/include/asm/scatterlist.h             |    6 +-
 arch/powerpc/include/asm/swiotlb.h                 |   27 +
 arch/powerpc/include/asm/systbl.h                  |    1 +
 arch/powerpc/include/asm/system.h                  |    2 +-
 arch/powerpc/include/asm/unistd.h                  |    3 +-
 arch/powerpc/include/asm/xilinx_pci.h              |   21 +
 arch/powerpc/kernel/Makefile                       |    6 +-
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
 arch/powerpc/kernel/setup_64.c                     |   15 +-
 arch/powerpc/kernel/time.c                         |   31 +-
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
 arch/powerpc/platforms/cell/axon_msi.c             |    4 +-
 arch/powerpc/platforms/cell/celleb_pci.c           |   10 +-
 arch/powerpc/platforms/cell/celleb_scc_epci.c      |   13 +-
 arch/powerpc/platforms/cell/celleb_scc_pciex.c     |   12 +-
 arch/powerpc/platforms/cell/iommu.c                |   37 +-
 arch/powerpc/platforms/cell/spufs/inode.c          |    6 -
 arch/powerpc/platforms/chrp/pci.c                  |    8 +-
 arch/powerpc/platforms/fsl_uli1575.c               |   24 +-
 arch/powerpc/platforms/iseries/dt.c                |    3 +-
 arch/powerpc/platforms/iseries/iommu.c             |    2 +-
 arch/powerpc/platforms/iseries/mf.c                |    3 +-
 arch/powerpc/platforms/iseries/pci.c               |    8 +-
 arch/powerpc/platforms/powermac/pic.c              |    2 +-
 arch/powerpc/platforms/powermac/setup.c            |    2 +-
 arch/powerpc/platforms/ps3/mm.c                    |   12 +-
 arch/powerpc/platforms/ps3/os-area.c               |  142 ++--
 arch/powerpc/platforms/ps3/platform.h              |   10 -
 arch/powerpc/platforms/ps3/setup.c                 |    1 +
 arch/powerpc/platforms/ps3/smp.c                   |   16 +-
 arch/powerpc/platforms/ps3/system-bus.c            |   15 +-
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
 drivers/block/ps3disk.c                            |   18 +-
 drivers/block/ps3vram.c                            |  168 ++--
 drivers/char/ps3flash.c                            |  296 +++---
 drivers/char/viotape.c                             |    2 +-
 drivers/i2c/busses/i2c-ibm_iic.c                   |    6 +-
 drivers/macintosh/therm_adt746x.c                  |    4 +-
 drivers/net/ps3_gelic_net.c                        |    8 +-
 drivers/net/ucc_geth.c                             |   24 +-
 drivers/net/ucc_geth.h                             |    4 +-
 drivers/of/base.c                                  |    1 +
 drivers/pci/Makefile                               |    1 -
 drivers/ps3/ps3-sys-manager.c                      |    2 +-
 drivers/ps3/ps3av.c                                |    8 +-
 drivers/ps3/ps3av_cmd.c                            |    3 +-
 drivers/rapidio/rio-scan.c                         |    6 +-
 drivers/usb/host/ehci-ps3.c                        |    7 +-
 drivers/usb/host/ohci-ps3.c                        |    7 +-
 drivers/video/ps3fb.c                              |  272 ++---
 drivers/video/xilinxfb.c                           |  290 +++---
 include/asm-generic/atomic64.h                     |   42 +
 include/linux/bio.h                                |    5 +
 include/linux/pci_ids.h                            |    4 +
 lib/Kconfig                                        |    6 +
 lib/Makefile                                       |    2 +
 lib/atomic64.c                                     |  175 ++++
 225 files changed, 7064 insertions(+), 2884 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/ecm.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/mcm.txt
 create mode 100644 arch/powerpc/boot/dts/mpc8569mds.dts
 create mode 100644 arch/powerpc/boot/dts/mpc8641_hpcn_36b.dts
 create mode 100644 arch/powerpc/boot/dts/p2020ds.dts
 create mode 100644 arch/powerpc/boot/dts/virtex440-ml510.dts
 create mode 100644 arch/powerpc/include/asm/emulated_ops.h
 delete mode 100644 arch/powerpc/include/asm/mpc86xx.h
 create mode 100644 arch/powerpc/include/asm/ps3gpu.h
 create mode 100644 arch/powerpc/include/asm/swiotlb.h
 create mode 100644 arch/powerpc/include/asm/xilinx_pci.h
 create mode 100644 arch/powerpc/kernel/dma-swiotlb.c
 create mode 100644 arch/powerpc/kernel/exceptions-64s.S
 delete mode 100644 arch/powerpc/platforms/40x/kilauea.c
 delete mode 100644 arch/powerpc/platforms/40x/makalu.c
 create mode 100644 arch/powerpc/platforms/44x/virtex_ml510.c
 create mode 100644 arch/powerpc/sysdev/xilinx_pci.c
 create mode 100644 include/asm-generic/atomic64.h
 create mode 100644 lib/atomic64.c


