Return-Path: <linux-kernel-owner+w=401wt.eu-S1756973AbYJXFnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbYJXFnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 01:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbYJXFmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 01:42:19 -0400
Received: from sh.osrg.net ([192.16.179.4]:45197 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287AbYJXFmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 01:42:17 -0400
Date: Fri, 24 Oct 2008 14:41:03 +0900
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, jens.axboe@oracle.com
Subject: [PATCH] x86: remove dead BIO_VMERGE_BOUNDARY definition
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081024143836K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The block layer dropped the virtual merge feature
(b8b3e16cfe6435d961f6aaebcfd52a1ff2a988c5). BIO_VMERGE_BOUNDARY
definition is meaningless now.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/include/asm/io.h    |    2 --
 arch/x86/include/asm/io_64.h |    2 --
 arch/x86/kernel/pci-dma.c    |    6 ------
 3 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 5618a10..2f13dbe 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -59,8 +59,6 @@ build_mmio_write(__writeq, "q", unsigned long, "r", )
 #define writeq writeq
 #endif
 
-extern int iommu_bio_merge;
-
 #ifdef CONFIG_X86_32
 # include "io_32.h"
 #else
diff --git a/arch/x86/include/asm/io_64.h b/arch/x86/include/asm/io_64.h
index fea325a..563c162 100644
--- a/arch/x86/include/asm/io_64.h
+++ b/arch/x86/include/asm/io_64.h
@@ -232,8 +232,6 @@ void memset_io(volatile void __iomem *a, int b, size_t c);
 
 #define flush_write_buffers()
 
-#define BIO_VMERGE_BOUNDARY iommu_bio_merge
-
 /*
  * Convert a virtual cached pointer to an uncached pointer
  */
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 1972266..d851667 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -28,11 +28,6 @@ int no_iommu __read_mostly;
 /* Set this to 1 if there is a HW IOMMU in the system */
 int iommu_detected __read_mostly = 0;
 
-/* This tells the BIO block layer to assume merging. Default to off
-   because we cannot guarantee merging later. */
-int iommu_bio_merge __read_mostly = 0;
-EXPORT_SYMBOL(iommu_bio_merge);
-
 dma_addr_t bad_dma_address __read_mostly = 0;
 EXPORT_SYMBOL(bad_dma_address);
 
@@ -186,7 +181,6 @@ static __init int iommu_setup(char *p)
 		}
 
 		if (!strncmp(p, "biomerge", 8)) {
-			iommu_bio_merge = 4096;
 			iommu_merge = 1;
 			force_iommu = 1;
 		}
-- 
1.5.4.2

