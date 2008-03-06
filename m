Return-Path: <linux-kernel-owner+w=401wt.eu-S934555AbYCFCar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934555AbYCFCar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765405AbYCFCZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:25:09 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:61432 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764527AbYCFCZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:25:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rUV5AKQ6wMJqoww9O8hbvoN1I3bLHzdmTP4YN55E6Qi6c1cO4g+LFvKN0/YqaSkMfFWRwOwTAl1B0/XwqgoURE+2VzY22/LlgS2GoZlcxJ6R1G1uFGEgC80DYvih9dG+vnisRMVVIe3Nsr71qgpmO8LcVXdqIrJGqXyf4ITElrE=
Subject: [PATCH 12/16] ioc3.c: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "ralf@linux-mips.org" <ralf@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 18:24:57 -0800
Message-Id: <1204770297.14154.48.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/sn/ioc3.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/sn/ioc3.c b/drivers/sn/ioc3.c
index 29fcd6d..c083274 100644
--- a/drivers/sn/ioc3.c
+++ b/drivers/sn/ioc3.c
@@ -561,7 +561,7 @@ void ioc3_unregister_submodule(struct ioc3_submodule *is)
 					printk(KERN_WARNING
 					       "%s: IOC3 submodule %s remove failed "
 					       "for pci_dev %s.\n",
-					       __FUNCTION__, module_name(is->owner),
+					       __func__, module_name(is->owner),
 					       pci_name(idd->pdev));
 			idd->active[is->id] = 0;
 			if(is->irq_mask)
@@ -611,7 +611,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 	if ((ret = pci_enable_device(pdev))) {
 		printk(KERN_WARNING
 		       "%s: Failed to enable IOC3 device for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(pdev));
+		       __func__, pci_name(pdev));
 		goto out;
 	}
 	pci_set_master(pdev);
@@ -623,7 +623,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
                 if (ret < 0) {
                         printk(KERN_WARNING "%s: Unable to obtain 64 bit DMA "
                                "for consistent allocations\n",
-				__FUNCTION__);
+				__func__);
                 }
 	}
 #endif
@@ -633,7 +633,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 	if (!idd) {
 		printk(KERN_WARNING
 		       "%s: Failed to allocate IOC3 data for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(pdev));
+		       __func__, pci_name(pdev));
 		ret = -ENODEV;
 		goto out_idd;
 	}
@@ -649,7 +649,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 		printk(KERN_WARNING
 		       "%s: Unable to find IOC3 resource "
 		       "for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(pdev));
+		       __func__, pci_name(pdev));
 		ret = -ENODEV;
 		goto out_pci;
 	}
@@ -657,7 +657,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 		printk(KERN_WARNING
 		       "%s: Unable to request IOC3 region "
 		       "for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(pdev));
+		       __func__, pci_name(pdev));
 		ret = -ENODEV;
 		goto out_pci;
 	}
@@ -666,7 +666,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 		printk(KERN_WARNING
 		       "%s: Unable to remap IOC3 region "
 		       "for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(pdev));
+		       __func__, pci_name(pdev));
 		ret = -ENODEV;
 		goto out_misc_region;
 	}
@@ -709,7 +709,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 		} else {
 			printk(KERN_WARNING
 			       "%s : request_irq fails for IRQ 0x%x\n ",
-			       __FUNCTION__, pdev->irq);
+			       __func__, pdev->irq);
 		}
 		if (!request_irq(pdev->irq+2, ioc3_intr_io, IRQF_SHARED,
 				 "ioc3-io", (void *)idd)) {
@@ -717,7 +717,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 		} else {
 			printk(KERN_WARNING
 			       "%s : request_irq fails for IRQ 0x%x\n ",
-			       __FUNCTION__, pdev->irq+2);
+			       __func__, pdev->irq+2);
 		}
 	} else {
 		if (!request_irq(pdev->irq, ioc3_intr_io, IRQF_SHARED,
@@ -726,7 +726,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 		} else {
 			printk(KERN_WARNING
 			       "%s : request_irq fails for IRQ 0x%x\n ",
-			       __FUNCTION__, pdev->irq);
+			       __func__, pdev->irq);
 		}
 	}
 
@@ -769,7 +769,7 @@ static void ioc3_remove(struct pci_dev *pdev)
 					printk(KERN_WARNING
 					       "%s: IOC3 submodule 0x%s remove failed "
 					       "for pci_dev %s.\n",
-					        __FUNCTION__,
+						__func__,
 						module_name(ioc3_submodules[id]->owner),
 					        pci_name(pdev));
 			idd->active[id] = 0;
-- 
1.5.4.GIT


