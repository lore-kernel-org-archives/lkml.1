Return-Path: <linux-kernel-owner+w=401wt.eu-S1758859AbYDHQ2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859AbYDHQ2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757858AbYDHQ1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:27:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757841AbYDHQ1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:27:31 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 06/28] x86: use dma_length in i386
Date: Tue,  8 Apr 2008 13:20:48 -0300
Message-Id: <12076717124023-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is done to get the code closer to x86_64.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-base_32.c |    1 +
 include/asm-x86/scatterlist.h |    2 --
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/pci-base_32.c b/arch/x86/kernel/pci-base_32.c
index 7caf5c2..837bbe9 100644
--- a/arch/x86/kernel/pci-base_32.c
+++ b/arch/x86/kernel/pci-base_32.c
@@ -24,6 +24,7 @@ static int pci32_dma_map_sg(struct device *dev, struct scatterlist *sglist,
 		BUG_ON(!sg_page(sg));
 
 		sg->dma_address = sg_phys(sg);
+		sg->dma_length = sg->length;
 	}
 
 	flush_write_buffers();
diff --git a/include/asm-x86/scatterlist.h b/include/asm-x86/scatterlist.h
index d13c197..c043206 100644
--- a/include/asm-x86/scatterlist.h
+++ b/include/asm-x86/scatterlist.h
@@ -11,9 +11,7 @@ struct scatterlist {
 	unsigned int	offset;
 	unsigned int	length;
 	dma_addr_t	dma_address;
-#ifdef CONFIG_X86_64
 	unsigned int	dma_length;
-#endif
 };
 
 #define ARCH_HAS_SG_CHAIN
-- 
1.5.0.6

