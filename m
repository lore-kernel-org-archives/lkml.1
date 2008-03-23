Return-Path: <linux-kernel-owner+w=401wt.eu-S934389AbYCWJEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934389AbYCWJEg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759130AbYCWIMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:19 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2362 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760225AbYCWIL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:59 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 076/148] include/asm-x86/msr.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:51 -0700
Message-Id: <1206259443-13210-77-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/msr.h |   81 +++++++++++++++++++++++++-----------------------
 1 files changed, 42 insertions(+), 39 deletions(-)

diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
index 3ca29eb..2c698a2 100644
--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -16,8 +16,8 @@
 static inline unsigned long long native_read_tscp(unsigned int *aux)
 {
 	unsigned long low, high;
-	asm volatile (".byte 0x0f,0x01,0xf9"
-		      : "=a" (low), "=d" (high), "=c" (*aux));
+	asm volatile(".byte 0x0f,0x01,0xf9"
+		     : "=a" (low), "=d" (high), "=c" (*aux));
 	return low | ((u64)high >> 32);
 }
 
@@ -29,7 +29,7 @@ static inline unsigned long long native_read_tscp(unsigned int *aux)
  */
 #ifdef CONFIG_X86_64
 #define DECLARE_ARGS(val, low, high)	unsigned low, high
-#define EAX_EDX_VAL(val, low, high)	(low | ((u64)(high) << 32))
+#define EAX_EDX_VAL(val, low, high)	((low) | ((u64)(high) << 32))
 #define EAX_EDX_ARGS(val, low, high)	"a" (low), "d" (high)
 #define EAX_EDX_RET(val, low, high)	"=a" (low), "=d" (high)
 #else
@@ -57,7 +57,7 @@ static inline unsigned long long native_read_msr_safe(unsigned int msr,
 		     ".section .fixup,\"ax\"\n\t"
 		     "3:  mov %3,%0 ; jmp 1b\n\t"
 		     ".previous\n\t"
-		     _ASM_EXTABLE(2b,3b)
+		     _ASM_EXTABLE(2b, 3b)
 		     : "=r" (*err), EAX_EDX_RET(val, low, high)
 		     : "c" (msr), "i" (-EFAULT));
 	return EAX_EDX_VAL(val, low, high);
@@ -78,10 +78,10 @@ static inline int native_write_msr_safe(unsigned int msr,
 		     ".section .fixup,\"ax\"\n\t"
 		     "3:  mov %4,%0 ; jmp 1b\n\t"
 		     ".previous\n\t"
-		     _ASM_EXTABLE(2b,3b)
+		     _ASM_EXTABLE(2b, 3b)
 		     : "=a" (err)
 		     : "c" (msr), "0" (low), "d" (high),
-		       "i" (-EFAULT));
+		     "i" (-EFAULT));
 	return err;
 }
 
@@ -116,23 +116,23 @@ static inline unsigned long long native_read_pmc(int counter)
  * pointer indirection), this allows gcc to optimize better
  */
 
-#define rdmsr(msr,val1,val2)						\
-	do {								\
-		u64 __val = native_read_msr(msr);			\
-		(val1) = (u32)__val;					\
-		(val2) = (u32)(__val >> 32);				\
-	} while(0)
+#define rdmsr(msr, val1, val2)					\
+do {								\
+	u64 __val = native_read_msr((msr));			\
+	(val1) = (u32)__val;					\
+	(val2) = (u32)(__val >> 32);				\
+} while (0)
 
 static inline void wrmsr(unsigned msr, unsigned low, unsigned high)
 {
 	native_write_msr(msr, low, high);
 }
 
-#define rdmsrl(msr,val)							\
-	((val) = native_read_msr(msr))
+#define rdmsrl(msr, val)			\
+	((val) = native_read_msr((msr)))
 
 #define wrmsrl(msr, val)						\
-	native_write_msr(msr, (u32)((u64)(val)), (u32)((u64)(val) >> 32))
+	native_write_msr((msr), (u32)((u64)(val)), (u32)((u64)(val) >> 32))
 
 /* wrmsr with exception handling */
 static inline int wrmsr_safe(unsigned msr, unsigned low, unsigned high)
@@ -141,14 +141,14 @@ static inline int wrmsr_safe(unsigned msr, unsigned low, unsigned high)
 }
 
 /* rdmsr with exception handling */
-#define rdmsr_safe(msr,p1,p2)						\
-	({								\
-		int __err;						\
-		u64 __val = native_read_msr_safe(msr, &__err);		\
-		(*p1) = (u32)__val;					\
-		(*p2) = (u32)(__val >> 32);				\
-		__err;							\
-	})
+#define rdmsr_safe(msr, p1, p2)					\
+({								\
+	int __err;						\
+	u64 __val = native_read_msr_safe((msr), &__err);	\
+	(*p1) = (u32)__val;					\
+	(*p2) = (u32)(__val >> 32);				\
+	__err;							\
+})
 
 #define rdtscl(low)						\
 	((low) = (u32)native_read_tsc())
@@ -156,35 +156,37 @@ static inline int wrmsr_safe(unsigned msr, unsigned low, unsigned high)
 #define rdtscll(val)						\
 	((val) = native_read_tsc())
 
-#define rdpmc(counter,low,high)					\
-	do {							\
-		u64 _l = native_read_pmc(counter);		\
-		(low)  = (u32)_l;				\
-		(high) = (u32)(_l >> 32);			\
-	} while(0)
+#define rdpmc(counter, low, high)			\
+do {							\
+	u64 _l = native_read_pmc((counter));		\
+	(low)  = (u32)_l;				\
+	(high) = (u32)(_l >> 32);			\
+} while (0)
 
-#define rdtscp(low, high, aux)						\
-       do {                                                            \
-		unsigned long long _val = native_read_tscp(&(aux));     \
-		(low) = (u32)_val;                                      \
-		(high) = (u32)(_val >> 32);                             \
-       } while (0)
+#define rdtscp(low, high, aux)					\
+do {                                                            \
+	unsigned long long _val = native_read_tscp(&(aux));     \
+	(low) = (u32)_val;                                      \
+	(high) = (u32)(_val >> 32);                             \
+} while (0)
 
 #define rdtscpll(val, aux) (val) = native_read_tscp(&(aux))
 
 #endif	/* !CONFIG_PARAVIRT */
 
 
-#define checking_wrmsrl(msr,val) wrmsr_safe(msr,(u32)(val),(u32)((val)>>32))
+#define checking_wrmsrl(msr, val) wrmsr_safe((msr), (u32)(val),		\
+					     (u32)((val) >> 32))
 
-#define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
+#define write_tsc(val1, val2) wrmsr(0x10, (val1), (val2))
 
-#define write_rdtscp_aux(val) wrmsr(0xc0000103, val, 0)
+#define write_rdtscp_aux(val) wrmsr(0xc0000103, (val), 0)
 
 #ifdef CONFIG_SMP
 void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
+
 int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 #else  /*  CONFIG_SMP  */
 static inline void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
@@ -195,7 +197,8 @@ static inline void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 {
 	wrmsr(msr_no, l, h);
 }
-static inline int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+static inline int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no,
+				    u32 *l, u32 *h)
 {
 	return rdmsr_safe(msr_no, l, h);
 }
-- 
1.5.4.rc2

