Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbZBRPLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbZBRPLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 10:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZBRPLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 10:11:41 -0500
Received: from mail-gx0-f222.google.com ([209.85.217.222]:50896 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbZBRPLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:11:40 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] Export device_add_attributes() so drivers can use it.
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Date: Wed, 18 Feb 2009 08:11:34 -0700
Message-ID: <20090218151132.476.81706.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

I find myself using the pattern of device_add_attributes() and
device_remove_attributes() frequently in my drivers.  Rather than
reinventing the wheel every time, I'm floating this patch to export
the symbols to see how it is received.  If this looks okay then I'll
rework my drivers and post additional patches to use these functions.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@suse.de>
---

 drivers/base/core.c    |   10 ++++++----
 include/linux/device.h |    4 ++++
 2 files changed, 10 insertions(+), 4 deletions(-)


diff --git a/drivers/base/core.c b/drivers/base/core.c
index f3eae63..5393eb6 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -302,8 +302,8 @@ out:
 static struct device_attribute uevent_attr =
 	__ATTR(uevent, S_IRUGO | S_IWUSR, show_uevent, store_uevent);
 
-static int device_add_attributes(struct device *dev,
-				 struct device_attribute *attrs)
+int device_add_attributes(struct device *dev,
+			  struct device_attribute *attrs)
 {
 	int error = 0;
 	int i;
@@ -320,9 +320,10 @@ static int device_add_attributes(struct device *dev,
 	}
 	return error;
 }
+EXPORT_SYMBOL(device_add_attributes);
 
-static void device_remove_attributes(struct device *dev,
-				     struct device_attribute *attrs)
+void device_remove_attributes(struct device *dev,
+			      struct device_attribute *attrs)
 {
 	int i;
 
@@ -330,6 +331,7 @@ static void device_remove_attributes(struct device *dev,
 		for (i = 0; attr_name(attrs[i]); i++)
 			device_remove_file(dev, &attrs[i]);
 }
+EXPORT_SYMBOL(device_remove_attributes);
 
 static int device_add_groups(struct device *dev,
 			     struct attribute_group **groups)
diff --git a/include/linux/device.h b/include/linux/device.h
index 45e5b19..2a64d84 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -310,6 +310,10 @@ extern int __must_check device_create_file(struct device *device,
 					   struct device_attribute *entry);
 extern void device_remove_file(struct device *dev,
 			       struct device_attribute *attr);
+extern int device_add_attributes(struct device *dev,
+				 struct device_attribute *attrs);
+extern void device_remove_attributes(struct device *dev,
+				     struct device_attribute *attrs);
 extern int __must_check device_create_bin_file(struct device *dev,
 					       struct bin_attribute *attr);
 extern void device_remove_bin_file(struct device *dev,

