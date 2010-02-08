Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab0BHTCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 14:02:49 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:57980 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab0BHTCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 14:02:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Jj2uSlkPOJyaA5z7qb4H6szeiU9YEunVTCZ7IkCNKq1y4lx7RHWR/iIYYPW+/dR7OO
         ALRoghXomwph8VUhYmtXk0LrwAWqA3RYyPBQDTljO/+y9/OQPoAWT0CvFnK/MNaFYxbL
         xyJVUTWtKPOZ7FfwcGw+FOnYjvwYvjzdO0foM=
From: Chihau Chau <chihau@gmail.com>
To: gregkh@suse.de
Cc: alan@linux.intel.com, andre.goddard@gmail.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Chihau Chau <chihau@gmail.com>
Subject: [PATCH] Staging: rar: rar_driver: fix some coding style issues
Date: Mon,  8 Feb 2010 16:02:36 -0300
Message-Id: <1265655756-26056-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>

This fixes some coding style issues like lines over 80 characters, "foo* bar"
and spaces or tabs errors.

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 drivers/staging/rar/rar_driver.c |   31 +++++++++++--------------------
 1 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rar/rar_driver.c b/drivers/staging/rar/rar_driver.c
index d85d189..4ef1acf 100644
--- a/drivers/staging/rar/rar_driver.c
+++ b/drivers/staging/rar/rar_driver.c
@@ -68,7 +68,8 @@ static void __exit rar_exit_handler(void);
 /*
   function that is activated on the successfull probe of the RAR device
 */
-static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
+static int __devinit rar_probe(struct pci_dev *pdev,
+					const struct pci_device_id *ent);
 
 static struct pci_device_id rar_pci_id_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4110) },
@@ -86,9 +87,7 @@ static struct pci_driver rar_pci_driver = {
 
 /* This function is used to retrieved RAR info using the IPC message
    bus interface */
-static int memrar_get_rar_addr(struct pci_dev* pdev,
-	                      int offset,
-	                      u32 *addr)
+static int memrar_get_rar_addr(struct pci_devi *pdev, int offset, u32 *addr)
 {
 	/*
 	 * ======== The Lincroft Message Bus Interface ========
@@ -140,23 +139,19 @@ static int memrar_get_rar_addr(struct pci_dev* pdev,
 	       | (offset << 8)
 	       | (LNC_MESSAGE_BYTE_WRITE_ENABLES << 4);
 
-	printk(KERN_WARNING "rar- offset to LNC MSG is %x\n",offset);
+	printk(KERN_WARNING "rar- offset to LNC MSG is %x\n", offset);
 
 	if (addr == 0)
 		return -EINVAL;
 
 	/* Send the control message */
-	result = pci_write_config_dword(pdev,
-	                          LNC_MCR_OFFSET,
-	                          message);
+	result = pci_write_config_dword(pdev, LNC_MCR_OFFSET, message);
 
-	printk(KERN_WARNING "rar- result from send ctl register is %x\n"
-	  ,result);
+	printk(KERN_WARNING "rar- result from send ctl register is %x\n",
+								result);
 
 	if (!result)
-		result = pci_read_config_dword(pdev,
-		                              LNC_MDR_OFFSET,
-				              addr);
+		result = pci_read_config_dword(pdev, LNC_MDR_OFFSET, addr);
 
 	printk(KERN_WARNING "rar- result from read data register is %x\n",
 	  result);
@@ -170,9 +165,7 @@ static int memrar_get_rar_addr(struct pci_dev* pdev,
 		return 0;
 }
 
-static int memrar_set_rar_addr(struct pci_dev* pdev,
-	                      int offset,
-	                      u32 addr)
+static int memrar_set_rar_addr(struct pci_dev *pdev, int offset, u32 addr)
 {
 	/*
 	 * ======== The Lincroft Message Bus Interface ========
@@ -225,15 +218,13 @@ static int memrar_set_rar_addr(struct pci_dev* pdev,
 	       | (offset << 8)
 	       | (LNC_MESSAGE_BYTE_WRITE_ENABLES << 4);
 
-	printk(KERN_WARNING "rar- offset to LNC MSG is %x\n",offset);
+	printk(KERN_WARNING "rar- offset to LNC MSG is %x\n", offset);
 
 	if (addr == 0)
 		return -EINVAL;
 
 	/* Send the control message */
-	result = pci_write_config_dword(pdev,
-	                          LNC_MDR_OFFSET,
-	                          addr);
+	result = pci_write_config_dword(pdev, LNC_MDR_OFFSET, addr);
 
 	printk(KERN_WARNING "rar- result from send ctl register is %x\n"
 	  ,result);
-- 
1.5.6.3

