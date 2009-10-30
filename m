Return-Path: <linux-kernel-owner+w=401wt.eu-S932973AbZJ3WKC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbZJ3WKC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 18:10:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932952AbZJ3WJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 18:09:58 -0400
Received: from kroah.org ([198.145.64.141]:48363 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757544AbZJ3WJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 18:09:52 -0400
Date: Fri, 30 Oct 2009 15:09:37 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [GIT PATCH] STAGING fixes for 2.6.32-git
Message-ID: <20091030220937.GB11297@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some staging fixes for your 2.6.32-git tree.

The big one here is a removal of a driver that is now working properly
with a "real" driver in the network driver portion of the kernel tree.
The other fixes are minor ones that solve problems that have been
reported (like finally getting the Hyper-V drivers to work properly.)

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

All of these patches have been in the linux-next and mm trees for a
while.

The patches will be sent as a follow-on to this message to the
driver-devel list for people to see.

thanks,

greg k-h

--------------

 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 drivers/staging/android/Kconfig                    |    1 +
 drivers/staging/hv/ChannelMgmt.h                   |    3 +-
 drivers/staging/hv/NetVsc.c                        |   10 +-
 drivers/staging/hv/TODO                            |    6 +
 drivers/staging/hv/osd.h                           |    1 +
 drivers/staging/hv/vmbus_drv.c                     |   28 +-
 drivers/staging/otus/Kconfig                       |    2 +-
 drivers/staging/panel/panel.c                      |   13 +-
 drivers/staging/rt2860/Kconfig                     |    2 +-
 drivers/staging/rt2870/Kconfig                     |    2 +-
 drivers/staging/rt3090/Kconfig                     |    2 +-
 drivers/staging/rtl8187se/Kconfig                  |    2 +-
 .../staging/rtl8187se/ieee80211/ieee80211_crypt.c  |    4 +-
 .../staging/rtl8187se/ieee80211/ieee80211_module.c |    4 +-
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |   12 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |   17 +-
 drivers/staging/rtl8192e/Kconfig                   |    2 +-
 .../staging/rtl8192e/ieee80211/ieee80211_crypt.c   |    8 +-
 .../staging/rtl8192e/ieee80211/ieee80211_module.c  |    8 +-
 .../staging/rtl8192e/ieee80211/ieee80211_softmac.c |   19 +-
 drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c  |   21 +-
 drivers/staging/rtl8192su/Kconfig                  |    2 +-
 .../staging/rtl8192su/ieee80211/ieee80211_crypt.c  |    4 +-
 .../staging/rtl8192su/ieee80211/ieee80211_module.c |    4 +-
 .../rtl8192su/ieee80211/ieee80211_softmac.c        |   15 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c |   17 +-
 drivers/staging/stlc45xx/Kconfig                   |    8 -
 drivers/staging/stlc45xx/Makefile                  |    1 -
 drivers/staging/stlc45xx/stlc45xx.c                | 2594 --------------------
 drivers/staging/stlc45xx/stlc45xx.h                |  283 ---
 drivers/staging/stlc45xx/stlc45xx_lmac.h           |  434 ----
 drivers/staging/vt6656/main_usb.c                  |    1 -
 drivers/staging/winbond/Kconfig                    |    2 +-
 drivers/staging/wlan-ng/Kconfig                    |    2 +-
 36 files changed, 75 insertions(+), 3462 deletions(-)
 delete mode 100644 drivers/staging/stlc45xx/Kconfig
 delete mode 100644 drivers/staging/stlc45xx/Makefile
 delete mode 100644 drivers/staging/stlc45xx/stlc45xx.c
 delete mode 100644 drivers/staging/stlc45xx/stlc45xx.h
 delete mode 100644 drivers/staging/stlc45xx/stlc45xx_lmac.h

---------------

Greg Kroah-Hartman (3):
      Staging: remove stlc45xx driver
      Staging: android: mark subsystem as broken
      Staging: wireless drivers Kconfig change

Haiyang Zhang (1):
      Staging: hv: Fix null pointer error after vmbus loading

Hank Janssen (1):
      Staging: hv: Fix vmbus load hang caused by faulty data packing

Herton Ronaldo Krzesinski (1):
      Staging: rtl8187se/rtl8192e/rtl8192su: allow module unload

Milan Dadok (3):
      Staging: hv: fix oops in vmbus - udev events
      Staging: hv: fix oops in vmbus - netvsc list_head
      Staging: hv: fix oops in vmbus - missing #include

Peter Huewe (1):
      Staging: Panel: prevent driver from calling misc_deregister twice on same ressource

Randy Dunlap (1):
      Staging: fix wireless drivers depends

Stephen Hemminger (1):
      Staging: hv TODO patches

miaofng (1):
      Staging: vt6656: fix the memory free bug in vntwusb_disconnect()

