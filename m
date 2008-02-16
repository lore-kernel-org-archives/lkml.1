Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbYBPUMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbYBPUMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbYBPUMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:12:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:12569 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbYBPUME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:12:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=QMy2VObVi7OlSFVbuTa8kKj6Y57AUCQVmxpyk++mkB9aFpoEwbVuPMW3DaKZo+yeTjnWHblXNUmt6c1Zm8z7pesXueuPnLbIiGROiNYksWlT/KZetZL71ehIidifaTde8rGYc6BnG+lVbfOd3TWzqwszXl6NXKqKiWCxtCpVKyM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2008 21:26:34 +0100
Message-Id: <20080216202634.25536.78915.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/9] sgiioc4: use ide_find_port()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/sgiioc4.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -591,20 +591,12 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	unsigned long bar0, cmd_phys_base, ctl;
 	void __iomem *virt_base;
 	ide_hwif_t *hwif;
-	int h;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	hw_regs_t hw;
 	struct ide_port_info d = sgiioc4_port_info;
 
-	/*
-	 * Find an empty HWIF; if none available, return -ENOMEM.
-	 */
-	for (h = 0; h < MAX_HWIFS; ++h) {
-		hwif = &ide_hwifs[h];
-		if (hwif->chipset == ide_unknown)
-			break;
-	}
-	if (h == MAX_HWIFS) {
+	hwif = ide_find_port();
+	if (hwif == NULL) {
 		printk(KERN_ERR "%s: too many IDE interfaces, no room in table\n",
 				DRV_NAME);
 		return -ENOMEM;
