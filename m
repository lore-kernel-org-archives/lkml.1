Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbYGVHfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbYGVHfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 03:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYGVHfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 03:35:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:49923 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbYGVHfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 03:35:10 -0400
Subject: [git pull] Please pull from powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Kumar Gala <kumar.gala@freescale.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 22 Jul 2008 17:32:11 +1000
Message-Id: <1216711931.11027.193.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿Hi Linus !

Here's the second batch of powerpc updates. I should have a last one
before the end of the merge window for things that are stealing dealing
with conflicts or dependencies but we are getting there.

So please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Hopefully this one shouldn't whack the main Makefile :-)

Note a couple of fbdev updates. One is an offb change by me, this is
a powerpc specific driver so that shouldn't affect anybody else, and
one is the ps3 specific fbdev by Geoff, so again, there should be
no collateral damage.

Some drivers/net changes to freescale specific drivers are coming from
Kumar's tree. Kumar, I merged them, however, shouldn't we have Jeff's
ack on these things or is it ok as long as those are arch specific
drivers and the changes boring ?

The cell EDAC change has been ack'ed by the EDAC maintainer.

Cheers,
Ben.

 Documentation/DMA-attributes.txt                   |    9 
 Documentation/powerpc/booting-without-of.txt       |  189 +
 .../powerpc/dts-bindings/fsl/cpm_qe/gpio.txt       |   38 
 .../powerpc/dts-bindings/fsl/cpm_qe/qe/usb.txt     |   53 
 .../powerpc/dts-bindings/fsl/mcu-mpc8349emitx.txt  |   17 
 Documentation/powerpc/dts-bindings/fsl/pmc.txt     |   63 
 Documentation/powerpc/dts-bindings/fsl/tsec.txt    |   31 
 .../powerpc/dts-bindings/fsl/upm-nand.txt          |   28 
 Documentation/powerpc/dts-bindings/gpio/led.txt    |   15 
 arch/powerpc/Kconfig                               |   14 
 arch/powerpc/boot/Makefile                         |    4 
 arch/powerpc/boot/dts/mpc7448hpc2.dts              |   24 
 arch/powerpc/boot/dts/mpc8313erdb.dts              |  241 +
 arch/powerpc/boot/dts/mpc8610_hpcd.dts             |   14 
 arch/powerpc/configs/85xx/mpc8544_ds_defconfig     |    8 
 arch/powerpc/configs/85xx/mpc8572_ds_defconfig     |    8 
 arch/powerpc/configs/mpc85xx_defconfig             |    8 
 arch/powerpc/configs/mpc8610_hpcd_defconfig        |  121 +
 arch/powerpc/configs/mpc8641_hpcn_defconfig        |    8 
 arch/powerpc/configs/ppc6xx_defconfig              | 3304 ++++++++++++++++++++
 arch/powerpc/configs/ps3_defconfig                 |  196 +
 arch/powerpc/kernel/cputable.c                     |   20 
 arch/powerpc/kernel/head_fsl_booke.S               |  187 -
 arch/powerpc/kernel/iommu.c                        |   13 
 arch/powerpc/kernel/pci-common.c                   |    1 
 arch/powerpc/kernel/prom_parse.c                   |   44 
 arch/powerpc/kernel/stacktrace.c                   |    2 
 arch/powerpc/kernel/vmlinux.lds.S                  |   31 
 arch/powerpc/lib/feature-fixups.c                  |    2 
 arch/powerpc/lib/string.S                          |   18 
 arch/powerpc/platforms/52xx/Kconfig                |    1 
 arch/powerpc/platforms/82xx/Kconfig                |    1 
 arch/powerpc/platforms/82xx/ep8248e.c              |    4 
 arch/powerpc/platforms/83xx/Kconfig                |    3 
 arch/powerpc/platforms/83xx/Makefile               |    2 
 arch/powerpc/platforms/83xx/mpc831x_rdb.c          |    1 
 arch/powerpc/platforms/83xx/mpc832x_mds.c          |    1 
 arch/powerpc/platforms/83xx/mpc832x_rdb.c          |    1 
 arch/powerpc/platforms/83xx/mpc834x_itx.c          |    1 
 arch/powerpc/platforms/83xx/mpc834x_mds.c          |    1 
 arch/powerpc/platforms/83xx/mpc836x_mds.c          |    1 
 arch/powerpc/platforms/83xx/mpc836x_rdk.c          |    1 
 arch/powerpc/platforms/83xx/mpc837x_mds.c          |    1 
 arch/powerpc/platforms/83xx/mpc837x_rdb.c          |    1 
 arch/powerpc/platforms/83xx/mpc83xx.h              |    5 
 arch/powerpc/platforms/83xx/pci.c                  |   91 -
 arch/powerpc/platforms/83xx/sbc834x.c              |    1 
 arch/powerpc/platforms/83xx/suspend-asm.S          |  533 +++
 arch/powerpc/platforms/83xx/suspend.c              |  388 ++
 arch/powerpc/platforms/83xx/usb.c                  |   24 
 arch/powerpc/platforms/85xx/Kconfig                |    3 
 arch/powerpc/platforms/85xx/mpc85xx_ds.c           |    2 
 arch/powerpc/platforms/86xx/Kconfig                |    3 
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c         |   87 -
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c         |    2 
 arch/powerpc/platforms/Kconfig                     |    6 
 arch/powerpc/platforms/Kconfig.cputype             |    5 
 arch/powerpc/platforms/cell/Kconfig                |   25 
 arch/powerpc/platforms/cell/Makefile               |    3 
 arch/powerpc/platforms/cell/cbe_powerbutton.c      |  117 +
 arch/powerpc/platforms/cell/cpufreq_spudemand.c    |  184 +
 arch/powerpc/platforms/cell/iommu.c                |  118 +
 arch/powerpc/platforms/cell/pervasive.c            |   27 
 arch/powerpc/platforms/cell/pervasive.h            |    9 
 arch/powerpc/platforms/cell/ras.c                  |   46 
 arch/powerpc/platforms/fsl_uli1575.c               |  117 +
 arch/powerpc/platforms/iseries/Kconfig             |    1 
 arch/powerpc/platforms/iseries/iommu.c             |    3 
 arch/powerpc/platforms/pasemi/iommu.c              |    3 
 arch/powerpc/platforms/ps3/Kconfig                 |    1 
 arch/powerpc/platforms/ps3/device-init.c           |    1 
 arch/powerpc/platforms/ps3/system-bus.c            |   21 
 arch/powerpc/platforms/pseries/Kconfig             |    1 
 arch/powerpc/platforms/pseries/eeh.c               |   26 
 arch/powerpc/platforms/pseries/iommu.c             |   14 
 arch/powerpc/sysdev/axonram.c                      |   28 
 arch/powerpc/sysdev/dart_iommu.c                   |    3 
 arch/powerpc/sysdev/fsl_pci.c                      |   61 
 arch/powerpc/sysdev/fsl_pci.h                      |    1 
 arch/powerpc/sysdev/fsl_soc.c                      |   90 -
 arch/powerpc/sysdev/fsl_soc.h                      |    1 
 arch/powerpc/sysdev/ipic.c                         |   71 
 arch/powerpc/sysdev/qe_lib/qe.c                    |    6 
 arch/powerpc/sysdev/qe_lib/ucc.c                   |    6 
 arch/powerpc/sysdev/qe_lib/ucc_fast.c              |   16 
 drivers/edac/cell_edac.c                           |    5 
 drivers/net/fs_enet/Makefile                       |    5 
 drivers/net/fs_enet/fs_enet-main.c                 |  312 --
 drivers/net/fs_enet/fs_enet.h                      |    4 
 drivers/net/fs_enet/mac-fcc.c                      |   67 
 drivers/net/fs_enet/mac-fec.c                      |   23 
 drivers/net/fs_enet/mac-scc.c                      |   37 
 drivers/net/fs_enet/mii-bitbang.c                  |  107 -
 drivers/net/fs_enet/mii-fec.c                      |  144 -
 drivers/net/gianfar.c                              |  122 +
 drivers/net/gianfar.h                              |   12 
 drivers/net/gianfar_ethtool.c                      |   41 
 drivers/video/offb.c                               |  192 +
 drivers/video/ps3fb.c                              |    1 
 include/asm-powerpc/asm-compat.h                   |    2 
 include/asm-powerpc/machdep.h                      |    3 
 include/asm-powerpc/pgtable-ppc32.h                |   15 
 include/asm-powerpc/pmi.h                          |    1 
 include/asm-powerpc/ps3.h                          |    7 
 include/asm-powerpc/reg.h                          |    4 
 include/asm-powerpc/uaccess.h                      |   21 
 include/asm-powerpc/ucc_fast.h                     |    8 
 include/linux/dma-attrs.h                          |    1 
 include/linux/fs_enet_pd.h                         |    4 
 include/linux/fsl_devices.h                        |    7 
 include/linux/of_gpio.h                            |    2 
 111 files changed, 6416 insertions(+), 1612 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/cpm_qe/gpio.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/mcu-mpc8349emitx.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/pmc.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/upm-nand.txt
 create mode 100644 Documentation/powerpc/dts-bindings/gpio/led.txt
 create mode 100644 arch/powerpc/configs/ppc6xx_defconfig
 delete mode 100644 arch/powerpc/platforms/83xx/pci.c
 create mode 100644 arch/powerpc/platforms/83xx/suspend-asm.S
 create mode 100644 arch/powerpc/platforms/83xx/suspend.c
 create mode 100644 arch/powerpc/platforms/cell/cbe_powerbutton.c
 create mode 100644 arch/powerpc/platforms/cell/cpufreq_spudemand.c

