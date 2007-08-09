Return-Path: <linux-kernel-owner+w=401wt.eu-S938435AbXHIEo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938435AbXHIEo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 00:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757586AbXHIEmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 00:42:38 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:45518 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbXHIEmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 00:42:36 -0400
Message-Id: <20070809044124.947806009@goodmis.org>
References: <20070809043626.830486783@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 09 Aug 2007 00:36:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>,
       Andi Kleen <ak@suse.de>
Subject: [PATCH 1/5 -v2] move lg.h to include/asm-<arch>
Content-Disposition: inline; filename=0001-move-lg.h-to-include-asm-arch.txt
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The lg.h file has lots of i386 specific information. Move it over to the asm
directory where it belongs.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/i386/kernel/asm-offsets.c        |    2 +-
 drivers/lguest/core.c                 |    2 +-
 drivers/lguest/hypercalls.c           |    2 +-
 drivers/lguest/interrupts_and_traps.c |    2 +-
 drivers/lguest/io.c                   |    2 +-
 drivers/lguest/lg.h                   |  300 ---------------------------------
 drivers/lguest/lguest_user.c          |    2 +-
 drivers/lguest/page_tables.c          |    2 +-
 drivers/lguest/segments.c             |    2 +-
 drivers/lguest/switcher.S             |    2 +-
 include/asm-i386/lg.h                 |  300 +++++++++++++++++++++++++++++++++
 11 files changed, 309 insertions(+), 309 deletions(-)

diff --git a/arch/i386/kernel/asm-offsets.c b/arch/i386/kernel/asm-offsets.c
index 7288ac8..e426e51 100644
--- a/arch/i386/kernel/asm-offsets.c
+++ b/arch/i386/kernel/asm-offsets.c
@@ -21,7 +21,7 @@
 
 #ifdef CONFIG_LGUEST_GUEST
 #include <linux/lguest.h>
-#include "../../../drivers/lguest/lg.h"
+#include <asm/lg.h>
 #endif
 
 #define DEFINE(sym, val) \
diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
index 0a46e88..e5f441d 100644
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -19,7 +19,7 @@
 #include <asm/highmem.h>
 #include <asm/asm-offsets.h>
 #include <asm/i387.h>
-#include "lg.h"
+#include <asm/lg.h>
 
 /* Found in switcher.S */
 extern char start_switcher_text[], end_switcher_text[], switch_to_guest[];
diff --git a/drivers/lguest/hypercalls.c b/drivers/lguest/hypercalls.c
index db6caac..0ddb133 100644
--- a/drivers/lguest/hypercalls.c
+++ b/drivers/lguest/hypercalls.c
@@ -26,7 +26,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <irq_vectors.h>
-#include "lg.h"
+#include <asm/lg.h>
 
 /*H:120 This is the core hypercall routine: where the Guest gets what it
  * wants.  Or gets killed.  Or, in the case of LHCALL_CRASH, both.
diff --git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
index 49787e9..899e681 100644
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -12,7 +12,7 @@
  * them first, so we also have a way of "reflecting" them into the Guest as if
  * they had been delivered to it directly. :*/
 #include <linux/uaccess.h>
-#include "lg.h"
+#include <asm/lg.h>
 
 /* The address of the interrupt handler is split into two bits: */
 static unsigned long idt_address(u32 lo, u32 hi)
