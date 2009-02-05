Return-Path: <linux-kernel-owner+w=401wt.eu-S1760614AbZBESDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614AbZBESDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbZBESDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:03:13 -0500
Received: from ns2.suse.de ([195.135.220.15]:49865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163AbZBESDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:03:12 -0500
Message-ID: <498B29CC.2030000@suse.de>
Date: Thu, 05 Feb 2009 19:02:52 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org, greg@kroah.com,
       kristen.c.accardi@intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, fenghua.yu@intel.com,
       akpm@linux-foundation.org, frank@f-seidel.de,
       Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCHv2] PCI: add missing KERN_* constants to printks
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
 drivers/pci/hotplug/pciehp.h |    3 ++-
 drivers/pci/hotplug/shpchp.h |    3 ++-
 drivers/pci/intel-iommu.c    |    2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

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
@@ -48,7 +48,8 @@ extern struct workqueue_struct *pciehp_w
 #define dbg(format, arg...)						\
 	do {								\
 		if (pciehp_debug)					\
-			printk("%s: " format, MY_NAME , ## arg);	\
+			printk(KERN_DEBUG "%s: " format, MY_NAME ,	\
+			       ## arg);					\
 	} while (0)
 #define err(format, arg...)						\
 	printk(KERN_ERR "%s: " format, MY_NAME , ## arg)
--- a/drivers/pci/hotplug/shpchp.h
+++ b/drivers/pci/hotplug/shpchp.h
@@ -50,7 +50,8 @@ extern struct workqueue_struct *shpchp_w
 #define dbg(format, arg...)						\
 	do {								\
 		if (shpchp_debug)					\
-			printk("%s: " format, MY_NAME , ## arg);	\
+			printk(KERN_DEBUG "%s: " format, MY_NAME ,	\
+			       ## arg);					\
 	} while (0)
 #define err(format, arg...)						\
 	printk(KERN_ERR "%s: " format, MY_NAME , ## arg)


