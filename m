Return-Path: <linux-kernel-owner+w=401wt.eu-S936186AbXGWUqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936186AbXGWUqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935779AbXGWUpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:45:36 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:44073 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935490AbXGWUpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:45:33 -0400
Date: Mon, 23 Jul 2007 13:49:21 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 5/10] dma: use dev_to_node to get node for device in
 dma_alloc_pages
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200707231349.21604.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 5/10] dma: use dev_to_node to get node for device in dma_alloc_pages

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Acked-by: Christoph Lameter <clameter@sgi.com>

diff --git a/arch/x86_64/kernel/pci-dma.c b/arch/x86_64/kernel/pci-dma.c
index 9f80aad..6dbf1c9 100644
--- a/arch/x86_64/kernel/pci-dma.c
+++ b/arch/x86_64/kernel/pci-dma.c
@@ -52,11 +52,9 @@ dma_alloc_pages(struct device *dev, gfp_t gfp, unsigned order)
 {
 	struct page *page;
 	int node;
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
-		node = pcibus_to_node(to_pci_dev(dev)->bus);
-	else
-#endif
+
+	node = dev_to_node(dev);
+	if (node == -1)
 		node = numa_node_id();
 
 	if (node < first_node(node_online_map))
