Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbYHURhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbYHURhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758914AbYHURha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:37:30 -0400
Received: from mx1.suse.de ([195.135.220.2]:47778 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760058AbYHURh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:37:28 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/15] dev_printk(): constify the `dev' argument
Date: Thu, 21 Aug 2008 10:32:53 -0700
Message-Id: <1219339983-9634-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20080821173036.GB7974@suse.de>
References: <20080821173036.GB7974@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

Add const markings to dev_name and dev_driver_string to make it clear that
dev_printk doesn't modify dev.  This is a prerequisite to adding more
const markings to other functions make it clearer, which functions can
modify dev and which can't.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c    |    2 +-
 include/linux/device.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 068aa1c..44bad73 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -53,7 +53,7 @@ static inline int device_is_not_partition(struct device *dev)
  * it is attached to.  If it is not attached to a bus either, an empty
  * string will be returned.
  */
-const char *dev_driver_string(struct device *dev)
+const char *dev_driver_string(const struct device *dev)
 {
 	return dev->driver ? dev->driver->name :
 			(dev->bus ? dev->bus->name :
diff --git a/include/linux/device.h b/include/linux/device.h
index d24a47f..a701c1b 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -406,7 +406,7 @@ struct device {
 /* Get the wakeup routines, which depend on struct device */
 #include <linux/pm_wakeup.h>
 
-static inline const char *dev_name(struct device *dev)
+static inline const char *dev_name(const struct device *dev)
 {
 	/* will be changed into kobject_name(&dev->kobj) in the near future */
 	return dev->bus_id;
@@ -518,7 +518,7 @@ extern void device_shutdown(void);
 extern void sysdev_shutdown(void);
 
 /* debugging and troubleshooting/diagnostic helpers. */
-extern const char *dev_driver_string(struct device *dev);
+extern const char *dev_driver_string(const struct device *dev);
 #define dev_printk(level, dev, format, arg...)	\
 	printk(level "%s %s: " format , dev_driver_string(dev) , \
 	       dev_name(dev) , ## arg)
-- 
1.5.6.5

