Return-Path: <linux-kernel-owner+w=401wt.eu-S936736AbXGSSq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936736AbXGSSq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 14:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759507AbXGSSqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 14:46:47 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:22136 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbXGSSqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 14:46:46 -0400
Date: Thu, 19 Jul 2007 14:42:41 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PATCH] hwmon patches against 2.6.22
Message-ID: <20070719184241.GF3406@jupiter.solarsys.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Updates to the hwmon subsystem are ready...

Please pull from:
	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git release

You'll get several new drivers, conversion of several existing drivers to
use the platform device model, and various bugfixes and enhancements.

The last commit removes i2c-isa.  Jean Delvare asked me to pass this on to you
due to the fact that all the prerequisites are in this tree anyway.

All of these patches have spent some time in -mm, as well.

Thanks & regards,

 Documentation/feature-removal-schedule.txt |    9 -
 Documentation/hwmon/abituguru              |   31 +-
 Documentation/hwmon/abituguru3             |   65 +
 Documentation/hwmon/dme1737                |  257 +++
 Documentation/hwmon/f71805f                |   35 +-
 Documentation/hwmon/it87                   |    9 +-
 Documentation/hwmon/lm90                   |   36 +-
 Documentation/hwmon/lm93                   |  412 +++++
 Documentation/hwmon/smsc47b397             |    7 +-
 Documentation/hwmon/sysfs-interface        |   15 +-
 Documentation/hwmon/w83627ehf              |    6 +-
 MAINTAINERS                                |   36 +-
 arch/arm/configs/badge4_defconfig          |    1 -
 arch/arm/configs/clps7500_defconfig        |    1 -
 arch/arm/configs/footbridge_defconfig      |    1 -
 arch/arm/configs/neponset_defconfig        |    1 -
 arch/arm/configs/picotux200_defconfig      |    1 -
 arch/arm/configs/rpc_defconfig             |    1 -
 arch/arm/configs/s3c2410_defconfig         |    1 -
 arch/m32r/m32104ut/defconfig.m32104ut      |    1 -
 arch/ppc/configs/ev64260_defconfig         |    1 -
 arch/ppc/configs/mpc8540_ads_defconfig     |    1 -
 arch/ppc/configs/mpc8548_cds_defconfig     |    1 -
 arch/ppc/configs/mpc8555_cds_defconfig     |    1 -
 arch/ppc/configs/mpc8560_ads_defconfig     |    1 -
 arch/ppc/configs/radstone_ppc7d_defconfig  |    1 -
 arch/ppc/configs/stx_gp3_defconfig         |    1 -
 arch/ppc/configs/sycamore_defconfig        |    1 -
 drivers/hwmon/Kconfig                      |   82 +-
 drivers/hwmon/Makefile                     |    3 +
 drivers/hwmon/abituguru.c                  |   45 +-
 drivers/hwmon/abituguru3.c                 | 1140 ++++++++++++
 drivers/hwmon/coretemp.c                   |    2 +-
 drivers/hwmon/dme1737.c                    | 2080 ++++++++++++++++++++++
 drivers/hwmon/ds1621.c                     |  161 +-
 drivers/hwmon/f71805f.c                    |  178 ++-
 drivers/hwmon/it87.c                       |  497 +++---
 drivers/hwmon/lm63.c                       |    4 +-
 drivers/hwmon/lm83.c                       |   12 +-
 drivers/hwmon/lm90.c                       |   78 +-
 drivers/hwmon/lm93.c                       | 2655 ++++++++++++++++++++++++++++
 drivers/hwmon/pc87360.c                    |  232 ++-
 drivers/hwmon/pc87427.c                    |    2 +-
 drivers/hwmon/sis5595.c                    |  510 +++---
 drivers/hwmon/smsc47b397.c                 |    7 +-
 drivers/hwmon/smsc47m1.c                   |   12 +-
 drivers/hwmon/smsc47m192.c                 |   37 +-
 drivers/hwmon/via686a.c                    |  538 +++---
 drivers/hwmon/vt8231.c                     |  318 ++--
 drivers/hwmon/w83627ehf.c                  |  615 ++++---
 drivers/hwmon/w83627hf.c                   |  153 ++-
 drivers/i2c/busses/Kconfig                 |    3 -
 drivers/i2c/busses/Makefile                |    1 -
 drivers/i2c/busses/i2c-isa.c               |  192 --
 drivers/i2c/i2c-core.c                     |    2 -
 include/linux/i2c-isa.h                    |   36 -
 include/linux/i2c.h                        |    1 -
 57 files changed, 8809 insertions(+), 1721 deletions(-)
 create mode 100644 Documentation/hwmon/abituguru3
 create mode 100644 Documentation/hwmon/dme1737
 create mode 100644 Documentation/hwmon/lm93
 create mode 100644 drivers/hwmon/abituguru3.c
 create mode 100644 drivers/hwmon/dme1737.c
 create mode 100644 drivers/hwmon/lm93.c
 delete mode 100644 drivers/i2c/busses/i2c-isa.c
 delete mode 100644 include/linux/i2c-isa.h

