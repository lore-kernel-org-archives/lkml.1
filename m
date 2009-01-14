Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZANCfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZANCfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbZANCfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:35:04 -0500
Received: from gate.crashing.org ([63.228.1.57]:52599 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZANCfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:35:02 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 13:34:47 +1100
Message-Id: <1231900487.22571.69.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's another batch for before -rc2. The main highlight is the u64 conversion
to unsigned long long along with a bunch of patches fixing warnings due to this
conversion. There will be a few more, for example the PS3 code is still pretty
bad in this area, but that's about it.

The rest is mostly bug fixes, moving a driver around as requested by a maintainer,
a couple of trivial things, and a few late embedded changes that were posted
before the merge window, but some maintainer needed more time than others to
recover from whatever he got intoxicated with over new year :-)

After that, I'm opening my next branch for .30 material and merge will be
regressions and severe bugs only.

Cheers,
Ben.

The following changes since commit a6525042bfdfcab128bd91fad264de10fd24a55e:
  Linus Torvalds (1):
        Merge branch 'x86-pat-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Anton Vorontsov (2):
      powerpc/83xx: Make serial ports work on MPC8315E-RDB w/ FSL U-Boots
      powerpc/83xx: Move mcu_mpc8349emitx driver out of drivers/i2c/chips/

Benjamin Herrenschmidt (3):
      Merge commit 'kumar/kumar-next' into next
      Merge commit 'gcl/gcl-next' into next
      powerpc/powermac: Fix occasional SMP boot failure

Grant Likely (1):
      powerpc/mpc52xx: Properly update irq_desc when set_type() is called.

Ingo Molnar (1):
      powerpc: Change u64/s64 to a long long integer type

Jason Jin (1):
      powerpc: Fix the ide suspend function in uli1575

John Linn (1):
      Xilinx: SPI: updated driver for device tree

Jon Smirl (1):
      drivers/of: Add the of_find_i2c_device_by_node function.

Kumar Gala (2):
      powerpc/85xx: Fix PCIe error interrupts
      powerpc/e500mc: Doorbells need to be taken w/exceptions disabled

Michael Ellerman (1):
      powerpc: Enable PS3 options and QPACE in ppc64_defconfig

Milton Miller (6):
      powerpc: Make dummy section a valid note header
      powerpc/kexec: Check crash_base for relocatable kernel
      hvc_console: Change an mb() to smp_mb() and add some comments
      hvc_console: Call free_irq() only if request_irq() was successful
      hvc_console: Do not set low_latency when using interrupts
      hvc_console: Use kzalloc() instead of kmalloc() + memset()

Nathan Lynch (1):
      powerpc/cacheinfo: Rename cache_dir per-cpu variable

Stephen Rothwell (3):
      powerpc: Cleanup from l64 to ll64 change: arch code
      powerpc: Cleanup from l64 to ll64 change: drivers/char
      powerpc: Cleanup from l64 to ll64 change: drivers/net

Timur Tabi (1):
      powerpc/qe: add Ethernet UPSMR definitions to QE library

Trent Piepho (4):
      powerpc/fsl-pci: Better ATMU setup for 85xx/86xx
      powerpc/fsl-pci: Set relaxed ordering on prefetchable ranges
      powerpc/fsl-booke: Don't hard-code size of struct tlbcam
      powerpc/fsl-booke: Remove num_tlbcam_entries

Wolfram Sang (1):
      powerpc/mpc52xx: remove dead code from GPIO driver

Yuri Tikhonov (1):
      powerpc/xsysace: add compatible string for non-ipcore instance

