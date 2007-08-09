Return-Path: <linux-kernel-owner+w=401wt.eu-S964921AbXHIEoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964921AbXHIEoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 00:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755352AbXHIEmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 00:42:37 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:39061 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbXHIEme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 00:42:34 -0400
Message-Id: <20070809044125.459178259@goodmis.org>
References: <20070809043626.830486783@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 09 Aug 2007 00:36:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>,
       Andi Kleen <ak@suse.de>
Subject: [PATCH 4/5 -v2] Added generic lg.h in the include/linux directory
Content-Disposition: inline; filename=0004-Added-generic-lg.h-in-the-include-linux-directory.txt
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a generic lg.h that can be included from lguest files.
This file will hold the data that can be shared across archs.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/i386/kernel/asm-offsets.c        |    2 +-
 drivers/lguest/core.c                 |    2 +-
 drivers/lguest/hypercalls.c           |    2 +-
 drivers/lguest/interrupts_and_traps.c |    2 +-
 drivers/lguest/io.c                   |    2 +-
 drivers/lguest/lguest_user.c          |    2 +-
 drivers/lguest/page_tables.c          |    2 +-
 drivers/lguest/segments.c             |    2 +-
 include/asm-i386/lg.h                 |   24 ++----------------------
 include/linux/lg.h                    |   30 ++++++++++++++++++++++++++++++
 10 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/arch/i386/kernel/asm-offsets.c b/arch/i386/kernel/asm-offsets.c
index e426e51..d6d17e5 100644
--- a/arch/i386/kernel/asm-offsets.c
+++ b/arch/i386/kernel/asm-offsets.c
@@ -21,7 +21,7 @@
 
 #ifdef CONFIG_LGUEST_GUEST
 #include <linux/lguest.h>
-#include <asm/lg.h>
+#include <linux/lg.h>
 #endif
 
 #define DEFINE(sym, val) \
diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
index e5f441d..5bcd237 100644
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -19,7 +19,7 @@
 #include <asm/highmem.h>
 #include <asm/asm-offsets.h>
 #include <asm/i387.h>
-#include <asm/lg.h>
+#include <linux/lg.h>
 
 /* Found in switcher.S */
 extern char start_switcher_text[], end_switcher_text[], switch_to_guest[];
diff --git a/drivers/lguest/hypercalls.c b/drivers/lguest/hypercalls.c
index 0ddb133..3c0d41e 100644
--- a/drivers/lguest/hypercalls.c
+++ b/drivers/lguest/hypercalls.c
@@ -26,7 +26,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <irq_vectors.h>
-#include <asm/lg.h>
+#include <linux/lg.h>
 
 /*H:120 This is the core hypercall routine: where the Guest gets what it
  * wants.  Or gets killed.  Or, in the case of LHCALL_CRASH, both.
diff --git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
index 899e681..3daf3e2 100644
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -12,7 +12,7 @@
  * them first, so we also have a way of "reflecting" them into the Guest as if
  * they had been delivered to it directly. :*/
 #include <linux/uaccess.h>
-#include <asm/lg.h>
+#include <linux/lg.h>
 
 /* The address of the interrupt handler is split into two bits: */
 static unsigned long idt_address(u32 lo, u32 hi)
diff --git a/drivers/lguest/io.c b/drivers/lguest/io.c
index 091a46d..d196121 100644
--- a/drivers/lguest/io.c
+++ b/drivers/lguest/io.c
@@ -25,7 +25,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/uaccess.h>
-#include <asm/lg.h>
+#include <linux/lg.h>
 
 /*L:300
  * I/O
diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index a29d85b..2f477df 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -7,7 +7,7 @@
 #include <linux/uaccess.h>
 #include <linux/miscdevice.h>
 #include <linux/fs.h>
-#include <asm/lg.h>
+#include <linux/lg.h>
 
 /*L:030 setup_regs() doesn't really belong in this file, but it gives us an
  * early glimpse deeper into the Host so it's worth having here.
diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
index db3dd8b..812d56a 100644
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -13,7 +13,7 @@
 #include <linux/random.h>
 #include <linux/percpu.h>
 #include <asm/tlbflush.h>
-#include <asm/lg.h>
+#include <linux/lg.h>
 
 /*M:008 We hold reference to pages, which prevents them from being swapped.
  * It'd be nice to have a callback in the "struct mm_struct" when Linux wants
diff --git a/drivers/lguest/segments.c b/drivers/lguest/segments.c
index 1d16d5d..351b13f 100644
--- a/drivers/lguest/segments.c
+++ b/drivers/lguest/segments.c
@@ -9,7 +9,7 @@
  * In these modern times, the segment handling code consists of simple sanity
  * checks, and the worst you'll experience reading this code is butterfly-rash
  * from frolicking through its parklike serenity. :*/
