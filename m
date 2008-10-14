Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbYJNAHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbYJNAHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 20:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbYJNAHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 20:07:35 -0400
Received: from styx.suse.cz ([82.119.242.94]:55905 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757133AbYJNAHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 20:07:34 -0400
Date: Tue, 14 Oct 2008 02:07:32 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [GIT] HID patches for 2.6.28
Message-ID: <alpine.LNX.1.10.0810140055060.26779@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive 2.6.28 patches for the HID (the HIDeously slow devices, you 
know) code.

The most notable change is a conversion of the whole HID core code into 
bus, and conversion of all the quirks to specialized separate drivers.  
Over past years, the quirks have been added in order to support broken 
devices (not complying with HID standard) all over the code, and turned it 
into total unmaintainable mess. The HID bus provides easy means for 
drivers for quirky devices to use as much of the common code as possible, 
and allows for re-implementing only the quirky part.


 Documentation/feature-removal-schedule.txt  |    7 +
 drivers/hid/Kconfig                         |  195 +++++
 drivers/hid/Makefile                        |   34 +-
 drivers/hid/hid-a4tech.c                    |  162 ++++
 drivers/hid/hid-apple.c                     |  484 +++++++++++
 drivers/hid/hid-belkin.c                    |  105 +++
 drivers/hid/hid-cherry.c                    |   87 ++
 drivers/hid/hid-chicony.c                   |   80 ++
 drivers/hid/hid-core.c                      | 1177 +++++++++++++++++++++------
 drivers/hid/hid-cypress.c                   |  158 ++++
 drivers/hid/hid-dell.c                      |   74 ++
 drivers/hid/hid-dummy.c                     |   69 ++
 drivers/hid/hid-ezkey.c                     |   95 +++
 drivers/hid/hid-gyration.c                  |   96 +++
 drivers/hid/hid-ids.h                       |  397 +++++++++
 drivers/hid/hid-input-quirks.c              |  484 -----------
 drivers/hid/hid-input.c                     |  915 ++++++++--------------
 drivers/hid/hid-lg.c                        |  342 ++++++++
 drivers/hid/hid-lg.h                        |   18 +
 drivers/hid/{usbhid => }/hid-lg2ff.c        |   14 +-
 drivers/hid/{usbhid => }/hid-lgff.c         |   34 +-
 drivers/hid/hid-microsoft.c                 |  219 +++++
 drivers/hid/hid-monterey.c                  |   82 ++
 drivers/hid/hid-petalynx.c                  |  122 +++
 drivers/hid/{usbhid/hid-plff.c => hid-pl.c} |   83 ++-
 drivers/hid/hid-samsung.c                   |  100 +++
 drivers/hid/hid-sony.c                      |  110 +++
 drivers/hid/hid-sunplus.c                   |   82 ++
 drivers/hid/{usbhid => }/hid-tmff.c         |  138 ++--
 drivers/hid/{usbhid => }/hid-zpff.c         |   71 ++-
 drivers/hid/hidraw.c                        |    8 +-
 drivers/hid/usbhid/Kconfig                  |   75 --
 drivers/hid/usbhid/Makefile                 |   18 -
 drivers/hid/usbhid/hid-core.c               |  463 ++++++------
 drivers/hid/usbhid/hid-ff.c                 |   95 ---
 drivers/hid/usbhid/hid-pidff.c              |    5 +-
 drivers/hid/usbhid/hid-quirks.c             |  934 +---------------------
 drivers/hid/usbhid/hiddev.c                 |   20 +-
 drivers/hid/usbhid/usbhid.h                 |    4 +-
 drivers/hid/usbhid/usbkbd.c                 |   12 +-
 drivers/hid/usbhid/usbmouse.c               |    8 +-
 include/linux/hid.h                         |  373 +++++++--
 include/linux/hiddev.h                      |   46 +-
 include/linux/mod_devicetable.h             |   10 +
 net/bluetooth/hidp/core.c                   |  214 +++--
 net/bluetooth/hidp/hidp.h                   |    2 +
 scripts/mod/file2alias.c                    |   18 +
 47 files changed, 5390 insertions(+), 2949 deletions(-)

Alex Chiang (1):
      HID: fix grammo in HID_COMPAT Kconfig help text

Anssi Hannula (1):
      HID: fix a lockup regression when using force feedback on a PID device

Antonio Ospite (2):
      HID: hiddev.h: Fix mixed space and tabs in example code.
      HID: hiddev.h: Fix example code.

Greg Kroah-Hartman (2):
      HID: remove info() macro from usb HID drivers
      HID: remove warn() macro from usb hid drivers

Harvey Harrison (1):
      HID: make compat functions static

Jiri Kosina (3):
      HID: introduce list for hiddev creation forcing
      HID: add support for Super Dual Box Pro USB PS2/PS2 adapter
      HID: fix incorrent length condition in hidraw_write()

Jiri Slaby (35):
      modpost: add support for hid
      HID: make a bus from hid code
      HID: hid, make parsing event driven
      HID: move ids into separate file
      HID: move usage input mapping to hid.h
      HID: move logitech quirks
      HID: move ignore quirks
      HID: move apple quirks
      HID: add compat support
      HID: indent switches/cases
      HID: move microsoft quirks
      HID: move sunplus quirks
      HID: move cypress quirks
      HID: move a4tech quirks
      HID: move cherry quirks
      HID: move ezkey quirks
      HID: move chicony quirks
      HID: move belkin quirks
      HID: move petalynx quirks
      HID: move monterey quirks
      HID: move gyration quirks
      HID: move samsung quirks
      HID: remove hid-input-quirks
      HID: remove rdesc quirk support
      HID: move sony quirks
      HID: move dell quirks
      HID: move connect quirks
      HID: move reset leds quirk
      HID: move logitech FF processing
      HID: fix tty<->hid deadlock
      HID: move pantherlord FF processing
      HID: move thrustmaster FF processing
      HID: move zeroplus FF processing
      HID: remove hid-ff
      HID: convert to dev_* prints

Peter Korsgaard (1):
      HID: add appletv IR receiver quirk

Randy Dunlap (1):
      HID: fix gyration build error

Remi Cattiau (1):
      HID: ignore iBuddy devices

Richard Hughes (1):
      HID: remove ignore quirk for MGE UPS devices

Sergey Belyashov (1):
      HID: Autocentering support for Logitech MOMO Racing Wheel

Tomoya Adachi (1):
      HID: report descriptor fix for remaining MacBook JIS keyboards

