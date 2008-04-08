Return-Path: <linux-kernel-owner+w=401wt.eu-S1760733AbYDHQdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733AbYDHQdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758967AbYDHQ3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:29:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758950AbYDHQ3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:29:04 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 23/28] x86: don't try to allocate from DMA zone at first
Date: Tue,  8 Apr 2008 13:21:05 -0300
Message-Id: <12076718192615-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we fail, we'll loop into the allocation again,
and then allocate in the DMA zone.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-dma_32.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
index 0e9ec11..11f100a 100644
--- a/arch/x86/kernel/pci-dma_32.c
+++ b/arch/x86/kernel/pci-dma_32.c
@@ -84,9 +84,6 @@ void *dma_alloc_coherent(struct device *dev, size_t size,
 	if (dma_alloc_from_coherent_mem(dev, size, dma_handle, &ret))
 		return ret;
 
-	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
-		gfp |= GFP_DMA;
-
 	if (!dev)
 		dev = &fallback_dev;
 
-- 
1.5.0.6

