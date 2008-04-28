Return-Path: <linux-kernel-owner+w=401wt.eu-S934338AbYD1NFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934338AbYD1NFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934239AbYD1NFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:05:32 -0400
Received: from web52011.mail.re2.yahoo.com ([206.190.48.27]:38421 "HELO
	web52011.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934204AbYD1NFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:05:31 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Apr 2008 09:05:30 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=tF+/gfrvvsftv4BkCP7juS0ntwfiIWGs0+FMG3CvxRREYINRHeCupNxGzX/emPZ6VYox+G8ZhxwEyaBqWqA8tR1jIfdqCnxW1w//N9Dc9mnjJdzu6w5aKJvpIhpm9NgSSCNn6/yY7e6e5zHZ18HbsYuEVNjft6+6gD4iZPUmVuA=;
X-YMail-OSG: JbHOAqMVM1nnVauPy2vLIc6g6kEn8OaORwo0.oBagRkRqU0YjFoAkJ.Yd8tD8KQfeHU3hZrDEe.Sy6S9XhzMB18rBQ0DDQy8hdnmmb6xenr6rELsZFUhg7b50Q--
X-Mailer: YahooMailRC/975.23 YahooMailWebService/0.7.185
Date: Mon, 28 Apr 2008 05:58:49 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: [patch v3] doc: DMA-mapping.txt has undeclared variables [Bug 10397]
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       grundler@parisc-linux.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <987999.8753.qm@web52011.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Consistently use pdev as the variable of type struct pci_dev *.
Update DMA mapping documentation to use 'pdev' rather than 'dev' in 
example code that calls routines expecting 'struct pci_device *', since 'dev' 
might make readers think they're passing 'struct device *' parameters.
Bug 10397.

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

---

--- linux-2.6/Documentation/DMA-mapping.txt    2008-03-23 09:01:06.304511500 +0200
+++ linux/Documentation/DMA-mapping.txt    2008-04-06 06:56:11.821314500 +0300
@@ -315,9 +315,9 @@
 
     dma_addr_t dma_handle;
 
-    cpu_addr = pci_alloc_consistent(dev, size, &dma_handle);
+    cpu_addr = pci_alloc_consistent(pdev, size, &dma_handle);
 
-where dev is a struct pci_dev *. You should pass NULL for PCI like buses
+where pdev is a struct pci_dev *. You should pass NULL for PCI like buses
 where devices don't have struct pci_dev (like ISA, EISA).  This may be
 called in interrupt context. 
 
@@ -354,9 +354,9 @@
 
 To unmap and free such a DMA region, you call:
 
-    pci_free_consistent(dev, size, cpu_addr, dma_handle);
+    pci_free_consistent(pdev, size, cpu_addr, dma_handle);
 
-where dev, size are the same as in the above call and cpu_addr and
+where pdev, size are the same as in the above call and cpu_addr and
 dma_handle are the values pci_alloc_consistent returned to you.
 This function may not be called in interrupt context.
 
@@ -371,9 +371,9 @@
 
     struct pci_pool *pool;
 
-    pool = pci_pool_create(name, dev, size, align, alloc);
+    pool = pci_pool_create(name, pdev, size, align, alloc);
 
-The "name" is for diagnostics (like a kmem_cache name); dev and size
+The "name" is for diagnostics (like a kmem_cache name); pdev and size
 are as above.  The device's hardware alignment requirement for this
 type of data is "align" (which is expressed in bytes, and must be a
 power of two).  If your device has no boundary crossing restrictions,
@@ -472,11 +472,11 @@
     void *addr = buffer->ptr;
     size_t size = buffer->len;
 
-    dma_handle = pci_map_single(dev, addr, size, direction);
+    dma_handle = pci_map_single(pdev, addr, size, direction);
 
 and to unmap it:
 
-    pci_unmap_single(dev, dma_handle, size, direction);
+    pci_unmap_single(pdev, dma_handle, size, direction);
 
 You should call pci_unmap_single when the DMA activity is finished, e.g.
 from the interrupt which told you that the DMA transfer is done.
@@ -493,17 +493,17 @@
     unsigned long offset = buffer->offset;
     size_t size = buffer->len;
 
-    dma_handle = pci_map_page(dev, page, offset, size, direction);
+    dma_handle = pci_map_page(pdev, page, offset, size, direction);
 
     ...
 
-    pci_unmap_page(dev, dma_handle, size, direction);
+    pci_unmap_page(pdev, dma_handle, size, direction);
 
 Here, "offset" means byte offset within the given page.
 
 With scatterlists, you map a region gathered from several regions by:
 
-    int i, count = pci_map_sg(dev, sglist, nents, direction);
+    int i, count = pci_map_sg(pdev, sglist, nents, direction);
     struct scatterlist *sg;
 
     for_each_sg(sglist, sg, count, i) {
@@ -527,7 +527,7 @@
 
 To unmap a scatterlist, just call:
 
-    pci_unmap_sg(dev, sglist, nents, direction);
+    pci_unmap_sg(pdev, sglist, nents, direction);
 
 Again, make sure DMA activity has already finished.
 
@@ -550,11 +550,11 @@
 So, firstly, just map it with pci_map_{single,sg}, and after each DMA
 transfer call either:
 
-    pci_dma_sync_single_for_cpu(dev, dma_handle, size, direction);
+    pci_dma_sync_single_for_cpu(pdev, dma_handle, size, direction);
 
 or:
 
-    pci_dma_sync_sg_for_cpu(dev, sglist, nents, direction);
+    pci_dma_sync_sg_for_cpu(pdev, sglist, nents, direction);
 
 as appropriate.
 
@@ -562,7 +562,7 @@
 finish accessing the data with the cpu, and then before actually
 giving the buffer to the hardware call either:
 
-    pci_dma_sync_single_for_device(dev, dma_handle, size, direction);
+    pci_dma_sync_single_for_device(pdev, dma_handle, size, direction);
 
 or:
 
@@ -739,7 +739,7 @@
 
     dma_addr_t dma_handle;
 
-    dma_handle = pci_map_single(dev, addr, size, direction);
+    dma_handle = pci_map_single(pdev, addr, size, direction);
     if (pci_dma_mapping_error(dma_handle)) {
         /*
          * reduce current DMA mapping usage,



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
