Return-Path: <linux-kernel-owner+w=401wt.eu-S1763397AbYBHDFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763397AbYBHDFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 22:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756910AbYBHDFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 22:05:03 -0500
Received: from emerald.lightlink.com ([205.232.34.14]:3139 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbYBHDFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 22:05:00 -0500
Date: Thu, 7 Feb 2008 22:01:29 -0500
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PATCH] hwmon updates against v2.6.24 (~git17)
Message-ID: <20080208030129.GA22919@jupiter.solarsys.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Please pull from:
	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git release

You'll get two new drivers and cleanups all over the place.  The
addition of individual alarm sysfs files to all drivers continues.
All of these patches made it into the most recent -mm, at least.

Thanks & regards,

 Documentation/hwmon/ads7828         |   36 ++
 Documentation/hwmon/it87            |    2 +-
 Documentation/hwmon/lm78            |    4 +-
 Documentation/hwmon/lm87            |   11 +-
 Documentation/hwmon/userspace-tools |    2 +-
 Documentation/hwmon/w83627ehf       |    5 +-
 Documentation/hwmon/w83627hf        |    3 +-
 Documentation/hwmon/w83781d         |   22 +-
 Documentation/hwmon/w83l786ng       |   54 +++
 Documentation/i2c/busses/i2c-piix4  |    2 +-
 drivers/firmware/dmi_scan.c         |   62 ++-
 drivers/hwmon/Kconfig               |   30 +-
 drivers/hwmon/Makefile              |    2 +
 drivers/hwmon/abituguru3.c          |    1 +
 drivers/hwmon/adm1021.c             |    1 -
 drivers/hwmon/adm1025.c             |  393 +++++++++--------
 drivers/hwmon/adm1026.c             |  632 +++++++++++++++------------
 drivers/hwmon/adm1031.c             |  501 ++++++++++-----------
 drivers/hwmon/adm9240.c             |   27 ++-
 drivers/hwmon/ads7828.c             |  297 +++++++++++++
 drivers/hwmon/adt7470.c             |  100 ++++-
 drivers/hwmon/asb100.c              |  395 ++++++++---------
 drivers/hwmon/dme1737.c             |   23 +-
 drivers/hwmon/ds1621.c              |    1 -
 drivers/hwmon/f71805f.c             |    6 +-
 drivers/hwmon/f71882fg.c            |    6 +-
 drivers/hwmon/fscher.c              |    1 -
 drivers/hwmon/fschmd.c              |   94 ++++-
 drivers/hwmon/fscpos.c              |    1 -
 drivers/hwmon/gl518sm.c             |  269 ++++++++----
 drivers/hwmon/gl520sm.c             |  648 +++++++++++++++++-----------
 drivers/hwmon/it87.c                |   88 ++++-
 drivers/hwmon/lm75.c                |    1 -
 drivers/hwmon/lm77.c                |   20 +-
 drivers/hwmon/lm78.c                |    7 +-
 drivers/hwmon/lm80.c                |  328 +++++++-------
 drivers/hwmon/lm83.c                |    1 -
 drivers/hwmon/lm85.c                |   64 +++-
 drivers/hwmon/lm87.c                |   29 +-
 drivers/hwmon/lm90.c                |   27 +-
 drivers/hwmon/lm92.c                |    1 -
 drivers/hwmon/pc87360.c             |    6 +-
 drivers/hwmon/pc87427.c             |    6 +-
 drivers/hwmon/smsc47b397.c          |    6 +-
 drivers/hwmon/smsc47m1.c            |    6 +-
 drivers/hwmon/smsc47m192.c          |    3 +-
 drivers/hwmon/vt1211.c              |    8 +-
 drivers/hwmon/vt8231.c              |    2 +-
 drivers/hwmon/w83627ehf.c           |   29 +-
 drivers/hwmon/w83627hf.c            |  225 ++++++++---
 drivers/hwmon/w83781d.c             |   49 +--
 drivers/hwmon/w83791d.c             |    6 +-
 drivers/hwmon/w83793.c              |   13 +-
 drivers/hwmon/w83l785ts.c           |    1 -
 drivers/hwmon/w83l786ng.c           |  821 +++++++++++++++++++++++++++++++++++
 drivers/i2c/chips/eeprom.c          |    1 -
 drivers/i2c/chips/pcf8574.c         |    1 -
 drivers/i2c/chips/pcf8591.c         |    1 -
 include/linux/dmi.h                 |    3 +
 include/linux/i2c-id.h              |   36 --
 60 files changed, 3689 insertions(+), 1731 deletions(-)
 create mode 100644 Documentation/hwmon/ads7828
 create mode 100644 Documentation/hwmon/w83l786ng
 create mode 100644 drivers/hwmon/ads7828.c
 create mode 100644 drivers/hwmon/w83l786ng.c

