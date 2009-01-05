Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZAEOup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZAEOup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZAEOuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:50:35 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:57759 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634AbZAEOue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:50:34 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/8] add map_page and unmap_page to struct dma_mapping_ops
Date: Mon,  5 Jan 2009 23:47:21 +0900
Message-Id: <1231166848-20149-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231166848-20149-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1231166848-20149-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds map_page and unmap_page to struct dma_mapping_ops.

This is a preparation of struct dma_mapping_ops unification. We use
map_page and unmap_page instead of map_single and unmap_single.

We will remove map_single and unmap_single hooks in the last patch in
this patchset.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/include/asm/dma-mapping.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index e93265c..2f89d2e 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -8,6 +8,7 @@
 
 #include <linux/kmemcheck.h>
 #include <linux/scatterlist.h>
+#include <linux/dma-attrs.h>
 #include <asm/io.h>
 #include <asm/swiotlb.h>
 #include <asm-generic/dma-coherent.h>
@@ -51,6 +52,13 @@ struct dma_mapping_ops {
 	void            (*unmap_sg)(struct device *hwdev,
 				struct scatterlist *sg, int nents,
 				int direction);
+	dma_addr_t	(*map_page)(struct device *dev, struct page *page,
+				    unsigned long offset, size_t size,
+				    enum dma_data_direction dir,
+				    struct dma_attrs *attrs);
+	void 		(*unmap_page)(struct device *dev, dma_addr_t dma_handle,
+				      size_t size, enum dma_data_direction dir,
+				      struct dma_attrs *attrs);
 	int             (*dma_supported)(struct device *hwdev, u64 mask);
 	int		is_phys;
 };
-- 
1.6.0.6

