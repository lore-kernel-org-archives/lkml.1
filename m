Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0BOGjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:39:31 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:48292 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab0BOGj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:39:29 -0500
Date: Mon, 15 Feb 2010 15:39:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: What's in genesis-2.6.git for 2.6.34?
Message-ID: <20100215063916.GG18636@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This includes the initial support for the SH-Mobile G series CPUs, a
series of ARM/SH multi-cores composed of SH IP blocks with this tree
handling the ARM MPU side of things.

The SH tree has been cleaning up and reorganizing code in preparation for
these CPUs for some time, and now that that is basically done, it's time
to roll the ARM support code in.

This includes support for the SH-Mobile G3, G4, and AP4 CPUs, along with
their respective reference boards (G3EVM, G4EVM, AP4EVB). At this point
this is just preliminary support, containing little more than serial and
timers. Much of the heavy lifting has yet to be done, and will roll over
to 2.6.35. The bits bound for 2.6.34 are enough to allow people to start
tinkering with the platform, however.

As the tree was only created a little over a week ago, it's only been in
-next for roughly the same amount of time, but as it's wholly insular
there really shouldn't be any surprises for anyone on the ARM or SH side
of things.

The tree is at:

	git://git.kernel.org/pub/scm/linux/kernel/git/lethal/genesis-2.6.git

and contains:

Kuninori Morimoto (1):
      ARM: mach-shmobile: intc-sh7372 tidyup

Magnus Damm (15):
      serial: sh-sci: remove SCIF code in sci_rxd_in()
      ARM: mach-shmobile: SH-Mobile G3 support.
      ARM: mach-shmobile: SH-Mobile G4 support.
      ARM: mach-shmobile: SH-Mobile AP4 support.
      sh: Build drivers/sh for ARM-based SH-Mobile CPUs.
      sh: Let INTC set IRQF_VALID on ARM platforms.
      serial: sh-sci: Support ARM-based SH-Mobile CPUs.
      ARM: mach-shmobile: G3EVM, G4EVM and AP4EVB defconfigs
      ARM: mach-shmobile: optimize get_irqnr_preamble/and_base macros
      ARM: mach-shmobile: early console support using earlyprintk
      ARM: mach-shmobile: sh7367 INTCA support
      ARM: mach-shmobile: sh7377 INTCA support
      ARM: mach-shmobile: sh7372 INTCA support
      ARM: mach-shmobile: sh7367 and G3EVM pinmux support
      ARM: mach-shmobile: G3EVM USBHS support

NISHIMOTO Hiroki (2):
      ARM: mach-shmobile: sh7377 and G4EVM pinmux support
      ARM: mach-shmobile: G4EVM USBHS support

