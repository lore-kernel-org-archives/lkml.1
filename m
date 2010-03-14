Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0CNHbL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 03:31:11 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54200 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab0CNHbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 03:31:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=P3pMT8uy0lwFsTsVigPChf2dv2hlbROkLwEUUUoLOMIM65Y7XYS2mNn9+EtAAY03Iz
         USaFy2VmLNwgJGh+GifdMYgHLQrqVqCcrtfu5gsxEW4ZgoY0fWupIXcPPcn1Si/tytfK
         ngv2zr9CRwlLgSPOhsbgsfwSPm/9/w1KojcJU=
Date: Sat, 13 Mar 2010 23:31:01 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.34-rc1
Message-ID: <20100314073101.GA27018@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Alan Stern (1):
      Input: enable remote wakeup for PNP i8042 keyboard ports

Arnd Bergmann (1):
      Input: remove BKL, fix input_open_file() locking

Christoph Fritz (1):
      Input: i8042 - add ALDI/MEDION netbook E1222 to qurik reset table

Dan Carpenter (1):
      Input: gamecon - fix off by one range check

Dmitry Torokhov (2):
      Input: i8042 - use platfrom_create_bundle() helper
      Input: scancode in get/set_keycodes should be unsigned

Jari Vanhala (1):
      Input: add driver for TWL4030 vibrator device

Mark Brown (1):
      Input: wm831x-on - convert to use genirq

Martin Buck (1):
      Input: ALPS - fix stuck buttons on some touchpads

Michael Hennerich (2):
      Input: ads7846 - add support for AD7843 parts
      Input: ad7877 - increase pen up imeout

Mike Frysinger (1):
      Input: bf54x-keys - fix system hang when pressing a key

Ping Cheng (2):
      Input: wacom - replace WACOM_PKGLEN_PENABLED
      Input: wacom - merge out and in prox events

Ranjith Lohithakshan (1):
      Input: ads7846 - add wakeup support

Thadeu Lima de Souza Cascardo (2):
      Input: mousedev - remove BKL
      Input: serio_raw - remove BKL

Thomas Bächler (1):
      Input: alps - add support for the touchpad on Toshiba Tecra A11-11L

Vadim Zaliva (1):
      Input: appletouch - fix integer overflow issue


Diffstat:
--------

 drivers/hid/hid-input.c                    |   24 ++--
 drivers/input/evdev.c                      |    2 +-
 drivers/input/input.c                      |   38 ++--
 drivers/input/joystick/gamecon.c           |    2 +-
 drivers/input/keyboard/bf54x-keys.c        |    2 +-
 drivers/input/misc/Kconfig                 |   11 +
 drivers/input/misc/Makefile                |    1 +
 drivers/input/misc/ati_remote2.c           |   14 +-
 drivers/input/misc/twl4030-vibra.c         |  297 ++++++++++++++++++++++++++++
 drivers/input/misc/winbond-cir.c           |   12 +-
 drivers/input/misc/wm831x-on.c             |    9 +-
 drivers/input/mouse/alps.c                 |   57 +++----
 drivers/input/mouse/appletouch.c           |    6 +-
 drivers/input/mousedev.c                   |    6 -
 drivers/input/serio/i8042-x86ia64io.h      |   10 +
 drivers/input/serio/i8042.c                |   24 +--
 drivers/input/serio/serio_raw.c            |   11 +-
 drivers/input/sparse-keymap.c              |    6 +-
 drivers/input/tablet/wacom_sys.c           |    4 +-
 drivers/input/tablet/wacom_wac.c           |  165 ++++++----------
 drivers/input/tablet/wacom_wac.h           |    1 -
 drivers/input/touchscreen/Kconfig          |    9 +-
 drivers/input/touchscreen/ad7877.c         |    2 +-
 drivers/input/touchscreen/ads7846.c        |   20 ++
 drivers/media/IR/ir-keytable.c             |    4 +-
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c |    4 +-
 drivers/platform/x86/dell-wmi.c            |   16 +-
 drivers/platform/x86/hp-wmi.c              |   15 +-
 drivers/platform/x86/panasonic-laptop.c    |   15 +-
 drivers/platform/x86/topstar-laptop.c      |   13 +-
 drivers/platform/x86/toshiba_acpi.c        |   17 +-
 include/linux/input.h                      |   20 ++-
 include/linux/spi/ads7846.h                |    3 +-
 33 files changed, 553 insertions(+), 287 deletions(-)
 create mode 100644 drivers/input/misc/twl4030-vibra.c

-- 
Dmitry

