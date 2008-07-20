Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbYGTLB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbYGTLB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 07:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbYGTLBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 07:01:18 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:17319 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbYGTLBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 07:01:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=CQqK3ILYd4+r2BKawc8VuNTOZUibEwwk6dzUJhAhC1OXhvHdAb287sA/IouyIky+Vr
         YaFzMQwdA/ghFcydfHPcOm9R/RrER8CNYwxKdymrsKPv6RU5P6LAqvMaTwsqcY4YsrEn
         AZQMVdvl6zsogWnR7Ek58PIgbpZlrFZASjV9s=
Date: Sun, 20 Jul 2008 15:01:10 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 2/2] dma-coherent: add documentation to new interfaces
References: <b6f0073d8c60115dc0975b32bee6bc8f4ceb8c9c.1216551301.git.dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6f0073d8c60115dc0975b32bee6bc8f4ceb8c9c.1216551301.git.dbaryshkov@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Message-ID: <48831afa.2834440a.3363.ffffc9df@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 kernel/dma-coherent.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/kernel/dma-coherent.c b/kernel/dma-coherent.c
index 56dff5c..7517115 100644
--- a/kernel/dma-coherent.c
+++ b/kernel/dma-coherent.c
@@ -92,6 +92,21 @@ void *dma_mark_declared_memory_occupied(struct device *dev,
 }
 EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
 
+/**
+ * Try to allocate memory from the per-device coherent area.
+ *
+ * @dev:	device from which we allocate memory
+ * @size:	size of requested memory area
+ * @dma_handle:	This will be filled with the correct dma handle
+ * @ret:	This pointer will be filled with the virtual address
+ * 		to allocated area.
+ *
+ * This function should be only called from per-arch %dma_alloc_coherent()
+ * to support allocation from per-device coherent memory pools.
+ *
+ * Returns 0 if dma_alloc_coherent should continue with allocating from
+ * generic memory areas, or !0 if dma_alloc_coherent should return %ret.
+ */
 int dma_alloc_from_coherent(struct device *dev, ssize_t size,
 				       dma_addr_t *dma_handle, void **ret)
 {
@@ -111,6 +126,19 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
 	return (mem != NULL);
 }
 
+/**
+ * Try to free the memory allocated from per-device coherent memory pool.
+ * @dev:	device from which the memory was allocated
+ * @order:	the order of pages allocated
+ * @vaddr:	virtual address of allocated pages
+ *
+ * This checks whether the memory was allocated from the per-device
+ * coherent memory pool and if so, releases that memory.
+ *
+ * Returns 1 if we correctly released the memory, or 0 if
+ * %dma_release_coherent() should proceed with releasing memory from
+ * generic pools.
+ */
 int dma_release_from_coherent(struct device *dev, int order, void *vaddr)
 {
 	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
-- 
1.5.6.2


-- 
With best wishes
Dmitry

