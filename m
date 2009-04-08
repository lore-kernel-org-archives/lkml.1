Return-Path: <linux-kernel-owner+w=401wt.eu-S1763389AbZDHHac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763389AbZDHHac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763327AbZDHH3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:29:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:30092 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763365AbZDHH3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:29:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=sg/FhL4PM/lNtNU8PMjuUtfl4tgeWQitnfzx2v7ZycBMo/xbvTk84MxAh6En+gTxUM
         uljjxI5Xn4CN/LbN8/5g9/+FBpNLY1T9KbHJKwSSoxtEbeX7OC+lgq7M3nbOYk2fY/5m
         qLIBqsuW0flk5AwKNVHsKBI/8IlVEGyckRdKQ=
Date: Wed, 8 Apr 2009 00:29:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.30-rc1
Message-ID: <20090408072935.GA27920@dtor-d630.eng.vmware.com>
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

to receive updates for the input subsystem. Bunch of new drivers plus
some cleanups to existing ones, nothing too exciting. It looks like I
managed to miss the merge window. Oh well...

Changelog:
---------

Adrian McMenamin (1):
      Input: add support for the Maple mouse on the SEGA Dreamcast

Andy Whitcroft (1):
      Input: psmouse - add newline to OLPC HGPK touchpad debugging

Daniel Mack (1):
      Input: generic driver for rotary encoders on GPIOs

Daniel Mierswa (2):
      Input: atkbd - consolidate force release quirk setup
      Input: atkbd - add quirk for Fujitsu Siemens Amilo PA 1510

Dmitry Torokhov (3):
      Input: fix polling of /proc/bus/input/devices
      Input: arrange drivers/input/misc/Makefile in alphabetical order
      Input: i8042 - add HP DV9700 to the noloop list

Helge Deller (1):
      Input: hilkbd - fix crash when removing hilkbd module

Johannes Berg (1):
      Input: stop autorepeat timer on key release

Mark Brown (2):
      Input: wm97xx - use disable_irq_nosync() for Mainstone
      Input: add accelerated touchscreen support for Marvell Zylonite

Michael Hennerich (3):
      Input: bf54x-keys - fix typo in warning
      Input: add AD7877 touchscreen driver
      Input: add AD7879 Touchscreen driver

Mike Rapoport (2):
      Input: wm97xx - add BTN_TOUCH event to wm97xx to use it with Android
      Input: ucb1400_ts, mainstone-wm97xx - add BTN_TOUCH events

Phil Sutter (1):
      Input: add driver for S1 button of rb532

Roel Kluin (1):
      Input: pc110pad - use no_pci_devices()

Ville Syrjala (3):
      Input: ati_remote2 - complete suspend support
      Input: ati_remote2 - add per device attrs
      Input: ati_remote2 - check module params


Diffstat:
--------

 Documentation/input/rotary-encoder.txt       |  101 +++
 arch/mips/include/asm/mach-rc32434/gpio.h    |    3 +
 arch/mips/rb532/devices.c                    |   19 +-
 drivers/input/input.c                        |   13 +-
 drivers/input/keyboard/atkbd.c               |  135 ++---
 drivers/input/keyboard/bf54x-keys.c          |    4 +-
 drivers/input/keyboard/hilkbd.c              |  140 +++--
 drivers/input/misc/Kconfig                   |   23 +
 drivers/input/misc/Makefile                  |   28 +-
 drivers/input/misc/ati_remote2.c             |  277 ++++++++-
 drivers/input/misc/rb532_button.c            |  120 ++++
 drivers/input/misc/rotary_encoder.c          |  221 +++++++
 drivers/input/mouse/Kconfig                  |   11 +
 drivers/input/mouse/Makefile                 |    9 +-
 drivers/input/mouse/hgpk.c                   |    2 +-
 drivers/input/mouse/maplemouse.c             |  147 +++++
 drivers/input/mouse/pc110pad.c               |    5 +-
 drivers/input/serio/i8042-x86ia64io.h        |    8 +
 drivers/input/touchscreen/Kconfig            |   58 ++
 drivers/input/touchscreen/Makefile           |    3 +
 drivers/input/touchscreen/ad7877.c           |  844 ++++++++++++++++++++++++++
 drivers/input/touchscreen/ad7879.c           |  782 ++++++++++++++++++++++++
 drivers/input/touchscreen/mainstone-wm97xx.c |    3 +-
 drivers/input/touchscreen/ucb1400_ts.c       |    5 +-
 drivers/input/touchscreen/wm97xx-core.c      |   13 +-
 drivers/input/touchscreen/zylonite-wm97xx.c  |  240 ++++++++
 include/linux/rotary_encoder.h               |   13 +
 include/linux/spi/ad7879.h                   |   35 ++
 28 files changed, 3062 insertions(+), 200 deletions(-)
 create mode 100644 Documentation/input/rotary-encoder.txt
 create mode 100644 drivers/input/misc/rb532_button.c
 create mode 100644 drivers/input/misc/rotary_encoder.c
 create mode 100644 drivers/input/mouse/maplemouse.c
 create mode 100644 drivers/input/touchscreen/ad7877.c
 create mode 100644 drivers/input/touchscreen/ad7879.c
 create mode 100644 drivers/input/touchscreen/zylonite-wm97xx.c
 create mode 100644 include/linux/rotary_encoder.h
 create mode 100644 include/linux/spi/ad7879.h

-- 
Dmitry

