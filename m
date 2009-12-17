Return-Path: <linux-kernel-owner+w=401wt.eu-S964980AbZLQLQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964980AbZLQLQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 06:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964950AbZLQLQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 06:16:15 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:63453 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964956AbZLQLQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 06:16:14 -0500
Subject: [GIT PULL] regulator updates for 2.6.33
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 11:16:09 +0000
Message-ID: <1261048569.3687.70.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following regulator changes for 2.6.33.

Significant changes for 2.6.33 include the addition of the MAX8660 and
Marvell 88MP8607 PMIC drivers. Other noteworthy changes include improved
TI TWLxxxx and Wolfson WM83xx PMIC family support, better regulator bulk
operation error reporting, improved regulator suspend handling and
various bug fixes / clean ups.

Thanks

Liam 

---

The following changes since commit 718deb6b61e34c200c1f2b706176d9aac334cb2d:
  Al Viro (1):
        Fix breakage in shmem.c

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Alberto Panizzo (1):
      regulator: mc13783-regulator: correct the probing time.

Haojian Zhuang (1):
      regulator: add 88PM8607 PMIC driver

Juha Keski-Saari (6):
      twl-regulator: Add all twl4030 regulators to twlreg_info
      twl-regulator: Define critical regulators as always_on
      twl-regulator: Add turnon-delay and REMAP config to twlreg_info struct
      twl-regulator: Restore REMAP configuration in regulator probe
      twl-regulator: Add turnon delay to reg_enable
      twl-regulator: Fix reg_disable functionality for 4030 and 6030

Julia Lawall (1):
      drivers/regulator: use PTR_ERR to get error code

Lars-Peter Clausen (1):
      regulator: Fix unbalanced disables/enables in regulator_bulk_{enable,disable} error path

Liam Girdwood (1):
      regulator: consumer.h - fix build when consumer.h is #included first.

Linus Walleij (1):
      Fix some AB3100 regulator issues

Mark Brown (9):
      regulator: Implement WM831x BuckWise DC-DC convertor DVS support
      regulator: Report error codes for bulk operations
      regulator: Factor out voltage constraint setup
      regulator: Also lift apply_uV into machine_constraints_voltage()
      regulator: Display actual settings with constraints
      regulator: Factor out regulator name pretty printing
      regulator: Handle regulators without suspend mode configuration
      regulator: Remove duplicate consts from ab3100
      regulator: Ensure val is initialised in 88pm8607 choose_voltage()

Roel Kluin (2):
      regulator: keep index within bounds in da9034_get_ldo12_voltage()
      regulator: wm831x_reg_read() failure unnoticed in wm831x_aldo_get_mode()

Stefan Roese (1):
      regulator: core.c: Small coding style cleanup (indentation fixup)

Uwe Kleine-König (2):
      regulator/mc13783: rename source file to match other drivers
      regulator/mc13783: various cleanups

Wolfram Sang (1):
      regulator: add driver for MAX8660/8661

 drivers/regulator/88pm8607.c          |  685 +++++++++++++++++++++++++++++++++
 drivers/regulator/Kconfig             |   13 +
 drivers/regulator/Makefile            |    4 +-
 drivers/regulator/ab3100.c            |   33 +--
 drivers/regulator/core.c              |  248 +++++++-----
 drivers/regulator/da903x.c            |    2 +-
 drivers/regulator/lp3971.c            |    4 +-
 drivers/regulator/max8660.c           |  510 ++++++++++++++++++++++++
 drivers/regulator/mc13783-regulator.c |  245 ++++++++++++
 drivers/regulator/mc13783.c           |  410 --------------------
 drivers/regulator/twl-regulator.c     |  147 +++++---
 drivers/regulator/wm831x-dcdc.c       |  207 +++++++++-
 drivers/regulator/wm831x-ldo.c        |    2 +-
 include/linux/mfd/wm831x/pdata.h      |   17 +
 include/linux/regulator/consumer.h    |    2 +
 include/linux/regulator/machine.h     |    6 +-
 include/linux/regulator/max8660.h     |   57 +++
 17 files changed, 1981 insertions(+), 611 deletions(-)
 create mode 100644 drivers/regulator/88pm8607.c
 create mode 100644 drivers/regulator/max8660.c
 create mode 100644 drivers/regulator/mc13783-regulator.c
 delete mode 100644 drivers/regulator/mc13783.c
 create mode 100644 include/linux/regulator/max8660.h


