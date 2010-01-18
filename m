Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518Ab0ARVTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab0ARVTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432Ab0ARVTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:19:31 -0500
Received: from mga14.intel.com ([143.182.124.37]:31252 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429Ab0ARVT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:19:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="234070379"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, alan@linux.intel.com,
       charles.f.johnson@intel.com
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH] Rename rar directory to rar_register for clarity
Date: Mon, 18 Jan 2010 13:23:11 -0800
Message-Id: <1263849791-23180-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is the change the name of the
directory for the rar_register driver. The name rar
was too ambiguous, it's being renamed to rar_register for clarity.

This is the fifth of seven patches for the rar_register driver
for Sunday, January 17, 2009

This patch only changes the names. It does not make any changes in
any code.

Any checkpatch errors on this code were from the original code. They
will be addressed in future patches.

The rar stands for restricted access region. The restricted access
region is an area of memory that can be locked from access by the
x86 processor.

The purpose of the restricted access region is to safeguard confidential
information from any unauthorized software running on the x86 processor.

The purpose of this driver is to enable other drivers to obtain
the address ranges of the restricted regions as well as lock them.

This patch is referenced off the linux-next repository as pulled
on Sunday, January 17, 2010

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>

Date: January 17, 2010
---
 drivers/staging/Kconfig                     |    2 +-
 drivers/staging/Makefile                    |    2 +-
 drivers/staging/rar/Kconfig                 |   21 --
 drivers/staging/rar/Makefile                |    1 -
 drivers/staging/rar/rar_register.c          |  445 ---------------------------
 drivers/staging/rar_register/Kconfig        |   21 ++
 drivers/staging/rar_register/Makefile       |    1 +
 drivers/staging/rar_register/rar_register.c |  445 +++++++++++++++++++++++++++
 8 files changed, 469 insertions(+), 469 deletions(-)
 delete mode 100644 drivers/staging/rar/Kconfig
 delete mode 100644 drivers/staging/rar/Makefile
 delete mode 100644 drivers/staging/rar/rar_register.c
 create mode 100644 drivers/staging/rar_register/Kconfig
 create mode 100644 drivers/staging/rar_register/Makefile
 create mode 100644 drivers/staging/rar_register/rar_register.c

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 61ec152..5db72ca 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -113,7 +113,7 @@ source "drivers/staging/hv/Kconfig"
 
 source "drivers/staging/vme/Kconfig"
 
-source "drivers/staging/rar/Kconfig"
+source "drivers/staging/rar_register/Kconfig"
 
 source "drivers/staging/sep/Kconfig"
 
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index dc40493..6415f38 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -36,7 +36,7 @@ obj-$(CONFIG_VT6656)		+= vt6656/
 obj-$(CONFIG_FB_UDL)		+= udlfb/
 obj-$(CONFIG_HYPERV)		+= hv/
 obj-$(CONFIG_VME_BUS)		+= vme/
-obj-$(CONFIG_RAR_REGISTER)	+= rar/
+obj-$(CONFIG_RAR_REGISTER)	+= rar_register/
 obj-$(CONFIG_DX_SEP)		+= sep/
 obj-$(CONFIG_IIO)		+= iio/
 obj-$(CONFIG_RAMZSWAP)		+= ramzswap/
