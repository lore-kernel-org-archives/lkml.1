Return-Path: <linux-kernel-owner+w=401wt.eu-S1752092AbYJUH4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbYJUH4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 03:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbYJUH4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 03:56:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:38264 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbYJUH4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 03:56:21 -0400
Subject: [git pull] Please pull from powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 18:56:05 +1100
Message-Id: <1224575765.7654.251.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

This is the remaining powerpc bits for this merge window (minus -maybe-
some kdump related stuff that Paul we'll see tomorrow, in any case,
it's not in this batch).

Nothing terribly fancy, mostly bug fixes, a few new embedded boards,
some serious fixes to Cell SPU oprofile.

A few things outside of arch/powerpc / drivers/of that should either
have appropriate ack's or be powerpc specific drivers unless I screwed
up.

Cheers,
Ben.

The following changes since commit 2515ddc6db8eb49a79f0fe5e67ff09ac7c81eab4:
  Paul Mundt (1):
        binfmt_elf_fdpic: Update for cputime changes.

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git master

Andre Detsch (2):
      powerpc/spufs: Improve search of node for contexts with SPU affinity
      powerpc/spufs: Explain conditional decrement of aff_sched_count

Anton Vorontsov (3):
      powerpc: Remove device_type = "board_control" properties in .dts files
      powerpc/83xx: Add support for MCU microcontroller in .dts files
      powerpc/83xx: Add DS1339 RTC support for MPC8349E-mITX boards .dts

Benjamin Herrenschmidt (4):
      Merge commit 'jwb/jwb-next'
      Merge commit 'gcl/gcl-next'
      Merge commit 'kumar/kumar-for-2.6.28'
      Merge commit 'origin' into master

Carl Love (1):
      powerpc/oprofile: Fix mutex locking for cell spu-oprofile

Ed Swarthout (1):
      powerpc/85xx: Fix mpc8536ds dma interrupt numbers

Grant Likely (2):
      powerpc/52xx: Make cuImage more robust in locating immr node.
      powerpc: Add missing cuImage.initrd.% target

Jason Jin (1):
      powerpc/85xx: Enable enhanced functions for 8536 TSEC

Jeremy Kerr (6):
      powerpc/spufs: sputrace: Only enable logging on open(), prevent multiple openers
      powerpc/spufs: sputrace: Don't block until the read buffer is full
      powerpc/spufs: Use state_mutex for switch_log locking, and prevent multiple openers
      powerpc/spufs: Don't require full buffer in switch_log read
      powerpc/spufs: Don't spu_acquire_saved unnecessarily in regs read
      powerpc/spufs: Use kmalloc rather than kzalloc for switch log buffer

Jon Smirl (1):
      of: Format string bug in drivers/of/of_i2c.c

Jon Tollefson (1):
      powerpc/numa: Make memory reserve code more robust

Josh Boyer (6):
      powerpc/40x: AMCC PowerPC 405EZ Acadia DTS
      powerpc/40x: Add AMCC PowerPC 405EZ to cputable
      powerpc/40x: Add PowerPC 40x simple platform support
      powerpc/40x: Add cuboot wrapper for Acadia board
      powerpc/40x: Add PowerPC 405EZ Acadia defconfig
      ibm_newemac: Fix new MAL feature handling

Kumar Gala (3):
      powerpc: Fix build issue with CONFIG_RELOCATABLE=y
      powerpc: Remove Kconfig support for PPC_MERGE
      powerpc/85xx: Move mpc8572ds.dts to address-cells/size-cells = <2>

Mike Ditto (1):
      powerpc: Fix boot wrapper memcmp() called with zero length argument

Milton Miller (4):
      powerpc: Find and destroy possible stale kernel added properties
      powerpc: Use cpu_thread_in_core in smp_init for of_spin_map
      powerpc: Always trim numa memory to lmb_end_of_DRAM()
      powerpc: Delete unused prom_strtoul and prom_memparse

Nathan Fontenot (1):
      powerpc/pseries: Validate PFN in pseries_remove_lmb()

Niklaus Giger (1):
      powerpc/40x: Add support for Netstal HCU4 board

Paul Mackerras (1):
      powerpc: Revert CHRP boot wrapper to real-base = 12MB on 32-bit

Sebastian Siewior (1):
      powerpc/boot: Compare _start against ei.loadsize instead ei.memsize

Steven A. Falco (1):
      powerpc/4xx: Add PowerPC 4xx GPIO driver

Wolfgang Ocker (1):
      of/spi: Support specifying chip select as active high via device tree

Wolfram Sang (3):
      powerpc/mpc5200: Don't touch pipelining for MPC5200B
      powerpc/mpc5200: Refactor FEC mdio read/write routines
      i2c-cpm: Suppress autoprobing for devices

roel kluin (1):
      powerpc: Unsigned speed cannot be negative in udbg_16559.c

 Documentation/powerpc/booting-without-of.txt     |    2 +
 Documentation/powerpc/dts-bindings/fsl/board.txt |    4 +-
 arch/powerpc/Kconfig                             |    3 -
 arch/powerpc/boot/Makefile                       |    7 +-
 arch/powerpc/boot/addnote.c                      |   41 +-
 arch/powerpc/boot/cuboot-52xx.c                  |    4 +
 arch/powerpc/boot/cuboot-acadia.c                |  174 ++++
 arch/powerpc/boot/dts/acadia.dts                 |  224 ++++++
 arch/powerpc/boot/dts/hcu4.dts                   |  168 ++++
 arch/powerpc/boot/dts/mpc8315erdb.dts            |    8 +
 arch/powerpc/boot/dts/mpc832x_mds.dts            |    2 +-
 arch/powerpc/boot/dts/mpc8349emitx.dts           |   16 +
 arch/powerpc/boot/dts/mpc8349emitxgp.dts         |    8 +
 arch/powerpc/boot/dts/mpc834x_mds.dts            |    2 +-
 arch/powerpc/boot/dts/mpc836x_mds.dts            |    2 +-
 arch/powerpc/boot/dts/mpc8377_rdb.dts            |    8 +
 arch/powerpc/boot/dts/mpc8378_rdb.dts            |    8 +
 arch/powerpc/boot/dts/mpc8379_rdb.dts            |    8 +
 arch/powerpc/boot/dts/mpc8536ds.dts              |   12 +-
 arch/powerpc/boot/dts/mpc8568mds.dts             |    2 +-
 arch/powerpc/boot/dts/mpc8572ds.dts              |   27 +-
 arch/powerpc/boot/libfdt-wrapper.c               |   16 +-
 arch/powerpc/boot/main.c                         |   14 +-
 arch/powerpc/boot/string.S                       |    4 +-
 arch/powerpc/boot/wrapper                        |    5 +-
 arch/powerpc/configs/40x/acadia_defconfig        |  921 +++++++++++++++++++++
 arch/powerpc/configs/40x/hcu4_defconfig          |  929 ++++++++++++++++++++++
 arch/powerpc/include/asm/page.h                  |    1 +
 arch/powerpc/kernel/cputable.c                   |   13 +
 arch/powerpc/kernel/machine_kexec_64.c           |   13 +
 arch/powerpc/kernel/prom_init.c                  |   61 --
 arch/powerpc/kernel/prom_init_check.sh           |    2 +-
 arch/powerpc/kernel/udbg_16550.c                 |    2 +-
 arch/powerpc/mm/numa.c                           |   21 +-
 arch/powerpc/oprofile/cell/pr_util.h             |   13 +
 arch/powerpc/oprofile/cell/spu_profiler.c        |    4 +-
 arch/powerpc/oprofile/cell/spu_task_sync.c       |  236 +++++-
 arch/powerpc/platforms/40x/Kconfig               |   38 +
 arch/powerpc/platforms/40x/Makefile              |    2 +
 arch/powerpc/platforms/40x/hcu4.c                |   61 ++
 arch/powerpc/platforms/40x/ppc40x_simple.c       |   80 ++
 arch/powerpc/platforms/44x/Kconfig               |    8 +
 arch/powerpc/platforms/52xx/mpc52xx_common.c     |    7 +-
 arch/powerpc/platforms/cell/smp.c                |   10 +-
 arch/powerpc/platforms/cell/spufs/file.c         |  155 +++--
 arch/powerpc/platforms/cell/spufs/run.c          |    3 +-
 arch/powerpc/platforms/cell/spufs/sched.c        |   24 +-
 arch/powerpc/platforms/cell/spufs/spufs.h        |    1 -
 arch/powerpc/platforms/cell/spufs/sputrace.c     |   37 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c  |    6 +
 arch/powerpc/platforms/pseries/smp.c             |   13 +-
 arch/powerpc/sysdev/Makefile                     |    1 +
 arch/powerpc/sysdev/ppc4xx_gpio.c                |  217 +++++
 drivers/i2c/busses/i2c-cpm.c                     |    1 -
 drivers/net/fec_mpc52xx_phy.c                    |   55 +-
 drivers/net/ibm_newemac/core.c                   |   10 +-
 drivers/net/ibm_newemac/mal.c                    |   15 +-
 drivers/of/of_i2c.c                              |    2 +-
 drivers/of/of_spi.c                              |    2 +
 drivers/oprofile/buffer_sync.c                   |   24 +
 drivers/oprofile/cpu_buffer.c                    |   15 +-
 drivers/oprofile/event_buffer.h                  |    7 +
 include/linux/oprofile.h                         |   16 +-
 63 files changed, 3507 insertions(+), 288 deletions(-)
 create mode 100644 arch/powerpc/boot/cuboot-acadia.c
 create mode 100644 arch/powerpc/boot/dts/acadia.dts
 create mode 100644 arch/powerpc/boot/dts/hcu4.dts
 create mode 100644 arch/powerpc/configs/40x/acadia_defconfig
 create mode 100644 arch/powerpc/configs/40x/hcu4_defconfig
 create mode 100644 arch/powerpc/platforms/40x/hcu4.c
 create mode 100644 arch/powerpc/platforms/40x/ppc40x_simple.c
 create mode 100644 arch/powerpc/sysdev/ppc4xx_gpio.c


