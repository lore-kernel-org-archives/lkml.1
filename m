Return-Path: <linux-kernel-owner+w=401wt.eu-S932128AbXB1KRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbXB1KRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 05:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932123AbXB1KRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 05:17:35 -0500
Received: from styx.suse.cz ([82.119.242.94]:59552 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932128AbXB1KRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 05:17:34 -0500
Date: Wed, 28 Feb 2007 11:19:01 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] HID and USB HID update for 2.6.21-rc2
Message-ID: <Pine.LNX.4.64.0702281114420.4255@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

or
        master.kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive updates for HID core layer and USB HID for 2.6.21-rc2. These 
are mainly straightforward fixes for various broken devices (kernel 
bugzilla #8099, #7352) and other trivial things.

The diffstat looks larger because the usbhid code is moved from 
USB-specific directory to HID-specific directory, as discussed previously 
with Greg and Dmitry in order to ease maintainance, no functional changes 
here. This was held back until all related fixes from other people trees 
are upstream, so that no merge conflicts occur.

 MAINTAINERS                                   |    2 +
 drivers/hid/Kconfig                           |    2 +
 drivers/hid/Makefile                          |    2 +
 drivers/hid/hid-core.c                        |    7 +-
 drivers/hid/hid-debug.c                       |    1 +
 drivers/hid/hid-input.c                       |   37 +-
 drivers/hid/usbhid/Kconfig                    |  152 +++
 drivers/hid/usbhid/Makefile                   |   33 +
 drivers/hid/usbhid/hid-core.c                 | 1061 ++++++++++++++++++
 drivers/{usb/input => hid/usbhid}/hid-ff.c    |    0 
 drivers/{usb/input => hid/usbhid}/hid-lgff.c  |    0 
 drivers/{usb/input => hid/usbhid}/hid-pidff.c |    0 
 drivers/{usb/input => hid/usbhid}/hid-plff.c  |    0 
 drivers/{usb/input => hid/usbhid}/hid-tmff.c  |    0 
 drivers/{usb/input => hid/usbhid}/hid-zpff.c  |    0 
 drivers/{usb/input => hid/usbhid}/hiddev.c    |    0 
 drivers/hid/usbhid/usbhid.h                   |  504 +++++++++
 drivers/{usb/input => hid/usbhid}/usbkbd.c    |    0 
 drivers/{usb/input => hid/usbhid}/usbmouse.c  |    0 
 drivers/usb/input/Kconfig                     |  145 ---
 drivers/usb/input/Makefile                    |   24 -
 drivers/usb/input/hid-core.c                  | 1457 -------------------------
 drivers/usb/input/usbhid.h                    |   87 --
 include/linux/hid.h                           |    6 +-
 24 files changed, 1793 insertions(+), 1727 deletions(-)

Adrian Bunk (1):
      HID: hid-debug.c should #include <linux/hid-debug.h>

Jiri Kosina (8):
      USB HID: use CONFIG_HID_DEBUG for outputting report descriptor
      HID: fix bug in zeroing the last field byte in output reports
      HID: fix possible double-free on error path in hid parser
      HID: fix broken Logitech S510 keyboard report descriptor; make extra keys work
      USB HID: move usbhid to hid-specific directory
      USB HID: cleanup - move hid_blacklist to where it belongs
      HID: add git tree information to MAINTAINERS
      HID: fix Logitech DiNovo Edge touchwheel and Logic3 /SpectraVideo middle button

Julien BLACHE (1):
      USB HID: Fix USB vendor and product IDs endianness for USB HID devices

