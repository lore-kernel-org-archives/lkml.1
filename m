Return-Path: <linux-kernel-owner+w=401wt.eu-S1761214AbYDHQe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761214AbYDHQe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759335AbYDHQ3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:29:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759318AbYDHQ3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:29:43 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 27/28] x86: don't do dma if mask is NULL.
Date: Tue,  8 Apr 2008 13:21:09 -0300
Message-Id: <12076718441606-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if the device hasn't provided a mask, abort allocation.
Note that we're using a fallback device now, so it does not cover
the case of a NULL device: just drivers passing NULL masks around.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-dma_32.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
index f134de3..d2f7074 100644
--- a/arch/x86/kernel/pci-dma_32.c
+++ b/arch/x86/kernel/pci-dma_32.c
@@ -91,6 +91,9 @@ void *dma_alloc_coherent(struct device *dev, size_t size,
 	if (dma_mask == 0)
 		dma_mask = DMA_32BIT_MASK;
 
+	if (dev->dma_mask == NULL)
+		return NULL;
+
 	/* Don't invoke OOM killer */
 	gfp |= __GFP_NORETRY;
 again:
-- 
1.5.0.6

