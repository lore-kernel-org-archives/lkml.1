Return-Path: <linux-kernel-owner+w=401wt.eu-S1762017AbYFDUen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762017AbYFDUen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 16:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbYFDUec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 16:34:32 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42063 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752201AbYFDUeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 16:34:31 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] x86 atomic operations: atomic_or_long atomic_inc_short
Cc: jeremy@goop.org, mingo@elte.hu
Message-Id: <E1K3zfZ-0002Bj-8P@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 04 Jun 2008 15:33:17 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Cliff Wickman <cpw@sgi.com>

Provide atomic operations for increment of a 16-bit integer and
logical OR into a 64-bit integer.

[ This patch was split off of patch:
    SGI UV: TLB shootdown using broadcast assist unit
  and improved with advice from Jeremy Fitzhardinge <jeremy@goop.org> ]

Diffed against 2.6.26-rc4

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 include/asm-x86/atomic_64.h |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

Index: linux/include/asm-x86/atomic_64.h
===================================================================
--- linux.orig/include/asm-x86/atomic_64.h
+++ linux/include/asm-x86/atomic_64.h
@@ -431,6 +431,32 @@ static inline int atomic64_add_unless(at
 	return c != (u);
 }
 
+/**
+ * atomic_inc_short - increment of a short integer
+ * @v: pointer to type int
+ *
+ * Atomically adds 1 to @v
+ * Returns the new value of @u
+ */
+static inline short int atomic_inc_short(short int *v)
+{
+	asm(LOCK_PREFIX "addw $1, %0" : "+m" (*v));
+	return *v;
+}
+
+/**
+ * atomic_or_long - OR of two long integers
+ * @v1: pointer to type unsigned long
+ * @v2: pointer to type unsigned long
+ *
+ * Atomically ORs @v1 and @v2
+ * Returns the result of the OR
+ */
+static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
+{
+	asm(LOCK_PREFIX "orq %1, %0" : "+m" (*v1) : "r" (v2));
+}
+
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
 /* These are x86-specific, used by some header files */
