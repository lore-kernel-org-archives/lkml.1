Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585Ab0ARVTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab0ARVTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402Ab0ARVTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:19:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:28125 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322Ab0ARVTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:19:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,298,1262592000"; 
   d="scan'208";a="532321954"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, alan@linux.intel.com,
       charles.f.johnson@intel.com
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH] Update rar_register.h to clean up checkpatch errors and debug
Date: Mon, 18 Jan 2010 13:23:26 -0800
Message-Id: <1263849806-23207-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to clean up the rar_register
header file so that has proper data types for kernel drivers,
clean up checkpatch issues, and then removing bugs

This is the sixth of seven patches for the rar_register driver
for Sunday, January 17, 2009

The rar stands for restricted access region. The restricted access
region is an area of memory that can be locked from access by the
x86 processor.

The purpose of the restricted access region is to safeguard confidential
information from any unauthorized software running on the x86 processor.

The purpose of this driver is to enable other drivers to obtain
the address ranges of the restricted regions as well as lock them.

This patch is referenced off the linux-next repository as pulled
on Sunday, January 17, 2010.

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>

Date: January 17, 2010
---
 include/linux/rar/rar_register.h |  114 +++++++++++++++-----------------------
 1 files changed, 44 insertions(+), 70 deletions(-)

diff --git a/include/linux/rar/rar_register.h b/include/linux/rar/rar_register.h
index 3690f98..35208f8 100644
--- a/include/linux/rar/rar_register.h
+++ b/include/linux/rar/rar_register.h
@@ -1,8 +1,42 @@
-/* === RAR Physical Addresses === */
-struct RAR_address_struct {
-        u32 low;
-        u32 high;
-};
+/*
+ * Copyright (C) 2008, 2009 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General
+ * Public License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be
+ * useful, but WITHOUT ANY WARRANTY; without even the implied
+ * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
+ * PURPOSE.  See the GNU General Public License for more details.
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the Free
+ * Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA  02111-1307, USA.
+ * The full GNU General Public License is included in this
+ * distribution in the file called COPYING.
+ */
+
+
+#ifndef _RAR_REGISTER_H
+#define _RAR_REGISTER_H
+
+# include <linux/types.h>
+
+/* PCI device id for controller */
+#define PCI_RAR_DEVICE_ID 0x4110
+
+/* The register_rar function is to used by other device drivers
+ * to ensure that this driver is ready. As we cannot be sure of
+ * the compile/execute order of dirvers in ther kernel, it is
+ * best to give this driver a callback function to call when
+ * it is ready to give out addresses. The callback function
+ * would have those steps that continue the initialization of
+ * a driver that do require a valid RAR address. One of those
+ * steps would be to call get_rar_address()
+ * This function return 0 on success an -1 on failure.
+ */
+int register_rar(int (*callback)(void *yourparameter), void *yourparameter);
 
 /* The get_rar_address function is used by other device drivers
  * to obtain RAR address information on a RAR. It takes two
@@ -19,8 +53,9 @@ struct RAR_address_struct {
  * The function returns a 0 upon success or a -1 if there is no RAR
  * facility on this system.
  */
-int get_rar_address(int rar_index,struct RAR_address_struct *addresses);
-
+int rar_get_address(int rar_index,
+		dma_addr_t *start_address,
+		dma_addr_t *end_address);
 
 /* The lock_rar function is ued by other device drivers to lock an RAR.
  * once an RAR is locked, it stays locked until the next system reboot.
@@ -33,67 +68,6 @@ int get_rar_address(int rar_index,struct RAR_address_struct *addresses);
  * The function returns a 0 upon success or a -1 if there is no RAR
  * facility on this system.
  */
-int lock_rar(int rar_index);
-
-
-/* DEBUG LEVEL MASKS */
-#define RAR_DEBUG_LEVEL_BASIC       0x1
-
-#define RAR_DEBUG_LEVEL_REGISTERS   0x2
-
-#define RAR_DEBUG_LEVEL_EXTENDED    0x4
-
-#define DEBUG_LEVEL	0x7
-
-/* FUNCTIONAL MACROS */
-
-/* debug macro without paramaters */
-#define DEBUG_PRINT_0(DEBUG_LEVEL , info) \
-do \
-{ \
-  if(DEBUG_LEVEL) \
-  { \
-    printk(KERN_WARNING info); \
-  } \
-}while(0)
-
-/* debug macro with 1 paramater */
-#define DEBUG_PRINT_1(DEBUG_LEVEL , info , param1) \
-do \
-{ \
-  if(DEBUG_LEVEL) \
-  { \
-    printk(KERN_WARNING info , param1); \
-  } \
-}while(0)
-
-/* debug macro with 2 paramaters */
-#define DEBUG_PRINT_2(DEBUG_LEVEL , info , param1, param2) \
-do \
-{ \
-  if(DEBUG_LEVEL) \
-  { \
-    printk(KERN_WARNING info , param1, param2); \
-  } \
-}while(0)
-
-/* debug macro with 3 paramaters */
-#define DEBUG_PRINT_3(DEBUG_LEVEL , info , param1, param2 , param3) \
-do \
-{ \
-  if(DEBUG_LEVEL) \
-  { \
-    printk(KERN_WARNING info , param1, param2 , param3); \
-  } \
-}while(0)
-
-/* debug macro with 4 paramaters */
-#define DEBUG_PRINT_4(DEBUG_LEVEL , info , param1, param2 , param3 , param4) \
-do \
-{ \
-  if(DEBUG_LEVEL) \
-  { \
-    printk(KERN_WARNING info , param1, param2 , param3 , param4); \
-  } \
-}while(0)
+int rar_lock(int rar_index);
 
+#endif  /* _RAR_REGISTER_H */
-- 
1.6.0.6