-#include <asm/lg.h>
+#include <linux/lg.h>
 
 /*H:600
  * We've almost completed the Host; there's just one file to go!
diff --git a/include/asm-i386/lg.h b/include/asm-i386/lg.h
index 64f0abe..c8e01c3 100644
--- a/include/asm-i386/lg.h
+++ b/include/asm-i386/lg.h
@@ -1,5 +1,5 @@
-#ifndef _LGUEST_H
-#define _LGUEST_H
+#ifndef _I386_LGUEST_H
+#define _I386_LGUEST_H
 
 #include <asm/desc.h>
 
@@ -47,17 +47,6 @@ int init_pagetables(struct page **switcher_page, unsigned int pages);
 #define FULL_EXEC_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9b00})
 #define FULL_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9300})
 
-struct lguest_dma_info
-{
-	struct list_head list;
-	union futex_key key;
-	unsigned long dmas;
-	u16 next_dma;
-	u16 num_dmas;
-	u16 guestid;
-	u8 interrupt; 	/* 0 when not registered */
-};
-
 /*H:310 The page-table code owes a great debt of gratitude to Andi Kleen.  He
  * reviewed the original code which used "u32" for all page table entries, and
  * insisted that it would be far clearer with explicit typing.  I thought it
@@ -245,15 +234,6 @@ void pin_page(struct lguest *lg, unsigned long vaddr);
 int lguest_device_init(void);
 void lguest_device_remove(void);
 
-/* io.c: */
-void lguest_io_init(void);
-int bind_dma(struct lguest *lg,
-	     unsigned long key, unsigned long udma, u16 numdmas, u8 interrupt);
-void send_dma(struct lguest *info, unsigned long key, unsigned long udma);
-void release_all_dma(struct lguest *lg);
-unsigned long get_dma_buffer(struct lguest *lg, unsigned long key,
-			     unsigned long *interrupt);
-
 /* hypercalls.c: */
 void do_hypercalls(struct lguest *lg);
 void write_timestamp(struct lguest *lg);
diff --git a/include/linux/lg.h b/include/linux/lg.h
new file mode 100644
index 0000000..c533102
--- /dev/null
+++ b/include/linux/lg.h
@@ -0,0 +1,30 @@
+#ifndef _LINUX_LGUEST_H
+#define _LINUX_LGUEST_H
+
+#include <linux/futex.h>
+
+struct lguest;
+
+/* io.c: */
+void lguest_io_init(void);
+int bind_dma(struct lguest *lg,
+	     unsigned long key, unsigned long udma, u16 numdmas, u8 interrupt);
+void send_dma(struct lguest *info, unsigned long key, unsigned long udma);
+void release_all_dma(struct lguest *lg);
+unsigned long get_dma_buffer(struct lguest *lg, unsigned long key,
+			     unsigned long *interrupt);
+
+struct lguest_dma_info
+{
+	struct list_head list;
+	union futex_key key;
+	unsigned long dmas;
+	u16 next_dma;
+	u16 num_dmas;
+	u16 guestid;
+	u8 interrupt; 	/* 0 when not registered */
+};
+
+#include <asm/lg.h>
+
+#endif /* _LINUX_LGUEST_H */
-- 
1.4.4.4

-- 
