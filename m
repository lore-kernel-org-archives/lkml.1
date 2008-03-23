Return-Path: <linux-kernel-owner+w=401wt.eu-S934212AbYCWJD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934212AbYCWJD2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759732AbYCWIMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:15 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2364 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760220AbYCWIL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:58 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 090/148] include/asm-x86/pda.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:05 -0700
Message-Id: <1206259443-13210-91-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/pda.h |   80 +++++++++++++++++++++++++-----------------------
 1 files changed, 42 insertions(+), 38 deletions(-)

diff --git a/include/asm-x86/pda.h b/include/asm-x86/pda.h
index b364d68..62b7349 100644
--- a/include/asm-x86/pda.h
+++ b/include/asm-x86/pda.h
@@ -55,34 +55,36 @@ extern struct x8664_pda _proxy_pda;
 
 #define pda_offset(field) offsetof(struct x8664_pda, field)
 
-#define pda_to_op(op, field, val) do {		\
-	typedef typeof(_proxy_pda.field) T__;	\
-	if (0) { T__ tmp__; tmp__ = (val); }	/* type checking */ \
-	switch (sizeof(_proxy_pda.field)) {	\
-	case 2:					\
-		asm(op "w %1,%%gs:%c2" :	\
-		    "+m" (_proxy_pda.field) :	\
-		    "ri" ((T__)val),		\
-		    "i"(pda_offset(field)));	\
-		break;				\
-	case 4:					\
-		asm(op "l %1,%%gs:%c2" :	\
-		    "+m" (_proxy_pda.field) :	\
-		    "ri" ((T__)val),		\
-		    "i" (pda_offset(field)));	\
-		break;				\
-	case 8:					\
-		asm(op "q %1,%%gs:%c2":		\
-		    "+m" (_proxy_pda.field) :	\
-		    "ri" ((T__)val),		\
-		    "i"(pda_offset(field)));	\
-		break;				\
-	default:				\
-		__bad_pda_field();		\
-	}					\
-	} while (0)
+#define pda_to_op(op, field, val)					\
+do {									\
+	typedef typeof(_proxy_pda.field) T__;				\
+	if (0) { T__ tmp__; tmp__ = (val); }	/* type checking */	\
+	switch (sizeof(_proxy_pda.field)) {				\
+	case 2:								\
+		asm(op "w %1,%%gs:%c2" :				\
+		    "+m" (_proxy_pda.field) :				\
+		    "ri" ((T__)val),					\
+		    "i"(pda_offset(field)));				\
+		break;							\
+	case 4:								\
+		asm(op "l %1,%%gs:%c2" :				\
+		    "+m" (_proxy_pda.field) :				\
+		    "ri" ((T__)val),					\
+		    "i" (pda_offset(field)));				\
+		break;							\
+	case 8:								\
+		asm(op "q %1,%%gs:%c2":					\
+		    "+m" (_proxy_pda.field) :				\
+		    "ri" ((T__)val),					\
+		    "i"(pda_offset(field)));				\
+		break;							\
+	default:							\
+		__bad_pda_field();					\
+	}								\
+} while (0)
 
-#define pda_from_op(op,field) ({		\
+#define pda_from_op(op, field)			\
+({						\
 	typeof(_proxy_pda.field) ret__;		\
 	switch (sizeof(_proxy_pda.field)) {	\
 	case 2:					\
@@ -90,23 +92,24 @@ extern struct x8664_pda _proxy_pda;
 		    "=r" (ret__) :		\
 		    "i" (pda_offset(field)),	\
 		    "m" (_proxy_pda.field));	\
-		 break;				\
+		break;				\
 	case 4:					\
 		asm(op "l %%gs:%c1,%0":		\
 		    "=r" (ret__):		\
 		    "i" (pda_offset(field)),	\
 		    "m" (_proxy_pda.field));	\
-		 break;				\
+		break;				\
 	case 8:					\
 		asm(op "q %%gs:%c1,%0":		\
 		    "=r" (ret__) :		\
 		    "i" (pda_offset(field)),	\
 		    "m" (_proxy_pda.field));	\
-		 break;				\
+		break;				\
 	default:				\
 		__bad_pda_field();		\
-       }					\
-       ret__; })
+	}					\
+	ret__;					\
+})
 
 #define read_pda(field)		pda_from_op("mov", field)
 #define write_pda(field, val)	pda_to_op("mov", field, val)
@@ -115,12 +118,13 @@ extern struct x8664_pda _proxy_pda;
 #define or_pda(field, val)	pda_to_op("or", field, val)
 
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */
-#define test_and_clear_bit_pda(bit, field) ({		\
-	int old__;						\
-	asm volatile("btr %2,%%gs:%c3\n\tsbbl %0,%0"		\
-	    : "=r" (old__), "+m" (_proxy_pda.field)		\
-	    : "dIr" (bit), "i" (pda_offset(field)) : "memory");	\
-	old__;							\
+#define test_and_clear_bit_pda(bit, field)				\
+({									\
+	int old__;							\
+	asm volatile("btr %2,%%gs:%c3\n\tsbbl %0,%0"			\
+		     : "=r" (old__), "+m" (_proxy_pda.field)		\
+		     : "dIr" (bit), "i" (pda_offset(field)) : "memory");\
+	old__;								\
 })
 
 #endif
-- 
1.5.4.rc2

