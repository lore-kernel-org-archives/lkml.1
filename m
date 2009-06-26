Return-Path: <linux-kernel-owner+w=401wt.eu-S1757128AbZFZHTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128AbZFZHTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 03:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbZFZHT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 03:19:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:37181 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbZFZHTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:19:25 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 17:19:12 +1000
Message-Id: <1246000752.22312.32.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

I would have hoped to get that stuff in before -rc1 but heh, I got sick
for a couple of days, a distracted by some other stuff for a couple more
and here we are, I missed it :-)

Anyway, here are a bunch of relatively small ppc bits, almost all are
bug fixes, mostly regressions, with the notable exception of one patch
which I decided was worth taking a chance, which is the addition of
lockdep/irqtrace support for ppc32 which has been around for 2 or 3
weeks and seems to be working well (it already found a couple of
bugs !).


The following changes since commit 987fed3bf6982f2627d4fa242caa9026ef61132a:
  Linus Torvalds (1):
        Merge branch 'drm-fixes' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Adrian Reber (1):
      powerpc/rtas: Fix watchdog driver temperature read functionality

Anton Vorontsov (1):
      powerpc/85xx: Make eSDHC 1-bit only transfer mode default for MPC8569E-MDS

Benjamin Herrenschmidt (13):
      powerpc/mpic: Fix mapping of "DCR" based MPIC variants
      powerpc/pmac: Fix issues with PowerMac "PowerSurge" SMP
      powerpc/mm: Make k(un)map_atomic out of line
      powerpc/pmac: Fix DMA ops for MacIO devices
      powerpc: Map more memory early on 601 processors
      powerpc: Add irqtrace support for 32-bit powerpc
      powerpc/rtas: Turn rtas lock into a raw spinlock
      powerpc: Use one common impl. of RTAS timebase sync and use raw spinlock
      powerpc/pasemi: Use raw spinlock in SMP TB sync
      powerpc/of: Fix usage of dev_set_name() in of_device_alloc()
      powerpc/440: Fix warning early debug code
      powerpc/mm: Fix potential access to freed pages when using hugetlbfs
      Merge commit 'kumar/next' into merge

Gerhard Pircher (1):
      powerpc/amigaone: Limit ISA I/O range to 4k in the device tree

Huang Weiyi (1):
      powerpc/85xx: remove duplicated #include

Jon Smirl (1):
      powerpc: Have git ignore generated files from dtc compile

Kumar Gala (6):
      powerpc/cpm1: Remove IMAP_ADDR
      powerpc/85xx: Stop using ppc_md.init on socrates
      powerpc/85xx: Fix issue found by lockdep trace in smp_85xx_kick_cpu
      powerpc: Refactor device tree binding
      powerpc: Fix output from show_regs
      powerpc: Fix mpic alloc warning

Michael Ellerman (1):
      powerpc: Swiotlb breaks pseries

Randy Vinson (1):
      powerpc/85xx: Fix FSL RapidIO probing on MDS boards

Sean MacLennan (1):
      powerpc/warp: Platform fix for i2c change

Sonny Rao (2):
      powerpc/BSR: add 4096 byte BSR size
      powerpc/BSR: Fix BSR to allow mmap of small BSR on 64k kernel

Timur Tabi (1):
      powerpc/qe: add polling timeout to qe_issue_cmd()

 Documentation/powerpc/booting-without-of.txt     | 1168 +---------------------
 Documentation/powerpc/dts-bindings/4xx/emac.txt  |  148 +++
 Documentation/powerpc/dts-bindings/gpio/gpio.txt |   50 +
 Documentation/powerpc/dts-bindings/gpio/mdio.txt |   19 +
 Documentation/powerpc/dts-bindings/marvell.txt   |  521 ++++++++++
 Documentation/powerpc/dts-bindings/phy.txt       |   25 +
 Documentation/powerpc/dts-bindings/spi-bus.txt   |   57 ++
 Documentation/powerpc/dts-bindings/usb-ehci.txt  |   25 +
 Documentation/powerpc/dts-bindings/xilinx.txt    |  295 ++++++
 arch/powerpc/Kconfig                             |    1 -
 arch/powerpc/boot/.gitignore                     |   10 +
 arch/powerpc/boot/dts/amigaone.dts               |    4 +-
 arch/powerpc/boot/dts/mpc8569mds.dts             |    1 +
 arch/powerpc/include/asm/cpm1.h                  |    2 -
 arch/powerpc/include/asm/dma-mapping.h           |   24 +-
 arch/powerpc/include/asm/highmem.h               |   57 +-
 arch/powerpc/include/asm/hw_irq.h                |   20 +-
 arch/powerpc/include/asm/pte-hash64-64k.h        |    3 +-
 arch/powerpc/include/asm/rtas.h                  |    5 +-
 arch/powerpc/kernel/entry_32.S                   |  127 +++-
 arch/powerpc/kernel/head_32.S                    |   17 +-
 arch/powerpc/kernel/of_device.c                  |    2 +-
 arch/powerpc/kernel/process.c                    |    2 +-
 arch/powerpc/kernel/rtas.c                       |   69 ++-
 arch/powerpc/kernel/setup_32.c                   |    2 +
 arch/powerpc/kernel/smp.c                        |    3 +-
 arch/powerpc/kernel/udbg_16550.c                 |    2 +-
 arch/powerpc/mm/Makefile                         |    1 +
 arch/powerpc/mm/highmem.c                        |   77 ++
 arch/powerpc/platforms/44x/warp.c                |   44 +-
 arch/powerpc/platforms/85xx/mpc85xx_mds.c        |    1 +
 arch/powerpc/platforms/85xx/smp.c                |    9 +-
 arch/powerpc/platforms/85xx/socrates.c           |    6 +-
 arch/powerpc/platforms/85xx/xes_mpc85xx.c        |    1 -
 arch/powerpc/platforms/cell/smp.c                |   30 +-
 arch/powerpc/platforms/chrp/smp.c                |   33 +-
 arch/powerpc/platforms/pasemi/setup.c            |   15 +-
 arch/powerpc/platforms/powermac/setup.c          |   41 +-
 arch/powerpc/platforms/powermac/smp.c            |  166 ++--
 arch/powerpc/platforms/pseries/smp.c             |   30 +-
 arch/powerpc/sysdev/mpic.c                       |   34 +-
 arch/powerpc/sysdev/qe_lib/qe.c                  |    9 +-
 drivers/char/bsr.c                               |   42 +-
 drivers/macintosh/macio_asic.c                   |   11 +
 drivers/watchdog/wdrtas.c                        |    8 +-
 scripts/dtc/.gitignore                           |    5 +
 46 files changed, 1691 insertions(+), 1531 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/4xx/emac.txt
 create mode 100644 Documentation/powerpc/dts-bindings/gpio/gpio.txt
 create mode 100644 Documentation/powerpc/dts-bindings/gpio/mdio.txt
 create mode 100644 Documentation/powerpc/dts-bindings/marvell.txt
 create mode 100644 Documentation/powerpc/dts-bindings/phy.txt
 create mode 100644 Documentation/powerpc/dts-bindings/spi-bus.txt
 create mode 100644 Documentation/powerpc/dts-bindings/usb-ehci.txt
 create mode 100644 Documentation/powerpc/dts-bindings/xilinx.txt
 create mode 100644 arch/powerpc/mm/highmem.c
 create mode 100644 scripts/dtc/.gitignore



