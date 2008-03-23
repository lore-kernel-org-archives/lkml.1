Return-Path: <linux-kernel-owner+w=401wt.eu-S934454AbYCWJE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934454AbYCWJE6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760293AbYCWIMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:21 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2368 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760227AbYCWIMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:12:00 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 091/148] include/asm-x86/percpu.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:06 -0700
Message-Id: <1206259443-13210-92-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/percpu.h |  104 ++++++++++++++++++++++++----------------------
 1 files changed, 54 insertions(+), 50 deletions(-)

diff --git a/include/asm-x86/percpu.h b/include/asm-x86/percpu.h
index 0dec00f..736fc3b 100644
--- a/include/asm-x86/percpu.h
+++ b/include/asm-x86/percpu.h
@@ -85,58 +85,62 @@ DECLARE_PER_CPU(unsigned long, this_cpu_off);
  * don't give an lvalue though). */
 extern void __bad_percpu_size(void);
 
-#define percpu_to_op(op,var,val)				\
-	do {							\
-		typedef typeof(var) T__;			\
-		if (0) { T__ tmp__; tmp__ = (val); }		\
-		switch (sizeof(var)) {				\
-		case 1:						\
-			asm(op "b %1,"__percpu_seg"%0"		\
-			    : "+m" (var)			\
-			    :"ri" ((T__)val));			\
-			break;					\
-		case 2:						\
-			asm(op "w %1,"__percpu_seg"%0"		\
-			    : "+m" (var)			\
-			    :"ri" ((T__)val));			\
-			break;					\
-		case 4:						\
-			asm(op "l %1,"__percpu_seg"%0"		\
-			    : "+m" (var)			\
-			    :"ri" ((T__)val));			\
-			break;					\
-		default: __bad_percpu_size();			\
-		}						\
-	} while (0)
-
-#define percpu_from_op(op,var)					\
-	({							\
-		typeof(var) ret__;				\
-		switch (sizeof(var)) {				\
-		case 1:						\
-			asm(op "b "__percpu_seg"%1,%0"		\
-			    : "=r" (ret__)			\
-			    : "m" (var));			\
-			break;					\
-		case 2:						\
-			asm(op "w "__percpu_seg"%1,%0"		\
-			    : "=r" (ret__)			\
-			    : "m" (var));			\
-			break;					\
-		case 4:						\
-			asm(op "l "__percpu_seg"%1,%0"		\
-			    : "=r" (ret__)			\
-			    : "m" (var));			\
-			break;					\
-		default: __bad_percpu_size();			\
-		}						\
-		ret__; })
+#define percpu_to_op(op, var, val)			\
+do {							\
+	typedef typeof(var) T__;			\
+	if (0) {					\
+		T__ tmp__;				\
+		tmp__ = (val);				\
+	}						\
+	switch (sizeof(var)) {				\
+	case 1:						\
+		asm(op "b %1,"__percpu_seg"%0"		\
+		    : "+m" (var)			\
+		    : "ri" ((T__)val));			\
+		break;					\
+	case 2:						\
+		asm(op "w %1,"__percpu_seg"%0"		\
+		    : "+m" (var)			\
+		    : "ri" ((T__)val));			\
+		break;					\
+	case 4:						\
+		asm(op "l %1,"__percpu_seg"%0"		\
+		    : "+m" (var)			\
+		    : "ri" ((T__)val));			\
+		break;					\
+	default: __bad_percpu_size();			\
+	}						\
+} while (0)
+
+#define percpu_from_op(op, var)				\
+({							\
+	typeof(var) ret__;				\
+	switch (sizeof(var)) {				\
+	case 1:						\
+		asm(op "b "__percpu_seg"%1,%0"		\
+		    : "=r" (ret__)			\
+		    : "m" (var));			\
+		break;					\
+	case 2:						\
+		asm(op "w "__percpu_seg"%1,%0"		\
+		    : "=r" (ret__)			\
+		    : "m" (var));			\
+		break;					\
+	case 4:						\
+		asm(op "l "__percpu_seg"%1,%0"		\
+		    : "=r" (ret__)			\
+		    : "m" (var));			\
+		break;					\
+	default: __bad_percpu_size();			\
+	}						\
+	ret__;						\
+})
 
 #define x86_read_percpu(var) percpu_from_op("mov", per_cpu__##var)
-#define x86_write_percpu(var,val) percpu_to_op("mov", per_cpu__##var, val)
-#define x86_add_percpu(var,val) percpu_to_op("add", per_cpu__##var, val)
-#define x86_sub_percpu(var,val) percpu_to_op("sub", per_cpu__##var, val)
-#define x86_or_percpu(var,val) percpu_to_op("or", per_cpu__##var, val)
+#define x86_write_percpu(var, val) percpu_to_op("mov", per_cpu__##var, val)
+#define x86_add_percpu(var, val) percpu_to_op("add", per_cpu__##var, val)
+#define x86_sub_percpu(var, val) percpu_to_op("sub", per_cpu__##var, val)
+#define x86_or_percpu(var, val) percpu_to_op("or", per_cpu__##var, val)
 #endif /* !__ASSEMBLY__ */
 #endif /* !CONFIG_X86_64 */
 #endif /* _ASM_X86_PERCPU_H_ */
-- 
1.5.4.rc2

