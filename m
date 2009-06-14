Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbZFNWkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbZFNWkM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 18:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZFNWkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 18:40:01 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35564 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbZFNWkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 18:40:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 15 Jun 2009 00:38:50 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: fix DMA unmapping in iso buffer removal
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.a52095c7211a30e8@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmap_unmap_page() shall use the same direction as dma_map_page().

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-iso.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/firewire/core-iso.c
===================================================================
--- linux.orig/drivers/firewire/core-iso.c
+++ linux/drivers/firewire/core-iso.c
@@ -71,7 +71,7 @@ int fw_iso_buffer_init(struct fw_iso_buf
 	for (j = 0; j < i; j++) {
 		address = page_private(buffer->pages[j]);
 		dma_unmap_page(card->device, address,
-			       PAGE_SIZE, DMA_TO_DEVICE);
+			       PAGE_SIZE, direction);
 		__free_page(buffer->pages[j]);
 	}
 	kfree(buffer->pages);
@@ -108,7 +108,7 @@ void fw_iso_buffer_destroy(struct fw_iso
 	for (i = 0; i < buffer->page_count; i++) {
 		address = page_private(buffer->pages[i]);
 		dma_unmap_page(card->device, address,
-			       PAGE_SIZE, DMA_TO_DEVICE);
+			       PAGE_SIZE, buffer->direction);
 		__free_page(buffer->pages[i]);
 	}
 

-- 
Stefan Richter
-=====-==--= -==- -====
http://arcgraph.de/sr/

