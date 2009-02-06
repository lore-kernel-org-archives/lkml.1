Return-Path: <linux-kernel-owner+w=401wt.eu-S1755681AbZBFJYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbZBFJYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbZBFJYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:24:00 -0500
Received: from mail.suse.de ([195.135.220.2]:41641 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbZBFJX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:23:59 -0500
Message-ID: <498C0198.3020408@suse.de>
Date: Fri, 06 Feb 2009 10:23:36 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org, greg@kroah.com,
       kristen.c.accardi@intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, fenghua.yu@intel.com,
       akpm@linux-foundation.org, frank@f-seidel.de,
       Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Frank Seidel <fseidel@suse.de>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Taku Izumi <izumi.taku@jp.fujitsu.com>
Subject: [PATCHv3] PCI: add missing KERN_* constants to printks
References: <498B2116.6010707@suse.de>
In-Reply-To: <498B2116.6010707@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <frank@f-seidel.de>

According to kerneljanitors todo list all printk calls (beginning
a new line) should have an according KERN_* constant.
Those are the missing pieces here for the pci subsystem.

Signed-off-by: Frank Seidel <frank@f-seidel.de>
---
 drivers/pci/hotplug/pciehp.h |   10 +++++-----
 drivers/pci/hotplug/shpchp.h |   10 +++++-----
 drivers/pci/intel-iommu.c    |    2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1960,7 +1960,7 @@ static inline void iommu_prepare_isa(voi
 	ret = iommu_prepare_identity_map(pdev, 0, 16*1024*1024);
 
 	if (ret)
-		printk("IOMMU: Failed to create 0-64M identity map, "
+		printk(KERN_ERR "IOMMU: Failed to create 0-64M identity map, "
 			"floppy might not work\n");
 
 }
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -46,10 +46,10 @@ extern int pciehp_force;
 extern struct workqueue_struct *pciehp_wq;
 
 #define dbg(format, arg...)						\
-	do {								\
-		if (pciehp_debug)					\
-			printk("%s: " format, MY_NAME , ## arg);	\
-	} while (0)
+do {									\
+	if (pciehp_debug)						\
+		printk(KERN_DEBUG "%s: " format, MY_NAME , ## arg);	\
+} while (0)
 #define err(format, arg...)						\
 	printk(KERN_ERR "%s: " format, MY_NAME , ## arg)
 #define info(format, arg...)						\
@@ -60,7 +60,7 @@ extern struct workqueue_struct *pciehp_w
 #define ctrl_dbg(ctrl, format, arg...)					\
 	do {								\
 		if (pciehp_debug)					\
-			dev_printk(, &ctrl->pcie->device,		\
+			dev_printk(KERN_DEBUG, &ctrl->pcie->device,	\
 					format, ## arg);		\
 	} while (0)
 #define ctrl_err(ctrl, format, arg...)					\
--- a/drivers/pci/hotplug/shpchp.h
+++ b/drivers/pci/hotplug/shpchp.h
@@ -48,10 +48,10 @@ extern int shpchp_debug;
 extern struct workqueue_struct *shpchp_wq;
 
 #define dbg(format, arg...)						\
-	do {								\
-		if (shpchp_debug)					\
-			printk("%s: " format, MY_NAME , ## arg);	\
-	} while (0)
+do {									\
+	if (shpchp_debug)						\
+		printk(KERN_DEBUG "%s: " format, MY_NAME , ## arg);	\
+} while (0)
 #define err(format, arg...)						\
 	printk(KERN_ERR "%s: " format, MY_NAME , ## arg)
 #define info(format, arg...)						\
@@ -62,7 +62,7 @@ extern struct workqueue_struct *shpchp_w
 #define ctrl_dbg(ctrl, format, arg...)					\
 	do {								\
 		if (shpchp_debug)					\
-			dev_printk(, &ctrl->pci_dev->dev,		\
+			dev_printk(KERN_DEBUG, &ctrl->pci_dev->dev,	\
 					format, ## arg);		\
 	} while (0)
 #define ctrl_err(ctrl, format, arg...)					\
