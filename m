Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbZIPUZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbZIPUZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbZIPUZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:25:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38234 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbZIPUZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:25:13 -0400
Date: Wed, 16 Sep 2009 22:25:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Rename D macro in kmap_types.h
Message-ID: <20090916202512.GA511@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename D macro in kmap_types.h

I tend to use a 'D' debugging macro a lot during debugging.
When I define it before includes I often get conflicts
with kmap_types.h's use of 'D' too. It's not very nice
when a global include pollutes the name space like this.

Rename the kmap_types.h D to KMAP_D. It is only used
temporarily in the header so has no effect on anything else.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/asm-generic/kmap_types.h |   47 +++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

Index: linux-2.6.31-rc3-ak/include/asm-generic/kmap_types.h
===================================================================
--- linux-2.6.31-rc3-ak.orig/include/asm-generic/kmap_types.h
+++ linux-2.6.31-rc3-ak/include/asm-generic/kmap_types.h
@@ -2,34 +2,35 @@
 #define _ASM_GENERIC_KMAP_TYPES_H
 
 #ifdef __WITH_KM_FENCE
-# define D(n) __KM_FENCE_##n ,
+# define KMAP_D(n) __KM_FENCE_##n ,
 #else
-# define D(n)
+# define KMAP_D(n)
 #endif
 
 enum km_type {
-D(0)	KM_BOUNCE_READ,
-D(1)	KM_SKB_SUNRPC_DATA,
-D(2)	KM_SKB_DATA_SOFTIRQ,
-D(3)	KM_USER0,
-D(4)	KM_USER1,
-D(5)	KM_BIO_SRC_IRQ,
-D(6)	KM_BIO_DST_IRQ,
-D(7)	KM_PTE0,
-D(8)	KM_PTE1,
-D(9)	KM_IRQ0,
-D(10)	KM_IRQ1,
-D(11)	KM_SOFTIRQ0,
-D(12)	KM_SOFTIRQ1,
-D(13)	KM_SYNC_ICACHE,
-D(14)	KM_SYNC_DCACHE,
-D(15)	KM_UML_USERCOPY, /* UML specific, for copy_*_user - used in do_op_one_page */
-D(16)	KM_IRQ_PTE,
-D(17)	KM_NMI,
-D(18)	KM_NMI_PTE,
-D(19)	KM_TYPE_NR
+KMAP_D(0)	KM_BOUNCE_READ,
+KMAP_D(1)	KM_SKB_SUNRPC_DATA,
+KMAP_D(2)	KM_SKB_DATA_SOFTIRQ,
+KMAP_D(3)	KM_USER0,
+KMAP_D(4)	KM_USER1,
+KMAP_D(5)	KM_BIO_SRC_IRQ,
+KMAP_D(6)	KM_BIO_DST_IRQ,
+KMAP_D(7)	KM_PTE0,
+KMAP_D(8)	KM_PTE1,
+KMAP_D(9)	KM_IRQ0,
+KMAP_D(10)	KM_IRQ1,
+KMAP_D(11)	KM_SOFTIRQ0,
+KMAP_D(12)	KM_SOFTIRQ1,
+KMAP_D(13)	KM_SYNC_ICACHE,
+KMAP_D(14)	KM_SYNC_DCACHE,
+/* UML specific, for copy_*_user - used in do_op_one_page */
+KMAP_D(15)	KM_UML_USERCOPY,
+KMAP_D(16)	KM_IRQ_PTE,
+KMAP_D(17)	KM_NMI,
+KMAP_D(18)	KM_NMI_PTE,
+KMAP_D(19)	KM_TYPE_NR
 };
 
-#undef D
+#undef KMAP_D
 
 #endif
