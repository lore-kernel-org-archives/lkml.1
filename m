Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbZCRVu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbZCRVu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757824AbZCRVnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:43:17 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757793AbZCRVnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:43:14 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 37/57] microblaze_v7: dma support
Date: Wed, 18 Mar 2009 21:31:04 +0100
Message-Id: <1165ce05edc67098d818cf42fd41a621868ab2a6.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <cde249b42d873cf948bd37d5e997307207de1bd3.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
 <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
 <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
 <75127eae09c978220d452d92f95763dde24f1d52.1237407249.git.monstr@monstr.eu>
 <b726b7b271cf303c36af54c4e155140541a6769b.1237407249.git.monstr@monstr.eu>
 <644f08d7f8cd338e606ed703e221914f75588fb5.1237407249.git.monstr@monstr.eu>
 <6d19f608a4ba3e7718aa55794c2845f19b5ed5e2.1237407249.git.monstr@monstr.eu>
 <039bc2fea33d23a3e7d2d85ac6fb275b8d21b5ed.1237407249.git.monstr@monstr.eu>
 <513d4067a84be1ecb47577e1edf131d2b3572808.1237407249.git.monstr@monstr.eu>
 <c6a6fbe7b56db27d9b74ee593cf068963f86ee58.1237407249.git.monstr@monstr.eu>
 <e9d4d452140c50451741dd6024ab89efd24ac8e6.1237407249.git.monstr@monstr.eu>
 <f8494212852d4cec890ae5e152353c91153c7c0d.1237407249.git.monstr@monstr.eu>
 <5c66d0329884feb553ae745584f6db589a892eb1.1237407249.git.monstr@monstr.eu>
 <72b06b8fa7b051005ebfa5c23c53a40d6a27f94a.1237407249.git.monstr@monstr.eu>
 <aa044d06327435cee76599fb6220630007f38ba7.1237407249.git.monstr@monstr.eu>
 <99fdae6e9b1da3ae5e2d3ebc841d1afdc694dfae.1237407249.git.monstr@monstr.eu>
 <29d86e7cd1124e596c9dde627f397ca98dccf572.1237407249.git.monstr@monstr.eu>
 <827e2a6a349e009f6c98f31178ce84042b0e2e10.1237407249.git.monstr@monstr.eu>
 <6eb167a9a027d644f10b843b8b1bde66e4c2ee25.1237407249.git.monstr@monstr.eu>
 <592d2a1c72581b6abf73841e640e7b7306c3ec3b.1237407249.git.monstr@monstr.eu>
 <fde2defbb60d9476df3aac0dc7d87241ed247d3e.1237407249.git.monstr@monstr.eu>
 <cde249b42d873cf948bd37d5e997307207de1bd3.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/dma-mapping.h |  131 +++++++++++++++++++++++++++++
 arch/microblaze/include/asm/dma.h         |   16 ++++
 arch/microblaze/include/asm/scatterlist.h |   28 ++++++
 3 files changed, 175 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/dma-mapping.h
 create mode 100644 arch/microblaze/include/asm/dma.h
 create mode 100644 arch/microblaze/include/asm/scatterlist.h

diff --git a/arch/microblaze/include/asm/dma-mapping.h b/arch/microblaze/include/asm/dma-mapping.h
new file mode 100644
index 0000000..e6f1246
--- /dev/null
+++ b/arch/microblaze/include/asm/dma-mapping.h
@@ -0,0 +1,131 @@
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
+#ifndef _ASM_MICROBLAZE_DMA_MAPPING_H
+#define _ASM_MICROBLAZE_DMA_MAPPING_H
+
+#include <asm/cacheflush.h>
+#include <linux/io.h>
+#include <linux/bug.h>
+
+struct scatterlist;
+
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
+/* FIXME */
+static inline int
+dma_supported(struct device *dev, u64 mask)
+{
+	return 1;
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
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return 0;
+}
+
+static inline void *dma_alloc_coherent(struct device *dev, size_t size,
+				dma_addr_t *dma_handle, int flag)
+{
+	return NULL; /* consistent_alloc(flag, size, dma_handle); */
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
+static inline void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
+				    size_t size,
+				    enum dma_data_direction direction)
+{
+	switch (direction) {
+	case DMA_FROM_DEVICE:
+		flush_dcache_range((unsigned)dma_addr,
+			(unsigned)dma_addr + size);
+			/* Fall through */
+	case DMA_TO_DEVICE:
+		break;
+	default:
+		BUG();
+	}
+}
+
+#endif /* _ASM_MICROBLAZE_DMA_MAPPING_H */
diff --git a/arch/microblaze/include/asm/dma.h b/arch/microblaze/include/asm/dma.h
new file mode 100644
index 0000000..0967fa0
--- /dev/null
+++ b/arch/microblaze/include/asm/dma.h
@@ -0,0 +1,16 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_DMA_H
+#define _ASM_MICROBLAZE_DMA_H
+
+/* we don't have dma address limit. define it as zero to be
+ * unlimited. */
+#define MAX_DMA_ADDRESS		(0)
+
+#endif /* _ASM_MICROBLAZE_DMA_H */
diff --git a/arch/microblaze/include/asm/scatterlist.h b/arch/microblaze/include/asm/scatterlist.h
new file mode 100644
index 0000000..08ff1d0
--- /dev/null
+++ b/arch/microblaze/include/asm/scatterlist.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_SCATTERLIST_H
+#define _ASM_MICROBLAZE_SCATTERLIST_H
+
+struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long	sg_magic;
+#endif
+	unsigned long	page_link;
+	dma_addr_t	dma_address;
+	unsigned int	offset;
+	unsigned int	length;
+};
+
+#define sg_dma_address(sg)      ((sg)->dma_address)
+#define sg_dma_len(sg)          ((sg)->length)
+
+#define ISA_DMA_THRESHOLD (~0UL)
+
+#endif /* _ASM_MICROBLAZE_SCATTERLIST_H */
-- 
1.5.5.1

