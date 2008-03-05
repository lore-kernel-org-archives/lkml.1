Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbYCEQFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbYCEQFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759376AbYCEQEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:04:49 -0500
Received: from www.tglx.de ([62.245.132.106]:49805 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699AbYCEQEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:04:47 -0500
Message-Id: <20080305155117.486097492@linutronix.de>
References: <20080305154829.185609547@linutronix.de>
User-Agent: quilt/0.46-1
Date: Wed, 05 Mar 2008 16:03:46 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 2/5] slab: add a flag to prevent debug_free checks on a
	kmem_cache
Content-Disposition: inline; filename=add-slab-flag-to-avoid-debug-checks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preperatory patch for the debugobjects infrastructure. The
flag prevents debug_free checks on kmem_caches. This is necessary to
avoid resursive calls into a debug mechanism which uses a kmem_cache
itself.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/slab.h |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6/include/linux/slab.h
===================================================================
--- linux-2.6.orig/include/linux/slab.h
+++ linux-2.6/include/linux/slab.h
@@ -29,6 +29,13 @@
 #define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory over cpuset */
 #define SLAB_TRACE		0x00200000UL	/* Trace allocations and frees */
 
+/* Flag to prevent checks on free */
+#ifdef CONFIG_DEBUG_OBJECTS
+# define SLAB_DEBUG_OBJECTS	0x00400000UL
+#else
+# define SLAB_DEBUG_OBJECTS	0x00000000UL
+#endif
+
 /* The following flags affect the page allocator grouping pages by mobility */
 #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */

-- 

