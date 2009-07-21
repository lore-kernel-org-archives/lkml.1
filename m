Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbZGUPAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbZGUPAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbZGUPAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:00:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42580 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753974AbZGUPAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:00:33 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 6/6] regulator: Provide mode to status conversion function
Date: Tue, 21 Jul 2009 16:00:28 +0100
Message-Id: <1248188428-11277-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248188428-11277-5-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1248188428-11277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248188428-11277-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248188428-11277-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248188428-11277-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248188428-11277-5-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is useful for implementing get_status() in terms of get_mode().

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c         |   24 ++++++++++++++++++++++++
 include/linux/regulator/driver.h |    2 ++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index cba10ec..13d0f92 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1993,6 +1993,30 @@ int regulator_notifier_call_chain(struct regulator_dev *rdev,
 }
 EXPORT_SYMBOL_GPL(regulator_notifier_call_chain);
 
+/**
+ * regulator_mode_to_status - convert a regulator mode into a status
+ *
+ * @mode: Mode to convert
+ *
+ * Convert a regulator mode into a status.
+ */
+int regulator_mode_to_status(unsigned int mode)
+{
+	switch (mode) {
+	case REGULATOR_MODE_FAST:
+		return REGULATOR_STATUS_FAST;
+	case REGULATOR_MODE_NORMAL:
+		return REGULATOR_STATUS_NORMAL;
+	case REGULATOR_MODE_IDLE:
+		return REGULATOR_STATUS_IDLE;
+	case REGULATOR_STATUS_STANDBY:
+		return REGULATOR_STATUS_STANDBY;
+	default:
+		return 0;
+	}
+}
+EXPORT_SYMBOL_GPL(regulator_mode_to_status);
+
 /*
  * To avoid cluttering sysfs (and memory) with useless state, only
  * create attributes that can be meaningfully displayed.
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 60efbd1..73c9cd6 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -195,6 +195,8 @@ void *rdev_get_drvdata(struct regulator_dev *rdev);
 struct device *rdev_get_dev(struct regulator_dev *rdev);
 int rdev_get_id(struct regulator_dev *rdev);
 
+int regulator_mode_to_status(unsigned int);
+
 void *regulator_get_init_drvdata(struct regulator_init_data *reg_init_data);
 
 #endif
-- 
1.6.3.3