Adrian Bunk (2):
      powerpc: Remove duplicate 6xx option in Kconfig
      powerpc/boot: Change spaces to tabs

Andy Fleming (2):
      powerpc: Add support for multiple gfar mdio interfaces
      powerpc: Fix a bunch of sparse warnings in the qe_lib

Anton Vorontsov (6):
      powerpc/83xx: fix ULPI setup for MPC8315 processors
      powerpc/fsl_soc: gianfar: don't probe disabled devices
      powerpc: add FHCI USB, FSL MCU, FSL UPM and GPIO LEDs bindings
      powerpc/fsl_uli1575: fix RTC quirk to work on MPC8572DS and MPC8610HPCD
      powerpc/85xx/86xx: some refactoring for fsl_uli1575 code
      powerpc/86xx: mpc8610_hpcd - add support for ULI RTC

Arnd Bergmann (1):
      powerpc: Fix support for latencytop

Benjamin Herrenschmidt (2):
      powerpc: Fix OF parsing of 64 bits PCI addresses
      fbdev: Teaches offb about palette on radeon r5xx/r6xx

Christian Krafft (3):
      powerpc/cell/cpufreq: Add spu aware cpufreq governor
      powerpc/cell: Cleanup sysreset_hack for IBM cell blades
      powerpc/cell: Add support for power button of future IBM cell blades

