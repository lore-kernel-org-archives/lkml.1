Return-Path: <linux-kernel-owner+w=401wt.eu-S1760629AbYDHQd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760629AbYDHQd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758961AbYDHQ3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:29:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758948AbYDHQ3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:29:04 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 17/28] x86: adjust dma_free_coherent for i386
Date: Tue,  8 Apr 2008 13:20:59 -0300
Message-Id: <12076717842335-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call unmap_single, if available.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-dma_32.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
index 78c7640..49166a4 100644
--- a/arch/x86/kernel/pci-dma_32.c
+++ b/arch/x86/kernel/pci-dma_32.c
@@ -84,6 +84,8 @@ void dma_free_coherent(struct device *dev, size_t size,
 	WARN_ON(irqs_disabled());	/* for portability */
 	if (dma_release_coherent(dev, order, vaddr))
 		return;
+	if (dma_ops->unmap_single)
+		dma_ops->unmap_single(dev, dma_handle, size, 0);
 	free_pages((unsigned long)vaddr, order);
 }
 EXPORT_SYMBOL(dma_free_coherent);
-- 
1.5.0.6

