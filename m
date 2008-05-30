Return-Path: <linux-kernel-owner+w=401wt.eu-S1761693AbYE3ESb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761693AbYE3ESb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761069AbYE3ERU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:17:20 -0400
Received: from mx1.suse.de ([195.135.220.2]:50770 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761158AbYE3ERO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:17:14 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/1] driver-core: prepare for 2.6.27 api change by adding dev_set_name
Date: Thu, 29 May 2008 21:16:23 -0700
Message-Id: <1212120984-15274-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080530041528.GA13743@suse.de>
References: <20080530041528.GA13743@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

Create the dev_set_name function now so that various subsystems can
start changing over to it before other changes in 2.6.27 will make it
compulsory.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c    |   15 +++++++++++++++
 include/linux/device.h |    3 +++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 72eccae..422cfca 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -760,6 +760,21 @@ static void device_remove_class_symlinks(struct device *dev)
 }
 
 /**
+ * dev_set_name - set a device name
+ * @dev: device
+ */
+int dev_set_name(struct device *dev, const char *fmt, ...)
+{
+	va_list vargs;
+
+	va_start(vargs, fmt);
+	vsnprintf(dev->bus_id, sizeof(dev->bus_id), fmt, vargs);
+	va_end(vargs);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dev_set_name);
+
+/**
  * device_add - add device to device hierarchy.
  * @dev: device.
  *
diff --git a/include/linux/device.h b/include/linux/device.h
index 14616e8..6a2d04c 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -385,6 +385,9 @@ static inline const char *dev_name(struct device *dev)
 	return dev->bus_id;
 }
 
+extern int dev_set_name(struct device *dev, const char *name, ...)
+			__attribute__((format(printf, 2, 3)));
+
 #ifdef CONFIG_NUMA
 static inline int dev_to_node(struct device *dev)
 {
-- 
1.5.5.1

