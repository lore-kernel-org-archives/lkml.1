Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbZAIQUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbZAIQUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZAIQTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:19:43 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:31932 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZAIQTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:19:42 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KD7PCJ-03-IX6-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: mingo@redhat.com, dwmw2@infradead.org, fujita.tomonori@lab.ntt.co.jp,
       netdev@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/16] dma-debug: add checks for sync_single_range_*
Date: Fri, 9 Jan 2009 17:19:27 +0100
Message-ID: <1231517970-20288-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Jan 2009 16:19:30.0857 (UTC) FILETIME=[0D1E5990:01C97276]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add debug callbacks for dma_sync_single_range_for_* functions

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/dma-debug.h |   26 ++++++++++++++++++++++++++
 lib/dma-debug.c           |   23 +++++++++++++++++++++++
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index f39c2a8..b9c221a 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -54,6 +54,16 @@ extern void debug_sync_single_for_device(struct device *dev,
 					 dma_addr_t dma_handle,
 					 size_t size, int direction);
 
+extern void debug_sync_single_range_for_cpu(struct device *dev,
+					    dma_addr_t dma_handle,
+					    unsigned long offset, size_t size,
+					    int direction);
+
+extern void debug_sync_single_range_for_device(struct device *dev,
+					       dma_addr_t dma_handle,
+					       unsigned long offset,
+					       size_t size, int direction);
+
 #else /* CONFIG_DMA_API_DEBUG */
 
 static inline void dma_debug_init(u32 num_entries)
@@ -104,6 +114,22 @@ static inline void debug_sync_single_for_device(struct device *dev,
 {
 }
 
+static inline void debug_sync_single_range_for_cpu(struct device *dev,
+						   dma_addr_t dma_handle,
+						   unsigned long offset,
+						   size_t size,
+						   int direction)
+{
+}
+
+static inline void debug_sync_single_range_for_device(struct device *dev,
+						      dma_addr_t dma_handle,
+						      unsigned long offset,
+						      size_t size,
+						      int direction)
+{
+}
+
 #endif /* CONFIG_DMA_API_DEBUG */
 
 #endif /* __DMA_DEBUG_H */
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index a7f2369..6f73bed 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -669,3 +669,26 @@ void debug_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
 }
 EXPORT_SYMBOL(debug_sync_single_for_device);
 
+void debug_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
+				     unsigned long offset, size_t size,
+				     int direction)
+{
+	if (global_disable)
+		return;
+
+	check_sync(dev, dma_handle, size, offset, direction, true);
+}
+EXPORT_SYMBOL(debug_sync_single_range_for_cpu);
+
+void debug_sync_single_range_for_device(struct device *dev,
+					dma_addr_t dma_handle,
+					unsigned long offset,
+					size_t size, int direction)
+{
+	if (global_disable)
+		return;
+
+	check_sync(dev, dma_handle, size, offset, direction, false);
+}
+EXPORT_SYMBOL(debug_sync_single_range_for_device);
+
-- 
1.5.6.4


