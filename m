Return-Path: <linux-kernel-owner+w=401wt.eu-S1761914AbYEBRRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761914AbYEBRRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 13:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbYEBRRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 13:17:04 -0400
Received: from ns.suse.de ([195.135.220.2]:52066 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963AbYEBRRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 13:17:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/1] driver-core: add dev_name() to help transition away from using bus_id
Date: Fri,  2 May 2008 10:16:46 -0700
Message-Id: <1209748606-25575-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080502171550.GA25405@suse.de>
References: <20080502171550.GA25405@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/device.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 832fb0e..8c23e3d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -380,6 +380,12 @@ struct device {
 /* Get the wakeup routines, which depend on struct device */
 #include <linux/pm_wakeup.h>
 
+static inline const char *dev_name(struct device *dev)
+{
+	/* will be changed into kobject_name(&dev->kobj) in the near future */
+	return dev->bus_id;
+}
+
 #ifdef CONFIG_NUMA
 static inline int dev_to_node(struct device *dev)
 {
@@ -478,7 +484,7 @@ extern void sysdev_shutdown(void);
 extern const char *dev_driver_string(struct device *dev);
 #define dev_printk(level, dev, format, arg...)	\
 	printk(level "%s %s: " format , dev_driver_string(dev) , \
-	       (dev)->bus_id , ## arg)
+	       dev_name(dev) , ## arg)
 
 #define dev_emerg(dev, format, arg...)		\
 	dev_printk(KERN_EMERG , dev , format , ## arg)
-- 
1.5.5.1

