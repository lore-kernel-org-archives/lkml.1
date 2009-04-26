Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZDZJS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZDZJS0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 05:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZDZJSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 05:18:15 -0400
Received: from cathcart.site5.com ([74.54.107.137]:46399 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZDZJSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 05:18:14 -0400
From: Mike Rapoport <mike@compulab.co.il>
To: broonie@opensource.wolfsonmicro.com
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
       Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH 1/2] regulator: move regulator_consumer_supply from machine.h to consumer.h
Date: Sun, 26 Apr 2009 12:17:22 +0300
Message-Id: <d8276bd68d4bd06f1566e832b84c02528332048c.1240736991.git.mike@compulab.co.il>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <cover.1240736991.git.mike@compulab.co.il>
References: <cover.1240736991.git.mike@compulab.co.il>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 include/linux/regulator/consumer.h |   13 +++++++++++++
 include/linux/regulator/machine.h  |   14 +-------------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 277f4b9..3c7acb7 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -120,6 +120,19 @@ struct regulator_bulk_data {
 	struct regulator *consumer;
 };
 
+/**
+ * struct regulator_consumer_supply - supply -> device mapping
+ *
+ * This maps a supply name to a device.
+ *
+ * @dev: Device structure for the consumer.
+ * @supply: Name for the supply.
+ */
+struct regulator_consumer_supply {
+	struct device *dev;	/* consumer */
+	const char *supply;	/* consumer supply - e.g. "vcc" */
+};
+
 #if defined(CONFIG_REGULATOR)
 
 /* regulator get and put */
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index bac64fa..c64c833 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -19,6 +19,7 @@
 #include <linux/suspend.h>
 
 struct regulator;
+struct regulator_consumer_supply;
 
 /*
  * Regulator operation constraint flags. These flags are used to enable
@@ -124,19 +125,6 @@ struct regulation_constraints {
 };
 
 /**
- * struct regulator_consumer_supply - supply -> device mapping
- *
- * This maps a supply name to a device.
- *
- * @dev: Device structure for the consumer.
- * @supply: Name for the supply.
- */
-struct regulator_consumer_supply {
-	struct device *dev;	/* consumer */
-	const char *supply;	/* consumer supply - e.g. "vcc" */
-};
-
-/**
  * struct regulator_init_data - regulator platform initialisation data.
  *
  * Initialisation constraints, our supply and consumers supplies.
-- 
1.5.6.4

