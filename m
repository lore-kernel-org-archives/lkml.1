Return-Path: <linux-kernel-owner+w=401wt.eu-S1760784AbYAYITF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784AbYAYITF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764057AbYAYIAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:49 -0500
Received: from mail.suse.de ([195.135.220.2]:59458 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764052AbYAYH7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 141/196] USB: use proper call to driver_create_file
Date: Thu, 24 Jan 2008 23:32:50 -0800
Message-Id: <1201246425-5058-62-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't try to call the "raw" sysfs_create_file when we already have a
helper function to do this kind of work for us.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/core/driver.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index c51f8e9..7c3aaa9 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -91,8 +91,8 @@ static int usb_create_newid_file(struct usb_driver *usb_drv)
 		goto exit;
 
 	if (usb_drv->probe != NULL)
-		error = sysfs_create_file(&usb_drv->drvwrap.driver.kobj,
-					  &driver_attr_new_id.attr);
+		error = driver_create_file(&usb_drv->drvwrap.driver,
+					   &driver_attr_new_id);
 exit:
 	return error;
 }
@@ -103,8 +103,8 @@ static void usb_remove_newid_file(struct usb_driver *usb_drv)
 		return;
 
 	if (usb_drv->probe != NULL)
-		sysfs_remove_file(&usb_drv->drvwrap.driver.kobj,
-				  &driver_attr_new_id.attr);
+		driver_remove_file(&usb_drv->drvwrap.driver,
+				   &driver_attr_new_id);
 }
 
 static void usb_free_dynids(struct usb_driver *usb_drv)
-- 
1.5.3.8

