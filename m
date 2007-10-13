Return-Path: <linux-kernel-owner+w=401wt.eu-S1762356AbXJMUOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762356AbXJMUOt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 16:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXJMUOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 16:14:41 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:36627 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbXJMUOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 16:14:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=bT77k6/W/U6qVC9Koyu1NjoAjcRQTAiW2ws53k3BGpBPRwJr5Yk5s35i2kJM66D5+f/KctTNeu59cuqHyD4y61KYak5kJrRgB96jiuYOmZh5UKvvJY3IJoWUYKaHV/cY1Woe6P2qY+dT+Q6Odc7TbYx/P+Mv+R9/djE0n+N44aE=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Input updates for 2.6.24-rc0
Date: Sat, 13 Oct 2007 16:14:35 -0400
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710131614.35356.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get a bunch
new drivers, fixes for existing ones and also input core will
finally have proper locking.

Changelog:
---------

Adrian McMenamin (1):
      Input: add support for SEGA Dreamcast keyboard

Alon Ziv (1):
      Input: psmouse - reset harder during probe

Andreas Herrmann (1):
      Input: auto-select INPUT for MAC_EMUMOUSEBTN option

Andrew McNabb (1):
      Input: adbhid - produce all CapsLock key events

Andrew Morton (1):
      Input: iforce - de-dosify iforce-protocol.txt

Anti Sullin (2):
      Input: gpio_keys - verify that supplied GPIO numbers are valid
      Input: gpio-keys - add suspend/resume support

Daniel Ritz (1):
      Input: usbtouchscreen - support DMC devices with empty EEPROM

Dmitry Torokhov (18):
      Input: xpad - use le16_to_cpup when parsing data stream
      Input: mark some functions __must_check
      Input: implement proper locking in input core
      Input: evdev - implement proper locking
      Input: mousedev - implement proper locking
      Input: joydev - implement proper locking
      Input: tsdev - implement proper locking
      Input: remove ec3104_keyb driver
      Input: lifebook - add signature of Panasonic CF-72
      HWMON: applesmc - convert to use input-polldev
      HWMON: ams - convert to use input-polldev
      Input: xpad - fix dependancy on LEDS class
      Input: jornada720_kbd - send MSC_SCAN events
      Input: ALPS - add signature for ThinkPad R61
      Input: lifebook - fix X and Y axis range
      Input: omap-keyboard - don't pretend we support changing keymap
      HWMON: hdaps - switch to using input-polldev
      Input: use full RCU API

Ilya Frolov (1):
      Input: usbtouchscreen - add support for GeneralTouch devices

Kristoffer Ericson (3):
      Input: add support for HP Jornada onboard keyboard (HP6XX)
      Input: add support for HP Jornada 7xx onboard keyboard
      Input: add support for the HP Jornada 7xx (710/720/728) touchscreen

Markus Armbruster (1):
      Input: i8042 - restore control register when enabling port fails

Michael Hennerich (1):
      Input: add support for Blackfin BF54x Keypad controller

Oliver Neukum (1):
      Input: fix open count handling in input interfaces

Ondrej Zary (1):
      Input: usbtouchscreen - add support for IdealTEK URTC1000

Rene Herman (1):
      Input: ucb1400_ts - use schedule_timeout_uninterruptible

Richard Purdie (1):
      Input: remove tsdev interface

Samuel Thibault (1):
      Input: keyboard - add CapsShift lock

Soeren Sonnenburg (1):
      Input: appletouch - another fix for idle reset logic

Stephen Hemminger (1):
      Input: polled device power saving

William Pettersson (1):
      Input: ALPS - add support for model found in Dell Vostro 1400

Diffstat:
--------
 Documentation/feature-removal-schedule.txt   |   14 -
 Documentation/kernel-parameters.txt          |    3 -
 arch/blackfin/mach-bf548/boards/ezkit.c      |    6 +-
 drivers/char/ec3104_keyb.c                   |  457 ----------------
 drivers/hwmon/Kconfig                        |    3 +
 drivers/hwmon/ams/ams-input.c                |   76 ++--
 drivers/hwmon/ams/ams.h                      |    5 +-
 drivers/hwmon/applesmc.c                     |   83 +--
 drivers/hwmon/hdaps.c                        |   55 +--
 drivers/input/Kconfig                        |   22 -
 drivers/input/Makefile                       |    1 -
 drivers/input/evdev.c                        |  708 ++++++++++++++++--------
 drivers/input/input-polldev.c                |    7 +-
 drivers/input/input.c                        |  660 +++++++++++++++++------
 drivers/input/joydev.c                       |  743 +++++++++++++++++---------
 drivers/input/joystick/xpad.c                |   55 ++-
 drivers/input/keyboard/Kconfig               |   40 ++
 drivers/input/keyboard/Makefile              |    5 +-
 drivers/input/keyboard/bf54x-keys.c          |  382 +++++++++++++
 drivers/input/keyboard/gpio_keys.c           |   81 +++-
 drivers/input/keyboard/jornada680_kbd.c      |  277 ++++++++++
 drivers/input/keyboard/jornada720_kbd.c      |  185 +++++++
 drivers/input/keyboard/maple_keyb.c          |  252 +++++++++
 drivers/input/keyboard/omap-keypad.c         |   22 +-
 drivers/input/mouse/alps.c                   |    2 +
 drivers/input/mouse/appletouch.c             |   15 +-
 drivers/input/mouse/lifebook.c               |   10 +-
 drivers/input/mouse/psmouse-base.c           |    5 +-
 drivers/input/mousedev.c                     |  740 ++++++++++++++++----------
 drivers/input/serio/i8042.c                  |    4 +
 drivers/input/touchscreen/Kconfig            |   21 +
 drivers/input/touchscreen/Makefile           |    1 +
 drivers/input/touchscreen/jornada720_ts.c    |  182 +++++++
 drivers/input/touchscreen/ucb1400_ts.c       |    3 +-
 drivers/input/touchscreen/usbtouchscreen.c   |   93 ++++-
 drivers/input/tsdev.c                        |  533 ------------------
 drivers/macintosh/Kconfig                    |    1 +
 drivers/macintosh/adbhid.c                   |   58 ++-
 include/asm-blackfin/mach-bf548/bf54x_keys.h |   17 +
 include/linux/gpio_keys.h                    |    1 +
 include/linux/input.h                        |  116 ++++-
 include/linux/keyboard.h                     |    4 +-
 42 files changed, 3774 insertions(+), 2174 deletions(-)
 delete mode 100644 drivers/char/ec3104_keyb.c
 create mode 100644 drivers/input/keyboard/bf54x-keys.c
 create mode 100644 drivers/input/keyboard/jornada680_kbd.c
 create mode 100644 drivers/input/keyboard/jornada720_kbd.c
 create mode 100644 drivers/input/keyboard/maple_keyb.c
 create mode 100644 drivers/input/touchscreen/jornada720_ts.c
 delete mode 100644 drivers/input/tsdev.c
 create mode 100644 include/asm-blackfin/mach-bf548/bf54x_keys.h

-- 
Dmitry
