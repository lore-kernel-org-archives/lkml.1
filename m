Return-Path: <linux-kernel-owner+w=401wt.eu-S1760914AbYDHQeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914AbYDHQeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759127AbYDHQ3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:29:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759116AbYDHQ3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:29:19 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 25/28] x86: remove kludge from x86_64
Date: Tue,  8 Apr 2008 13:21:07 -0300
Message-Id: <12076718311113-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The claim is that i386 does it. Just it does not.
So remove it.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-dma_64.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index b956f59..596c8c8 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -68,10 +68,6 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	/* Don't invoke OOM killer */
 	gfp |= __GFP_NORETRY;
 
-	/* Kludge to make it bug-to-bug compatible with i386. i386
-	   uses the normal dma_mask for alloc_coherent. */
-	dma_mask &= *dev->dma_mask;
-
 	/* Why <=? Even when the mask is smaller than 4GB it is often
 	   larger than 16MB and in this case we have a chance of
 	   finding fitting memory in the next higher zone first. If
-- 
1.5.0.6