diff --git a/drivers/lguest/io.c b/drivers/lguest/io.c
index ea68613..091a46d 100644
--- a/drivers/lguest/io.c
+++ b/drivers/lguest/io.c
@@ -25,7 +25,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/uaccess.h>
-#include "lg.h"
+#include <asm/lg.h>
 
 /*L:300
  * I/O
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
deleted file mode 100644
index 64f0abe..0000000
--- a/drivers/lguest/lg.h
+++ /dev/null
@@ -1,300 +0,0 @@
-#ifndef _LGUEST_H
-#define _LGUEST_H
-
-#include <asm/desc.h>
-
-#define GDT_ENTRY_LGUEST_CS	10
-#define GDT_ENTRY_LGUEST_DS	11
-#define LGUEST_CS		(GDT_ENTRY_LGUEST_CS * 8)
-#define LGUEST_DS		(GDT_ENTRY_LGUEST_DS * 8)
-
-#ifndef __ASSEMBLY__
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/stringify.h>
-#include <linux/binfmts.h>
-#include <linux/futex.h>
-#include <linux/lguest.h>
-#include <linux/lguest_launcher.h>
-#include <linux/wait.h>
-#include <linux/err.h>
-#include <asm/semaphore.h>
-#include "irq_vectors.h"
-
-#define GUEST_PL 1
-
-struct lguest_regs
-{
-	/* Manually saved part. */
-	unsigned long ebx, ecx, edx;
-	unsigned long esi, edi, ebp;
-	unsigned long gs;
-	unsigned long eax;
-	unsigned long fs, ds, es;
-	unsigned long trapnum, errcode;
-	/* Trap pushed part */
-	unsigned long eip;
-	unsigned long cs;
-	unsigned long eflags;
-	unsigned long esp;
-	unsigned long ss;
-};
-
-void free_pagetables(void);
-int init_pagetables(struct page **switcher_page, unsigned int pages);
-
-/* Full 4G segment descriptors, suitable for CS and DS. */
-#define FULL_EXEC_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9b00})
-#define FULL_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9300})
-
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
-/*H:310 The page-table code owes a great debt of gratitude to Andi Kleen.  He
- * reviewed the original code which used "u32" for all page table entries, and
- * insisted that it would be far clearer with explicit typing.  I thought it
- * was overkill, but he was right: it is much clearer than it was before.
- *
- * We have separate types for the Guest's ptes & pgds and the shadow ptes &
- * pgds.  There's already a Linux type for these (pte_t and pgd_t) but they
- * change depending on kernel config options (PAE). */
-
-/* Each entry is identical: lower 12 bits of flags and upper 20 bits for the
- * "page frame number" (0 == first physical page, etc).  They are different
- * types so the compiler will warn us if we mix them improperly. */
-typedef union {
-	struct { unsigned flags:12, pfn:20; };
-	struct { unsigned long val; } raw;
-} spgd_t;
-typedef union {
-	struct { unsigned flags:12, pfn:20; };
-	struct { unsigned long val; } raw;
-} spte_t;
-typedef union {
-	struct { unsigned flags:12, pfn:20; };
-	struct { unsigned long val; } raw;
-} gpgd_t;
-typedef union {
-	struct { unsigned flags:12, pfn:20; };
-	struct { unsigned long val; } raw;
-} gpte_t;
-
-/* We have two convenient macros to convert a "raw" value as handed to us by
- * the Guest into the correct Guest PGD or PTE type. */
-#define mkgpte(_val) ((gpte_t){.raw.val = _val})
-#define mkgpgd(_val) ((gpgd_t){.raw.val = _val})
-/*:*/
-
-struct pgdir
-{
-	unsigned long cr3;
-	spgd_t *pgdir;
-};
-
-/* This is a guest-specific page (mapped ro) into the guest. */
-struct lguest_ro_state
-{
-	/* Host information we need to restore when we switch back. */
-	u32 host_cr3;
-	struct Xgt_desc_struct host_idt_desc;
-	struct Xgt_desc_struct host_gdt_desc;
-	u32 host_sp;
-
-	/* Fields which are used when guest is running. */
-	struct Xgt_desc_struct guest_idt_desc;
-	struct Xgt_desc_struct guest_gdt_desc;
-	struct i386_hw_tss guest_tss;
-	struct desc_struct guest_idt[IDT_ENTRIES];
-	struct desc_struct guest_gdt[GDT_ENTRIES];
-};
-
-/* We have two pages shared with guests, per cpu.  */
-struct lguest_pages
-{
-	/* This is the stack page mapped rw in guest */
-	char spare[PAGE_SIZE - sizeof(struct lguest_regs)];
-	struct lguest_regs regs;
-
-	/* This is the host state & guest descriptor page, ro in guest */
-	struct lguest_ro_state state;
-} __attribute__((aligned(PAGE_SIZE)));
-
-#define CHANGED_IDT		1
-#define CHANGED_GDT		2
-#define CHANGED_GDT_TLS		4 /* Actually a subset of CHANGED_GDT */
-#define CHANGED_ALL	        3
-
-/* The private info the thread maintains about the guest. */
-struct lguest
-{
-	/* At end of a page shared mapped over lguest_pages in guest.  */
-	unsigned long regs_page;
-	struct lguest_regs *regs;
-	struct lguest_data __user *lguest_data;
-	struct task_struct *tsk;
-	struct mm_struct *mm; 	/* == tsk->mm, but that becomes NULL on exit */
-	u16 guestid;
-	u32 pfn_limit;
-	u32 page_offset;
-	u32 cr2;
-	int halted;
-	int ts;
-	u32 next_hcall;
-	u32 esp1;
-	u8 ss1;
-
-	/* Do we need to stop what we're doing and return to userspace? */
-	int break_out;
-	wait_queue_head_t break_wq;
-
-	/* Bitmap of what has changed: see CHANGED_* above. */
-	int changed;
-	struct lguest_pages *last_pages;
-
-	/* We keep a small number of these. */
-	u32 pgdidx;
-	struct pgdir pgdirs[4];
-
-	/* Cached wakeup: we hold a reference to this task. */
-	struct task_struct *wake;
-
-	unsigned long noirq_start, noirq_end;
-	int dma_is_pending;
-	unsigned long pending_dma; /* struct lguest_dma */
-	unsigned long pending_key; /* address they're sending to */
-
-	unsigned int stack_pages;
-	u32 tsc_khz;
-
-	struct lguest_dma_info dma[LGUEST_MAX_DMA];
-
-	/* Dead? */
-	const char *dead;
-
-	/* The GDT entries copied into lguest_ro_state when running. */
-	struct desc_struct gdt[GDT_ENTRIES];
-
-	/* The IDT entries: some copied into lguest_ro_state when running. */
-	struct desc_struct idt[FIRST_EXTERNAL_VECTOR+LGUEST_IRQS];
-	struct desc_struct syscall_idt;
-
-	/* Virtual clock device */
-	struct hrtimer hrt;
-
-	/* Pending virtual interrupts */
-	DECLARE_BITMAP(irqs_pending, LGUEST_IRQS);
-};
-
-extern struct lguest lguests[];
-extern struct mutex lguest_lock;
-
-/* core.c: */
-u32 lgread_u32(struct lguest *lg, unsigned long addr);
-void lgwrite_u32(struct lguest *lg, unsigned long addr, u32 val);
-void lgread(struct lguest *lg, void *buf, unsigned long addr, unsigned len);
-void lgwrite(struct lguest *lg, unsigned long, const void *buf, unsigned len);
-int find_free_guest(void);
-int lguest_address_ok(const struct lguest *lg,
-		      unsigned long addr, unsigned long len);
-int run_guest(struct lguest *lg, unsigned long __user *user);
-
-
-/* interrupts_and_traps.c: */
-void maybe_do_interrupt(struct lguest *lg);
-int deliver_trap(struct lguest *lg, unsigned int num);
-void load_guest_idt_entry(struct lguest *lg, unsigned int i, u32 low, u32 hi);
-void guest_set_stack(struct lguest *lg, u32 seg, u32 esp, unsigned int pages);
-void pin_stack_pages(struct lguest *lg);
-void setup_default_idt_entries(struct lguest_ro_state *state,
-			       const unsigned long *def);
-void copy_traps(const struct lguest *lg, struct desc_struct *idt,
-		const unsigned long *def);
-void guest_set_clockevent(struct lguest *lg, unsigned long delta);
-void init_clockdev(struct lguest *lg);
-
-/* segments.c: */
-void setup_default_gdt_entries(struct lguest_ro_state *state);
-void setup_guest_gdt(struct lguest *lg);
-void load_guest_gdt(struct lguest *lg, unsigned long table, u32 num);
-void guest_load_tls(struct lguest *lg, unsigned long tls_array);
-void copy_gdt(const struct lguest *lg, struct desc_struct *gdt);
-void copy_gdt_tls(const struct lguest *lg, struct desc_struct *gdt);
-
-/* page_tables.c: */
-int init_guest_pagetable(struct lguest *lg, unsigned long pgtable);
-void free_guest_pagetable(struct lguest *lg);
-void guest_new_pagetable(struct lguest *lg, unsigned long pgtable);
-void guest_set_pmd(struct lguest *lg, unsigned long cr3, u32 i);
-void guest_pagetable_clear_all(struct lguest *lg);
-void guest_pagetable_flush_user(struct lguest *lg);
-void guest_set_pte(struct lguest *lg, unsigned long cr3,
-		   unsigned long vaddr, gpte_t val);
-void map_switcher_in_guest(struct lguest *lg, struct lguest_pages *pages);
-int demand_page(struct lguest *info, unsigned long cr2, int errcode);
-void pin_page(struct lguest *lg, unsigned long vaddr);
-
-/* lguest_user.c: */
-int lguest_device_init(void);
-void lguest_device_remove(void);
-
-/* io.c: */
-void lguest_io_init(void);
-int bind_dma(struct lguest *lg,
-	     unsigned long key, unsigned long udma, u16 numdmas, u8 interrupt);
-void send_dma(struct lguest *info, unsigned long key, unsigned long udma);
-void release_all_dma(struct lguest *lg);
-unsigned long get_dma_buffer(struct lguest *lg, unsigned long key,
-			     unsigned long *interrupt);
-
-/* hypercalls.c: */
-void do_hypercalls(struct lguest *lg);
-void write_timestamp(struct lguest *lg);
-
-/*L:035
- * Let's step aside for the moment, to study one important routine that's used
- * widely in the Host code.
- *
- * There are many cases where the Guest does something invalid, like pass crap
- * to a hypercall.  Since only the Guest kernel can make hypercalls, it's quite
- * acceptable to simply terminate the Guest and give the Launcher a nicely
- * formatted reason.  It's also simpler for the Guest itself, which doesn't
- * need to check most hypercalls for "success"; if you're still running, it
- * succeeded.
- *
- * Once this is called, the Guest will never run again, so most Host code can
- * call this then continue as if nothing had happened.  This means many
- * functions don't have to explicitly return an error code, which keeps the
- * code simple.
- *
- * It also means that this can be called more than once: only the first one is
- * remembered.  The only trick is that we still need to kill the Guest even if
- * we can't allocate memory to store the reason.  Linux has a neat way of
- * packing error codes into invalid pointers, so we use that here.
- *
- * Like any macro which uses an "if", it is safely wrapped in a run-once "do {
- * } while(0)".
- */
-#define kill_guest(lg, fmt...)					\
-do {								\
-	if (!(lg)->dead) {					\
-		(lg)->dead = kasprintf(GFP_ATOMIC, fmt);	\
-		if (!(lg)->dead)				\
-			(lg)->dead = ERR_PTR(-ENOMEM);		\
-	}							\
-} while(0)
-/* (End of aside) :*/
-
-static inline unsigned long guest_pa(struct lguest *lg, unsigned long vaddr)
-{
-	return vaddr - lg->page_offset;
-}
-#endif	/* __ASSEMBLY__ */
-#endif	/* _LGUEST_H */
diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index 80d1b58..a29d85b 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -7,7 +7,7 @@
 #include <linux/uaccess.h>
 #include <linux/miscdevice.h>
 #include <linux/fs.h>
