Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbYLCAgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbYLCAgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYLCAgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:36:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40416 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbYLCAgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:36:06 -0500
Date: Wed, 3 Dec 2008 01:36:20 +0100
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Clean up namespace in kmap_types.h
Message-ID: <20081203003620.GA32069@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up namespace in kmap_types.h

During debugging I often use custom "D" macros. But I ran
into a name space conflict with kmap_types.h which also defines a D macro.
Rename the kmap_types.h one to KMAPD.

No semantical changes.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/kmap_types.h |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

Index: linux-2.6.28-rc4-test/arch/x86/include/asm/kmap_types.h
===================================================================
--- linux-2.6.28-rc4-test.orig/arch/x86/include/asm/kmap_types.h	2008-10-24 13:34:40.000000000 +0200
+++ linux-2.6.28-rc4-test/arch/x86/include/asm/kmap_types.h	2008-12-02 22:51:16.000000000 +0100
@@ -2,28 +2,28 @@
 #define _ASM_X86_KMAP_TYPES_H
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_DEBUG_HIGHMEM)
-# define D(n) __KM_FENCE_##n ,
+# define KMAPD(n) __KM_FENCE_##n ,
 #else
-# define D(n)
+# define KMAPD(n)
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
-D(13)	KM_TYPE_NR
+KMAPD(0)	KM_BOUNCE_READ,
+KMAPD(1)	KM_SKB_SUNRPC_DATA,
+KMAPD(2)	KM_SKB_DATA_SOFTIRQ,
+KMAPD(3)	KM_USER0,
+KMAPD(4)	KM_USER1,
+KMAPD(5)	KM_BIO_SRC_IRQ,
+KMAPD(6)	KM_BIO_DST_IRQ,
+KMAPD(7)	KM_PTE0,
+KMAPD(8)	KM_PTE1,
+KMAPD(9)	KM_IRQ0,
+KMAPD(10)	KM_IRQ1,
+KMAPD(11)	KM_SOFTIRQ0,
+KMAPD(12)	KM_SOFTIRQ1,
+KMAPD(13)	KM_TYPE_NR
 };
 
-#undef D
+#undef KMAPD
 
 #endif /* _ASM_X86_KMAP_TYPES_H */
