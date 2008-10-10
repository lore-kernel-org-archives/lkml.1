Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbYJJWoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbYJJWoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 18:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYJJWor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 18:44:47 -0400
Received: from kroah.org ([198.145.64.141]:48916 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750825AbYJJWoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 18:44:46 -0400
Date: Fri, 10 Oct 2008 15:41:30 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] STAGING patches for 2.6.28
Message-ID: <20081010224130.GA30117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a tree of patches against your 2.6 git tree that adds the
drivers/staging/ directory and related infrastructure.

The infrastructure is:
  - add TAINT_CRAP to the kernel and the module build tools
  - add MAINTAINERS file entry for this pile of crap

The drivers we have for the staging/ directory in this patch series are:
  - USB/IP drivers
  - echo cancellation driver (used by mISDN and Zaptel)
  - eth131x network driver
  - slicoss network driver
  - sxg network driver
  - me4000 data collection driver
  - go7007 video capture driver
  - wlan-ng prism2 usb driver
  - w35und wifi driver

There are also follow-on patches by individuals cleaning up some of the
problems in these drivers that have kept them out of the main kernel
tree so far.

All of these drivers are self-contained in their respective
subdirectories, touching no other kernel code at all.  There are TODO
files in the directories detailing what is needed to be done to clean up
these drivers to get them merged into the main tree.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h


 Documentation/sysctl/kernel.txt             |    1 +
 MAINTAINERS                                 |    7 +
 drivers/Kconfig                             |    2 +
 drivers/Makefile                            |    1 +
 drivers/staging/Kconfig                     |   44 +
 drivers/staging/Makefile                    |   11 +
 drivers/staging/echo/Kconfig                |    9 +
 drivers/staging/echo/Makefile               |    1 +
 drivers/staging/echo/TODO                   |   10 +
 drivers/staging/echo/bit_operations.h       |  253 +
 drivers/staging/echo/echo.c                 |  632 ++
 drivers/staging/echo/echo.h                 |  220 +
 drivers/staging/echo/fir.h                  |  369 +
 drivers/staging/echo/mmx.h                  |  288 +
 drivers/staging/et131x/Kconfig              |   18 +
 drivers/staging/et131x/Makefile             |   18 +
 drivers/staging/et131x/README               |   25 +
 drivers/staging/et131x/et1310_address_map.h | 2399 +++++++
 drivers/staging/et131x/et1310_eeprom.c      |  480 ++
 drivers/staging/et131x/et1310_eeprom.h      |   89 +
 drivers/staging/et131x/et1310_jagcore.c     |  220 +
 drivers/staging/et131x/et1310_jagcore.h     |  112 +
 drivers/staging/et131x/et1310_mac.c         |  792 +++
 drivers/staging/et131x/et1310_mac.h         |   93 +
 drivers/staging/et131x/et1310_phy.c         | 1281 ++++
 drivers/staging/et131x/et1310_phy.h         |  910 +++
 drivers/staging/et131x/et1310_pm.c          |  207 +
 drivers/staging/et131x/et1310_pm.h          |  125 +
 drivers/staging/et131x/et1310_rx.c          | 1391 ++++
 drivers/staging/et131x/et1310_rx.h          |  373 +
 drivers/staging/et131x/et1310_tx.c          | 1525 ++++
 drivers/staging/et131x/et1310_tx.h          |  242 +
 drivers/staging/et131x/et131x_adapter.h     |  347 +
 drivers/staging/et131x/et131x_config.c      |  325 +
 drivers/staging/et131x/et131x_config.h      |   67 +
 drivers/staging/et131x/et131x_debug.c       |  218 +
 drivers/staging/et131x/et131x_debug.h       |  201 +
 drivers/staging/et131x/et131x_defs.h        |  128 +
 drivers/staging/et131x/et131x_initpci.c     | 1046 +++
 drivers/staging/et131x/et131x_initpci.h     |   73 +
 drivers/staging/et131x/et131x_isr.c         |  488 ++
 drivers/staging/et131x/et131x_isr.h         |   65 +
 drivers/staging/et131x/et131x_netdev.c      |  856 +++
 drivers/staging/et131x/et131x_netdev.h      |   64 +
 drivers/staging/et131x/et131x_version.h     |   81 +
 drivers/staging/go7007/Kconfig              |   25 +
 drivers/staging/go7007/Makefile             |   18 +
 drivers/staging/go7007/README               |   11 +
 drivers/staging/go7007/go7007-driver.c      |  688 ++
 drivers/staging/go7007/go7007-fw.c          | 1639 +++++
 drivers/staging/go7007/go7007-i2c.c         |  309 +
 drivers/staging/go7007/go7007-priv.h        |  279 +
 drivers/staging/go7007/go7007-usb.c         | 1229 ++++
 drivers/staging/go7007/go7007-v4l2.c        | 1499 ++++
 drivers/staging/go7007/go7007.h             |  114 +
 drivers/staging/go7007/saa7134-go7007.c     |  484 ++
 drivers/staging/go7007/snd-go7007.c         |  305 +
 drivers/staging/go7007/wis-i2c.h            |   55 +
 drivers/staging/go7007/wis-ov7640.c         |  130 +
 drivers/staging/go7007/wis-saa7113.c        |  358 +
 drivers/staging/go7007/wis-saa7115.c        |  491 ++
 drivers/staging/go7007/wis-sony-tuner.c     |  742 ++
 drivers/staging/go7007/wis-tw2804.c         |  380 +
 drivers/staging/go7007/wis-tw9903.c         |  362 +
 drivers/staging/go7007/wis-uda1342.c        |  136 +
 drivers/staging/me4000/Kconfig              |   10 +
 drivers/staging/me4000/Makefile             |    1 +
 drivers/staging/me4000/README               |   13 +
 drivers/staging/me4000/me4000.c             | 6133 ++++++++++++++++
 drivers/staging/me4000/me4000.h             |  954 +++
 drivers/staging/me4000/me4000_firmware.h    |10033 +++++++++++++++++++++++++++
 drivers/staging/me4000/me4610_firmware.h    | 5409 +++++++++++++++
 drivers/staging/slicoss/Kconfig             |   14 +
 drivers/staging/slicoss/Makefile            |    1 +
 drivers/staging/slicoss/README              |   19 +
 drivers/staging/slicoss/gbdownload.h        | 8215 ++++++++++++++++++++++
 drivers/staging/slicoss/gbrcvucode.h        |  238 +
 drivers/staging/slicoss/oasisdbgdownload.h  | 6850 ++++++++++++++++++
 drivers/staging/slicoss/oasisdownload.h     | 6848 ++++++++++++++++++
 drivers/staging/slicoss/oasisrcvucode.h     |  205 +
 drivers/staging/slicoss/slic.h              |  598 ++
 drivers/staging/slicoss/slic_os.h           |   84 +
 drivers/staging/slicoss/slicbuild.h         |   96 +
 drivers/staging/slicoss/slicdbg.h           |  100 +
 drivers/staging/slicoss/slicdump.h          |  278 +
 drivers/staging/slicoss/slichw.h            |  845 +++
 drivers/staging/slicoss/slicinc.h           |  185 +
 drivers/staging/slicoss/slicoss.c           | 5936 ++++++++++++++++
 drivers/staging/sxg/Kconfig                 |   10 +
 drivers/staging/sxg/Makefile                |    1 +
 drivers/staging/sxg/README                  |   13 +
 drivers/staging/sxg/saharadbgdownload.h     | 4854 +++++++++++++
 drivers/staging/sxg/sxg.c                   | 3624 ++++++++++
 drivers/staging/sxg/sxg.h                   |  773 +++
 drivers/staging/sxg/sxg_os.h                |  154 +
 drivers/staging/sxg/sxgdbg.h                |  190 +
 drivers/staging/sxg/sxghif.h                |  861 +++
 drivers/staging/sxg/sxghw.h                 |  734 ++
 drivers/staging/sxg/sxgphycode.h            |  349 +
 drivers/staging/usbip/Kconfig               |   36 +
 drivers/staging/usbip/Makefile              |   12 +
 drivers/staging/usbip/README                |    6 +
 drivers/staging/usbip/stub.h                |   95 +
 drivers/staging/usbip/stub_dev.c            |  483 ++
 drivers/staging/usbip/stub_main.c           |  300 +
 drivers/staging/usbip/stub_rx.c             |  615 ++
 drivers/staging/usbip/stub_tx.c             |  371 +
 drivers/staging/usbip/usbip_common.c        |  997 +++
 drivers/staging/usbip/usbip_common.h        |  406 ++
 drivers/staging/usbip/usbip_event.c         |  141 +
 drivers/staging/usbip/vhci.h                |  142 +
 drivers/staging/usbip/vhci_hcd.c            | 1275 ++++
 drivers/staging/usbip/vhci_rx.c             |  251 +
 drivers/staging/usbip/vhci_sysfs.c          |  250 +
 drivers/staging/usbip/vhci_tx.c             |  239 +
 drivers/staging/winbond/Kconfig             |    7 +
 drivers/staging/winbond/Makefile            |   18 +
 drivers/staging/winbond/README              |   10 +
 drivers/staging/winbond/adapter.h           |   23 +
 drivers/staging/winbond/bss_f.h             |   59 +
 drivers/staging/winbond/bssdscpt.h          |  156 +
 drivers/staging/winbond/ds_tkip.h           |   33 +
 drivers/staging/winbond/gl_80211.h          |  125 +
 drivers/staging/winbond/ioctls.h            |  678 ++
 drivers/staging/winbond/linux/common.h      |  143 +
 drivers/staging/winbond/linux/sysdef.h      |   73 +
 drivers/staging/winbond/linux/wb35reg.c     |  747 ++
 drivers/staging/winbond/linux/wb35reg_f.h   |   56 +
 drivers/staging/winbond/linux/wb35reg_s.h   |  170 +
 drivers/staging/winbond/linux/wb35rx.c      |  337 +
 drivers/staging/winbond/linux/wb35rx_f.h    |   17 +
 drivers/staging/winbond/linux/wb35rx_s.h    |   48 +
 drivers/staging/winbond/linux/wb35tx.c      |  313 +
 drivers/staging/winbond/linux/wb35tx_f.h    |   20 +
 drivers/staging/winbond/linux/wb35tx_s.h    |   47 +
 drivers/staging/winbond/linux/wbusb.c       |  404 ++
 drivers/staging/winbond/linux/wbusb_f.h     |   34 +
 drivers/staging/winbond/linux/wbusb_s.h     |   42 +
 drivers/staging/winbond/localpara.h         |  275 +
 drivers/staging/winbond/mac_structures.h    |  670 ++
 drivers/staging/winbond/mds.c               |  630 ++
 drivers/staging/winbond/mds_f.h             |   33 +
 drivers/staging/winbond/mds_s.h             |  183 +
 drivers/staging/winbond/mlme_mib.h          |   84 +
 drivers/staging/winbond/mlme_s.h            |  195 +
 drivers/staging/winbond/mlmetxrx.c          |  150 +
 drivers/staging/winbond/mlmetxrx_f.h        |   52 +
 drivers/staging/winbond/mto.c               | 1229 ++++
 drivers/staging/winbond/mto.h               |  265 +
 drivers/staging/winbond/mto_f.h             |    7 +
 drivers/staging/winbond/os_common.h         |    2 +
 drivers/staging/winbond/phy_calibration.c   | 1759 +++++
 drivers/staging/winbond/phy_calibration.h   |  101 +
 drivers/staging/winbond/reg.c               | 2683 +++++++
 drivers/staging/winbond/rxisr.c             |   30 +
 drivers/staging/winbond/scan_s.h            |  115 +
 drivers/staging/winbond/sme_api.c           |   13 +
 drivers/staging/winbond/sme_api.h           |  265 +
 drivers/staging/winbond/sme_s.h             |  228 +
 drivers/staging/winbond/wb35_ver.h          |   30 +
 drivers/staging/winbond/wbhal.c             |  878 +++
 drivers/staging/winbond/wbhal_f.h           |  122 +
 drivers/staging/winbond/wbhal_s.h           |  615 ++
 drivers/staging/winbond/wblinux.c           |  277 +
 drivers/staging/winbond/wblinux_f.h         |   23 +
 drivers/staging/winbond/wblinux_s.h         |   45 +
 drivers/staging/wlan-ng/Kconfig             |   10 +
 drivers/staging/wlan-ng/Makefile            |    9 +
 drivers/staging/wlan-ng/README              |    8 +
 drivers/staging/wlan-ng/hfa384x.c           | 4018 +++++++++++
 drivers/staging/wlan-ng/hfa384x.h           | 3067 ++++++++
 drivers/staging/wlan-ng/hfa384x_usb.c       | 5027 ++++++++++++++
 drivers/staging/wlan-ng/p80211conv.c        |  683 ++
 drivers/staging/wlan-ng/p80211conv.h        |  186 +
 drivers/staging/wlan-ng/p80211hdr.h         |  299 +
 drivers/staging/wlan-ng/p80211ioctl.h       |  123 +
 drivers/staging/wlan-ng/p80211meta.h        |  169 +
 drivers/staging/wlan-ng/p80211metadef.h     | 2524 +++++++
 drivers/staging/wlan-ng/p80211metamib.h     |  105 +
 drivers/staging/wlan-ng/p80211metamsg.h     |  105 +
 drivers/staging/wlan-ng/p80211metastruct.h  |  644 ++
 drivers/staging/wlan-ng/p80211mgmt.h        |  575 ++
 drivers/staging/wlan-ng/p80211mod.c         |  216 +
 drivers/staging/wlan-ng/p80211msg.h         |  102 +
 drivers/staging/wlan-ng/p80211netdev.c      | 1502 ++++
 drivers/staging/wlan-ng/p80211netdev.h      |  336 +
 drivers/staging/wlan-ng/p80211req.c         |  329 +
 drivers/staging/wlan-ng/p80211req.h         |   68 +
 drivers/staging/wlan-ng/p80211types.h       |  675 ++
 drivers/staging/wlan-ng/p80211wep.c         |  317 +
 drivers/staging/wlan-ng/p80211wext.c        | 2048 ++++++
 drivers/staging/wlan-ng/prism2_cs.c         | 1487 ++++
 drivers/staging/wlan-ng/prism2_pci.c        |  332 +
 drivers/staging/wlan-ng/prism2_plx.c        |  472 ++
 drivers/staging/wlan-ng/prism2_usb.c        |  361 +
 drivers/staging/wlan-ng/prism2mgmt.c        | 2956 ++++++++
 drivers/staging/wlan-ng/prism2mgmt.h        |  182 +
 drivers/staging/wlan-ng/prism2mib.c         | 3799 ++++++++++
 drivers/staging/wlan-ng/prism2sta.c         | 2502 +++++++
 drivers/staging/wlan-ng/version.h           |   64 +
 drivers/staging/wlan-ng/wlan_compat.h       |  757 ++
 include/linux/kernel.h                      |    1 +
 kernel/module.c                             |   11 +
 kernel/panic.c                              |    6 +-
 scripts/mod/modpost.c                       |    9 +
 205 files changed, 146209 insertions(+), 2 deletions(-)
 create mode 100644 drivers/staging/Kconfig
 create mode 100644 drivers/staging/Makefile
 create mode 100644 drivers/staging/echo/Kconfig
 create mode 100644 drivers/staging/echo/Makefile
 create mode 100644 drivers/staging/echo/TODO
 create mode 100644 drivers/staging/echo/bit_operations.h
 create mode 100644 drivers/staging/echo/echo.c
 create mode 100644 drivers/staging/echo/echo.h
 create mode 100644 drivers/staging/echo/fir.h
 create mode 100644 drivers/staging/echo/mmx.h
 create mode 100644 drivers/staging/et131x/Kconfig
 create mode 100644 drivers/staging/et131x/Makefile
 create mode 100644 drivers/staging/et131x/README
 create mode 100644 drivers/staging/et131x/et1310_address_map.h
 create mode 100644 drivers/staging/et131x/et1310_eeprom.c
 create mode 100644 drivers/staging/et131x/et1310_eeprom.h
 create mode 100644 drivers/staging/et131x/et1310_jagcore.c
 create mode 100644 drivers/staging/et131x/et1310_jagcore.h
 create mode 100644 drivers/staging/et131x/et1310_mac.c
 create mode 100644 drivers/staging/et131x/et1310_mac.h
 create mode 100644 drivers/staging/et131x/et1310_phy.c
 create mode 100644 drivers/staging/et131x/et1310_phy.h
 create mode 100644 drivers/staging/et131x/et1310_pm.c
 create mode 100644 drivers/staging/et131x/et1310_pm.h
 create mode 100644 drivers/staging/et131x/et1310_rx.c
 create mode 100644 drivers/staging/et131x/et1310_rx.h
 create mode 100644 drivers/staging/et131x/et1310_tx.c
 create mode 100644 drivers/staging/et131x/et1310_tx.h
 create mode 100644 drivers/staging/et131x/et131x_adapter.h
 create mode 100644 drivers/staging/et131x/et131x_config.c
 create mode 100644 drivers/staging/et131x/et131x_config.h
 create mode 100644 drivers/staging/et131x/et131x_debug.c
 create mode 100644 drivers/staging/et131x/et131x_debug.h
 create mode 100644 drivers/staging/et131x/et131x_defs.h
 create mode 100644 drivers/staging/et131x/et131x_initpci.c
 create mode 100644 drivers/staging/et131x/et131x_initpci.h
 create mode 100644 drivers/staging/et131x/et131x_isr.c
 create mode 100644 drivers/staging/et131x/et131x_isr.h
 create mode 100644 drivers/staging/et131x/et131x_netdev.c
 create mode 100644 drivers/staging/et131x/et131x_netdev.h
 create mode 100644 drivers/staging/et131x/et131x_version.h
 create mode 100644 drivers/staging/go7007/Kconfig
 create mode 100644 drivers/staging/go7007/Makefile
 create mode 100644 drivers/staging/go7007/README
 create mode 100644 drivers/staging/go7007/go7007-driver.c
 create mode 100644 drivers/staging/go7007/go7007-fw.c
 create mode 100644 drivers/staging/go7007/go7007-i2c.c
 create mode 100644 drivers/staging/go7007/go7007-priv.h
 create mode 100644 drivers/staging/go7007/go7007-usb.c
 create mode 100644 drivers/staging/go7007/go7007-v4l2.c
 create mode 100644 drivers/staging/go7007/go7007.h
 create mode 100644 drivers/staging/go7007/saa7134-go7007.c
 create mode 100644 drivers/staging/go7007/snd-go7007.c
 create mode 100644 drivers/staging/go7007/wis-i2c.h
 create mode 100644 drivers/staging/go7007/wis-ov7640.c
 create mode 100644 drivers/staging/go7007/wis-saa7113.c
 create mode 100644 drivers/staging/go7007/wis-saa7115.c
 create mode 100644 drivers/staging/go7007/wis-sony-tuner.c
 create mode 100644 drivers/staging/go7007/wis-tw2804.c
 create mode 100644 drivers/staging/go7007/wis-tw9903.c
 create mode 100644 drivers/staging/go7007/wis-uda1342.c
 create mode 100644 drivers/staging/me4000/Kconfig
 create mode 100644 drivers/staging/me4000/Makefile
 create mode 100644 drivers/staging/me4000/README
 create mode 100644 drivers/staging/me4000/me4000.c
 create mode 100644 drivers/staging/me4000/me4000.h
 create mode 100644 drivers/staging/me4000/me4000_firmware.h
 create mode 100644 drivers/staging/me4000/me4610_firmware.h
 create mode 100644 drivers/staging/slicoss/Kconfig
 create mode 100644 drivers/staging/slicoss/Makefile
 create mode 100644 drivers/staging/slicoss/README
 create mode 100644 drivers/staging/slicoss/gbdownload.h
 create mode 100644 drivers/staging/slicoss/gbrcvucode.h
 create mode 100644 drivers/staging/slicoss/oasisdbgdownload.h
 create mode 100644 drivers/staging/slicoss/oasisdownload.h
 create mode 100644 drivers/staging/slicoss/oasisrcvucode.h
 create mode 100644 drivers/staging/slicoss/slic.h
 create mode 100644 drivers/staging/slicoss/slic_os.h
 create mode 100644 drivers/staging/slicoss/slicbuild.h
 create mode 100644 drivers/staging/slicoss/slicdbg.h
 create mode 100644 drivers/staging/slicoss/slicdump.h
 create mode 100644 drivers/staging/slicoss/slichw.h
 create mode 100644 drivers/staging/slicoss/slicinc.h
 create mode 100644 drivers/staging/slicoss/slicoss.c
 create mode 100644 drivers/staging/sxg/Kconfig
 create mode 100644 drivers/staging/sxg/Makefile
 create mode 100644 drivers/staging/sxg/README
 create mode 100644 drivers/staging/sxg/saharadbgdownload.h
 create mode 100644 drivers/staging/sxg/sxg.c
 create mode 100644 drivers/staging/sxg/sxg.h
 create mode 100644 drivers/staging/sxg/sxg_os.h
 create mode 100644 drivers/staging/sxg/sxgdbg.h
 create mode 100644 drivers/staging/sxg/sxghif.h
 create mode 100644 drivers/staging/sxg/sxghw.h
 create mode 100644 drivers/staging/sxg/sxgphycode.h
 create mode 100644 drivers/staging/usbip/Kconfig
 create mode 100644 drivers/staging/usbip/Makefile
 create mode 100644 drivers/staging/usbip/README
 create mode 100644 drivers/staging/usbip/stub.h
 create mode 100644 drivers/staging/usbip/stub_dev.c
 create mode 100644 drivers/staging/usbip/stub_main.c
 create mode 100644 drivers/staging/usbip/stub_rx.c
 create mode 100644 drivers/staging/usbip/stub_tx.c
 create mode 100644 drivers/staging/usbip/usbip_common.c
 create mode 100644 drivers/staging/usbip/usbip_common.h
 create mode 100644 drivers/staging/usbip/usbip_event.c
 create mode 100644 drivers/staging/usbip/vhci.h
 create mode 100644 drivers/staging/usbip/vhci_hcd.c
 create mode 100644 drivers/staging/usbip/vhci_rx.c
 create mode 100644 drivers/staging/usbip/vhci_sysfs.c
 create mode 100644 drivers/staging/usbip/vhci_tx.c
 create mode 100644 drivers/staging/winbond/Kconfig
 create mode 100644 drivers/staging/winbond/Makefile
 create mode 100644 drivers/staging/winbond/README
 create mode 100644 drivers/staging/winbond/adapter.h
 create mode 100644 drivers/staging/winbond/bss_f.h
 create mode 100644 drivers/staging/winbond/bssdscpt.h
 create mode 100644 drivers/staging/winbond/ds_tkip.h
 create mode 100644 drivers/staging/winbond/gl_80211.h
 create mode 100644 drivers/staging/winbond/ioctls.h
 create mode 100644 drivers/staging/winbond/linux/common.h
 create mode 100644 drivers/staging/winbond/linux/sysdef.h
 create mode 100644 drivers/staging/winbond/linux/wb35reg.c
 create mode 100644 drivers/staging/winbond/linux/wb35reg_f.h
 create mode 100644 drivers/staging/winbond/linux/wb35reg_s.h
 create mode 100644 drivers/staging/winbond/linux/wb35rx.c
 create mode 100644 drivers/staging/winbond/linux/wb35rx_f.h
 create mode 100644 drivers/staging/winbond/linux/wb35rx_s.h
 create mode 100644 drivers/staging/winbond/linux/wb35tx.c
 create mode 100644 drivers/staging/winbond/linux/wb35tx_f.h
 create mode 100644 drivers/staging/winbond/linux/wb35tx_s.h
 create mode 100644 drivers/staging/winbond/linux/wbusb.c
 create mode 100644 drivers/staging/winbond/linux/wbusb_f.h
 create mode 100644 drivers/staging/winbond/linux/wbusb_s.h
 create mode 100644 drivers/staging/winbond/localpara.h
 create mode 100644 drivers/staging/winbond/mac_structures.h
 create mode 100644 drivers/staging/winbond/mds.c
 create mode 100644 drivers/staging/winbond/mds_f.h
 create mode 100644 drivers/staging/winbond/mds_s.h
 create mode 100644 drivers/staging/winbond/mlme_mib.h
 create mode 100644 drivers/staging/winbond/mlme_s.h
 create mode 100644 drivers/staging/winbond/mlmetxrx.c
 create mode 100644 drivers/staging/winbond/mlmetxrx_f.h
 create mode 100644 drivers/staging/winbond/mto.c
 create mode 100644 drivers/staging/winbond/mto.h
 create mode 100644 drivers/staging/winbond/mto_f.h
 create mode 100644 drivers/staging/winbond/os_common.h
 create mode 100644 drivers/staging/winbond/phy_calibration.c
 create mode 100644 drivers/staging/winbond/phy_calibration.h
 create mode 100644 drivers/staging/winbond/reg.c
 create mode 100644 drivers/staging/winbond/rxisr.c
 create mode 100644 drivers/staging/winbond/scan_s.h
 create mode 100644 drivers/staging/winbond/sme_api.c
 create mode 100644 drivers/staging/winbond/sme_api.h
 create mode 100644 drivers/staging/winbond/sme_s.h
 create mode 100644 drivers/staging/winbond/wb35_ver.h
 create mode 100644 drivers/staging/winbond/wbhal.c
 create mode 100644 drivers/staging/winbond/wbhal_f.h
 create mode 100644 drivers/staging/winbond/wbhal_s.h
 create mode 100644 drivers/staging/winbond/wblinux.c
 create mode 100644 drivers/staging/winbond/wblinux_f.h
 create mode 100644 drivers/staging/winbond/wblinux_s.h
 create mode 100644 drivers/staging/wlan-ng/Kconfig
 create mode 100644 drivers/staging/wlan-ng/Makefile
 create mode 100644 drivers/staging/wlan-ng/README
 create mode 100644 drivers/staging/wlan-ng/hfa384x.c
 create mode 100644 drivers/staging/wlan-ng/hfa384x.h
 create mode 100644 drivers/staging/wlan-ng/hfa384x_usb.c
 create mode 100644 drivers/staging/wlan-ng/p80211conv.c
 create mode 100644 drivers/staging/wlan-ng/p80211conv.h
 create mode 100644 drivers/staging/wlan-ng/p80211hdr.h
 create mode 100644 drivers/staging/wlan-ng/p80211ioctl.h
 create mode 100644 drivers/staging/wlan-ng/p80211meta.h
 create mode 100644 drivers/staging/wlan-ng/p80211metadef.h
 create mode 100644 drivers/staging/wlan-ng/p80211metamib.h
 create mode 100644 drivers/staging/wlan-ng/p80211metamsg.h
 create mode 100644 drivers/staging/wlan-ng/p80211metastruct.h
 create mode 100644 drivers/staging/wlan-ng/p80211mgmt.h
 create mode 100644 drivers/staging/wlan-ng/p80211mod.c
 create mode 100644 drivers/staging/wlan-ng/p80211msg.h
 create mode 100644 drivers/staging/wlan-ng/p80211netdev.c
 create mode 100644 drivers/staging/wlan-ng/p80211netdev.h
 create mode 100644 drivers/staging/wlan-ng/p80211req.c
 create mode 100644 drivers/staging/wlan-ng/p80211req.h
 create mode 100644 drivers/staging/wlan-ng/p80211types.h
 create mode 100644 drivers/staging/wlan-ng/p80211wep.c
 create mode 100644 drivers/staging/wlan-ng/p80211wext.c
 create mode 100644 drivers/staging/wlan-ng/prism2_cs.c
 create mode 100644 drivers/staging/wlan-ng/prism2_pci.c
 create mode 100644 drivers/staging/wlan-ng/prism2_plx.c
 create mode 100644 drivers/staging/wlan-ng/prism2_usb.c
 create mode 100644 drivers/staging/wlan-ng/prism2mgmt.c
 create mode 100644 drivers/staging/wlan-ng/prism2mgmt.h
 create mode 100644 drivers/staging/wlan-ng/prism2mib.c
 create mode 100644 drivers/staging/wlan-ng/prism2sta.c
 create mode 100644 drivers/staging/wlan-ng/version.h
 create mode 100644 drivers/staging/wlan-ng/wlan_compat.h

