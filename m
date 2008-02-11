Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbYBKQYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbYBKQYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757248AbYBKQYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:24:06 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:55312 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967AbYBKQYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:24:04 -0500
Message-ID: <47B07685.5000606@tiscali.nl>
Date: Mon, 11 Feb 2008 17:23:33 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: kyle@parisc-linux.org, Matthew Wilcox <matthew@wil.cx>,
       grundler@parisc-linux.org
CC: linux-parisc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH?][arch/parisc/kernel/pci-dma.c] pcxl_dma_ops.alloc_noncoherent
 = pa11_dma_alloc_consistent?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

duplicate pa11_dma_alloc_consistent; more appropriate appears
pa11_dma_alloc_noncoherent here. 

Not tested, please confirm that this fix is correct
---
fix noncoherent allocation

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index 9448d4e..0e8b71f 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -549,7 +549,7 @@ static void pa11_dma_sync_sg_for_device(struct device *dev, struct scatterlist *
 struct hppa_dma_ops pcxl_dma_ops = {
 	.dma_supported =	pa11_dma_supported,
 	.alloc_consistent =	pa11_dma_alloc_consistent,
-	.alloc_noncoherent =	pa11_dma_alloc_consistent,
+	.alloc_noncoherent =	pa11_dma_alloc_noncoherent,
 	.free_consistent =	pa11_dma_free_consistent,
 	.map_single =		pa11_dma_map_single,
 	.unmap_single =		pa11_dma_unmap_single,