diff --git a/drivers/staging/rar/Kconfig b/drivers/staging/rar/Kconfig
deleted file mode 100644
index e923178..0000000
--- a/drivers/staging/rar/Kconfig
+++ /dev/null
@@ -1,21 +0,0 @@
-#
-# RAR device configuration
-#
-
-menu "RAR Register Driver"
-#
-#	Restricted Access Register Manager
-#
-config RAR_REGISTER
-	tristate "Restricted Access Region Register Driver"
-	---help---
-		This driver allows other kernel drivers access to the
-		contents of the restricted access region control
-		registers. The restricted access regions are areas
-		of memory on the Intel ultra mobile platform which the
-		x86 processor (and software running thereupon) cannot
-		access for reading or writing. It is used the protect
-		sensitive information from unauthorized programms running
-		on the x86 processor.
-
-endmenu
diff --git a/drivers/staging/rar/Makefile b/drivers/staging/rar/Makefile
deleted file mode 100644
index 7f1478b..0000000
--- a/drivers/staging/rar/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-$(CONFIG_RAR_REGISTER) += rar_register.o
diff --git a/drivers/staging/rar/rar_register.c b/drivers/staging/rar/rar_register.c
deleted file mode 100644
index 4b9a3a3..0000000
--- a/drivers/staging/rar/rar_register.c
+++ /dev/null
@@ -1,445 +0,0 @@
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/fs.h>
-#include <linux/cdev.h>
-#include <linux/kdev_t.h>
-#include <linux/semaphore.h>
-#include <linux/mm.h>
-#include <linux/poll.h>
-#include <linux/wait.h>
-#include <linux/ioctl.h>
-#include <linux/ioport.h>
-#include <linux/io.h>
-#include <linux/interrupt.h>
-#include <linux/pagemap.h>
-#include <linux/pci.h>
-#include <linux/firmware.h>
-#include <linux/sched.h>
-#include <linux/rar/rar_register.h>
-#include <linux/rar/memrar.h>
-
-/* The following defines are for the IPC process to retrieve RAR in */
-
-/* === Lincroft Message Bus Interface === */
-/* Message Control Register */
-#define LNC_MCR_OFFSET 0xD0
-
-/* Message Data Register */
-#define LNC_MDR_OFFSET 0xD4
-
-/* Message Opcodes */
-#define LNC_MESSAGE_READ_OPCODE  0xD0
-#define LNC_MESSAGE_WRITE_OPCODE 0xE0
-
-/* Message Write Byte Enables */
-#define LNC_MESSAGE_BYTE_WRITE_ENABLES 0xF
-
-/* B-unit Port */
-#define LNC_BUNIT_PORT 0x3
-
-/* === Lincroft B-Unit Registers - Programmed by IA32 firmware === */
-#define LNC_BRAR0L  0x10
-#define LNC_BRAR0H  0x11
-#define LNC_BRAR1L  0x12
-#define LNC_BRAR1H  0x13
-
-/* Reserved for SeP */
-#define LNC_BRAR2L  0x14
-#define LNC_BRAR2H  0x15
-
-
-/* This structure is only used during module initialization. */
-struct RAR_offsets {
-	int low; /* Register offset for low RAR physical address. */
-	int high; /* Register offset for high RAR physical address. */
-};
-
-struct pci_dev *rar_dev;
-static uint32_t registered;
-
-/* Moorestown supports three restricted access regions. */
-#define MRST_NUM_RAR 3
-
-struct RAR_address_struct rar_addr[MRST_NUM_RAR];
-
-/* prototype for init */
-static int __init rar_init_handler(void);
-static void __exit rar_exit_handler(void);
-
-/*
-  function that is activated on the successfull probe of the RAR device
-*/
-static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
-
-static struct pci_device_id rar_pci_id_tbl[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4110) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, rar_pci_id_tbl);
-
-/* field for registering driver to PCI device */
-static struct pci_driver rar_pci_driver = {
-	.name = "rar_driver",
-	.id_table = rar_pci_id_tbl,
-	.probe = rar_probe
-};
-
-/* This function is used to retrieved RAR info using the IPC message
-   bus interface */
-static int memrar_get_rar_addr(struct pci_dev* pdev,
-	                      int offset,
-	                      u32 *addr)
-{
-	/*
-	 * ======== The Lincroft Message Bus Interface ========
-	 * Lincroft registers may be obtained from the PCI
-	 * (the Host Bridge) using the Lincroft Message Bus
-	 * Interface.  That message bus interface is generally
-	 * comprised of two registers: a control register (MCR, 0xDO)
-	 * and a data register (MDR, 0xD4).
-	 *
-	 * The MCR (message control register) format is the following:
-	 *   1.  [31:24]: Opcode
-	 *   2.  [23:16]: Port
-	 *   3.  [15:8]: Register Offset
-	 *   4.  [7:4]: Byte Enables (use 0xF to set all of these bits
-	 *              to 1)
-	 *   5.  [3:0]: reserved
-	 *
-	 *  Read (0xD0) and write (0xE0) opcodes are written to the
-	 *  control register when reading and writing to Lincroft
-	 *  registers, respectively.
-	 *
-	 *  We're interested in registers found in the Lincroft
-	 *  B-unit.  The B-unit port is 0x3.
-	 *
-	 *  The six B-unit RAR register offsets we use are listed
-	 *  earlier in this file.
-	 *
-	 *  Lastly writing to the MCR register requires the "Byte
-	 *  enables" bits to be set to 1.  This may be achieved by
-	 *  writing 0xF at bit 4.
-	 *
-	 * The MDR (message data register) format is the following:
-	 *   1. [31:0]: Read/Write Data
-	 *
-	 *  Data being read from this register is only available after
-	 *  writing the appropriate control message to the MCR
-	 *  register.
-	 *
-	 *  Data being written to this register must be written before
-	 *  writing the appropriate control message to the MCR
-	 *  register.
-	 */
-
-	int result = 0; /* result */
-	/* Construct control message */
-	u32 const message =
-	       (LNC_MESSAGE_READ_OPCODE << 24)
-	       | (LNC_BUNIT_PORT << 16)
-	       | (offset << 8)
-	       | (LNC_MESSAGE_BYTE_WRITE_ENABLES << 4);
-
-	printk(KERN_WARNING "rar- offset to LNC MSG is %x\n",offset);
-
-	if (addr == 0)
-		return -EINVAL;
-
-	/* Send the control message */
-	result = pci_write_config_dword(pdev,
-	                          LNC_MCR_OFFSET,
-	                          message);
-
-	printk(KERN_WARNING "rar- result from send ctl register is %x\n"
-	  ,result);
-
-	if (!result)
-		result = pci_read_config_dword(pdev,
-		                              LNC_MDR_OFFSET,
-				              addr);
-
-	printk(KERN_WARNING "rar- result from read data register is %x\n",
-	  result);
-
-	printk(KERN_WARNING "rar- value read from data register is %x\n",
-	  *addr);
-
-	if (result)
-		return -1;
-	else
-		return 0;
-}
-
-static int memrar_set_rar_addr(struct pci_dev* pdev,
-	                      int offset,
-	                      u32 addr)
-{
-	/*
-	 * ======== The Lincroft Message Bus Interface ========
-	 * Lincroft registers may be obtained from the PCI
-	 * (the Host Bridge) using the Lincroft Message Bus
-	 * Interface.  That message bus interface is generally
-	 * comprised of two registers: a control register (MCR, 0xDO)
-	 * and a data register (MDR, 0xD4).
-	 *
-	 * The MCR (message control register) format is the following:
-	 *   1.  [31:24]: Opcode
-	 *   2.  [23:16]: Port
-	 *   3.  [15:8]: Register Offset
-	 *   4.  [7:4]: Byte Enables (use 0xF to set all of these bits
-	 *              to 1)
-	 *   5.  [3:0]: reserved
-	 *
-	 *  Read (0xD0) and write (0xE0) opcodes are written to the
-	 *  control register when reading and writing to Lincroft
-	 *  registers, respectively.
-	 *
-	 *  We're interested in registers found in the Lincroft
-	 *  B-unit.  The B-unit port is 0x3.
-	 *
-	 *  The six B-unit RAR register offsets we use are listed
-	 *  earlier in this file.
-	 *
-	 *  Lastly writing to the MCR register requires the "Byte
-	 *  enables" bits to be set to 1.  This may be achieved by
-	 *  writing 0xF at bit 4.
-	 *
-	 * The MDR (message data register) format is the following:
-	 *   1. [31:0]: Read/Write Data
-	 *
-	 *  Data being read from this register is only available after
-	 *  writing the appropriate control message to the MCR
-	 *  register.
-	 *
-	 *  Data being written to this register must be written before
-	 *  writing the appropriate control message to the MCR
-	 *  register.
-	 */
-
-	int result = 0; /* result */
-
-	/* Construct control message */
-	u32 const message =
-	       (LNC_MESSAGE_WRITE_OPCODE << 24)
-	       | (LNC_BUNIT_PORT << 16)
-	       | (offset << 8)
-	       | (LNC_MESSAGE_BYTE_WRITE_ENABLES << 4);
-
-	printk(KERN_WARNING "rar- offset to LNC MSG is %x\n",offset);
-
-	if (addr == 0)
-		return -EINVAL;
-
-	/* Send the control message */
-	result = pci_write_config_dword(pdev,
-	                          LNC_MDR_OFFSET,
-	                          addr);
-
-	printk(KERN_WARNING "rar- result from send ctl register is %x\n"
-	  ,result);
-
-	if (!result)
-		result = pci_write_config_dword(pdev,
-		                              LNC_MCR_OFFSET,
-				              message);
-
-	printk(KERN_WARNING "rar- result from write data register is %x\n",
-	  result);
-
-	printk(KERN_WARNING "rar- value read to data register is %x\n",
-	  addr);
-
-	if (result)
-		return -1;
-	else
-		return 0;
-}
-
-/*
-
- * Initialize RAR parameters, such as physical addresses, etc.
-
- */
-static int memrar_init_rar_params(struct pci_dev *pdev)
-{
-	struct RAR_offsets const offsets[] = {
-	       { LNC_BRAR0L, LNC_BRAR0H },
-	       { LNC_BRAR1L, LNC_BRAR1H },
-	       { LNC_BRAR2L, LNC_BRAR2H }
-	};
-
-	size_t const num_offsets = sizeof(offsets) / sizeof(offsets[0]);
-	struct RAR_offsets const *end = offsets + num_offsets;
-	struct RAR_offsets const *i;
-	unsigned int n = 0;
-	int result = 0;
-
-	/* Retrieve RAR start and end physical addresses. */
-
-	/*
-	 * Access the RAR registers through the Lincroft Message Bus
-	 * Interface on PCI device: 00:00.0 Host bridge.
-	 */
-
-	/* struct pci_dev *pdev = pci_get_bus_and_slot(0, PCI_DEVFN(0,0)); */
-
-	if (pdev == NULL)
-	       return -ENODEV;
-
-	for (i = offsets; i != end; ++i, ++n) {
-	       if (memrar_get_rar_addr (pdev,
-		                       (*i).low,
-		                       &(rar_addr[n].low)) != 0
-		   || memrar_get_rar_addr (pdev,
-		                          (*i).high,
-		                          &(rar_addr[n].high)) != 0) {
-		       result = -1;
-		       break;
-	       }
-	}
-
-	/* Done accessing the device. */
-	/* pci_dev_put(pdev); */
-
-	if (result == 0) {
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
-	}
-
-	return result;
-}
-
-/*
-  function that is activated on the successfull probe of the RAR device
-*/
-static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
-{
-	/* error */
-	int error;
-
-	/*------------------------
-	CODE
-	---------------------------*/
-
-	DEBUG_PRINT_0(RAR_DEBUG_LEVEL_EXTENDED,
-	  "Rar pci probe starting\n");
-	error = 0;
-
-	/* enable the device */
-	error = pci_enable_device(pdev);
-	if (error) {
-		DEBUG_PRINT_0(RAR_DEBUG_LEVEL_EXTENDED,
-		  "error enabling pci device\n");
-		goto end_function;
-	}
-
-	rar_dev = pdev;
-	registered = 1;
-
-	/* Initialize the RAR parameters, which have to be retrieved */
-	/* via the message bus service */
-	error=memrar_init_rar_params(rar_dev);
-
-	if (error) {
-		DEBUG_PRINT_0(RAR_DEBUG_LEVEL_EXTENDED,
-		  "error getting RAR addresses device\n");
-		registered = 0;
-		goto end_function;
-		}
-
-end_function:
-
-	return error;
-}
-
-/*
-  this function registers th driver to
-  the device subsystem( either PCI, USB, etc)
-*/
-static int __init rar_init_handler(void)
-{
-	return pci_register_driver(&rar_pci_driver);
-}
-
-static void __exit rar_exit_handler(void)
-{
-	pci_unregister_driver(&rar_pci_driver);
-}
-
-module_init(rar_init_handler);
-module_exit(rar_exit_handler);
-
-MODULE_LICENSE("GPL");
-
-
-/* The get_rar_address function is used by other device drivers
- * to obtain RAR address information on a RAR. It takes two
- * parameter:
- *
- * int rar_index
- * The rar_index is an index to the rar for which you wish to retrieve
- * the address information.
- * Values can be 0,1, or 2.
- *
- * struct RAR_address_struct is a pointer to a place to which the function
- * can return the address structure for the RAR.
- *
- * The function returns a 0 upon success or a -1 if there is no RAR
- * facility on this system.
- */
-int get_rar_address(int rar_index,struct RAR_address_struct *addresses)
-{
-	if (registered && (rar_index < 3) && (rar_index >= 0)) {
-		*addresses=rar_addr[rar_index];
-		/* strip off lock bit information  */
-		addresses->low = addresses->low & 0xfffffff0;
-		addresses->high = addresses->high & 0xfffffff0;
-		return 0;
-		}
-
-	else {
-		return -ENODEV;
-		}
-}
-
-
-EXPORT_SYMBOL(get_rar_address);
-
-/* The lock_rar function is ued by other device drivers to lock an RAR.
- * once an RAR is locked, it stays locked until the next system reboot.
- * The function takes one parameter:
- *
- * int rar_index
- * The rar_index is an index to the rar that you want to lock.
- * Values can be 0,1, or 2.
- *
- * The function returns a 0 upon success or a -1 if there is no RAR
- * facility on this system.
- */
-int lock_rar(int rar_index)
-{
-	u32 working_addr;
-	int result;
-if (registered && (rar_index < 3) && (rar_index >= 0)) {
-	/* first make sure that lock bits are clear (this does lock) */
-	working_addr=rar_addr[rar_index].low & 0xfffffff0;
-
-	/* now send that value to the register using the IPC */
-        result=memrar_set_rar_addr(rar_dev,rar_index,working_addr);
-	return result;
-	}
-
-else {
-	return -ENODEV;
-	}
-}
diff --git a/drivers/staging/rar_register/Kconfig b/drivers/staging/rar_register/Kconfig
new file mode 100644
index 0000000..e923178
--- /dev/null
+++ b/drivers/staging/rar_register/Kconfig
@@ -0,0 +1,21 @@
+#
+# RAR device configuration
+#
+
+menu "RAR Register Driver"
+#
+#	Restricted Access Register Manager
+#
+config RAR_REGISTER
+	tristate "Restricted Access Region Register Driver"
+	---help---
+		This driver allows other kernel drivers access to the
+		contents of the restricted access region control
+		registers. The restricted access regions are areas
+		of memory on the Intel ultra mobile platform which the
+		x86 processor (and software running thereupon) cannot
+		access for reading or writing. It is used the protect
+		sensitive information from unauthorized programms running
+		on the x86 processor.
+
+endmenu
diff --git a/drivers/staging/rar_register/Makefile b/drivers/staging/rar_register/Makefile
new file mode 100644
index 0000000..7f1478b
--- /dev/null
+++ b/drivers/staging/rar_register/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_RAR_REGISTER) += rar_register.o
diff --git a/drivers/staging/rar_register/rar_register.c b/drivers/staging/rar_register/rar_register.c
new file mode 100644
index 0000000..4b9a3a3
--- /dev/null
+++ b/drivers/staging/rar_register/rar_register.c
@@ -0,0 +1,445 @@
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/kdev_t.h>
+#include <linux/semaphore.h>
+#include <linux/mm.h>
+#include <linux/poll.h>
+#include <linux/wait.h>
+#include <linux/ioctl.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/pagemap.h>
+#include <linux/pci.h>
+#include <linux/firmware.h>
+#include <linux/sched.h>
+#include <linux/rar/rar_register.h>
+#include <linux/rar/memrar.h>
+
+/* The following defines are for the IPC process to retrieve RAR in */
+
+/* === Lincroft Message Bus Interface === */
+/* Message Control Register */
+#define LNC_MCR_OFFSET 0xD0
+
+/* Message Data Register */
+#define LNC_MDR_OFFSET 0xD4
+
+/* Message Opcodes */
+#define LNC_MESSAGE_READ_OPCODE  0xD0
+#define LNC_MESSAGE_WRITE_OPCODE 0xE0
+
+/* Message Write Byte Enables */
+#define LNC_MESSAGE_BYTE_WRITE_ENABLES 0xF
+
+/* B-unit Port */
+#define LNC_BUNIT_PORT 0x3
+
+/* === Lincroft B-Unit Registers - Programmed by IA32 firmware === */
+#define LNC_BRAR0L  0x10
+#define LNC_BRAR0H  0x11
+#define LNC_BRAR1L  0x12
+#define LNC_BRAR1H  0x13
+
+/* Reserved for SeP */
+#define LNC_BRAR2L  0x14
+#define LNC_BRAR2H  0x15
+
+
+/* This structure is only used during module initialization. */
+struct RAR_offsets {
+	int low; /* Register offset for low RAR physical address. */
+	int high; /* Register offset for high RAR physical address. */
+};
+
+struct pci_dev *rar_dev;
+static uint32_t registered;
+
+/* Moorestown supports three restricted access regions. */
+#define MRST_NUM_RAR 3
+
+struct RAR_address_struct rar_addr[MRST_NUM_RAR];
+
+/* prototype for init */
+static int __init rar_init_handler(void);
+static void __exit rar_exit_handler(void);
+
+/*
+  function that is activated on the successfull probe of the RAR device
+*/
+static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
+
+static struct pci_device_id rar_pci_id_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4110) },
+	{ 0 }
+};
+
+MODULE_DEVICE_TABLE(pci, rar_pci_id_tbl);
+
+/* field for registering driver to PCI device */
+static struct pci_driver rar_pci_driver = {
+	.name = "rar_driver",
+	.id_table = rar_pci_id_tbl,
+	.probe = rar_probe
+};
+
+/* This function is used to retrieved RAR info using the IPC message
+   bus interface */
+static int memrar_get_rar_addr(struct pci_dev* pdev,
+	                      int offset,
+	                      u32 *addr)
+{
+	/*
+	 * ======== The Lincroft Message Bus Interface ========
+	 * Lincroft registers may be obtained from the PCI
+	 * (the Host Bridge) using the Lincroft Message Bus
+	 * Interface.  That message bus interface is generally
+	 * comprised of two registers: a control register (MCR, 0xDO)
+	 * and a data register (MDR, 0xD4).
+	 *
+	 * The MCR (message control register) format is the following:
+	 *   1.  [31:24]: Opcode
+	 *   2.  [23:16]: Port
+	 *   3.  [15:8]: Register Offset
+	 *   4.  [7:4]: Byte Enables (use 0xF to set all of these bits
+	 *              to 1)
+	 *   5.  [3:0]: reserved
+	 *
+	 *  Read (0xD0) and write (0xE0) opcodes are written to the
+	 *  control register when reading and writing to Lincroft
+	 *  registers, respectively.
+	 *
+	 *  We're interested in registers found in the Lincroft
+	 *  B-unit.  The B-unit port is 0x3.
+	 *
+	 *  The six B-unit RAR register offsets we use are listed
+	 *  earlier in this file.
+	 *
+	 *  Lastly writing to the MCR register requires the "Byte
+	 *  enables" bits to be set to 1.  This may be achieved by
+	 *  writing 0xF at bit 4.
+	 *
+	 * The MDR (message data register) format is the following:
+	 *   1. [31:0]: Read/Write Data
+	 *
+	 *  Data being read from this register is only available after
+	 *  writing the appropriate control message to the MCR
+	 *  register.
+	 *
+	 *  Data being written to this register must be written before
+	 *  writing the appropriate control message to the MCR
+	 *  register.
+	 */
+
+	int result = 0; /* result */
+	/* Construct control message */
+	u32 const message =
+	       (LNC_MESSAGE_READ_OPCODE << 24)
+	       | (LNC_BUNIT_PORT << 16)
+	       | (offset << 8)
+	       | (LNC_MESSAGE_BYTE_WRITE_ENABLES << 4);
+
+	printk(KERN_WARNING "rar- offset to LNC MSG is %x\n",offset);
+
+	if (addr == 0)
+		return -EINVAL;
+
+	/* Send the control message */
+	result = pci_write_config_dword(pdev,
+	                          LNC_MCR_OFFSET,
+	                          message);
+
+	printk(KERN_WARNING "rar- result from send ctl register is %x\n"
+	  ,result);
+
+	if (!result)
+		result = pci_read_config_dword(pdev,
+		                              LNC_MDR_OFFSET,
+				              addr);
+
+	printk(KERN_WARNING "rar- result from read data register is %x\n",
+	  result);
+
+	printk(KERN_WARNING "rar- value read from data register is %x\n",
+	  *addr);
+
+	if (result)
+		return -1;
+	else
+		return 0;
+}
+
+static int memrar_set_rar_addr(struct pci_dev* pdev,
+	                      int offset,
+	                      u32 addr)
+{
+	/*
+	 * ======== The Lincroft Message Bus Interface ========
+	 * Lincroft registers may be obtained from the PCI
+	 * (the Host Bridge) using the Lincroft Message Bus
+	 * Interface.  That message bus interface is generally
+	 * comprised of two registers: a control register (MCR, 0xDO)
+	 * and a data register (MDR, 0xD4).
+	 *
+	 * The MCR (message control register) format is the following:
+	 *   1.  [31:24]: Opcode
+	 *   2.  [23:16]: Port
+	 *   3.  [15:8]: Register Offset
+	 *   4.  [7:4]: Byte Enables (use 0xF to set all of these bits
+	 *              to 1)
+	 *   5.  [3:0]: reserved
+	 *
+	 *  Read (0xD0) and write (0xE0) opcodes are written to the
+	 *  control register when reading and writing to Lincroft
+	 *  registers, respectively.
+	 *
+	 *  We're interested in registers found in the Lincroft
+	 *  B-unit.  The B-unit port is 0x3.
+	 *
+	 *  The six B-unit RAR register offsets we use are listed
+	 *  earlier in this file.
+	 *
+	 *  Lastly writing to the MCR register requires the "Byte
+	 *  enables" bits to be set to 1.  This may be achieved by
+	 *  writing 0xF at bit 4.
+	 *
+	 * The MDR (message data register) format is the following:
+	 *   1. [31:0]: Read/Write Data
+	 *
+	 *  Data being read from this register is only available after
+	 *  writing the appropriate control message to the MCR
+	 *  register.
+	 *
+	 *  Data being written to this register must be written before
+	 *  writing the appropriate control message to the MCR
+	 *  register.
+	 */
+
+	int result = 0; /* result */
+
+	/* Construct control message */
+	u32 const message =
+	       (LNC_MESSAGE_WRITE_OPCODE << 24)
+	       | (LNC_BUNIT_PORT << 16)
+	       | (offset << 8)
+	       | (LNC_MESSAGE_BYTE_WRITE_ENABLES << 4);
+
+	printk(KERN_WARNING "rar- offset to LNC MSG is %x\n",offset);
+
+	if (addr == 0)
+		return -EINVAL;
+
+	/* Send the control message */
+	result = pci_write_config_dword(pdev,
+	                          LNC_MDR_OFFSET,
+	                          addr);
+
+	printk(KERN_WARNING "rar- result from send ctl register is %x\n"
+	  ,result);
+
+	if (!result)
+		result = pci_write_config_dword(pdev,
+		                              LNC_MCR_OFFSET,
+				              message);
+
+	printk(KERN_WARNING "rar- result from write data register is %x\n",
+	  result);
+
+	printk(KERN_WARNING "rar- value read to data register is %x\n",
+	  addr);
+
+	if (result)
+		return -1;
+	else
+		return 0;
+}
+
+/*
+
+ * Initialize RAR parameters, such as physical addresses, etc.
+
+ */
+static int memrar_init_rar_params(struct pci_dev *pdev)
+{
+	struct RAR_offsets const offsets[] = {
+	       { LNC_BRAR0L, LNC_BRAR0H },
+	       { LNC_BRAR1L, LNC_BRAR1H },
+	       { LNC_BRAR2L, LNC_BRAR2H }
+	};
+
+	size_t const num_offsets = sizeof(offsets) / sizeof(offsets[0]);
+	struct RAR_offsets const *end = offsets + num_offsets;
+	struct RAR_offsets const *i;
+	unsigned int n = 0;
+	int result = 0;
+
+	/* Retrieve RAR start and end physical addresses. */
+
+	/*
+	 * Access the RAR registers through the Lincroft Message Bus
+	 * Interface on PCI device: 00:00.0 Host bridge.
+	 */
+
+	/* struct pci_dev *pdev = pci_get_bus_and_slot(0, PCI_DEVFN(0,0)); */
+
+	if (pdev == NULL)
+	       return -ENODEV;
+
+	for (i = offsets; i != end; ++i, ++n) {
+	       if (memrar_get_rar_addr (pdev,
+		                       (*i).low,
+		                       &(rar_addr[n].low)) != 0
+		   || memrar_get_rar_addr (pdev,
+		                          (*i).high,
+		                          &(rar_addr[n].high)) != 0) {
+		       result = -1;
+		       break;
+	       }
+	}
+
+	/* Done accessing the device. */
+	/* pci_dev_put(pdev); */
+
+	if (result == 0) {
+	if(1) {
+	       size_t z;
+	       for (z = 0; z != MRST_NUM_RAR; ++z) {
+			printk(KERN_WARNING "rar - BRAR[%Zd] physical address low\n"
+			     "\tlow:  0x%08x\n"
+			     "\thigh: 0x%08x\n",
+			     z,
+			     rar_addr[z].low,
+			     rar_addr[z].high);
+			}
+	       }
+	}
+
+	return result;
+}
+
+/*
+  function that is activated on the successfull probe of the RAR device
+*/
+static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	/* error */
+	int error;
+
+	/*------------------------
+	CODE
+	---------------------------*/
+
+	DEBUG_PRINT_0(RAR_DEBUG_LEVEL_EXTENDED,
+	  "Rar pci probe starting\n");
+	error = 0;
+
+	/* enable the device */
+	error = pci_enable_device(pdev);
+	if (error) {
+		DEBUG_PRINT_0(RAR_DEBUG_LEVEL_EXTENDED,
+		  "error enabling pci device\n");
+		goto end_function;
+	}
+
+	rar_dev = pdev;
+	registered = 1;
+
+	/* Initialize the RAR parameters, which have to be retrieved */
+	/* via the message bus service */
+	error=memrar_init_rar_params(rar_dev);
+
+	if (error) {
+		DEBUG_PRINT_0(RAR_DEBUG_LEVEL_EXTENDED,
+		  "error getting RAR addresses device\n");
+		registered = 0;
+		goto end_function;
+		}
+
+end_function:
+
+	return error;
+}
+
+/*
+  this function registers th driver to
+  the device subsystem( either PCI, USB, etc)
+*/
+static int __init rar_init_handler(void)
+{
+	return pci_register_driver(&rar_pci_driver);
+}
+
+static void __exit rar_exit_handler(void)
+{
+	pci_unregister_driver(&rar_pci_driver);
+}
+
+module_init(rar_init_handler);
+module_exit(rar_exit_handler);
+
+MODULE_LICENSE("GPL");
+
+
+/* The get_rar_address function is used by other device drivers
+ * to obtain RAR address information on a RAR. It takes two
+ * parameter:
+ *
+ * int rar_index
+ * The rar_index is an index to the rar for which you wish to retrieve
+ * the address information.
+ * Values can be 0,1, or 2.
+ *
+ * struct RAR_address_struct is a pointer to a place to which the function
+ * can return the address structure for the RAR.
+ *
+ * The function returns a 0 upon success or a -1 if there is no RAR
+ * facility on this system.
+ */
+int get_rar_address(int rar_index,struct RAR_address_struct *addresses)
+{
+	if (registered && (rar_index < 3) && (rar_index >= 0)) {
+		*addresses=rar_addr[rar_index];
+		/* strip off lock bit information  */
+		addresses->low = addresses->low & 0xfffffff0;
+		addresses->high = addresses->high & 0xfffffff0;
+		return 0;
+		}
+
+	else {
+		return -ENODEV;
+		}
+}
+
+
+EXPORT_SYMBOL(get_rar_address);
+
+/* The lock_rar function is ued by other device drivers to lock an RAR.
+ * once an RAR is locked, it stays locked until the next system reboot.
+ * The function takes one parameter:
+ *
+ * int rar_index
+ * The rar_index is an index to the rar that you want to lock.
+ * Values can be 0,1, or 2.
+ *
+ * The function returns a 0 upon success or a -1 if there is no RAR
+ * facility on this system.
+ */
+int lock_rar(int rar_index)
+{
+	u32 working_addr;
+	int result;
+if (registered && (rar_index < 3) && (rar_index >= 0)) {
+	/* first make sure that lock bits are clear (this does lock) */
+	working_addr=rar_addr[rar_index].low & 0xfffffff0;
+
+	/* now send that value to the register using the IPC */
+        result=memrar_set_rar_addr(rar_dev,rar_index,working_addr);
+	return result;
+	}
+
+else {
+	return -ENODEV;
+	}
+}
-- 
1.6.0.6

