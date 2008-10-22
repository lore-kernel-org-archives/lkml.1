Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbYJVR0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbYJVR0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbYJVRZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:25:41 -0400
Received: from kroah.org ([198.145.64.141]:56927 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754259AbYJVRZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:25:40 -0400
Date: Wed, 22 Oct 2008 10:22:03 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] more STAGING patches for 2.6.28
Message-ID: <20081022172203.GA4000@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some more staging patches against your 2.6 git tree.

These should fix up all of the known build warnings, so that I don't get
a bunch of patches that do the same thing from different people, as well
as a lot of other cleanups and 2 more new drivers.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

These have all been in the past few -next releases with no known build
errors.

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h


 drivers/staging/Kconfig                   |    4 +
 drivers/staging/Makefile                  |    2 +
 drivers/staging/at76_usb/at76_usb.c       |    4 +-
 drivers/staging/echo/bit_operations.h     |  205 ++---
 drivers/staging/echo/echo.c               |  847 +++++++++---------
 drivers/staging/echo/echo.h               |   58 +--
 drivers/staging/echo/fir.h                |  376 +++-----
 drivers/staging/echo/mmx.h                |   29 +-
 drivers/staging/echo/oslec.h              |   86 ++
 drivers/staging/et131x/et1310_phy.c       |    2 -
 drivers/staging/et131x/et131x_debug.c     |    1 -
 drivers/staging/et131x/et131x_initpci.c   |    1 -
 drivers/staging/go7007/go7007-driver.c    |    1 -
 drivers/staging/go7007/go7007-fw.c        |    1 -
 drivers/staging/go7007/go7007-i2c.c       |    1 -
 drivers/staging/go7007/go7007-usb.c       |    1 -
 drivers/staging/go7007/snd-go7007.c       |    1 -
 drivers/staging/go7007/wis-ov7640.c       |    1 -
 drivers/staging/go7007/wis-saa7113.c      |    1 -
 drivers/staging/go7007/wis-saa7115.c      |    1 -
 drivers/staging/go7007/wis-sony-tuner.c   |    1 -
 drivers/staging/go7007/wis-tw2804.c       |    1 -
 drivers/staging/go7007/wis-tw9903.c       |    1 -
 drivers/staging/go7007/wis-uda1342.c      |    1 -
 drivers/staging/me4000/me4000.c           |  908 +++++++++----------
 drivers/staging/me4000/me4000.h           |  194 +++--
 drivers/staging/pcc-acpi/Kconfig          |   11 +
 drivers/staging/pcc-acpi/Makefile         |    1 +
 drivers/staging/pcc-acpi/TODO             |    7 +
 drivers/staging/pcc-acpi/pcc-acpi.c       | 1111 ++++++++++++++++++++++
 drivers/staging/poch/Kconfig              |    6 +
 drivers/staging/poch/Makefile             |    1 +
 drivers/staging/poch/README               |    7 +
 drivers/staging/poch/poch.c               | 1425 +++++++++++++++++++++++++++++
 drivers/staging/poch/poch.h               |   29 +
 drivers/staging/slicoss/slicoss.c         |   18 +-
 drivers/staging/sxg/README                |    1 +
 drivers/staging/sxg/sxg.c                 | 1379 ++++++++++++++--------------
 drivers/staging/sxg/sxg_os.h              |   41 +-
 drivers/staging/sxg/sxgdbg.h              |    2 +-
 drivers/staging/sxg/sxghif.h              |  410 ++++-----
 drivers/staging/sxg/sxghw.h               |  404 ++++----
 drivers/staging/sxg/sxgphycode.h          |   12 +-
 drivers/staging/usbip/usbip_common.c      |    2 +-
 drivers/staging/usbip/vhci_rx.c           |    2 +-
 drivers/staging/winbond/Kconfig           |    2 +-
 drivers/staging/winbond/README            |    1 +
 drivers/staging/winbond/bss_f.h           |    6 +-
 drivers/staging/winbond/ds_tkip.h         |    6 +-
 drivers/staging/winbond/linux/common.h    |   17 +-
 drivers/staging/winbond/linux/wb35reg.c   |   63 +-
 drivers/staging/winbond/linux/wb35reg_f.h |   12 +-
 drivers/staging/winbond/linux/wb35reg_s.h |    4 +-
 drivers/staging/winbond/linux/wb35rx.c    |  175 ++--
 drivers/staging/winbond/linux/wb35rx_s.h  |    2 +-
 drivers/staging/winbond/linux/wb35tx.c    |  138 ++--
 drivers/staging/winbond/linux/wb35tx_f.h  |    2 +-
 drivers/staging/winbond/linux/wbusb.c     |  259 +++---
 drivers/staging/winbond/mds.c             |   30 +-
 drivers/staging/winbond/mds_f.h           |    6 +-
 drivers/staging/winbond/mds_s.h           |    8 +-
 drivers/staging/winbond/mlme_s.h          |    4 +-
 drivers/staging/winbond/mlmetxrx.c        |    4 +-
 drivers/staging/winbond/mlmetxrx_f.h      |    4 +-
 drivers/staging/winbond/reg.c             |   24 +-
 drivers/staging/winbond/sme_api.c         |    1 +
 drivers/staging/winbond/sme_api.h         |    2 +-
 drivers/staging/winbond/wbhal.c           |   32 +-
 drivers/staging/winbond/wbhal_f.h         |   28 +-
 drivers/staging/winbond/wbhal_s.h         |    4 +-
 drivers/staging/winbond/wblinux.c         |  208 +++---
 drivers/staging/winbond/wblinux_s.h       |    4 +-
 drivers/staging/wlan-ng/Kconfig           |    2 +-
 drivers/staging/wlan-ng/hfa384x.h         |    2 +-
 drivers/staging/wlan-ng/p80211wep.c       |    1 -
 drivers/staging/wlan-ng/prism2mib.c       |    2 -
 drivers/staging/wlan-ng/wlan_compat.h     |    8 +-
 77 files changed, 5566 insertions(+), 3093 deletions(-)
 create mode 100644 drivers/staging/echo/oslec.h
 create mode 100644 drivers/staging/pcc-acpi/Kconfig
 create mode 100644 drivers/staging/pcc-acpi/Makefile
 create mode 100644 drivers/staging/pcc-acpi/TODO
 create mode 100644 drivers/staging/pcc-acpi/pcc-acpi.c
 create mode 100644 drivers/staging/poch/Kconfig
 create mode 100644 drivers/staging/poch/Makefile
 create mode 100644 drivers/staging/poch/README
 create mode 100644 drivers/staging/poch/poch.c
 create mode 100644 drivers/staging/poch/poch.h

