Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbYIIGUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbYIIGUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 02:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbYIIGTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 02:19:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:1055 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977AbYIIGTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 02:19:32 -0400
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Cc: mingo@elite.hu, steven@uplinklabs.net
Subject: [PATCH] x86: unused variable in dma_alloc_coherent_gfp_flags()
Date: Mon,  8 Sep 2008 16:19:11 -0700
Message-Id: <1220915951-11434-3-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1220915951-11434-2-git-send-email-steven@uplinklabs.net>
References: <1220915951-11434-1-git-send-email-steven@uplinklabs.net>
 <1220915951-11434-2-git-send-email-steven@uplinklabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a warning caused by a badly placed ifdef.

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 include/asm-x86/dma-mapping.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index a072ae6..8bb3108 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -255,9 +255,9 @@ static inline unsigned long dma_alloc_coherent_mask(struct device *dev,
 
 static inline gfp_t dma_alloc_coherent_gfp_flags(struct device *dev, gfp_t gfp)
 {
+#ifdef CONFIG_X86_64
 	unsigned long dma_mask = dma_alloc_coherent_mask(dev, gfp);
 
-#ifdef CONFIG_X86_64
 	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA))
 		gfp |= GFP_DMA32;
 #endif
-- 
1.6.0.1

