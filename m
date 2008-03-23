Return-Path: <linux-kernel-owner+w=401wt.eu-S1762161AbYCWI2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762161AbYCWI2M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759485AbYCWIJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:34 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2279 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759329AbYCWIJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:32 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 085/148] include/asm-x86/paravirt.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:00 -0700
Message-Id: <1206259443-13210-86-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/paravirt.h |   47 ++++++++++++++++++++++++++-----------------
 1 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index 3433c12..a7f046f 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -233,7 +233,8 @@ struct pv_mmu_ops {
 	void (*set_pte_at)(struct mm_struct *mm, unsigned long addr,
 			   pte_t *ptep, pte_t pteval);
 	void (*set_pmd)(pmd_t *pmdp, pmd_t pmdval);
-	void (*pte_update)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+	void (*pte_update)(struct mm_struct *mm, unsigned long addr,
+			   pte_t *ptep);
 	void (*pte_update_defer)(struct mm_struct *mm,
 				 unsigned long addr, pte_t *ptep);
 
@@ -248,7 +249,8 @@ struct pv_mmu_ops {
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
 	void (*set_pte_present)(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte);
-	void (*pte_clear)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+	void (*pte_clear)(struct mm_struct *mm, unsigned long addr,
+			  pte_t *ptep);
 	void (*pmd_clear)(pmd_t *pmdp);
 
 #endif	/* CONFIG_X86_PAE */
@@ -276,8 +278,7 @@ struct pv_mmu_ops {
 /* This contains all the paravirt structures: we get a convenient
  * number for each function using the offset which we use to indicate
  * what to patch. */
-struct paravirt_patch_template
-{
+struct paravirt_patch_template {
 	struct pv_init_ops pv_init_ops;
 	struct pv_time_ops pv_time_ops;
 	struct pv_cpu_ops pv_cpu_ops;
@@ -662,32 +663,37 @@ static inline int paravirt_write_msr(unsigned msr, unsigned low, unsigned high)
 }
 
 /* These should all do BUG_ON(_err), but our headers are too tangled. */
-#define rdmsr(msr,val1,val2) do {		\
+#define rdmsr(msr, val1, val2)			\
+do {						\
 	int _err;				\
 	u64 _l = paravirt_read_msr(msr, &_err);	\
 	val1 = (u32)_l;				\
 	val2 = _l >> 32;			\
-} while(0)
+} while (0)
 
-#define wrmsr(msr,val1,val2) do {		\
+#define wrmsr(msr, val1, val2)			\
+do {						\
 	paravirt_write_msr(msr, val1, val2);	\
-} while(0)
+} while (0)
 
-#define rdmsrl(msr,val) do {			\
+#define rdmsrl(msr, val)			\
+do {						\
 	int _err;				\
 	val = paravirt_read_msr(msr, &_err);	\
-} while(0)
+} while (0)
 
-#define wrmsrl(msr,val)		wrmsr(msr, (u32)((u64)(val)), ((u64)(val))>>32)
-#define wrmsr_safe(msr,a,b)	paravirt_write_msr(msr, a, b)
+#define wrmsrl(msr, val)	wrmsr(msr, (u32)((u64)(val)), ((u64)(val))>>32)
+#define wrmsr_safe(msr, a, b)	paravirt_write_msr(msr, a, b)
 
 /* rdmsr with exception handling */
-#define rdmsr_safe(msr,a,b) ({			\
+#define rdmsr_safe(msr, a, b)			\
+({						\
 	int _err;				\
 	u64 _l = paravirt_read_msr(msr, &_err);	\
 	(*a) = (u32)_l;				\
 	(*b) = _l >> 32;			\
-	_err; })
+	_err;					\
+})
 
 
 static inline u64 paravirt_read_tsc(void)
@@ -695,10 +701,11 @@ static inline u64 paravirt_read_tsc(void)
 	return PVOP_CALL0(u64, pv_cpu_ops.read_tsc);
 }
 
-#define rdtscl(low) do {			\
+#define rdtscl(low)				\
+do {						\
 	u64 _l = paravirt_read_tsc();		\
 	low = (int)_l;				\
-} while(0)
+} while (0)
 
 #define rdtscll(val) (val = paravirt_read_tsc())
 
@@ -713,11 +720,12 @@ static inline unsigned long long paravirt_read_pmc(int counter)
 	return PVOP_CALL1(u64, pv_cpu_ops.read_pmc, counter);
 }
 
-#define rdpmc(counter,low,high) do {		\
+#define rdpmc(counter, low, high)		\
+do {						\
 	u64 _l = paravirt_read_pmc(counter);	\
 	low = (u32)_l;				\
 	high = _l >> 32;			\
-} while(0)
+} while (0)
 
 static inline unsigned long long paravirt_rdtscp(unsigned int *aux)
 {
@@ -796,7 +804,8 @@ static inline void set_iopl_mask(unsigned mask)
 }
 
 /* The paravirtualized I/O functions */
-static inline void slow_down_io(void) {
+static inline void slow_down_io(void)
+{
 	pv_cpu_ops.io_delay();
 #ifdef REALLY_SLOW_IO
 	pv_cpu_ops.io_delay();
-- 
1.5.4.rc2

