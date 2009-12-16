Return-Path: <linux-kernel-owner+w=401wt.eu-S1761655AbZLPGrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761655AbZLPGrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 01:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbZLPGrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 01:47:14 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:35604 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbZLPGrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 01:47:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=JI5GH6ESdexrxwm42aEwgHafq+HOKTmXw3SXvWneOBzOk54Q9NCZ36yWdHTnfvmj+I
         1yjUJdZDXqb80piH0Gdvx+GzIp1PBMFDm6WOrN6ULI2e2PUCNqr8wxkQSwaCa0X1u3QJ
         YXLaCDeAWSkm2ttyaR1NpBpzIf9R06cOpt3Ik=
Date: Tue, 15 Dec 2009 22:47:06 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.33-rc0
Message-ID: <20091216064706.GC2699@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive second round of updates for the input subsystem. It contains
update to wacom driver, new ALPS protocol so that touchpads in Dell
Latitudes E6x00 series will finally work properly and not loose sync,
a new touchscreen driver and bunch of smaller fixes.

Changelog:
---------

Dmitry Torokhov (12):
      Input: serio - set owner in driver structures
      Input: hil-mlc - use del_timer_sync() when unloading the driver
      Input: altera_ps2 - add annotations to probe and remove methods
      Input: gscps2 - fix probe() and remove() annotations
      Input: ambakmi - annotate probe() and remove() methods
      Input: sa1111ps2 - annotate probe() and remove() methods
      Input: document use of input_event() function
      Input: ALPS - do not set REL_X/REL_Y capabilities on the touchpad
      Input: i8042 - fix locking in interrupt routine
      Input: i8042 - add Gigabyte M1022M to the noloop list
      Input: at32psif - do not sleep in atomic context
      Input: keyboard - don't override beep with a bell

H Hartley Sweeten (1):
      Input: ep93xx_keypad - update driver to new core support

Matthew Garrett (1):
      Input: i8042 - allow installing platform filters for incoming data

Ping Cheng (5):
      Input: wacom - ensure the device is initialized properly upon resume
      Input: wacom - add defines for packet lengths of various devices
      Input: wacom - add support for new LCD tablets
      Input: wacom - add defines for data packet report IDs
      Input: wacom - separate pen from express keys on Graphire

Roel Kluin (1):
      Input: altera_ps2 - fix test of unsigned in altera_ps2_probe()

Sascha Hauer (1):
      Input: add mc13783 touchscreen driver

Sebastian Kapfer (1):
      Input: ALPS - add interleaved protocol support (Dell E6x00 series)


Diffstat:
--------

 arch/arm/mach-ep93xx/include/mach/ep93xx_keypad.h |   11 +-
 drivers/char/keyboard.c                           |   10 +-
 drivers/input/input.c                             |   10 +-
 drivers/input/keyboard/ep93xx_keypad.c            |  150 +++------
 drivers/input/mouse/alps.c                        |  265 +++++++++++++--
 drivers/input/mouse/alps.h                        |    1 +
 drivers/input/serio/altera_ps2.c                  |   15 +-
 drivers/input/serio/ambakmi.c                     |    9 +-
 drivers/input/serio/at32psif.c                    |    3 +-
 drivers/input/serio/gscps2.c                      |    6 +-
 drivers/input/serio/hil_mlc.c                     |    8 +-
 drivers/input/serio/i8042-x86ia64io.h             |    8 +
 drivers/input/serio/i8042.c                       |   88 +++++-
 drivers/input/serio/sa1111ps2.c                   |   10 +-
 drivers/input/tablet/wacom.h                      |   11 +-
 drivers/input/tablet/wacom_sys.c                  |  231 +++++++++----
 drivers/input/tablet/wacom_wac.c                  |  368 +++++++++++++--------
 drivers/input/tablet/wacom_wac.h                  |   29 ++-
 drivers/input/touchscreen/Kconfig                 |   12 +
 drivers/input/touchscreen/Makefile                |    1 +
 drivers/input/touchscreen/mc13783_ts.c            |  258 +++++++++++++++
 include/linux/i8042.h                             |   18 +-
 22 files changed, 1137 insertions(+), 385 deletions(-)
 create mode 100644 drivers/input/touchscreen/mc13783_ts.c

-- 
Dmitry

