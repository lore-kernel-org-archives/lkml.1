Return-Path: <linux-kernel-owner+w=401wt.eu-S968301AbXEHPql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968301AbXEHPql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 11:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966437AbXEHPpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 11:45:31 -0400
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:1656 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934575AbXEHPpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 11:45:23 -0400
Date: Tue, 8 May 2007 17:45:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon updates for 2.6.22
Message-ID: <20070508174529.7298cae4@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the hwmon subsystem updates for Linux 2.6.22 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 hwmon-for-linus

There are 3 new hardware monitoring drivers (ad7418 for the Analog
Devices AD7416, AD7417 and AD7418, coretemp for the Intel Core/Core 2
integrated sensors and max6650 for the Maxim MAX6650 and MAX6651),
added support for the SMSC LPC47M292 sensors, and a few random fixes
and cleanups. Additionally, 5 drivers (lm78, smsc47b397, smsc47m1,
w83627hf and w83781d) have been converted from i2c-isa to platform
drivers. The rest should follow soon, so that we can get rid of i2c-isa
in 2.6.23.

 Documentation/hwmon/coretemp        |   36 +
 Documentation/hwmon/max6650         |   53 ++
 Documentation/hwmon/smsc47m1        |   11 +-
 Documentation/hwmon/smsc47m192      |    7 +-
 Documentation/hwmon/sysfs-interface |    7 +
 MAINTAINERS                         |   12 +
 arch/i386/kernel/msr.c              |  106 +---
 arch/i386/lib/msr-on-cpu.c          |   73 ++-
 drivers/hwmon/Kconfig               |  146 +++--
 drivers/hwmon/Makefile              |    3 +
 drivers/hwmon/ad7418.c              |  373 +++++++++++
 drivers/hwmon/ams/ams-core.c        |    3 -
 drivers/hwmon/ams/ams-i2c.c         |    8 +-
 drivers/hwmon/coretemp.c            |  406 ++++++++++++
 drivers/hwmon/f71805f.c             |   16 +-
 drivers/hwmon/hwmon-vid.c           |    6 +-
 drivers/hwmon/lm75.c                |   82 ++--
 drivers/hwmon/lm78.c                |  662 ++++++++++++--------
 drivers/hwmon/lm87.c                |    2 +-
 drivers/hwmon/max6650.c             |  693 ++++++++++++++++++++
 drivers/hwmon/pc87427.c             |   15 +-
 drivers/hwmon/smsc47b397.c          |  228 ++++---
 drivers/hwmon/smsc47m1.c            |  606 +++++++++++-------
 drivers/hwmon/smsc47m192.c          |    4 +-
 drivers/hwmon/vt1211.c              |   13 +
 drivers/hwmon/w83627hf.c            |  670 ++++++++++----------
 drivers/hwmon/w83781d.c             | 1205 +++++++++++++++++++----------------
 include/asm-i386/msr.h              |   12 +-
 include/asm-x86_64/msr.h            |   11 +
 29 files changed, 3777 insertions(+), 1692 deletions(-)
 create mode 100644 Documentation/hwmon/coretemp
 create mode 100644 Documentation/hwmon/max6650
 create mode 100644 drivers/hwmon/ad7418.c
 create mode 100644 drivers/hwmon/coretemp.c
 create mode 100644 drivers/hwmon/max6650.c

---------------

Alessandro Zummo (1):
      hwmon: New AD7416, AD7417 and AD7418 driver

Hans-Juergen Koch (1):
      hwmon: New max6650 driver

Jan Engelhardt (1):
      Use menuconfig objects - hwmon

Jean Delvare (22):
      hwmon/smsc47m192: Document the LPC47M292 as supported
      hwmon: Request the I/O regions in platform drivers
      hwmon/smsc47m1: Add support for the LPC47M292
      hwmon/smsc47m1: Get rid of a useless mutex
      hwmon: Only call vid_which_vrm() when needed
      hwmon/w83627hf: Preliminary cleanups
      hwmon/w83627hf: Convert to a platform driver
      hwmon: Document the new fan1_target interface file
      hwmon/smsc47m1: Convert to a platform driver
      hwmon/smsc47m1: Use DRVNAME consistently
      hwmon/smsc47m1: Use dynamic sysfs callbacks
      hwmon/lm78: No longer use i2c-isa
      hwmon/lm78: Be less i2c_client-centric
      hwmon/lm78: Use dynamic sysfs callbacks
      hwmon/lm75: Use dynamic sysfs callbacks
      hwmon/w83781d: No longer use i2c-isa
      hwmon/w83781d: Clean up conversion macros
      hwmon/w83781d: Be less i2c_client-centric
      hwmon/w83781d: Use dynamic sysfs callbacks
      hwmon/w83781d: Deprecate W83627HF support
      hwmon/smsc47b397: Convert to a platform driver
      hwmon/smsc47b397: Use dynamic sysfs callbacks

Nicolas Boichat (1):
      i386: Use functions from library in msr driver

Olaf Hering (1):
      hwmon/ams: Do not print error on systems without apple motion sensor

Rudolf Marek (4):
      hwmon-vid: Add support for VIA Esther
      i386: Add safe variants of rdmsr_on_cpu and wrmsr_on_cpu
      hwmon: New coretemp driver
      hwmon/coretemp: Add documentation

Stelian Pop (1):
      hwmon/ams: Fix I2C read retry logic

Thanks,
-- 
Jean Delvare
