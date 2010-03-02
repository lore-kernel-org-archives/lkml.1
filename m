Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab0CBQDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 11:03:18 -0500
Received: from smtp.nokia.com ([192.100.122.233]:46459 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab0CBQDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 11:03:16 -0500
Subject: [GIT PULL] OMAP DSS updates for 2.6.34
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: ext Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Tue, 02 Mar 2010 18:01:59 +0200
Message-ID: <1267545719.2406.65.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Mar 2010 16:02:04.0084 (UTC) FILETIME=[B3733740:01CABA21]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the OMAP Display Subsystem patches below.

- Couple of new panel drivers
- Various small fixes and improvements
- Multiple patches making the DSS device model more sane, moving the
control from the DSS core driver to the panel drivers. This makes it
possible for the panel drivers to fully control what is going on,
instead of having to work with the limits imposed by the DSS core.

 Tomi


The following changes since commit 13dda80e48439b446d0bc9bab34b91484bc8f533:
  Linus Torvalds (1):
        Merge branch 'davinci-for-linus' of git://git.kernel.org/.../khilman/linux-davinci

are available in the git repository at:

  git://gitorious.org/linux-omap-dss2/linux.git for-linus

Aaro Koskinen (1):
      OMAP: DSS: Taal: fix error returns in taal_probe()

Grazvydas Ignotas (1):
      OMAP: DSS: add TPO TD043MTEA1 panel

Janusz Krzysztofik (2):
      omapfb: Fix 12-bit display (RGB444 color mode) handling
      omapfb: lcd_ams_delta: add support for contrast control

Mike Rapoport (1):
      OMAP: DSS2: add Toppoly TDO35S panel

Tomi Valkeinen (41):
      OMAP: DSS2: Improve Kconfig help texts
      OMAP: DSS2: enable VDDS_DSI when using DPI
      OMAP: 3430SDP: remove vdvi regulator
      OMAP: DSS2: OMAPFB: implement OMAPFB_GET_DISPLAY_INFO
      OMAP: DSS2: fix irq-stats compilation
      OMAP: DSS2: OMAPFB: Add omapfb_update_window prototype
      OMAP: DSS2: improve DSS clk src selection
      OMAP: DSS2: DSI: add dsi_bus_is_locked()
      OMAP: DSS2: DSI: add helpers for DCS read/write
      OMAP: DSS2: DSI: export dsi_vc_enable_hs()
      OMAP: DSS2: DSI: configure all DSI VCs
      OMAP: DSS2: DSI: remove dsi_vc_print_status()
      OMAP: DSS2: Check ctx loss count only when starting the first clock
      OMAP: DSS2: remove sub-panel system
      OMAP: DSS2: fix driver probe error handling
      OMAP: DSS2: OMAPFB: fix dssdev cleanup on error
      OMAP: DSS2: OMAPFB: fix cleanup on dssdev enable error
      OMAP: DSS2: fix get_dsi/dispc_clk_source() usage
      OMAP: DSS2: DSI: change DSI bus_lock to semaphore
      OMAP: DSS2: DSI: remove auto-update perf measurement
      OMAP: DSS2: move run_test()
      OMAP: DSS2: move memory_read()
      OMAP: DSS2: move set/get_mirror()
      OMAP: DSS2: move get/set_rotate()
      OMAP: DSS2: move wait_vsync()
      OMAP: DSS2: move enable/disable_channel to overlay manager
      OMAP: DSS2: move get_resolution()
      OMAP: DSS2: move get_recommended_bpp()
      OMAP: DSS2: move enable/get_te()
      OMAP: DSS2: move set/get_update_mode()
      OMAP: DSS2: move update() and sync()
      OMAP: DSS2: move enable/disable/suspend/resume
      OMAP: DSS2: move set/get_wss()
      OMAP: DSS2: move timing functions
      OMAP: DSS2: DSI: remove external TE support
      OMAP: DSS2: OMAPFB: Remove FB_OMAP2_FORCE_AUTO_UPDATE
      OMAP: DSS2: DSI: add dsi_vc_dcs_read_2() helper
      OMAP: DSS2: TPO-TD03MTEA1: fix function names
      OMAP: DSS2: DSI: add error prints
      OMAP: DSS2: Taal: Fix ESD check
      OMAP: DSS2: Taal: Fix TE when resuming

Vaibhav Hiremath (1):
      OMAP: DSS2: Add Sharp LQ043T1DG01 panel driver

Ville Syrjälä (2):
      OMAP: DSS2: OMAPFB: install omapfb.h
      OMAP: DSS2: OMAPFB: Constify some function parameters

 arch/arm/mach-omap2/board-3430sdp.c                |    4 -
 arch/arm/plat-omap/include/plat/display.h          |  117 ++-
 drivers/video/omap/lcd_ams_delta.c                 |   93 ++-
 drivers/video/omap/omapfb_main.c                   |    7 +-
 drivers/video/omap2/displays/Kconfig               |   18 +
 drivers/video/omap2/displays/Makefile              |    3 +
 drivers/video/omap2/displays/panel-generic.c       |   56 +-
 .../video/omap2/displays/panel-sharp-lq043t1dg01.c |  159 +++
 .../video/omap2/displays/panel-sharp-ls037v7dw01.c |   77 +-
 drivers/video/omap2/displays/panel-taal.c          |  253 ++++-
 .../video/omap2/displays/panel-toppoly-tdo35s.c    |  154 +++
 .../video/omap2/displays/panel-tpo-td043mtea1.c    |  528 ++++++++++
 drivers/video/omap2/dss/Kconfig                    |   26 +-
 drivers/video/omap2/dss/core.c                     |  117 ++-
 drivers/video/omap2/dss/dispc.c                    |   42 +-
 drivers/video/omap2/dss/display.c                  |  119 +--
 drivers/video/omap2/dss/dpi.c                      |  144 +---
 drivers/video/omap2/dss/dsi.c                      | 1031 +++++---------------
 drivers/video/omap2/dss/dss.c                      |   42 +-
 drivers/video/omap2/dss/dss.h                      |   23 +-
 drivers/video/omap2/dss/manager.c                  |   48 +-
 drivers/video/omap2/dss/overlay.c                  |    2 +-
 drivers/video/omap2/dss/rfbi.c                     |  321 +------
 drivers/video/omap2/dss/sdi.c                      |  115 +--
 drivers/video/omap2/dss/venc.c                     |  296 +++----
 drivers/video/omap2/omapfb/Kconfig                 |   11 +-
 drivers/video/omap2/omapfb/omapfb-ioctl.c          |   68 +-
 drivers/video/omap2/omapfb/omapfb-main.c           |  133 ++--
 drivers/video/omap2/omapfb/omapfb.h                |    9 +
 include/linux/Kbuild                               |    1 +
 include/linux/omapfb.h                             |    9 +
 31 files changed, 2186 insertions(+), 1840 deletions(-)
 create mode 100644 drivers/video/omap2/displays/panel-sharp-lq043t1dg01.c
 create mode 100644 drivers/video/omap2/displays/panel-toppoly-tdo35s.c
 create mode 100644 drivers/video/omap2/displays/panel-tpo-td043mtea1.c


