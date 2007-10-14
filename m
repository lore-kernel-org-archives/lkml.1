Return-Path: <linux-kernel-owner+w=401wt.eu-S1761156AbXJNTdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761156AbXJNTdk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 15:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbXJNTdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 15:33:33 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:26733 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbXJNTdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 15:33:32 -0400
Date: Sun, 14 Oct 2007 15:29:53 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PATCH] hwmon updates against v2.6.23
Message-ID: <20071014192953.GA9122@jupiter.solarsys.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Please pull from:
	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git release

You'll get five new drivers, cleanups and fixes all over the place.  The
addition of individual alarm sysfs files to all drivers continues.  Also, the
conversion from struct class_device to struct device touched every driver.
Most of these patches have spent some time in -mm.

Thanks & regards,

 Documentation/hwmon/coretemp        |    2 
 Documentation/hwmon/dme1737         |   33 -
 Documentation/hwmon/f71805f         |    7 
 Documentation/hwmon/it87            |    3 
 Documentation/hwmon/lm78            |   10 
 Documentation/hwmon/lm93            |  126 ----
 Documentation/hwmon/sysfs-interface |  131 +++-
 Documentation/hwmon/w83791d         |   96 +--
 MAINTAINERS                         |    5 
 drivers/hwmon/Kconfig               |   79 ++
 drivers/hwmon/Makefile              |    5 
 drivers/hwmon/abituguru.c           |   10 
 drivers/hwmon/abituguru3.c          |   10 
 drivers/hwmon/ad7418.c              |   12 
 drivers/hwmon/adm1021.c             |  373 +++++++-----
 drivers/hwmon/adm1025.c             |   12 
 drivers/hwmon/adm1026.c             |   12 
 drivers/hwmon/adm1029.c             |   10 
 drivers/hwmon/adm1031.c             |   10 
 drivers/hwmon/adm9240.c             |   10 
 drivers/hwmon/adt7470.c             | 1050 ++++++++++++++++++++++++++++++++++++
 drivers/hwmon/applesmc.c            |   10 
 drivers/hwmon/asb100.c              |   16 
 drivers/hwmon/atxp1.c               |   10 
 drivers/hwmon/coretemp.c            |   19 
 drivers/hwmon/dme1737.c             |  954 +++++++++++++++++++++-----------
 drivers/hwmon/ds1621.c              |   12 
 drivers/hwmon/f71805f.c             |   15 
 drivers/hwmon/f71882fg.c            |  950 ++++++++++++++++++++++++++++++++
 drivers/hwmon/f75375s.c             |  691 +++++++++++++++++++++++
 drivers/hwmon/fscher.c              |   10 
 drivers/hwmon/fschmd.c              |  778 ++++++++++++++++++++++++++
 drivers/hwmon/fscpos.c              |   10 
 drivers/hwmon/gl518sm.c             |   10 
 drivers/hwmon/gl520sm.c             |   10 
 drivers/hwmon/hwmon.c               |   27 
 drivers/hwmon/ibmpex.c              |  607 ++++++++++++++++++++
 drivers/hwmon/it87.c                |   66 +-
 drivers/hwmon/k8temp.c              |   10 
 drivers/hwmon/lm63.c                |   10 
 drivers/hwmon/lm70.c                |   27 
 drivers/hwmon/lm75.c                |   12 
 drivers/hwmon/lm75.h                |    2 
 drivers/hwmon/lm77.c                |   12 
 drivers/hwmon/lm78.c                |   48 +
 drivers/hwmon/lm80.c                |   10 
 drivers/hwmon/lm83.c                |   10 
 drivers/hwmon/lm85.c                |  704 +++++++++++-------------
 drivers/hwmon/lm87.c                |   83 ++
 drivers/hwmon/lm90.c                |   39 +
 drivers/hwmon/lm92.c                |   10 
 drivers/hwmon/lm93.c                |   28 
 drivers/hwmon/max1619.c             |   10 
 drivers/hwmon/max6650.c             |   10 
 drivers/hwmon/pc87360.c             |   12 
 drivers/hwmon/pc87427.c             |   10 
 drivers/hwmon/sis5595.c             |   21 
 drivers/hwmon/smsc47b397.c          |   10 
 drivers/hwmon/smsc47m1.c            |   14 
 drivers/hwmon/smsc47m192.c          |   12 
 drivers/hwmon/thmc50.c              |   68 +-
 drivers/hwmon/via686a.c             |   10 
 drivers/hwmon/vt1211.c              |   10 
 drivers/hwmon/vt8231.c              |   12 
 drivers/hwmon/w83627ehf.c           |   16 
 drivers/hwmon/w83627hf.c            |  812 +++++++++++++--------------
 drivers/hwmon/w83781d.c             |  206 ++++++-
 drivers/hwmon/w83791d.c             |  134 ++++
 drivers/hwmon/w83792d.c             |   59 +-
 drivers/hwmon/w83793.c              |   10 
 drivers/hwmon/w83l785ts.c           |   10 
 drivers/input/touchscreen/ads7846.c |    4 
 drivers/misc/thinkpad_acpi.c        |    2 
 drivers/misc/thinkpad_acpi.h        |    2 
 include/linux/hwmon.h               |    4 
 75 files changed, 6818 insertions(+), 1846 deletions(-)