-#include "lg.h"
+#include <asm/lg.h>
 
 /*L:030 setup_regs() doesn't really belong in this file, but it gives us an
  * early glimpse deeper into the Host so it's worth having here.
diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
index b7a924a..db3dd8b 100644
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -13,7 +13,7 @@
 #include <linux/random.h>
 #include <linux/percpu.h>
 #include <asm/tlbflush.h>
-#include "lg.h"
+#include <asm/lg.h>
 
 /*M:008 We hold reference to pages, which prevents them from being swapped.
  * It'd be nice to have a callback in the "struct mm_struct" when Linux wants
diff --git a/drivers/lguest/segments.c b/drivers/lguest/segments.c
index f675a41..1d16d5d 100644
--- a/drivers/lguest/segments.c
+++ b/drivers/lguest/segments.c
@@ -9,7 +9,7 @@
  * In these modern times, the segment handling code consists of simple sanity
  * checks, and the worst you'll experience reading this code is butterfly-rash
  * from frolicking through its parklike serenity. :*/
-#include "lg.h"
+#include <asm/lg.h>
 
 /*H:600
  * We've almost completed the Host; there's just one file to go!
diff --git a/drivers/lguest/switcher.S b/drivers/lguest/switcher.S
index d418179..40382f6 100644
--- a/drivers/lguest/switcher.S
+++ b/drivers/lguest/switcher.S
@@ -47,7 +47,7 @@
 // Down here in the depths of assembler code.
 #include <linux/linkage.h>
 #include <asm/asm-offsets.h>
-#include "lg.h"
+#include <asm/lg.h>
 
 // We mark the start of the code to copy
 // It's placed in .text tho it's never run here
diff --git a/include/asm-i386/lg.h b/include/asm-i386/lg.h
new file mode 100644
index 0000000..64f0abe
--- /dev/null
+++ b/include/asm-i386/lg.h
@@ -0,0 +1,300 @@
+#ifndef _LGUEST_H
+#define _LGUEST_H
+
+#include <asm/desc.h>
+
+#define GDT_ENTRY_LGUEST_CS	10
+#define GDT_ENTRY_LGUEST_DS	11
+#define LGUEST_CS		(GDT_ENTRY_LGUEST_CS * 8)
+#define LGUEST_DS		(GDT_ENTRY_LGUEST_DS * 8)
+
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/stringify.h>
+#include <linux/binfmts.h>
+#include <linux/futex.h>
+#include <linux/lguest.h>
+#include <linux/lguest_launcher.h>
+#include <linux/wait.h>
+#include <linux/err.h>
+#include <asm/semaphore.h>
+#include "irq_vectors.h"
+
+#define GUEST_PL 1
+
+struct lguest_regs
+{
+	/* Manually saved part. */
+	unsigned long ebx, ecx, edx;
+	unsigned long esi, edi, ebp;
+	unsigned long gs;
+	unsigned long eax;
+	unsigned long fs, ds, es;
+	unsigned long trapnum, errcode;
+	/* Trap pushed part */
+	unsigned long eip;
+	unsigned long cs;
+	unsigned long eflags;
+	unsigned long esp;
+	unsigned long ss;
+};
+
+void free_pagetables(void);
+int init_pagetables(struct page **switcher_page, unsigned int pages);
+
+/* Full 4G segment descriptors, suitable for CS and DS. */
+#define FULL_EXEC_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9b00})
+#define FULL_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9300})
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
+/*H:310 The page-table code owes a great debt of gratitude to Andi Kleen.  He
+ * reviewed the original code which used "u32" for all page table entries, and
+ * insisted that it would be far clearer with explicit typing.  I thought it
+ * was overkill, but he was right: it is much clearer than it was before.
+ *
+ * We have separate types for the Guest's ptes & pgds and the shadow ptes &
+ * pgds.  There's already a Linux type for these (pte_t and pgd_t) but they
+ * change depending on kernel config options (PAE). */
+
+/* Each entry is identical: lower 12 bits of flags and upper 20 bits for the
+ * "page frame number" (0 == first physical page, etc).  They are different
+ * types so the compiler will warn us if we mix them improperly. */
+typedef union {
+	struct { unsigned flags:12, pfn:20; };
+	struct { unsigned long val; } raw;
+} spgd_t;
+typedef union {
+	struct { unsigned flags:12, pfn:20; };
+	struct { unsigned long val; } raw;
+} spte_t;
+typedef union {
+	struct { unsigned flags:12, pfn:20; };
+	struct { unsigned long val; } raw;
+} gpgd_t;
+typedef union {
+	struct { unsigned flags:12, pfn:20; };
+	struct { unsigned long val; } raw;
+} gpte_t;
+
+/* We have two convenient macros to convert a "raw" value as handed to us by
+ * the Guest into the correct Guest PGD or PTE type. */
+#define mkgpte(_val) ((gpte_t){.raw.val = _val})
+#define mkgpgd(_val) ((gpgd_t){.raw.val = _val})
+/*:*/
+
+struct pgdir
+{
+	unsigned long cr3;
+	spgd_t *pgdir;
+};
+
+/* This is a guest-specific page (mapped ro) into the guest. */
+struct lguest_ro_state
+{
+	/* Host information we need to restore when we switch back. */
+	u32 host_cr3;
+	struct Xgt_desc_struct host_idt_desc;
+	struct Xgt_desc_struct host_gdt_desc;
+	u32 host_sp;
+
+	/* Fields which are used when guest is running. */
+	struct Xgt_desc_struct guest_idt_desc;
+	struct Xgt_desc_struct guest_gdt_desc;
+	struct i386_hw_tss guest_tss;
+	struct desc_struct guest_idt[IDT_ENTRIES];
+	struct desc_struct guest_gdt[GDT_ENTRIES];
+};
+
+/* We have two pages shared with guests, per cpu.  */
+struct lguest_pages
+{
+	/* This is the stack page mapped rw in guest */
+	char spare[PAGE_SIZE - sizeof(struct lguest_regs)];
+	struct lguest_regs regs;
+
+	/* This is the host state & guest descriptor page, ro in guest */
+	struct lguest_ro_state state;
+} __attribute__((aligned(PAGE_SIZE)));
+
+#define CHANGED_IDT		1
+#define CHANGED_GDT		2
+#define CHANGED_GDT_TLS		4 /* Actually a subset of CHANGED_GDT */
+#define CHANGED_ALL	        3
+
+/* The private info the thread maintains about the guest. */
+struct lguest
+{
+	/* At end of a page shared mapped over lguest_pages in guest.  */
+	unsigned long regs_page;
+	struct lguest_regs *regs;
+	struct lguest_data __user *lguest_data;
+	struct task_struct *tsk;
+	struct mm_struct *mm; 	/* == tsk->mm, but that becomes NULL on exit */
+	u16 guestid;
+	u32 pfn_limit;
+	u32 page_offset;
+	u32 cr2;
+	int halted;
+	int ts;
+	u32 next_hcall;
+	u32 esp1;
+	u8 ss1;
+
+	/* Do we need to stop what we're doing and return to userspace? */
+	int break_out;
+	wait_queue_head_t break_wq;
+
+	/* Bitmap of what has changed: see CHANGED_* above. */
+	int changed;
+	struct lguest_pages *last_pages;
+
+	/* We keep a small number of these. */
+	u32 pgdidx;
+	struct pgdir pgdirs[4];
+
+	/* Cached wakeup: we hold a reference to this task. */
+	struct task_struct *wake;
+
+	unsigned long noirq_start, noirq_end;
+	int dma_is_pending;
+	unsigned long pending_dma; /* struct lguest_dma */
+	unsigned long pending_key; /* address they're sending to */
+
+	unsigned int stack_pages;
+	u32 tsc_khz;
+
+	struct lguest_dma_info dma[LGUEST_MAX_DMA];
+
+	/* Dead? */
+	const char *dead;
+
+	/* The GDT entries copied into lguest_ro_state when running. */
+	struct desc_struct gdt[GDT_ENTRIES];
+
+	/* The IDT entries: some copied into lguest_ro_state when running. */
+	struct desc_struct idt[FIRST_EXTERNAL_VECTOR+LGUEST_IRQS];
+	struct desc_struct syscall_idt;
+
+	/* Virtual clock device */
+	struct hrtimer hrt;
+
+	/* Pending virtual interrupts */
+	DECLARE_BITMAP(irqs_pending, LGUEST_IRQS);
+};
+
+extern struct lguest lguests[];
+extern struct mutex lguest_lock;
+
+/* core.c: */
+u32 lgread_u32(struct lguest *lg, unsigned long addr);
+void lgwrite_u32(struct lguest *lg, unsigned long addr, u32 val);
+void lgread(struct lguest *lg, void *buf, unsigned long addr, unsigned len);
+void lgwrite(struct lguest *lg, unsigned long, const void *buf, unsigned len);
+int find_free_guest(void);
+int lguest_address_ok(const struct lguest *lg,
+		      unsigned long addr, unsigned long len);
+int run_guest(struct lguest *lg, unsigned long __user *user);
+
+
+/* interrupts_and_traps.c: */
+void maybe_do_interrupt(struct lguest *lg);
+int deliver_trap(struct lguest *lg, unsigned int num);
+void load_guest_idt_entry(struct lguest *lg, unsigned int i, u32 low, u32 hi);
+void guest_set_stack(struct lguest *lg, u32 seg, u32 esp, unsigned int pages);
+void pin_stack_pages(struct lguest *lg);
+void setup_default_idt_entries(struct lguest_ro_state *state,
+			       const unsigned long *def);
+void copy_traps(const struct lguest *lg, struct desc_struct *idt,
+		const unsigned long *def);
+void guest_set_clockevent(struct lguest *lg, unsigned long delta);
+void init_clockdev(struct lguest *lg);
+
+/* segments.c: */
+void setup_default_gdt_entries(struct lguest_ro_state *state);
+void setup_guest_gdt(struct lguest *lg);
+void load_guest_gdt(struct lguest *lg, unsigned long table, u32 num);
+void guest_load_tls(struct lguest *lg, unsigned long tls_array);
+void copy_gdt(const struct lguest *lg, struct desc_struct *gdt);
+void copy_gdt_tls(const struct lguest *lg, struct desc_struct *gdt);
+
+/* page_tables.c: */
+int init_guest_pagetable(struct lguest *lg, unsigned long pgtable);
+void free_guest_pagetable(struct lguest *lg);
+void guest_new_pagetable(struct lguest *lg, unsigned long pgtable);
+void guest_set_pmd(struct lguest *lg, unsigned long cr3, u32 i);
+void guest_pagetable_clear_all(struct lguest *lg);
+void guest_pagetable_flush_user(struct lguest *lg);
+void guest_set_pte(struct lguest *lg, unsigned long cr3,
+		   unsigned long vaddr, gpte_t val);
+void map_switcher_in_guest(struct lguest *lg, struct lguest_pages *pages);
+int demand_page(struct lguest *info, unsigned long cr2, int errcode);
+void pin_page(struct lguest *lg, unsigned long vaddr);
+
+/* lguest_user.c: */
+int lguest_device_init(void);
+void lguest_device_remove(void);
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
+/* hypercalls.c: */
+void do_hypercalls(struct lguest *lg);
+void write_timestamp(struct lguest *lg);
+
+/*L:035
+ * Let's step aside for the moment, to study one important routine that's used
+ * widely in the Host code.
+ *
+ * There are many cases where the Guest does something invalid, like pass crap
+ * to a hypercall.  Since only the Guest kernel can make hypercalls, it's quite
+ * acceptable to simply terminate the Guest and give the Launcher a nicely
+ * formatted reason.  It's also simpler for the Guest itself, which doesn't
+ * need to check most hypercalls for "success"; if you're still running, it
+ * succeeded.
+ *
+ * Once this is called, the Guest will never run again, so most Host code can
+ * call this then continue as if nothing had happened.  This means many
+ * functions don't have to explicitly return an error code, which keeps the
+ * code simple.
+ *
+ * It also means that this can be called more than once: only the first one is
+ * remembered.  The only trick is that we still need to kill the Guest even if
+ * we can't allocate memory to store the reason.  Linux has a neat way of
+ * packing error codes into invalid pointers, so we use that here.
+ *
+ * Like any macro which uses an "if", it is safely wrapped in a run-once "do {
+ * } while(0)".
+ */
+#define kill_guest(lg, fmt...)					\
+do {								\
+	if (!(lg)->dead) {					\
+		(lg)->dead = kasprintf(GFP_ATOMIC, fmt);	\
+		if (!(lg)->dead)				\
+			(lg)->dead = ERR_PTR(-ENOMEM);		\
+	}							\
+} while(0)
+/* (End of aside) :*/
+
+static inline unsigned long guest_pa(struct lguest *lg, unsigned long vaddr)
+{
+	return vaddr - lg->page_offset;
+}
+#endif	/* __ASSEMBLY__ */
+#endif	/* _LGUEST_H */
-- 
1.4.4.4

-- 
