Return-Path: <linux-kernel-owner+w=401wt.eu-S1759608AbZJMMHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608AbZJMMHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759050AbZJMMHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:07:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38857 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752415AbZJMMH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:07:29 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: Report error codes for bulk operations
Date: Tue, 13 Oct 2009 13:06:49 +0100
Message-Id: <1255435610-9765-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we're going to log an error we may as well log what the error
code that we're failing on is.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 942af6e..25e35c7 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1890,9 +1890,9 @@ int regulator_bulk_get(struct device *dev, int num_consumers,
 		consumers[i].consumer = regulator_get(dev,
 						      consumers[i].supply);
 		if (IS_ERR(consumers[i].consumer)) {
-			dev_err(dev, "Failed to get supply '%s'\n",
-				consumers[i].supply);
 			ret = PTR_ERR(consumers[i].consumer);
+			dev_err(dev, "Failed to get supply '%s': %d\n",
+				consumers[i].supply, ret);
 			consumers[i].consumer = NULL;
 			goto err;
 		}
@@ -1935,7 +1935,7 @@ int regulator_bulk_enable(int num_consumers,
 	return 0;
 
 err:
-	printk(KERN_ERR "Failed to enable %s\n", consumers[i].supply);
+	printk(KERN_ERR "Failed to enable %s: %d\n", consumers[i].supply, ret);
 	for (i = 0; i < num_consumers; i++)
 		regulator_disable(consumers[i].consumer);
 
@@ -1970,7 +1970,8 @@ int regulator_bulk_disable(int num_consumers,
 	return 0;
 
 err:
-	printk(KERN_ERR "Failed to disable %s\n", consumers[i].supply);
+	printk(KERN_ERR "Failed to disable %s: %d\n", consumers[i].supply,
+	       ret);
 	for (i = 0; i < num_consumers; i++)
 		regulator_enable(consumers[i].consumer);
 
-- 
1.6.4.3

