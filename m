Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbZIVMa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbZIVMa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 08:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbZIVMa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 08:30:28 -0400
Received: from smtp.nokia.com ([192.100.105.134]:64977 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZIVMa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 08:30:27 -0400
Subject: [GIT PULL]: OMAP2/3 Display Subsystem
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Reply-To: tomi.valkeinen@nokia.com
To: torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, tony@atomide.com, linux-omap@vger.kernel.org,
       linux-fbdev-devel <linux-fbdev-devel@lists.sourceforge.net>
Content-Type: text/plain
Organization: Nokia Oyj
Date: Tue, 22 Sep 2009 15:29:48 +0300
Message-Id: <1253622588.25232.11.camel@tubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Sep 2009 12:29:54.0867 (UTC) FILETIME=[63BD1830:01CA3B80]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Here's the new display subsystem and framebuffer driver for OMAP2/3.

The driver has been reviewed on linux-omap and linux-fbdev-devel, and is in
use, for example, on N900, Beagle Board and Overo boards. We have an ACK for
the OMAP parts from Tony Lindgren, who maintains the OMAP platform.

We have gotten positive feedback about the driver, for example in this thread:
http://marc.info/?l=linux-kernel&m=125171081901820&w=2

The driver is actively maintained and developed further, and I have already a
bunch of patches on top of these patches, but I would like to get the big core
driver merged first. After the driver is merged, other people can send patches
to LCD drivers and board files to enable the new display subsystem on their
boards.

Andrew said 2-3 weeks ago that he'll merge the driver (after he has looked
through it), but he hasn't responded since then. I'm guessing he's quite busy.

Please pull the new OMAP2/3 display subsystem driver from:

  git://gitorious.org/linux-omap-dss2/linux.git for-linus

 Tomi

 ---

