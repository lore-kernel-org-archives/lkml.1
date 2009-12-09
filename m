Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbZLIVRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbZLIVRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 16:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbZLIVRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 16:17:19 -0500
Received: from bamako.nerim.net ([62.4.17.28]:51079 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbZLIVRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 16:17:19 -0500
Date: Wed, 9 Dec 2009 22:17:21 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] hwmon updates for 2.6.33, round 1
Message-ID: <20091209221721.3dc73a97@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some hwmon subsystem updates for Linux 2.6.33 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

We have support for 5 new devices (Analog Devices ADT7476 and ADT7490,
National Semiconductor LM73, Fintek F71889FG and Freescale MC13783),
improvements to the f71882fg and adt7475 drivers, cleanups to many
detect function as the result of a recent i2c-core clean-up, and random
fixes and clean-ups as usual.

 Documentation/feature-removal-schedule.txt |    7 +
 Documentation/hwmon/adt7473                |    2 +
 Documentation/hwmon/adt7475                |  204 ++++++-----
 Documentation/hwmon/f71882fg               |   10 +
 Documentation/hwmon/it87                   |    1 -
 Documentation/hwmon/mc13783-adc            |   50 +++
 Documentation/hwmon/sysfs-interface        |   11 +-
 Documentation/hwmon/w83627hf               |   29 ++-
 MAINTAINERS                                |   15 +
 drivers/hwmon/Kconfig                      |   35 ++-
 drivers/hwmon/Makefile                     |    2 +
 drivers/hwmon/adm1021.c                    |   76 ++---
 drivers/hwmon/adm1025.c                    |   73 +---
 drivers/hwmon/adm1026.c                    |   47 +--
 drivers/hwmon/adm1029.c                    |   57 +--
 drivers/hwmon/adm1031.c                    |   26 +-
 drivers/hwmon/adm9240.c                    |   61 ++--
 drivers/hwmon/ads7828.c                    |   22 +-
 drivers/hwmon/adt7462.c                    |   25 +-
 drivers/hwmon/adt7470.c                    |   25 +-
 drivers/hwmon/adt7473.c                    |   28 +-
 drivers/hwmon/adt7475.c                    |  538 ++++++++++++++++++++++++----
 drivers/hwmon/asb100.c                     |   55 +--
 drivers/hwmon/dme1737.c                    |   32 +--
 drivers/hwmon/ds1621.c                     |   22 +-
 drivers/hwmon/f71882fg.c                   |  350 ++++++++++++------
 drivers/hwmon/f75375s.c                    |   32 +--
 drivers/hwmon/fschmd.c                     |   53 ++--
 drivers/hwmon/gl518sm.c                    |   29 +--
 drivers/hwmon/gl520sm.c                    |   12 +-
 drivers/hwmon/it87.c                       |   47 ++-
 drivers/hwmon/lm63.c                       |   54 ++--
 drivers/hwmon/lm73.c                       |  205 +++++++++++
 drivers/hwmon/lm75.c                       |   56 ++--
 drivers/hwmon/lm77.c                       |   80 ++---
 drivers/hwmon/lm78.c                       |   60 ++--
 drivers/hwmon/lm83.c                       |   81 ++---
 drivers/hwmon/lm85.c                       |  157 ++++-----
 drivers/hwmon/lm87.c                       |   41 +--
 drivers/hwmon/lm90.c                       |  228 +++++-------
 drivers/hwmon/lm92.c                       |   31 +-
 drivers/hwmon/lm93.c                       |   32 +--
 drivers/hwmon/lm95241.c                    |   48 +--
 drivers/hwmon/max1619.c                    |   64 +---
 drivers/hwmon/max6650.c                    |   20 +-
 drivers/hwmon/mc13783-adc.c                |  236 ++++++++++++
 drivers/hwmon/s3c-hwmon.c                  |    4 +-
 drivers/hwmon/smsc47m192.c                 |   28 +-
 drivers/hwmon/thmc50.c                     |   37 +--
 drivers/hwmon/tmp401.c                     |   55 ++--
 drivers/hwmon/tmp421.c                     |   45 ++--
 drivers/hwmon/w83627hf.c                   |   96 +++---
 drivers/hwmon/w83781d.c                    |  131 +++----
 drivers/hwmon/w83791d.c                    |   60 +---
 drivers/hwmon/w83792d.c                    |   61 +---
 drivers/hwmon/w83793.c                     |   53 +--
 drivers/hwmon/w83l785ts.c                  |   70 ++---
 drivers/hwmon/w83l786ng.c                  |   58 +--
 58 files changed, 2322 insertions(+), 1745 deletions(-)
 create mode 100644 Documentation/hwmon/mc13783-adc
 create mode 100644 drivers/hwmon/lm73.c
 create mode 100644 drivers/hwmon/mc13783-adc.c

---------------

Adrien Demarez (1):
      hwmon: New driver for the National Semiconductor LM73

Ben Dooks (1):
      hwmon: (s3c-hwmon) Fix build error

Hans de Goede (4):
      hwmon: (f71882fg) Cleanup sysfs attr creation 1/2
      hwmon: (f71882fg) Cleanup sysfs attr creation 2/2
      hwmon: (f71882fg) Fix sysfs file removal
      hwmon: (f71882fg) Add support for the f71889fg (version 2)

Jean Delvare (33):
      MAINTAINERS: Add missing hwmon files
      hwmon: Clarify autopwm trip points documentation
      hwmon: (it87) Verify the VID pin usage
      hwmon: (it87) Check for fan2 and fan3 availability
      hwmon: (w83627hf) Drop the force_addr module parameter
      hwmon: (w83627hf) Stop using globals for I/O port numbers
      hwmon: (adm1021) Clean up detect function
      hwmon: (adm1025) Clean up detect function
      hwmon: (lm77) Clean up detect function
      hwmon: (lm83) Clean up detect function
      hwmon: (lm85) Clean up detect function
      hwmon: (lm90) Clean up detect function
      hwmon: (tmp401/tmp421) Clean up detect functions
      hwmon: (w83781d) Clean up detect function
      hwmon: (w83791d) Clean up detect function
      hwmon: (w83792d) Clean up detect function
      hwmon: (w83l785ts) Clean up detect function
      hwmon: Clean up detect functions
      hwmon: (thmc50) Stop using I2C_CLIENT_MODULE_PARM
      hwmon: (adt7475) Add support for the ADT7473
      hwmon: (adt7475) New documentation
      hwmon: (adt7475) Implement pwm_use_point2_pwm_at_crit
      hwmon: (adt7475) Rework voltage inputs handling
      hwmon: (adt7475) Add missing static marker
      hwmon: (adt7475) Improve device detection
      hwmon: (adt7475) Add support for the ADT7490
      hwmon: (adt7475) Move sysfs files removal to a separate function
      hwmon: (adt7475) Handle alternative pin functions
      hwmon: (adt7475) Print device information on probe
      hwmon: (adt7475) Voltage attenuators can be bypassed
      hwmon: (adt7475) Add support for the ADT7476
      hwmon: (adt7475) Add an entry in MAINTAINERS
      hwmon: (adt7475) Add VID support for the ADT7476

Luotao Fu (1):
      hwmon: Add Freescale MC13783 ADC driver

Marc Hulsman (1):
      hwmon: (w83791d) Remove experimental dependency

Thanks,
-- 
Jean Delvare
