Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYDYATW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYDYATW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 20:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYDYATP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 20:19:15 -0400
Received: from ozlabs.org ([203.10.76.45]:59178 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbYDYATN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 20:19:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18449.9080.504033.707163@cargo.ozlabs.ibm.com>
Date: Fri, 25 Apr 2008 10:19:04 +1000
From: Paul Mackerras <paulus@samba.org>
To: torvalds@linux-foundation.org
CC: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git master branch
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please do:

git pull \
git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git master

to get another powerpc update.  There are fixes for various problems
that have arisen plus a few patchsets that were not quite ready to go
when I sent the last pull request but now are.

Note that there are some generic changes to include/linux/sched.h and
init/main.c.  They are from a set of 3 patches from Ben H that Andrew
Morton acked and asked us to push through the powerpc tree.

Thanks,
Paul.

 Documentation/powerpc/booting-without-of.txt   |   11 
 MAINTAINERS                                    |   25 +
 arch/powerpc/Kconfig                           |   83 ++
 arch/powerpc/boot/.gitignore                   |    1 
 arch/powerpc/boot/Makefile                     |    2 
 arch/powerpc/boot/dts/canyonlands.dts          |   37 +
 arch/powerpc/boot/dts/glacier.dts              |   37 +
 arch/powerpc/boot/ns16550.c                    |    5 
 arch/powerpc/kernel/Makefile                   |    9 
 arch/powerpc/kernel/asm-offsets.c              |   11 
 arch/powerpc/kernel/cpu_setup_44x.S            |    1 
 arch/powerpc/kernel/cpu_setup_6xx.S            |    8 
 arch/powerpc/kernel/cputable.c                 |    4 
 arch/powerpc/kernel/head_fsl_booke.S           |   11 
 arch/powerpc/kernel/misc_32.S                  |    6 
 arch/powerpc/kernel/misc_64.S                  |   20 -
 arch/powerpc/kernel/of_platform.c              |    2 
 arch/powerpc/kernel/paca.c                     |   87 +-
 arch/powerpc/kernel/ppc32.h                    |    2 
 arch/powerpc/kernel/process.c                  |   31 +
 arch/powerpc/kernel/prom.c                     |    4 
 arch/powerpc/kernel/prom_init_check.sh         |   58 +
 arch/powerpc/kernel/ptrace32.c                 |   27 -
 arch/powerpc/kernel/setup_64.c                 |    5 
 arch/powerpc/kernel/stacktrace.c               |    1 
 arch/powerpc/kernel/udbg.c                     |    4 
 arch/powerpc/mm/fsl_booke_mmu.c                |    2 
 arch/powerpc/mm/hash_low_32.S                  |    4 
 arch/powerpc/mm/init_32.c                      |   13 
 arch/powerpc/mm/init_64.c                      |    3 
 arch/powerpc/mm/mem.c                          |   37 +
 arch/powerpc/mm/numa.c                         |    1 
 arch/powerpc/mm/pgtable_32.c                   |   23 +
 arch/powerpc/platforms/Kconfig                 |    1 
 arch/powerpc/platforms/Kconfig.cputype         |    4 
 arch/powerpc/platforms/Makefile                |    1 
 arch/powerpc/platforms/cell/Kconfig            |   13 
 arch/powerpc/platforms/cell/Makefile           |   20 -
 arch/powerpc/platforms/cell/axon_msi.c         |    6 
 arch/powerpc/platforms/cell/beat.c             |    2 
 arch/powerpc/platforms/cell/beat.h             |    0 
 arch/powerpc/platforms/cell/beat_htab.c        |    0 
 arch/powerpc/platforms/cell/beat_hvCall.S      |    0 
 arch/powerpc/platforms/cell/beat_interrupt.c   |    2 
 arch/powerpc/platforms/cell/beat_interrupt.h   |    0 
 arch/powerpc/platforms/cell/beat_iommu.c       |    0 
 arch/powerpc/platforms/cell/beat_smp.c         |    2 
 arch/powerpc/platforms/cell/beat_spu_priv1.c   |    0 
 arch/powerpc/platforms/cell/beat_syscall.h     |    0 
 arch/powerpc/platforms/cell/beat_udbg.c        |    0 
 arch/powerpc/platforms/cell/beat_wrapper.h     |    0 
 arch/powerpc/platforms/cell/celleb_pci.c       |   50 +
 arch/powerpc/platforms/cell/celleb_pci.h       |   19 
 arch/powerpc/platforms/cell/celleb_scc.h       |   87 ++
 arch/powerpc/platforms/cell/celleb_scc_epci.c  |   77 --
 arch/powerpc/platforms/cell/celleb_scc_pciex.c |  547 ++++++++++++++
 arch/powerpc/platforms/cell/celleb_scc_sio.c   |    0 
 arch/powerpc/platforms/cell/celleb_scc_uhc.c   |    2 
 arch/powerpc/platforms/cell/celleb_setup.c     |   12 
 arch/powerpc/platforms/cell/io-workarounds.c   |  358 +++------
 arch/powerpc/platforms/cell/io-workarounds.h   |   49 +
 arch/powerpc/platforms/cell/setup.c            |   43 +
 arch/powerpc/platforms/cell/spider-pci.c       |  184 +++++
 arch/powerpc/platforms/celleb/Kconfig          |   12 
 arch/powerpc/platforms/celleb/Makefile         |    9 
 arch/powerpc/platforms/celleb/io-workarounds.c |  280 -------
 arch/powerpc/platforms/iseries/exception.S     |   27 +
 arch/powerpc/platforms/ps3/os-area.c           |    1 
 arch/powerpc/platforms/pseries/Kconfig         |    5 
 arch/powerpc/platforms/pseries/Makefile        |    4 
 arch/powerpc/platforms/pseries/eeh.c           |    1 
 arch/powerpc/platforms/pseries/eeh_cache.c     |    1 
 arch/powerpc/platforms/pseries/firmware.c      |   10 
 arch/powerpc/platforms/pseries/iommu.c         |   39 -
 arch/powerpc/platforms/pseries/lpar.c          |   36 -
 arch/powerpc/platforms/pseries/ras.c           |    4 
 arch/powerpc/platforms/pseries/rtasd.c         |   14 
 arch/powerpc/platforms/pseries/scanlog.c       |   23 -
 arch/powerpc/platforms/pseries/setup.c         |   17 
 arch/powerpc/platforms/pseries/smp.c           |   11 
 arch/powerpc/platforms/pseries/xics.c          |    1 
 arch/powerpc/sysdev/mv64x60_dev.c              |   52 +
 arch/powerpc/sysdev/mv64x60_udbg.c             |    2 
 arch/ppc/8260_io/fcc_enet.c                    |   19 
 arch/ppc/8xx_io/enet.c                         |   23 -
 arch/ppc/Kconfig                               |   82 --
 arch/ppc/configs/ads8272_defconfig             |  930 ------------------------
 arch/ppc/configs/mpc86x_ads_defconfig          |  633 ----------------
 arch/ppc/configs/mpc885ads_defconfig           |  622 ----------------
 arch/ppc/kernel/ppc_ksyms.c                    |    1 
 arch/ppc/lib/string.S                          |   14 
 arch/ppc/platforms/Makefile                    |    4 
 arch/ppc/platforms/fads.h                      |   25 -
 arch/ppc/platforms/mpc8272ads_setup.c          |  367 ---------
 arch/ppc/platforms/mpc885ads.h                 |   93 --
 arch/ppc/platforms/mpc885ads_setup.c           |  476 ------------
 arch/ppc/platforms/pq2ads.c                    |   53 -
 arch/ppc/platforms/pq2ads.h                    |   94 --
 arch/ppc/platforms/pq2ads_pd.h                 |   32 -
 arch/ppc/syslib/m8260_setup.c                  |    6 
 arch/ppc/syslib/m82xx_pci.c                    |   38 -
 arch/ppc/syslib/m8xx_setup.c                   |   10 
 drivers/char/xilinx_hwicap/xilinx_hwicap.c     |    2 
 drivers/macintosh/windfarm_pm112.c             |    3 
 drivers/macintosh/windfarm_pm81.c              |    4 
 drivers/macintosh/windfarm_pm91.c              |    3 
 drivers/net/Kconfig                            |    1 
 drivers/of/of_i2c.c                            |    3 
 drivers/serial/of_serial.c                     |   14 
 include/asm-powerpc/fixmap.h                   |  106 +++
 include/asm-powerpc/highmem.h                  |   41 +
 include/asm-powerpc/io-defs.h                  |  101 +--
 include/asm-powerpc/io.h                       |    8 
 include/asm-powerpc/kdump.h                    |    5 
 include/asm-powerpc/paca.h                     |    1 
 include/asm-powerpc/page.h                     |   45 +
 include/asm-powerpc/page_32.h                  |    6 
 include/asm-powerpc/thread_info.h              |    8 
 include/asm-ppc/mmu.h                          |    2 
 include/asm-ppc/mpc8260.h                      |    4 
 include/asm-ppc/mpc8xx.h                       |    4 
 include/linux/sched.h                          |    2 
 init/main.c                                    |    7 
 123 files changed, 1923 insertions(+), 4572 deletions(-)
 create mode 100644 arch/powerpc/kernel/prom_init_check.sh
 rename arch/powerpc/platforms/{celleb/beat.c => cell/beat.c} (99%)
 rename arch/powerpc/platforms/{celleb/beat.h => cell/beat.h} (100%)
 rename arch/powerpc/platforms/{celleb/htab.c => cell/beat_htab.c} (100%)
 rename arch/powerpc/platforms/{celleb/hvCall.S => cell/beat_hvCall.S} (100%)
 rename arch/powerpc/platforms/{celleb/interrupt.c => cell/beat_interrupt.c} (99%)
 rename arch/powerpc/platforms/{celleb/interrupt.h => cell/beat_interrupt.h} (100%)
 rename arch/powerpc/platforms/{celleb/iommu.c => cell/beat_iommu.c} (100%)
 rename arch/powerpc/platforms/{celleb/smp.c => cell/beat_smp.c} (99%)
 rename arch/powerpc/platforms/{celleb/spu_priv1.c => cell/beat_spu_priv1.c} (100%)
 rename arch/powerpc/platforms/{celleb/beat_syscall.h => cell/beat_syscall.h} (100%)
 rename arch/powerpc/platforms/{celleb/udbg_beat.c => cell/beat_udbg.c} (100%)
 rename arch/powerpc/platforms/{celleb/beat_wrapper.h => cell/beat_wrapper.h} (100%)
 rename arch/powerpc/platforms/{celleb/pci.c => cell/celleb_pci.c} (93%)
 rename arch/powerpc/platforms/{celleb/pci.h => cell/celleb_pci.h} (73%)
 rename arch/powerpc/platforms/{celleb/scc.h => cell/celleb_scc.h} (68%)
 rename arch/powerpc/platforms/{celleb/scc_epci.c => cell/celleb_scc_epci.c} (86%)
 create mode 100644 arch/powerpc/platforms/cell/celleb_scc_pciex.c
 rename arch/powerpc/platforms/{celleb/scc_sio.c => cell/celleb_scc_sio.c} (100%)
 rename arch/powerpc/platforms/{celleb/scc_uhc.c => cell/celleb_scc_uhc.c} (99%)
 rename arch/powerpc/platforms/{celleb/setup.c => cell/celleb_setup.c} (97%)
 create mode 100644 arch/powerpc/platforms/cell/io-workarounds.h
 create mode 100644 arch/powerpc/platforms/cell/spider-pci.c
 delete mode 100644 arch/powerpc/platforms/celleb/Kconfig
 delete mode 100644 arch/powerpc/platforms/celleb/Makefile
 delete mode 100644 arch/powerpc/platforms/celleb/io-workarounds.c
 delete mode 100644 arch/ppc/configs/ads8272_defconfig
 delete mode 100644 arch/ppc/configs/mpc86x_ads_defconfig
 delete mode 100644 arch/ppc/configs/mpc885ads_defconfig
 delete mode 100644 arch/ppc/platforms/mpc8272ads_setup.c
 delete mode 100644 arch/ppc/platforms/mpc885ads.h
 delete mode 100644 arch/ppc/platforms/mpc885ads_setup.c
 delete mode 100644 arch/ppc/platforms/pq2ads.c
 delete mode 100644 arch/ppc/platforms/pq2ads.h
 delete mode 100644 arch/ppc/platforms/pq2ads_pd.h
 create mode 100644 include/asm-powerpc/fixmap.h

Adrian Bunk (2):
      [POWERPC] drivers/of/of_i2c.c: Add MODULE_LICENSE
      [POWERPC] char/xilinx_hwicap/ section fix

Benjamin Herrenschmidt (3):
      [POWERPC] Add thread_info_cache_init() weak hook
      [POWERPC] Fix kernel stack allocation alignment
      [POWERPC] Use __weak macro for smp_setup_processor_id

Christoph Hellwig (1):
      [POWERPC] Fix new warnings arising from stacktrace patch

Geoff Levand (1):
      [POWERPC] PS3: Fix gelic net module dependency

Grant Likely (1):
      [POWERPC] bootwrapper: fix build error on virtex405-head.S

Ishizaki Kou (9):
      [POWERPC] cell: Generalize io-workarounds code
      [POWERPC] celleb: Consolidate io-workarounds code
      [POWERPC] celleb: Move the files for celleb base support
      [POWERPC] celleb: Move the SCC related code for celleb
      [POWERPC] celleb: Move files for Beat hvcall interfaces
      [POWERPC] celleb: Move files for Beat mmu and iommu
      [POWERPC] celleb: Move a file for SPU on Beat
      [POWERPC] celleb: Move miscellaneous files for Beat
      [POWERPC] celleb: Add support for PCI Express

John Linn (2):
      [POWERPC] Xilinx: boot support for Xilinx uart 16550.
      [POWERPC] Xilinx: of_serial support for Xilinx uart 16550.

Josh Boyer (2):
      [POWERPC] 4xx: Fix duplicate phys_addr_t definition
      [POWERPC] Add strncmp to arch/ppc

Kay Sievers (1):
      [POWERPC] macintosh/windfarm: Fix platform driver hotplug/coldplug

Kumar Gala (9):
      [PPC] Remove mpc8272 ads board from arch/ppc
      [PPC] Remove mpc885ads and mpc86x ads boards from arch/ppc
      [POWERPC] ppc32: Fix errata for 603 CPUs
      [POWERPC] 85xx: Add support for relocatable kernel (and booting at non-zero)
      [POWERPC] Port fixmap from x86 and use for kmap_atomic
      [POWERPC] Clean up access to thread_info in assembly
      [POWERPC] Cleanup asm-offsets.c
      [POWERPC] Clean up misc_64.S
      [POWERPC] Add zImage.iseries to arch/powerpc/boot/.gitignore

Michael Ellerman (9):
      [POWERPC] Add include of linux/of.h to numa.c
      [POWERPC] Add include of linux/of.h to os-area.c
      [POWERPC] Discourage people from fiddling with kernel data from prom_init
      [POWERPC] Use of_get_next_parent() in platforms/cell/axon_msi.c
      [POWERPC] Set udbg_console index to 0
      [POWERPC] Mark udbg console as CON_ANYTIME, ie. callable early in boot
      [POWERPC] Register udbg console early on pseries LPAR
      [POWERPC] Convert from DBG() to pr_debug() in platforms/pseries/
      [POWERPC] Add CONFIG_PPC_PSERIES_DEBUG to enable debugging for platforms/pseries

Paul Mackerras (1):
      Revert "[POWERPC] Add compat handler for PTRACE_GETSIGINFO"

Remi Machet (3):
      [POWERPC] Use default values if necessary in mv64x60 I2C initialization
      [POWERPC] Initialize all mv64x60 devices even if one fails
      [POWERPC] Fix mv64x60 early console code to use cell-index property

Stefan Roese (2):
      [POWERPC] 4xx: Add NOR FLASH entries to Canyonlands and Glacier dts
      [POWERPC] 4xx: Fix 460GT support to not enable FPU

Timur Tabi (1):
      [POWERPC] Add Timur Tabi to the MAINTAINERS file

Tony Breeds (2):
      [POWERPC] Make iSeries spin on __secondary_hold_spinloop, like pSeries
      [POWERPC] Raise the upper limit of NR_CPUS and move the pacas into the BSS

