Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbZAHFkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbZAHFkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 00:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbZAHFkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 00:40:05 -0500
Received: from gate.crashing.org ([63.228.1.57]:53157 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbZAHFkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 00:40:03 -0500
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 16:39:46 +1100
Message-Id: <1231393186.2142.47.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

The following changes since commit 9e42d0cf5020aaf217433cad1a224745241d212a:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/sparc-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

Those are remaining bits for this merge window that didn't quite make it in
the previous batch. Mostly arch/powerpc though you'll find a couple of
new drivers: The long awaited PS3 video ram driver in drivers/mtd
(David Woodhouse is happy for us to merge it via our tree) and the Cell
Network Processor serial in drivers/serial (Alan Cox reviewed it)

There's also a couple of one liner Kconfig fixe in drivers/scsi and
drivers/serial for iseries related drivers.

I don't expect much more now. There may be a handful still pending
from freescale that were waiting for dependent patches to go in via
some maintainers, but at worst they can probably make -rc1. I will
push the big u64 change from unsigned long to unsigned long long
after that, along with a handful of related fixups.

Please let me know what I screwed up this time !

Cheers,
Ben.

Anton Vorontsov (14):
      powerpc: Implement get_brgfreq() and get_baudrate() stubs
      powerpc/83xx: Fix sparse warnings in board files
      powerpc/83xx: Fix sparse warnings in mpc836x_mds.c
      powerpc/qe: Implement QE Pin Multiplexing API
      powerpc: Add device tree bindings for BCSR GPIO banks
      powerpc: Implement GPIO driver for simple memory-mapped banks
      powerpc/83xx: Add USB Host/Gadget support for MPC8360E-MDS boards
      powerpc/83xx: Add USB Host support for MPC8360E-RDK boards
      powerpc/fsl_pci: Fix sparse warnings
      powerpc/83xx: Fix few build errors with CONFIG_QUICC_ENGINE=n
      powerpc/qe: Fix few build errors with CONFIG_QUICC_ENGINE=n
      powerpc/qe: Select QE_USB with USB_GADGET_FSL_QE
      powerpc/kdump: Use ppc_save_regs() in crash_setup_regs()
      powerpc/mm: Make clear_fixmap() actually work

Becky Bruce (1):
      powerpc/86xx: Update 8641hpcn dts file to match latest u-boot

Benjamin Herrenschmidt (4):
      Merge commit 'kumar/kumar-next' into next
      Merge commit 'origin/master' into next
      powerpc/pci: Reserve legacy regions on PCI
      powerpc: Fix missing semicolons in mmu_decl.h

Benjamin Krill (1):
      serial: Add driver for the Cell Network Processor serial port NWP device

Dave Hansen (4):
      powerpc/mm: Add better comment on careful_allocation()
      powerpc/mm:: Cleanup careful_allocation(): bootmem already panics
      powerpc/mm: Make careful_allocation() return virtual addrs
      powerpc/mm: Cleanup careful_allocation(): consolidate memset()

Dave Liu (1):
      powerpc: Remove the redundant _tlbil_pid at SMP case

Geert Uytterhoeven (1):
      mtd/ps3vram: Add modalias support to the ps3vram driver

Geoff Levand (5):
      mtd/ps3vram: Remove ps3vram debug routines
      mtd/ps3vram: Cleanup ps3vram driver messages
      mtd/ps3vram: Use proper kernel types
      mtd/ps3vram: Use msleep in waits
      mtd/ps3vram: Use _PAGE_NO_CACHE in memory ioremap

Grant Likely (1):
      powerpc: Copy bootable images in the default install script

Ingo Molnar (4):
      powerpc: Use correct type in prom_init.c
      powerpc/cell: Use correct types in beat files
      powerpc/cell: Fix some u64 vs. long types
      powerpc/pasemi: local_irq_save uses an unsigned long

Jim Paris (1):
      mtd/ps3vram: Add ps3vram driver for accessing video RAM as MTD

Julia Lawall (3):
      powerpc/85xx: Add local_irq_restore in error handling code
      powerpc/52xx: Use DEFINE_SPINLOCK
      powerpc/pasemi: Use DEFINE_SPINLOCK

Kamalesh Babulal (1):
      powerpc: Fix iseries drivers build failure without CONFIG_VIOPATH

Kumar Gala (3):
      powerpc/85xx: Enable SMP support
      powerpc/85xx: Add SMP support to MPC8572 DS
      powerpc: Export cacheable_memzero as its now used in a driver

Matthias Fuchs (1):
      powerpc: Add ioctls for RS485 mode control of serial drivers

Michael Ellerman (1):
      powerpc/iseries: Kexec is known not to work on iseries

Mohan Kumar M (1):
      powerpc: Enable RELOCATABLE option for CRASH_DUMP

Nathan Lynch (1):
      powerpc: Rewrite sysfs processor cache info code

Nicolas Palix (1):
      powerpc/powermac: Add missing of_node_put

Paul Mackerras (1):
      powerpc: Fix pciconfig_iobase system call on PCI-Express powermac

Stephen Rothwell (4):
      powerpc/cell: Bitops work on unsigned longs
      powerpc/cell: local_irq_save takes an unsigned long
      powerpc: Remove unnecessary casts
      powerpc/cell: Fix the prototype of create_vma_map()

Steven Rostedt (1):
      powerpc: enable dynamic ftrace

 Documentation/powerpc/dts-bindings/fsl/board.txt   |   32 +-
 MAINTAINERS                                        |    6 +
 arch/powerpc/Kconfig                               |    5 +-
 arch/powerpc/boot/Makefile                         |    2 +-
 arch/powerpc/boot/dts/mpc836x_mds.dts              |   43 +-
 arch/powerpc/boot/dts/mpc836x_rdk.dts              |   19 +-
 arch/powerpc/boot/dts/mpc8641_hpcn.dts             |   56 +-
 arch/powerpc/boot/install.sh                       |   14 +-
 arch/powerpc/configs/85xx/mpc8572_ds_defconfig     |   43 +-
 arch/powerpc/include/asm/ioctls.h                  |    2 +
 arch/powerpc/include/asm/kexec.h                   |   55 --
 arch/powerpc/include/asm/ps3.h                     |    2 +
 arch/powerpc/include/asm/qe.h                      |   37 +-
 arch/powerpc/include/asm/qe_ic.h                   |   21 +-
 arch/powerpc/include/asm/spu.h                     |    2 +-
 arch/powerpc/kernel/Makefile                       |    2 +-
 arch/powerpc/kernel/cacheinfo.c                    |  837 ++++++++++++++++++++
 arch/powerpc/kernel/cacheinfo.h                    |    8 +
 arch/powerpc/kernel/pci-common.c                   |   71 ++-
 arch/powerpc/kernel/pci_64.c                       |    9 +-
 arch/powerpc/kernel/ppc_ksyms.c                    |    1 +
 arch/powerpc/kernel/prom.c                         |   14 +-
 arch/powerpc/kernel/prom_init.c                    |    2 +-
 arch/powerpc/kernel/sysfs.c                        |  300 +-------
 arch/powerpc/mm/mmu_decl.h                         |    6 +-
 arch/powerpc/mm/numa.c                             |   62 +-
 arch/powerpc/mm/pgtable_32.c                       |    3 +-
 arch/powerpc/mm/tlb_nohash.c                       |    3 +-
 arch/powerpc/oprofile/cell/pr_util.h               |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_common.c       |    2 +-
 arch/powerpc/platforms/83xx/mpc831x_rdb.c          |    2 +-
 arch/powerpc/platforms/83xx/mpc832x_mds.c          |    9 +-
 arch/powerpc/platforms/83xx/mpc832x_rdb.c          |    5 +-
 arch/powerpc/platforms/83xx/mpc836x_mds.c          |   81 ++-
 arch/powerpc/platforms/83xx/mpc836x_rdk.c          |    6 +-
 arch/powerpc/platforms/83xx/mpc837x_mds.c          |    1 -
 arch/powerpc/platforms/83xx/mpc837x_rdb.c          |    2 -
 arch/powerpc/platforms/83xx/mpc83xx.h              |    1 +
 arch/powerpc/platforms/85xx/mpc85xx_ds.c           |    7 +
 arch/powerpc/platforms/85xx/smp.c                  |    1 +
 arch/powerpc/platforms/Kconfig                     |   11 +
 arch/powerpc/platforms/Kconfig.cputype             |    2 +-
 arch/powerpc/platforms/cell/beat_htab.c            |   21 +-
 arch/powerpc/platforms/cell/beat_udbg.c            |    4 +-
 .../powerpc/platforms/cell/cbe_cpufreq_pervasive.c |    2 +-
 arch/powerpc/platforms/cell/interrupt.c            |    2 +-
 arch/powerpc/platforms/cell/io-workarounds.c       |    4 +-
 arch/powerpc/platforms/cell/iommu.c                |    4 +-
 arch/powerpc/platforms/iseries/Kconfig             |    5 +-
 arch/powerpc/platforms/iseries/setup.c             |   11 +
 arch/powerpc/platforms/pasemi/cpufreq.c            |    2 +-
 arch/powerpc/platforms/pasemi/dma_lib.c            |    2 +-
 arch/powerpc/platforms/powermac/pci.c              |    2 +
 arch/powerpc/platforms/powermac/time.c             |   11 +-
 arch/powerpc/platforms/ps3/device-init.c           |   37 +
 arch/powerpc/sysdev/Makefile                       |    1 +
 arch/powerpc/sysdev/fsl_pci.c                      |    7 +-
 arch/powerpc/sysdev/fsl_soc.h                      |    5 +
 arch/powerpc/sysdev/qe_lib/Kconfig                 |    3 +-
 arch/powerpc/sysdev/qe_lib/gpio.c                  |  195 +++++
 arch/powerpc/sysdev/simple_gpio.c                  |  155 ++++
 arch/powerpc/sysdev/simple_gpio.h                  |   12 +
 drivers/char/Kconfig                               |    1 +
 drivers/char/hvc_beat.c                            |    4 +-
 drivers/mtd/devices/Kconfig                        |    7 +
 drivers/mtd/devices/Makefile                       |    1 +
 drivers/mtd/devices/ps3vram.c                      |  768 ++++++++++++++++++
 drivers/scsi/Kconfig                               |    1 +
 drivers/serial/Kconfig                             |   19 +-
 drivers/serial/Makefile                            |    1 +
 drivers/serial/nwpserial.c                         |  475 +++++++++++
 drivers/serial/of_serial.c                         |   19 +
 include/linux/nwpserial.h                          |   18 +
 include/linux/serial_core.h                        |    3 +
 74 files changed, 3089 insertions(+), 502 deletions(-)
 create mode 100644 arch/powerpc/kernel/cacheinfo.c
 create mode 100644 arch/powerpc/kernel/cacheinfo.h
 create mode 100644 arch/powerpc/sysdev/simple_gpio.c
 create mode 100644 arch/powerpc/sysdev/simple_gpio.h
 create mode 100644 drivers/mtd/devices/ps3vram.c
 create mode 100644 drivers/serial/nwpserial.c
 create mode 100644 include/linux/nwpserial.h


