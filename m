Return-Path: <linux-kernel-owner+w=401wt.eu-S934629AbXHHBVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934629AbXHHBVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 21:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757805AbXHHBU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 21:20:58 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:46062 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758291AbXHHBU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 21:20:57 -0400
Date: Tue, 07 Aug 2007 18:25:29 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 5/5] dma: use dev_to_node to get node for device in
 dma_alloc_pages
In-reply-to: <200708072246.l77MkPaP008763@imap1.linux-foundation.org>
To: akpm@linux-foundation.org, ak@suse.de
Cc: apw@shadowen.org, clameter@sgi.com, greg@kroah.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200708071825.30055.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200708072246.l77MkPaP008763@imap1.linux-foundation.org>
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 5/5] dma: use dev_to_node to get node for device in dma_alloc_pages

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
