Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbYGXMDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbYGXMDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYGXMDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:03:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:44237 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbYGXMDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:03:06 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: ralf@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] mips kgdb support rev 2
Date: Thu, 24 Jul 2008 07:02:53 -0500
Message-Id: <1216900975-9869-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.5.1
X-OriginalArrivalTime: 24 Jul 2008 12:02:56.0748 (UTC) FILETIME=[35B3FAC0:01C8ED85]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is rev 2 of the kgdb support.  Based on comments from Ralf, I elected
to switch to die notification and entirely remove the trap_low, which
was not getting dynamically unregistered in the first place after kgdb
was unconfigured.

This greatly simplified the kgdb implementation for mips, and allowed for
the deprecation of a couple more headers and a large chunk of assembly
code.

Jason.

The following changes since commit 338b9bb3adac0d2c5a1e180491d9b001d624c402:
  Linus Torvalds (1):
        Merge branch 'x86/auditsc' of git://git.kernel.org/.../frob/linux-2.6-roland

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git kgdb-next

Jason Wessel (2):
      kgdb, mips: Remove existing kgdb implementation
      kgdb, mips: add arch support for the kernel's kgdb core

 arch/mips/Kconfig                          |    7 +-
 arch/mips/Kconfig.debug                    |   22 -
 arch/mips/au1000/Kconfig                   |    1 -
 arch/mips/au1000/common/Makefile           |    1 -
 arch/mips/au1000/common/dbg_io.c           |  109 ---
 arch/mips/basler/excite/Makefile           |    1 -
 arch/mips/basler/excite/excite_dbg_io.c    |  121 ---
 arch/mips/basler/excite/excite_irq.c       |    7 -
 arch/mips/basler/excite/excite_setup.c     |    4 +-
 arch/mips/configs/db1000_defconfig         |    1 -
 arch/mips/configs/db1100_defconfig         |    1 -
 arch/mips/configs/db1200_defconfig         |    1 -
 arch/mips/configs/db1500_defconfig         |    1 -
 arch/mips/configs/db1550_defconfig         |    1 -
 arch/mips/configs/excite_defconfig         |    1 -
 arch/mips/configs/ip27_defconfig           |    1 -
 arch/mips/configs/msp71xx_defconfig        |    2 -
 arch/mips/configs/mtx1_defconfig           |    1 -
 arch/mips/configs/pb1100_defconfig         |    1 -
 arch/mips/configs/pb1500_defconfig         |    1 -
 arch/mips/configs/pb1550_defconfig         |    1 -
 arch/mips/configs/pnx8550-jbs_defconfig    |    4 +-
 arch/mips/configs/pnx8550-stb810_defconfig |    4 +-
 arch/mips/configs/rbtx49xx_defconfig       |    1 -
 arch/mips/configs/sb1250-swarm_defconfig   |    1 -
 arch/mips/configs/yosemite_defconfig       |    2 -
 arch/mips/emma2rh/markeins/platform.c      |    1 -
 arch/mips/emma2rh/markeins/setup.c         |    1 -
 arch/mips/kernel/Makefile                  |    2 +-
 arch/mips/kernel/gdb-low.S                 |  394 ----------
 arch/mips/kernel/gdb-stub.c                | 1155 ----------------------------
 arch/mips/kernel/irq.c                     |   30 +-
 arch/mips/kernel/kgdb.c                    |  256 ++++++
 arch/mips/kernel/traps.c                   |   21 +
 arch/mips/mti-malta/Makefile               |    1 -
 arch/mips/mti-malta/malta-init.c           |   54 --
 arch/mips/mti-malta/malta-kgdb.c           |  133 ----
 arch/mips/mti-malta/malta-setup.c          |    4 -
 arch/mips/nxp/pnx8550/common/Makefile      |    1 -
 arch/mips/nxp/pnx8550/common/gdb_hook.c    |  109 ---
 arch/mips/nxp/pnx8550/common/int.c         |    1 -
 arch/mips/nxp/pnx8550/common/proc.c        |    1 -
 arch/mips/nxp/pnx8550/common/setup.c       |   12 -
 arch/mips/pmc-sierra/msp71xx/msp_serial.c  |   73 --
 arch/mips/pmc-sierra/yosemite/Makefile     |    1 -
 arch/mips/pmc-sierra/yosemite/dbg_io.c     |  180 -----
 arch/mips/pmc-sierra/yosemite/irq.c        |    9 -
 arch/mips/sgi-ip22/ip22-setup.c            |   25 -
 arch/mips/sgi-ip27/Makefile                |    1 -
 arch/mips/sgi-ip27/ip27-dbgio.c            |   60 --
 arch/mips/sibyte/bcm1480/irq.c             |   80 --
 arch/mips/sibyte/cfe/setup.c               |   14 -
 arch/mips/sibyte/sb1250/irq.c              |   60 --
 arch/mips/sibyte/swarm/Makefile            |    1 -
 arch/mips/sibyte/swarm/dbg_io.c            |   76 --
 arch/mips/txx9/Kconfig                     |    2 -
 arch/mips/txx9/generic/Makefile            |    1 -
 arch/mips/txx9/generic/dbgio.c             |   48 --
 arch/mips/txx9/jmr3927/Makefile            |    1 -
 arch/mips/txx9/jmr3927/kgdb_io.c           |  105 ---
 include/asm-mips/gdb-stub.h                |  215 ------
 include/asm-mips/kdebug.h                  |   14 +-
 include/asm-mips/kgdb.h                    |   54 ++
 63 files changed, 362 insertions(+), 3132 deletions(-)
 delete mode 100644 arch/mips/au1000/common/dbg_io.c
 delete mode 100644 arch/mips/basler/excite/excite_dbg_io.c
 delete mode 100644 arch/mips/kernel/gdb-low.S
 delete mode 100644 arch/mips/kernel/gdb-stub.c
 create mode 100644 arch/mips/kernel/kgdb.c
 delete mode 100644 arch/mips/mti-malta/malta-kgdb.c
 delete mode 100644 arch/mips/nxp/pnx8550/common/gdb_hook.c
 delete mode 100644 arch/mips/pmc-sierra/yosemite/dbg_io.c
 delete mode 100644 arch/mips/sgi-ip27/ip27-dbgio.c
 delete mode 100644 arch/mips/sibyte/swarm/dbg_io.c
 delete mode 100644 arch/mips/txx9/generic/dbgio.c
 delete mode 100644 arch/mips/txx9/jmr3927/kgdb_io.c
 delete mode 100644 include/asm-mips/gdb-stub.h
 create mode 100644 include/asm-mips/kgdb.h
