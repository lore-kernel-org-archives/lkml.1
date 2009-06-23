Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbZFWBzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbZFWBzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 21:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZFWBzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 21:55:07 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57836 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbZFWBzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 21:55:07 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 2/2] Blackfin: fix dma-mapping build errors
Date: Mon, 22 Jun 2009 21:54:46 -0400
Message-Id: <1245722086-13340-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245722086-13340-1-git-send-email-vapier@gentoo.org>
References: <1245722086-13340-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent deprecation of dma_sync_{sg,single} ironically broke Blackfin
systems.  This is because we don't define dma_sync_sg_for_cpu at all, so
until the DMA asm-generic conversion/cleanup is done after the next
release, simply redirect the dma_sync_sg_for_cpu to the debug version.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/dma-mapping.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/include/asm/dma-mapping.h b/arch/blackfin/include/asm/dma-mapping.h
index d7d9148..257eb42 100644
--- a/arch/blackfin/include/asm/dma-mapping.h
+++ b/arch/blackfin/include/asm/dma-mapping.h
@@ -1,6 +1,7 @@
 #ifndef _BLACKFIN_DMA_MAPPING_H
 #define _BLACKFIN_DMA_MAPPING_H
 
+#include <linux/dma-debug.h>
 #include <asm/scatterlist.h>
 
 void dma_alloc_init(unsigned long start, unsigned long end);
@@ -95,4 +96,7 @@ static inline void dma_sync_single_for_device(struct device *dev,
 					enum dma_data_direction dir)
 {
 }
+
+#define dma_sync_sg_for_cpu debug_dma_sync_sg_for_cpu
+
 #endif				/* _BLACKFIN_DMA_MAPPING_H */
-- 
1.6.3.1

