Return-Path: <linux-kernel-owner+w=401wt.eu-S1759913AbYBKSjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913AbYBKSjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYBKSit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:38:49 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:26438 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYBKSir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:38:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=u6S2UyCixqn3oS/8RwadfSOxLJE5jCNEDWoJzNp64ShlHAgImSOkcFL2vJEhkEw+AVOtccm9hyj9IHcGV/BCoLkKAW0RVuiXtUA3QdSFuW+q6vYHJEuNpAO9d5RJZ/DGZGxjvJPw2IdxtDRjKnt7Q+vslZgP9GGbOUDrV2JeiDY=
Subject: [PATCH 3/3] Final removal of FASTCALL()/fastcall
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 10:38:42 -0800
Message-Id: <1202755123.6313.16.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All users are gone, remove definitions and comments referring
to them.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/char/drm/i830_dma.c   |    2 +-
 include/asm-mn10300/highmem.h |    4 ++--
 include/asm-mn10300/linkage.h |    2 --
 include/linux/irq.h           |    1 -
 include/linux/linkage.h       |    5 -----
 kernel/rcupdate.c             |    2 +-
 6 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/char/drm/i830_dma.c b/drivers/char/drm/i830_dma.c
index 379cbda..9df0810 100644
--- a/drivers/char/drm/i830_dma.c
+++ b/drivers/char/drm/i830_dma.c
@@ -36,7 +36,7 @@
 #include "i830_drm.h"
 #include "i830_drv.h"
 #include <linux/interrupt.h>	/* For task queue support */
-#include <linux/pagemap.h>	/* For FASTCALL on unlock_page() */
+#include <linux/pagemap.h>
 #include <linux/delay.h>
 #include <asm/uaccess.h>
 
diff --git a/include/asm-mn10300/highmem.h b/include/asm-mn10300/highmem.h
index 383c0c4..5256854 100644
--- a/include/asm-mn10300/highmem.h
+++ b/include/asm-mn10300/highmem.h
@@ -42,8 +42,8 @@ extern void __init kmap_init(void);
 #define PKMAP_NR(virt)  ((virt - PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
 
-extern unsigned long __fastcall kmap_high(struct page *page);
-extern void __fastcall kunmap_high(struct page *page);
+extern unsigned long kmap_high(struct page *page);
+extern void kunmap_high(struct page *page);
 
 static inline unsigned long kmap(struct page *page)
 {
diff --git a/include/asm-mn10300/linkage.h b/include/asm-mn10300/linkage.h
index 29a32e4..dda3002 100644
--- a/include/asm-mn10300/linkage.h
+++ b/include/asm-mn10300/linkage.h
@@ -13,8 +13,6 @@
 
 /* don't override anything */
 #define asmlinkage
-#define FASTCALL(x) x
-#define fastcall
 
 #define __ALIGN		.align 4,0xcb
 #define __ALIGN_STR	".align 4,0xcb"
diff --git a/include/linux/irq.h b/include/linux/irq.h
index bfd9efb..176e5e7 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -285,7 +285,6 @@ extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
 
 /*
  * Monolithic do_IRQ implementation.
- * (is an explicit fastcall, because i386 4KSTACKS calls it from assembly)
  */
 #ifndef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
 extern unsigned int __do_IRQ(unsigned int irq);
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 3faf599..0592936 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -73,9 +73,4 @@
 #define ATTRIB_NORET  __attribute__((noreturn))
 #define NORET_AND     noreturn,
 
-#ifndef FASTCALL
-#define FASTCALL(x)	x
-#define fastcall
-#endif
-
 #endif
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 760dfc2..0810e78 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -56,7 +56,7 @@ static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);
 static struct completion rcu_barrier_completion;
 
-/* Because of FASTCALL declaration of complete, we use this wrapper */
+/* FASTCALL no longer exists, this wrapper may no longer be needed */
 static void wakeme_after_rcu(struct rcu_head  *head)
 {
 	struct rcu_synchronize *rcu;
-- 
1.5.4.1219.g65b9

