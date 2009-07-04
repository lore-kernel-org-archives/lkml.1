Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbZGDCf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbZGDCf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 22:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757898AbZGDCfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 22:35:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:41445 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759084AbZGDCfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 22:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sViFcnIk2UWCcB+hox8iJxrLSNGk9bT7WjnPrLWKrMMp8ikQEU/nENDAEiV2nWYTu3
         eAgjfCc1tdQfjm/hyNkODce8BB/Krstf6RoRiPupZr/E5zY78GX5Ei66rmO54swFe6Zn
         v1EeDHtYva3EGY7wfjbVhXtImqs/Im4/Wy8yk=
From: tom.leiming@gmail.com
To: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 1/3] dma-mapping:remove CONFIG_HAVE_DMA_ATTRS
Date: Sat,  4 Jul 2009 10:34:53 +0800
Message-Id: <1246674895-9610-2-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1246674895-9610-1-git-send-email-tom.leiming@gmail.com>
References: <1246674895-9610-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>


Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 include/linux/dma-attrs.h   |   10 ----------
 include/linux/dma-mapping.h |   17 -----------------
 2 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/include/linux/dma-attrs.h b/include/linux/dma-attrs.h
index 71ad34e..fce45cd 100644
--- a/include/linux/dma-attrs.h
+++ b/include/linux/dma-attrs.h
@@ -36,7 +36,6 @@ static inline void init_dma_attrs(struct dma_attrs *attrs)
 	bitmap_zero(attrs->flags, __DMA_ATTRS_LONGS);
 }
 
-#ifdef CONFIG_HAVE_DMA_ATTRS
 /**
  * dma_set_attr - set a specific attribute
  * @attr: attribute to set
@@ -62,14 +61,5 @@ static inline int dma_get_attr(enum dma_attr attr, struct dma_attrs *attrs)
 	BUG_ON(attr >= DMA_ATTR_MAX);
 	return test_bit(attr, attrs->flags);
 }
-#else /* !CONFIG_HAVE_DMA_ATTRS */
-static inline void dma_set_attr(enum dma_attr attr, struct dma_attrs *attrs)
-{
-}
 
-static inline int dma_get_attr(enum dma_attr attr, struct dma_attrs *attrs)
-{
-	return 0;
-}
-#endif /* CONFIG_HAVE_DMA_ATTRS */
 #endif /* _DMA_ATTR_H */
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 07dfd46..b83acee 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -219,21 +219,4 @@ static inline void dmam_release_declared_memory(struct device *dev)
 }
 #endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
 
-#ifndef CONFIG_HAVE_DMA_ATTRS
-struct dma_attrs;
-
-#define dma_map_single_attrs(dev, cpu_addr, size, dir, attrs) \
-	dma_map_single(dev, cpu_addr, size, dir)
-
-#define dma_unmap_single_attrs(dev, dma_addr, size, dir, attrs) \
-	dma_unmap_single(dev, dma_addr, size, dir)
-
-#define dma_map_sg_attrs(dev, sgl, nents, dir, attrs) \
-	dma_map_sg(dev, sgl, nents, dir)
-
-#define dma_unmap_sg_attrs(dev, sgl, nents, dir, attrs) \
-	dma_unmap_sg(dev, sgl, nents, dir)
-
-#endif /* CONFIG_HAVE_DMA_ATTRS */
-
 #endif
-- 
1.6.0.GIT

