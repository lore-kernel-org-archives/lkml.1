Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbXGOUEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbXGOUEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 16:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757452AbXGOUBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 16:01:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39954 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662AbXGOUBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 16:01:22 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] missing argument in bin_attribute ->read()/->write()
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Message-Id: <E1IAAHS-00056e-0q@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 15 Jul 2007 21:01:22 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fallout from commit 91a6902958f052358899f58683d44e36228d85c2

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/s390/kernel/ipl.c        |   10 +++++-----
 drivers/i2c/chips/ds1682.c    |    8 ++++----
 drivers/w1/slaves/w1_ds2760.c |    4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 9a13b24..8b8f136 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -295,8 +295,8 @@ static ssize_t sys_ipl_device_show(struct kset *kset, char *page)
 static struct subsys_attribute sys_ipl_device_attr =
 	__ATTR(device, S_IRUGO, sys_ipl_device_show, NULL);
 
-static ssize_t ipl_parameter_read(struct kobject *kobj, char *buf, loff_t off,
-				  size_t count)
+static ssize_t ipl_parameter_read(struct kobject *kobj, struct bin_attribute *attr,
+				  char *buf, loff_t off, size_t count)
 {
 	unsigned int size = IPL_PARMBLOCK_SIZE;
 
@@ -317,8 +317,8 @@ static struct bin_attribute ipl_parameter_attr = {
 	.read = &ipl_parameter_read,
 };
 
-static ssize_t ipl_scp_data_read(struct kobject *kobj, char *buf, loff_t off,
-	size_t count)
+static ssize_t ipl_scp_data_read(struct kobject *kobj, struct bin_attribute *attr,
+				 char *buf, loff_t off, size_t count)
 {
 	unsigned int size = IPL_PARMBLOCK_START->ipl_info.fcp.scp_data_len;
 	void *scp_data = &IPL_PARMBLOCK_START->ipl_info.fcp.scp_data;
@@ -337,7 +337,7 @@ static struct bin_attribute ipl_scp_data_attr = {
 		.mode = S_IRUGO,
 	},
 	.size = PAGE_SIZE,
-	.read = &ipl_scp_data_read,
+	.read = ipl_scp_data_read,
 };
 
 /* FCP ipl device attributes */
diff --git a/drivers/i2c/chips/ds1682.c b/drivers/i2c/chips/ds1682.c
index 25fd467..5879f0f 100644
--- a/drivers/i2c/chips/ds1682.c
+++ b/drivers/i2c/chips/ds1682.c
@@ -140,8 +140,8 @@ static const struct attribute_group ds1682_group = {
 /*
  * User data attribute
  */
-static ssize_t ds1682_eeprom_read(struct kobject *kobj, char *buf, loff_t off,
-				  size_t count)
+static ssize_t ds1682_eeprom_read(struct kobject *kobj, struct bin_attribute *attr,
+				  char *buf, loff_t off, size_t count)
 {
 	struct i2c_client *client = kobj_to_i2c_client(kobj);
 	int rc;
@@ -163,8 +163,8 @@ static ssize_t ds1682_eeprom_read(struct kobject *kobj, char *buf, loff_t off,
 	return count;
 }
 
-static ssize_t ds1682_eeprom_write(struct kobject *kobj, char *buf, loff_t off,
-				   size_t count)
+static ssize_t ds1682_eeprom_write(struct kobject *kobj, struct bin_attribute *attr,
+				   char *buf, loff_t off, size_t count)
 {
 	struct i2c_client *client = kobj_to_i2c_client(kobj);
 
diff --git a/drivers/w1/slaves/w1_ds2760.c b/drivers/w1/slaves/w1_ds2760.c
index 88a37fb..1f2b1a4 100644
--- a/drivers/w1/slaves/w1_ds2760.c
+++ b/drivers/w1/slaves/w1_ds2760.c
@@ -68,8 +68,8 @@ int w1_ds2760_write(struct device *dev, char *buf, int addr, size_t count)
 	return w1_ds2760_io(dev, buf, addr, count, 1);
 }
 
-static ssize_t w1_ds2760_read_bin(struct kobject *kobj, char *buf, loff_t off,
-				  size_t count)
+static ssize_t w1_ds2760_read_bin(struct kobject *kobj, struct bin_attribute *attr,
+				  char *buf, loff_t off, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	return w1_ds2760_read(dev, buf, off, count);
-- 
1.5.3.GIT


