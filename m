Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbYLNDpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbYLNDpt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 22:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbYLNDpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 22:45:40 -0500
Received: from sh.osrg.net ([192.16.179.4]:52209 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbYLNDpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 22:45:39 -0500
Date: Sun, 14 Dec 2008 12:44:59 +0900
To: linuxppc-dev@ozlabs.org
Cc: paulus@samba.org, benh@kernel.crashing.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: [RESEND] [PATCH] powerpc: remove dead BIO_VMERGE_BOUNDARY
 definition
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081214124508U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend of:

http://marc.info/?l=linux-kernel&m=122482703616607&w=2

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] powerpc: remove dead BIO_VMERGE_BOUNDARY definition

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
1.5.5.GIT

