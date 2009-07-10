Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbZGJMhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbZGJMhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZGJMg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:36:57 -0400
Received: from smtp.nokia.com ([192.100.122.233]:34832 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZGJMgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:36:55 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
Date: Fri, 10 Jul 2009 15:40:04 +0300
Message-Id: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
Subject: [PATCH 0/32] mmc and omap_hsmmc patches
X-OriginalArrivalTime: 10 Jul 2009 12:36:28.0238 (UTC) FILETIME=[0BA33EE0:01CA015B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre

Here are 32 patches for mmc and omap_hsmmc.

Sorry there are so many.

They mostly relate to trying to save power.

They split into 2 groups: the first 8 affect mmc core only
and the remaining ones affect omap_hsmmc only.

They apply cleanly on top of Linux 2.6.31-rc2

Adrian Hunter (20):
      mmc: add 'enable' and 'disable' methods to mmc host
      mmc: allow host claim / release nesting
      mmc: add MMC_CAP_NONREMOVABLE host capability
      mmc: add ability to save power by powering off cards
      mmc: add host capabilities for SD only and MMC only
      mmc: check status after MMC SWITCH command
      omap_hsmmc: make use of new enable/disable interface
      omap_hsmmc: keep track of power mode
      omap_hsmmc: ensure workqueues are empty before suspend
      omap_hsmmc: make use of new MMC_CAP_NONREMOVABLE host capability
      ARM: OMAP: mmc-twl4030: add regulator sleep / wake function
      omap_hsmmc: put MMC regulator to sleep
      omap_hsmmc: clear interrupt status after init sequence
      omap_hsmmc: cater for weird CMD6 behaviour
      omap_hsmmc: prevent races with irq handler
      omap_hsmmc: pass host capabilities for SD only and MMC only
      omap_hsmmc: protect the card when the cover is open
      omap_hsmmc: ensure all clock enables and disables are paired
      omap_hsmmc: set a large data timeout for commands with busy signal
      ARM: OMAP: RX51: set MMC capabilities and power-saving flag

Denis Karpov (8):
      mmc: power off once at removal
      omap_hsmmc: add debugfs entry (host registers)
      ARM: OMAP: mmc-twl4030: add context loss counter support
      omap_hsmmc: context save/restore support
      omap_hsmmc: set open drain bit correctly
      omap_hsmmc: support for deeper power saving states
      omap_hsmmc: cleanup macro usage
      omap_hsmmc: code refactoring

Jarkko Lavinen (4):
      mmc: add mmc card sleep and awake support
      omap_hsmmc: fix scatter-gather list sanity checking
      omap_hsmmc: add mmc card sleep and awake support
      omap_hsmmc: fix NULL pointer dereference

 arch/arm/mach-omap2/board-rx51-peripherals.c |    5 +
 arch/arm/mach-omap2/mmc-twl4030.c            |   77 ++
 arch/arm/mach-omap2/mmc-twl4030.h            |    2 +
 arch/arm/plat-omap/include/mach/mmc.h        |   11 +
 drivers/mmc/core/core.c                      |  288 +++++++-
 drivers/mmc/core/core.h                      |    4 +
 drivers/mmc/core/host.c                      |    1 +
 drivers/mmc/core/host.h                      |    2 +
 drivers/mmc/core/mmc.c                       |  130 +++-
 drivers/mmc/core/mmc_ops.c                   |   59 ++
 drivers/mmc/core/mmc_ops.h                   |    1 +
 drivers/mmc/core/sd.c                        |   52 ++-
 drivers/mmc/host/omap_hsmmc.c                | 1025 +++++++++++++++++++++-----
 include/linux/mmc/card.h                     |    2 +
 include/linux/mmc/core.h                     |    1 +
 include/linux/mmc/host.h                     |   65 ++
 include/linux/mmc/mmc.h                      |    3 +
 17 files changed, 1512 insertions(+), 216 deletions(-)


Regards
Adrian