roel kluin (1):
      powerpc/mpc5121: fix NULL test in mpc5121_clk_get utility function.

 arch/powerpc/boot/dts/mpc8315erdb.dts              |    4 +-
 arch/powerpc/boot/dts/mpc8544ds.dts                |    4 +-
 arch/powerpc/boot/dts/mpc8572ds.dts                |    4 +-
 arch/powerpc/boot/dts/mpc8572ds_camp_core0.dts     |    2 +-
 arch/powerpc/boot/dts/mpc8572ds_camp_core1.dts     |    2 +-
 arch/powerpc/configs/ppc64_defconfig               |   26 ++++-
 arch/powerpc/include/asm/qe.h                      |   19 +++-
 arch/powerpc/include/asm/rtas.h                    |    2 +-
 arch/powerpc/include/asm/types.h                   |    7 +-
 arch/powerpc/kernel/asm-offsets.c                  |    7 +
 arch/powerpc/kernel/cacheinfo.c                    |   10 +-
 arch/powerpc/kernel/dma-iommu.c                    |    4 +-
 arch/powerpc/kernel/head_64.S                      |    9 ++
 arch/powerpc/kernel/head_fsl_booke.S               |    8 +-
 arch/powerpc/kernel/iommu.c                        |   12 +-
 arch/powerpc/kernel/lparcfg.c                      |   10 +-
 arch/powerpc/kernel/machine_kexec.c                |   25 ++++
 arch/powerpc/kernel/pci_64.c                       |    6 +-
 arch/powerpc/kernel/setup_64.c                     |    6 +-
 arch/powerpc/kernel/vmlinux.lds.S                  |    4 +-
 arch/powerpc/mm/fsl_booke_mmu.c                    |    9 +-
 arch/powerpc/mm/mmu_decl.h                         |   11 ++-
 arch/powerpc/mm/stab.c                             |    4 +-
 arch/powerpc/oprofile/op_model_pa6t.c              |    6 +-
 arch/powerpc/platforms/512x/clock.c                |    4 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpio.c         |    3 -
 arch/powerpc/platforms/52xx/mpc52xx_pic.c          |    8 +-
 arch/powerpc/platforms/83xx/Makefile               |    1 +
 .../powerpc/platforms/83xx}/mcu_mpc8349emitx.c     |    0
 arch/powerpc/platforms/Kconfig                     |   11 ++
 arch/powerpc/platforms/cell/beat_interrupt.c       |    2 +-
 arch/powerpc/platforms/cell/celleb_scc_epci.c      |    4 +-
 arch/powerpc/platforms/cell/iommu.c                |    4 +-
 arch/powerpc/platforms/cell/ras.c                  |    8 +-
 arch/powerpc/platforms/cell/spu_base.c             |    4 +-
 arch/powerpc/platforms/cell/spu_callbacks.c        |    2 +-
 arch/powerpc/platforms/cell/spufs/coredump.c       |    2 +-
 arch/powerpc/platforms/cell/spufs/fault.c          |    2 +-
 arch/powerpc/platforms/cell/spufs/file.c           |    6 +-
 arch/powerpc/platforms/fsl_uli1575.c               |    1 +
 arch/powerpc/platforms/iseries/iommu.c             |    4 +-
 arch/powerpc/platforms/powermac/smp.c              |    2 +-
 arch/powerpc/platforms/pseries/iommu.c             |   35 +++---
 arch/powerpc/sysdev/fsl_pci.c                      |  107 +++++++++++-----
 arch/powerpc/sysdev/mpic.c                         |    2 +-
 drivers/block/xsysace.c                            |    1 +
 drivers/char/bsr.c                                 |    2 +-
 drivers/char/hvc_console.c                         |   14 +-
 drivers/char/hvc_irq.c                             |    2 +-
 drivers/i2c/chips/Kconfig                          |   11 --
 drivers/i2c/chips/Makefile                         |    1 -
 drivers/net/ehea/ehea_main.c                       |    8 +-
 drivers/net/ehea/ehea_qmr.c                        |   18 ++--
 drivers/net/ibmveth.c                              |   16 +-
 drivers/net/iseries_veth.c                         |    2 +-
 drivers/net/pasemi_mac.c                           |    6 +-
 drivers/of/of_i2c.c                                |   19 +++
 drivers/pcmcia/electra_cf.c                        |    2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |   12 +-
 drivers/spi/xilinx_spi.c                           |  137 ++++++++++++--------
 include/linux/of_i2c.h                             |    3 +
 61 files changed, 423 insertions(+), 244 deletions(-)
 rename {drivers/i2c/chips => arch/powerpc/platforms/83xx}/mcu_mpc8349emitx.c (100%)


