Return-Path: <linux-kernel-owner+w=401wt.eu-S1760657AbZEOCZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbZEOCZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 22:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757668AbZEOCYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 22:24:30 -0400
Received: from sh.osrg.net ([192.16.179.4]:39946 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbZEOCY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 22:24:28 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 2/4] sparc: add sync_single_for_device and sync_sg_for_device to struct dma_ops
Date: Fri, 15 May 2009 11:23:09 +0900
Message-Id: <1242354191-6232-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242354191-6232-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1242354191-6232-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 15 May 2009 11:24:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds sync_single_for_device() and sync_sg_for_device() to struct
dma_ops in order to unify dma-mpping_{32|64}.h. dma-mpping_32.h needs them though dma-mpping_64.h doesn't.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/sparc/include/asm/dma-mapping_64.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/sparc/include/asm/dma-mapping_64.h b/arch/sparc/include/asm/dma-mapping_64.h
index 017ae70..0c4fb1f 100644
--- a/arch/sparc/include/asm/dma-mapping_64.h
+++ b/arch/sparc/include/asm/dma-mapping_64.h
@@ -23,9 +23,15 @@ struct dma_ops {
 	void (*sync_single_for_cpu)(struct device *dev,
 				    dma_addr_t dma_handle, size_t size,
 				    enum dma_data_direction direction);
+	void (*sync_single_for_device)(struct device *dev,
+				       dma_addr_t dma_handle, size_t size,
+				       enum dma_data_direction direction);
 	void (*sync_sg_for_cpu)(struct device *dev, struct scatterlist *sg,
 				int nelems,
 				enum dma_data_direction direction);
+	void (*sync_sg_for_device)(struct device *dev,
+				   struct scatterlist *sg, int nents,
+				   enum dma_data_direction dir);
 };
 extern const struct dma_ops *dma_ops;
 
-- 
1.6.0.6