Geoff Levand (1):
      powerpc/ps3: Update ps3_defconfig

Jochen Friedrich (1):
      powerpc: Add documentation for CPM GPIO banks

John Rigby (2):
      powerpc: pci config cleanup
      powerpc: Move mpc83xx_add_bridge to fsl_pci.c

Kumar Gala (7):
      fs_enet: Remove !CONFIG_PPC_CPM_NEW_BINDING code
      powerpc: Remove Kconfig PPC_CPM_NEW_BINDING
      powerpc: rework FSL Book-E PTE access and TLB miss
      powerpc/fsl: Minor TLBSYNC cleanup for FSL Book-E
      powerpc/ep8248e: Unconditionally select PHYLIB for mdio_bitbang
      Revert "powerpc/ep8248e: Fix compile problem if !CONFIG_FS_ENET"
      powerpc: Add a 6xx defconfig

Mark Nelson (2):
      powerpc/dma: Use the struct dma_attrs in iommu code
      powerpc/cell: Add DMA_ATTR_WEAK_ORDERING dma attribute and use in Cell IOMMU code

Masakazu Mokuno (1):
      powerpc/ps3: Add a sub-match id to ps3_system_bus

Maxim Shchetynin (3):
      powerpc/axonram: Use only one block device major number
      powerpc/axonram: Enable partitioning of the Axons DDR2 DIMMs
      powerpc/cell/edac: Log a syndrome code in case of correctable error

Michael Ellerman (4):
      powerpc: Use WARN_ON(1) instead of __WARN()
      powerpc: Add a #define for aligning to a long-sized boundary
      powerpc: Use PPC_LONG_ALIGN in uaccess.h
      powerpc: Use PPC_LONG and PPC_LONG_ALIGN in lib/string.S

Mike Mason (1):
      powerpc/eeh: Don't panic when EEH_MAX_FAILS is exceeded

Paul Gortmaker (1):
      powerpc/mpc7448: add alias list to DTS, clean out old chosen node

Scott Wood (6):
      powerpc: Document Freescale power management nodes, and the sleep property.
      powerpc: Update example SOC node in booting-without-of.txt.
      powerpc/mpc83xx: Power Management support
      powerpc/mpc8313erdb: Add power management to the device tree.
      gianfar: Add magic packet and suspend/resume support.
      Add fsl,magic-packet to, and clean up, the gianfar binding.

Segher Boessenkool (1):
      powerpc: Fix build bug with binutils < 2.18 and GCC < 4.2

Timur Tabi (1):
      powerpc: fix ALSA options in Freescale 85xx and 86xx defconfigs

Torez Smith (1):
      powerpc: Indicate which oprofile counters to use while in compat mode

Wolfgang Grandegger (1):
      of_gpio: Should use new <linux/gpio.h> header



