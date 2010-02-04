Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab0BDVaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 16:30:06 -0500
Received: from polaris.joshh.co.uk ([212.13.195.18]:36275 "EHLO
	polaris.joshh.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab0BDVaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 16:30:04 -0500
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Feb 2010 16:30:04 EST
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
From: Josh Holland <jrh@joshh.co.uk>
To: gregkh@suse.de, alan@linux.intel.com, andre.goddard@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Josh Holland <jrh@joshh.co.uk>
Subject: [PATCH] Staging: rar: fixed up rar_driver.{h,c}
Date: Thu,  4 Feb 2010 21:23:05 +0000
Message-Id: <1265318585-24236-1-git-send-email-jrh@joshh.co.uk>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the rar_driver.c and rar_driver.h files to remove
style issues found by the checkpatch.pl script.

Signed-off-by: Josh Holland <jrh@joshh.co.uk>
---
 drivers/staging/rar/rar_driver.c |   92 ++++++++++++++++----------------------
 drivers/staging/rar/rar_driver.h |   72 +++++++++++------------------
 2 files changed, 67 insertions(+), 97 deletions(-)

diff --git a/drivers/staging/rar/rar_driver.c b/drivers/staging/rar/rar_driver.c
index d85d189..886a819 100644
--- a/drivers/staging/rar/rar_driver.c
+++ b/drivers/staging/rar/rar_driver.c
@@ -68,7 +68,8 @@ static void __exit rar_exit_handler(void);
 /*
   function that is activated on the successfull probe of the RAR device
 */
-static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
+static int __devinit rar_probe(struct pci_dev *pdev,
+	const struct pci_device_id *ent);
 
 static struct pci_device_id rar_pci_id_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4110) },
@@ -86,9 +87,7 @@ static struct pci_driver rar_pci_driver = {
 
 /* This function is used to retrieved RAR info using the IPC message
    bus interface */
-static int memrar_get_rar_addr(struct pci_dev* pdev,
-	                      int offset,
-	                      u32 *addr)
+static int memrar_get_rar_addr(struct pci_dev *pdev, int offset, u32 *addr)
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
+			result);
 
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
@@ -225,23 +218,19 @@ static int memrar_set_rar_addr(struct pci_dev* pdev,
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
 
-	printk(KERN_WARNING "rar- result from send ctl register is %x\n"
-	  ,result);
+	printk(KERN_WARNING "rar- result from send ctl register is %x\n",
+			result);
 
 	if (!result)
-		result = pci_write_config_dword(pdev,
-		                              LNC_MCR_OFFSET,
-				              message);
+		result = pci_write_config_dword(pdev, LNC_MCR_OFFSET, message);
 
 	printk(KERN_WARNING "rar- result from write data register is %x\n",
 	  result);
@@ -284,35 +273,31 @@ static int memrar_init_rar_params(struct pci_dev *pdev)
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
-	       }
+		if (memrar_get_rar_addr(pdev, (*i).low, &(rar_addr[n].low))
+			|| memrar_get_rar_addr(pdev, (*i).high,
+			   &(rar_addr[n].high))) {
+			result = -1;
+			break;
+		}
 	}
 
 	/* Done accessing the device. */
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
-			}
-	       }
+		size_t z;
+		for (z = 0; z != MRST_NUM_RAR; ++z) {
+			printk(KERN_WARNING "rar - "
+			"BRAR[%Zd] physical address low\n"
+			"\tlow:  0x%08x\n"
+			"\thigh: 0x%08x\n",
+			z,
+			rar_addr[z].low,
+			rar_addr[z].high);
+	}
 	}
 
 	return result;
@@ -321,7 +306,8 @@ static int memrar_init_rar_params(struct pci_dev *pdev)
 /*
   function that is activated on the successfull probe of the RAR device
 */
