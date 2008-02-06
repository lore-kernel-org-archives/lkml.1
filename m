Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbYBFGIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbYBFGIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 01:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYBFGIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 01:08:37 -0500
Received: from mxsf09.insightbb.com ([74.128.0.79]:16599 "EHLO
	mxsf09.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbYBFGIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 01:08:35 -0500
X-IronPort-AV: E=Sophos;i="4.25,310,1199682000"; 
   d="scan'208";a="244099239"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAMvdqEdKjlCP/2dsb2JhbACBWKw9gXY
X-IronPort-AV: E=Sophos;i="4.25,310,1199682000"; 
   d="scan'208";a="153818900"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Input updates for 2.6.25-rc0
Date: Wed, 6 Feb 2008 01:08:30 -0500
User-Agent: KMail/1.9.3
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802060108.31644.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. Most of the changes were in -mm for
some time with the exception of PXA keypad driver update. However, since there
are currently no users of said driver in mainline kernel, I consider the update
pretty safe. 

Changelog:
---------

Andre Haupt (1):
      Input: remove duplicate includes

Andrew Morton (1):
      Input: i8042 - non-x86 build fix

Bruce Duncan (1):
      Input: i8042 - enable DMI quirks on x86-64

Carlos Corbacho (2):
      Input: i8042 - add Dritek keyboard extension quirk
      Input: i8042 - add Dritek quirk for Acer Aspire 9110

David Brownell (1):
      Input: ads7846 - stop updating dev->power.power_state

Dmitry Baryshkov (1):
      Input: add Tosa keyboard driver

Dmitry Torokhov (10):
      Input: Add proper locking when changing device's keymap
      Input: keyspan_remote - add support for loadable keymaps
      Input: atlas_btns - add support for loadable keymaps
      Input: cobalt_btns - add support for loadable keymaps
      Input: atkbd - remove unneeded synchronize_sched()
      Input: i8042 - use synchronize_irq() instead of synchronize_sched()
      Input: iforce - don't access input_dev->private directly
      V4L/DVB: Don't access input_dev->private directly
      Input: remove cdev from input_dev structure
      Input: mousedev - use BIT_MASK instead of BIT

Eric Miao (8):
      Input: pxa27x_keypad - rename the driver (was pxa27x_keyboard)
      Input: pxa27x_keypad - remove pin configuration from the driver
      Input: pxa27x_keypad - introduce driver structure and use KEY() to define matrix keys
      Input: pxa27x_keypad - introduce pxa27x_keypad_config()
      Input: pxa27x_keypad - enable rotary encoders and direct keys
      Input: pxa27x_keypad - use device resources for I/O memory mapping and IRQ
      Input: pxa27x_keypad - add debounce_interval to the keypad platform data
      Input: pxa27x_keypad - also enable on PXA3xx

Francisco Alecrim (1):
      Input: remove duplicated headers in drivers/char/keyboard.c

Giel de Nijs (1):
      Input: atkbd - properly handle special keys on Dell Latitudes

Jan Engelhardt (1):
      Input: constify function pointer tables (seq_operations)

Jiri Kosina (1):
      Input: i8042 - add Fujitsu-Siemens Amilo Pro 2010 to nomux list

Julia Lawall (1):
      Input: drop redundant includes of moduleparam.h

Richard Purdie (1):
      Input: add input event to APM event bridge

Stephen Hemminger (2):
      Input: implement proper timer rounding for polled devices
      Input: add driver for Fujitsu application buttons

Steven Whitehouse (1):
      Input: fix bug in example code

Diffstat:
--------

 Documentation/input/input-programming.txt         |    2 +-
 arch/arm/mach-pxa/tosa.c                          |   43 ++
 drivers/char/keyboard.c                           |    5 +-
 drivers/input/Kconfig                             |   12 +
 drivers/input/Makefile                            |    1 +
 drivers/input/apm-power.c                         |  131 +++++
 drivers/input/evdev.c                             |    6 +-
 drivers/input/input-polldev.c                     |   18 +-
 drivers/input/input.c                             |   85 +++-
 drivers/input/joystick/amijoy.c                   |    1 -
 drivers/input/joystick/analog.c                   |    1 -
 drivers/input/joystick/db9.c                      |    1 -
 drivers/input/joystick/gamecon.c                  |    1 -
 drivers/input/joystick/iforce/iforce-main.c       |   17 +-
 drivers/input/joystick/turbografx.c               |    1 -
 drivers/input/joystick/xpad.c                     |    1 -
 drivers/input/keyboard/Kconfig                    |   29 +-
 drivers/input/keyboard/Makefile                   |    3 +-
 drivers/input/keyboard/atkbd.c                    |   91 +++-
 drivers/input/keyboard/lkkbd.c                    |    1 -
 drivers/input/keyboard/pxa27x_keyboard.c          |  274 ----------
 drivers/input/keyboard/pxa27x_keypad.c            |  572 +++++++++++++++++++++
 drivers/input/keyboard/tosakbd.c                  |  415 +++++++++++++++
 drivers/input/misc/Kconfig                        |   14 +
 drivers/input/misc/Makefile                       |    1 +
 drivers/input/misc/apanel.c                       |  378 ++++++++++++++
 drivers/input/misc/ati_remote.c                   |    1 -
 drivers/input/misc/atlas_btns.c                   |   39 +-
 drivers/input/misc/cobalt_btns.c                  |   73 ++--
 drivers/input/misc/keyspan_remote.c               |  119 +++--
 drivers/input/mouse/inport.c                      |    1 -
 drivers/input/mouse/logibm.c                      |    1 -
 drivers/input/mouse/psmouse-base.c                |    1 -
 drivers/input/mouse/trackpoint.c                  |    1 -
 drivers/input/mousedev.c                          |    3 +-
 drivers/input/serio/i8042-x86ia64io.h             |   67 +++-
 drivers/input/serio/i8042.c                       |   26 +-
 drivers/input/serio/libps2.c                      |    1 -
 drivers/input/touchscreen/ads7846.c               |    8 +-
 drivers/input/touchscreen/mk712.c                 |    1 -
 drivers/input/touchscreen/ucb1400_ts.c            |    1 -
 drivers/media/video/usbvideo/konicawc.c           |    2 -
 drivers/media/video/usbvideo/quickcam_messenger.c |    2 -
 include/asm-arm/arch-pxa/pxa27x_keyboard.h        |   13 -
 include/asm-arm/arch-pxa/pxa27x_keypad.h          |   56 ++
 include/asm-arm/arch-pxa/tosa.h                   |   30 ++
 include/linux/input.h                             |    7 +-
 47 files changed, 2073 insertions(+), 484 deletions(-)
 create mode 100644 drivers/input/apm-power.c
 delete mode 100644 drivers/input/keyboard/pxa27x_keyboard.c
 create mode 100644 drivers/input/keyboard/pxa27x_keypad.c
 create mode 100644 drivers/input/keyboard/tosakbd.c
 create mode 100644 drivers/input/misc/apanel.c
 delete mode 100644 include/asm-arm/arch-pxa/pxa27x_keyboard.h
 create mode 100644 include/asm-arm/arch-pxa/pxa27x_keypad.h

-- 
Dmitry
