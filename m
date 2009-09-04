Return-Path: <linux-kernel-owner+w=401wt.eu-S932618AbZIDGph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618AbZIDGph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 02:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbZIDGpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 02:45:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:62464 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756647AbZIDGpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:45:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,330,1249282800"; 
   d="scan'208";a="445599425"
Subject: [PATCH 03/18] dmaengine: cleanup unused transaction types
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
Date: Thu, 03 Sep 2009 23:44:50 -0700
Message-ID: <20090904064450.7141.51497.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No drivers currently implement these operation types, so they can be
deleted.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/arm/mach-iop13xx/setup.c |    7 -------
 arch/arm/plat-iop/adma.c      |    2 --
 drivers/dma/iop-adma.c        |    5 +----
 include/linux/dmaengine.h     |    3 ---
 4 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-iop13xx/setup.c b/arch/arm/mach-iop13xx/setup.c
index faaef95..5c147fb 100644
--- a/arch/arm/mach-iop13xx/setup.c
+++ b/arch/arm/mach-iop13xx/setup.c
@@ -477,10 +477,8 @@ void __init iop13xx_platform_init(void)
 			plat_data = &iop13xx_adma_0_data;
 			dma_cap_set(DMA_MEMCPY, plat_data->cap_mask);
 			dma_cap_set(DMA_XOR, plat_data->cap_mask);
-			dma_cap_set(DMA_DUAL_XOR, plat_data->cap_mask);
 			dma_cap_set(DMA_XOR_VAL, plat_data->cap_mask);
 			dma_cap_set(DMA_MEMSET, plat_data->cap_mask);
-			dma_cap_set(DMA_MEMCPY_CRC32C, plat_data->cap_mask);
 			dma_cap_set(DMA_INTERRUPT, plat_data->cap_mask);
 			break;
 		case IOP13XX_INIT_ADMA_1:
@@ -489,10 +487,8 @@ void __init iop13xx_platform_init(void)
 			plat_data = &iop13xx_adma_1_data;
 			dma_cap_set(DMA_MEMCPY, plat_data->cap_mask);
 			dma_cap_set(DMA_XOR, plat_data->cap_mask);
-			dma_cap_set(DMA_DUAL_XOR, plat_data->cap_mask);
 			dma_cap_set(DMA_XOR_VAL, plat_data->cap_mask);
 			dma_cap_set(DMA_MEMSET, plat_data->cap_mask);
-			dma_cap_set(DMA_MEMCPY_CRC32C, plat_data->cap_mask);
 			dma_cap_set(DMA_INTERRUPT, plat_data->cap_mask);
 			break;
 		case IOP13XX_INIT_ADMA_2:
@@ -501,13 +497,10 @@ void __init iop13xx_platform_init(void)
 			plat_data = &iop13xx_adma_2_data;
 			dma_cap_set(DMA_MEMCPY, plat_data->cap_mask);
 			dma_cap_set(DMA_XOR, plat_data->cap_mask);
-			dma_cap_set(DMA_DUAL_XOR, plat_data->cap_mask);
 			dma_cap_set(DMA_XOR_VAL, plat_data->cap_mask);
 			dma_cap_set(DMA_MEMSET, plat_data->cap_mask);
-			dma_cap_set(DMA_MEMCPY_CRC32C, plat_data->cap_mask);
 			dma_cap_set(DMA_INTERRUPT, plat_data->cap_mask);
 			dma_cap_set(DMA_PQ, plat_data->cap_mask);
-			dma_cap_set(DMA_PQ_UPDATE, plat_data->cap_mask);
 			dma_cap_set(DMA_PQ_VAL, plat_data->cap_mask);
 			break;
 		}
diff --git a/arch/arm/plat-iop/adma.c b/arch/arm/plat-iop/adma.c
index da1dd0d..1ff6a37 100644
--- a/arch/arm/plat-iop/adma.c
+++ b/arch/arm/plat-iop/adma.c
@@ -179,7 +179,6 @@ static int __init iop3xx_adma_cap_init(void)
 	dma_cap_set(DMA_INTERRUPT, iop3xx_dma_0_data.cap_mask);
 	#else
 	dma_cap_set(DMA_MEMCPY, iop3xx_dma_0_data.cap_mask);
-	dma_cap_set(DMA_MEMCPY_CRC32C, iop3xx_dma_0_data.cap_mask);
 	dma_cap_set(DMA_INTERRUPT, iop3xx_dma_0_data.cap_mask);
 	#endif
 
@@ -188,7 +187,6 @@ static int __init iop3xx_adma_cap_init(void)
 	dma_cap_set(DMA_INTERRUPT, iop3xx_dma_1_data.cap_mask);
 	#else
 	dma_cap_set(DMA_MEMCPY, iop3xx_dma_1_data.cap_mask);
-	dma_cap_set(DMA_MEMCPY_CRC32C, iop3xx_dma_1_data.cap_mask);
 	dma_cap_set(DMA_INTERRUPT, iop3xx_dma_1_data.cap_mask);
 	#endif
 
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index d6b6b52..9bbebf0 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -1257,15 +1257,12 @@ static int __devinit iop_adma_probe(struct platform_device *pdev)
 	}
 
 	dev_printk(KERN_INFO, &pdev->dev, "Intel(R) IOP: "
-	  "( %s%s%s%s%s%s%s%s%s%s)\n",
+	  "( %s%s%s%s%s%s%s)\n",
 	  dma_has_cap(DMA_PQ, dma_dev->cap_mask) ? "pq " : "",
-	  dma_has_cap(DMA_PQ_UPDATE, dma_dev->cap_mask) ? "pq_update " : "",
 	  dma_has_cap(DMA_PQ_VAL, dma_dev->cap_mask) ? "pq_val " : "",
 	  dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
-	  dma_has_cap(DMA_DUAL_XOR, dma_dev->cap_mask) ? "dual_xor " : "",
 	  dma_has_cap(DMA_XOR_VAL, dma_dev->cap_mask) ? "xor_val " : "",
 	  dma_has_cap(DMA_MEMSET, dma_dev->cap_mask)  ? "fill " : "",
-	  dma_has_cap(DMA_MEMCPY_CRC32C, dma_dev->cap_mask) ? "cpy+crc " : "",
 	  dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask) ? "cpy " : "",
 	  dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask) ? "intr " : "");
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 3e35df3..94656f9 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -56,12 +56,9 @@ enum dma_transaction_type {
 	DMA_MEMCPY,
 	DMA_XOR,
 	DMA_PQ,
-	DMA_DUAL_XOR,
-	DMA_PQ_UPDATE,
 	DMA_XOR_VAL,
 	DMA_PQ_VAL,
 	DMA_MEMSET,
-	DMA_MEMCPY_CRC32C,
 	DMA_INTERRUPT,
 	DMA_PRIVATE,
 	DMA_ASYNC_TX,

