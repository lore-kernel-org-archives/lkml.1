Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbXBWK3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbXBWK3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 05:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932185AbXBWK3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 05:29:48 -0500
Received: from mo32.po.2iij.net ([210.128.50.17]:16626 "EHLO mo32.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbXBWK3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 05:29:48 -0500
Date: Fri, 23 Feb 2007 19:29:36 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Andrew Morton <akpm@osdl.org>
Cc: yoichi_yuasa@tripeaks.co.jp,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix memory leak dma_declare_coherent_memory()
Message-Id: <20070223192936.1962ea04.yoichi_yuasa@tripeaks.co.jp>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 1.0.4 (GTK+ 1.2.10; i386-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch has fixed memory leak in dma_declare_coherent_memory().
When it goes to free1_out, dev->dma_mem has not been freed.

Yoichi

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff -pruN -X generic/Documentation/dontdiff generic-orig/arch/cris/arch-v32/drivers/pci/dma.c generic/arch/cris/arch-v32/drivers/pci/dma.c
--- generic-orig/arch/cris/arch-v32/drivers/pci/dma.c	2007-02-23 19:06:28.355418750 +0900
+++ generic/arch/cris/arch-v32/drivers/pci/dma.c	2007-02-23 19:08:43.311853000 +0900
@@ -111,7 +111,7 @@ int dma_declare_coherent_memory(struct d
 	return DMA_MEMORY_IO;
 
  free1_out:
-	kfree(dev->dma_mem->bitmap);
+	kfree(dev->dma_mem);
  out:
 	return 0;
 }
diff -pruN -X generic/Documentation/dontdiff generic-orig/arch/i386/kernel/pci-dma.c generic/arch/i386/kernel/pci-dma.c
--- generic-orig/arch/i386/kernel/pci-dma.c	2007-02-23 19:06:30.183533000 +0900
+++ generic/arch/i386/kernel/pci-dma.c	2007-02-23 19:07:28.475176000 +0900
@@ -110,7 +110,7 @@ int dma_declare_coherent_memory(struct d
 	return DMA_MEMORY_IO;
 
  free1_out:
-	kfree(dev->dma_mem->bitmap);
+	kfree(dev->dma_mem);
  out:
 	if (mem_base)
 		iounmap(mem_base);
