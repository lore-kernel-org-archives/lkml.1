Return-Path: <linux-kernel-owner+w=401wt.eu-S1762215AbZAHT3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762215AbZAHT3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbZAHT3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:29:14 -0500
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:43200
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbZAHT3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:29:13 -0500
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2009 14:29:13 EST
Subject: [PATCH] synclink_gt enable RI interrupt
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 13:18:37 -0600
Message-Id: <1231442317.18401.3.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable ring indicator interrupt.
Remove vendor specific CVS version tags.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>

--- a/drivers/char/synclink_gt.c	2009-01-08 13:00:24.000000000 -0600
+++ b/drivers/char/synclink_gt.c	2009-01-08 13:07:27.000000000 -0600
@@ -1,6 +1,4 @@
 /*
- * $Id: synclink_gt.c,v 4.50 2007/07/25 19:29:25 paulkf Exp $
- *
  * Device driver for Microgate SyncLink GT serial adapters.
  *
  * written by Paul Fulghum for Microgate Corporation
@@ -91,7 +89,6 @@
  * module identification
  */
 static char *driver_name     = "SyncLink GT";
-static char *driver_version  = "$Revision: 4.50 $";
 static char *tty_driver_name = "synclink_gt";
 static char *tty_dev_prefix  = "ttySLG";
 MODULE_LICENSE("GPL");
@@ -1356,7 +1353,7 @@ static int read_proc(char *page, char **
 	off_t	begin = 0;
 	struct slgt_info *info;
 
-	len += sprintf(page, "synclink_gt driver:%s\n", driver_version);
+	len += sprintf(page, "synclink_gt driver\n");
 
 	info = slgt_device_list;
 	while( info ) {
@@ -2488,7 +2485,7 @@ static void program_hw(struct slgt_info 
 	info->ri_chkcount = 0;
 	info->dsr_chkcount = 0;
 
-	slgt_irq_on(info, IRQ_DCD | IRQ_CTS | IRQ_DSR);
+	slgt_irq_on(info, IRQ_DCD | IRQ_CTS | IRQ_DSR | IRQ_RI);
 	get_signals(info);
 
 	if (info->netcount ||
@@ -3600,7 +3597,7 @@ static void slgt_cleanup(void)
 	struct slgt_info *info;
 	struct slgt_info *tmp;
 
-	printk("unload %s %s\n", driver_name, driver_version);
+	printk(KERN_INFO "unload %s\n", driver_name);
 
 	if (serial_driver) {
 		for (info=slgt_device_list ; info != NULL ; info=info->next_device)
@@ -3643,7 +3640,7 @@ static int __init slgt_init(void)
 {
 	int rc;
 
- 	printk("%s %s\n", driver_name, driver_version);
+	printk(KERN_INFO "%s\n", driver_name);
 
 	serial_driver = alloc_tty_driver(MAX_DEVICES);
 	if (!serial_driver) {
@@ -3674,9 +3671,8 @@ static int __init slgt_init(void)
 		goto error;
 	}
 
- 	printk("%s %s, tty major#%d\n",
-		driver_name, driver_version,
-		serial_driver->major);
+	printk(KERN_INFO "%s, tty major#%d\n",
+	       driver_name, serial_driver->major);
 
 	slgt_device_count = 0;
 	if ((rc = pci_register_driver(&pci_driver)) < 0) {


