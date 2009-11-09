Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbZKILp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbZKILp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 06:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbZKILp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 06:45:56 -0500
Received: from smtp.nokia.com ([192.100.122.233]:64517 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbZKILpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 06:45:55 -0500
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH 00/19] OMAP: DSS2 v5 intro
Date: Mon,  9 Nov 2009 13:45:07 +0200
Message-Id: <1257767126-12059-1-git-send-email-tomi.valkeinen@nokia.com>
X-Mailer: git-send-email 1.6.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Nov 2009 11:45:40.0470 (UTC) FILETIME=[296C4160:01CA6132]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set implement new display subsystem driver (DSS2) and omapfb driver
for OMAP2/3. The patches have been reviewed on linux-omap and linux-fbdev-devel
mailing lists. The patches can also be found from master branch in
http://gitorious.org/linux-omap-dss2/linux. The branch is based on the
linux-next tree.

The patches include DSS documentation patch that includes more instructions for
module parameters, sysfs files etc.

The patches enable DSS2 for OMAP3430 SDP board and support for other boards can
be sent after the DSS2 has been merged. DSS2 is used in various boards, for
example Nokia N900, Beagle Board and Overo.

I don't currently have any OMAP2 board to test DSS2, but it has worked on OMAP2
and the possible fixes needed should be minimal.

OMAP1 is not supported, and so the old DSS needs to be used on OMAP1 boards. My
longer term plan is to move all OMAP2 stuff from the old DSS to the new one,
and then shrink the old DSS to support OMAP1 only.

DSS2 is partly based on the old omapfb driver by Imre Deak, and Imre has also
contributed to DSS2 quite a bit. Ville Syrjälä has been contributing to scaling
and tv-out work, and Topi Pohjolainen to VRFB. Also some contributions have
been made by Hardik Shah, Vaibhav Hiremath, and perhaps some others that I have
forgotten =).

---
Changes in v5
- Improvements in the DSI code
- Improvements and fixes in the VRFB code
- Many other minor fixes

Changes in v4:
- Rebased on latest linux tree
- Add maintainers

Changes in v3:
- Rebased on mainstream linux
- Remove Beagle and Overo board changes

Changes in v2:

- Split the commits more to make them smaller
- Print error if fclk is too low for scaling
- Indent SDP, Beagle, Overo board files
- DSI: return -EIO instead of -1
- VRFB: Move to drivers/video/omap2/
- VRAM: Move to drivers/video/omap2/
- VRFB: use omap2_sms_write_*() functions instead of omap_writel
- SDI: Remove custom pinmuxing. Will be added later properly.
- VENC: indentation changes
- Add Taal DSI panel driver

---

[PATCH 01/19] OMAP2: Add funcs for writing SMS_ROT_* registers
[PATCH 02/19] OMAP: OMAPFB: split omapfb.h
[PATCH 03/19] OMAP: OMAPFB: add omapdss device
[PATCH 04/19] OMAP: Add VRAM manager
[PATCH 05/19] OMAP: Add support for VRFB rotation engine
[PATCH 06/19] OMAP: DSS2: Documentation for DSS2
[PATCH 07/19] OMAP: DSS2: Display Subsystem Driver core
[PATCH 08/19] OMAP: DSS2: Add more core files
[PATCH 09/19] OMAP: DSS2: DISPC
[PATCH 10/19] OMAP: DSS2: DPI driver
[PATCH 11/19] OMAP: DSS2: Video encoder driver
[PATCH 12/19] OMAP: DSS2: RFBI driver
[PATCH 13/19] OMAP: DSS2: SDI driver
[PATCH 14/19] OMAP: DSS2: DSI driver
[PATCH 15/19] OMAP: DSS2: omapfb driver
[PATCH 16/19] OMAP: DSS2: Add DPI panel drivers
[PATCH 17/19] OMAP: DSS2: Taal DSI command mode panel driver
[PATCH 18/19] OMAP: SDP: Enable DSS2 for OMAP3 SDP board
[PATCH 19/19] MAINTAINERS: Add OMAP2/3 DSS and OMAPFB maintainer

---

 Documentation/arm/OMAP/DSS                         |  317 ++
 MAINTAINERS                                        |   17 +
 arch/arm/configs/omap_3430sdp_defconfig            |   32 +-
 arch/arm/mach-omap1/board-nokia770.c               |    1 +
 arch/arm/mach-omap2/board-3430sdp.c                |  167 +-
 arch/arm/mach-omap2/clock24xx.c                    |    8 +-
 arch/arm/mach-omap2/clock34xx.c                    |   14 +-
 arch/arm/mach-omap2/io.c                           |    4 +-
 arch/arm/mach-omap2/sdrc.c                         |   16 +
 arch/arm/plat-omap/fb.c                            |   41 +-
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
 drivers/video/omap/hwa742.c                        |    2 +-
 drivers/video/omap/lcd_2430sdp.c                   |    3 +-
 drivers/video/omap/lcd_ams_delta.c                 |    3 +-
 drivers/video/omap/lcd_apollon.c                   |    3 +-
 drivers/video/omap/lcd_h3.c                        |    2 +-
 drivers/video/omap/lcd_h4.c                        |    2 +-
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
 drivers/video/omap/sossi.c                         |    2 +-
 drivers/video/omap2/Kconfig                        |    9 +
 drivers/video/omap2/Makefile                       |    6 +
 drivers/video/omap2/displays/Kconfig               |   28 +
 drivers/video/omap2/displays/Makefile              |    5 +
 drivers/video/omap2/displays/panel-generic.c       |  104 +
 .../omap2/displays/panel-samsung-lte430wq-f0c.c    |  113 +
 .../video/omap2/displays/panel-sharp-ls037v7dw01.c |  153 +
 drivers/video/omap2/displays/panel-taal.c          | 1003 ++++++
 drivers/video/omap2/dss/Kconfig                    |   89 +
 drivers/video/omap2/dss/Makefile                   |    6 +
 drivers/video/omap2/dss/core.c                     |  919 +++++
 drivers/video/omap2/dss/dispc.c                    | 3087 ++++++++++++++++
 drivers/video/omap2/dss/display.c                  |  671 ++++
 drivers/video/omap2/dss/dpi.c                      |  399 +++
 drivers/video/omap2/dss/dsi.c                      | 3708 ++++++++++++++++++++
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
 75 files changed, 22314 insertions(+), 463 deletions(-)

