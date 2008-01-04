Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbYADNSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbYADNSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 08:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYADNSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 08:18:08 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:38457 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbYADNSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 08:18:07 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
       Andreas Block <andreas.block@esd-electronics.com>,
       Oliver Thimm <oliver.thimm@esd-electronics.com>
Subject: [PATCH 1/1] phantom, don't grab other devices
Date: Fri,  4 Jan 2008 14:18:03 +0100
Message-Id: <1199452683-1316-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specify also sub pci ids to not grab devices with properly set sub ids.
This devices has these set (unset) to the same as (plx 9050) ids.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Andreas Block <andreas.block@esd-electronics.com>
Cc: Oliver Thimm <oliver.thimm@esd-electronics.com>

diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index cd221fd..7fa61e9 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -25,7 +25,7 @@
 #include <asm/atomic.h>
 #include <asm/io.h>
 
-#define PHANTOM_VERSION		"n0.9.7"
+#define PHANTOM_VERSION		"n0.9.8"
 
 #define PHANTOM_MAX_MINORS	8
 
@@ -456,8 +456,9 @@ static int phantom_resume(struct pci_dev *pdev)
 #endif
 
 static struct pci_device_id phantom_pci_tbl[] __devinitdata = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050),
-		.class = PCI_CLASS_BRIDGE_OTHER << 8, .class_mask = 0xffff00 },
+	{ .vendor = PCI_VENDOR_ID_PLX, .device = PCI_DEVICE_ID_PLX_9050,
+	  .subvendor = PCI_VENDOR_ID_PLX, .subdevice = PCI_DEVICE_ID_PLX_9050,
+	  .class = PCI_CLASS_BRIDGE_OTHER << 8, .class_mask = 0xffff00 },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, phantom_pci_tbl);
-- 
1.5.3.7

