Return-Path: <linux-kernel-owner+w=401wt.eu-S1762767AbYCYVpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762767AbYCYVpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757970AbYCYVjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:39:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757487AbYCYVjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:39:05 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: [PATCH 19/20] x86: move ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY to dma-mapping.h
Date: Tue, 25 Mar 2008 18:36:38 -0300
Message-Id: <1206480999-21767-20-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
In-Reply-To: <1206480999-21767-19-git-send-email-gcosta@redhat.com>
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
 <1206480999-21767-15-git-send-email-gcosta@redhat.com>
 <1206480999-21767-16-git-send-email-gcosta@redhat.com>
 <1206480999-21767-17-git-send-email-gcosta@redhat.com>
 <1206480999-21767-18-git-send-email-gcosta@redhat.com>
 <1206480999-21767-19-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

define it conditionally to i386

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/dma-mapping.h    |   14 ++++++++++++++
 include/asm-x86/dma-mapping_32.h |   12 ------------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 352433b..9548b19 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -202,4 +202,18 @@ dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 {
 	flush_write_buffers();
 }
+
+#ifdef CONFIG_X86_32
+#  define ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
+extern int
+dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
+			    dma_addr_t device_addr, size_t size, int flags);
+
+extern void
+dma_release_declared_memory(struct device *dev);
+
+extern void *
+dma_mark_declared_memory_occupied(struct device *dev,
+				  dma_addr_t device_addr, size_t size);
+#endif /* CONFIG_X86_32 */
 #endif
diff --git a/include/asm-x86/dma-mapping_32.h b/include/asm-x86/dma-mapping_32.h
index 03a75f8..4ec4f45 100644
--- a/include/asm-x86/dma-mapping_32.h
+++ b/include/asm-x86/dma-mapping_32.h
@@ -20,16 +20,4 @@ dma_get_cache_alignment(void)
 
 #define dma_is_consistent(d, h)	(1)
 
-#define ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
-extern int
-dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-			    dma_addr_t device_addr, size_t size, int flags);
-
-extern void
-dma_release_declared_memory(struct device *dev);
-
-extern void *
-dma_mark_declared_memory_occupied(struct device *dev,
-				  dma_addr_t device_addr, size_t size);
-
 #endif
-- 
1.5.0.6

