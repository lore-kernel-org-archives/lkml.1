Return-Path: <linux-kernel-owner+w=401wt.eu-S932287AbYAYIZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbYAYIZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759687AbYAYIBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764089AbYAYH7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ursula Braun <ubraun@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 146/196] netiucv: Use device_driver default attribute groups.
Date: Thu, 24 Jan 2008 23:32:55 -0800
Message-Id: <1201246425-5058-67-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

CC: Ursula Braun <ubraun@linux.vnet.ibm.com>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/s390/net/netiucv.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index c7ea938..d6e93f1 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -2089,6 +2089,11 @@ static struct attribute_group netiucv_drv_attr_group = {
 	.attrs = netiucv_drv_attrs,
 };
 
+static struct attribute_group *netiucv_drv_attr_groups[] = {
+	&netiucv_drv_attr_group,
+	NULL,
+};
+
 static void netiucv_banner(void)
 {
 	PRINT_INFO("NETIUCV driver initialized\n");
@@ -2113,7 +2118,6 @@ static void __exit netiucv_exit(void)
 		netiucv_unregister_device(dev);
 	}
 
-	sysfs_remove_group(&netiucv_driver.kobj, &netiucv_drv_attr_group);
 	driver_unregister(&netiucv_driver);
 	iucv_unregister(&netiucv_handler, 1);
 	iucv_unregister_dbf_views();
@@ -2133,6 +2137,7 @@ static int __init netiucv_init(void)
 	if (rc)
 		goto out_dbf;
 	IUCV_DBF_TEXT(trace, 3, __FUNCTION__);
+	netiucv_driver.groups = netiucv_drv_attr_groups;
 	rc = driver_register(&netiucv_driver);
 	if (rc) {
 		PRINT_ERR("NETIUCV: failed to register driver.\n");
@@ -2140,18 +2145,9 @@ static int __init netiucv_init(void)
 		goto out_iucv;
 	}
 
-	rc = sysfs_create_group(&netiucv_driver.kobj, &netiucv_drv_attr_group);
-	if (rc) {
-		PRINT_ERR("NETIUCV: failed to add driver attributes.\n");
-		IUCV_DBF_TEXT_(setup, 2,
-			       "ret %d - netiucv_drv_attr_group\n", rc);
-		goto out_driver;
-	}
 	netiucv_banner();
 	return rc;
 
-out_driver:
-	driver_unregister(&netiucv_driver);
 out_iucv:
 	iucv_unregister(&netiucv_handler, 1);
 out_dbf:
-- 
1.5.3.8

