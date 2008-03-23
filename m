Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbYCWIMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbYCWIMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758884AbYCWIIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:05 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2199 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758814AbYCWIIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:01 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 023/148] include/asm-x86/desc.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:58 -0700
Message-Id: <1206259443-13210-24-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/desc.h |   61 ++++++++++++++++++++++++-----------------------
 1 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index 5b6a05d..268a012 100644
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -62,8 +62,8 @@ static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
 }
 
 static inline void pack_gate(gate_desc *gate, unsigned char type,
-       unsigned long base, unsigned dpl, unsigned flags, unsigned short seg)
-
+			     unsigned long base, unsigned dpl, unsigned flags,
+			     unsigned short seg)
 {
 	gate->a = (seg << 16) | (base & 0xffff);
 	gate->b = (base & 0xffff0000) |
@@ -84,22 +84,23 @@ static inline int desc_empty(const void *ptr)
 #define load_TR_desc() native_load_tr_desc()
 #define load_gdt(dtr) native_load_gdt(dtr)
 #define load_idt(dtr) native_load_idt(dtr)
-#define load_tr(tr) __asm__ __volatile("ltr %0"::"m" (tr))
-#define load_ldt(ldt) __asm__ __volatile("lldt %0"::"m" (ldt))
+#define load_tr(tr) asm volatile("ltr %0"::"m" (tr))
+#define load_ldt(ldt) asm volatile("lldt %0"::"m" (ldt))
 
 #define store_gdt(dtr) native_store_gdt(dtr)
 #define store_idt(dtr) native_store_idt(dtr)
 #define store_tr(tr) (tr = native_store_tr())
-#define store_ldt(ldt) __asm__ ("sldt %0":"=m" (ldt))
+#define store_ldt(ldt) asm("sldt %0":"=m" (ldt))
 
 #define load_TLS(t, cpu) native_load_tls(t, cpu)
 #define set_ldt native_set_ldt
 
-#define write_ldt_entry(dt, entry, desc) \
-				native_write_ldt_entry(dt, entry, desc)
-#define write_gdt_entry(dt, entry, desc, type) \
-				native_write_gdt_entry(dt, entry, desc, type)
-#define write_idt_entry(dt, entry, g) native_write_idt_entry(dt, entry, g)
+#define write_ldt_entry(dt, entry, desc)	\
+	native_write_ldt_entry(dt, entry, desc)
+#define write_gdt_entry(dt, entry, desc, type)		\
+	native_write_gdt_entry(dt, entry, desc, type)
+#define write_idt_entry(dt, entry, g)		\
+	native_write_idt_entry(dt, entry, g)
 #endif
 
 static inline void native_write_idt_entry(gate_desc *idt, int entry,
@@ -138,8 +139,8 @@ static inline void pack_descriptor(struct desc_struct *desc, unsigned long base,
 {
 	desc->a = ((base & 0xffff) << 16) | (limit & 0xffff);
 	desc->b = (base & 0xff000000) | ((base & 0xff0000) >> 16) |
-		  (limit & 0x000f0000) | ((type & 0xff) << 8) |
-		  ((flags & 0xf) << 20);
+		(limit & 0x000f0000) | ((type & 0xff) << 8) |
+		((flags & 0xf) << 20);
 	desc->p = 1;
 }
 
@@ -159,7 +160,6 @@ static inline void set_tssldt_descriptor(void *d, unsigned long addr,
 	desc->base2 = (PTR_MIDDLE(addr) >> 8) & 0xFF;
 	desc->base3 = PTR_HIGH(addr);
 #else
-
 	pack_descriptor((struct desc_struct *)d, addr, size, 0x80 | type, 0);
 #endif
 }
@@ -177,7 +177,8 @@ static inline void __set_tss_desc(unsigned cpu, unsigned int entry, void *addr)
 	 * last valid byte
 	 */
 	set_tssldt_descriptor(&tss, (unsigned long)addr, DESC_TSS,
-		IO_BITMAP_OFFSET + IO_BITMAP_BYTES + sizeof(unsigned long) - 1);
+			      IO_BITMAP_OFFSET + IO_BITMAP_BYTES +
+			      sizeof(unsigned long) - 1);
 	write_gdt_entry(d, entry, &tss, DESC_TSS);
 }
 
@@ -186,7 +187,7 @@ static inline void __set_tss_desc(unsigned cpu, unsigned int entry, void *addr)
 static inline void native_set_ldt(const void *addr, unsigned int entries)
 {
 	if (likely(entries == 0))
-		__asm__ __volatile__("lldt %w0"::"q" (0));
+		asm volatile("lldt %w0"::"q" (0));
 	else {
 		unsigned cpu = smp_processor_id();
 		ldt_desc ldt;
@@ -195,7 +196,7 @@ static inline void native_set_ldt(const void *addr, unsigned int entries)
 				      DESC_LDT, entries * sizeof(ldt) - 1);
 		write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_LDT,
 				&ldt, DESC_LDT);
-		__asm__ __volatile__("lldt %w0"::"q" (GDT_ENTRY_LDT*8));
+		asm volatile("lldt %w0"::"q" (GDT_ENTRY_LDT*8));
 	}
 }
 
@@ -240,15 +241,15 @@ static inline void native_load_tls(struct thread_struct *t, unsigned int cpu)
 		gdt[GDT_ENTRY_TLS_MIN + i] = t->tls_array[i];
 }
 
-#define _LDT_empty(info) (\
-	(info)->base_addr	== 0	&& \
-	(info)->limit		== 0	&& \
-	(info)->contents	== 0	&& \
-	(info)->read_exec_only	== 1	&& \
-	(info)->seg_32bit	== 0	&& \
-	(info)->limit_in_pages	== 0	&& \
-	(info)->seg_not_present	== 1	&& \
-	(info)->useable		== 0)
+#define _LDT_empty(info)				\
+	((info)->base_addr		== 0	&&	\
+	 (info)->limit			== 0	&&	\
+	 (info)->contents		== 0	&&	\
+	 (info)->read_exec_only		== 1	&&	\
+	 (info)->seg_32bit		== 0	&&	\
+	 (info)->limit_in_pages		== 0	&&	\
+	 (info)->seg_not_present	== 1	&&	\
+	 (info)->useable		== 0)
 
 #ifdef CONFIG_X86_64
 #define LDT_empty(info) (_LDT_empty(info) && ((info)->lm == 0))
@@ -287,7 +288,7 @@ static inline unsigned long get_desc_limit(const struct desc_struct *desc)
 }
 
 static inline void _set_gate(int gate, unsigned type, void *addr,
-			      unsigned dpl, unsigned ist, unsigned seg)
+			     unsigned dpl, unsigned ist, unsigned seg)
 {
 	gate_desc s;
 	pack_gate(&s, type, (unsigned long)addr, dpl, ist, seg);
@@ -370,10 +371,10 @@ static inline void set_system_gate_ist(int n, void *addr, unsigned ist)
  *    Will read the base address of GDT_ENTRY_ESPFIX_SS and put it into %eax.
  */
 #define GET_DESC_BASE(idx, gdt, base, lo_w, lo_b, hi_b) \
-	movb idx*8+4(gdt), lo_b; \
-	movb idx*8+7(gdt), hi_b; \
-	shll $16, base; \
-	movw idx*8+2(gdt), lo_w;
+	movb idx * 8 + 4(gdt), lo_b;			\
+	movb idx * 8 + 7(gdt), hi_b;			\
+	shll $16, base;					\
+	movw idx * 8 + 2(gdt), lo_w;
 
 
 #endif /* __ASSEMBLY__ */
-- 
1.5.4.rc2

