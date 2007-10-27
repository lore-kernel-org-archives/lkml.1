Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbXJ0SXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbXJ0SXr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 14:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbXJ0SXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 14:23:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46240 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbXJ0SXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 14:23:39 -0400
Date: Sat, 27 Oct 2007 19:23:30 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] scatterlist fallout: frv
Message-ID: <20071027182330.GN8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/frv/mb93090-mb00/pci-dma.c b/arch/frv/mb93090-mb00/pci-dma.c
index 671ce1e..662f7b1 100644
--- a/arch/frv/mb93090-mb00/pci-dma.c
+++ b/arch/frv/mb93090-mb00/pci-dma.c
@@ -15,6 +15,7 @@
 #include <linux/list.h>
 #include <linux/pci.h>
 #include <linux/highmem.h>
+#include <linux/scatterlist.h>
 #include <asm/io.h>
 
 void *dma_alloc_coherent(struct device *hwdev, size_t size, dma_addr_t *dma_handle, gfp_t gfp)
@@ -86,7 +87,7 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	dampr2 = __get_DAMPR(2);
 
 	for (i = 0; i < nents; i++) {
-		vaddr = kmap_atomic(sg[i].page, __KM_CACHE);
+		vaddr = kmap_atomic(sg_page(&sg[i]), __KM_CACHE);
 
 		frv_dcache_writeback((unsigned long) vaddr,
 				     (unsigned long) vaddr + PAGE_SIZE);
