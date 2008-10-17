Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbYJQP7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbYJQP7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbYJQP7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:59:07 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:42801 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbYJQP7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:59:06 -0400
Date: Fri, 17 Oct 2008 17:58:55 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [PATCH] hwmon updates for 2.6.28
Message-ID: <20081017175855.4fc377ed@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem updates for Linux 2.6.28 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 hwmon-for-linus

In the absence of a maintainer for the hwmon subsystem, I have gathered
a number of patches which have been posted to the lm-sensors mailing
list over the past few months and reviewed publicly. This will ensure
that these patches, which I consider ready for upstream, aren't lost,
so developers can spend their time to something else than resending
these patches over and over again. This will also make an hypothetical
future hwmon subsystem maintainer's job easier by limiting the backlog
he or she would have to go through.

I've also added a few patches I wrote myself and which haven't been
reviewed, but which are so trivial that delaying them would be stupid.

 Documentation/hwmon/adt7470       |   76 +++
 Documentation/hwmon/it87          |    4 +-
 Documentation/hwmon/lm85          |   10 -
 Documentation/hwmon/lm87          |    9 +-
 Documentation/hwmon/lm90          |   45 ++-
 Documentation/hwmon/pc87360       |    7 +-
 Documentation/hwmon/pc87427       |    2 +-
 Documentation/hwmon/w83781d       |   37 ++-
 Documentation/hwmon/w83791d       |   43 ++-
 drivers/hwmon/Kconfig             |    8 +-
 drivers/hwmon/adm1026.c           |   17 +-
 drivers/hwmon/adm1029.c           |    5 +-
 drivers/hwmon/ams/ams-core.c      |   82 ++--
 drivers/hwmon/ams/ams-i2c.c       |   60 +--
 drivers/hwmon/ams/ams-input.c     |   63 ++-
 drivers/hwmon/ams/ams-pmu.c       |   18 +-
 drivers/hwmon/ams/ams.h           |    4 +-
 drivers/hwmon/ibmaem.c            |    7 +
 drivers/hwmon/ibmpex.c            |    6 +
 drivers/hwmon/it87.c              |   11 +-
 drivers/hwmon/lm78.c              |  270 ++++++-----
 drivers/hwmon/lm85.c              |  352 +++++++-------
 drivers/hwmon/lm87.c              |   33 +-
 drivers/hwmon/lm90.c              |  444 ++++++++++++-----
 drivers/hwmon/max1619.c           |   17 +-
 drivers/hwmon/w83781d.c           |  976 ++++++++++++++++++++-----------------
 drivers/hwmon/w83791d.c           |  324 ++++++++++++-
 drivers/i2c/busses/i2c-powermac.c |   29 ++
 28 files changed, 1864 insertions(+), 1095 deletions(-)
 create mode 100644 Documentation/hwmon/adt7470

---------------

Andrew Morton (1):
      hwmon: (max1619) Use inline functions instead of macros

Ben Hutchings (5):
      hwmon: (lm90) Rename temperature conversion functions to match usage
      hwmon: (lm90) Support MAX6646, MAX6647 and MAX6649
      hwmon: (lm87) Fix masking of config register in lm87_init_client()
      hwmon: (lm87) Restore original configuration register on removal
      hwmon: (lm87) Add support for configuration through platform_data

Corentin Labbe (1):
      hwmon: (adm1029) Use mask for fan_div value

Darrick J. Wong (3):
      hwmon: (ibmpex) Automatically load on IBM systems via DMI
      hwmon: (ibmaem) Automatically load on IBM systems via DMI
      hwmon: (adt7470) Add documentation

Dmitry Torokhov (3):
      hwmon: (ams) Fix permissions on 'joystick' module parameter
      hwmon: (ams) Fix locking issues
      hwmon: (ams) Simplify IRQ handling routine

Jean Delvare (26):
      hwmon: (lm90) Move 16-bit value read to a separate function
      hwmon: (lm90) Support the extra resolution bits of MAX6657
      hwmon: (lm90) Don't access nonexistent registers on Maxim chips
      hwmon: (lm90) Update datasheet links
      hwmon: (lm90) Don't spam the kernel log
      hwmon: (ams) Convert to a new-style i2c driver
      hwmon: (lm85) Rework the device detection
      hwmon: (lm85) Implement the standard PWM frequency interface
      hwmon: (lm85) Select the closest PWM frequency
      hwmon: (lm85) Support different PWM frequency tables
      hwmon: (lm85) Convert to a new-style i2c driver
      hwmon: (lm85) Simplify RANGE_TO_REG
      hwmon: (lm85) Better label names
      hwmon: (lm78) Fix I/O resource conflict with PNP
      hwmon: (lm78) Detect alias chips
      hwmon: (lm78) Prevent misdetection of Winbond chips
      hwmon: (lm78) Stop abusing struct i2c_client for ISA devices
      hwmon: (lm78) Convert to a new-style i2c driver
      hwmon: (it87) Fix thermal sensor type values
      hwmon: Drop dead links to old National Semiconductor chip datasheets
      hwmon: (w83781d) Refactor beep enable handling
      hwmon: (w83781d) Detect alias chips
      hwmon: (w83781d) Additional information about AS99127F PWM
      hwmon: (w83781d) Stop abusing struct i2c_client for ISA devices
      hwmon: (adm1026) Fix debug messages
      hwmon: (adm1026) Prevent log spamming

Marc Hulsman (4):
      hwmon: (w83791d) fan 4/5 pins can also be used for gpio
      hwmon: (w83791d) add manual PWM support
      hwmon: (w83791d) add pwm_enable support
      hwmon: (w83791d) add support for thermal cruise mode

Nate Case (2):
      hwmon: (lm90) Convert some macros to static functions
      hwmon: (lm90) Support ADT7461 in extended mode

Wolfgang Grandegger (2):
      hwmon: (w83781d) Make ISA interface depend on CONFIG_ISA
      hwmon: (w83781d) Use new style driver binding

Thanks,
-- 
Jean Delvare
