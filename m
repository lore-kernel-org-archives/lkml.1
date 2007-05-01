Return-Path: <linux-kernel-owner+w=401wt.eu-S965712AbXEAPX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965712AbXEAPX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965687AbXEAPX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:23:29 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:36444 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965712AbXEAPX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:23:27 -0400
Message-ID: <46375B18.4080802@drzeus.cx>
Date: Tue, 01 May 2007 17:22:00 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070414)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 drivers/misc/tifm_7xx1.c                  |  332 +++----
 drivers/misc/tifm_core.c                  |  305 +++--
 drivers/mmc/Kconfig                       |  106 +--
 drivers/mmc/Makefile                      |   33 +-
 drivers/mmc/card/Kconfig                  |   17 +
 drivers/mmc/card/Makefile                 |   11 +
 drivers/mmc/{mmc_block.c => card/block.c} |   55 +-
 drivers/mmc/{mmc_queue.c => card/queue.c} |   12 +-
 drivers/mmc/{mmc_queue.h => card/queue.h} |    0
 drivers/mmc/core/Kconfig                  |   17 +
 drivers/mmc/core/Makefile                 |   11 +
 drivers/mmc/core/core.c                   |  727 ++++++++++++
 drivers/mmc/core/core.h                   |   70 ++
 drivers/mmc/core/mmc.c                    |  537 +++++++++
 drivers/mmc/core/mmc_ops.c                |  276 +++++
 drivers/mmc/core/mmc_ops.h                |   27 +
 drivers/mmc/core/sd.c                     |  587 ++++++++++
 drivers/mmc/core/sd_ops.c                 |  316 ++++++
 drivers/mmc/core/sd_ops.h                 |   25 +
 drivers/mmc/{mmc_sysfs.c => core/sysfs.c} |   11 +-
 drivers/mmc/{mmc.h => core/sysfs.h}       |   10 +-
 drivers/mmc/host/Kconfig                  |  103 ++
 drivers/mmc/host/Makefile                 |   18 +
 drivers/mmc/{ => host}/at91_mci.c         |    1 -
 drivers/mmc/{ => host}/au1xmmc.c          |    1 -
 drivers/mmc/{ => host}/au1xmmc.h          |    0
 drivers/mmc/{ => host}/imxmmc.c           |    1 -
 drivers/mmc/{ => host}/imxmmc.h           |    0
 drivers/mmc/{ => host}/mmci.c             |    1 -
 drivers/mmc/{ => host}/mmci.h             |    0
 drivers/mmc/{ => host}/omap.c             |   56 +-
 drivers/mmc/{ => host}/pxamci.c           |    1 -
 drivers/mmc/{ => host}/pxamci.h           |    0
 drivers/mmc/{ => host}/sdhci.c            |   43 +-
 drivers/mmc/{ => host}/sdhci.h            |    4 +-
 drivers/mmc/host/tifm_sd.c                | 1102 ++++++++++++++++++
 drivers/mmc/{ => host}/wbsd.c             |  205 +---
 drivers/mmc/{ => host}/wbsd.h             |    9 +-
 drivers/mmc/mmc.c                         | 1724 -----------------------------
 drivers/mmc/tifm_sd.c                     |  987 -----------------
 include/asm-arm/arch-imx/mmc.h            |    2 +-
 include/asm-arm/arch-pxa/mmc.h            |    2 +-
 include/asm-arm/mach/mmc.h                |    2 +-
 include/linux/mmc/card.h                  |   32 +-
 include/linux/mmc/core.h                  |  112 ++
 include/linux/mmc/host.h                  |   59 +-
 include/linux/mmc/mmc.h                   |  322 ++++--
 include/linux/mmc/protocol.h              |  327 ------
 include/linux/mmc/sd.h                    |   83 ++
 include/linux/tifm.h                      |  117 +-
 50 files changed, 4858 insertions(+), 3941 deletions(-)

Adrian Bunk (1):
      mmc: make tifm_sd_set_dma_data() static

Alex Dubov (18):
      mmc: cull sg list to match mmc request size
      tifm: hide details of interrupt processing from socket drivers
      tifm: use bus methods to handle probe/remove instead of driver ones.
      tifm: simplify bus match and uevent handlers
      tifm: replace per-adapter kthread with freezeable workqueue
      tifm_7xx1: improve card detection routine
      tifm: move common adapter management tasks from tifm_7xx1 to tifm_core
      tifm: move common device management tasks from tifm_7xx1 to tifm_core
      tifm_7xx1: fix adapter resume function
      tifm: add sysfs attribute for tifm devices
      tifm_sd: remove tifm_sd_terminate function
      tifm_sd: remove wait for power off on remove
      tifm_sd: separate command flags, socket flags and register bit masks
      tifm_sd: merge dma and pio request processing paths
      tifm_sd: replace command completion state machine with full checking
      tifm_sd: fix resume handler
      tifm_sd: implement software scatter-gather
      tifm: layout fixes, small changes to comments and printfs

Andrew Morton (1):
      tifm: add missing include for DMA_32BIT_MASK

Arnaud Patard (1):
      mmc-omap: add missing '\n'

Philip Langdale (2):
      MMC: Consolidate voltage definitions
      MMC: Fix handling of low-voltage cards

Pierre Ossman (21):
      mmc: enforce correct sg list
      wbsd: remove block crc test
      mmc: use right timing mode constant
      mmc: MMC sector based cards
      mmc: add type field to cards
      mmc: Move OCR bit defines
      mmc: Move "present" marking
      mmc: Move queue functions to mmc_block
      mmc: Move host and card drivers to subdirs
      mmc: Flush pending detects on host removal
      mmc: allow suspended block driver to be removed
      mmc: remove card upon suspend
      mmc: deprecate mmc bus topology
      mmc: Move core functions to subdir
      mmc: Separate out protocol ops
      wbsd: check for data opcode earlier
      mmc: add bus handler
      mmc: break apart switch function
      mmc: separate out reading EXT_CSD
      mmc: support unsafe resume of cards
      mmc: remove old card states

Tony Lindgren (2):
      mmc-omap: Fix omap to use MMC_POWER_ON
      mmc-omap: Clean up omap set_ios and make MMC_POWER_ON work


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
