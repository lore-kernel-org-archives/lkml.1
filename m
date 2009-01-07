Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbZAGPzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbZAGPzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbZAGPzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:55:19 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:11889 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbZAGPzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:55:17 -0500
Date: Wed, 7 Jan 2009 16:55:01 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] hwmon updates for 2.6.29
Message-ID: <20090107165501.646e4841@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some hwmon subsystem updates for Linux 2.6.29 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 hwmon-for-linus

There are a lot of improvements to the f71882fg driver, a new driver
(ltc4245), watchdog support added to the fschmd driver, support for the
ITE IT8720F, and a few other small things.

 Documentation/feature-removal-schedule.txt |    8 +
 Documentation/hwmon/f71882fg               |   89 ++
 Documentation/hwmon/it87                   |   20 +-
 Documentation/hwmon/lm70                   |   12 +-
 Documentation/hwmon/lm85                   |    2 +-
 Documentation/hwmon/ltc4245                |   81 ++
 Documentation/spi/spi-lm70llp              |   10 +
 drivers/hwmon/Kconfig                      |   47 +-
 drivers/hwmon/Makefile                     |    1 +
 drivers/hwmon/asb100.c                     |    5 +-
 drivers/hwmon/dme1737.c                    |    5 +
 drivers/hwmon/f71805f.c                    |    5 +
 drivers/hwmon/f71882fg.c                   | 1549 +++++++++++++++++++++++-----
 drivers/hwmon/fschmd.c                     |  448 ++++++++-
 drivers/hwmon/i5k_amb.c                    |    7 +
 drivers/hwmon/it87.c                       |   37 +-
 drivers/hwmon/lm70.c                       |   91 ++-
 drivers/hwmon/ltc4245.c                    |  567 ++++++++++
 drivers/hwmon/pc87360.c                    |    6 +
 drivers/hwmon/pc87427.c                    |    5 +
 drivers/hwmon/sis5595.c                    |    5 +
 drivers/hwmon/smsc47b397.c                 |    5 +
 drivers/hwmon/smsc47m1.c                   |    5 +
 drivers/hwmon/via686a.c                    |    5 +
 drivers/hwmon/vt1211.c                     |    5 +
 drivers/hwmon/vt8231.c                     |    5 +
 drivers/hwmon/w83627ehf.c                  |    8 +-
 drivers/hwmon/w83627hf.c                   |    5 +
 drivers/hwmon/w83781d.c                    |    5 +-
 drivers/hwmon/w83791d.c                    |    5 +-
 drivers/hwmon/w83792d.c                    |    5 +-
 drivers/hwmon/w83793.c                     |    5 +-
 drivers/spi/spi_lm70llp.c                  |   33 +-
 33 files changed, 2729 insertions(+), 362 deletions(-)
 create mode 100644 Documentation/hwmon/f71882fg
 create mode 100644 Documentation/hwmon/ltc4245
 create mode 100644 drivers/hwmon/ltc4245.c

---------------

Darrick J. Wong (1):
      hwmon: (i5k_amb) Load automatically on all 5000/5400 chipsets

Hans de Goede (18):
      hwmon: (f71882fg) Style cleanups and put some repeating code into functions
      hwmon: (f71882fg) Add support for the F71862FG superio sensors
      hwmon: (f71882fg) Move some io access from the detect to the probe function
      hwmon: (f71882fg) Prepare for adding F8000 support
      hwmon: (f71882fg) Fix various sysfs callback function issues
      hwmon: (f71882fg) Cleanup fan and temp hyst functions
      hwmon: (f71882fg) Check for hwmon powerdown state
      hwmon: (f71882fg) Separate max and crit alarm and beep
      hwmon: (f71882fg) Remove the fan_mode module option
      hwmon: (f71882fg) Add F8000 support
      hwmon: (f71882fg) Add missing pwm3 attr for f71862fg
      hwmon: (f71882fg) Fix auto_channels_temp temp numbering with f8000
      hwmon: (f71882fg) Add documentation
      hwmon: (f71882fg) Printout fan modes
      hwmon: (f71882fg) Fix fan_to/from_reg prototypes
      hwmon: (fschmd) Cleanups for watchdog support
      hwmon: (fschmd) Add watchdog support
      hwmon: Deprecate the fscher and fscpos drivers

Ira Snyder (1):
      hwmon: Add LTC4245 driver

Jean Delvare (3):
      hwmon: Don't overuse I2C_CLIENT_MODULE_PARM
      hwmon: Check for ACPI resource conflicts
      hwmon: Fix various typos

Jean-Marc Spaggiari (1):
      hwmon: (it87) Add support for the ITE IT8720F

Kaiwan N Billimoria (1):
      hwmon: (lm70) Code streamlining and cleanup

Manuel Lauss (1):
      hwmon: (lm70) Add TI TMP121 support

Mark van Doesburg (3):
      hwmon: (f71882fg) Use sensor_device_attribute_2
      hwmon: (f71882fg) Misc cleanups
      hwmon: (f71882fg) Add PWM support



-- 
Jean Delvare
