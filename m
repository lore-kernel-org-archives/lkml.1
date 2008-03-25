Return-Path: <linux-kernel-owner+w=401wt.eu-S1761271AbYCYVox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761271AbYCYVox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758124AbYCYVjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:39:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757858AbYCYVjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:39:04 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: [PATCH 17/20] x86: provide a bad_dma_address symbol for i386
Date: Tue, 25 Mar 2008 18:36:36 -0300
Message-Id: <1206480999-21767-18-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
In-Reply-To: <1206480999-21767-17-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's initially 0, since we don't expect any DMA there.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-dma_32.c     |    4 ++++
 include/asm-x86/dma-mapping.h    |    2 ++
 include/asm-x86/dma-mapping_64.h |    1 -
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
index 453b4bd..55ab3c8 100644
--- a/arch/x86/kernel/pci-dma_32.c
+++ b/arch/x86/kernel/pci-dma_32.c
@@ -14,6 +14,10 @@
 #include <linux/module.h>
 #include <asm/io.h>
 
+/* For i386, we make it point to the NULL address */
+dma_addr_t bad_dma_address __read_mostly = 0x0;
+EXPORT_SYMBOL(bad_dma_address);
+
 struct dma_coherent_mem {
 	void		*virt_base;
 	u32		device_base;
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 06eb448..908fcaa 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -10,6 +10,8 @@
 #include <asm/io.h>
 #include <asm/swiotlb.h>
 
+extern dma_addr_t bad_dma_address;
+
 struct dma_mapping_ops {
 	int             (*mapping_error)(dma_addr_t dma_addr);
 	void*           (*alloc_coherent)(struct device *dev, size_t size,
diff --git a/include/asm-x86/dma-mapping_64.h b/include/asm-x86/dma-mapping_64.h
index 9674dac..352bf41 100644
--- a/include/asm-x86/dma-mapping_64.h
+++ b/include/asm-x86/dma-mapping_64.h
@@ -1,7 +1,6 @@
 #ifndef _X8664_DMA_MAPPING_H
 #define _X8664_DMA_MAPPING_H 1
 
-extern dma_addr_t bad_dma_address;
 extern int iommu_merge;
 
 static inline int dma_mapping_error(dma_addr_t dma_addr)
-- 
1.5.0.6

