Return-Path: <linux-kernel-owner+w=401wt.eu-S1757877AbYAZQBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbYAZQBF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbYAZPzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:55:17 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752801AbYAZPzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:55:14 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 38/52] [microblaze] dma support
Date: Thu, 24 Jan 2008 16:03:13 +0100
Message-Id: <99bfbc3fdb53003c11414681b2c73561d533c3ef.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <29ee870c02ea5d4c409644d7f0eb09cfbb1ec816.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
 <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
 <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
 <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
 <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu>
 <db7f441df21cfe296a44744747b28f379e75fd49.1201107832.git.monstr@monstr.eu>
 <e6309af7cc6550ef5b399fc0902f1926f9e52e58.1201107832.git.monstr@monstr.eu>
 <2d11eef3abada1f41658a532a483c6121ded8054.1201107832.git.monstr@monstr.eu>
 <48db19662b808ab6f5455dd7f2116e6544c50e95.1201107832.git.monstr@monstr.eu>
 <7b0cfa6ae11749e20c941d0a4f03577141e022f8.1201107832.git.monstr@monstr.eu>
 <2f3db7ba4fe41cb9888adabf0e4e052d4da5c37c.1201107832.git.monstr@monstr.eu>
 <d67010417928d04766e6dd74820b12c249d61814.1201107832.git.monstr@monstr.eu>
 <37627293f081fa40f21234944ddb878d5e711740.1201107832.git.monstr@monstr.eu>
 <105791d33ea12564c70be0dd3fafef386f8e1b55.1201107832.git.monstr@monstr.eu>
 <b501d439bdfabddbdef5935db86b6f64c83d55c4.1201107832.git.monstr@monstr.eu>
 <43f77bd3045d72346eb39d3170de727050c835c1.1201107832.git.monstr@monstr.eu>
 <c09d54c49393bedbe4ca43df0e35cefa5fcc649c.1201107832.git.monstr@monstr.eu>
 <29ee870c02ea5d4c409644d7f0eb09cfbb1ec816.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/dma-mapping.h |  124 ++++++++++++++++++++++++++++++++++
 include/asm-microblaze/dma.h         |   21 ++++++
 include/asm-microblaze/scatterlist.h |   21 ++++++
 3 files changed, 166 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/dma-mapping.h
 create mode 100644 include/asm-microblaze/dma.h
 create mode 100644 include/asm-microblaze/scatterlist.h

diff --git a/include/asm-microblaze/dma-mapping.h b/include/asm-microblaze/dma-mapping.h
new file mode 100644
index 0000000..defe1c4
--- /dev/null
+++ b/include/asm-microblaze/dma-mapping.h
@@ -0,0 +1,124 @@
+/*
+ * include/asm-microblaze/dma-mapping.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_DMA_MAPPING_H
+#define _ASM_DMA_MAPPING_H
+
+#include <asm/io.h>
+#include <asm/bug.h>
+
+struct scatterlist;
+
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
+void *consistent_alloc(gfp_t gfp, size_t size, dma_addr_t *dma_handle);
+void consistent_free(void *vaddr);
+void consistent_sync(void *vaddr, size_t size, int direction);
+void consistent_sync_page(struct page *page, unsigned long offset,
+	size_t size, int direction);
+
+/* FIXME */
+static inline int
+dma_supported(struct device *dev, u64 mask)
+{
+	return 0;
+}
+
+static inline dma_addr_t
+dma_map_page(struct device *dev, struct page *page,
+	unsigned long offset, size_t size,
+	enum dma_data_direction direction)
+{
+	BUG();
+	return 0;
+}
+
+static inline void
+dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
+	enum dma_data_direction direction)
+{
+	BUG();
+}
+
+static inline int
+dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+	enum dma_data_direction direction)
+{
+	BUG();
+	return 0;
+}
+
+static inline void
+dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
+	enum dma_data_direction direction)
+{
+	BUG();
+}
+
+static inline void
+dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
+			enum dma_data_direction direction)
+{
+	BUG();
+}
+
+static inline void
+dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
+		size_t size, enum dma_data_direction direction)
+{
+	BUG();
+}
+
+static inline void
+dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
+		enum dma_data_direction direction)
+{
+	BUG();
+}
+
+static inline void
+dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
+		enum dma_data_direction direction)
+{
+	BUG();
+}
+
+static inline int
+dma_mapping_error(dma_addr_t dma_addr)
+{
+	return 0;
+}
+
+static inline void *dma_alloc_coherent(struct device *dev, size_t size,
+				dma_addr_t *dma_handle, int flag)
+{
+	return consistent_alloc(flag, size, dma_handle);
+}
+
+static inline void dma_free_coherent(struct device *dev, size_t size,
+			void *vaddr, dma_addr_t dma_handle)
+{
+	BUG();
+}
+
+static inline dma_addr_t
+dma_map_single(struct device *dev, void *ptr, size_t size,
+	enum dma_data_direction direction)
+{
+	BUG_ON(direction == DMA_NONE);
+
+	return virt_to_bus(ptr);
+}
+
+#define dma_unmap_single(dev, addr, size, dir)	do { } while (0)
+
+
+#endif /* _ASM_DMA_MAPPING_H */
diff --git a/include/asm-microblaze/dma.h b/include/asm-microblaze/dma.h
new file mode 100644
index 0000000..a0c5c41
--- /dev/null
+++ b/include/asm-microblaze/dma.h
@@ -0,0 +1,21 @@
+/*
+ * include/asm-microblaze/dma.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_DMA_H
+#define _ASM_DMA_H
+
+/* we don't have dma address limit. define it as zero to be
+ * unlimited. */
+#define MAX_DMA_ADDRESS		(0)
+
+#define ISA_DMA_THRESHOLD	(0)
+
+
+#endif /* _ASM_DMA_H */
diff --git a/include/asm-microblaze/scatterlist.h b/include/asm-microblaze/scatterlist.h
new file mode 100644
index 0000000..389bdc8
--- /dev/null
+++ b/include/asm-microblaze/scatterlist.h
@@ -0,0 +1,21 @@
+/*
+ * include/asm-microblaze/scatterlist.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_SCATTERLIST_H
+#define _ASM_SCATTERLIST_H
+
+struct scatterlist {
+	unsigned long page_link;
+	unsigned int	offset;
+	dma_addr_t	dma_address;
+	unsigned int	length;
+};
+
+#endif /* _ASM_SCATTERLIST_H */
-- 
1.5.4.rc4.14.g6fc74

