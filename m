Return-Path: <linux-kernel-owner+w=401wt.eu-S1759021AbYKVRhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021AbYKVRhJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758970AbYKVRfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:35:17 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55408 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758963AbYKVRfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:35:15 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 12/32] gdth section fixes
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wO2-0006SA-Jb@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:35:14 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


PCI side of driver should be devinit, not init

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/gdth.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -588,7 +588,7 @@ static struct pci_driver gdth_pci_driver = {
 	.remove		= gdth_pci_remove_one,
 };
 
-static void gdth_pci_remove_one(struct pci_dev *pdev)
+static void __devexit gdth_pci_remove_one(struct pci_dev *pdev)
 {
 	gdth_ha_str *ha = pci_get_drvdata(pdev);
 
@@ -600,7 +600,7 @@ static void gdth_pci_remove_one(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-static int gdth_pci_init_one(struct pci_dev *pdev,
+static int __devinit gdth_pci_init_one(struct pci_dev *pdev,
 				       const struct pci_device_id *ent)
 {
 	ushort vendor = pdev->vendor;
@@ -853,7 +853,7 @@ static int __init gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha)
 #endif /* CONFIG_ISA */
 
 #ifdef CONFIG_PCI
-static int gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
+static int __devinit gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
 				   gdth_ha_str *ha)
 {
     register gdt6_dpram_str __iomem *dp6_ptr;
@@ -1237,7 +1237,7 @@ static int gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
 
 /* controller protocol functions */
 
-static void __init gdth_enable_int(gdth_ha_str *ha)
+static void __devinit gdth_enable_int(gdth_ha_str *ha)
 {
     ulong flags;
     gdt2_dpram_str __iomem *dp2_ptr;
@@ -1553,7 +1553,7 @@ static int gdth_internal_cmd(gdth_ha_str *ha, unchar service, ushort opcode,
 
 /* search for devices */
 
-static int __init gdth_search_drives(gdth_ha_str *ha)
+static int __devinit gdth_search_drives(gdth_ha_str *ha)
 {
     ushort cdev_cnt, i;
     int ok;
@@ -4935,7 +4935,7 @@ static int __init gdth_eisa_probe_one(ushort eisa_slot)
 #endif /* CONFIG_EISA */
 
 #ifdef CONFIG_PCI
-static int gdth_pci_probe_one(gdth_pci_str *pcistr,
+static int __devinit gdth_pci_probe_one(gdth_pci_str *pcistr,
 			     gdth_ha_str **ha_out)
 {
 	struct Scsi_Host *shp;
