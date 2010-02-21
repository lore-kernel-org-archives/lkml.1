Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab0BURhO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 12:37:14 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:33557 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab0BURhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 12:37:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dS92r+uLYjo0gcr9MAlCV43vg7fcPjj8kCqVwDlwdec8u3HcxOCqWrr+hBsU0/dMc7
         nAS7JTrjtVAcqBsQt854Q6VXsRq3n1HSDxvUt20G11JjLoAvWf5HDlI0kBMjtpEEI3/o
         eetsH5mfBPOhs47pD/Iv1fCIR8f1aKqXqRF7k=
From: Norberto Lopes <nlopes.ml@gmail.com>
To: gregkh@suse.de, alan@linux.intel.com, andre.goddard@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Norberto Lopes <nlopes.ml@gmail.com>
Subject: [PATCH 1/1] Staging: rar: fix errors/warnings related to coding style
Date: Sun, 21 Feb 2010 18:37:07 +0100
Message-Id: <1266773827-729-1-git-send-email-nlopes.ml@gmail.com>
X-Mailer: git-send-email 1.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Norberto Lopes <nlopes.ml@gmail.com>
---
 drivers/staging/rar/rar_driver.c |   82 ++++++++++++++++++-------------------
 1 files changed, 40 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/rar/rar_driver.c b/drivers/staging/rar/rar_driver.c
index d85d189..a8ab3a9 100644
--- a/drivers/staging/rar/rar_driver.c
+++ b/drivers/staging/rar/rar_driver.c
@@ -86,9 +86,9 @@ static struct pci_driver rar_pci_driver = {
 
 /* This function is used to retrieved RAR info using the IPC message
    bus interface */
-static int memrar_get_rar_addr(struct pci_dev* pdev,
-	                      int offset,
-	                      u32 *addr)
+static int memrar_get_rar_addr(struct pci_dev *pdev,
+				int offset,
+				u32 *addr)
 {
 	/*
 	 * ======== The Lincroft Message Bus Interface ========
@@ -140,23 +140,23 @@ static int memrar_get_rar_addr(struct pci_dev* pdev,
 	       | (offset << 8)
 	       | (LNC_MESSAGE_BYTE_WRITE_ENABLES << 4);
 
-	printk(KERN_WARNING "rar- offset to LNC MSG is %x\n",offset);
+	printk(KERN_WARNING "rar- offset to LNC MSG is %x\n", offset);
 
 	if (addr == 0)
 		return -EINVAL;
 
 	/* Send the control message */
 	result = pci_write_config_dword(pdev,
-	                          LNC_MCR_OFFSET,
-	                          message);
+					LNC_MCR_OFFSET,
+					message);
 
-	printk(KERN_WARNING "rar- result from send ctl register is %x\n"
-	  ,result);
+	printk(KERN_WARNING "rar- result from send ctl register is %x\n",
+	  result);
 
 	if (!result)
 		result = pci_read_config_dword(pdev,
-		                              LNC_MDR_OFFSET,
-				              addr);
+						LNC_MDR_OFFSET,
+						addr);
 
 	printk(KERN_WARNING "rar- result from read data register is %x\n",
 	  result);
@@ -170,9 +170,9 @@ static int memrar_get_rar_addr(struct pci_dev* pdev,
 		return 0;
 }
 
-static int memrar_set_rar_addr(struct pci_dev* pdev,
-	                      int offset,
-	                      u32 addr)
+static int memrar_set_rar_addr(struct pci_dev *pdev,
+				int offset,
+				u32 addr)
 {
 	/*
 	 * ======== The Lincroft Message Bus Interface ========
@@ -225,23 +225,23 @@ static int memrar_set_rar_addr(struct pci_dev* pdev,
 	       | (offset << 8)
 	       | (LNC_MESSAGE_BYTE_WRITE_ENABLES << 4);
 
-	printk(KERN_WARNING "rar- offset to LNC MSG is %x\n",offset);
+	printk(KERN_WARNING "rar- offset to LNC MSG is %x\n", offset);
 
 	if (addr == 0)
 		return -EINVAL;
 
 	/* Send the control message */
 	result = pci_write_config_dword(pdev,
-	                          LNC_MDR_OFFSET,
-	                          addr);
+					LNC_MDR_OFFSET,
+					addr);
 
