Return-Path: <linux-kernel-owner+w=401wt.eu-S1762772AbXGOXke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762772AbXGOXke (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757157AbXGOXkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:40:23 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:56347 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758196AbXGOXkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:40:21 -0400
Date: Sun, 15 Jul 2007 19:40:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] Immediate Values - Architecture Independent Code - kerneldoc for implementation
Message-ID: <20070715234019.GH22428@Krystal>
References: <20070714012439.285079881@polymtl.ca> <20070714012623.231272637@polymtl.ca> <20070714225925.GC18674@Krystal> <20070715013611.GF23209@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070715013611.GF23209@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:39:17 up 8 days, 13:44,  3 users,  load average: 0.43, 0.84, 0.56
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate Values - Architecture Independent Code - kerneldoc for implementation

Add kerneldoc to Immediate Values API.
It applies after
"Immediate Values - Architecture Independent Code - kerneldoc"

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: hch@infradead.org
---
 kernel/immediate.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

Index: linux-2.6-lttng/kernel/immediate.c
===================================================================
--- linux-2.6-lttng.orig/kernel/immediate.c	2007-07-15 19:04:08.000000000 -0400
+++ linux-2.6-lttng/kernel/immediate.c	2007-07-15 19:07:14.000000000 -0400
@@ -54,7 +54,10 @@ static inline void _immediate_update_ran
 }
 
 #ifdef CONFIG_MODULES
-/*
+/**
+ * module_immediate_setup - Update immediate values in a module
+ * @mod: pointer to the struct module
+ *
  * Setup the immediate according to the variable upon which it depends.  Called
  * by load_module with module_mutex held. This mutex protects against concurrent
  * modifications to modules'immediates. Therefore, since
@@ -89,6 +92,12 @@ static inline void immediate_update_modu
 static inline void immediate_update_modules(int lock) { }
 #endif
 
+/**
+ * immediate_update - update all immediate values in the kernel
+ * @lock: should a module_mutex be taken ?
+ *
+ * Iterate on the kernel core and modules to update the immediate values.
+ */
 void immediate_update(int lock)
 {
 	/* Core kernel immediates */
@@ -98,11 +107,7 @@ void immediate_update(int lock)
 }
 EXPORT_SYMBOL_GPL(immediate_update);
 
-/*
- * Update the immediate values to the state of the variables they refer to. It
- * is done before SMP is active, at the very beginning of start_kernel().
- */
-void __init immediate_update_early_range(const struct __immediate *begin,
+static void __init immediate_update_early_range(const struct __immediate *begin,
 		const struct __immediate *end)
 {
 	const struct __immediate *iter;
@@ -111,7 +116,12 @@ void __init immediate_update_early_range
 		arch_immediate_update_early(iter);
 }
 
-
+/**
+ * immediate_update_early - Update immediate values at boot time
+ *
+ * Update the immediate values to the state of the variables they refer to. It
+ * is done before SMP is active, at the very beginning of start_kernel().
+ */
 void __init immediate_update_early(void)
 {
 	immediate_update_early_range(__start___immediate, __stop___immediate);
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