Adrian Bunk (1):
      make coretemp_device_remove() static

Carlos Olalla Martinez (1):
      hwmon/w83627hf: Add PWM frequency selection support

David Hubbard (3):
      hwmon/w83627ehf: Update the Kconfig entry
      hwmon/w83627ehf: Convert to a platform driver
      hwmon/w83627ehf: Add error messages for two error cases

Hans de Goede (4):
      hwmon: fix detection of abituguru volt inputs
      hwmon: Add support for newer uGuru's
      hwmon: fix Abit Uguru3 driver detection on some motherboards
      hwmon: refuse to load abituguru driver on non-Abit boards

Hans-Jürgen Koch (1):
      hwmon: Add LM93 support

Jean Delvare (25):
      hwmon/lm90: Spelling fix: explicitly
      hwmon/smsc47m192: Semaphore to mutex conversion
      hwmon/ds1621: Minor cleanups
      hwmon/ds1621: Use dynamic sysfs callbacks
      hwmon/ds1621: Create individual alarm files
      hwmon/pc87360: Convert to a platform driver
      hwmon: Use platform_device_add_data()
      hwmon: Fault files naming convention
      hwmon/via686a: Temperature interrupt configuration fix
      hwmon/via686a: Convert to a platform driver
      hwmon/via686a: Use dynamic sysfs callbacks
      hwmon/sis5595: Convert to a platform driver
      hwmon/sis5595: Use dynamic sysfs callbacks
      hwmon/sis5595: Use PCI_REVISION_ID
      hwmon: Fix a potential race condition on unload
      hwmon/w83627ehf: Preserve speed reading when changing fan min
      hwmon/smsc47b397: Don't report missing fans as spinning at 82 RPM
      hwmon: Improve the pwmN_enable documentation
      hwmon/w83627ehf: Fix timing issues
      hwmon/w83627ehf: Add support for the VID inputs
      hwmon/w83627ehf: Enable VBAT monitoring
      hwmon/w83627ehf: Export the thermal sensor types
      hwmon/w83627ehf: No need to initialize fan_min
      hwmon/w83627ehf: Be quiet when no chip is found
      i2c: Delete the i2c-isa pseudo bus driver

Juerg Haefliger (3):
      hwmon: New SMSC DME1737 driver
      hwmon/dme1737: Add documentation
      hwmon: add SCH5317 to smsc47b397 driver

Mark M. Hoffman (1):
      hwmon: New maintainer

Phil Endecott (1):
      hwmon/f71805f: Add temperature-tracking fan control mode

Rainer Birkenmaier (1):
      hwmon/lm90: Add support for the Maxim MAX6680/MAX6681

Roger Lucas (1):
      hwmon: Convert vt8231 to a platform driver

Rudolf Marek (1):
      hwmon/it87: Add IT8726F support

corentin.labbe (1):
      hwmon: convert it87 to platform driver

-- 
Mark M. Hoffman
mhoffman@lightlink.com

