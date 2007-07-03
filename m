Return-Path: <linux-kernel-owner+w=401wt.eu-S1757715AbXGCQp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbXGCQp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758332AbXGCQpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:45:23 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:45763 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871AbXGCQpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:45:18 -0400
Message-Id: <20070703164513.431226966@polymtl.ca>
References: <20070703164046.645090494@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 12:40:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 01/10] Immediate values - Global modules list and module mutex
Content-Disposition: inline; filename=immediate-values-global-modules-list-and-mutex.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  3 Jul 2007 16:45:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove "static" from module_mutex and the modules list so it can be used by
other builtin objects in the kernel. Otherwise, every code depending on the
module list would have to be put in kernel/module.c. Since the immediate values
depends on the module list but can be considered as logically different, it
makes sense to implement them in their own file.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 kernel/module.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2007-07-03 11:48:36.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2007-07-03 11:48:45.000000000 -0400
@@ -65,8 +65,8 @@
 static DEFINE_SPINLOCK(modlist_lock);
 
 /* List of modules, protected by module_mutex AND modlist_lock */
-static DEFINE_MUTEX(module_mutex);
-static LIST_HEAD(modules);
+DEFINE_MUTEX(module_mutex);
+LIST_HEAD(modules);
 static DECLARE_MUTEX(notify_mutex);
 
 static BLOCKING_NOTIFIER_HEAD(module_notify_list);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