Paul Mundt (1):
      MAINTAINERS: Add entry for ARM-based SH-Mobile architecture.

 MAINTAINERS                                       |   10 +
 arch/arm/Kconfig                                  |    7 +
 arch/arm/Makefile                                 |    1 +
 arch/arm/configs/ap4evb_defconfig                 |  779 +++++++++
 arch/arm/configs/g3evm_defconfig                  |  774 +++++++++
 arch/arm/configs/g4evm_defconfig                  |  779 +++++++++
 arch/arm/mach-shmobile/Kconfig                    |   83 +
 arch/arm/mach-shmobile/Makefile                   |   21 +
 arch/arm/mach-shmobile/Makefile.boot              |    9 +
 arch/arm/mach-shmobile/board-ap4evb.c             |  128 ++
 arch/arm/mach-shmobile/board-g3evm.c              |  211 +++
 arch/arm/mach-shmobile/board-g4evm.c              |  211 +++
 arch/arm/mach-shmobile/clock-sh7367.c             |   96 ++
 arch/arm/mach-shmobile/console.c                  |   31 +
 arch/arm/mach-shmobile/include/mach/clkdev.h      |    7 +
 arch/arm/mach-shmobile/include/mach/common.h      |   22 +
 arch/arm/mach-shmobile/include/mach/dma.h         |    1 +
 arch/arm/mach-shmobile/include/mach/entry-macro.S |   39 +
 arch/arm/mach-shmobile/include/mach/gpio.h        |   48 +
 arch/arm/mach-shmobile/include/mach/hardware.h    |    7 +
 arch/arm/mach-shmobile/include/mach/io.h          |    9 +
 arch/arm/mach-shmobile/include/mach/irqs.h        |   10 +
 arch/arm/mach-shmobile/include/mach/memory.h      |    7 +
 arch/arm/mach-shmobile/include/mach/sh7367.h      |  332 ++++
 arch/arm/mach-shmobile/include/mach/sh7377.h      |  360 ++++
 arch/arm/mach-shmobile/include/mach/system.h      |   14 +
 arch/arm/mach-shmobile/include/mach/timex.h       |    6 +
 arch/arm/mach-shmobile/include/mach/uncompress.h  |   21 +
 arch/arm/mach-shmobile/include/mach/vmalloc.h     |    6 +
 arch/arm/mach-shmobile/intc-sh7367.c              |  270 +++
 arch/arm/mach-shmobile/intc-sh7372.c              |  369 +++++
 arch/arm/mach-shmobile/intc-sh7377.c              |  350 ++++
 arch/arm/mach-shmobile/pfc-sh7367.c               | 1801 +++++++++++++++++++++
 arch/arm/mach-shmobile/pfc-sh7377.c               | 1766 ++++++++++++++++++++
 arch/arm/mach-shmobile/setup-sh7367.c             |  198 +++
 arch/arm/mach-shmobile/setup-sh7372.c             |  199 +++
 arch/arm/mach-shmobile/setup-sh7377.c             |  215 +++
 arch/arm/mach-shmobile/timer.c                    |   46 +
 drivers/Makefile                                  |    1 +
 drivers/serial/Kconfig                            |    2 +-
 drivers/serial/sh-sci.h                           |  242 +---
 drivers/sh/intc.c                                 |   10 +-
 42 files changed, 9269 insertions(+), 229 deletions(-)
 create mode 100644 arch/arm/configs/ap4evb_defconfig
 create mode 100644 arch/arm/configs/g3evm_defconfig
 create mode 100644 arch/arm/configs/g4evm_defconfig
 create mode 100644 arch/arm/mach-shmobile/Kconfig
 create mode 100644 arch/arm/mach-shmobile/Makefile
 create mode 100644 arch/arm/mach-shmobile/Makefile.boot
 create mode 100644 arch/arm/mach-shmobile/board-ap4evb.c
 create mode 100644 arch/arm/mach-shmobile/board-g3evm.c
 create mode 100644 arch/arm/mach-shmobile/board-g4evm.c
 create mode 100644 arch/arm/mach-shmobile/clock-sh7367.c
 create mode 100644 arch/arm/mach-shmobile/console.c
 create mode 100644 arch/arm/mach-shmobile/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-shmobile/include/mach/common.h
 create mode 100644 arch/arm/mach-shmobile/include/mach/dma.h
 create mode 100644 arch/arm/mach-shmobile/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-shmobile/include/mach/gpio.h
 create mode 100644 arch/arm/mach-shmobile/include/mach/hardware.h
 create mode 100644 arch/arm/mach-shmobile/include/mach/io.h
 create mode 100644 arch/arm/mach-shmobile/include/mach/irqs.h
 create mode 100644 arch/arm/mach-shmobile/include/mach/memory.h
 create mode 100644 arch/arm/mach-shmobile/include/mach/sh7367.h
 create mode 100644 arch/arm/mach-shmobile/include/mach/sh7377.h
 create mode 100644 arch/arm/mach-shmobile/include/mach/system.h
 create mode 100644 arch/arm/mach-shmobile/include/mach/timex.h
 create mode 100644 arch/arm/mach-shmobile/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-shmobile/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-shmobile/intc-sh7367.c
 create mode 100644 arch/arm/mach-shmobile/intc-sh7372.c
 create mode 100644 arch/arm/mach-shmobile/intc-sh7377.c
 create mode 100644 arch/arm/mach-shmobile/pfc-sh7367.c
 create mode 100644 arch/arm/mach-shmobile/pfc-sh7377.c
 create mode 100644 arch/arm/mach-shmobile/setup-sh7367.c
 create mode 100644 arch/arm/mach-shmobile/setup-sh7372.c
 create mode 100644 arch/arm/mach-shmobile/setup-sh7377.c
 create mode 100644 arch/arm/mach-shmobile/timer.c
