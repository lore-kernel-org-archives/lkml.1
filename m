Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729Ab0BESsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 13:48:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:31257 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933728Ab0BESsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 13:48:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,414,1262592000"; 
   d="scan'208";a="770519050"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, alan@linux.intel.com,
       charles.f.johnson@intel.com, greg@kroah.com
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH 4/6] staging:rar_register: fix checkpatch errors and debug header file
Date: Fri,  5 Feb 2010 10:53:00 -0800
Message-Id: <1265395980-16029-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/rar_register/rar_register.h |  115 +++++++++++++--------------
 1 files changed, 55 insertions(+), 60 deletions(-)

diff --git a/drivers/staging/rar_register/rar_register.h b/drivers/staging/rar_register/rar_register.h
index 4172fbf..29ade0f 100644
--- a/drivers/staging/rar_register/rar_register.h
+++ b/drivers/staging/rar_register/rar_register.h
@@ -1,9 +1,53 @@
-/* === RAR Physical Addresses === */
-struct RAR_address_struct {
-	u32 low;
-	u32 high;
+/*
+ * Copyright (C) 2010 Intel Corporation. All rights reserved.
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
+/* following are used both in drivers as well as user space apps */
+enum RAR_type {
+	RAR_TYPE_VIDEO = 0,
+	RAR_TYPE_AUDIO,
+	RAR_TYPE_IMAGE,
+	RAR_TYPE_DATA
 };
 
+#ifdef __KERNEL__
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
+
 /* The get_rar_address function is used by other device drivers
  * to obtain RAR address information on a RAR. It takes two
  * parameter:
@@ -19,10 +63,11 @@ struct RAR_address_struct {
  * The function returns a 0 upon success or a -1 if there is no RAR
  * facility on this system.
  */
-int get_rar_address(int rar_index, struct RAR_address_struct *addresses);
-
+int rar_get_address(int rar_index,
+		dma_addr_t *start_address,
+		dma_addr_t *end_address);
 
-/* The lock_rar function is used by other device drivers to lock an RAR.
+/* The lock_rar function is ued by other device drivers to lock an RAR.
  * once an RAR is locked, it stays locked until the next system reboot.
  * The function takes one parameter:
  *
@@ -33,57 +78,7 @@ int get_rar_address(int rar_index, struct RAR_address_struct *addresses);
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
-do { \
-	if (DEBUG_LEVEL) { \
-		printk(KERN_WARNING info); \
-	} \
-} while (0)
-
-/* debug macro with 1 paramater */
-#define DEBUG_PRINT_1(DEBUG_LEVEL , info , param1) \
-do { \
-	if (DEBUG_LEVEL) { \
-		printk(KERN_WARNING info , param1); \
-	} \
-} while (0)
-
-/* debug macro with 2 paramaters */
-#define DEBUG_PRINT_2(DEBUG_LEVEL , info , param1, param2) \
-do { \
-	if (DEBUG_LEVEL) { \
-		printk(KERN_WARNING info , param1, param2); \
-	} \
-} while (0)
-
-/* debug macro with 3 paramaters */
-#define DEBUG_PRINT_3(DEBUG_LEVEL , info , param1, param2 , param3) \
-do { \
-	if (DEBUG_LEVEL) { \
-		printk(KERN_WARNING info , param1, param2 , param3); \
-	} \
-} while (0)
-
-/* debug macro with 4 paramaters */
-#define DEBUG_PRINT_4(DEBUG_LEVEL , info , param1, param2 , param3 , param4) \
-do { \
-	if (DEBUG_LEVEL) { \
-		printk(KERN_WARNING info , param1, param2 , param3 , param4); \
-	} \
-} while (0)
+int rar_lock(int rar_index);
 
+#endif  /* __KERNEL__ */
+#endif  /* _RAR_REGISTER_H */
-- 
1.6.0.6

