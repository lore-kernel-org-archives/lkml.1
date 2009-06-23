Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbZFWCeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbZFWCeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 22:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbZFWCeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 22:34:01 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48268 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbZFWCeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 22:34:00 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/2 v2] Blackfin: fix dma-mapping build errors
Date: Mon, 22 Jun 2009 22:33:40 -0400
Message-Id: <1245724420-26317-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090623111430D.fujita.tomonori@lab.ntt.co.jp>
References: <20090623111430D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

The recent deprecation of dma_sync_{sg,single} ironically broke Blackfin
systems.  This is because we don't define dma_sync_sg_for_cpu at all, so
until the DMA asm-generic conversion/cleanup is done after the next
release, simply stub out the dma_sync_sg_for_{cpu,device} functions.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/dma-mapping.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/include/asm/dma-mapping.h b/arch/blackfin/include/asm/dma-mapping.h
index d7d9148..ed6b1f3 100644
--- a/arch/blackfin/include/asm/dma-mapping.h
+++ b/arch/blackfin/include/asm/dma-mapping.h
@@ -95,4 +95,17 @@ static inline void dma_sync_single_for_device(struct device *dev,
 					enum dma_data_direction dir)
 {
 }
+
+static inline void dma_sync_sg_for_cpu(struct device *dev,
+					struct scatterlist *sg,
+					int nents, enum dma_data_direction dir)
+{
+}
+
+static inline void dma_sync_sg_for_device(struct device *dev,
+					struct scatterlist *sg,
+					int nents, enum dma_data_direction dir)
+{
+}
+
 #endif				/* _BLACKFIN_DMA_MAPPING_H */
-- 
1.6.3.1

