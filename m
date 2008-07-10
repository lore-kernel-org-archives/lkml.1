Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbYGJP3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbYGJP3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756901AbYGJP1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:27:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45167 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759287AbYGJP1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:27:35 -0400
Subject: [PATCH 14/15] regulator: core - added system suspend state sysfs
	entries. (new for V5)
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 16:27:33 +0100
Message-Id: <1215703653.13431.70.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow regulator suspend state and voltage to be published to
userspace via sysfs. Note: suspend state config API for consumers
has still to be added.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
---
 Documentation/ABI/testing/sysfs-class-regulator |  128 +++++++++++++++++++++
 drivers/regulator/core.c                        |  140 ++++++++++++++++++++++-
 include/linux/regulator/driver.h                |   13 ++
 3 files changed, 280 insertions(+), 1 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-regulator b/Documentation/ABI/testing/sysfs-class-regulator
index 4655927..79a4a75 100644
--- a/Documentation/ABI/testing/sysfs-class-regulator
+++ b/Documentation/ABI/testing/sysfs-class-regulator
@@ -185,3 +185,131 @@ Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
 Description:
 		Some regulator directories will contain a link called parent.
 		This points to the parent or supply regulator if one exists.
+
+What:		/sys/class/regulator/.../suspend_mem_microvolts
+Date:		May 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		suspend_mem_microvolts. This holds the regulator output
+		voltage setting for this domain measured in microvolts when
+		the system is suspended to memory.
+
+		NOTE: this will return the string 'not defined' if
+		the power domain has no suspend to memory voltage defined by
+		platform code.
+
+What:		/sys/class/regulator/.../suspend_disk_microvolts
+Date:		May 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		suspend_disk_microvolts. This holds the regulator output
+		voltage setting for this domain measured in microvolts when
+		the system is suspended to disk.
+
+		NOTE: this will return the string 'not defined' if
+		the power domain has no suspend to disk voltage defined by
+		platform code.
+
+What:		/sys/class/regulator/.../suspend_standby_microvolts
+Date:		May 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		suspend_standby_microvolts. This holds the regulator output
+		voltage setting for this domain measured in microvolts when
+		the system is suspended to standby.
+
+		NOTE: this will return the string 'not defined' if
+		the power domain has no suspend to standby voltage defined by
+		platform code.
+
+What:		/sys/class/regulator/.../suspend_mem_mode
+Date:		May 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		suspend_mem_mode. This holds the regulator operating mode
+		setting for this domain when the system is suspended to
+		memory.
+
+		NOTE: this will return the string 'not defined' if
+		the power domain has no suspend to memory mode defined by
+		platform code.
+
+What:		/sys/class/regulator/.../suspend_disk_mode
+Date:		May 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		suspend_disk_mode. This holds the regulator operating mode
+		setting for this domain when the system is suspended to disk.
+
+		NOTE: this will return the string 'not defined' if
+		the power domain has no suspend to disk mode defined by
+		platform code.
+
+What:		/sys/class/regulator/.../suspend_standby_mode
+Date:		May 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		suspend_standby_mode. This holds the regulator operating mode
+		setting for this domain when the system is suspended to
+		standby.
+
+		NOTE: this will return the string 'not defined' if
+		the power domain has no suspend to standby mode defined by
+		platform code.
+
+What:		/sys/class/regulator/.../suspend_mem_state
+Date:		May 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		suspend_mem_state. This holds the regulator operating state
+		when suspended to memory.
+
+		This will be one of the following strings:
+
+		'enabled'
+		'disabled'
+		'not defined'
+
+What:		/sys/class/regulator/.../suspend_disk_state
+Date:		May 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		suspend_disk_state. This holds the regulator operating state
+		when suspended to disk.
+
+		This will be one of the following strings:
+
+		'enabled'
+		'disabled'
+		'not defined'
+
+What:		/sys/class/regulator/.../suspend_standby_state
+Date:		May 2008
+KernelVersion:	2.6.26
+Contact:	Liam Girdwood <lg@opensource.wolfsonmicro.com>
+Description:
+		Each regulator directory will contain a field called
+		suspend_standby_state. This holds the regulator operating
+		state when suspended to standby.
+
+		This will be one of the following strings:
+
+		'enabled'
+		'disabled'
+		'not defined'
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index da77b05..50fc224 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -338,7 +338,7 @@ static ssize_t regulator_total_uA_show(struct device *dev,
 }
 
 static ssize_t regulator_num_users_show(struct device *dev,
-				       struct device_attribute *attr, char *buf)
+				      struct device_attribute *attr, char *buf)
 {
 	struct regulator_dev *rdev = to_rdev(dev);
 	return sprintf(buf, "%d\n", rdev->use_count);
@@ -358,6 +358,126 @@ static ssize_t regulator_type_show(struct device *dev,
 	return sprintf(buf, "unknown\n");
 }
 
+static ssize_t regulator_suspend_mem_uV_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = to_rdev(dev);
+
+	if (!rdev->constraints)
+		return sprintf(buf, "not defined\n");
+	return sprintf(buf, "%d\n", rdev->constraints->state_mem.uV);
+}
+
+static ssize_t regulator_suspend_disk_uV_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = to_rdev(dev);
+
+	if (!rdev->constraints)
+		return sprintf(buf, "not defined\n");
+	return sprintf(buf, "%d\n", rdev->constraints->state_disk.uV);
+}
+
+static ssize_t regulator_suspend_standby_uV_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = to_rdev(dev);
+
+	if (!rdev->constraints)
+		return sprintf(buf, "not defined\n");
+	return sprintf(buf, "%d\n", rdev->constraints->state_standby.uV);
+}
+
+static ssize_t suspend_opmode_show(struct regulator_dev *rdev,
+	unsigned int mode, char *buf)
+{
+	switch (mode) {
+	case REGULATOR_MODE_FAST:
+		return sprintf(buf, "fast\n");
+	case REGULATOR_MODE_NORMAL:
+		return sprintf(buf, "normal\n");
+	case REGULATOR_MODE_IDLE:
+		return sprintf(buf, "idle\n");
+	case REGULATOR_MODE_STANDBY:
+		return sprintf(buf, "standby\n");
+	}
+	return sprintf(buf, "unknown\n");
+}
+
+static ssize_t regulator_suspend_mem_mode_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = to_rdev(dev);
+
+	if (!rdev->constraints)
+		return sprintf(buf, "not defined\n");
+	return suspend_opmode_show(rdev,
+		rdev->constraints->state_mem.mode, buf);
+}
+
+static ssize_t regulator_suspend_disk_mode_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = to_rdev(dev);
+
+	if (!rdev->constraints)
+		return sprintf(buf, "not defined\n");
+	return suspend_opmode_show(rdev,
+		rdev->constraints->state_disk.mode, buf);
+}
+
+static ssize_t regulator_suspend_standby_mode_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = to_rdev(dev);
+
+	if (!rdev->constraints)
+		return sprintf(buf, "not defined\n");
+	return suspend_opmode_show(rdev,
+		rdev->constraints->state_standby.mode, buf);
+}
+
+static ssize_t regulator_suspend_mem_state_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = to_rdev(dev);
+
+	if (!rdev->constraints)
+		return sprintf(buf, "not defined\n");
+
+	if (rdev->constraints->state_mem.enabled)
+		return sprintf(buf, "enabled\n");
+	else
+		return sprintf(buf, "disabled\n");
+}
+
+static ssize_t regulator_suspend_disk_state_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = to_rdev(dev);
+
+	if (!rdev->constraints)
+		return sprintf(buf, "not defined\n");
+
+	if (rdev->constraints->state_disk.enabled)
+		return sprintf(buf, "enabled\n");
+	else
+		return sprintf(buf, "disabled\n");
+}
+
+static ssize_t regulator_suspend_standby_state_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct regulator_dev *rdev = to_rdev(dev);
+
+	if (!rdev->constraints)
+		return sprintf(buf, "not defined\n");
+
+	if (rdev->constraints->state_standby.enabled)
+		return sprintf(buf, "enabled\n");
+	else
+		return sprintf(buf, "disabled\n");
+}
 static struct device_attribute regulator_dev_attrs[] = {
 	__ATTR(microvolts, 0444, regulator_uV_show, NULL),
 	__ATTR(microamps, 0444, regulator_uA_show, NULL),
@@ -370,6 +490,24 @@ static struct device_attribute regulator_dev_attrs[] = {
 	__ATTR(requested_microamps, 0444, regulator_total_uA_show, NULL),
 	__ATTR(num_users, 0444, regulator_num_users_show, NULL),
 	__ATTR(type, 0444, regulator_type_show, NULL),
+	__ATTR(suspend_mem_microvolts, 0444,
+		regulator_suspend_mem_uV_show, NULL),
+	__ATTR(suspend_disk_microvolts, 0444,
+		regulator_suspend_disk_uV_show, NULL),
+	__ATTR(suspend_standby_microvolts, 0444,
+		regulator_suspend_standby_uV_show, NULL),
+	__ATTR(suspend_mem_mode, 0444,
+		regulator_suspend_mem_mode_show, NULL),
+	__ATTR(suspend_disk_mode, 0444,
+		regulator_suspend_disk_mode_show, NULL),
+	__ATTR(suspend_standby_mode, 0444,
+		regulator_suspend_standby_mode_show, NULL),
+	__ATTR(suspend_mem_state, 0444,
+		regulator_suspend_mem_state_show, NULL),
+	__ATTR(suspend_disk_state, 0444,
+		regulator_suspend_disk_state_show, NULL),
+	__ATTR(suspend_standby_state, 0444,
+		regulator_suspend_standby_state_show, NULL),
 	__ATTR_NULL,
 };
 
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 1c02362..1d712c7 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -49,6 +49,19 @@ struct regulator_ops {
 	/* get most efficient regulator operating mode for load */
 	unsigned int (*get_optimum_mode) (struct regulator_dev *, int input_uV,
 					  int output_uV, int load_uA);
+
+	/* the operations below are for configuration of regulator state when
+	 * it's parent PMIC enters a global STANBY/HIBERNATE state */
+
+	/* set regulator suspend voltage */
+	int (*set_suspend_voltage) (struct regulator_dev *, int uV);
+
+	/* enable/disable regulator in suspend state */
+	int (*set_suspend_enable) (struct regulator_dev *);
+	int (*set_suspend_disable) (struct regulator_dev *);
+
+	/* set regulator suspend operating mode (defined in regulator.h) */
+	int (*set_suspend_mode) (struct regulator_dev *, unsigned int mode);
 };
 
 /*
-- 
1.5.4.3



