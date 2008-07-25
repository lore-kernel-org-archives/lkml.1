Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbYGYINl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbYGYINl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 04:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYGYINZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 04:13:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:57941 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbYGYINX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 04:13:23 -0400
Subject: [git pull] Please pull from powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 25 Jul 2008 18:13:10 +1000
Message-Id: <1216973590.11188.99.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's what should be the last batch of 'features' for powerpc for
this merge window, unless I missed something.

The binfmt_elf change is the one discussed earlier, acked by
Andrew, just slightly rebased on top of another binfmt_elf
patch that went in in the meantime.

﻿git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Cheers,
Ben.

 Documentation/powerpc/booting-without-of.txt    |   57 +
 arch/powerpc/kernel/cputable.c                  |   11 
 arch/powerpc/kernel/entry_32.S                  |    6 
 arch/powerpc/kernel/iommu.c                     |   28 +
 arch/powerpc/kernel/lparcfg.c                   |  386 ++++++---
 arch/powerpc/kernel/process.c                   |   46 +
 arch/powerpc/kernel/prom_init.c                 |    9 
 arch/powerpc/kernel/ptrace.c                    |   72 +-
 arch/powerpc/kernel/signal.c                    |    6 
 arch/powerpc/kernel/sysfs.c                     |    3 
 arch/powerpc/kernel/traps.c                     |   16 
 arch/powerpc/kernel/vio.c                       | 1033 +++++++++++++++++++++++
 arch/powerpc/kernel/vmlinux.lds.S               |    2 
 arch/powerpc/mm/fault.c                         |   25 -
 arch/powerpc/platforms/52xx/Kconfig             |    2 
 arch/powerpc/platforms/cell/iommu.c             |   16 
 arch/powerpc/platforms/cell/spufs/sched.c       |   35 +
 arch/powerpc/platforms/cell/spufs/sputrace.c    |    3 
 arch/powerpc/platforms/iseries/iommu.c          |    3 
 arch/powerpc/platforms/pasemi/iommu.c           |    3 
 arch/powerpc/platforms/pseries/Kconfig          |   23 +
 arch/powerpc/platforms/pseries/Makefile         |    1 
 arch/powerpc/platforms/pseries/cmm.c            |  468 ++++++++++
 arch/powerpc/platforms/pseries/iommu.c          |   42 +
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   10 
 arch/powerpc/platforms/pseries/setup.c          |   71 ++
 arch/powerpc/sysdev/dart_iommu.c                |    3 
 drivers/net/ibmveth.c                           |  189 +++-
 drivers/net/ibmveth.h                           |    5 
 drivers/of/of_i2c.c                             |    2 
 drivers/scsi/ibmvscsi/ibmvfc.c                  |   15 
 drivers/scsi/ibmvscsi/ibmvscsi.c                |   45 +
 drivers/scsi/ibmvscsi/ibmvscsi.h                |    2 
 fs/binfmt_elf.c                                 |   28 +
 include/asm-powerpc/cputable.h                  |    2 
 include/asm-powerpc/elf.h                       |    8 
 include/asm-powerpc/firmware.h                  |    3 
 include/asm-powerpc/hvcall.h                    |   23 -
 include/asm-powerpc/lppaca.h                    |    5 
 include/asm-powerpc/machdep.h                   |    2 
 include/asm-powerpc/mpc52xx_psc.h               |   40 +
 include/asm-powerpc/pgtable.h                   |   13 
 include/asm-powerpc/syscalls.h                  |    1 
 include/asm-powerpc/systbl.h                    |    6 
 include/asm-powerpc/system.h                    |    2 
 include/asm-powerpc/tlbflush.h                  |   11 
 include/asm-powerpc/unistd.h                    |    8 
 include/asm-powerpc/vio.h                       |   27 +
 include/linux/auxvec.h                          |    6 
 49 files changed, 2546 insertions(+), 277 deletions(-)
 create mode 100644 arch/powerpc/platforms/pseries/cmm.c

Andre Detsch (2):
      powerpc/spufs: fix aff_mutex and cbe_spu_info[n].list_mutex deadlock
      powerpc/spufs: better placement of spu affinity reference context

Benjamin Herrenschmidt (1):
      Move update_mmu_cache() declaration from tlbflush.h to pgtable.h

Brian King (4):
      powerpc/pseries: Utilities to set firmware page state
      powerpc/pseries: Add collaborative memory manager
      powerpc/pseries: Add CMO paging statistics
      ibmvfc: Add support for collaborative memory overcommit

Grant Likely (3):
      powerpc/mpc5200: Make mpc5200 GPIO driver select the GENERIC_GPIO config
      powerpc/mpc5200: add PSC SICR bit definitions
      of-bindings: Add binding documentation for SPI busses and devices

Jon Smirl (2):
      powerpc/mpc5200: Add AC97 register definitions for the MPC52xx PSC
      powerpc/mpc5200: Remove fsl-soc.c from mpc5200 build, it is not needed.

Luis Machado (1):
      powerpc: BookE hardware watchpoint support

Mark Nelson (1):
      powerpc/cell: Fixed IOMMU mapping uses weak ordering for a pcie endpoint

Milton Miller (1):
      powerpc/spufs: correct kcalloc usage

Nathan Fontenot (5):
      powerpc/pseries: Remove extraneous error reporting for hcall failures in lparcfg
      powerpc/pseries: Add memory entitlement capabilities to /proc/ppc64/lparcfg
      powerpc/pseries: Verify CMO memory entitlement updates with virtual I/O
      powerpc/pseries: Update arch vector to indicate support for CMO
      powerpc/pseries: Remove kmalloc call in handling writes to lparcfg

Nathan Fotenot (1):
      powerpc/pseries: Split processor entitlement retrieval and gathering to helper routines

Nathan Lynch (2):
      ELF loader support for auxvec base platform string
      powerpc: Enable AT_BASE_PLATFORM aux vector

Robert Jennings (6):
      powerpc/pseries: Split retrieval of processor entitlement data into a helper routine
      powerpc/pseries: Enable CMO feature during platform setup
      powerpc/pseries: iommu enablement for CMO
      powerpc/pseries: vio bus support for CMO
      ibmveth: enable driver for CMO
      ibmvscsi: driver enablement for CMO

Santiago Leon (1):
      ibmveth: Automatically enable larger rx buffer pools for larger mtu

Segher Boessenkool (1):
      powerpc: Fix compile error with binutils 2.15

Stephen Rothwell (1):
      powerpc: Fallout from sysdev API changes

Tony Breeds (1):
      powerpc: Wireup new syscalls

Wolfram Sang (1):
      powerpc/mpc5200: Fix wrong 'no interrupt' handling in of_i2c



