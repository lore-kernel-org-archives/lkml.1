Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbYJXFmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbYJXFmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 01:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYJXFl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 01:41:56 -0400
Received: from sh.osrg.net ([192.16.179.4]:45193 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbYJXFl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 01:41:56 -0400
Date: Fri, 24 Oct 2008 14:41:09 +0900
To: linuxppc-dev@ozlabs.org
Cc: paulus@samba.org, benh@kernel.crashing.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: remove dead BIO_VMERGE_BOUNDARY definition
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081024144036K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The block layer dropped the virtual merge feature
(b8b3e16cfe6435d961f6aaebcfd52a1ff2a988c5). BIO_VMERGE_BOUNDARY
definition is meaningless now (For POWER, BIO_VMERGE_BOUNDARY has been
meaningless for a long time since POWER disables the virtual merge
feature).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/powerpc/include/asm/io.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
index 08266d2..494cd8b 100644
--- a/arch/powerpc/include/asm/io.h
+++ b/arch/powerpc/include/asm/io.h
@@ -713,13 +713,6 @@ static inline void * phys_to_virt(unsigned long address)
  */
 #define page_to_phys(page)	((phys_addr_t)page_to_pfn(page) << PAGE_SHIFT)
 
-/* We do NOT want virtual merging, it would put too much pressure on
- * our iommu allocator. Instead, we want drivers to be smart enough
- * to coalesce sglists that happen to have been mapped in a contiguous
- * way by the iommu
- */
-#define BIO_VMERGE_BOUNDARY	0
-
 /*
  * 32 bits still uses virt_to_bus() for it's implementation of DMA
  * mappings se we have to keep it defined here. We also have some old
-- 
1.5.4.2

