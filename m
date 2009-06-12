Return-Path: <linux-kernel-owner+w=401wt.eu-S1765366AbZFLQ0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765366AbZFLQ0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764185AbZFLQY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:24:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39061 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760273AbZFLQYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:24:55 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Jie Zhang <jie.zhang@analog.com>
Subject: [PATCH 03/27] Blackfin: rename bfin_addr_dcachable to bfin_addr_dcacheable
Date: Fri, 12 Jun 2009 12:24:21 -0400
Message-Id: <1244823885-22410-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Zhang <jie.zhang@analog.com>

The latter naming convention is much more common.

Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/cacheflush.h  |    2 +-
 arch/blackfin/kernel/bfin_dma_5xx.c     |    4 ++--
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c |    2 +-
 drivers/spi/spi_bfin5xx.c               |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/blackfin/include/asm/cacheflush.h b/arch/blackfin/include/asm/cacheflush.h
index 94697f0..18bc4f7 100644
--- a/arch/blackfin/include/asm/cacheflush.h
+++ b/arch/blackfin/include/asm/cacheflush.h
@@ -97,7 +97,7 @@ do { memcpy(dst, src, len);						\
 extern unsigned long reserved_mem_dcache_on;
 extern unsigned long reserved_mem_icache_on;
 
-static inline int bfin_addr_dcachable(unsigned long addr)
+static inline int bfin_addr_dcacheable(unsigned long addr)
 {
 #ifdef CONFIG_BFIN_DCACHE
 	if (addr < (_ramend - DMA_UNCACHED_REGION))
diff --git a/arch/blackfin/kernel/bfin_dma_5xx.c b/arch/blackfin/kernel/bfin_dma_5xx.c
index 763ed84..e0bf8cc 100644
--- a/arch/blackfin/kernel/bfin_dma_5xx.c
+++ b/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -453,10 +453,10 @@ void *dma_memcpy(void *pdst, const void *psrc, size_t size)
 	unsigned long src = (unsigned long)psrc;
 	size_t bulk, rest;
 
-	if (bfin_addr_dcachable(src))
+	if (bfin_addr_dcacheable(src))
 		blackfin_dcache_flush_range(src, src + size);
 
-	if (bfin_addr_dcachable(dst))
+	if (bfin_addr_dcacheable(dst))
 		blackfin_dcache_invalidate_range(dst, dst + size);
 
 	bulk = size & ~0xffff;
diff --git a/arch/blackfin/kernel/cplb-mpu/cplbmgr.c b/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
index 87463ce..784923e 100644
--- a/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
+++ b/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
@@ -151,7 +151,7 @@ static noinline int dcplb_miss(unsigned int cpu)
 
 	d_data = CPLB_SUPV_WR | CPLB_VALID | CPLB_DIRTY | PAGE_SIZE_4KB;
 #ifdef CONFIG_BFIN_DCACHE
-	if (bfin_addr_dcachable(addr)) {
+	if (bfin_addr_dcacheable(addr)) {
 		d_data |= CPLB_L1_CHBL | ANOMALY_05000158_WORKAROUND;
 #ifdef CONFIG_BFIN_WT
 		d_data |= CPLB_L1_AOW | CPLB_WT;
diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index f014cc2..011c5bd 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -803,7 +803,7 @@ static void bfin_spi_pump_transfers(unsigned long data)
 				drv_data->rx, drv_data->len_in_bytes);
 
 			/* invalidate caches, if needed */
-			if (bfin_addr_dcachable((unsigned long) drv_data->rx))
+			if (bfin_addr_dcacheable((unsigned long) drv_data->rx))
 				invalidate_dcache_range((unsigned long) drv_data->rx,
 							(unsigned long) (drv_data->rx +
 							drv_data->len_in_bytes));
@@ -816,7 +816,7 @@ static void bfin_spi_pump_transfers(unsigned long data)
 			dev_dbg(&drv_data->pdev->dev, "doing DMA out.\n");
 
 			/* flush caches, if needed */
-			if (bfin_addr_dcachable((unsigned long) drv_data->tx))
+			if (bfin_addr_dcacheable((unsigned long) drv_data->tx))
 				flush_dcache_range((unsigned long) drv_data->tx,
 						(unsigned long) (drv_data->tx +
 						drv_data->len_in_bytes));
-- 
1.6.3.1

