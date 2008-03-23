Return-Path: <linux-kernel-owner+w=401wt.eu-S1761625AbYCWIvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761625AbYCWIvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760116AbYCWILh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:37 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2331 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760074AbYCWILb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:31 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 024/148] include/asm-x86/div64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:59 -0700
Message-Id: <1206259443-13210-25-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/div64.h |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/include/asm-x86/div64.h b/include/asm-x86/div64.h
index e98d16e..0dbf8bf 100644
--- a/include/asm-x86/div64.h
+++ b/include/asm-x86/div64.h
@@ -17,18 +17,20 @@
  * This ends up being the most efficient "calling
  * convention" on x86.
  */
-#define do_div(n,base) ({ \
-	unsigned long __upper, __low, __high, __mod, __base; \
-	__base = (base); \
-	asm("":"=a" (__low), "=d" (__high):"A" (n)); \
-	__upper = __high; \
-	if (__high) { \
-		__upper = __high % (__base); \
-		__high = __high / (__base); \
-	} \
-	asm("divl %2":"=a" (__low), "=d" (__mod):"rm" (__base), "0" (__low), "1" (__upper)); \
-	asm("":"=A" (n):"a" (__low),"d" (__high)); \
-	__mod; \
+#define do_div(n, base)						\
+({								\
+	unsigned long __upper, __low, __high, __mod, __base;	\
+	__base = (base);					\
+	asm("":"=a" (__low), "=d" (__high) : "A" (n));		\
+	__upper = __high;					\
+	if (__high) {						\
+		__upper = __high % (__base);			\
+		__high = __high / (__base);			\
+	}							\
+	asm("divl %2":"=a" (__low), "=d" (__mod)		\
+	    : "rm" (__base), "0" (__low), "1" (__upper));	\
+	asm("":"=A" (n) : "a" (__low), "d" (__high));		\
+	__mod;							\
 })
 
 /*
@@ -37,14 +39,13 @@
  *
  * Warning, this will do an exception if X overflows.
  */
-#define div_long_long_rem(a,b,c) div_ll_X_l_rem(a,b,c)
+#define div_long_long_rem(a, b, c) div_ll_X_l_rem(a, b, c)
 
-static inline long
-div_ll_X_l_rem(long long divs, long div, long *rem)
+static inline long div_ll_X_l_rem(long long divs, long div, long *rem)
 {
 	long dum2;
-      __asm__("divl %2":"=a"(dum2), "=d"(*rem)
-      :	"rm"(div), "A"(divs));
+	asm("divl %2":"=a"(dum2), "=d"(*rem)
+	    : "rm"(div), "A"(divs));
 
 	return dum2;
 
-- 
1.5.4.rc2

