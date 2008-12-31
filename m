Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbYLaMx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbYLaMx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 07:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920AbYLaMw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 07:52:57 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1074 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815AbYLaMw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 07:52:56 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 31 Dec 2008 12:52:41 +0000
Message-Id: <1230727964-9268-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1230727964-9268-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20081231125114.GC6596@sirena.org.uk>
 <1230727964-9268-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 2/5] regulator: Clean up kerneldoc warnings
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove kerneldoc warnings that don't relate to missing documentation,
mostly by renaming parameters in the documentation to match their
actual names.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c           |   44 ++++++++++++++++++------------------
 include/linux/regulator/consumer.h |    8 +++---
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 7ba9491..ea12c68 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -655,7 +655,7 @@ static void print_constraints(struct regulator_dev *rdev)
 
 /**
  * set_machine_constraints - sets regulator constraints
- * @regulator: regulator source
+ * @rdev: regulator source
  *
  * Allows platform initialisation code to define and constrain
  * regulator circuits e.g. valid voltage/current ranges, etc.  NOTE:
@@ -730,8 +730,8 @@ out:
 
 /**
  * set_supply - set regulator supply regulator
- * @regulator: regulator name
- * @supply: supply regulator name
+ * @rdev: regulator name
+ * @supply_rdev: supply regulator name
  *
  * Called by platform initialisation code to set the supply regulator for this
  * regulator. This ensures that a regulators supply will also be enabled by the
@@ -758,9 +758,9 @@ out:
 
 /**
  * set_consumer_device_supply: Bind a regulator to a symbolic supply
- * @regulator: regulator source
- * @dev:       device the supply applies to
- * @supply:    symbolic name for supply
+ * @rdev:         regulator source
+ * @consumer_dev: device the supply applies to
+ * @supply:       symbolic name for supply
  *
  * Allows platform initialisation code to map physical regulator
  * sources to symbolic names for supplies for use by devices.  Devices
@@ -1013,9 +1013,8 @@ static int _regulator_enable(struct regulator_dev *rdev)
  *
  * Enable the regulator output at the predefined voltage or current value.
  * NOTE: the output value can be set by other drivers, boot loader or may be
- * hardwired in the regulator.
- * NOTE: calls to regulator_enable() must be balanced with calls to
- * regulator_disable().
+ * hardwired in the regulator.  Calls to regulator_enable() must be balanced
+ * with calls to regulator_disable().
  */
 int regulator_enable(struct regulator *regulator)
 {
@@ -1074,10 +1073,10 @@ static int _regulator_disable(struct regulator_dev *rdev)
  * @regulator: regulator source
  *
  * Disable the regulator output voltage or current.
+ *
  * NOTE: this will only disable the regulator output if no other consumer
- * devices have it enabled.
- * NOTE: calls to regulator_enable() must be balanced with calls to
- * regulator_disable().
+ * devices have it enabled.  Calls to regulator_enable() must be balanced with
+ * calls to regulator_disable().
  */
 int regulator_disable(struct regulator *regulator)
 {
@@ -1200,7 +1199,7 @@ EXPORT_SYMBOL_GPL(regulator_is_enabled);
  *
  * NOTE: If the regulator is shared between several devices then the lowest
  * request voltage that meets the system constraints will be used.
- * NOTE: Regulator system constraints must be set for this regulator before
+ * Regulator system constraints must be set for this regulator before
  * calling this function otherwise this call will fail.
  */
 int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
@@ -1498,7 +1497,7 @@ EXPORT_SYMBOL_GPL(regulator_set_optimum_mode);
 /**
  * regulator_register_notifier - register regulator event notifier
  * @regulator: regulator source
- * @notifier_block: notifier block
+ * @nb: notifier block
  *
  * Register notifier block to receive regulator events.
  */
@@ -1513,7 +1512,7 @@ EXPORT_SYMBOL_GPL(regulator_register_notifier);
 /**
  * regulator_unregister_notifier - unregister regulator event notifier
  * @regulator: regulator source
- * @notifier_block: notifier block
+ * @nb: notifier block
  *
  * Unregister regulator event notifier block.
  */
@@ -1679,9 +1678,9 @@ EXPORT_SYMBOL_GPL(regulator_bulk_free);
 
 /**
  * regulator_notifier_call_chain - call regulator event notifier
- * @regulator: regulator source
+ * @rdev: regulator source
  * @event: notifier block
- * @data:
+ * @data: callback-specific data.
  *
  * Called by regulator drivers to notify clients a regulator event has
  * occurred. We also notify regulator clients downstream.
@@ -1808,8 +1807,9 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
 
 /**
  * regulator_register - register regulator
- * @regulator: regulator source
- * @reg_data: private regulator data
+ * @regulator_desc: regulator to register
+ * @dev: struct device for the regulator
+ * @driver_data: private regulator data
  *
  * Called by regulator drivers to register a regulator.
  * Returns 0 on success.
@@ -1916,7 +1916,7 @@ EXPORT_SYMBOL_GPL(regulator_register);
 
 /**
  * regulator_unregister - unregister regulator
- * @regulator: regulator source
+ * @rdev: regulator to unregister
  *
  * Called by regulator drivers to unregister a regulator.
  */
@@ -1971,7 +1971,7 @@ EXPORT_SYMBOL_GPL(regulator_suspend_prepare);
 
 /**
  * rdev_get_drvdata - get rdev regulator driver data
- * @regulator: regulator
+ * @rdev: regulator
  *
  * Get rdev regulator driver private data. This call can be used in the
  * regulator driver context.
@@ -2008,7 +2008,7 @@ EXPORT_SYMBOL_GPL(regulator_set_drvdata);
 
 /**
  * regulator_get_id - get regulator ID
- * @regulator: regulator
+ * @rdev: regulator
  */
 int rdev_get_id(struct regulator_dev *rdev)
 {
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index afdc455..801bf77 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -104,10 +104,10 @@ struct regulator;
 /**
  * struct regulator_bulk_data - Data used for bulk regulator operations.
  *
- * @supply   The name of the supply.  Initialised by the user before
- *           using the bulk regulator APIs.
- * @consumer The regulator consumer for the supply.  This will be managed
- *           by the bulk API.
+ * @supply:   The name of the supply.  Initialised by the user before
+ *            using the bulk regulator APIs.
+ * @consumer: The regulator consumer for the supply.  This will be managed
+ *            by the bulk API.
  *
  * The regulator APIs provide a series of regulator_bulk_() API calls as
  * a convenience to consumers which require multiple supplies.  This
-- 
1.5.6.3