Auke Kok (1):
      hwmon: (sis5595) re-use s_bridge->revision

Charles Spirakis (1):
      hwmon: (w83791d) new sysfs beep/alarm methodology

Christian Hohnstaedt (1):
      hwmon: Allow writing of negative trigger temperatures

Darrick J. Wong (3):
      hwmon: add support for adt7470
      hwmon: IBM power meter driver
      hwmon: (ibmpex) Release IPMI user if hwmon registration fails

Gong Jun (1):
      hwmon: (w83792d) Add individual alarm files

Hans de Goede (3):
      hwmon: add support for Fintek F71882FG and F71883FG
      hwmon: update sysfs interface document - error handling
      hwmon: Add new combined driver for FSC chips

Jean Delvare (26):
      hwmon: (f71805f) List the F71806F/FG as supported
      hwmon: Don't export thermistor beta
      hwmon: (lm93) Documentation fixes
      hwmon: (lm70) Add a name attribute
      hwmon: (smsc47m1) No confusing debugging messages
      hwmon: Update the sysfs interface documentation
      hwmon: (lm85) Use dynamic sysfs callbacks
      hwmon: (lm85) Export in5, in6 and in7 voltage channels
      hwmon: (lm85) Add individual alarm files
      hwmon: (lm85) Clean up the handling of additional resolution bits
      hwmon: (lm85) Let the user set the fan min limit to 0
      hwmon: (lm93) Use standard names for vid files
      hwmon: (it87) Add support for fan4 and fan5
      hwmon: Kconfig dependency cleanups
      hwmon: (lm90) Export temperature offset values
      hwmon: (lm78) Add individual alarm files
      hwmon: (lm87) Fix a division by zero
      hwmon: (lm87) Add individual alarm files
      hwmon: (thmc50) Don't create temp3 if not enabled
      hwmon: (thmc50) Fix a debug message
      hwmon: Fix the code examples in documentation
      hwmon: VRM is not read from registers
      hwmon: (w83781d) Add individual alarm and beep files
      hwmon: (lm87) Disable VID when it should be
      hwmon: (w83627hf) Fix setting fan min right after driver load
      hwmon: (w83627hf) don't assume bank 0

Jim Cromie (1):
      hwmon: (w83627hf) De-macro sysfs callback functions

Juerg Haefliger (3):
      hwmon: (dme1737) cleanups
      hwmon: (dme1737) group functions logically
      hwmon: (dme1737) Add sch311x support

Krzysztof Helt (5):
      hwmon: adm1021 clean ups
      hwmon: (thmc50) add individual alarm & fault files
      hwmon: (thmc50) Fix alarms clearing
      hwmon: (adm1021) dynamic sysfs callbacks conversion
      hwmon: (adm1021) individual alarm files

Mark M. Hoffman (5):
      hwmon: (f71882fg) trivial whitespace cleanup
      MAINTAINERS: update hwmon subsystem git trees
      hwmon: (dme1737) Fix some merge conflicts
      hwmon: (sis5595) fix sparse warning
      hwmon: (vt8231) fix sparse warning

Riku Voipio (1):
      hwmon: Add f75375s driver

Rudolf Marek (1):
      hwmon: (coretemp) Add support for Celeron 4xx

Satyam Sharma (1):
      hwmon: (coretemp) Remove bogus __cpuinitdata etc cleanup

Tony Jones (1):
      hwmon: Convert from class_device to device

-- 
Mark M. Hoffman
mhoffman@lightlink.com

