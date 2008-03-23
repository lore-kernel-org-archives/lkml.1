Return-Path: <linux-kernel-owner+w=401wt.eu-S1764213AbYCWJIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764213AbYCWJIj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760387AbYCWIMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:32 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2376 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760252AbYCWIMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:12:03 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 113/148] include/asm-x86/signal.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:28 -0700
Message-Id: <1206259443-13210-114-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/signal.h |   48 +++++++++++++++++++++++-----------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/include/asm-x86/signal.h b/include/asm-x86/signal.h
index aee7eca..f15186d 100644
--- a/include/asm-x86/signal.h
+++ b/include/asm-x86/signal.h
@@ -185,61 +185,61 @@ typedef struct sigaltstack {
 
 #define __HAVE_ARCH_SIG_BITOPS
 
-#define sigaddset(set,sig)		   \
-	(__builtin_constantp(sig) ?	   \
-	 __const_sigaddset((set),(sig)) :  \
-	 __gen_sigaddset((set),(sig)))
+#define sigaddset(set,sig)		    \
+	(__builtin_constantp(sig)	    \
+	 ? __const_sigaddset((set), (sig))  \
+	 : __gen_sigaddset((set), (sig)))
 
-static __inline__ void __gen_sigaddset(sigset_t *set, int _sig)
+static inline void __gen_sigaddset(sigset_t *set, int _sig)
 {
-	__asm__("btsl %1,%0" : "+m"(*set) : "Ir"(_sig - 1) : "cc");
+	asm("btsl %1,%0" : "+m"(*set) : "Ir"(_sig - 1) : "cc");
 }
 
-static __inline__ void __const_sigaddset(sigset_t *set, int _sig)
+static inline void __const_sigaddset(sigset_t *set, int _sig)
 {
 	unsigned long sig = _sig - 1;
 	set->sig[sig / _NSIG_BPW] |= 1 << (sig % _NSIG_BPW);
 }
 
-#define sigdelset(set,sig)		   \
-	(__builtin_constant_p(sig) ?       \
-	 __const_sigdelset((set),(sig)) :  \
-	 __gen_sigdelset((set),(sig)))
+#define sigdelset(set, sig)		    \
+	(__builtin_constant_p(sig)	    \
+	 ? __const_sigdelset((set), (sig))  \
+	 : __gen_sigdelset((set), (sig)))
 
 
-static __inline__ void __gen_sigdelset(sigset_t *set, int _sig)
+static inline void __gen_sigdelset(sigset_t *set, int _sig)
 {
-	__asm__("btrl %1,%0" : "+m"(*set) : "Ir"(_sig - 1) : "cc");
+	asm("btrl %1,%0" : "+m"(*set) : "Ir"(_sig - 1) : "cc");
 }
 
-static __inline__ void __const_sigdelset(sigset_t *set, int _sig)
+static inline void __const_sigdelset(sigset_t *set, int _sig)
 {
 	unsigned long sig = _sig - 1;
 	set->sig[sig / _NSIG_BPW] &= ~(1 << (sig % _NSIG_BPW));
 }
 
-static __inline__ int __const_sigismember(sigset_t *set, int _sig)
+static inline int __const_sigismember(sigset_t *set, int _sig)
 {
 	unsigned long sig = _sig - 1;
 	return 1 & (set->sig[sig / _NSIG_BPW] >> (sig % _NSIG_BPW));
 }
 
-static __inline__ int __gen_sigismember(sigset_t *set, int _sig)
+static inline int __gen_sigismember(sigset_t *set, int _sig)
 {
 	int ret;
-	__asm__("btl %2,%1\n\tsbbl %0,%0"
-		: "=r"(ret) : "m"(*set), "Ir"(_sig-1) : "cc");
+	asm("btl %2,%1\n\tsbbl %0,%0"
+	    : "=r"(ret) : "m"(*set), "Ir"(_sig-1) : "cc");
 	return ret;
 }
 
-#define sigismember(set,sig)			\
-	(__builtin_constant_p(sig) ?		\
-	 __const_sigismember((set),(sig)) :	\
-	 __gen_sigismember((set),(sig)))
+#define sigismember(set, sig)			\
+	(__builtin_constant_p(sig)		\
+	 ? __const_sigismember((set), (sig))	\
+	 : __gen_sigismember((set), (sig)))
 
-static __inline__ int sigfindinword(unsigned long word)
+static inline int sigfindinword(unsigned long word)
 {
-	__asm__("bsfl %1,%0" : "=r"(word) : "rm"(word) : "cc");
+	asm("bsfl %1,%0" : "=r"(word) : "rm"(word) : "cc");
 	return word;
 }
 
-- 
1.5.4.rc2

