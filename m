Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbYCMX2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbYCMX2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 19:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbYCMX2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 19:28:33 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45654 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbYCMX2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 19:28:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 14 Mar 2008 00:27:49 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firewire: fw-ohci: shut up false compiler warning on
 PPC32
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Jarod Wilson <jwilson@redhat.com>
In-Reply-To: <47D8679A.10303@s5r6.in-berlin.de>
Message-ID: <tkrat.662a510489fead33@s5r6.in-berlin.de>
References: <200803121743.27170.jwilson@redhat.com>
 <47D8679A.10303@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shut up "may be used uninitialised in this function" warnings due to
PPC32's implementation of dma_alloc_coherent().

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

updated to be enqueued after patch
"firewire: fw-ohci: use dma_alloc_coherent for ar_buffer"

 drivers/firewire/fw-ohci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -281,7 +281,7 @@ static int ar_context_add_page(struct ar
 {
 	struct device *dev = ctx->ohci->card.device;
 	struct ar_buffer *ab;
-	dma_addr_t ab_bus;
+	dma_addr_t uninitialized_var(ab_bus);
 	size_t offset;
 
 	ab = dma_alloc_coherent(dev, PAGE_SIZE, &ab_bus, GFP_ATOMIC);
@@ -536,7 +536,7 @@ static int
 context_add_buffer(struct context *ctx)
 {
 	struct descriptor_buffer *desc;
-	dma_addr_t bus_addr;
+	dma_addr_t uninitialized_var(bus_addr);
 	int offset;
 
 	/*
@@ -1321,7 +1321,7 @@ ohci_set_config_rom(struct fw_card *card
 	unsigned long flags;
 	int retval = -EBUSY;
 	__be32 *next_config_rom;
-	dma_addr_t next_config_rom_bus;
+	dma_addr_t uninitialized_var(next_config_rom_bus);
 
 	ohci = fw_ohci(card);
 

-- 
Stefan Richter
-=====-==--- --== -===-
http://arcgraph.de/sr/

