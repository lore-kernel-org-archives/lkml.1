Return-Path: <linux-kernel-owner+w=401wt.eu-S1761398AbXGEQyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761398AbXGEQyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 12:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761000AbXGEQya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 12:54:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:30484 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760920AbXGEQy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 12:54:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=KPjrz9DZPzskF4D7HU7fjlUOtRDes0DU4A2dywyO93o/Jp/Y4DxE1mV5ppPnaYLcxeKFsKShQzVqG6+Cl+KabE27jh2c+CiLsDvNUJYkoHgaD2R1gesrYBZjOoI2DWMjL6yvyrsSyjTncodMCgc3vNW2xgCpsgbGHgMPfaCMbJc=
Date: Thu, 5 Jul 2007 20:54:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/4] Sky Cpu and Nexus: code style improvement
Message-ID: <20070705165420.GB7180@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes useless spaces and adds
some empty lines to make code more readable.
Also marker for printk is added.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 drivers/misc/hdpuftrs/hdpu_cpustate.c |   51 +++++++++++++++-----------------
 drivers/misc/hdpuftrs/hdpu_nexus.c    |   24 +++++++++------
 2 files changed, 38 insertions(+), 37 deletions(-)
 
@@ -169,22 +170,21 @@ static struct platform_driver hdpu_cpustate_driver = {
  *	The various file operations we support.
  */
 static const struct file_operations cpustate_fops = {
-      owner:THIS_MODULE,
-      open:cpustate_open,
-      release:cpustate_release,
-      read:cpustate_read,
-      write:cpustate_write,
-      fasync:NULL,
-      poll:NULL,
-      ioctl:NULL,
-      llseek:no_llseek,
-
+      owner:	THIS_MODULE,
+      open:	cpustate_open,
+      release:	cpustate_release,
+      read:	cpustate_read,
+      write:	cpustate_write,
+      fasync:	NULL,
+      poll:	NULL,
+      ioctl:	NULL,
+      llseek:	no_llseek,
 };
 
 static struct miscdevice cpustate_dev = {
 	MISC_DYNAMIC_MINOR,
 	"sky_cpustate",
-	&cpustate_fops
+	&cpustate_fops,
 };
 
 static int hdpu_cpustate_probe(struct platform_device *pdev)
@@ -199,18 +199,18 @@ static int hdpu_cpustate_probe(struct platform_device *pdev)
 
 	ret = misc_register(&cpustate_dev);
 	if (ret) {
-		printk(KERN_WARNING "sky_cpustate: Unable to register misc "
-					"device.\n");
+		printk(KERN_WARNING "sky_cpustate: "
+		       "Unable to register misc device.\n");
 		cpustate.set_addr = NULL;
 		cpustate.clr_addr = NULL;
 		return ret;
 	}
 
 	proc_de = create_proc_read_entry("sky_cpustate", 0, 0,
-					cpustate_read_proc, NULL);
+					 cpustate_read_proc, NULL);
 	if (proc_de == NULL)
-		printk(KERN_WARNING "sky_cpustate: Unable to create proc "
-					"dir entry\n");
+		printk(KERN_WARNING "sky_cpustate: "
+		       "Unable to create proc dir entry\n");
 
 	printk(KERN_INFO "Sky CPU State Driver v" SKY_CPUSTATE_VERSION "\n");
 	return 0;
@@ -218,21 +218,18 @@ static int hdpu_cpustate_probe(struct platform_device *pdev)
 
 static int hdpu_cpustate_remove(struct platform_device *pdev)
 {
-
 	cpustate.set_addr = NULL;
 	cpustate.clr_addr = NULL;
 
 	remove_proc_entry("sky_cpustate", NULL);
 	misc_deregister(&cpustate_dev);
-	return 0;
 
+	return 0;
 }
 
 static int __init cpustate_init(void)
 {
-	int rc;
-	rc = platform_driver_register(&hdpu_cpustate_driver);
-	return rc;
+	return platform_driver_register(&hdpu_cpustate_driver);
 }
 
 static void __exit cpustate_exit(void)
diff --git a/drivers/misc/hdpuftrs/hdpu_nexus.c b/drivers/misc/hdpuftrs/hdpu_nexus.c
index 60c8b26..fd3f3c2 100644
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c
+++ b/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -40,40 +40,43 @@ static struct platform_driver hdpu_nexus_driver = {
 int hdpu_slot_id_read(char *buffer, char **buffer_location, off_t offset,
 		      int buffer_length, int *zero, void *ptr)
 {
-
 	if (offset > 0)
 		return 0;
+
 	return sprintf(buffer, "%d\n", slot_id);
 }
 
 int hdpu_chassis_id_read(char *buffer, char **buffer_location, off_t offset,
 			 int buffer_length, int *zero, void *ptr)
 {
-
 	if (offset > 0)
 		return 0;
+
 	return sprintf(buffer, "%d\n", chassis_id);
 }
 
 static int hdpu_nexus_probe(struct platform_device *pdev)
 {
 	struct resource *res;
+	int *nexus_id_addr;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	int *nexus_id_addr;
-	nexus_id_addr =
-	    ioremap(res->start, (unsigned long)(res->end - res->start));
+	nexus_id_addr = ioremap(res->start,
+				(unsigned long)(res->end - res->start));
 	if (nexus_id_addr) {
 		slot_id = (*nexus_id_addr >> 8) & 0x1f;
 		chassis_id = *nexus_id_addr & 0xff;
 		iounmap(nexus_id_addr);
-	} else
-		printk("Could not map slot id\n");
+	} else {
+		printk(KERN_ERR "Could not map slot id\n");
+	}
+
 	hdpu_slot_id = create_proc_entry("sky_slot_id", 0666, &proc_root);
 	hdpu_slot_id->read_proc = hdpu_slot_id_read;
 
 	hdpu_chassis_id = create_proc_entry("sky_chassis_id", 0666, &proc_root);
 	hdpu_chassis_id->read_proc = hdpu_chassis_id_read;
+
 	return 0;
 }
 
@@ -81,18 +84,19 @@ static int hdpu_nexus_remove(struct platform_device *pdev)
 {
 	slot_id = -1;
 	chassis_id = -1;
+
 	remove_proc_entry("sky_slot_id", &proc_root);
 	remove_proc_entry("sky_chassis_id", &proc_root);
+
 	hdpu_slot_id = 0;
 	hdpu_chassis_id = 0;
+
 	return 0;
 }
 
 static int __init nexus_init(void)
 {
-	int rc;
-	rc = platform_driver_register(&hdpu_nexus_driver);
-	return rc;
+	return platform_driver_register(&hdpu_nexus_driver);
 }
 
 static void __exit nexus_exit(void)
