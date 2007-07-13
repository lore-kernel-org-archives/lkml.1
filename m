Return-Path: <linux-kernel-owner+w=401wt.eu-S936496AbXGMJWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936496AbXGMJWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763328AbXGMJWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:22:10 -0400
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:1214 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763270AbXGMJWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:22:09 -0400
Date: Fri, 13 Jul 2007 11:22:33 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH] i2c/ds1682: Fix binary file callback signatures
Message-ID: <20070713112233.28561e65@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 91a6902958f052358899f58683d44e36228d85c2 changed the binary
sysfs file signatures at the same time the ds1682 driver was added.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/i2c/chips/ds1682.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- linux-2.6.23-pre.orig/drivers/i2c/chips/ds1682.c	2007-07-13 09:46:20.000000000 +0200
+++ linux-2.6.23-pre/drivers/i2c/chips/ds1682.c	2007-07-13 11:14:59.000000000 +0200
@@ -140,8 +140,9 @@ static const struct attribute_group ds16
 /*
  * User data attribute
  */
-static ssize_t ds1682_eeprom_read(struct kobject *kobj, char *buf, loff_t off,
-				  size_t count)
+static ssize_t ds1682_eeprom_read(struct kobject *kobj,
+				  struct bin_attribute *bin_attr, char *buf,
+				  loff_t off, size_t count)
 {
 	struct i2c_client *client = kobj_to_i2c_client(kobj);
 	int rc;
@@ -163,8 +164,9 @@ static ssize_t ds1682_eeprom_read(struct
 	return count;
 }
 
-static ssize_t ds1682_eeprom_write(struct kobject *kobj, char *buf, loff_t off,
-				   size_t count)
+static ssize_t ds1682_eeprom_write(struct kobject *kobj,
+				   struct bin_attribute *bin_attr, char *buf,
+				   loff_t off, size_t count)
 {
 	struct i2c_client *client = kobj_to_i2c_client(kobj);
 


-- 
Jean Delvare
