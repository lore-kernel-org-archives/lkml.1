Return-Path: <linux-kernel-owner+w=401wt.eu-S933788AbYBTVYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbYBTVYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765064AbYBTVX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:23:27 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:56453 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761570AbYBTVXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:23:24 -0500
Date: Wed, 20 Feb 2008 13:21:00 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh <greg@kroah.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 2/2] firmware: fix a few build errors
Message-Id: <20080220132100.c168fc20.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix one typo (comma to semi-colon).
Fix sysfs externs (just use sysfs.h for prototypes).

Documentation/firmware_class/firmware_sample_firmware_class.c:37: error: conflicting types for 'sysfs_remove_bin_file'
include/linux/sysfs.h:100: error: previous declaration of 'sysfs_remove_bin_file' was here

Still has a build error:
ERROR: "firmware_class" [samples/firmware_class/firmware_sample_firmware_class.ko]
undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 samples/firmware_class/firmware_sample_firmware_class.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- linux-2625-rc2-docsrc.orig/samples/firmware_class/firmware_sample_firmware_class.c
+++ linux-2625-rc2-docsrc/samples/firmware_class/firmware_sample_firmware_class.c
@@ -33,9 +33,6 @@ struct class_device_attribute *to_class_
 	return container_of(_attr,struct class_device_attribute,attr);
 }
 
-int sysfs_create_bin_file(struct kobject * kobj, struct bin_attribute * attr);
-int sysfs_remove_bin_file(struct kobject * kobj, struct bin_attribute * attr);
-
 struct firmware_priv {
 	char fw_id[FIRMWARE_NAME_MAX];
 	s32 loading:2;
@@ -127,7 +124,7 @@ static int fw_setup_class_device(struct 
 	class_dev->class_id[BUS_ID_SIZE-1] = '\0';
 	class_dev->dev = device;
 
-	class_dev->class = &firmware_class,
+	class_dev->class = &firmware_class;
 	class_set_devdata(class_dev, fw_priv);
 	retval = class_device_register(class_dev);
 	if (retval){
