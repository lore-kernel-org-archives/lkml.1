Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYJXFlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYJXFlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 01:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYJXFlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 01:41:20 -0400
Received: from sh.osrg.net ([192.16.179.4]:45181 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529AbYJXFlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 01:41:19 -0400
Date: Fri, 24 Oct 2008 14:41:09 +0900
To: linux-ia64@vger.kernel.org
Cc: tony.luck@intel.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] IA64: remove dead BIO_VMERGE_BOUNDARY definition
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081024144038A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The block layer dropped the virtual merge feature
(b8b3e16cfe6435d961f6aaebcfd52a1ff2a988c5). BIO_VMERGE_BOUNDARY
definition is meaningless now (For IA64, BIO_VMERGE_BOUNDARY has been
meaningless for a long time since IA64 disables the virtual merge
feature).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/include/asm/io.h |   24 ------------------------
 1 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
index 7f25750..0d9d16e 100644
--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -434,28 +434,4 @@ extern void memset_io(volatile void __iomem *s, int c, long n);
 
 # endif /* __KERNEL__ */
 
-/*
- * Enabling BIO_VMERGE_BOUNDARY forces us to turn off I/O MMU bypassing.  It is said that
- * BIO-level virtual merging can give up to 4% performance boost (not verified for ia64).
- * On the other hand, we know that I/O MMU bypassing gives ~8% performance improvement on
- * SPECweb-like workloads on zx1-based machines.  Thus, for now we favor I/O MMU bypassing
- * over BIO-level virtual merging.
- */
-extern unsigned long ia64_max_iommu_merge_mask;
-#if 1
-#define BIO_VMERGE_BOUNDARY	0
-#else
-/*
- * It makes no sense at all to have this BIO_VMERGE_BOUNDARY macro here.  Should be
- * replaced by dma_merge_mask() or something of that sort.  Note: the only way
- * BIO_VMERGE_BOUNDARY is used is to mask off bits.  Effectively, our definition gets
- * expanded into:
- *
- *	addr & ((ia64_max_iommu_merge_mask + 1) - 1) == (addr & ia64_max_iommu_vmerge_mask)
- *
- * which is precisely what we want.
- */
-#define BIO_VMERGE_BOUNDARY	(ia64_max_iommu_merge_mask + 1)
-#endif
-
 #endif /* _ASM_IA64_IO_H */
-- 
1.5.4.2

