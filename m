Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbZAIQXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbZAIQXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZAIQU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:20:28 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:28484 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbZAIQTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:19:49 -0500
X-BigFish: VPS-4(zz18c1K655Oc8kzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KD7PCH-03-IWZ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: mingo@redhat.com, dwmw2@infradead.org, fujita.tomonori@lab.ntt.co.jp,
       netdev@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/16] dma-debug: add header file and core data structures
Date: Fri, 9 Jan 2009 17:19:16 +0100
Message-ID: <1231517970-20288-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Jan 2009 16:19:30.0589 (UTC) FILETIME=[0CF574D0:01C97276]
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
 lib/dma-debug.c           |   39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 0 deletions(-)
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
index 0000000..d04f8b6
--- /dev/null
+++ b/lib/dma-debug.c
@@ -0,0 +1,39 @@
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
+	dma_debug_sg,
+	dma_debug_coherent,
+};
+
+struct dma_debug_entry {
+	struct list_head list;
+	struct device    *dev;
+	int              type;
+	void             *cpu_addr;
+	u64              dev_addr;
+	u64              size;
+	int              direction;
+};
+
-- 
1.5.6.4


