Return-Path: <linux-kernel-owner+w=401wt.eu-S1762290AbZFKMFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762290AbZFKMFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZFKMFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:05:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46183 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbZFKMFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:05:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/6] FRV: BUG to BUG_ON changes
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Stoyan Gaydarov <stoyboyker@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Thu, 11 Jun 2009 13:05:04 +0100
Message-ID: <20090611120504.12082.70515.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090611120458.12082.4348.stgit@warthog.procyon.org.uk>
References: <20090611120458.12082.4348.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stoyan Gaydarov <stoyboyker@gmail.com>

Change some BUG()'s to BUG_ON()'s.

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/include/asm/pci.h            |    7 ++-----
 arch/frv/kernel/uaccess.c             |    6 ++----
 arch/frv/mb93090-mb00/pci-dma-nommu.c |    6 ++----
 arch/frv/mb93090-mb00/pci-dma.c       |    6 ++----
 4 files changed, 8 insertions(+), 17 deletions(-)


diff --git a/arch/frv/include/asm/pci.h b/arch/frv/include/asm/pci.h
index 585d9b4..cc685e6 100644
--- a/arch/frv/include/asm/pci.h
+++ b/arch/frv/include/asm/pci.h
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
 

