Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbZCFNga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbZCFNga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbZCFNbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:31:06 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:42896 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754386AbZCFNaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:30:52 -0500
X-BigFish: VPS-6(zz18c1K655Oc8kzzzzz32i65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KG36US-02-TL1-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/18] dma-debug: add header file and core data structures
Date: Fri, 6 Mar 2009 14:30:13 +0100
Message-ID: <1236346229-6618-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 06 Mar 2009 13:30:30.0042 (UTC) FILETIME=[B7DAC7A0:01C99E5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add groundwork for DMA-API debugging

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/dma-debug.h |   25 +++++++++++++++++++++++++
 lib/Makefile              |    2 ++
 lib/dma-debug.c           |   42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/dma-debug.h
 create mode 100644 lib/dma-debug.c

diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
new file mode 100644
index 0000000..ce4ace7
--- /dev/null
+++ b/include/linux/dma-debug.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2008 Advanced Micro Devices, Inc.
+ *
+ * Author: Joerg Roedel <joerg.roedel@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#ifndef __DMA_DEBUG_H
+#define __DMA_DEBUG_H
+
+struct device;
+
+#endif /* __DMA_DEBUG_H */
diff --git a/lib/Makefile b/lib/Makefile
index 32b0e64..50b48cf 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -84,6 +84,8 @@ obj-$(CONFIG_HAVE_ARCH_TRACEHOOK) += syscall.o
 
 obj-$(CONFIG_DYNAMIC_PRINTK_DEBUG) += dynamic_printk.o
 
+obj-$(CONFIG_DMA_API_DEBUG) += dma-debug.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
new file mode 100644
index 0000000..3109971
--- /dev/null
+++ b/lib/dma-debug.c
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2008 Advanced Micro Devices, Inc.
+ *
+ * Author: Joerg Roedel <joerg.roedel@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/dma-debug.h>
+#include <linux/types.h>
+#include <linux/list.h>
+
+enum {
+	dma_debug_single,
+	dma_debug_page,
+	dma_debug_sg,
+	dma_debug_coherent,
+};
+
+struct dma_debug_entry {
+	struct list_head list;
+	struct device    *dev;
+	int              type;
+	phys_addr_t      paddr;
+	u64              dev_addr;
+	u64              size;
+	int              direction;
+	int		 sg_call_ents;
+	int		 sg_mapped_ents;
+};
+
-- 
1.5.6.4


