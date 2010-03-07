Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0CGPEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 10:04:52 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40433 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab0CGPEv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 10:04:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=TUQXu1auPLF1xjnhCIgPBQy3clDvBgIjwML48n4yuF41/qMCiUG0bO8b+KctKAjnwT
         xRgbujpReTOqL9GXNW+O96KOb2hIHMH7LywQt/hyIomrpYkvXdg2eHCkHcn4qMqr0C6E
         hHzJhiY7Echh/dLuO+G18INxwELJ2FD37fZQ4=
From: Gustavo Campanelli <gedece@gmail.com>
To: gregkh@suse.de, alan@linux.intel.com
Subject: 0001-Staging-rar-fixed-coding-style-issues-in-rar_driver
Date: Sun, 7 Mar 2010 11:52:35 -0300
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-generic; KDE/4.3.2; i686; ; )
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003071152.35805.gedece@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3aa64eeca3712935308080784bbc54fa018db88b Mon Sep 17 00:00:00 2001
From: Gustavo Campanelli <gedece@gmail.com>
Date: Sun, 7 Mar 2010 10:44:54 -0300
Subject: [PATCH] Staging: rar: fixed coding style issues in rar_driver.c
 This is a patch to the rar_driver.c file that fixes various coding issues found by the checkpath.pl tool
 Signed-off-by: Gustavo Campanelli <gedece@gmail.com>

---
 drivers/staging/rar/rar_driver.c |   91 +++++++++++++++++++------------------
 1 files changed, 47 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/rar/rar_driver.c b/drivers/staging/rar/rar_driver.c
index d85d189..e087706 100644
--- a/drivers/staging/rar/rar_driver.c
+++ b/drivers/staging/rar/rar_driver.c
@@ -68,7 +68,8 @@ static void __exit rar_exit_handler(void);
 /*
   function that is activated on the successfull probe of the RAR device
 */
-static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
+static int __devinit rar_probe(struct pci_dev *pdev,
+				const struct pci_device_id *ent);
 
 static struct pci_device_id rar_pci_id_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4110) },
@@ -86,9 +87,9 @@ static struct pci_driver rar_pci_driver = {
 
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
@@ -140,23 +141,23 @@ static int memrar_get_rar_addr(struct pci_dev* pdev,
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
+				LNC_MCR_OFFSET,
+				message);
 
 	printk(KERN_WARNING "rar- result from send ctl register is %x\n"
-	  ,result);
+	  , result);
 
 	if (!result)
 		result = pci_read_config_dword(pdev,
-		                              LNC_MDR_OFFSET,
-				              addr);
+						LNC_MDR_OFFSET,
+						addr);
 
 	printk(KERN_WARNING "rar- result from read data register is %x\n",
 	  result);
@@ -170,9 +171,9 @@ static int memrar_get_rar_addr(struct pci_dev* pdev,
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
@@ -225,23 +226,23 @@ static int memrar_set_rar_addr(struct pci_dev* pdev,
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
 
 	printk(KERN_WARNING "rar- result from send ctl register is %x\n"
-	  ,result);
+	  , result);
 
 	if (!result)
 		result = pci_write_config_dword(pdev,
-		                              LNC_MCR_OFFSET,
-				              message);
+						LNC_MCR_OFFSET,
+						message);
 
 	printk(KERN_WARNING "rar- result from write data register is %x\n",
 	  result);
@@ -284,17 +285,17 @@ static int memrar_init_rar_params(struct pci_dev *pdev)
 	/* struct pci_dev *pdev = pci_get_bus_and_slot(0, PCI_DEVFN(0,0)); */
 
 	if (pdev == NULL)
-	       return -ENODEV;
+		return -ENODEV;
 
 	for (i = offsets; i != end; ++i, ++n) {
-	       if (memrar_get_rar_addr (pdev,
-		                       (*i).low,
-		                       &(rar_addr[n].low)) != 0
-		   || memrar_get_rar_addr (pdev,
-		                          (*i).high,
-		                          &(rar_addr[n].high)) != 0) {
-		       result = -1;
-		       break;
+		if (memrar_get_rar_addr(pdev,
+					(*i).low,
+					 &(rar_addr[n].low)) != 0
+		   || memrar_get_rar_addr(pdev,
+					(*i).high,
+					&(rar_addr[n].high)) != 0) {
+			result = -1;
+			break;
 	       }
 	}
 
@@ -302,15 +303,16 @@ static int memrar_init_rar_params(struct pci_dev *pdev)
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
+				printk(KERN_WARNING "rar - BRAR[%Zd] physical"
+							"address low\n"
+							"\tlow:  0x%08x\n"
+							"\thigh: 0x%08x\n",
+							z,
+							rar_addr[z].low,
+							rar_addr[z].high);
 			}
 	       }
 	}
@@ -321,7 +323,8 @@ static int memrar_init_rar_params(struct pci_dev *pdev)
 /*
   function that is activated on the successfull probe of the RAR device
 */
-static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+static int __devinit rar_probe(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
 {
 	/* error */
 	int error;
@@ -347,7 +350,7 @@ static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id
 
 	/* Initialize the RAR parameters, which have to be retrieved */
 	/* via the message bus service */
-	error=memrar_init_rar_params(rar_dev);
+	error = memrar_init_rar_params(rar_dev);
 
 	if (error) {
 		DEBUG_PRINT_0(RAR_DEBUG_LEVEL_EXTENDED,
@@ -388,7 +391,7 @@ MODULE_LICENSE("GPL");
  * int rar_index
  * The rar_index is an index to the rar for which you wish to retrieve
  * the address information.
- * Values can be 0,1, or 2.
+ * Values can be 0,1, or 2.r
  *
  * struct RAR_address_struct is a pointer to a place to which the function
  * can return the address structure for the RAR.
@@ -396,10 +399,10 @@ MODULE_LICENSE("GPL");
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
@@ -431,10 +434,10 @@ int lock_rar(int rar_index)
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
1.6.3.3

