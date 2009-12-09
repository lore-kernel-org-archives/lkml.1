Return-Path: <linux-kernel-owner+w=401wt.eu-S1751585AbZLIQyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbZLIQyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 11:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbZLIQyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 11:54:15 -0500
Received: from smtp.nokia.com ([192.100.105.134]:61552 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZLIQyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 11:54:14 -0500
Subject: [GIT PULL]: OMAP2/3 Display Subsystem
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tony@atomide.com,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Dec 2009 18:53:30 +0200
Message-ID: <1260377610.9700.49.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Dec 2009 16:53:32.0878 (UTC) FILETIME=[243A86E0:01CA78F0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Here are the new display subsystem and framebuffer drivers for OMAP2/3.

The drivers have been reviewed on linux-omap and linux-fbdev-devel, and
are in use, for example, on N900, Beagle Board and Overo boards.

The drivers are actively maintained and developed further, and I have
already a bunch of patches on top of these patches, but I would like to
get the big core driver merged first. After the core drivers are merged,
other people can send patches to LCD drivers and board files to enable
the new display subsystem on their boards.

Please pull the new OMAP2/3 display subsystem drivers from:

  git://gitorious.org/linux-omap-dss2/linux.git for-linus

 Tomi

 --- 

The following changes since commit 2b876f95d03e226394b5d360c86127cbefaf614b:
  Linus Torvalds (1):
        Merge branches 'timers-for-linus-ntp' and 'irq-core-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://gitorious.org/linux-omap-dss2/linux.git for-linus

Tomi Valkeinen (19):
      OMAP2: Add funcs for writing SMS_ROT_* registers
      OMAP: OMAPFB: split omapfb.h
      OMAP: OMAPFB: add omapdss device
      OMAP: Add VRAM manager
      OMAP: Add support for VRFB rotation engine
      OMAP: DSS2: Documentation for DSS2
      OMAP: DSS2: Display Subsystem Driver core
      OMAP: DSS2: Add more core files
      OMAP: DSS2: DISPC
      OMAP: DSS2: DPI driver
      OMAP: DSS2: Video encoder driver
      OMAP: DSS2: RFBI driver
      OMAP: DSS2: SDI driver
      OMAP: DSS2: DSI driver
      OMAP: DSS2: omapfb driver
      OMAP: DSS2: Add generic and Sharp panel drivers
      OMAP: DSS2: Taal DSI command mode panel driver
      OMAP: SDP: Enable DSS2 for OMAP3 SDP board
      MAINTAINERS: Add OMAP2/3 DSS and OMAPFB maintainer

 Documentation/arm/OMAP/DSS                         |  317 ++
 MAINTAINERS                                        |   17 +
 arch/arm/configs/omap_3430sdp_defconfig            |   28 +-
 arch/arm/mach-omap1/board-nokia770.c               |    2 +-
 arch/arm/mach-omap2/board-3430sdp.c                |  167 +-
 arch/arm/mach-omap2/clock24xx.c                    |    8 +-
 arch/arm/mach-omap2/clock34xx.c                    |   14 +-
 arch/arm/mach-omap2/io.c                           |    4 +-
 arch/arm/mach-omap2/sdrc.c                         |   16 +
 arch/arm/plat-omap/fb.c                            |   49 +-
 arch/arm/plat-omap/include/plat/display.h          |  575 +++
 arch/arm/plat-omap/include/plat/omapfb.h           |  398 ---
 arch/arm/plat-omap/include/plat/sdrc.h             |    9 +-
 arch/arm/plat-omap/include/plat/vram.h             |   62 +
 arch/arm/plat-omap/include/plat/vrfb.h             |   50 +
 arch/arm/plat-omap/sram.c                          |    8 +
 drivers/video/Kconfig                              |    1 +
 drivers/video/Makefile                             |    1 +
 drivers/video/omap/Kconfig                         |    5 +-
 drivers/video/omap/blizzard.c                      |    2 +-
 drivers/video/omap/dispc.c                         |   21 +-
 drivers/video/omap/hwa742.c                        |    3 +-
 drivers/video/omap/lcd_2430sdp.c                   |    3 +-
 drivers/video/omap/lcd_ams_delta.c                 |    3 +-
 drivers/video/omap/lcd_apollon.c                   |    3 +-
 drivers/video/omap/lcd_h3.c                        |    2 +-
 drivers/video/omap/lcd_h4.c                        |    2 +-
 drivers/video/omap/lcd_htcherald.c                 |    2 +-
 drivers/video/omap/lcd_inn1510.c                   |    2 +-
 drivers/video/omap/lcd_inn1610.c                   |    2 +-
 drivers/video/omap/lcd_ldp.c                       |    3 +-
 drivers/video/omap/lcd_mipid.c                     |    3 +-
 drivers/video/omap/lcd_omap2evm.c                  |    3 +-
 drivers/video/omap/lcd_omap3beagle.c               |    4 +-
 drivers/video/omap/lcd_omap3evm.c                  |    3 +-
 drivers/video/omap/lcd_osk.c                       |    2 +-
 drivers/video/omap/lcd_overo.c                     |    3 +-
 drivers/video/omap/lcd_palmte.c                    |    2 +-
 drivers/video/omap/lcd_palmtt.c                    |    2 +-
 drivers/video/omap/lcd_palmz71.c                   |    2 +-
 drivers/video/omap/lcdc.c                          |    3 +-
 drivers/video/omap/omapfb.h                        |  227 ++
 drivers/video/omap/omapfb_main.c                   |    2 +-
 drivers/video/omap/rfbi.c                          |    3 +-
 drivers/video/omap/sossi.c                         |    3 +-
 drivers/video/omap2/Kconfig                        |    9 +
 drivers/video/omap2/Makefile                       |    6 +
 drivers/video/omap2/displays/Kconfig               |   22 +
 drivers/video/omap2/displays/Makefile              |    4 +
 drivers/video/omap2/displays/panel-generic.c       |  104 +
 .../video/omap2/displays/panel-sharp-ls037v7dw01.c |  153 +
 drivers/video/omap2/displays/panel-taal.c          | 1003 ++++++
 drivers/video/omap2/dss/Kconfig                    |   89 +
 drivers/video/omap2/dss/Makefile                   |    6 +
 drivers/video/omap2/dss/core.c                     |  919 +++++
 drivers/video/omap2/dss/dispc.c                    | 3091 ++++++++++++++++
 drivers/video/omap2/dss/display.c                  |  671 ++++
 drivers/video/omap2/dss/dpi.c                      |  399 +++
 drivers/video/omap2/dss/dsi.c                      | 3710 ++++++++++++++++++++
 drivers/video/omap2/dss/dss.c                      |  596 ++++
 drivers/video/omap2/dss/dss.h                      |  370 ++
 drivers/video/omap2/dss/manager.c                  | 1487 ++++++++
 drivers/video/omap2/dss/overlay.c                  |  680 ++++
 drivers/video/omap2/dss/rfbi.c                     | 1309 +++++++
 drivers/video/omap2/dss/sdi.c                      |  277 ++
 drivers/video/omap2/dss/venc.c                     |  797 +++++
 drivers/video/omap2/omapfb/Kconfig                 |   37 +
 drivers/video/omap2/omapfb/Makefile                |    2 +
 drivers/video/omap2/omapfb/omapfb-ioctl.c          |  755 ++++
 drivers/video/omap2/omapfb/omapfb-main.c           | 2261 ++++++++++++
 drivers/video/omap2/omapfb/omapfb-sysfs.c          |  507 +++
 drivers/video/omap2/omapfb/omapfb.h                |  146 +
 drivers/video/omap2/vram.c                         |  655 ++++
 drivers/video/omap2/vrfb.c                         |  315 ++
 include/linux/omapfb.h                             |  251 ++
 75 files changed, 22208 insertions(+), 464 deletions(-)
 create mode 100644 Documentation/arm/OMAP/DSS
 create mode 100644 arch/arm/plat-omap/include/plat/display.h
 delete mode 100644 arch/arm/plat-omap/include/plat/omapfb.h
 create mode 100644 arch/arm/plat-omap/include/plat/vram.h
 create mode 100644 arch/arm/plat-omap/include/plat/vrfb.h
 create mode 100644 drivers/video/omap/omapfb.h
 create mode 100644 drivers/video/omap2/Kconfig
 create mode 100644 drivers/video/omap2/Makefile
 create mode 100644 drivers/video/omap2/displays/Kconfig
 create mode 100644 drivers/video/omap2/displays/Makefile
 create mode 100644 drivers/video/omap2/displays/panel-generic.c
 create mode 100644 drivers/video/omap2/displays/panel-sharp-ls037v7dw01.c
 create mode 100644 drivers/video/omap2/displays/panel-taal.c
 create mode 100644 drivers/video/omap2/dss/Kconfig
 create mode 100644 drivers/video/omap2/dss/Makefile
 create mode 100644 drivers/video/omap2/dss/core.c
 create mode 100644 drivers/video/omap2/dss/dispc.c
 create mode 100644 drivers/video/omap2/dss/display.c
 create mode 100644 drivers/video/omap2/dss/dpi.c
 create mode 100644 drivers/video/omap2/dss/dsi.c
 create mode 100644 drivers/video/omap2/dss/dss.c
 create mode 100644 drivers/video/omap2/dss/dss.h
 create mode 100644 drivers/video/omap2/dss/manager.c
 create mode 100644 drivers/video/omap2/dss/overlay.c
 create mode 100644 drivers/video/omap2/dss/rfbi.c
 create mode 100644 drivers/video/omap2/dss/sdi.c
 create mode 100644 drivers/video/omap2/dss/venc.c
 create mode 100644 drivers/video/omap2/omapfb/Kconfig
 create mode 100644 drivers/video/omap2/omapfb/Makefile
 create mode 100644 drivers/video/omap2/omapfb/omapfb-ioctl.c
 create mode 100644 drivers/video/omap2/omapfb/omapfb-main.c
 create mode 100644 drivers/video/omap2/omapfb/omapfb-sysfs.c
 create mode 100644 drivers/video/omap2/omapfb/omapfb.h
 create mode 100644 drivers/video/omap2/vram.c
 create mode 100644 drivers/video/omap2/vrfb.c
 create mode 100644 include/linux/omapfb.h