---------------

David Rowe (1):
      Staging: add echo cancelation module

Greg Kroah-Hartman (11):
      Staging: add TAINT_CRAP for all drivers/staging code
      Staging: add TAINT_CRAP flag to drivers/staging modules
      Staging: add Kconfig entries and Makefile infrastructure
      Staging: add MAINTAINERS entry
      Staging: add et131x network driver
      Staging: add Alacritech slicoss network driver
      Staging: add sxg network driver
      Staging: add me4000 firmware files
      Staging: add me4000 pci data collection driver
      Staging: add the go7007 video driver
      Staging: add wlan-ng prism2 usb driver

J.R. Mauro (2):
      Staging: Fix gcc warnings in sxg
      Staging: Lindent sxg.c

Lior Dotan (4):
      Staging: SLICOSS: lots of checkpatch fixes
      Staging: SLICOSS: Fix warnings due to static usage
      Staging: SLICOSS: Fix remaining type names
      Staging: SLICOSS: Call pci_release_regions at driver exit

Pavel Machek (1):
      Staging: add w35und wifi driver

Ross Cohen (1):
      Staging: go7007 v4l fixes

Takahiro Hirofuchi (3):
      Staging: USB/IP: add common functions needed
      Staging: USB/IP: add client driver
      Staging: USB/IP: add host driver

