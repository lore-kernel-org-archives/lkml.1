Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbZLWTuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbZLWTuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbZLWTui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:50:38 -0500
Received: from kroah.org ([198.145.64.141]:39856 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135AbZLWTu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:50:28 -0500
Date: Wed, 23 Dec 2009 11:50:00 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [GIT PATCH] STAGING patches for 2.6.33-git
Message-ID: <20091223195000.GC18101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some staging patches for your 2.6.33-rc1 tree.

There are two big things here, the removal of the dst driver, which the
author asked for as there are no users, and no more development is
happening on this, and the addition of a framebuffer driver.  The
framebuffer driver had been sent before the merge window, but was
waiting on patches from another tree to land in your tree before I could
send this.  Both of these are self-contained in the staging tree
(somehow the dst.h file ended up in the main kernel include directory,
but no other code was ever using this, sorry about that.)

There are some other minor patches, build fixes and Kconfig dependancy
issues, nothing big.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

All of these patches have been in the linux-next and mm trees.

The patches will be sent as a follow-on to this message to the
driver-devel list for people to see.

thanks,

greg k-h

--------------

 drivers/staging/Kconfig                            |    4 +-
 drivers/staging/Makefile                           |    2 +-
 drivers/staging/batman-adv/Kconfig                 |    1 +
 drivers/staging/batman-adv/send.c                  |    4 +-
 drivers/staging/comedi/comedi.h                    |    2 +-
 drivers/staging/comedi/drivers/jr3_pci.c           |    7 +-
 drivers/staging/comedi/drivers/usbdux.c            |    5 +-
 drivers/staging/dst/Kconfig                        |   67 --
 drivers/staging/dst/Makefile                       |    3 -
 drivers/staging/dst/crypto.c                       |  733 ------------
 drivers/staging/dst/dcore.c                        |  968 ---------------
 drivers/staging/dst/export.c                       |  660 -----------
 drivers/staging/dst/state.c                        |  844 -------------
 drivers/staging/dst/thread_pool.c                  |  348 ------
 drivers/staging/dst/trans.c                        |  337 ------
 drivers/staging/panel/Kconfig                      |    2 +-
 drivers/staging/panel/panel.c                      |    2 +-
 drivers/staging/ramzswap/TODO                      |    1 -
 drivers/staging/ramzswap/ramzswap_drv.c            |   28 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |   10 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |    2 +-
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |   14 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |    2 +-
 drivers/staging/rtl8187se/r8180_core.c             |   10 +-
 drivers/staging/rtl8187se/r8180_wx.c               |    2 +-
 drivers/staging/rtl8192e/ieee80211.h               |   12 +-
 drivers/staging/rtl8192e/ieee80211/ieee80211.h     |   12 +-
 .../staging/rtl8192e/ieee80211/ieee80211_module.c  |   10 +-
 drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c  |    2 +-
 .../staging/rtl8192e/ieee80211/ieee80211_softmac.c |   24 +-
 drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c  |    2 +-
 drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c  |    2 +-
 .../staging/rtl8192e/ieee80211/rtl819x_BAProc.c    |    6 +-
 drivers/staging/rtl8192e/r8192E_core.c             |   14 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211.h    |    8 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c |    6 +-
 .../rtl8192su/ieee80211/ieee80211_softmac.c        |   16 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c |    2 +-
 drivers/staging/rtl8192su/r8192U_core.c            |   10 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c  |    2 +-
 .../staging/rtl8192u/ieee80211/rtl819x_BAProc.c    |    6 +-
 drivers/staging/sm7xx/Kconfig                      |   15 +
 drivers/staging/sm7xx/Makefile                     |    3 +
 drivers/staging/sm7xx/TODO                         |   10 +
 drivers/staging/sm7xx/smtc2d.c                     |  979 +++++++++++++++
 drivers/staging/sm7xx/smtc2d.h                     |  530 +++++++++
 drivers/staging/sm7xx/smtcfb.c                     | 1253 ++++++++++++++++++++
 drivers/staging/sm7xx/smtcfb.h                     |  793 +++++++++++++
 drivers/staging/vt6655/Kconfig                     |    2 +-
 drivers/staging/vt6656/Kconfig                     |    2 +-
 drivers/staging/wlan-ng/prism2fw.c                 |    2 +-
 include/linux/dst.h                                |  587 ---------
 52 files changed, 3696 insertions(+), 4672 deletions(-)
 delete mode 100644 drivers/staging/dst/Kconfig
 delete mode 100644 drivers/staging/dst/Makefile
 delete mode 100644 drivers/staging/dst/crypto.c
 delete mode 100644 drivers/staging/dst/dcore.c
 delete mode 100644 drivers/staging/dst/export.c
 delete mode 100644 drivers/staging/dst/state.c
 delete mode 100644 drivers/staging/dst/thread_pool.c
 delete mode 100644 drivers/staging/dst/trans.c
 create mode 100644 drivers/staging/sm7xx/Kconfig
 create mode 100644 drivers/staging/sm7xx/Makefile
 create mode 100644 drivers/staging/sm7xx/TODO
 create mode 100644 drivers/staging/sm7xx/smtc2d.c
 create mode 100644 drivers/staging/sm7xx/smtc2d.h
 create mode 100644 drivers/staging/sm7xx/smtcfb.c
 create mode 100644 drivers/staging/sm7xx/smtcfb.h
 delete mode 100644 include/linux/dst.h

---------------

Andrew Lunn (1):
      Staging: batman-adv: Add Kconfig dependancies on PROC_FS and PACKET.

Bernd Porr (2):
      Staging: comedi: usbdux.c: fix locking up of the driver when the comedi ringbuffer runs empty
      Staging: comedi: removed "depricated" from COMEDI_CB_BLOCK

George Kadianakis (3):
      Staging: fix rtl8187se compilation errors with mac80211
      staging: fix rtl8192e compilation errors with mac80211
      staging: fix rtl8192su compilation errors with mac80211

Greg Kroah-Hartman (2):
      Staging: batman: fix debug Kconfig option
      Staging: dst: remove from the tree

Ian Abbott (1):
      Staging: comedi: jr3_pci: Don't ioremap too much space. Check result.

Julia Lawall (2):
      Staging: wlan-ng: fix Correct size given to memset
      Staging: batman-adv: introduce missing kfree

Nitin Gupta (1):
      Staging: ramzswap: remove ARM specific d-cache hack

Peter Huewe (2):
      Staging: panel: Fix compilation error with custom lcd charset
      Staging: panel: Adjust range for PANEL_KEYPAD in Kconfig

Randy Dunlap (2):
      Staging: rtl8192x: fix printk formats
      Staging/vt66*: kconfig, depends on WLAN

Roel Kluin (1):
      Staging: rtl8192su: fix test for negative error in rtl8192_rx_isr()

Stephane Glondu (1):
      staging: rtl8192su: add USB VID/PID for HWNUm-300

Wu Zhangjin (1):
      Staging: sm7xx: add a new framebuffer driver

