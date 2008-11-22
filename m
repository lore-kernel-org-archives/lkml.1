Return-Path: <linux-kernel-owner+w=401wt.eu-S1759889AbYKVRnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889AbYKVRnS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759825AbYKVRiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:38:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58503 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759547AbYKVRiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:38:15 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 30/32] get xenbus_driver ->probe() "recognized" by modpost
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wQw-0006fX-Mz@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:38:14 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... by giving the instances' names magic suffix recognized by modpost ;-/
Their ->probe() is __devinit

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/input/xen-kbdfront.c |    6 +++---
 drivers/net/xen-netfront.c   |    6 +++---
 drivers/video/xen-fbfront.c  |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -323,7 +323,7 @@ static struct xenbus_device_id xenkbd_ids[] = {
 	{ "" }
 };
 
-static struct xenbus_driver xenkbd = {
+static struct xenbus_driver xenkbd_driver = {
 	.name = "vkbd",
 	.owner = THIS_MODULE,
 	.ids = xenkbd_ids,
@@ -342,12 +342,12 @@ static int __init xenkbd_init(void)
 	if (xen_initial_domain())
 		return -ENODEV;
 
-	return xenbus_register_frontend(&xenkbd);
+	return xenbus_register_frontend(&xenkbd_driver);
 }
 
 static void __exit xenkbd_cleanup(void)
 {
-	xenbus_unregister_driver(&xenkbd);
+	xenbus_unregister_driver(&xenkbd_driver);
 }
 
 module_init(xenkbd_init);
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1785,7 +1785,7 @@ static int __devexit xennet_remove(struct xenbus_device *dev)
 	return 0;
 }
 
-static struct xenbus_driver netfront = {
+static struct xenbus_driver netfront_driver = {
 	.name = "vif",
 	.owner = THIS_MODULE,
 	.ids = netfront_ids,
@@ -1805,7 +1805,7 @@ static int __init netif_init(void)
 
 	printk(KERN_INFO "Initialising Xen virtual ethernet driver.\n");
 
-	return xenbus_register_frontend(&netfront);
+	return xenbus_register_frontend(&netfront_driver);
 }
 module_init(netif_init);
 
@@ -1815,7 +1815,7 @@ static void __exit netif_exit(void)
 	if (xen_initial_domain())
 		return;
 
-	xenbus_unregister_driver(&netfront);
+	xenbus_unregister_driver(&netfront_driver);
 }
 module_exit(netif_exit);
 
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -668,7 +668,7 @@ static struct xenbus_device_id xenfb_ids[] = {
 	{ "" }
 };
 
-static struct xenbus_driver xenfb = {
+static struct xenbus_driver xenfb_driver = {
 	.name = "vfb",
 	.owner = THIS_MODULE,
 	.ids = xenfb_ids,
@@ -687,12 +687,12 @@ static int __init xenfb_init(void)
 	if (xen_initial_domain())
 		return -ENODEV;
 
-	return xenbus_register_frontend(&xenfb);
+	return xenbus_register_frontend(&xenfb_driver);
 }
 
 static void __exit xenfb_cleanup(void)
 {
-	xenbus_unregister_driver(&xenfb);
+	xenbus_unregister_driver(&xenfb_driver);
 }
 
 module_init(xenfb_init);
