Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbYDUNS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbYDUNS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757077AbYDUNSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:18:41 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:35324 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965AbYDUNSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:18:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:date:subject:cc;
        b=D4jkHXDtlIzV6Wc9BJNPv9hDjagXrEajsdLsVKUT1cToauGEEN/xLoupHZ7vtUdWdnY4x/iBfXVbARFc92WiClIYT5kO2IB9wHZML29zuLKnEam+E1XhwDe3kckh5DswVahFRo0yIMv7SVceth1bmqTrKvFM61pPdsfzomC4yM8=
Message-Id: <cover.1208783694.git.dmitry.torokhov@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Mon, 21 Apr 2008 09:14:54 -0400
Subject: [PATCH 00/37] Input queue for 2.6.26 merge window
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches are what I would like to get in 2.6.26
in the next couple of days. Please shout if you see any problems.

Thanks.

-- 
Dmitry

Anssi Hannula (7):
  Input: xpad - match xbox 360 devices with interface info
  Input: xpad - fix dpad handling of unknown devices
  Input: xpad - fix inverted Y and RY axes
  Input: xpad - add more xbox 360 controller ids
  Input: xpad - do not report nonexistent buttons for xbox360
  Input: xpad - enable force feedback on xbox 360 controllers only
  Input: xpad - drop obsolete driver versioning

Brian Magnuson (1):
  Input: xpad - add support for wireless xbox360 controllers

David Brownell (3):
  Input: ads7846 - simplify support of external vREF (and ads7843)
  Input: gpio_keys - irq handling cleanup
  Input: omap-keypad - fix build warning

Dmitry Baryshkov (1):
  Input: tosakbd - fix suspend

Dmitry Torokhov (1):
  Input: remove private member from input_dev structure

Guryanov Dmitry (1):
  Input: aiptek - add support for Genius G-PEN 560 tablet

Hans-Christian Egtvedt (1):
  Input: add PS/2 serio driver for AVR32 devices

Helge Deller (1):
  Input: locomokbd - add 'off' button support for Sharp Collie/Poodle

Jiri Kosina (1):
  Input: fix ordering in joystick Makefile

Julia Lawall (1):
  Input: drivers/char/keyboard.c - use time_after

Karl Dahlke (1):
  Input: put ledstate in the keyboard notifier

Kay Sievers (1):
  Input: add MODULE_ALIAS() to hotpluggable platform modules

Mark Brown (8):
  Input: add support for WM97xx familty touchscreens
  Input: WM97xx - add chip driver for WM9705 touchscreen
  Input: WM97xx - add chip driver for WM9712 touchscreen
  Input: WM97xx - add chip driver for WM97123 touchscreen
  Input: WM97xx - add support for streaming mode on Mainstone
  Input: wm97xx-core - only schedule interrupt handler if not already
    scheduled
  Input: wm97xx-core - use IRQF_SAMPLE_RANDOM
  Input: wm97xx-core - support use as a wakeup source

Martin Kebert (1):
  Input: add Zhen Hua driver

Michael Gruber (1):
  Input: xpad - set proper buffer length for outgoing requests

Michael Hennerich (1):
  Input: bf54x-keys - add infrastructure for keypad wakeups

Oliver Neukum (3):
  Input: xpad - don't use GFP_ATOMIC
  Input: usbtouchscreen - don't use DMA on stack
  Input: wacom - implement suspend and autosuspend

Peter Zijlstra (1):
  Input: mac_hid - add lockdep annotation to emumousebtn

Roel Kluin (1):
  Input: i8042 - fix incorrect usage of strncpy and strncat

Tobias Mueller (1):
  Input: appletouch - add product IDs for the 4th generation MacBooks

 MAINTAINERS                                  |   10 +
 drivers/char/keyboard.c                      |    6 +-
 drivers/hid/usbhid/hid-quirks.c              |    4 +
 drivers/input/input-polldev.c                |    6 +-
 drivers/input/joystick/Kconfig               |   12 +
 drivers/input/joystick/Makefile              |    4 +-
 drivers/input/joystick/xpad.c                |  213 ++++++-
 drivers/input/joystick/zhenhua.c             |  243 ++++++++
 drivers/input/keyboard/aaed2000_kbd.c        |    4 +
 drivers/input/keyboard/bf54x-keys.c          |   37 +-
 drivers/input/keyboard/corgikbd.c            |    2 +
 drivers/input/keyboard/gpio_keys.c           |    5 +-
 drivers/input/keyboard/jornada680_kbd.c      |    2 +
 drivers/input/keyboard/jornada720_kbd.c      |    4 +
 drivers/input/keyboard/locomokbd.c           |   73 ++-
 drivers/input/keyboard/omap-keypad.c         |    9 +-
 drivers/input/keyboard/pxa27x_keypad.c       |    4 +
 drivers/input/keyboard/spitzkbd.c            |    1 +
 drivers/input/keyboard/tosakbd.c             |   23 +-
 drivers/input/misc/cobalt_btns.c             |    3 +
 drivers/input/mouse/appletouch.c             |   13 +-
 drivers/input/mouse/gpio_mouse.c             |    4 +
 drivers/input/serio/Kconfig                  |   10 +
 drivers/input/serio/Makefile                 |    1 +
 drivers/input/serio/at32psif.c               |  375 ++++++++++++
 drivers/input/serio/i8042-x86ia64io.h        |   12 +-
 drivers/input/serio/rpckbd.c                 |    2 +
 drivers/input/tablet/Kconfig                 |   10 +-
 drivers/input/tablet/aiptek.c                |    2 +
 drivers/input/tablet/wacom.h                 |    3 +
 drivers/input/tablet/wacom_sys.c             |   76 ++-
 drivers/input/touchscreen/Kconfig            |   53 ++
 drivers/input/touchscreen/Makefile           |    7 +
 drivers/input/touchscreen/ads7846.c          |   22 +-
 drivers/input/touchscreen/corgi_ts.c         |    2 +
 drivers/input/touchscreen/jornada720_ts.c    |    4 +
 drivers/input/touchscreen/mainstone-wm97xx.c |  302 ++++++++++
 drivers/input/touchscreen/usbtouchscreen.c   |   31 +-
 drivers/input/touchscreen/wm9705.c           |  353 +++++++++++
 drivers/input/touchscreen/wm9712.c           |  462 ++++++++++++++
 drivers/input/touchscreen/wm9713.c           |  460 ++++++++++++++
 drivers/input/touchscreen/wm97xx-core.c      |  829 ++++++++++++++++++++++++++
 drivers/macintosh/mac_hid.c                  |    6 +
 include/linux/input.h                        |    8 +-
 include/linux/keyboard.h                     |    1 +
 include/linux/serio.h                        |    1 +
 include/linux/spi/ads7846.h                  |    3 +-
 include/linux/wm97xx.h                       |  314 ++++++++++
 48 files changed, 3915 insertions(+), 116 deletions(-)
 create mode 100644 drivers/input/joystick/zhenhua.c
 create mode 100644 drivers/input/serio/at32psif.c
 create mode 100644 drivers/input/touchscreen/mainstone-wm97xx.c
 create mode 100644 drivers/input/touchscreen/wm9705.c
 create mode 100644 drivers/input/touchscreen/wm9712.c
 create mode 100644 drivers/input/touchscreen/wm9713.c
 create mode 100644 drivers/input/touchscreen/wm97xx-core.c
 create mode 100644 include/linux/wm97xx.h

