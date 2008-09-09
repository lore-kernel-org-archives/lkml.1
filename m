Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbYIIQK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbYIIQK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbYIIQI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:08:56 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:35997 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874AbYIIQIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:08:53 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 2/2] x86: convert dma_alloc_coherent to use is_device_dma_capable
Date: Wed, 10 Sep 2008 00:49:48 +0900
Message-Id: <1220975388-8318-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1220975388-8318-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220975388-8318-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220975388-8318-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/asm-x86/dma-mapping.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 9dd92b4..7b0fdd6 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -280,7 +280,7 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp |= GFP_DMA;
 	}
 
-	if (!dev->dma_mask)
+	if (!is_device_dma_capable(dev))
 		return NULL;
 
 	if (!ops->alloc_coherent)
-- 
1.5.4.2

