Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbXBKT2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbXBKT2E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 14:28:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932103AbXBKT2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 14:28:04 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:50179 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932104AbXBKT2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 14:28:03 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH 02/10] atomic.h : Complete atomic_long operations in asm-generic
Date: Sun, 11 Feb 2007 14:17:40 -0500
Message-Id: <11712214684190-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11712214684187-git-send-email-mathieu.desnoyers@polymtl.ca>
References: <11712214684187-git-send-email-mathieu.desnoyers@polymtl.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

atomic.h : Complete atomic_long operations in asm-generic

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -9,6 +9,7 @@
  */
 
 #include <asm/types.h>
+#include <asm/system.h>
 
 /*
  * Suppport for atomic_long_t
@@ -66,6 +67,72 @@ static inline void atomic_long_sub(long i, atomic_long_t *l)
 	atomic64_sub(i, v);
 }
 
+static inline int atomic_long_sub_and_test(long i, atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+	
+	return atomic64_sub_and_test(i, v);
+}
+
+static inline int atomic_long_dec_and_test(atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+	
+	return atomic64_dec_and_test(v);
+}
+
+static inline int atomic_long_inc_and_test(atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+	
+	return atomic64_inc_and_test(v);
+}
+
+static inline int atomic_long_add_negative(long i, atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+	
+	return atomic64_add_negative(i, v);
+}
+
+static inline long atomic_long_add_return(long i, atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+	
+	return (long)atomic64_add_return(i, v);
+}
+
+static inline long atomic_long_sub_return(long i, atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+	
+	return (long)atomic64_sub_return(i, v);
+}
+
+static inline long atomic_long_inc_return(atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+	
+	return (long)atomic64_inc_return(v);
+}
+
+static inline long atomic_long_dec_return(atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+	
+	return (long)atomic64_dec_return(v);
+}
+
+#define atomic_long_add_unless(l, a, u) \
+	atomic64_add_unless((atomic64_t *)(l), (a), (u))
+
+#define atomic_long_inc_not_zero(l) atomic64_inc_not_zero((atomic64_t *)(l))
+
+#define atomic_long_cmpxchg(l, old, new) \
+	(atomic_cmpxchg((atomic64_t *)(l), (old), (new)))
+#define atomic_long_xchg(v, new) \
+	(atomic_xchg((atomic64_t *)(l), (new)))
+
 #else  /*  BITS_PER_LONG == 64  */
 
 typedef atomic_t atomic_long_t;
@@ -113,6 +180,72 @@ static inline void atomic_long_sub(long i, atomic_long_t *l)
 	atomic_sub(i, v);
 }
 
+static inline int atomic_long_sub_and_test(long i, atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+	
+	return atomic_sub_and_test(i, v);
+}
+
+static inline int atomic_long_dec_and_test(atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+	
+	return atomic_dec_and_test(v);
+}
+
+static inline int atomic_long_inc_and_test(atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+	
+	return atomic_inc_and_test(v);
+}
+
+static inline int atomic_long_add_negative(long i, atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+	
+	return atomic_add_negative(i, v);
+}
+
+static inline long atomic_long_add_return(long i, atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+	
+	return (long)atomic_add_return(i, v);
+}
+
+static inline long atomic_long_sub_return(long i, atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+	
+	return (long)atomic_sub_return(i, v);
+}
+
+static inline long atomic_long_inc_return(atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+	
+	return (long)atomic_inc_return(v);
+}
+
+static inline long atomic_long_dec_return(atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+	
+	return (long)atomic_dec_return(v);
+}
+
+#define atomic_long_add_unless(l, a, u) \
+	atomic_add_unless((atomic_t *)(l), (a), (u))
+
+#define atomic_long_inc_not_zero(l) atomic_inc_not_zero((atomic_t *)(l))
+
+#define atomic_long_cmpxchg(l, old, new) \
+	(atomic_cmpxchg((atomic_t *)(l), (old), (new)))
+#define atomic_long_xchg(v, new) \
+	(atomic_xchg((atomic_t *)(l), (new)))
+
 #endif  /*  BITS_PER_LONG == 64  */
 
 #endif  /*  _ASM_GENERIC_ATOMIC_H  */
