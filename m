Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbYDGQCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbYDGQCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 12:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbYDGQCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 12:02:01 -0400
Received: from web52004.mail.re2.yahoo.com ([206.190.49.251]:43459 "HELO
	web52004.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753873AbYDGQCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 12:02:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=6eR+H7hALrZujAtgj5dlfl3cf2pDBZYEFsmXW1rtt9eD/NDbxR1hPTYP64ScAuGoR1hS/LZXOA7krkHpM2t+2uri2F1tpnJB/eL5f41QYPxLU1vxOP0xjvvxUPNAqVkGSj1XdLyPt0hBJf37J7A9Xxg0zF+QrcZQWX3hPyJ7N/Y=;
X-YMail-OSG: ml035DsVM1lSIduGAkTqaqmi43lb2SfJWh5YMXIsm7879IpP8YlRn3nA6QyZAXX2echfZPhzSRulMOefZ.AhWOH4mYqyrPE5hO8emYGanUcJ2dFfRMUc7tqIO6lxMnlxo0ldnIbIS6ef9zYCtRqzSYPqPQ--
X-Mailer: YahooMailRC/902.40 YahooMailWebService/0.7.185
Date: Mon, 7 Apr 2008 09:01:54 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: [patch v2] doc: DMA-mapping.txt has undeclared variables [Bug 10397]
To: Grant Grundler <grundler@parisc-linux.org>, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <935779.51834.qm@web52004.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Fix undeclared variables in code examples.
Consistently use pdev as the variable of type struct pci_dev *.
Bug 10397.

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

---

--- linux-2.6/Documentation/DMA-mapping.txt	2008-03-23 09:01:06.304511500 +0200
+++ linux/Documentation/DMA-mapping.txt	2008-04-06 06:56:11.821314500 +0300
@@ -315,9 +315,9 @@
 
 	dma_addr_t dma_handle;
 
-	cpu_addr = pci_alloc_consistent(dev, size, &dma_handle);
+	cpu_addr = pci_alloc_consistent(pdev, size, &dma_handle);
 
-where dev is a struct pci_dev *. You should pass NULL for PCI like buses
+where pdev is a struct pci_dev *. You should pass NULL for PCI like buses
 where devices don't have struct pci_dev (like ISA, EISA).  This may be
 called in interrupt context. 
 
@@ -354,9 +354,9 @@
 
 To unmap and free such a DMA region, you call:
 
-	pci_free_consistent(dev, size, cpu_addr, dma_handle);
+	pci_free_consistent(pdev, size, cpu_addr, dma_handle);
 
-where dev, size are the same as in the above call and cpu_addr and
+where pdev, size are the same as in the above call and cpu_addr and
 dma_handle are the values pci_alloc_consistent returned to you.
 This function may not be called in interrupt context.
 
@@ -371,9 +371,9 @@
 
 	struct pci_pool *pool;
 
-	pool = pci_pool_create(name, dev, size, align, alloc);
+	pool = pci_pool_create(name, pdev, size, align, alloc);
 
-The "name" is for diagnostics (like a kmem_cache name); dev and size
+The "name" is for diagnostics (like a kmem_cache name); pdev and size
 are as above.  The device's hardware alignment requirement for this
 type of data is "align" (which is expressed in bytes, and must be a
 power of two).  If your device has no boundary crossing restrictions,
@@ -472,11 +472,11 @@
 	void *addr = buffer->ptr;
 	size_t size = buffer->len;
 
-	dma_handle = pci_map_single(dev, addr, size, direction);
+	dma_handle = pci_map_single(pdev, addr, size, direction);
 
 and to unmap it:
 
-	pci_unmap_single(dev, dma_handle, size, direction);
+	pci_unmap_single(pdev, dma_handle, size, direction);
 
 You should call pci_unmap_single when the DMA activity is finished, e.g.
 from the interrupt which told you that the DMA transfer is done.
@@ -493,17 +493,17 @@
 	unsigned long offset = buffer->offset;
 	size_t size = buffer->len;
 
-	dma_handle = pci_map_page(dev, page, offset, size, direction);
+	dma_handle = pci_map_page(pdev, page, offset, size, direction);
 
 	...
 
-	pci_unmap_page(dev, dma_handle, size, direction);
+	pci_unmap_page(pdev, dma_handle, size, direction);
 
 Here, "offset" means byte offset within the given page.
 
 With scatterlists, you map a region gathered from several regions by:
 
-	int i, count = pci_map_sg(dev, sglist, nents, direction);
+	int i, count = pci_map_sg(pdev, sglist, nents, direction);
 	struct scatterlist *sg;
 
 	for_each_sg(sglist, sg, count, i) {
@@ -527,7 +527,7 @@
 
 To unmap a scatterlist, just call:
 
-	pci_unmap_sg(dev, sglist, nents, direction);
+	pci_unmap_sg(pdev, sglist, nents, direction);
 
 Again, make sure DMA activity has already finished.
 
@@ -550,11 +550,11 @@
 So, firstly, just map it with pci_map_{single,sg}, and after each DMA
 transfer call either:
 
-	pci_dma_sync_single_for_cpu(dev, dma_handle, size, direction);
+	pci_dma_sync_single_for_cpu(pdev, dma_handle, size, direction);
 
 or:
 
-	pci_dma_sync_sg_for_cpu(dev, sglist, nents, direction);
+	pci_dma_sync_sg_for_cpu(pdev, sglist, nents, direction);
 
 as appropriate.
 
@@ -562,7 +562,7 @@
 finish accessing the data with the cpu, and then before actually
 giving the buffer to the hardware call either:
 
-	pci_dma_sync_single_for_device(dev, dma_handle, size, direction);
+	pci_dma_sync_single_for_device(pdev, dma_handle, size, direction);
 
 or:
 
@@ -739,7 +739,7 @@
 
 	dma_addr_t dma_handle;
 
-	dma_handle = pci_map_single(dev, addr, size, direction);
+	dma_handle = pci_map_single(pdev, addr, size, direction);
 	if (pci_dma_mapping_error(dma_handle)) {
 		/*
 		 * reduce current DMA mapping usage,



      ____________________________________________________________________________________
You rock. That's why Blockbuster's offering you one month of Blockbuster Total Access, No Cost.  
http://tc.deals.yahoo.com/tc/blockbuster/text5.com
