Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbZCJFPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbZCJFPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbZCJFLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:11:48 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:28373 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbZCJFLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:11:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nHtb7d+lXju4LzA4RdkVjsNVho0VOCvFfxbnZ65rgBCO6VOedT/S0SGKezWe3kl3vK
         0z539WC6M0rxXjDID7LoOd9SedDMSXggFRueKEJ0fRfoaXOZ0CNQVVoPl+NAgqBBoS7r
         vABZkoVoxDn1a+C3bcTo25OwY21dEybwLudJQ=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, dhowells@redhat.com
Subject: [PATCH 12/25] [frv] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:37 -0500
Message-Id: <1236661850-8237-13-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236661850-8237-12-git-send-email-stoyboyker@gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-5-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-6-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-7-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-8-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-9-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-10-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-11-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-12-git-send-email-stoyboyker@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 arch/frv/kernel/uaccess.c             |    6 ++----
 arch/frv/mb93090-mb00/pci-dma-nommu.c |    6 ++----
 arch/frv/mb93090-mb00/pci-dma.c       |    6 ++----
 include/asm-frv/pci.h                 |    7 ++-----
 4 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/arch/frv/kernel/uaccess.c b/arch/frv/kernel/uaccess.c
index 9fb771a..374f88d 100644
--- a/arch/frv/kernel/uaccess.c
+++ b/arch/frv/kernel/uaccess.c
@@ -23,8 +23,7 @@ long strncpy_from_user(char *dst, const char __user *src, long count)
 	char *p, ch;
 	long err = -EFAULT;
 
-	if (count < 0)
-		BUG();
+	BUG_ON(count < 0);
 
 	p = dst;
 
@@ -76,8 +75,7 @@ long strnlen_user(const char __user *src, long count)
 	long err = 0;
 	char ch;
 
-	if (count < 0)
-		BUG();
+	BUG_ON(count < 0);
 
 #ifndef CONFIG_MMU
 	if ((unsigned long) src < memory_start)
diff --git a/arch/frv/mb93090-mb00/pci-dma-nommu.c b/arch/frv/mb93090-mb00/pci-dma-nommu.c
index 52ff9ae..4e1ba0b 100644
--- a/arch/frv/mb93090-mb00/pci-dma-nommu.c
+++ b/arch/frv/mb93090-mb00/pci-dma-nommu.c
@@ -116,8 +116,7 @@ EXPORT_SYMBOL(dma_free_coherent);
 dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
 			  enum dma_data_direction direction)
 {
-	if (direction == DMA_NONE)
-                BUG();
+	BUG_ON(direction == DMA_NONE);
 
 	frv_cache_wback_inv((unsigned long) ptr, (unsigned long) ptr + size);
 
@@ -151,8 +150,7 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 		frv_cache_wback_inv(sg_dma_address(&sg[i]),
 				    sg_dma_address(&sg[i]) + sg_dma_len(&sg[i]));
 
-	if (direction == DMA_NONE)
-                BUG();
+	BUG_ON(direction == DMA_NONE);
 
 	return nents;
 }
diff --git a/arch/frv/mb93090-mb00/pci-dma.c b/arch/frv/mb93090-mb00/pci-dma.c
index 3ddedeb..45954f0 100644
--- a/arch/frv/mb93090-mb00/pci-dma.c
+++ b/arch/frv/mb93090-mb00/pci-dma.c
@@ -48,8 +48,7 @@ EXPORT_SYMBOL(dma_free_coherent);
 dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
 			  enum dma_data_direction direction)
 {
-	if (direction == DMA_NONE)
-                BUG();
+	BUG_ON(direction == DMA_NONE);
 
 	frv_cache_wback_inv((unsigned long) ptr, (unsigned long) ptr + size);
 
@@ -81,8 +80,7 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	void *vaddr;
 	int i;
 
-	if (direction == DMA_NONE)
-                BUG();
+	BUG_ON(direction == DMA_NONE);
 
 	dampr2 = __get_DAMPR(2);
 
diff --git a/include/asm-frv/pci.h b/include/asm-frv/pci.h
index 585d9b4..cc685e6 100644
--- a/include/asm-frv/pci.h
+++ b/include/asm-frv/pci.h
@@ -87,8 +87,7 @@ static inline void pci_dma_sync_single(struct pci_dev *hwdev,
 				       dma_addr_t dma_handle,
 				       size_t size, int direction)
 {
-	if (direction == PCI_DMA_NONE)
-                BUG();
+	BUG_ON(direction == PCI_DMA_NONE);
 
 	frv_cache_wback_inv((unsigned long)bus_to_virt(dma_handle),
 			    (unsigned long)bus_to_virt(dma_handle) + size);
@@ -105,9 +104,7 @@ static inline void pci_dma_sync_sg(struct pci_dev *hwdev,
 				   int nelems, int direction)
 {
 	int i;
-
-	if (direction == PCI_DMA_NONE)
-                BUG();
+	BUG_ON(direction == PCI_DMA_NONE);
 
 	for (i = 0; i < nelems; i++)
 		frv_cache_wback_inv(sg_dma_address(&sg[i]),
-- 
1.6.1.3

