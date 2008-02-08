Return-Path: <linux-kernel-owner+w=401wt.eu-S934523AbYBHUAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934523AbYBHUAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758173AbYBHUAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:00:31 -0500
Received: from mail.gmx.net ([213.165.64.20]:49027 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751847AbYBHUA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:00:29 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/fU1wAttrf9y5YjqdOJ64qMraQp8EWShW18vgTCx
	mlg0cDBi5FWI0P
Date: Fri, 8 Feb 2008 21:00:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] lib/scatterlist.o needed by a module only - link it in
 unconditionally
Message-ID: <Pine.LNX.4.64.0802081930590.8364@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lib/scatterlist.c is needed by drivers/media/video/videobuf-dma-sg.c, and 
we would like to be able to use the latter without PCI too, for example, 
on PXA270 ARM CPU. It is then possible to create a configuration with 
CONFIG_BLOCK=n, where only module code will need scatterlist.c. Therefore 
it must be in obj-y.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

diff --git a/lib/Makefile b/lib/Makefile
index 543f250..7475da4 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -6,7 +6,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
-	 proportions.o prio_heap.o scatterlist.o
+	 proportions.o prio_heap.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
@@ -14,7 +14,7 @@ lib-$(CONFIG_SMP) += cpumask.o
 lib-y	+= kobject.o kref.o klist.o
 
 obj-y += div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
-	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o
+	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
