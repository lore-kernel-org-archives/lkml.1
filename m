Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbYJaJIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbYJaJIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 05:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbYJaJII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 05:08:08 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:25149 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752947AbYJaJIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 05:08:06 -0400
Date: Fri, 31 Oct 2008 18:07:26 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.28-rc3
Message-ID: <20081031090726.GA3615@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Harvey Harrison (1):
      sh: use the new byteorder headers.

Kuninori Morimoto (4):
      sh: Provide a sample defconfig for the UL2 (SH7366) board.
      SH 7366 needs SCIF_ONLY
      Add support usb setting on sh 7366
      sh: Enable NFS root in Migo-R defconfig.

Matt Fleming (1):
      Define SCSPTR1 for SH 7751R

Michael Trimarchi (1):
      sh: Fix up the shared IRQ demuxer's control bit testing logic.

Nobuhiro Iwamatsu (3):
      gdrom: Fix compile error
      sh: Change register name SCSPTR to SCSPTR2
      sh: Add sci_rxd_in of SH4-202

Paul Mundt (10):
      serial: sh-sci: Kill off all of the SCI/SCIF special casing.
      sh: oprofile: Fix up the SH7750 performance counter name.
      sh: Fix FPU tuning on toolchains with mismatched multilib targets.
      sh: Add on-chip RTC support for SH7722.
      sh: sh7785lcr: Select uImage as default image target.
      sh: Simplify and lock down the ISA tuning.
      sh: Revert "SH 7366 needs SCIF_ONLY"
      sh: Kill off long-dead HD64465 cchip support.
      sh: SHmedia ISA tuning fixups.
      sh: FTRACE renamed to FUNCTION_TRACER.

Yoshihiro Shimoda (1):
      sh: fix sh2a cache entry_mask

 Documentation/sh/new-machine.txt        |    4 +-
 arch/sh/Kconfig                         |    2 +-
 arch/sh/Makefile                        |   31 +-
 arch/sh/boot/compressed/Makefile_32     |    2 +-
 arch/sh/cchips/Kconfig                  |   33 -
 arch/sh/cchips/hd6446x/Makefile         |    1 -
 arch/sh/cchips/hd6446x/hd64465/Makefile |    6 -
 arch/sh/cchips/hd6446x/hd64465/gpio.c   |  196 ------
 arch/sh/cchips/hd6446x/hd64465/io.c     |  211 ------
 arch/sh/cchips/hd6446x/hd64465/setup.c  |  181 -----
 arch/sh/configs/migor_defconfig         |   35 +-
 arch/sh/configs/ul2_defconfig           | 1169 +++++++++++++++++++++++++++++++
 arch/sh/include/asm/byteorder.h         |   36 +-
 arch/sh/include/asm/hd64465/gpio.h      |   46 --
 arch/sh/include/asm/hd64465/hd64465.h   |  256 -------
 arch/sh/include/asm/hd64465/io.h        |   44 --
 arch/sh/include/asm/serial.h            |   17 -
 arch/sh/include/cpu-sh4/cpu/rtc.h       |    2 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c  |   28 +
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c  |   34 +-
 arch/sh/kernel/entry-common.S           |    4 +-
 arch/sh/kernel/sh_ksyms_32.c            |   13 +-
 arch/sh/mm/cache-sh2a.c                 |    8 +-
 arch/sh/oprofile/op_model_sh7750.c      |    6 +-
 arch/sh/tools/mach-types                |    1 -
 drivers/cdrom/gdrom.c                   |    5 +-
 drivers/pcmcia/Kconfig                  |    4 -
 drivers/pcmcia/Makefile                 |    1 -
 drivers/pcmcia/hd64465_ss.c             |  939 -------------------------
 drivers/serial/sh-sci.c                 |   40 +-
 drivers/serial/sh-sci.h                 |   96 +--
 31 files changed, 1357 insertions(+), 2094 deletions(-)
 delete mode 100644 arch/sh/cchips/hd6446x/hd64465/Makefile
 delete mode 100644 arch/sh/cchips/hd6446x/hd64465/gpio.c
 delete mode 100644 arch/sh/cchips/hd6446x/hd64465/io.c
 delete mode 100644 arch/sh/cchips/hd6446x/hd64465/setup.c
 create mode 100644 arch/sh/configs/ul2_defconfig
 delete mode 100644 arch/sh/include/asm/hd64465/gpio.h
 delete mode 100644 arch/sh/include/asm/hd64465/hd64465.h
 delete mode 100644 arch/sh/include/asm/hd64465/io.h
 delete mode 100644 drivers/pcmcia/hd64465_ss.c
