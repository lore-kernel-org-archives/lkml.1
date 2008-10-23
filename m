Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbYJWGAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbYJWGAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 02:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYJWF7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 01:59:52 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:35702 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751032AbYJWF7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 01:59:51 -0400
Date: Thu, 23 Oct 2008 14:59:24 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.28-rc1, part 2.
Message-ID: <20081023055924.GA22111@linux-sh.org>
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

Andrew Morton (1):
      sh: Kill off duplicate remove_memory() definition.

Guennadi Liakhovetski (1):
      sh: fix soc-camera compile breakage on Migo-R.

Magnus Damm (5):
      sh: update ov772x byte order on Migo-R
      sh: Update gpio_set_value() pin value handling
      sh: use 10MHz VIO_CLK for ov772x on Migo-R
      sh: improve pinmux support for single direction pins
      sh: sh7785 pinmux support

Paul Mundt (15):
      sh: Fix up the SH7203 build.
      sh: arch/sh/kernel/smp.c needs linux/cpu.h for notify_cpu_starting().
      sh: gpio: Include asm-generic/gpio.h for non-gpiolib stubs.
      sh: rsk7203: leds-gpio support for RSK+ LEDs.
      sh: gpio: Stub in dummy GPIO<->IRQ mapping routines.
      sh: ap325rxa: Move off of hardcoded pinmux for flctl initialization.
      sh: Hook up PB0->PB7 input-only pins in SH7203 PFC.
      sh: ap325rxa: Kill off unused port definitions.
      sh: Wire up oops reporting in the die notifier chain.
      sh: Export cache flush routines needed by sh_eth on SH7619.
      rtc: Add R2025S/D comment to rs5c372 Kconfig entry.
      sh: Kill off unused p1fc divisors from SH7763 clk fwk.
      sh: update defconfigs.
      sh: mach-highlander: Handle SCIF pinmuxing on R7785RP.
      sh: asm/gpio.h needs linux/kernel.h for might_sleep()/WARN_ON().

Yoshihiro Shimoda (1):
      sh: add support FLCTL for ap325rxa board

 arch/sh/boards/board-ap325rxa.c                 |   64 +-
 arch/sh/boards/board-rsk7203.c                  |   44 +-
 arch/sh/boards/mach-highlander/Kconfig          |    1 +
 arch/sh/boards/mach-highlander/Makefile         |   10 +-
 arch/sh/boards/mach-highlander/pinmux-r7785rp.c |   20 +
 arch/sh/boards/mach-highlander/setup.c          |    2 +
 arch/sh/boards/mach-migor/setup.c               |   18 +-
 arch/sh/configs/ap325rxa_defconfig              |   72 +-
 arch/sh/configs/cayman_defconfig                |  406 ++++++--
 arch/sh/configs/dreamcast_defconfig             |   76 +-
 arch/sh/configs/edosk7760_defconfig             |  168 ++--
 arch/sh/configs/hp6xx_defconfig                 |   65 +-
 arch/sh/configs/landisk_defconfig               |  129 ++-
 arch/sh/configs/lboxre2_defconfig               |   88 ++-
 arch/sh/configs/magicpanelr2_defconfig          |   78 +-
 arch/sh/configs/microdev_defconfig              |   83 +-
 arch/sh/configs/migor_defconfig                 |  125 ++-
 arch/sh/configs/r7780mp_defconfig               |  223 ++++-
 arch/sh/configs/r7785rp_defconfig               |  280 +++++-
 arch/sh/configs/rsk7203_defconfig               |  111 ++-
 arch/sh/configs/rts7751r2d1_defconfig           |  121 ++-
 arch/sh/configs/rts7751r2dplus_defconfig        |  121 ++-
 arch/sh/configs/rts7751r2dplus_qemu_defconfig   |   72 +-
 arch/sh/configs/sdk7780_defconfig               |  135 ++-
 arch/sh/configs/se7206_defconfig                |   75 +-
 arch/sh/configs/se7343_defconfig                |   80 +-
 arch/sh/configs/se7619_defconfig                |   56 +-
 arch/sh/configs/se7705_defconfig                |  659 ++++++-------
 arch/sh/configs/se7712_defconfig                |  113 ++-
 arch/sh/configs/se7721_defconfig                |  263 ++++--
 arch/sh/configs/se7722_defconfig                |  458 +++++----
 arch/sh/configs/se7750_defconfig                |  700 ++++++-------
 arch/sh/configs/se7751_defconfig                |  693 ++++++------
 arch/sh/configs/se7780_defconfig                |  292 ++++--
 arch/sh/configs/sh03_defconfig                  |  801 ++++++++-------
 arch/sh/configs/sh7710voipgw_defconfig          |  222 +++--
 arch/sh/configs/sh7763rdp_defconfig             |   75 +-
 arch/sh/configs/sh7785lcr_defconfig             |  199 +++-
 arch/sh/configs/shmin_defconfig                 |  639 ++++++------
 arch/sh/configs/shx3_defconfig                  |  627 +++++++++--
 arch/sh/configs/snapgear_defconfig              |  237 +++--
 arch/sh/configs/systemh_defconfig               |  478 ++++-----
 arch/sh/configs/titan_defconfig                 | 1061 +++++++++----------
 arch/sh/include/asm/gpio.h                      |   19 +-
 arch/sh/include/asm/kdebug.h                    |    1 +
 arch/sh/include/cpu-sh4/cpu/sh7785.h            |  234 ++++
 arch/sh/include/mach-common/mach/highlander.h   |    6 +
 arch/sh/kernel/cpu/sh2a/pinmux-sh7203.c         |   30 +-
 arch/sh/kernel/cpu/sh4a/Makefile                |    1 +
 arch/sh/kernel/cpu/sh4a/clock-sh7763.c          |    1 -
 arch/sh/kernel/cpu/sh4a/pinmux-sh7785.c         | 1310 +++++++++++++++++++++++
 arch/sh/kernel/gpio.c                           |    8 +-
 arch/sh/kernel/sh_ksyms_32.c                    |    7 +-
 arch/sh/kernel/smp.c                            |    1 +
 arch/sh/kernel/traps_32.c                       |    2 +
 arch/sh/mm/init.c                               |   17 -
 drivers/rtc/Kconfig                             |    4 +-
 57 files changed, 7836 insertions(+), 4045 deletions(-)
 create mode 100644 arch/sh/boards/mach-highlander/pinmux-r7785rp.c
 create mode 100644 arch/sh/include/cpu-sh4/cpu/sh7785.h
 create mode 100644 arch/sh/kernel/cpu/sh4a/pinmux-sh7785.c
