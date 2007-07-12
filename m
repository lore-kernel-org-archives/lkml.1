Return-Path: <linux-kernel-owner+w=401wt.eu-S932689AbXGLMgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689AbXGLMgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758640AbXGLMgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:36:14 -0400
Received: from smtp-104-thursday.nerim.net ([62.4.16.104]:59677 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755362AbXGLMgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:36:13 -0400
Date: Thu, 12 Jul 2007 14:36:38 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c updates for 2.6.23
Message-ID: <20070712143638.4d1f4daf@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the i2c subsystem updates for Linux 2.6.23 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

We have two new bus drivers (i2c-pmcmsp for the PMC MSP71xx and
i2c-taos-evm for the TAOS evaluation modules), two new chip drivers
(ds1682 for the Dallas DS1682 elapsed time recorder and tsl2550 for the
TAOS TSL2550 light sensor), speed improvements for i2c-i801 block
transactions and new DocBook documentation. And as usual, cleanups and
fixes all around the place.

Other changes worth mentioning:
* Many embedded I2C bus drivers have been converted to support the
new-style i2c drivers introduced in 2.6.22.
* The i2c_smbus_read_i2c_block_data() function has a new prototype,
finally letting the caller ask for a specific block length.

 Documentation/DocBook/kernel-api.tmpl      |   55 +++
 Documentation/feature-removal-schedule.txt |    7 +
 Documentation/i2c/busses/i2c-i801          |    4 +-
 Documentation/i2c/busses/i2c-piix4         |    2 +-
 Documentation/i2c/busses/i2c-taos-evm      |   46 ++
 Documentation/i2c/chips/max6875            |    2 +-
 Documentation/i2c/chips/x1205              |   38 --
 Documentation/i2c/summary                  |    2 -
 Documentation/i2c/writing-clients          |    2 +-
 drivers/i2c/algos/Kconfig                  |    4 -
 drivers/i2c/busses/Kconfig                 |   31 ++-
 drivers/i2c/busses/Makefile                |    3 +-
 drivers/i2c/busses/i2c-gpio.c              |   12 +-
 drivers/i2c/busses/i2c-i801.c              |  249 +++++++----
 drivers/i2c/busses/i2c-iop3xx.c            |    3 +-
 drivers/i2c/busses/i2c-mpc.c               |   26 +-
 drivers/i2c/busses/i2c-mv64xxx.c           |    3 +-
 drivers/i2c/busses/i2c-nforce2.c           |   44 ++-
 drivers/i2c/busses/i2c-piix4.c             |    4 +-
 drivers/i2c/busses/i2c-pmcmsp.c            |  653 ++++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-powermac.c          |    3 +-
 drivers/i2c/busses/i2c-pxa.c               |    9 +-
 drivers/i2c/busses/i2c-rpx.c               |  101 -----
 drivers/i2c/busses/i2c-savage4.c           |   21 +-
 drivers/i2c/busses/i2c-sis5595.c           |   27 +-
 drivers/i2c/busses/i2c-taos-evm.c          |  330 ++++++++++++++
 drivers/i2c/busses/i2c-viapro.c            |    2 +-
 drivers/i2c/busses/scx200_acb.c            |   16 +-
 drivers/i2c/chips/Kconfig                  |   35 ++-
 drivers/i2c/chips/Makefile                 |    2 +
 drivers/i2c/chips/ds1682.c                 |  259 +++++++++++
 drivers/i2c/chips/eeprom.c                 |    6 +-
 drivers/i2c/chips/max6875.c                |    1 +
 drivers/i2c/chips/tsl2550.c                |  460 ++++++++++++++++++++
 drivers/i2c/i2c-core.c                     |   25 +-
 drivers/i2c/i2c-dev.c                      |    9 +
 drivers/macintosh/windfarm_smu_sat.c       |   28 +-
 drivers/rtc/rtc-x1205.c                    |    5 +-
 drivers/video/matrox/matroxfb_crtc2.h      |    2 -
 include/linux/i2c.h                        |   19 +-
 include/linux/pci_ids.h                    |    1 +
 include/linux/serio.h                      |    1 +
 42 files changed, 2222 insertions(+), 330 deletions(-)
 create mode 100644 Documentation/i2c/busses/i2c-taos-evm
 delete mode 100644 Documentation/i2c/chips/x1205
 create mode 100644 drivers/i2c/busses/i2c-pmcmsp.c
 delete mode 100644 drivers/i2c/busses/i2c-rpx.c
 create mode 100644 drivers/i2c/busses/i2c-taos-evm.c
 create mode 100644 drivers/i2c/chips/ds1682.c
 create mode 100644 drivers/i2c/chips/tsl2550.c

---------------

Atsushi Nemoto (2):
      i2c-gpio: Add support for new-style clients
      i2c-gpio: Make some internal functions static

Dale Farnsworth (1):
      i2c-mv64xxx: Use i2c_add_numbered_adapter

David Brownell (1):
      i2c: Add kernel documentation

Domen Puncer (1):
      i2c-mpc: work around missing-9th-clock-pulse bug

Grant Likely (2):
      i2c: New DS1682 chip driver
      i2c-mpc: Use i2c_add_numbered_adapter

Henry Su (1):
      i2c-piix4: Add support for the ATI SB700

Jean Delvare (9):
      i2c: Delete outdated x1205 driver documentation
      i2c: Deprecate legacy RTC drivers
      i2c: Fix the i2c_smbus_read_i2c_block_data() prototype
      matroxfb: Clean-up i2c header inclusions
      i2c-sis5595: Resolve resource conflict with sis5595
      i2c: New bus driver for the TAOS evaluation modules
      i2c/tsl2550: Speed up initialization
      i2c-savage4: Delete many unused defines
      i2c-rpx: Remove

Marc St-Jean (1):
      i2c: New PMC MSP71xx TWI bus driver

Mark M. Hoffman (1):
      i2c: Fix sparse warning in i2c.h

Martin Michlmayr (1):
      i2c-iop3xx: Switch to static adapter numbering

Matthias Kaehlcke (1):
      scx200_acb: Use mutex instead of semaphore

Oleg Ryjkov (3):
      i2c-nforce2: Add support for SMBus block transactions
      i2c-i801: Various cleanups
      i2c-i801: Use the internal 32-byte buffer on ICH4+

Rodolfo Giometti (2):
      i2c-pxa: Support new-style I2C drivers
      i2c: Add support for the TSL2550

Thanks,
-- 
Jean Delvare
