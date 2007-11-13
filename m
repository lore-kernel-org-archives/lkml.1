Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbXKMNMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbXKMNMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 08:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbXKMNMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 08:12:38 -0500
Received: from emerald.lightlink.com ([205.232.34.14]:9801 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbXKMNMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 08:12:37 -0500
Date: Tue, 13 Nov 2007 08:12:10 -0500
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PATCH] hwmon updates against v2.6.24-rc2
Message-ID: <20071113131210.GA2674@jupiter.solarsys.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Please pull from:
	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git release

You'll get one new driver, a few cleanups, and a few bugfixes.  This
takes care of all known regressions; hopefully it's the last you hear
from me before 2.6.24-final.

Note: the f75375s/n2100 patches especially are critical to avoid
possible overheating problems on that platform (yay crappy BIOS).

All of these patches have spent considerable time in -mm.

Thanks & regards,

 Documentation/hwmon/sysfs-interface |   31 ++
 arch/arm/mach-iop32x/n2100.c        |   11 
 drivers/hwmon/Kconfig               |   10 
 drivers/hwmon/Makefile              |    1 
 drivers/hwmon/abituguru3.c          |   56 +++
 drivers/hwmon/applesmc.c            |  107 ++++++
 drivers/hwmon/f75375s.c             |  170 ++++++++---
 drivers/hwmon/i5k_amb.c             |  552 ++++++++++++++++++++++++++++++++++++
 drivers/hwmon/ibmpex.c              |   48 +--
 drivers/hwmon/lm70.c                |   11 
 drivers/hwmon/sis5595.c             |   59 ++-
 drivers/hwmon/w83627hf.c            |  155 +++-------
 drivers/hwmon/w83781d.c             |    3 
 include/linux/f75375s.h             |   21 +
 include/linux/pci_ids.h             |    3 
 15 files changed, 1049 insertions(+), 189 deletions(-)

Adrian Bunk (1):
      hwmon: (ibmpex.c) fix NULL dereference

Darrick J. Wong (4):
      hwmon: Add power meter spec to Documentation/hwmon/sysfs-interface
      hwmon: (i5k_amb) New memory temperature sensor driver
      hwmon: (ibmpex) Change printk to dev_{info,err} macros
      hwmon: (i5k_amb) Convert macros to C functions

Hans de Goede (2):
      hwmon: (abituguru3) Add support for 2 new motherboards
      hwmon: (abituguru3) Identify ABit IP35 Pro as such

Ivo Manca (2):
      hwmon: (sis5595) Add individual alarm files
      hwmon: (sis5595) Split sis5595_attributes_opt

Jean Delvare (1):
      hwmon: (w83781d) Add missing curly braces

Jim Cromie (2):
      hwmon: (w83627hf) hoist nr-1 offset out of show-store-temp-X
      hwmon: (w83627hf) push nr+1 offset into *_REG_FAN macros and simplify

Matthias Kaehlcke (1):
      hwmon: (lm70) Convert semaphore to mutex

René Rebe (1):
      hwmon: (applesmc) Add support for Mac Pro 2 x Quad-Core

Riku Voipio (5):
      hwmon: (f75375s) fix pwm mode setting
      hwmon: (f75375s) Add new style bindings
      hwmon: (f75375s) Allow setting up fans with platform_data
      hwmon: (f75375s) On n2100 systems, set fans to full speed on boot
      hwmon: (f75375s) pwmX_mode sysfs files writable for f75375 variant

-- 
Mark M. Hoffman
mhoffman@lightlink.com

