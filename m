Return-Path: <linux-kernel-owner+w=401wt.eu-S933366AbYCWI4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366AbYCWI4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760190AbYCWILu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:50 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2346 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760103AbYCWILn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:43 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 037/148] include/asm-x86/futex.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:12 -0700
Message-Id: <1206259443-13210-38-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/futex.h |  101 +++++++++++++++++++++++++---------------------
 1 files changed, 55 insertions(+), 46 deletions(-)

diff --git a/include/asm-x86/futex.h b/include/asm-x86/futex.h
index c9952ea..ac0fbf2 100644
--- a/include/asm-x86/futex.h
+++ b/include/asm-x86/futex.h
@@ -12,35 +12,32 @@
 #include <asm/uaccess.h>
 
 #define __futex_atomic_op1(insn, ret, oldval, uaddr, oparg)	\
-  __asm__ __volatile(						\
-"1:	" insn "\n"						\
-"2:	.section .fixup,\"ax\"\n				\
-3:	mov	%3, %1\n					\
-	jmp	2b\n						\
-	.previous\n"						\
-	_ASM_EXTABLE(1b,3b)					\
-	: "=r" (oldval), "=r" (ret), "+m" (*uaddr)		\
-	: "i" (-EFAULT), "0" (oparg), "1" (0))
+	asm volatile("1:\t" insn "\n"				\
+		     "2:\t.section .fixup,\"ax\"\n"		\
+		     "3:\tmov\t%3, %1\n"			\
+		     "\tjmp\t2b\n"				\
+		     "\t.previous\n"				\
+		     _ASM_EXTABLE(1b, 3b)			\
+		     : "=r" (oldval), "=r" (ret), "+m" (*uaddr)	\
+		     : "i" (-EFAULT), "0" (oparg), "1" (0))
 
 #define __futex_atomic_op2(insn, ret, oldval, uaddr, oparg)	\
-  __asm__ __volatile(						\
-"1:	movl	%2, %0\n					\
-	movl	%0, %3\n"					\
-	insn "\n"						\
-"2:	lock; cmpxchgl %3, %2\n					\
-	jnz	1b\n						\
-3:	.section .fixup,\"ax\"\n				\
-4:	mov	%5, %1\n					\
-	jmp	3b\n						\
-	.previous\n"						\
-	_ASM_EXTABLE(1b,4b)					\
-	_ASM_EXTABLE(2b,4b)					\
-	: "=&a" (oldval), "=&r" (ret), "+m" (*uaddr),		\
-	  "=&r" (tem)						\
-	: "r" (oparg), "i" (-EFAULT), "1" (0))
-
-static inline int
-futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
+	asm volatile("1:\tmovl	%2, %0\n"			\
+		     "\tmovl\t%0, %3\n"				\
+		     "\t" insn "\n"				\
+		     "2:\tlock; cmpxchgl %3, %2\n"		\
+		     "\tjnz\t1b\n"				\
+		     "3:\t.section .fixup,\"ax\"\n"		\
+		     "4:\tmov\t%5, %1\n"			\
+		     "\tjmp\t3b\n"				\
+		     "\t.previous\n"				\
+		     _ASM_EXTABLE(1b, 4b)			\
+		     _ASM_EXTABLE(2b, 4b)			\
+		     : "=&a" (oldval), "=&r" (ret),		\
+		       "+m" (*uaddr), "=&r" (tem)		\
+		     : "r" (oparg), "i" (-EFAULT), "1" (0))
+
+static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
@@ -87,20 +84,33 @@ futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 
 	if (!ret) {
 		switch (cmp) {
-		case FUTEX_OP_CMP_EQ: ret = (oldval == cmparg); break;
-		case FUTEX_OP_CMP_NE: ret = (oldval != cmparg); break;
-		case FUTEX_OP_CMP_LT: ret = (oldval < cmparg); break;
-		case FUTEX_OP_CMP_GE: ret = (oldval >= cmparg); break;
-		case FUTEX_OP_CMP_LE: ret = (oldval <= cmparg); break;
-		case FUTEX_OP_CMP_GT: ret = (oldval > cmparg); break;
-		default: ret = -ENOSYS;
+		case FUTEX_OP_CMP_EQ:
+			ret = (oldval == cmparg);
+			break;
+		case FUTEX_OP_CMP_NE:
+			ret = (oldval != cmparg);
+			break;
+		case FUTEX_OP_CMP_LT:
+			ret = (oldval < cmparg);
+			break;
+		case FUTEX_OP_CMP_GE:
+			ret = (oldval >= cmparg);
+			break;
+		case FUTEX_OP_CMP_LE:
+			ret = (oldval <= cmparg);
+			break;
+		case FUTEX_OP_CMP_GT:
+			ret = (oldval > cmparg);
+			break;
+		default:
+			ret = -ENOSYS;
 		}
 	}
 	return ret;
 }
 
-static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+static inline int futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval,
+						int newval)
 {
 
 #if defined(CONFIG_X86_32) && !defined(CONFIG_X86_BSWAP)
@@ -112,16 +122,15 @@ futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
 		return -EFAULT;
 
-	__asm__ __volatile__(
-		"1:	lock; cmpxchgl %3, %1			\n"
-		"2:	.section .fixup, \"ax\"			\n"
-		"3:	mov     %2, %0				\n"
-		"	jmp     2b				\n"
-		"	.previous				\n"
-		_ASM_EXTABLE(1b,3b)
-		: "=a" (oldval), "+m" (*uaddr)
-		: "i" (-EFAULT), "r" (newval), "0" (oldval)
-		: "memory"
+	asm volatile("1:\tlock; cmpxchgl %3, %1\n"
+		     "2:\t.section .fixup, \"ax\"\n"
+		     "3:\tmov     %2, %0\n"
+		     "\tjmp     2b\n"
+		     "\t.previous\n"
+		     _ASM_EXTABLE(1b, 3b)
+		     : "=a" (oldval), "+m" (*uaddr)
+		     : "i" (-EFAULT), "r" (newval), "0" (oldval)
+		     : "memory"
 	);
 
 	return oldval;
-- 
1.5.4.rc2

