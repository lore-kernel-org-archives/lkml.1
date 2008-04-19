Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbYDSN0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbYDSN0i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 09:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbYDSN0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 09:26:30 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:28550 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754044AbYDSN03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 09:26:29 -0400
Date: Sat, 19 Apr 2008 22:25:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.26-rc1
Message-ID: <20080419132548.GA23092@linux-sh.org>
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

Angelo Castello (1):
      rtc: rtc-sh: Add support for periodic IRQs.

Magnus Damm (13):
      sh: SuperH KEYSC platform driver
      sh: SuperH KEYSC keypad data for MigoR
      sh: SuperH KEYSC keypad data for Solution Engine 7722
      Fix sh_keysc double free
      sh: Add MigoR header file
      sh: Use physical addresses for sh7722 USBF resources
      sh: Use phyical addresses for MigoR smc91x resources
      sh: MigoR NOR flash support using physmap-flash
      sh: MigoR NAND flash support using gen_flash
      sh: Add I2C platform data to sh7722
      sh: Add I2C support to MigoR
      sh: Add rs5c732b RTC support to MigoR
      sh: Add migor_ts support to MigoR

Masayuki Hosokawa (1):
      sh: Hook up remaining IRQ sources for R7780MP FPGA.

Paul Mundt (11):
      sh: Create an sh debugfs root.
      sh: Initial support for the MX-G CPU.
      sh: Hook up the rest of the SH7770 serial ports.
      sh: Allow optimized clear/copy page routines to be used on SH-2.
      sh: Fix up __access_ok() check for nommu.
      sh: r7780rp: Hook up the I2C and SMBus platform devices.
      sh: Fix up mach-types formatting from merge damage.
      sh: Fix up SH7763 build.
      sh: Add support for SH7723 CPU subtype.
      sh: Fix up SH-4A part probe.
      sh: Fix up L2 cache probe.

Yoshihiro Shimoda (1):
      sh: Add support for Solution Engine SH7721 board

 arch/sh/Kconfig                              |   30 +-
 arch/sh/Kconfig.debug                        |   13 +-
 arch/sh/Makefile                             |    1 +
 arch/sh/boards/renesas/migor/setup.c         |  197 +++++-
 arch/sh/boards/renesas/r7780rp/irq-r7780mp.c |   39 +-
 arch/sh/boards/renesas/r7780rp/setup.c       |   42 +-
 arch/sh/boards/se/7721/Makefile              |    1 +
 arch/sh/boards/se/7721/irq.c                 |   45 ++
 arch/sh/boards/se/7721/setup.c               |   99 +++
 arch/sh/boards/se/7722/setup.c               |   41 +
 arch/sh/configs/se7721_defconfig             | 1085 ++++++++++++++++++++++++++
 arch/sh/kernel/cf-enabler.c                  |   15 +-
 arch/sh/kernel/cpu/sh2a/Makefile             |    7 +-
 arch/sh/kernel/cpu/sh2a/probe.c              |    3 +
 arch/sh/kernel/cpu/sh2a/setup-mxg.c          |  168 ++++
 arch/sh/kernel/cpu/sh4/probe.c               |   33 +-
 arch/sh/kernel/cpu/sh4a/Makefile             |    2 +
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c       |   28 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c       |  300 +++++++
 arch/sh/kernel/cpu/sh4a/setup-sh7763.c       |   10 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7770.c       |   37 +-
 arch/sh/kernel/setup.c                       |   15 +
 arch/sh/lib/clear_page.S                     |    6 +-
 arch/sh/lib/copy_page.S                      |    6 +-
 arch/sh/mm/cache-debugfs.c                   |    4 +-
 arch/sh/mm/pmb.c                             |    2 +-
 arch/sh/tools/mach-types                     |    5 +-
 drivers/input/keyboard/Kconfig               |    9 +
 drivers/input/keyboard/Makefile              |    1 +
 drivers/input/keyboard/sh_keysc.c            |  280 +++++++
 drivers/rtc/rtc-sh.c                         |  296 +++++---
 drivers/serial/sh-sci.c                      |    7 +-
 drivers/serial/sh-sci.h                      |   60 ++-
 include/asm-sh/bugs.h                        |    2 +-
 include/asm-sh/cpu-sh4/freq.h                |    6 +-
 include/asm-sh/cpu-sh4/rtc.h                 |    5 +
 include/asm-sh/migor.h                       |   58 ++
 include/asm-sh/processor.h                   |    5 +-
 include/asm-sh/r7780rp.h                     |   22 +-
 include/asm-sh/se7721.h                      |   70 ++
 include/asm-sh/se7722.h                      |    2 +
 include/asm-sh/sh_keysc.h                    |   13 +
 include/asm-sh/system.h                      |    2 +
 include/asm-sh/uaccess_32.h                  |    5 +-
 44 files changed, 2858 insertions(+), 219 deletions(-)
 create mode 100644 arch/sh/boards/se/7721/Makefile
 create mode 100644 arch/sh/boards/se/7721/irq.c
 create mode 100644 arch/sh/boards/se/7721/setup.c
 create mode 100644 arch/sh/configs/se7721_defconfig
 create mode 100644 arch/sh/kernel/cpu/sh2a/setup-mxg.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/setup-sh7723.c
 create mode 100644 drivers/input/keyboard/sh_keysc.c
 create mode 100644 include/asm-sh/migor.h
 create mode 100644 include/asm-sh/se7721.h
 create mode 100644 include/asm-sh/sh_keysc.h