---------------

Diego Calleja (1):
      Staging: Fix leak in drivers/staging/at76_usb.c

Geert Uytterhoeven (1):
      Staging: W35UND should depend on USB

Greg Kroah-Hartman (8):
      Staging: document 4k stack problem for winbond driver
      Staging: wlan-ng: fix build error if wireless networking is not enabled
      Staging: pcc-acpi: update to latest version
      Staging: sxg: fix up unused function warnings
      Staging: sxg: fix compiler warnings.
      Staging: wbusb: fix a bunch of compiler warnings
      Staging: me4000: remove some compiler warnings
      Staging: usbip: fix build warning on 64bit kernels

Harvey Harrison (2):
      Staging: sxg: replace __FUNCTION__ with __func__
      Staging: remove remaining uses of __FUNCTION__

Hiroshi Miura (1):
      Staging: add pcc-acpi driver

Huang Weiyi (6):
      Staging: SLICOSS: remove duplicated #include's
      Staging: et131x: remove duplicated #include's
      Staging: wlan-ng: prism2: remove duplicated #include
      staging: wlan-ng: prism2: remove more duplicated #include
      Staging: go7007: remove unused #include <version.h>
      Staging: SLICOSS: remove unused #include <version.h>

J.R. Mauro (3):
      Staging: Clean up sxg driver
      Staging: Lindent the echo driver
      Staging: sxg: clean up C99 comments

Lior Dotan (3):
      Staging: Fixes for me4000 pci data collection driver
      Staging: PCC-ACPI: Fix all checkpatch errors
      Staging: SLICOSS: Free multicast list at driver exit

Mariusz Kozlowski (2):
      staging: fix potential build error in slicoss driver
      staging: balance parenthesis in wlan-ng headers

Pekka Enberg (8):
      Staging: w35und: remove some typedefs
      Staging: echo: fix kmalloc()/kfree() uses
      Staging: echo: remove dead code
      Staging: echo: remove __cplusplus macro magic
      Staging: echo: remove annoying "end of function" markers
      Staging: w35und: remove spinlock wrappers
      Staging: w35und: use gotos for error handling
      Staging: w35und: module init cleanup

Stephen Rothwell (1):
      linux-next: build failure

Tzafrir Cohen (5):
      Staging: echo: A separate oslec.h for external interface
      Staging: echo: Export interface functions. Add module headers.
      Staging: echo: Replace echo_can_state_t with struct echo_can_state
      Staging: echo: Changed preffix from echo_can_ to oslec_
      Staging: echo: Replace __BLACKFIN__ASM__ with __bfin__

Vijay Kumar (1):
      Staging: add poch driver

