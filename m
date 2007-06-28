Return-Path: <linux-kernel-owner+w=401wt.eu-S1760741AbXF1Nha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741AbXF1Nha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 09:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbXF1NhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 09:37:19 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:16451 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072AbXF1NhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 09:37:18 -0400
Date: Thu, 28 Jun 2007 15:37:15 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch -mm] Make check_signature() depend on CONFIG_HAS_IOMEM
Message-ID: <20070628133715.GA4343@osiris.boeblingen.de.ibm.com>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

check_signature() uses readb() and therefore should only be build on
CONFIG_HAS_IOMEM.

Otherwise breaks s390:
lib/check_signature.c: In function `check_signature':
lib/check_signature.c:19: error: implicit declaration of function `readb'

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 lib/Makefile |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc6-mm1/lib/Makefile
===================================================================
--- linux-2.6.22-rc6-mm1.orig/lib/Makefile
+++ linux-2.6.22-rc6-mm1/lib/Makefile
@@ -5,8 +5,7 @@
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o bitmap.o extable.o prio_tree.o \
-	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
-	 check_signature.o
+	 sha1.o irq_regs.o reciprocal_div.o argv_split.o
 
 lib-$(CONFIG_MMU) += ioremap.o pagewalk.o
 lib-$(CONFIG_SMP) += cpumask.o
@@ -22,7 +21,7 @@ CFLAGS_kobject_uevent.o += -DDEBUG
 endif
 
 obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
-obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
+obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o check_signature.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
