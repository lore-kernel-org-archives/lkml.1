Return-Path: <linux-kernel-owner+w=401wt.eu-S1762227AbYCYVne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762227AbYCYVne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbYCYViy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:38:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034AbYCYVix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:38:53 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: [PATCH 14/20] x86: move dma_cache_sync to common header
Date: Tue, 25 Mar 2008 18:36:33 -0300
Message-Id: <1206480999-21767-15-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
In-Reply-To: <1206480999-21767-14-git-send-email-gcosta@redhat.com>
References: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
 <1206480999-21767-2-git-send-email-gcosta@redhat.com>
 <1206480999-21767-3-git-send-email-gcosta@redhat.com>
 <1206480999-21767-4-git-send-email-gcosta@redhat.com>
 <1206480999-21767-5-git-send-email-gcosta@redhat.com>
 <1206480999-21767-6-git-send-email-gcosta@redhat.com>
 <1206480999-21767-7-git-send-email-gcosta@redhat.com>
 <1206480999-21767-8-git-send-email-gcosta@redhat.com>
 <1206480999-21767-9-git-send-email-gcosta@redhat.com>
 <1206480999-21767-10-git-send-email-gcosta@redhat.com>
 <1206480999-21767-11-git-send-email-gcosta@redhat.com>
 <1206480999-21767-12-git-send-email-gcosta@redhat.com>
 <1206480999-21767-13-git-send-email-gcosta@redhat.com>
 <1206480999-21767-14-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

they are the same in both architectures.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/dma-mapping.h    |    6 ++++++
 include/asm-x86/dma-mapping_32.h |    7 -------
 include/asm-x86/dma-mapping_64.h |    7 -------
 3 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index b5a413a..70a5ede 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -183,4 +183,10 @@ static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
 	dma_unmap_single(dev, addr, size, direction);
 }
 
+static inline void
+dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+	enum dma_data_direction dir)
+{
+	flush_write_buffers();
+}
 #endif
diff --git a/include/asm-x86/dma-mapping_32.h b/include/asm-x86/dma-mapping_32.h
index c61ae7f..e60c30a 100644
--- a/include/asm-x86/dma-mapping_32.h
+++ b/include/asm-x86/dma-mapping_32.h
@@ -55,13 +55,6 @@ dma_get_cache_alignment(void)
 
 #define dma_is_consistent(d, h)	(1)
 
-static inline void
-dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-	       enum dma_data_direction direction)
-{
-	flush_write_buffers();
-}
-
 #define ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
 extern int
 dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
diff --git a/include/asm-x86/dma-mapping_64.h b/include/asm-x86/dma-mapping_64.h
index 2b4a430..b1bc6ca 100644
--- a/include/asm-x86/dma-mapping_64.h
+++ b/include/asm-x86/dma-mapping_64.h
@@ -24,13 +24,6 @@ static inline int dma_get_cache_alignment(void)
 
 extern int dma_set_mask(struct device *dev, u64 mask);
 
-static inline void
-dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-	enum dma_data_direction dir)
-{
-	flush_write_buffers();
-}
-
 extern struct device fallback_dev;
 extern int panic_on_overflow;
 
-- 
1.5.0.6

