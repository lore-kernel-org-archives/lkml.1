Return-Path: <linux-kernel-owner+w=401wt.eu-S937716AbZFPGLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937716AbZFPGLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936984AbZFPGBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 02:01:48 -0400
Received: from mail-pz0-f187.google.com ([209.85.222.187]:55847 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937000AbZFPGBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 02:01:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=aH7kbiaRo751sJBrnoaqpQGGObXGSqToIyDzpOSRabLBDb7pIbnjVlJL5BUPmUKKWz
         ChZZ+5Xkq9Hm8H8JfAqhExtwIxd9ayNlXfUzxzp/fJhY4P/6IttfGyFaUuTjx2x2oVlB
         e6SRGLt4pB4avj7fWun6DS0jolKNM76vojFz0=
From: unsik Kim <donari75@gmail.com>
To: tj@kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org,
       bzolnier@gmail.com, joerg@dorchain.net, geert@linux-m68k.org,
       davem@davemloft.net, jdike@linux.intel.com, benh@kernel.crashing.org,
       Laurent@lvivier.info
Cc: unsik Kim <donari75@gmail.com>
Subject: [PATCH] mg_disk: seperate mg_disk.h again
Date: Tue, 16 Jun 2009 14:59:54 +0900
Message-Id: <1245131994-21518-1-git-send-email-donari75@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eec9462088a26c046d4db3100796a340a50890b8 fold mg_disk.h into mg_disk.c,
but mg_disk platform driver needs private data for operation. This also
make mg_disk.c as machine independent. Seperate only needed structure and
defines to mg_disk.h

Signed-off-by: unsik Kim <donari75@gmail.com>
---
Sorry for the very very late reply for message
<1240891577-4813-12-git-send-email-tj@kernel.org>.  
---
 drivers/block/mg_disk.c |   28 +---------------------------
 include/linux/mg_disk.h |   45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 27 deletions(-)
 create mode 100644 include/linux/mg_disk.h

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 60de5a0..f703f54 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -22,13 +22,12 @@
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <linux/mg_disk.h>
 
 #define MG_RES_SEC (CONFIG_MG_DISK_RES << 1)
 
 /* name for block device */
 #define MG_DISK_NAME "mgd"
-/* name for platform device */
-#define MG_DEV_NAME "mg_disk"
 
 #define MG_DISK_MAJ 0
 #define MG_DISK_MAX_PART 16
@@ -103,33 +102,8 @@
 #define MG_TMAX_SWRST_TO_RDY	500
 #define MG_TMAX_RSTOUT		3000
 
-/* device attribution */
-/* use mflash as boot device */
-#define MG_BOOT_DEV		(1 << 0)
-/* use mflash as storage device */
-#define MG_STORAGE_DEV		(1 << 1)
-/* same as MG_STORAGE_DEV, but bootloader already done reset sequence */
-#define MG_STORAGE_DEV_SKIP_RST	(1 << 2)
-
 #define MG_DEV_MASK (MG_BOOT_DEV | MG_STORAGE_DEV | MG_STORAGE_DEV_SKIP_RST)
 
-/* names of GPIO resource */
-#define MG_RST_PIN	"mg_rst"
-/* except MG_BOOT_DEV, reset-out pin should be assigned */
-#define MG_RSTOUT_PIN	"mg_rstout"
-
-/* private driver data */
-struct mg_drv_data {
-	/* disk resource */
-	u32 use_polling;
-
-	/* device attribution */
-	u32 dev_attr;
-
-	/* internally used */
-	struct mg_host *host;
-};
-
 /* main structure for mflash driver */
 struct mg_host {
 	struct device *dev;
diff --git a/include/linux/mg_disk.h b/include/linux/mg_disk.h
new file mode 100644
index 0000000..e11f4d9
--- /dev/null
+++ b/include/linux/mg_disk.h
@@ -0,0 +1,45 @@
+/*
+ *  include/linux/mg_disk.c
+ *
+ *  Private data for mflash platform driver
+ *
+ * (c) 2008 mGine Co.,LTD
+ * (c) 2008 unsik Kim <donari75@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#ifndef __MG_DISK_H__
+#define __MG_DISK_H__
+
+/* name for platform device */
+#define MG_DEV_NAME "mg_disk"
+
+/* names of GPIO resource */
+#define MG_RST_PIN	"mg_rst"
+/* except MG_BOOT_DEV, reset-out pin should be assigned */
+#define MG_RSTOUT_PIN	"mg_rstout"
+
+/* device attribution */
+/* use mflash as boot device */
+#define MG_BOOT_DEV		(1 << 0)
+/* use mflash as storage device */
+#define MG_STORAGE_DEV		(1 << 1)
+/* same as MG_STORAGE_DEV, but bootloader already done reset sequence */
+#define MG_STORAGE_DEV_SKIP_RST	(1 << 2)
+
+/* private driver data */
+struct mg_drv_data {
+	/* disk resource */
+	u32 use_polling;
+
+	/* device attribution */
+	u32 dev_attr;
+
+	/* internally used */
+	void *host;
+};
+
+#endif
-- 
1.6.0.6