-static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+static int __devinit rar_probe(struct pci_dev *pdev,
+		const struct pci_device_id *ent)
 {
 	/* error */
 	int error;
@@ -347,7 +333,7 @@ static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id
 
 	/* Initialize the RAR parameters, which have to be retrieved */
 	/* via the message bus service */
-	error=memrar_init_rar_params(rar_dev);
+	error = memrar_init_rar_params(rar_dev);
 
 	if (error) {
 		DEBUG_PRINT_0(RAR_DEBUG_LEVEL_EXTENDED,
@@ -396,10 +382,10 @@ MODULE_LICENSE("GPL");
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
@@ -410,9 +396,9 @@ int get_rar_address(int rar_index,struct RAR_address_struct *addresses)
 		return -ENODEV;
 		}
 }
+EXPORT_SYMBOL(get_rar_address);
 
 
-EXPORT_SYMBOL(get_rar_address);
 
 /* The lock_rar function is ued by other device drivers to lock an RAR.
  * once an RAR is locked, it stays locked until the next system reboot.
@@ -431,10 +417,10 @@ int lock_rar(int rar_index)
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
 
diff --git a/drivers/staging/rar/rar_driver.h b/drivers/staging/rar/rar_driver.h
index 3690f98..567cc7e 100644
--- a/drivers/staging/rar/rar_driver.h
+++ b/drivers/staging/rar/rar_driver.h
@@ -1,7 +1,7 @@
 /* === RAR Physical Addresses === */
 struct RAR_address_struct {
-        u32 low;
-        u32 high;
+	u32 low;
+	u32 high;
 };
 
 /* The get_rar_address function is used by other device drivers
@@ -19,7 +19,7 @@ struct RAR_address_struct {
  * The function returns a 0 upon success or a -1 if there is no RAR
  * facility on this system.
  */
-int get_rar_address(int rar_index,struct RAR_address_struct *addresses);
+int get_rar_address(int rar_index, struct RAR_address_struct *addresses);
 
 
 /* The lock_rar function is ued by other device drivers to lock an RAR.
@@ -48,52 +48,36 @@ int lock_rar(int rar_index);
 /* FUNCTIONAL MACROS */
 
 /* debug macro without paramaters */
-#define DEBUG_PRINT_0(DEBUG_LEVEL , info) \
-do \
-{ \
-  if(DEBUG_LEVEL) \
-  { \
-    printk(KERN_WARNING info); \
-  } \
-}while(0)
+#define DEBUG_PRINT_0(DEBUG_LEVEL, info) \
+do { \
+	if (DEBUG_LEVEL) \
+		printk(KERN_WARNING info); \
+} while (0)
 
 /* debug macro with 1 paramater */
-#define DEBUG_PRINT_1(DEBUG_LEVEL , info , param1) \
-do \
-{ \
-  if(DEBUG_LEVEL) \
-  { \
-    printk(KERN_WARNING info , param1); \
-  } \
-}while(0)
+#define DEBUG_PRINT_1(DEBUG_LEVEL, info , param1) \
+do { \
+	if (DEBUG_LEVEL) \
+		printk(KERN_WARNING info, param1); \
+} while (0)
 
 /* debug macro with 2 paramaters */
-#define DEBUG_PRINT_2(DEBUG_LEVEL , info , param1, param2) \
-do \
-{ \
-  if(DEBUG_LEVEL) \
-  { \
-    printk(KERN_WARNING info , param1, param2); \
-  } \
-}while(0)
+#define DEBUG_PRINT_2(DEBUG_LEVEL, info, param1, param2) \
+do { \
+	if (DEBUG_LEVEL) \
+		printk(KERN_WARNING info, param1, param2); \
+} while (0)
 
 /* debug macro with 3 paramaters */
-#define DEBUG_PRINT_3(DEBUG_LEVEL , info , param1, param2 , param3) \
-do \
-{ \
-  if(DEBUG_LEVEL) \
-  { \
-    printk(KERN_WARNING info , param1, param2 , param3); \
-  } \
-}while(0)
+#define DEBUG_PRINT_3(DEBUG_LEVEL, info, param1, param2, param3) \
+do { \
+	if (DEBUG_LEVEL) \
+		printk(KERN_WARNING info, param1, param2, param3); \
+} while (0)
 
 /* debug macro with 4 paramaters */
-#define DEBUG_PRINT_4(DEBUG_LEVEL , info , param1, param2 , param3 , param4) \
-do \
-{ \
-  if(DEBUG_LEVEL) \
-  { \
-    printk(KERN_WARNING info , param1, param2 , param3 , param4); \
-  } \
-}while(0)
-
+#define DEBUG_PRINT_4(DEBUG_LEVEL, info, param1, param2, param3, param4) \
+do { \
+	if (DEBUG_LEVEL) \
+		printk(KERN_WARNING info, param1, param2, param3, param4); \
+} while (0)
-- 
1.6.3.3

