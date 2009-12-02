Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbZLBNcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbZLBNcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZLBNcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:32:31 -0500
Received: from smtp.nokia.com ([192.100.105.134]:64966 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbZLBNca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:32:30 -0500
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       List Linux Omap <linux-omap@vger.kernel.org>
Subject: [PATCH] mfd: twl4030: clarify the return value for read and write
Date: Wed,  2 Dec 2009 15:31:18 +0200
Message-Id: <1259760678-18707-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 02 Dec 2009 13:31:23.0496 (UTC) FILETIME=[BDA97680:01CA7353]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should be checking if all the messages were tranferred or not. Currently we
return success even if none of messages were transferred successfully.

Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
---
 drivers/mfd/twl4030-core.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
index cf462b9..6ace378 100644
--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -298,10 +298,12 @@ int twl4030_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 	ret = i2c_transfer(twl->client->adapter, twl->xfer_msg, 1);
 	mutex_unlock(&twl->xfer_lock);
 
-	/* i2cTransfer returns num messages.translate it pls.. */
-	if (ret >= 0)
-		ret = 0;
-	return ret;
+	/* i2c_transfer returns number of messages transferred */
+	if (ret != 1) {
+		pr_err("%s: twl4030_i2c_write failed to transfer all messages\n", DRIVER_NAME);
+		return ret;
+	} else
+		return 0;
 }
 EXPORT_SYMBOL(twl4030_i2c_write);
 
@@ -350,10 +352,13 @@ int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 	ret = i2c_transfer(twl->client->adapter, twl->xfer_msg, 2);
 	mutex_unlock(&twl->xfer_lock);
 
-	/* i2cTransfer returns num messages.translate it pls.. */
-	if (ret >= 0)
-		ret = 0;
-	return ret;
+	/* i2c_transfer returns number of messages transferred */
+	if (ret != 2) {
+		pr_err("%s: twl4030_i2c_read failed to transfer all messages\n", DRIVER_NAME);
+		return ret;
+	}
+	else
+		return 0;
 }
 EXPORT_SYMBOL(twl4030_i2c_read);
 
-- 
1.6.3.3