-	printk(KERN_WARNING "rar- result from send ctl register is %x\n"
-	  ,result);
+	printk(KERN_WARNING "rar- result from send ctl register is %x\n",
+	  result);
 
 	if (!result)
 		result = pci_write_config_dword(pdev,
-		                              LNC_MCR_OFFSET,
-				              message);
+						LNC_MCR_OFFSET,
+						message);
 
 	printk(KERN_WARNING "rar- result from write data register is %x\n",
 	  result);
@@ -287,12 +287,12 @@ static int memrar_init_rar_params(struct pci_dev *pdev)
 	       return -ENODEV;
 
 	for (i = offsets; i != end; ++i, ++n) {
-	       if (memrar_get_rar_addr (pdev,
-		                       (*i).low,
-		                       &(rar_addr[n].low)) != 0
-		   || memrar_get_rar_addr (pdev,
-		                          (*i).high,
-		                          &(rar_addr[n].high)) != 0) {
+		if (memrar_get_rar_addr(pdev,
+					(*i).low,
+					&(rar_addr[n].low)) != 0
+		   || memrar_get_rar_addr(pdev,
+					  (*i).high,
+					  &(rar_addr[n].high)) != 0) {
 		       result = -1;
 		       break;
 	       }
@@ -302,15 +302,15 @@ static int memrar_init_rar_params(struct pci_dev *pdev)
 	/* pci_dev_put(pdev); */
 
 	if (result == 0) {
-	if(1) {
-	       size_t z;
-	       for (z = 0; z != MRST_NUM_RAR; ++z) {
-			printk(KERN_WARNING "rar - BRAR[%Zd] physical address low\n"
-			     "\tlow:  0x%08x\n"
-			     "\thigh: 0x%08x\n",
-			     z,
-			     rar_addr[z].low,
-			     rar_addr[z].high);
+		if (1) {
+			size_t z;
+			for (z = 0; z != MRST_NUM_RAR; ++z) {
+				printk(KERN_WARNING "rar - BRAR[%Zd] physical address low\n"
+					"\tlow:  0x%08x\n"
+					"\thigh: 0x%08x\n",
+					z,
+					rar_addr[z].low,
+					rar_addr[z].high);
 			}
 	       }
 	}
@@ -347,7 +347,7 @@ static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id
 
 	/* Initialize the RAR parameters, which have to be retrieved */
 	/* via the message bus service */
-	error=memrar_init_rar_params(rar_dev);
+	error = memrar_init_rar_params(rar_dev);
 
 	if (error) {
 		DEBUG_PRINT_0(RAR_DEBUG_LEVEL_EXTENDED,
@@ -396,10 +396,10 @@ MODULE_LICENSE("GPL");
  * The function returns a 0 upon success or a -1 if there is no RAR
  * facility on this system.
  */
-int get_rar_address(int rar_index,struct RAR_address_struct *addresses)
+int get_rar_address(int rar_index, struct RAR_address_struct *addresses)
 {
 	if (registered && (rar_index < 3) && (rar_index >= 0)) {
-		*addresses=rar_addr[rar_index];
+		*addresses = rar_addr[rar_index];
 		/* strip off lock bit information  */
 		addresses->low = addresses->low & 0xfffffff0;
 		addresses->high = addresses->high & 0xfffffff0;
@@ -410,8 +410,6 @@ int get_rar_address(int rar_index,struct RAR_address_struct *addresses)
 		return -ENODEV;
 		}
 }
-
-
 EXPORT_SYMBOL(get_rar_address);
 
 /* The lock_rar function is ued by other device drivers to lock an RAR.
@@ -431,10 +429,10 @@ int lock_rar(int rar_index)
 	int result;
 if (registered && (rar_index < 3) && (rar_index >= 0)) {
 	/* first make sure that lock bits are clear (this does lock) */
-	working_addr=rar_addr[rar_index].low & 0xfffffff0;
+	working_addr = rar_addr[rar_index].low & 0xfffffff0;
 
 	/* now send that value to the register using the IPC */
-        result=memrar_set_rar_addr(rar_dev,rar_index,working_addr);
+	result = memrar_set_rar_addr(rar_dev, rar_index, working_addr);
 	return result;
 	}
 
-- 
1.6.4

