Return-Path: <linux-kernel-owner+w=401wt.eu-S1762177AbYDKQXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762177AbYDKQXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760950AbYDKQUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:20:46 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34419 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760936AbYDKQUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:20:45 -0400
Message-Id: <20080411162002.509849000@bull.net>
References: <20080411161702.460410000@bull.net>
User-Agent: quilt/0.45-1
Date: Fri, 11 Apr 2008 18:17:13 +0200
From: Nadia.Derbey@bull.net
To: efault@gmx.de
Cc: manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       peterz@infradead.org, xemul@openvz.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 11/13] Integrate the ridr code
Content-Disposition: inline; filename=ridr_integrate.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 11/13]

>From now on the ridr code can be compiled and used (the initialization routine
is called during kernel init).

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 init/main.c  |    2 ++
 lib/Makefile |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.25-rc8-mm1/lib/Makefile
===================================================================
--- linux-2.6.25-rc8-mm1.orig/lib/Makefile	2008-04-11 17:14:08.000000000 +0200
+++ linux-2.6.25-rc8-mm1/lib/Makefile	2008-04-11 18:10:26.000000000 +0200
@@ -6,7 +6,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
-	 proportions.o prio_heap.o ratelimit.o
+	 proportions.o prio_heap.o ratelimit.o ridr.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
Index: linux-2.6.25-rc8-mm1/init/main.c
===================================================================
--- linux-2.6.25-rc8-mm1.orig/init/main.c	2008-04-11 17:14:32.000000000 +0200
+++ linux-2.6.25-rc8-mm1/init/main.c	2008-04-11 18:11:01.000000000 +0200
@@ -60,6 +60,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/idr.h>
+#include <linux/ridr.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -636,6 +637,7 @@ asmlinkage void __init start_kernel(void
 	security_init();
 	vfs_caches_init(num_physpages);
 	radix_tree_init();
+	ridr_init_cache();
 	signals_init();
 	/* rootfs populating might need page-writeback */
 	page_writeback_init();

--
