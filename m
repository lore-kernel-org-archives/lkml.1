Return-Path: <linux-kernel-owner+w=401wt.eu-S1750992AbXCXNGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992AbXCXNGE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 09:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbXCXNGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 09:06:03 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33347 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750992AbXCXNGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 09:06:00 -0400
Date: Sat, 24 Mar 2007 14:06:02 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.22 patch] more scheduled OSS driver removal
Message-ID: <20070324130602.GD752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the scheduled removal of OSS drivers that:
- have ALSA drivers for the same hardware without known regressions and
- whose Kconfig options have been removed in 2.6.20.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

Due to its size, the patch is available at
ftp://ftp.kernel.org/pub/linux/kernel/people/bunk/misc/patch-remove-oss.gz


 Documentation/feature-removal-schedule.txt |    7 
 Documentation/kernel-parameters.txt        |   10 
 Documentation/sound/oss/AD1816             |   84 
 Documentation/sound/oss/NM256              |  280 -
 Documentation/sound/oss/OPL3-SA2           |  210 
 Documentation/sound/oss/VIA-chipset        |   43 
 Documentation/sound/oss/cs46xx             |  138 
 MAINTAINERS                                |   35 
 drivers/media/radio/Makefile               |    4 
 drivers/media/radio/miropcm20-radio.c      |  266 -
 drivers/media/radio/miropcm20-rds-core.c   |  211 
 drivers/media/radio/miropcm20-rds-core.h   |   19 
 drivers/media/radio/miropcm20-rds.c        |  132 
 sound/oss/Makefile                         |   13 
 sound/oss/ac97.c                           |  432 -
 sound/oss/ac97.h                           |  201 
 sound/oss/aci.c                            |  712 --
 sound/oss/aci.h                            |   57 
 sound/oss/ad1816.c                         | 1368 -----
 sound/oss/ad1889.c                         | 1101 ----
 sound/oss/ad1889.h                         |  135 
 sound/oss/adlib_card.c                     |   73 
 sound/oss/cs461x.h                         | 1691 ------
 sound/oss/cs461x_image.h                   |  322 -
 sound/oss/cs46xx.c                         | 5444 ---------------------
 sound/oss/cs46xx_wrapper-24.h              |   56 
 sound/oss/cs46xxpm.h                       |   70 
 sound/oss/emu10k1/8010.h                   |  737 --
 sound/oss/emu10k1/Makefile                 |   17 
 sound/oss/emu10k1/audio.c                  | 1595 ------
 sound/oss/emu10k1/audio.h                  |   44 
 sound/oss/emu10k1/cardmi.c                 |  832 ---
 sound/oss/emu10k1/cardmi.h                 |   97 
 sound/oss/emu10k1/cardmo.c                 |  229 
 sound/oss/emu10k1/cardmo.h                 |   62 
 sound/oss/emu10k1/cardwi.c                 |  384 -
 sound/oss/emu10k1/cardwi.h                 |   91 
 sound/oss/emu10k1/cardwo.c                 |  643 --
 sound/oss/emu10k1/cardwo.h                 |   90 
 sound/oss/emu10k1/ecard.c                  |  157 
 sound/oss/emu10k1/ecard.h                  |  113 
 sound/oss/emu10k1/efxmgr.c                 |  220 
 sound/oss/emu10k1/efxmgr.h                 |  270 -
 sound/oss/emu10k1/emuadxmg.c               |  104 
 sound/oss/emu10k1/hwaccess.c               |  507 -
 sound/oss/emu10k1/hwaccess.h               |  247 
 sound/oss/emu10k1/icardmid.h               |  163 
 sound/oss/emu10k1/icardwav.h               |   53 
 sound/oss/emu10k1/irqmgr.c                 |  113 
 sound/oss/emu10k1/irqmgr.h                 |   52 
 sound/oss/emu10k1/main.c                   | 1471 -----
 sound/oss/emu10k1/midi.c                   |  614 --
 sound/oss/emu10k1/midi.h                   |   78 
 sound/oss/emu10k1/mixer.c                  |  690 --
 sound/oss/emu10k1/passthrough.c            |  240 
 sound/oss/emu10k1/passthrough.h            |   99 
 sound/oss/emu10k1/recmgr.c                 |  147 
 sound/oss/emu10k1/recmgr.h                 |   48 
 sound/oss/emu10k1/timer.c                  |  176 
 sound/oss/emu10k1/timer.h                  |   54 
 sound/oss/emu10k1/voicemgr.c               |  398 -
 sound/oss/emu10k1/voicemgr.h               |  103 
 sound/oss/nm256.h                          |  292 -
 sound/oss/nm256_audio.c                    | 1662 ------
 sound/oss/nm256_coeff.h                    | 4697 ------------------
 sound/oss/opl3.c                           |   14 
 sound/oss/opl3.h                           |    5 
 sound/oss/opl3sa2.c                        | 1020 ---
 68 files changed, 4 insertions(+), 31738 deletions(-)

