Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271Ab0ARVSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab0ARVSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163Ab0ARVSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:18:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:43408 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab0ARVSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:18:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,298,1262592000"; 
   d="scan'208";a="765246383"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, alan@linux.intel.com,
       charles.f.johnson@intel.com
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH] Move rar_register.h file to include/linux/rar
Date: Mon, 18 Jan 2010 13:22:24 -0800
Message-Id: <1263849744-23098-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to move the rar_register.h file from
the driver source code directory to a subdirectory in the kernel's
include tree; at incluce/linux/rar.

This is the second of seven patches for the rar_register driver
for Sunday, January 17, 2009

This is to provide visibility to other device driver developers.

This patch only does the move. It does not make any changes in
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
 drivers/staging/rar/rar_register.c |    2 +-
 drivers/staging/rar/rar_register.h |   99 ------------------------------------
 include/linux/rar/rar_register.h   |   99 ++++++++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+), 100 deletions(-)
 delete mode 100644 drivers/staging/rar/rar_register.h
 create mode 100644 include/linux/rar/rar_register.h

diff --git a/drivers/staging/rar/rar_register.c b/drivers/staging/rar/rar_register.c
index a23a1f6..836d383 100644
--- a/drivers/staging/rar/rar_register.c
+++ b/drivers/staging/rar/rar_register.c
@@ -15,7 +15,7 @@
 #include <linux/pci.h>
 #include <linux/firmware.h>
 #include <linux/sched.h>
-#include "rar_register.h"
+#include <linux/rar/rar_register.h>
 
 /* The following defines are for the IPC process to retrieve RAR in */
 
diff --git a/drivers/staging/rar/rar_register.h b/drivers/staging/rar/rar_register.h
deleted file mode 100644
index 3690f98..0000000
--- a/drivers/staging/rar/rar_register.h
+++ /dev/null
@@ -1,99 +0,0 @@
-/* === RAR Physical Addresses === */
-struct RAR_address_struct {
-        u32 low;
-        u32 high;
-};
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
-int get_rar_address(int rar_index,struct RAR_address_struct *addresses);
-
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
-
diff --git a/include/linux/rar/rar_register.h b/include/linux/rar/rar_register.h
new file mode 100644
index 0000000..3690f98
--- /dev/null
+++ b/include/linux/rar/rar_register.h
@@ -0,0 +1,99 @@
+/* === RAR Physical Addresses === */
+struct RAR_address_struct {
+        u32 low;
+        u32 high;
+};
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
+int get_rar_address(int rar_index,struct RAR_address_struct *addresses);
+
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
+int lock_rar(int rar_index);
+
+
+/* DEBUG LEVEL MASKS */
+#define RAR_DEBUG_LEVEL_BASIC       0x1
+
+#define RAR_DEBUG_LEVEL_REGISTERS   0x2
+
+#define RAR_DEBUG_LEVEL_EXTENDED    0x4
+
+#define DEBUG_LEVEL	0x7
+
+/* FUNCTIONAL MACROS */
+
+/* debug macro without paramaters */
+#define DEBUG_PRINT_0(DEBUG_LEVEL , info) \
+do \
+{ \
+  if(DEBUG_LEVEL) \
+  { \
+    printk(KERN_WARNING info); \
+  } \
+}while(0)
+
+/* debug macro with 1 paramater */
+#define DEBUG_PRINT_1(DEBUG_LEVEL , info , param1) \
+do \
+{ \
+  if(DEBUG_LEVEL) \
+  { \
+    printk(KERN_WARNING info , param1); \
+  } \
+}while(0)
+
+/* debug macro with 2 paramaters */
+#define DEBUG_PRINT_2(DEBUG_LEVEL , info , param1, param2) \
+do \
+{ \
+  if(DEBUG_LEVEL) \
+  { \
+    printk(KERN_WARNING info , param1, param2); \
+  } \
+}while(0)
+
+/* debug macro with 3 paramaters */
+#define DEBUG_PRINT_3(DEBUG_LEVEL , info , param1, param2 , param3) \
+do \
+{ \
+  if(DEBUG_LEVEL) \
+  { \
+    printk(KERN_WARNING info , param1, param2 , param3); \
+  } \
+}while(0)
+
+/* debug macro with 4 paramaters */
+#define DEBUG_PRINT_4(DEBUG_LEVEL , info , param1, param2 , param3 , param4) \
+do \
+{ \
+  if(DEBUG_LEVEL) \
+  { \
+    printk(KERN_WARNING info , param1, param2 , param3 , param4); \
+  } \
+}while(0)
+
-- 
1.6.0.6

