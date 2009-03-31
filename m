Return-Path: <linux-kernel-owner+w=401wt.eu-S1760444AbZCaO2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760444AbZCaO2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZCaO2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:28:45 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:59220 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbZCaO2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:28:44 -0400
Subject: [GIT PULL] Regulator changes for 2.6.30
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 31 Mar 2009 15:28:41 +0100
Message-Id: <1238509721.12172.26.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the voltage regulator changes for 2.6.30. The changes
include a new twl4030 regulator driver, improved regulator init_data
handling, refcount fixes, some new voltage API functions and numerous
minor fixes.

The following changes since commit 15f7176eb1cccec0a332541285ee752b935c1c85:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Adrian Hunter (1):
      regulator: twl4030 VAUX3 supports 3.0V

Andrew Morton (1):
      regulator: minor cleanup of virtual consumer

David Brownell (10):
      regulator: minor cleanup of virtual consumer
      regulator: add get_status()
      regulator: enumerate voltages (v2)
      regulator: get_status() grows kerneldoc
      regulator: twl4030 regulators
      regulator: twl4030 voltage enumeration (v2)
      MMC: regulator utilities
      twl4030-regulator: list more VAUX4 voltages
      regulator: refcount fixes
      twl4030-regulator: expose VPLL2

Jonathan Cameron (1):
      Regulator: Push lock out of _notifier_call_chain + add voltage change event.

Liam Girdwood (1):
      regulator: email - update email address and regulator webpage.

Mark Brown (16):
      regulator: Pass regulator init data as explict argument when registering
      regulator: Allow init data to be supplied for bq24022
      regulator: Allow init_data to be passed to fixed voltage regulators
      regulator: Make fixed voltage regulators visible in Kconfig
      regulator: Mark attributes table for virtual regulator static
      regulator: Hoist struct regulator_dev out of core to fix notifiers
      regulator: Suggest use of datasheet supply or pin names for consumers
      regulator: Allow regulators to set the initial operating mode
      regulator: Fix get_mode() for WM835x DCDCs
      regulator: Implement list_voltage() for WM8400 DCDCs and LDOs
      regulator: Don't warn on omitted voltage constraints
      regulator: Implement list_voltage for WM835x LDOs and DCDCs
      regulator: Allow boot_on regulators to be disabled by clients
      regulator: Don't warn if we failed to get a regulator
      regulator: Don't increment use_count for boot_on regulators
      regulator: Support disabling of unused regulators by machines

Mike Rapoport (1):
      regulator: add unset_regulator_supplies to fix regulator_unregister

Randy Dunlap (1):
      regulator: fix header file missing kernel-doc

 Documentation/ABI/testing/sysfs-class-regulator |   57 +++-
 MAINTAINERS                                     |    2 +-
 drivers/mfd/twl4030-core.c                      |    2 -
 drivers/mmc/core/core.c                         |  100 +++++
 drivers/regulator/Kconfig                       |   13 +-
 drivers/regulator/Makefile                      |    1 +
 drivers/regulator/bq24022.c                     |    3 +-
 drivers/regulator/core.c                        |  386 ++++++++++++++----
 drivers/regulator/da903x.c                      |    3 +-
 drivers/regulator/fixed.c                       |    3 +-
 drivers/regulator/pcf50633-regulator.c          |    3 +-
 drivers/regulator/twl4030-regulator.c           |  500 +++++++++++++++++++++++
 drivers/regulator/virtual.c                     |   14 +-
 drivers/regulator/wm8350-regulator.c            |   57 +++-
 drivers/regulator/wm8400-regulator.c            |   36 ++-
 include/linux/i2c/twl4030.h                     |   47 +++
 include/linux/mmc/host.h                        |    5 +
 include/linux/regulator/bq24022.h               |    3 +
 include/linux/regulator/consumer.h              |    6 +-
 include/linux/regulator/driver.h                |   81 ++++-
 include/linux/regulator/fixed.h                 |    3 +
 include/linux/regulator/machine.h               |   12 +-
 22 files changed, 1220 insertions(+), 117 deletions(-)
 create mode 100644 drivers/regulator/twl4030-regulator.c


