Return-Path: <linux-kernel-owner+w=401wt.eu-S1751689AbXLELuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbXLELuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 06:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbXLELuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 06:50:32 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:33819 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbXLELua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 06:50:30 -0500
Date: Wed, 5 Dec 2007 12:50:28 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Ursula Braun <ubraun@linux.vnet.ibm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [patch 2/3] netiucv: Use device_driver default attribute groups.
Message-ID: <20071205125028.026a617d@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071205114119.905238262@de.ibm.com>
References: <20071205114119.905238262@de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Ursula Braun <ubraun@linux.vnet.ibm.com>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/s390/net/netiucv.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

--- linux-2.6.orig/drivers/s390/net/netiucv.c
+++ linux-2.6/drivers/s390/net/netiucv.c
@@ -2089,6 +2089,11 @@ static struct attribute_group netiucv_dr
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

