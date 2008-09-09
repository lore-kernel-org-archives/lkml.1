Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbYIIQKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbYIIQKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbYIIQI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:08:57 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:58225 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406AbYIIQIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:08:53 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       Tony Luck <tony.luck@intel.com>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/4] add is_buffer_dma_capable helper function
Date: Wed, 10 Sep 2008 01:06:46 +0900
Message-Id: <1220976409-8417-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1220976409-8417-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220976409-8417-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is_buffer_dma_capable helper function is to see if a memory region is
DMA-capable or not. The arugments are the dma_mask (or
coherent_dma_mask) of a device and the address and size of a memory
region.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/dma-mapping.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 952e0f8..6ed50c1 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -48,6 +48,11 @@ static inline int is_device_dma_capable(struct device *dev)
 	return dev->dma_mask != NULL && *dev->dma_mask != DMA_MASK_NONE;
 }
 
+static inline int is_buffer_dma_capable(u64 mask, dma_addr_t addr, size_t size)
+{
+	return addr + size <= mask;
+}
+
 #ifdef CONFIG_HAS_DMA
 #include <asm/dma-mapping.h>
 #else
-- 
1.5.4.2

