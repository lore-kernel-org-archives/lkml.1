Return-Path: <linux-kernel-owner+w=401wt.eu-S932934AbXBTNIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934AbXBTNIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 08:08:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932943AbXBTNIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 08:08:04 -0500
Received: from tim.rpsys.net ([194.106.48.114]:40523 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932934AbXBTNIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 08:08:02 -0500
Subject: [GIT PULL] Backlight updates
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 Feb 2007 13:06:39 +0000
Message-Id: <1171976799.5884.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull from:
git://git.o-hand.com/linux-rpurdie-backlight for-linus

which:

 * Adds myself as backlight maintainer (I've been involved with it 
   since its creation, just never officially)
 * Resolves the locking nightmare backlight usage was turning into
 * Fixes several bugs
 * Adds a new backlight driver
 * Cleans up code in a number of areas and removes duplication
 * Fixes some Kconfig issues

Its been in the last two -mm releases apart from the last Kconfig fix.
The late merge is due to waiting for ACPI to merge drivers containing
backlight code first. The combined ACPI/misc changes are 
Acked-by: Len Brown <len.brown@intel.com> although its hard to apply
that to a specific commit.

Thanks,

Richard

 MAINTAINERS                                 |    5
 arch/powerpc/kernel/traps.c                 |    6 -
 arch/powerpc/platforms/powermac/backlight.c |   27 +---
 drivers/acpi/asus_acpi.c                    |    7 -
 drivers/acpi/ibm_acpi.c                     |    8 -
 drivers/acpi/toshiba_acpi.c                 |    7 -
 drivers/acpi/video.c                        |   36 ++----
 drivers/macintosh/via-pmu-backlight.c       |   33 ++----
 drivers/misc/asus-laptop.c                  |   31 +----
 drivers/misc/msi-laptop.c                   |   10 -
 drivers/misc/sony-laptop.c                  |   16 +-
 drivers/usb/misc/appledisplay.c             |   18 +--
 drivers/video/Kconfig                       |   71 ++++++------
 drivers/video/Makefile                      |    2
 drivers/video/aty/aty128fb.c                |  102 +++---------------
 drivers/video/aty/atyfb_base.c              |  100 +++---------------
 drivers/video/aty/radeon_backlight.c        |   59 ++--------
 drivers/video/aty/radeon_base.c             |    3
 drivers/video/backlight/Kconfig             |   23 +---
 drivers/video/backlight/Makefile            |    1
 drivers/video/backlight/backlight.c         |  123 +++++++++++-----------
 drivers/video/backlight/corgi_bl.c          |   54 ++++-----
 drivers/video/backlight/hp680_bl.c          |   50 +++++----
 drivers/video/backlight/lcd.c               |   83 +++++++--------
 drivers/video/backlight/locomolcd.c         |   13 +-
 drivers/video/backlight/progear_bl.c        |  153 ++++++++++++++++++++++++++++
 drivers/video/chipsfb.c                     |   26 ----
 drivers/video/console/fbcon.c               |    7 +
 drivers/video/fbsysfs.c                     |   14 +-
 drivers/video/nvidia/nv_backlight.c         |   92 ++--------------
 drivers/video/nvidia/nv_proto.h             |    2
 drivers/video/nvidia/nvidia.c               |    5
 drivers/video/riva/fbdev.c                  |  100 +++---------------
 include/linux/backlight.h                   |   50 +++++++--
 include/linux/fb.h                          |   13 +-
 include/linux/lcd.h                         |   45 ++++++--
 36 files changed, 629 insertions(+), 766 deletions(-)

Dmitry Torokhov (2):
      backlight: Fix error handling
      backlight: Remove excessive (un)likelys

James Simmons (1):
      backlight: Improve backlight selection for fbdev drivers

Marcin Juszkiewicz (1):
      backlight: Add Frontpath ProGear HX1050+ driver

Richard Purdie (16):
      backlight: Add maintainer entry
      backlight: Remove unneeded owner field
      backlight: Minor code cleanups for corgi_bl.c
      backlight: Minor code cleanups for hp680_bl.c
      backlight: Fix external uses of backlight internal semaphore
      backlight: Convert semaphore -> mutex
      backlight: Remove uneeded nvidia set_power calls
      backlight: Fix Kconfig entries
      backlight/fbcon: Add FB_EVENT_CONBLANK
      backlight: Remove uneeded update_status call from chipsfb.c
      backlight: Remove unneeded backlight update_status calls
      backlight: Rework backlight/fb interaction simplifying, lots
      backlight: Clean up pmac_backlight handling
      backlight: Separate backlight properties from backlight ops pointers
      backlight: simplify corgi_bl locking
      backlight: Remove bogus SYSFS dependency



