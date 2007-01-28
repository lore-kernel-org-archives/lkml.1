Return-Path: <linux-kernel-owner+w=401wt.eu-S932612AbXA1NcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612AbXA1NcI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 08:32:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932547AbXA1Naw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 08:30:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583AbXA1N3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 08:29:30 -0500
Message-Id: <20070128132437.299596000@programming.kicks-ass.net>
References: <20070128131343.628722000@programming.kicks-ass.net>
User-Agent: quilt/0.45-1
Date: Sun, 28 Jan 2007 14:13:54 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@osdl.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 11/14] atomic_ulong_t
Content-Disposition: inline; filename=atomic_ulong_t.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

provide an unsigned long atomic type.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/asm-generic/atomic.h |   45 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

Index: linux-2.6-git2/include/asm-generic/atomic.h
===================================================================
--- linux-2.6-git2.orig/include/asm-generic/atomic.h	2006-12-15 14:13:20.000000000 +0100
+++ linux-2.6-git2/include/asm-generic/atomic.h	2006-12-20 22:28:23.000000000 +0100
@@ -115,4 +115,49 @@ static inline void atomic_long_sub(long 
 
 #endif  /*  BITS_PER_LONG == 64  */
 
+typedef atomic_long_t atomic_ulong_t;
+
+#define ATOMIC_ULONG_INIT(i)	ATOMIC_LONG_INIT(i)
+static inline unsigned long atomic_ulong_read(atomic_ulong_t *l)
+{
+	atomic_long_t *v = (atomic_long_t *)l;
+
+	return (unsigned long)atomic_long_read(v);
+}
+
+static inline void atomic_ulong_set(atomic_ulong_t *l, unsigned long i)
+{
+	atomic_long_t *v = (atomic_long_t *)l;
+
+	atomic_long_set(v, i);
+}
+
+static inline void atomic_ulong_inc(atomic_ulong_t *l)
+{
+	atomic_long_t *v = (atomic_long_t *)l;
+
+	atomic_long_inc(v);
+}
+
+static inline void atomic_ulong_dec(atomic_ulong_t *l)
+{
+	atomic_long_t *v = (atomic_long_t *)l;
+
+	atomic_long_dec(v);
+}
+
+static inline void atomic_ulong_add(unsigned long i, atomic_ulong_t *l)
+{
+	atomic_long_t *v = (atomic_long_t *)l;
+
+	atomic_long_add(i, v);
+}
+
+static inline void atomic_ulong_sub(unsigned long i, atomic_ulong_t *l)
+{
+	atomic_long_t *v = (atomic_long_t *)l;
+
+	atomic_long_sub(i, v);
+}
+
 #endif  /*  _ASM_GENERIC_ATOMIC_H  */

--

