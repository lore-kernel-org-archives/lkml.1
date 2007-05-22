Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbXEVIKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbXEVIKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758268AbXEVIGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:06:30 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:5737 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbXEVIGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:06:12 -0400
From: muli@il.ibm.com
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org, jdmason@kudzu.us,
       michaelv@il.ibm.com, guillaume.thouvenin@ext.bull.net, muli@il.ibm.com
Subject: [PATCH 15/15] x86-64: Calgary - tidy up debug printks
Date: Tue, 22 May 2007 04:06:04 -0400
Message-Id: <1179821168449-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.4.4
In-Reply-To: <11798211683559-git-send-email-muli@il.ibm.com>
References: <11798211643534-git-send-email-muli@il.ibm.com> <11798211643659-git-send-email-muli@il.ibm.com> <11798211643144-git-send-email-muli@il.ibm.com> <11798211663773-git-send-email-muli@il.ibm.com> <1179821166685-git-send-email-muli@il.ibm.com> <11798211661041-git-send-email-muli@il.ibm.com> <11798211672108-git-send-email-muli@il.ibm.com> <1179821167481-git-send-email-muli@il.ibm.com> <11798211673003-git-send-email-muli@il.ibm.com> <11798211672822-git-send-email-muli@il.ibm.com> <1179821167443-git-send-email-muli@il.ibm.com> <11798211673144-git-send-email-muli@il.ibm.com> <11798211671872-git-send-email-muli@il.ibm.com> <11798211673121-git-send-email-muli@il.ibm.com> <11798211683559-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86_64/kernel/pci-calgary.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index 1df556c..0bbe839 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -1226,10 +1226,9 @@ static int __init calgary_init(void)
 			continue;
 		}
 		tce_space = bus_info[dev->bus->number].tce_space;
-		if (!tce_space && !translate_empty_slots) {
-			printk("Calg: %p failed tce_space check\n", dev);
+		if (!tce_space && !translate_empty_slots)
 			continue;
-		}
+
 		ret = calgary_init_one(dev);
 		if (ret)
 			goto error;
@@ -1421,8 +1420,6 @@ void __init detect_calgary(void)
 				goto cleanup;
 			info->tce_space = tbl;
 			calgary_found = 1;
-			printk("Calg: allocated tce_table %p for bus 0x%x\n",
-			       info->tce_space, bus);
 		}
 	}
 
@@ -1557,10 +1554,6 @@ static void __init calgary_fixup_one_tce
 		npages = (r->end - r->start) >> PAGE_SHIFT;
 		npages++;
 
-		printk(KERN_DEBUG "Calg: dev %p [%x] tbl %p reserving "
-		       "0x%Lx-0x%Lx [0x%x pages]\n", dev, dev->bus->number,
-		       tbl, r->start, r->end, npages);
-
 		iommu_range_reserve(tbl, r->start, npages);
 	}
 }
@@ -1573,7 +1566,7 @@ static int __init calgary_fixup_tce_spac
 	if (no_iommu || swiotlb || !calgary_detected)
 		return -ENODEV;
 
-	printk(KERN_DEBUG "Calgary: fixing tce spaces\n");
+	printk(KERN_DEBUG "Calgary: fixing up tce spaces\n");
 
 	do {
 		dev = pci_get_device(PCI_VENDOR_ID_IBM, PCI_ANY_ID, dev);
-- 
1.4.4

