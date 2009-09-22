Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbZIVVx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbZIVVx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 17:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbZIVVx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 17:53:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:19066 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbZIVVx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 17:53:26 -0400
Subject: [GIT PULL] Regulator for 2.6.32
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 22:53:19 +0100
Message-Id: <1253656399.11624.842.camel@vega>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following regulator updates for 2.6.32. 

Highlights for 2.6.32 are new drivers for the TI TPS65023 and TPS6507x
PMICs. Other notable driver changes include list_voltage() support for
the DA903x and PCF50633. 

The regulator core also received regulator_get_exclusive() for client
drivers that require exclusive access to their supply regulators. Other
changes include better error reporting, fixes to constraint checking,
bug fixes and documentation clean ups.

Thanks

Liam

---

The following changes since commit 43c1266ce4dc06bfd236cec31e11e9ecd69c0bef:
  Linus Torvalds (1):
        Merge branch 'perfcounters-rename-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Anuj Aggarwal (3):
      Regulator: Add TPS65023 regulator driver
      Regulator: Add TPS6507x regulator driver
      Regulator: Adding TPS65023 and TPS6507x in Kconfig and Makefile

Felipe Balbi (1):
      regulator: userspace: use sysfs_create_group

Haojian Zhuang (5):
      regulator: add buck3 in da903x driver
      regulator: support da9030 BUCK in da903x driver
      regulator: replace ADTV1 register by ADTV2 in da903x
      regulator: support list voltage in da903x
      regulator: fix voltage range in da9034 ldo12

Joe Perches (1):
      drivers/regulator/pcf50633-regulator.c: Remove unnecessary semicolons

Lars-Peter Clausen (1):
      Regulator: Implement list_voltage for pcf50633 regulator driver.

Liam Girdwood (1):
      regulator: tps650xx - build fixes for x86_64

Linus Walleij (2):
      Fix some regulator documentation
      REGULATOR Handle positive returncode from enable

Mark Brown (16):
      regulator: Report regulator_get() failure in virtual consumer
      regulator: Make virtual consumer use dev_printk
      regulator: Make virtual consumer a bit more chatty
      regulator: Allow consumer supplies to be set up with dev_name()
      regulator: Define full constraints function with REGULATOR disabled
      regulator: Add regulator_get_exclusive() API
      regulator: Add regulator voltage range check API
      regulator: Warn when unregistering an in-use regulator
      regulator: Fix support for deviceless supply mappings
      regulator: Improve virtual consumer probe error handling
      regulator: More explict error reporting for fixed regulator
      regulator: Check for constraints before using them for name
      regulator: Check for constraints in regulator_init_complete()
      regulator: Push locking for regulator_is_enabled() out
      regulator: regulator_enable() permission checking
      regulator: Add some brief design documentation

Michael Prokop (1):
      drivers/regulator/Kconfig: fix typo (s/Usersapce/Userspace/) in REGULATOR_USERSPACE_CONSUMER description

Mike Rapoport (1):
      regulator: da903x: consolidate DA903[045]_DVC macros

Roel Kluin (2):
      regulator: add check index of wm8350->pmic.pdev[]
      regulator: fix calculation of voltage range in da9034_set_ldo12_voltage()

Roger Quadros (1):
      regulator: Add GPIO enable control to fixed voltage regulator driver

Wolfram Sang (5):
      regulator: update a filename in documentation
      regulator: fix typos
      regulator: drop 'default n'
      regulator/lp3971: drop unnecessary initialization
      regulator/driver: be more specific in nanodoc for is_enabled

roald (1):
      regulator: add initialization macro of regulator supply

 Documentation/power/regulator/design.txt    |   33 ++
 Documentation/power/regulator/machine.txt   |    4 +-
 Documentation/power/regulator/overview.txt  |    4 +-
 Documentation/power/regulator/regulator.txt |    5 +-
 drivers/regulator/Kconfig                   |   24 +-
 drivers/regulator/Makefile                  |    3 +
 drivers/regulator/core.c                    |  285 ++++++++---
 drivers/regulator/da903x.c                  |   77 +++-
 drivers/regulator/fixed.c                   |   91 ++++-
 drivers/regulator/lp3971.c                  |    2 +-
 drivers/regulator/pcf50633-regulator.c      |   98 +++--
 drivers/regulator/tps65023-regulator.c      |  632 ++++++++++++++++++++++++
 drivers/regulator/tps6507x-regulator.c      |  714 +++++++++++++++++++++++++++
 drivers/regulator/userspace-consumer.c      |   45 +-
 drivers/regulator/virtual.c                 |   56 ++-
 drivers/regulator/wm8350-regulator.c        |    2 +
 include/linux/mfd/da903x.h                  |    4 +-
 include/linux/regulator/consumer.h          |    4 +
 include/linux/regulator/driver.h            |    5 +-
 include/linux/regulator/fixed.h             |   24 +
 include/linux/regulator/machine.h           |   26 +-
 include/linux/regulator/max1586.h           |    4 +-
 22 files changed, 1966 insertions(+), 176 deletions(-)
 create mode 100644 Documentation/power/regulator/design.txt
 create mode 100644 drivers/regulator/tps65023-regulator.c
 create mode 100644 drivers/regulator/tps6507x-regulator.c


