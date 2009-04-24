Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbZDXBrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbZDXBrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 21:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbZDXBri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 21:47:38 -0400
Received: from [65.98.92.6] ([65.98.92.6]:2133 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752930AbZDXBri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 21:47:38 -0400
Message-Id: <0483452db22e72f57289e63fcf097120d94c2a73.1240533480.git@localhost>
In-Reply-To: <0483452db22e72f57289e63fcf097120d94c2a37.1240533480.git@localhost>
References: <0483452db22e72f57289e63fcf097120d94c2a37.1240533480.git@localhost>
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Thu, 23 Apr 2009 17:03:43 -0700
Subject: [PATCH 1/3] MIPS: Add size and direction arguments to plat_unmap_dma_mem()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 .../include/asm/mach-cavium-octeon/dma-coherence.h |    3 ++-
 arch/mips/include/asm/mach-generic/dma-coherence.h |    3 ++-
 arch/mips/include/asm/mach-ip27/dma-coherence.h    |    3 ++-
 arch/mips/include/asm/mach-ip32/dma-coherence.h    |    3 ++-
 arch/mips/include/asm/mach-jazz/dma-coherence.h    |    3 ++-
 arch/mips/include/asm/mach-lemote/dma-coherence.h  |    3 ++-
 arch/mips/mm/dma-default.c                         |    8 ++++----
 7 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h b/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
index f30fce9..7289e67 100644
--- a/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
+++ b/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
@@ -35,7 +35,8 @@ static inline unsigned long plat_dma_addr_to_phys(dma_addr_t dma_addr)
 	return dma_addr;
 }
 
-static inline void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr)
+static inline void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr,
+	size_t size, enum dma_data_direction direction)
 {
 	octeon_unmap_dma_mem(dev, dma_addr);
 }
diff --git a/arch/mips/include/asm/mach-generic/dma-coherence.h b/arch/mips/include/asm/mach-generic/dma-coherence.h
index 36c611b..804c2de 100644
--- a/arch/mips/include/asm/mach-generic/dma-coherence.h
+++ b/arch/mips/include/asm/mach-generic/dma-coherence.h
@@ -28,7 +28,8 @@ static inline unsigned long plat_dma_addr_to_phys(dma_addr_t dma_addr)
 	return dma_addr;
 }
 
-static inline void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr)
+static inline void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr,
+	size_t size, enum dma_data_direction direction)
 {
 }
 
diff --git a/arch/mips/include/asm/mach-ip27/dma-coherence.h b/arch/mips/include/asm/mach-ip27/dma-coherence.h
index 4c21bfc..8676673 100644
--- a/arch/mips/include/asm/mach-ip27/dma-coherence.h
+++ b/arch/mips/include/asm/mach-ip27/dma-coherence.h
@@ -38,7 +38,8 @@ static unsigned long plat_dma_addr_to_phys(dma_addr_t dma_addr)
 	return dma_addr & ~(0xffUL << 56);
 }
 
-static inline void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr)
+static inline void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr,
+	size_t size, enum dma_data_direction direction)
 {
 }
 
diff --git a/arch/mips/include/asm/mach-ip32/dma-coherence.h b/arch/mips/include/asm/mach-ip32/dma-coherence.h
index 7ae40f4..d41805e 100644
--- a/arch/mips/include/asm/mach-ip32/dma-coherence.h
+++ b/arch/mips/include/asm/mach-ip32/dma-coherence.h
@@ -60,7 +60,8 @@ static unsigned long plat_dma_addr_to_phys(dma_addr_t dma_addr)
 	return addr;
 }
 
-static inline void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr)
+static inline void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr,
+	size_t size, enum dma_data_direction direction)
 {
 }
 
diff --git a/arch/mips/include/asm/mach-jazz/dma-coherence.h b/arch/mips/include/asm/mach-jazz/dma-coherence.h
index 1c7cd27..5f3d7ea 100644
--- a/arch/mips/include/asm/mach-jazz/dma-coherence.h
+++ b/arch/mips/include/asm/mach-jazz/dma-coherence.h
@@ -27,7 +27,8 @@ static unsigned long plat_dma_addr_to_phys(dma_addr_t dma_addr)
 	return vdma_log2phys(dma_addr);
 }
 
-static void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr)
+static void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr,
+	size_t size, enum dma_data_direction direction)
 {
 	vdma_free(dma_addr);
 }
diff --git a/arch/mips/include/asm/mach-lemote/dma-coherence.h b/arch/mips/include/asm/mach-lemote/dma-coherence.h
index 38fad7d..c78f1d8 100644
--- a/arch/mips/include/asm/mach-lemote/dma-coherence.h
+++ b/arch/mips/include/asm/mach-lemote/dma-coherence.h
@@ -30,7 +30,8 @@ static inline unsigned long plat_dma_addr_to_phys(dma_addr_t dma_addr)
 	return dma_addr & 0x7fffffff;
 }
 
-static inline void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr)
+static inline void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr,
+	size_t size, enum dma_data_direction direction)
 {
 }
 
diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
index 4fdb7f5..30b108c 100644
--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -111,7 +111,7 @@ EXPORT_SYMBOL(dma_alloc_coherent);
 void dma_free_noncoherent(struct device *dev, size_t size, void *vaddr,
 	dma_addr_t dma_handle)
 {
-	plat_unmap_dma_mem(dev, dma_handle);
+	plat_unmap_dma_mem(dev, dma_handle, size, DMA_BIDIRECTIONAL);
 	free_pages((unsigned long) vaddr, get_order(size));
 }
 
@@ -122,7 +122,7 @@ void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
 {
 	unsigned long addr = (unsigned long) vaddr;
 
-	plat_unmap_dma_mem(dev, dma_handle);
+	plat_unmap_dma_mem(dev, dma_handle, size, DMA_BIDIRECTIONAL);
 
 	if (!plat_device_is_coherent(dev))
 		addr = CAC_ADDR(addr);
@@ -173,7 +173,7 @@ void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 		__dma_sync(dma_addr_to_virt(dma_addr), size,
 		           direction);
 
-	plat_unmap_dma_mem(dev, dma_addr);
+	plat_unmap_dma_mem(dev, dma_addr, size, direction);
 }
 
 EXPORT_SYMBOL(dma_unmap_single);
@@ -232,7 +232,7 @@ void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
 			if (addr)
 				__dma_sync(addr, sg->length, direction);
 		}
-		plat_unmap_dma_mem(dev, sg->dma_address);
+		plat_unmap_dma_mem(dev, sg->dma_address, sg->length, direction);
 	}
 }
 
-- 
1.5.3.6

