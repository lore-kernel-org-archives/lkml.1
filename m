Return-Path: <linux-kernel-owner+w=401wt.eu-S1760699AbZAUKmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699AbZAUKmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbZAUKl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:41:59 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:53038 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752931AbZAUKl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:41:58 -0500
Date: Wed, 21 Jan 2009 19:39:12 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.29-rc3
Message-ID: <20090121103912.GC17836@linux-sh.org>
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

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.29

Which contains:

Adrian McMenamin (1):
      dma-coherent: per-device coherent area is in pages, not bytes.

Julia Lawall (1):
      arch/sh/mm: Move a dereference below a NULL test

Kuninori Morimoto (3):
      sh: mach-migor: Add ov772x support.
      sh: mach-migor: Delete soc_camera_platform setup.
      sh: mach-migor: Add tw9910 support.

Magnus Damm (4):
      sh: ap325rxa MMC support using spi_gpio and mmc_spi
      sh: Migo-R MMC support using spi_gpio and mmc_spi.
      sh: export the sh7343 JPU to user space
      sh: fix sh-sci / early printk build on sh7723

Mike Frysinger (1):
      asm-sh/posix_types_{32,64}.h: drop __GLIBC__/__USE_ALL usage

Paul Mundt (8):
      sh: Drop the BKL from sys_execve() on SH-5.
      sh: mach-x3proto: needs linux/irq.h.
      sh: sh7785lcr/highlander/hp6xx need linux/irq.h.
      sh: Kill off obsolete busses from arch/sh/Kconfig.
      serial: sh-sci: Fix up SH7720/SH7721 SCI build.
      sh: update defconfigs.
      nommu: Stub in vm_map_ram()/vm_unmap_ram()/vm_unmap_aliases().
      dma-coherent: Restore dma_alloc_from_coherent() large alloc fall back policy.

SUGIOKA Toshinobu (1):
      sh: fix unaligned and nonexistent address handling

Steve Glendinning (3):
      sh: convert ap325rxa platform to use smsc911x.
      sh: convert magicpanelr2 platform to use smsc911x.
      sh: convert rsk7203 to use smsc911x.

 arch/sh/Kconfig                           |   63 +-----
 arch/sh/boards/board-ap325rxa.c           |   53 ++++-
 arch/sh/boards/board-magicpanelr2.c       |   23 ++-
 arch/sh/boards/board-sh7785lcr.c          |    1 +
 arch/sh/boards/mach-highlander/setup.c    |    1 +
 arch/sh/boards/mach-hp6xx/setup.c         |    2 +-
 arch/sh/boards/mach-migor/setup.c         |  171 ++++++--------
 arch/sh/boards/mach-rsk/devices-rsk7203.c |   24 +-
 arch/sh/boards/mach-x3proto/setup.c       |    1 +
 arch/sh/configs/ap325rxa_defconfig        |  355 ++++++++++++++++++++++++++---
 arch/sh/configs/dreamcast_defconfig       |   60 ++++--
 arch/sh/configs/edosk7705_defconfig       |   18 +-
 arch/sh/configs/edosk7760_defconfig       |   83 +++++--
 arch/sh/configs/hp6xx_defconfig           |   88 ++++----
 arch/sh/configs/landisk_defconfig         |   76 +++++--
 arch/sh/configs/lboxre2_defconfig         |   63 ++++--
 arch/sh/configs/magicpanelr2_defconfig    |  119 +++++++---
 arch/sh/configs/microdev_defconfig        |   63 ++++--
 arch/sh/configs/migor_defconfig           |   95 ++++++--
 arch/sh/configs/r7780mp_defconfig         |   85 ++++++--
 arch/sh/configs/r7785rp_defconfig         |  130 ++++++++---
 arch/sh/configs/rsk7201_defconfig         |   26 ++-
 arch/sh/configs/rsk7203_defconfig         |   88 ++++++--
 arch/sh/configs/rts7751r2d1_defconfig     |   87 +++++--
 arch/sh/configs/rts7751r2dplus_defconfig  |   87 +++++--
 arch/sh/configs/sdk7780_defconfig         |  101 ++++++---
 arch/sh/configs/se7206_defconfig          |   75 +++++--
 arch/sh/configs/se7343_defconfig          |   61 +++--
 arch/sh/configs/se7619_defconfig          |   47 +++--
 arch/sh/configs/se7705_defconfig          |   60 +++--
 arch/sh/configs/se7712_defconfig          |   79 +++++--
 arch/sh/configs/se7721_defconfig          |   85 +++++---
 arch/sh/configs/se7722_defconfig          |   61 +++--
 arch/sh/configs/se7750_defconfig          |   61 +++--
 arch/sh/configs/se7751_defconfig          |   56 +++--
 arch/sh/configs/se7780_defconfig          |   87 +++++---
 arch/sh/configs/sh03_defconfig            |   82 +++++--
 arch/sh/configs/sh7710voipgw_defconfig    |   55 +++--
 arch/sh/configs/sh7763rdp_defconfig       |   71 ++++--
 arch/sh/configs/sh7785lcr_defconfig       |   92 +++++---
 arch/sh/configs/shmin_defconfig           |   54 +++--
 arch/sh/configs/shx3_defconfig            |   77 +++++--
 arch/sh/configs/snapgear_defconfig        |   53 +++--
 arch/sh/configs/systemh_defconfig         |   50 +++--
 arch/sh/configs/titan_defconfig           |   90 +++++--
 arch/sh/configs/ul2_defconfig             |   69 ++++--
 arch/sh/include/asm/posix_types_32.h      |    8 +-
 arch/sh/include/asm/posix_types_64.h      |    8 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7343.c    |   31 +++
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c    |    2 +-
 arch/sh/kernel/process_64.c               |    2 -
 arch/sh/kernel/traps_32.c                 |    9 +-
 arch/sh/mm/ioremap_64.c                   |    2 +-
 drivers/serial/sh-sci.h                   |    5 +-
 kernel/dma-coherent.c                     |   47 ++--
 mm/nommu.c                                |   20 ++-
 56 files changed, 2368 insertions(+), 1094 deletions(-)