Darrick J. Wong (1):
      hwmon: (adt7470) Support per-sensor alarm files

Hans de Goede (1):
      hwmon: (fschmd) Read voltage scaling factors from BIOS DMI

Jean Delvare (49):
      dmi: Let drivers walk the DMI table
      hwmon: (lm78/w83781d) Probe fewer I2C addresses
      hwmon: (lm87) Add support for the Analog Devices ADM1024
      hwmon: (adm1025) Use dynamic sysfs callbacks
      hwmon: (adm1025) Add individual alarm files
      hwmon: (adm1025) Various cleanups
      hwmon: (fschmd) Discard non-ASCII characters
      hwmon: (gl518sm) Various cleanups
      hwmon: (gl518sm) Don't create sysfs files for missing features
      hwmon: (gl518sm) Refactor fan functions
      hwmon: (gl518sm) Add individual alarm and beep files
      hwmon: (gl518sm) Report error on invalid fan div value
      hwmon: (gl518sm) Fix the reported fan speed
      hwmon: (lm90) Use generic i2c reads during detection
      hwmon: (gl520sm) Various cleanups
      hwmon: (gl520sm) Put register addresses in arrays
      hwmon: (gl520sm) De-macro the sysfs callbacks
      hwmon: (gl520sm) Add individual alarm and beep files
      hwmon: Update the lm-sensors website address
      hwmon: Let the user override the detected Super-I/O device ID
      hwmon: (it87) Discard a dead e-mail address
      hwmon: (it87) Add individual alarm files
      hwmon: (adm1026) Add individual alarm files
      hwmon: (adm1026) Whitespace cleanups
      hwmon: (adm1026) More cleanups (updated)
      hwmon: (adm1026) Don't create files for missing inputs
      hwmon: (w83781d) Drop W83627HF support
      hwmon: (w83781d) Misc cleanups
      hwmon: (it87) Delete pwmN_freq files on driver removal
      hwmon: (adm1031) Fix register overwrite in set_fan_div()
      hwmon: (adm1031) Various cleanups
      hwmon: (adm1031) Get rid of macro-generated wrappers
      hwmon: (adm1031) Add individual alarm and fault files
      hwmon: (lm85) Return standard values in pwmN_enable
      hwmon: (lm85) Make the pwmN_enable files writable
      hwmon: Discard useless I2C driver IDs
      hwmon: (lm77) Add individual alarm files
      hwmon: (adm9240) Add individual alarm files
      hwmon: VRM is not written to registers
      hwmon: (asb100) Various cleanups
      hwmon: (asb100) De-macro the sysfs callbacks
      hwmon: (asb100) Add individual alarm files
      hwmon: (w83627ehf) The W83627DHG has 8 VID pins
      hwmon: (w83627hf) Enable VBAT monitoring
      hwmon: (w83627hf) Add individual alarm and beep files
      hwmon: (w83627hf) Refactor beep enable handling
      hwmon: (lm80) Various cleanups
      hwmon: (lm80) De-macro the sysfs callbacks
      hwmon: (lm80) Add individual alarm files

Joe Perches (1):
      hwmon: (vt8231) Add missing "space"

Juerg Haefliger (2):
      hwmon: (dme1737) fix divide-by-0
      hwmon: (dme1737) fix Super-IO device ID override

Kevin Lo (1):
      hwmon: Add support for Winbond W83L786NG/NR

Nicolas Kaiser (1):
      hwmon: (w83793) remove duplicated defines

Robert P. J. Day (1):
      hwmon: (adt7470) Replace power-of-two test

Sergey Vlasov (1):
      hwmon: (abituguru3) Add AUX4 fan input for Abit IP35 Pro

Steve Hardy (1):
      hwmon: Add support for Texas Instruments/Burr-Brown ADS7828

-- 
Mark M. Hoffman
mhoffman@lightlink.com

