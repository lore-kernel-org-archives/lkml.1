Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbZFTGKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbZFTGKf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 02:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZFTGK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 02:10:28 -0400
Received: from mail-px0-f202.google.com ([209.85.216.202]:42728 "EHLO
	mail-px0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZFTGK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 02:10:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=KKOtJkR63roU2zM8eOvhH/vTQUNefgNUUmOP08aFBAZZBqi78Up7L/Gohdax7z6m0K
         sos0nwIV9UTUPduSwGHRUxLO0mwQ3dJbZinpuN7HxodPCORGExaAP7/HK2h2LaqcXYLo
         nZdnDcvIfPdNs+myNCZWgtE8bTruy5voa0ryc=
Date: Fri, 19 Jun 2009 23:10:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.31-rc0
Message-ID: <20090620061024.GB7710@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. There are a couple of
drivers that did not make into this pull request (gpio matrix in
particular), I intend to submit it in -rc1. I so hope I won't be moving
again for a while...

Changelog:
---------

Alek Du (1):
      Input: gpio-keys - change timer to workqueue

Aristeu Sergio Rozanski Filho (1):
      Input: uinput - flush all pending ff effects before destroying device

Daniel Mack (1):
      Input: add driver for EETI touchpanels

David Brownell (1):
      Input: add dm355evm_keys driver

Dmitry Torokhov (9):
      Input: gtco - add MODULE_DESCRIPTION()
      Input: fp801-gp - add MODULE_DESCRIPTION()
      Input: gameport - rearrange EXPORT_SYMBOL() markings
      Input: serio - rearrange EXPORT_SYMBOL() markings
      Input: gpio-keys - remove depreciated IRQF_SAMPLE_RANDOM flag
      Input: keyboard - remove warning about raw mode not supported
      Input: ALPS - Dell Latitude D630/D800 have DualPoint
      Input: lifebook - don't send incomplete events
      Input: serio - do not use deprecated dev.power.power_state

Felipe Balbi (2):
      Input: add twl4030-pwrbutton driver
      Input: introduce lm8323 keypad driver
w
Greg Kroah-Hartman (1):
      Input: wm97xx - do not access dev->driver_data directly

H Hartley Sweeten (2):
      Input: rotary_encoder - add support for REL_* axes
      Input: add matrix keypad driver for Cirrus EP93xx

Hans-Christian Egtvedt (1):
      Input: add wm97xx accelerated driver for Atmel microprocessors

Jeremy Huddleston (1):
      Input: appletouch - improve finger detection

Kwangwoo Lee (1):
      Input: tsc2007 - make sure platform provides get_pendown_state()

Michael Roth (3):
      Input: ads7846 - support swapping x and y axes
      Input: ads7846 - more detailed model name in sysfs
      Input: ads7846 - pin change interrupt support

Mike Rapoport (1):
      Input: add driver for Synaptics I2C touchpad

Ping Cheng (2):
      Input: wacom - add support for Intuos4 tablets
      Input: wacom - clear Intuos4 wheel data when finger leaves proximity

Sebastian Andrzej Siewior (1):
      Input: ucb1400 - move static function from header into core

Tero Saarni (1):
      Input: synaptics - add support for reporting x/y resolution

Thadeu Lima de Souza Cascardo (2):
      Input: fix typo in documentation
      Input: simplify name handling for certain input handles

Ulrich Dangel (1):
      Input: ALPS - handle touchpoints buttons correctly

Ville Syrjala (1):
      Input: ati_remote2 - use non-atomic bitops

Wan ZongShun (1):
      Input: add support for touchscreen on W90P910 ARM platform

Zephaniah E. Hull (1):
      Input: psmouse - ESD workaround fix for OLPC XO touchpad


Diffstat:
--------

 Documentation/input/input.txt                     |    2 +-
 Documentation/input/rotary-encoder.txt            |    9 +-
 arch/arm/mach-ep93xx/include/mach/ep93xx_keypad.h |   42 +
 drivers/char/keyboard.c                           |    2 -
 drivers/input/evdev.c                             |   21 +-
 drivers/input/gameport/fm801-gp.c                 |    1 +
 drivers/input/gameport/gameport.c                 |   25 +-
 drivers/input/joydev.c                            |   14 +-
 drivers/input/keyboard/Kconfig                    |   21 +
 drivers/input/keyboard/Makefile                   |    2 +
 drivers/input/keyboard/ep93xx_keypad.c            |  470 +++++++++++
 drivers/input/keyboard/gpio_keys.c                |   35 +-
 drivers/input/keyboard/lm8323.c                   |  878 +++++++++++++++++++++
 drivers/input/misc/Kconfig                        |   19 +
 drivers/input/misc/Makefile                       |    2 +
 drivers/input/misc/ati_remote2.c                  |   16 +-
 drivers/input/misc/dm355evm_keys.c                |  329 ++++++++
 drivers/input/misc/rotary_encoder.c               |   61 +-
 drivers/input/misc/twl4030-pwrbutton.c            |  145 ++++
 drivers/input/misc/uinput.c                       |   94 ++-
 drivers/input/mouse/Kconfig                       |   18 +
 drivers/input/mouse/Makefile                      |    1 +
 drivers/input/mouse/alps.c                        |   31 +-
 drivers/input/mouse/appletouch.c                  |    2 +-
 drivers/input/mouse/lifebook.c                    |   25 +-
 drivers/input/mouse/psmouse-base.c                |    4 +-
 drivers/input/mouse/synaptics.c                   |   28 +
 drivers/input/mouse/synaptics.h                   |    2 +
 drivers/input/mouse/synaptics_i2c.c               |  676 ++++++++++++++++
 drivers/input/mousedev.c                          |    9 +-
 drivers/input/serio/i8042.c                       |   17 +-
 drivers/input/serio/serio.c                       |   58 +-
 drivers/input/tablet/gtco.c                       |    1 +
 drivers/input/tablet/wacom.h                      |    5 +-
 drivers/input/tablet/wacom_sys.c                  |   13 +
 drivers/input/tablet/wacom_wac.c                  |  171 +++-
 drivers/input/tablet/wacom_wac.h                  |    3 +
 drivers/input/touchscreen/Kconfig                 |   32 +
 drivers/input/touchscreen/Makefile                |    3 +
 drivers/input/touchscreen/ads7846.c               |   23 +-
 drivers/input/touchscreen/atmel-wm97xx.c          |  446 +++++++++++
 drivers/input/touchscreen/eeti_ts.c               |  286 +++++++
 drivers/input/touchscreen/tsc2007.c               |    2 +-
 drivers/input/touchscreen/w90p910_ts.c            |  350 ++++++++
 drivers/mfd/ucb1400_core.c                        |   20 +
 include/linux/gameport.h                          |    3 +-
 include/linux/i2c/lm8323.h                        |   46 ++
 include/linux/input.h                             |    2 +
 include/linux/rotary_encoder.h                    |    2 +
 include/linux/serio.h                             |    9 +-
 include/linux/spi/ads7846.h                       |    1 +
 include/linux/ucb1400.h                           |   23 +-
 52 files changed, 4256 insertions(+), 244 deletions(-)
 create mode 100644 arch/arm/mach-ep93xx/include/mach/ep93xx_keypad.h
 create mode 100644 drivers/input/keyboard/ep93xx_keypad.c
 create mode 100644 drivers/input/keyboard/lm8323.c
 create mode 100644 drivers/input/misc/dm355evm_keys.c
 create mode 100644 drivers/input/misc/twl4030-pwrbutton.c
 create mode 100644 drivers/input/mouse/synaptics_i2c.c
 create mode 100644 drivers/input/touchscreen/atmel-wm97xx.c
 create mode 100644 drivers/input/touchscreen/eeti_ts.c
 create mode 100644 drivers/input/touchscreen/w90p910_ts.c
 create mode 100644 include/linux/i2c/lm8323.h

-- 
Dmitry

