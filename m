Return-Path: <linux-kernel-owner+w=401wt.eu-S934202AbXLQB5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202AbXLQB5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 20:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759105AbXLQB5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 20:57:14 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:60878 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461AbXLQB5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 20:57:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=J8y8PG4A/ZnJsyp1LieZgjyXKK5QgnckWoWLnL6EFFNu6zATo9MvrqOE3mrATfIRL07vC2DAhRKT5M2+iyBS2QzBAhzFuOPaas008TxoSBjdkEIt+tWpXJqcUaCNFhuzUg8KBgN58ZQlSHJZjjoiP1g5OzGT6W3UIvCX+pkWFjA=
Subject: [PATCH 5/4] x86: local.h fix checkpatch warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Sun, 16 Dec 2007 17:57:16 -0800
Message-Id: <1197856636.3749.109.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly space after comma, one space after if.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-x86/local.h |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/asm-x86/local.h b/include/asm-x86/local.h
index f5677e2..f852c62 100644
--- a/include/asm-x86/local.h
+++ b/include/asm-x86/local.h
@@ -7,15 +7,14 @@
 #include <asm/atomic.h>
 #include <asm/asm.h>
 
-typedef struct
-{
+typedef struct {
 	atomic_long_t a;
 } local_t;
 
 #define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
 
 #define local_read(l)	atomic_long_read(&(l)->a)
-#define local_set(l,i)	atomic_long_set(&(l)->a, (i))
+#define local_set(l, i)	atomic_long_set(&(l)->a, (i))
 
 static inline void local_inc(local_t *l)
 {
@@ -137,7 +136,7 @@ static inline long local_add_return(long i, local_t *l)
 	long __i;
 #ifdef CONFIG_M386
 	unsigned long flags;
-	if(unlikely(boot_cpu_data.x86 <= 3))
+	if (unlikely(boot_cpu_data.x86 <= 3))
 		goto no_xadd;
 #endif
 	/* Modern 486+ processor */
@@ -160,11 +159,11 @@ no_xadd: /* Legacy 386 processor */
 
 static inline long local_sub_return(long i, local_t *l)
 {
-	return local_add_return(-i,l);
+	return local_add_return(-i, l);
 }
 
-#define local_inc_return(l)  (local_add_return(1,l))
-#define local_dec_return(l)  (local_sub_return(1,l))
+#define local_inc_return(l)  (local_add_return(1, l))
+#define local_dec_return(l)  (local_sub_return(1, l))
 
 #define local_cmpxchg(l, o, n) \
 	(cmpxchg_local(&((l)->a.counter), (o), (n)))
@@ -202,8 +201,8 @@ static inline long local_sub_return(long i, local_t *l)
  */
 #define __local_inc(l)		local_inc(l)
 #define __local_dec(l)		local_dec(l)
-#define __local_add(i,l)	local_add((i),(l))
-#define __local_sub(i,l)	local_sub((i),(l))
+#define __local_add(i, l)	local_add((i), (l))
+#define __local_sub(i, l)	local_sub((i), (l))
 
 /* Use these for per-cpu local_t variables: on some archs they are
  * much more efficient than these naive implementations.  Note they take
-- 
1.5.4.rc0.1083.gf568

