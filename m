Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbZADXNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbZADXNQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZADXM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:12:59 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:59106 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbZADXM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:12:58 -0500
Date: Mon, 5 Jan 2009 00:15:28 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Mike Rapoport <mike@compulab.co.il>
Subject: [GIT] MFD pull request
Message-ID: <20090104231528.GA2585@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull the MFD updates for rc1 ? Thanks in advance.

The following changes since commit 7d3b56ba37a95f1f370f50258ed3954c304c524b:
  Linus Torvalds (1):
        Merge branch 'cpus4096-for-linus-3' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.o-hand.com/linux-mfd for-next

David Brownell (8):
      mfd: allow reading entire register banks on twl4030
      mfd: twl4030: simplified child creation code
      mfd: twl4030: cleanup symbols and OMAP dependency
      mfd: twl4030: create some regulator devices
      mfd: twl4030 regulator bug fixes
      mfd: dm355evm msp430 driver
      mfd: move drivers/i2c/chips/tps65010.c to drivers/mfd
      mfd: move drivers/i2c/chips/menelaus.c to drivers/mfd

Mark Brown (18):
      mfd: Don't mark WM8350 security register as volatile
      mfd: Remove i.MX31ism from WM8350 i2c driver
      mfd: Add some documentation for WM8350 register lock
      mfd: Add WM8350 revision H support
      mfd: Add AUXADC support for WM8350
      power_supply: Add support for WM8350 PMU
      mfd: Switch WM8350 revision detection to a feature based model
      mfd: Refactor WM8350 chip identification
      power_supply: Add cold to the POWER_SUPPLY_HEALTH report values
      power_supply: Add battery health reporting for WM8350
      mfd: Pass driver_data onto child devices
      mfd: Register WM8400 codec device
      mfd: Add WM8352 support
      mfd: Handle missing WM8350 platform data
      mfd: Support configurable numbers of DCDCs and ISINKs on WM8350
      mfd: Add WM8351 support
      mfd: Add missing break from wm3850-core
      mfd: Fix section mismatch in da903x

Mike Rapoport (2):
      mfd: Dialog DA9030 battery charger MFD driver
      power_supply: Add Dialog DA9030 battery charger driver

Samuel Ortiz (2):
      mfd: Fix twl4030-core.c build error
      mfd: Use irq_to_desc in twl4030 code

 drivers/i2c/chips/Kconfig             |   23 -
 drivers/i2c/chips/Makefile            |    2 -
 drivers/mfd/Kconfig                   |   66 +-
 drivers/mfd/Makefile                  |    7 +-
 drivers/mfd/da903x.c                  |   16 +-
 drivers/mfd/dm355evm_msp.c            |  420 +++++++
 drivers/{i2c/chips => mfd}/menelaus.c |    0
 drivers/mfd/mfd-core.c                |    1 +
 drivers/{i2c/chips => mfd}/tps65010.c |    0
 drivers/mfd/twl4030-core.c            |  472 ++++----
 drivers/mfd/twl4030-irq.c             |   30 +-
 drivers/mfd/wm8350-core.c             |  266 ++++-
 drivers/mfd/wm8350-i2c.c              |    4 +-
 drivers/mfd/wm8350-regmap.c           | 2100 ++++++++++++++++++++++++++++++++-
 drivers/mfd/wm8400-core.c             |   31 +-
 drivers/power/Kconfig                 |   14 +
 drivers/power/Makefile                |    2 +
 drivers/power/da9030_battery.c        |  600 ++++++++++
 drivers/power/power_supply_sysfs.c    |    2 +-
 drivers/power/wm8350_power.c          |  532 +++++++++
 drivers/regulator/wm8350-regulator.c  |    7 +
 include/linux/i2c/dm355evm_msp.h      |   79 ++
 include/linux/i2c/twl4030.h           |   81 +-
 include/linux/mfd/da903x.h            |   44 +-
 include/linux/mfd/wm8350/comparator.h |    8 +
 include/linux/mfd/wm8350/core.h       |   52 +-
 include/linux/mfd/wm8350/pmic.h       |    4 +
 include/linux/mfd/wm8350/supply.h     |   25 +-
 include/linux/power_supply.h          |    1 +
 29 files changed, 4546 insertions(+), 343 deletions(-)
 create mode 100644 drivers/mfd/dm355evm_msp.c
 rename drivers/{i2c/chips => mfd}/menelaus.c (100%)
 rename drivers/{i2c/chips => mfd}/tps65010.c (100%)
 create mode 100644 drivers/power/da9030_battery.c
 create mode 100644 drivers/power/wm8350_power.c
 create mode 100644 include/linux/i2c/dm355evm_msp.h

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
