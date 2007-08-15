Return-Path: <linux-kernel-owner+w=401wt.eu-S932207AbXHOAle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbXHOAle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 20:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757318AbXHOAkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 20:40:37 -0400
Received: from ns2.suse.de ([195.135.220.15]:55675 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260AbXHOAkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 20:40:35 -0400
From: Andi Kleen <ak@suse.de>
References: <20070815240.194452000@suse.de>
In-Reply-To: <20070815240.194452000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: [PATCH] [1/4] x86_64: Fail dma_alloc_coherent on dma less devices 
Message-Id: <20070815004034.4AB7814DC8@wotan.suse.de>
Date: Wed, 15 Aug 2007 02:40:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This should fix an oops with PCMCIA PATA devices

http://bugzilla.kernel.org/show_bug.cgi?id=8424

This is not a full fix for the problem, but probably
still the right thing to do.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/pci-dma.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/arch/x86_64/kernel/pci-dma.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-dma.c
+++ linux/arch/x86_64/kernel/pci-dma.c
@@ -82,6 +82,10 @@ dma_alloc_coherent(struct device *dev, s
 	if (dma_mask == 0)
 		dma_mask = DMA_32BIT_MASK;
 
+	/* Device not DMA able */
+	if (dev->dma_mask == NULL)
+		return NULL;
+
 	/* Don't invoke OOM killer */
 	gfp |= __GFP_NORETRY;
 
