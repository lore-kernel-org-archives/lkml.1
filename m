Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbYLaMxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbYLaMxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 07:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYLaMwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 07:52:54 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1071 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbYLaMwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 07:52:53 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 31 Dec 2008 12:52:42 +0000
Message-Id: <1230727964-9268-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1230727964-9268-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20081231125114.GC6596@sirena.org.uk>
 <1230727964-9268-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1230727964-9268-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 3/5] regulator: Add missing kerneldoc
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is only the documentation that the kerneldoc system warns about.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c          |    1 +
 include/linux/regulator/driver.h  |   40 +++++++++++++++++++++++++++++++++++-
 include/linux/regulator/machine.h |   41 +++++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index ea12c68..fda4400 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -656,6 +656,7 @@ static void print_constraints(struct regulator_dev *rdev)
 /**
  * set_machine_constraints - sets regulator constraints
  * @rdev: regulator source
+ * @constraints: constraints to apply
  *
  * Allows platform initialisation code to define and constrain
  * regulator circuits e.g. valid voltage/current ranges, etc.  NOTE:
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index e37d805..84c3737 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -24,7 +24,37 @@ struct regulator_init_data;
 /**
  * struct regulator_ops - regulator operations.
  *
- * This struct describes regulator operations.
+ * This struct describes regulator operations which can be implemented by
+ * regulator chip drivers.
+ *
+ * @enable: Enable the regulator.
+ * @disable: Disable the regulator.
+ * @is_enabled: Return 1 if the reguator is enabled, 0 otherwise.
+ *
+ * @set_voltage: Set the voltage for the regulator within the range specified.
+ *               The driver should select the voltage closest to min_uV.
+ * @get_voltage: Return the currently configured voltage for the regulator.
+ *
+ * @set_current: Set the current for the regulator within the range specified.
+ *               The driver should select the current closest to min_uA.
+ * @get_current: Return the currently configured current for the regulator.
+ *
+ * @set_current_limit: Configure a limit for a current-limited regulator.
+ * @get_current_limit: Get the limit for a current-limited regulator.
+ *
+ * @set_mode: Set the operating mode for the regulator.
+ * @get_mode: Get the current operating mode for the regulator.
+ * @get_optimum_mode: Get the most efficient operating mode for the regulator
+ *                    when running with the specified parameters.
+ *
+ * @set_suspend_voltage: Set the voltage for the regulator when the system
+ *                       is suspended.
+ * @set_suspend_enable: Mark the regulator as enabled when the system is
+ *                      suspended.
+ * @set_suspend_disable: Mark the regulator as disabled when the system is
+ *                       suspended.
+ * @set_suspend_mode: Set the operating mode for the regulator when the
+ *                    system is suspended.
  */
 struct regulator_ops {
 
@@ -75,6 +105,14 @@ enum regulator_type {
 /**
  * struct regulator_desc - Regulator descriptor
  *
+ * Each regulator registered with the core is described with a structure of
+ * this type.
+ *
+ * @name: Identifying name for the regulator.
+ * @id: Numerical identifier for the regulator.
+ * @ops: Regulator operations table.
+ * @type: Indicates if the regulator is a voltage or current regulator.
+ * @owner: Module providing the regulator, used for refcounting.
  */
 struct regulator_desc {
 	const char *name;
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index c6d6933..3794773 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -44,6 +44,10 @@ struct regulator;
  * struct regulator_state - regulator state during low power syatem states
  *
  * This describes a regulators state during a system wide low power state.
+ *
+ * @uV: Operating voltage during suspend.
+ * @mode: Operating mode during suspend.
+ * @enabled: Enabled during suspend.
  */
 struct regulator_state {
 	int uV;	/* suspend voltage */
@@ -55,6 +59,30 @@ struct regulator_state {
  * struct regulation_constraints - regulator operating constraints.
  *
  * This struct describes regulator and board/machine specific constraints.
+ *
+ * @name: Descriptive name for the constraints, used for display purposes.
+ *
+ * @min_uV: Smallest voltage consumers may set.
+ * @max_uV: Largest voltage consumers may set.
+ *
+ * @min_uA: Smallest consumers consumers may set.
+ * @max_uA: Largest current consumers may set.
+ *
+ * @valid_modes_mask: Mask of modes which may be configured by consumers.
+ * @valid_ops_mask: Operations which may be performed by consumers.
+ *
+ * @always_on: Set if the regulator should never be disabled.
+ * @boot_on: Set if the regulator is enabled when the system is initially
+ *           started.
+ * @apply_uV: Apply the voltage constraint when initialising.
+ *
+ * @input_uV: Input voltage for regulator when supplied by another regulator.
+ *
+ * @state_disk: State for regulator when system is suspended in disk mode.
+ * @state_mem: State for regulator when system is suspended in mem mode.
+ * @state_standby: State for regulator when system is suspended in standby
+ *                 mode.
+ * @initial_state: Suspend state to set by default.
  */
 struct regulation_constraints {
 
@@ -93,6 +121,9 @@ struct regulation_constraints {
  * struct regulator_consumer_supply - supply -> device mapping
  *
  * This maps a supply name to a device.
+ *
+ * @dev: Device structure for the consumer.
+ * @supply: Name for the supply.
  */
 struct regulator_consumer_supply {
 	struct device *dev;	/* consumer */
@@ -103,6 +134,16 @@ struct regulator_consumer_supply {
  * struct regulator_init_data - regulator platform initialisation data.
  *
  * Initialisation constraints, our supply and consumers supplies.
+ *
+ * @supply_regulator_dev: Parent regulator (if any).
+ *
+ * @constraints: Constraints.  These must be specified for the regulator to
+ *               be usable.
+ * @num_consumer_supplies: Number of consumer device supplies.
+ * @consumer_supplies: Consumer device supply configuration.
+ *
+ * @regulator_init: Callback invoked when the regulator has been registered.
+ * @driver_data: Data passed to regulator_init.
  */
 struct regulator_init_data {
 	struct device *supply_regulator_dev; /* or NULL for LINE */
-- 
1.5.6.3

