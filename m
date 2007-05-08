Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbXEHFqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbXEHFqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 01:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967933AbXEHFqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 01:46:17 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:38511 "EHLO
	asav04.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbXEHFqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 01:46:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CALCrP0ZKhRO4W2dsb2JhbACBXI4VHQ0GEA
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] More input updates for post-2.6.21
Date: Tue, 8 May 2007 01:46:14 -0400
User-Agent: KMail/1.9.3
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705080146.14911.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling from:

        git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git

or
        master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git

to receive more updates for input subsystem. You will get yet another
fix for i8042 AUX detection, bunch of sparse warnings fixed and
USB input devices moved into drivers/input to keep all input devices
together in menuconfig and friends.

Dmitry Torokhov (12):
      Input: force feedback - make sure effect is present before playing
      Input: drivers/joystick - fix various sparse warnings
      Input: evdev - fix some sparse warnings (signedness, shadowing)
      Input: drivers/usb/input - fix sparse warnings (signedness)
      Input: synaptics - don't complain about failed resets
      Input: drivers/usb/input - usb_buffer_free() cleanup
      Input: aaed2000_kbd - convert to use polldev library
      Input: move USB tablets under drivers/input/tablet
      Input: move USB touchscreens under drivers/input/touchscreen
      Input: move USB gamepads under drivers/input/joystick
      Input: move USB mice under drivers/input/mouse
      Input: move USB miscellaneous devices under drivers/input/misc

Mike Frysinger (1):
      Input: pull input.h into uinpit.h

Roland Scheidegger (1):
      Input: i8042 - fix AUX port detection with some chips

 drivers/input/Kconfig                              |    2 +
 drivers/input/Makefile                             |    1 +
 drivers/input/evdev.c                              |    6 +-
 drivers/input/ff-core.c                            |    3 +-
 drivers/input/joystick/Kconfig                     |   18 ++-
 drivers/input/joystick/Makefile                    |    1 +
 drivers/input/joystick/analog.c                    |    2 +-
 drivers/input/joystick/db9.c                       |   18 +-
 drivers/input/joystick/gamecon.c                   |   17 +-
 drivers/input/joystick/iforce/iforce.h             |    2 +-
 drivers/input/joystick/turbografx.c                |   18 +-
 drivers/{usb/input => input/joystick}/xpad.c       |    0 
 drivers/input/keyboard/Kconfig                     |    1 +
 drivers/input/keyboard/aaed2000_kbd.c              |   62 ++----
 drivers/input/misc/Kconfig                         |   88 +++++++-
 drivers/input/misc/Makefile                        |    9 +-
 drivers/{usb/input => input/misc}/ati_remote.c     |    0 
 drivers/{usb/input => input/misc}/ati_remote2.c    |    4 +-
 drivers/{usb/input => input/misc}/keyspan_remote.c |    0 
 .../{usb/input => input/misc}/map_to_7segment.h    |    0 
 drivers/{usb/input => input/misc}/powermate.c      |   10 +-
 drivers/input/misc/uinput.c                        |    1 -
 drivers/{usb/input => input/misc}/yealink.c        |   25 +--
 drivers/{usb/input => input/misc}/yealink.h        |    0 
 drivers/input/mouse/Kconfig                        |   38 +++-
 drivers/input/mouse/Makefile                       |    1 +
 drivers/{usb/input => input/mouse}/appletouch.c    |    0 
 drivers/input/mouse/synaptics.c                    |    2 +-
 drivers/input/serio/i8042.c                        |   35 +++-
 drivers/input/tablet/Kconfig                       |   74 +++++++
 drivers/input/tablet/Makefile                      |   12 +
 drivers/{usb/input => input/tablet}/acecad.c       |    2 +-
 drivers/{usb/input => input/tablet}/aiptek.c       |    0 
 drivers/{usb/input => input/tablet}/gtco.c         |    0 
 drivers/{usb/input => input/tablet}/kbtab.c        |    2 +-
 drivers/{usb/input => input/tablet}/wacom.h        |    2 +-
 drivers/{usb/input => input/tablet}/wacom_sys.c    |    2 +-
 drivers/{usb/input => input/tablet}/wacom_wac.c    |    2 +-
 drivers/{usb/input => input/tablet}/wacom_wac.h    |    4 +-
 drivers/input/touchscreen/Kconfig                  |   60 +++++-
 drivers/input/touchscreen/Makefile                 |   17 +-
 .../input => input/touchscreen}/usbtouchscreen.c   |    5 +-
 drivers/usb/Kconfig                                |    2 -
 drivers/usb/Makefile                               |    9 -
 drivers/usb/input/Kconfig                          |  225 --------------------
 drivers/usb/input/Makefile                         |   24 --
 include/linux/uinput.h                             |    2 +
 47 files changed, 404 insertions(+), 404 deletions(-)
 rename drivers/{usb/input => input/joystick}/xpad.c (100%)
 rename drivers/{usb/input => input/misc}/ati_remote.c (100%)
 rename drivers/{usb/input => input/misc}/ati_remote2.c (99%)
 rename drivers/{usb/input => input/misc}/keyspan_remote.c (100%)
 rename drivers/{usb/input => input/misc}/map_to_7segment.h (100%)
 rename drivers/{usb/input => input/misc}/powermate.c (99%)
 rename drivers/{usb/input => input/misc}/yealink.c (98%)
 rename drivers/{usb/input => input/misc}/yealink.h (100%)
 rename drivers/{usb/input => input/mouse}/appletouch.c (100%)
 create mode 100644 drivers/input/tablet/Kconfig
 create mode 100644 drivers/input/tablet/Makefile
 rename drivers/{usb/input => input/tablet}/acecad.c (100%)
 rename drivers/{usb/input => input/tablet}/aiptek.c (100%)
 rename drivers/{usb/input => input/tablet}/gtco.c (100%)
 rename drivers/{usb/input => input/tablet}/kbtab.c (100%)
 rename drivers/{usb/input => input/tablet}/wacom.h (99%)
 rename drivers/{usb/input => input/tablet}/wacom_sys.c (100%)
 rename drivers/{usb/input => input/tablet}/wacom_wac.c (100%)
 rename drivers/{usb/input => input/tablet}/wacom_wac.h (93%)
 rename drivers/{usb/input => input/touchscreen}/usbtouchscreen.c (99%)
 delete mode 100644 drivers/usb/input/Kconfig
 delete mode 100644 drivers/usb/input/Makefile

-- 
Dmitry
