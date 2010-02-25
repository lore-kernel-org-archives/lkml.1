Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab0BYQnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:43:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:40069 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932906Ab0BYQni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:43:38 -0500
Date: Thu, 25 Feb 2010 17:43:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1002251733480.30967@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive HID updates for 2.6.34 merge window. Apart from usual pile of 
fixes to various drivers and for various devices, most notably we have 
completely new drivers for bleeding-edge multitouch devices, written by 
Stephane Chatty.

I know that I am sending this pull request very early and not waiting a 
couple of days, but I will be unavailable for the whole next week and I'd 
rather not miss the merge window which now apparently has unpredictable 
size :)

Thanks!

Alex Neblett (1):
      HID: add support for Pixart Imaging Optical Touch Screen

Alexander Shishkin (1):
      HID: add NOGET quirk for Prodige Cordless Combo

Bastien Nocera (3):
      HID: Implement Wacom quirk in the kernel
      HID: Enable Sixaxis controller over Bluetooth
      HID: fix typo in error message

Gary Stein (1):
      HID: add driver for the Logitech Flight System G940

H Hartley Sweeten (1):
      HID: hid-debug.c: make local symbols static

Jiri Kosina (13):
      HID: make 3M PCT touchscreen driver standalone config option
      HID: make Stantum driver standalone config option
      HID: handle joysticks with large number of buttons
      HID: fix parsing of local delimiter with size 0
      HID: remove TENX iBuddy from blacklist
      HID: update copyright
      HID: make raw reports possible for both feature and output reports
      HID: make Wacom modesetting failures non-fatal
      HID: make full-fledged hid-bus drivers properly selectable
      HID: fix up Kconfig entry for MagicMouse
      HID: remove MODULE_VERSION from new drivers
      HID: extend mask for BUTTON usage page
      HID: usbhid: initialize interface pointers early enough

Johnathon Harris (1):
      HID: add support for Ortek WKB-2000

Leo P White (1):
      HID: add mapping for "AL Network Chat" usage

Michael Poole (3):
      HID: Export hid_register_report
      HID: add a device driver for the Apple Magic Mouse.
      HID: magicmouse: coding style and probe failure fixes

Márton Németh (1):
      HID: make USB device id constant

Oliver Neukum (1):
      HID: usbhid: introduce timeout for stuck ctrl/out URBs

Rafi Rubin (4):
      HID: hid-ntrig add multi input quirk and clean up
      HID: n-trig: remove unnecessary tool switching
      HID: hid-ntrig: multitouch cleanup and fix
      HID: hid-ntrig: Single touch mode tap

Stefan Glasenhardt (1):
      HID: allow disabling hard-coded ISO-layout for Apple keyboards

Stephane Chatty (7):
      HID: Support for 3M multitouch panel
      HID: add support for Stantum multitouch panel
      HID: add support for Acer T230H multitouch
      HID: let hid-input accept digitizers
      HID: fixed bug in single-touch emulation on the stantum panel
      HID: add pressure support for the Stantum multitouch panel
      HID: Support for MosArt multitouch panel

Thadeu Lima de Souza Cascardo (2):
      HID: use multi input quirk for eTurboTouch touchscreen
      HID: use multi input quirk for TouchPack touchscreen

 drivers/hid/Kconfig             |   54 +++++-
 drivers/hid/Makefile            |    9 +
 drivers/hid/hid-3m-pct.c        |  290 +++++++++++++++++++++++++
 drivers/hid/hid-apple.c         |   17 +-
 drivers/hid/hid-core.c          |   23 ++-
 drivers/hid/hid-debug.c         |    6 +-
 drivers/hid/hid-ids.h           |   37 +++-
 drivers/hid/hid-input.c         |   12 +-
 drivers/hid/hid-lg.c            |    7 +-
 drivers/hid/hid-lg.h            |    6 +
 drivers/hid/hid-lg3ff.c         |  176 +++++++++++++++
 drivers/hid/hid-lgff.c          |    1 +
 drivers/hid/hid-magicmouse.c    |  449 +++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-mosart.c        |  273 ++++++++++++++++++++++++
 drivers/hid/hid-ntrig.c         |  212 +++++++++++++------
 drivers/hid/hid-ortek.c         |   56 +++++
 drivers/hid/hid-quanta.c        |  260 ++++++++++++++++++++++
 drivers/hid/hid-sony.c          |   23 ++-
 drivers/hid/hid-stantum.c       |  283 ++++++++++++++++++++++++
 drivers/hid/hid-wacom.c         |   28 +++
 drivers/hid/hidraw.c            |    2 +-
 drivers/hid/usbhid/hid-core.c   |   42 +++-
 drivers/hid/usbhid/hid-quirks.c |    3 +
 drivers/hid/usbhid/usbhid.h     |    2 +
 include/linux/hid.h             |    5 +-
 include/linux/input.h           |   42 ++++
 net/bluetooth/hidp/core.c       |   17 ++-
 27 files changed, 2222 insertions(+), 113 deletions(-)
 create mode 100644 drivers/hid/hid-3m-pct.c
 create mode 100644 drivers/hid/hid-lg3ff.c
 create mode 100644 drivers/hid/hid-magicmouse.c
 create mode 100644 drivers/hid/hid-mosart.c
 create mode 100644 drivers/hid/hid-ortek.c
 create mode 100644 drivers/hid/hid-quanta.c
 create mode 100644 drivers/hid/hid-stantum.c