The following changes since commit 43c1266ce4dc06bfd236cec31e11e9ecd69c0bef:
  Linus Torvalds (1):
        Merge branch 'perfcounters-rename-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

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
      OMAP: DSS2: Add DPI panel drivers
      OMAP: DSS2: Taal DSI command mode panel driver
      OMAP: SDP: Enable DSS2 for OMAP3 SDP board
      MAINTAINERS: Add OMAP2/3 DSS and OMAPFB maintainer

 Documentation/arm/OMAP/DSS                         |  317 ++
 MAINTAINERS                                        |   17 +
 arch/arm/configs/omap_3430sdp_defconfig            |   61 +-
 arch/arm/mach-omap1/board-nokia770.c               |    2 +-
 arch/arm/mach-omap2/board-3430sdp.c                |  167 +-
 arch/arm/mach-omap2/clock24xx.c                    |    8 +-
 arch/arm/mach-omap2/clock34xx.c                    |   14 +-
 arch/arm/mach-omap2/io.c                           |    4 +-
 arch/arm/mach-omap2/sdrc.c                         |   16 +
 arch/arm/plat-omap/fb.c                            |   41 +-
 arch/arm/plat-omap/include/mach/display.h          |  540 +++
 arch/arm/plat-omap/include/mach/omapfb.h           |  398 ---
 arch/arm/plat-omap/include/mach/sdrc.h             |    9 +-
 arch/arm/plat-omap/include/mach/vram.h             |   63 +
 arch/arm/plat-omap/include/mach/vrfb.h             |   46 +
 arch/arm/plat-omap/sram.c                          |    8 +
 drivers/video/Kconfig                              |    1 +
 drivers/video/Makefile                             |    1 +
 drivers/video/omap/Kconfig                         |    5 +-
 drivers/video/omap/blizzard.c                      |    2 +-
 drivers/video/omap/dispc.c                         |   21 +-
 drivers/video/omap/hwa742.c                        |    2 +-
 drivers/video/omap/lcd_h3.c                        |    2 +-
 drivers/video/omap/lcd_h4.c                        |    2 +-
 drivers/video/omap/lcd_inn1510.c                   |    2 +-
 drivers/video/omap/lcd_inn1610.c                   |    2 +-
 drivers/video/omap/lcd_osk.c                       |    2 +-
 drivers/video/omap/lcd_palmte.c                    |    2 +-
 drivers/video/omap/lcd_palmtt.c                    |    2 +-
 drivers/video/omap/lcd_palmz71.c                   |    2 +-
 drivers/video/omap/lcdc.c                          |    3 +-
 drivers/video/omap/omapfb.h                        |  227 ++
 drivers/video/omap/omapfb_main.c                   |    2 +-
 drivers/video/omap/rfbi.c                          |    3 +-
 drivers/video/omap/sossi.c                         |    2 +-
 drivers/video/omap2/Kconfig                        |    9 +
 drivers/video/omap2/Makefile                       |    6 +
 drivers/video/omap2/displays/Kconfig               |   28 +
 drivers/video/omap2/displays/Makefile              |    5 +
 drivers/video/omap2/displays/panel-generic.c       |  104 +
 .../omap2/displays/panel-samsung-lte430wq-f0c.c    |  113 +
 .../video/omap2/displays/panel-sharp-ls037v7dw01.c |  153 +
 drivers/video/omap2/displays/panel-taal.c          |  900 +++++
 drivers/video/omap2/dss/Kconfig                    |   89 +
 drivers/video/omap2/dss/Makefile                   |    6 +
 drivers/video/omap2/dss/core.c                     |  917 +++++
 drivers/video/omap2/dss/dispc.c                    | 3182 ++++++++++++++++++
 drivers/video/omap2/dss/display.c                  |  658 ++++
 drivers/video/omap2/dss/dpi.c                      |  388 +++
 drivers/video/omap2/dss/dsi.c                      | 3509 ++++++++++++++++++++
 drivers/video/omap2/dss/dss.c                      |  347 ++
 drivers/video/omap2/dss/dss.h                      |  356 ++
 drivers/video/omap2/dss/manager.c                  | 1487 +++++++++
 drivers/video/omap2/dss/overlay.c                  |  673 ++++
 drivers/video/omap2/dss/rfbi.c                     | 1310 ++++++++
 drivers/video/omap2/dss/sdi.c                      |  261 ++
 drivers/video/omap2/dss/venc.c                     |  797 +++++
 drivers/video/omap2/omapfb/Kconfig                 |   37 +
 drivers/video/omap2/omapfb/Makefile                |    2 +
 drivers/video/omap2/omapfb/omapfb-ioctl.c          |  727 ++++
 drivers/video/omap2/omapfb/omapfb-main.c           | 2137 ++++++++++++
 drivers/video/omap2/omapfb/omapfb-sysfs.c          |  507 +++
 drivers/video/omap2/omapfb/omapfb.h                |  146 +
 drivers/video/omap2/vram.c                         |  655 ++++
 drivers/video/omap2/vrfb.c                         |  277 ++
 include/linux/omapfb.h                             |  242 ++
 66 files changed, 21572 insertions(+), 452 deletions(-)
 create mode 100644 Documentation/arm/OMAP/DSS
 create mode 100644 arch/arm/plat-omap/include/mach/display.h
 delete mode 100644 arch/arm/plat-omap/include/mach/omapfb.h
 create mode 100644 arch/arm/plat-omap/include/mach/vram.h
 create mode 100644 arch/arm/plat-omap/include/mach/vrfb.h
 create mode 100644 drivers/video/omap/omapfb.h
 create mode 100644 drivers/video/omap2/Kconfig
 create mode 100644 drivers/video/omap2/Makefile
 create mode 100644 drivers/video/omap2/displays/Kconfig
 create mode 100644 drivers/video/omap2/displays/Makefile
 create mode 100644 drivers/video/omap2/displays/panel-generic.c
 create mode 100644 drivers/video/omap2/displays/panel-samsung-lte430wq-f0c.c
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



