Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbXHRPeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbXHRPeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 11:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbXHRPeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 11:34:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33823 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbXHRPeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 11:34:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 18 Aug 2007 17:32:05 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH trivial] include/asm-*/system.h: remove unused set_rmb(),
 set_wmb() macros
To: trivial@kernel.org
cc: linux-kernel@vger.kernel.org, Bryan Wu <bryan.wu@analog.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>,
       Miles Bader <uclinux-v850@lsi.nec.co.jp>
Message-ID: <tkrat.eb667dbcda37eb9d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These don't appear anywhere else in the kernel anymore.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Miles Bader <uclinux-v850@lsi.nec.co.jp>
---
 include/asm-blackfin/system.h  |    4 +---
 include/asm-h8300/system.h     |    3 +--
 include/asm-m68knommu/system.h |    3 +--
 include/asm-sh64/system.h      |    3 +--
 include/asm-v850/system.h      |    3 +--
 5 files changed, 5 insertions(+), 11 deletions(-)

Index: linux/include/asm-blackfin/system.h
===================================================================
--- linux.orig/include/asm-blackfin/system.h
+++ linux/include/asm-blackfin/system.h
@@ -119,9 +119,7 @@ extern unsigned long irq_flags;
 #define mb()   asm volatile (""   : : :"memory")
 #define rmb()  asm volatile (""   : : :"memory")
 #define wmb()  asm volatile (""   : : :"memory")
-#define set_rmb(var, value)    do { (void) xchg(&var, value); } while (0)
-#define set_mb(var, value)     set_rmb(var, value)
-#define set_wmb(var, value)    do { var = value; wmb(); } while (0)
+#define set_mb(var, value) do { (void) xchg(&var, value); } while (0)
 
 #define read_barrier_depends() 		do { } while(0)
 
Index: linux/include/asm-h8300/system.h
===================================================================
--- linux.orig/include/asm-h8300/system.h
+++ linux/include/asm-h8300/system.h
@@ -82,8 +82,7 @@ asmlinkage void resume(void);
 #define mb()   asm volatile (""   : : :"memory")
 #define rmb()  asm volatile (""   : : :"memory")
 #define wmb()  asm volatile (""   : : :"memory")
-#define set_rmb(var, value)    do { xchg(&var, value); } while (0)
-#define set_mb(var, value)     set_rmb(var, value)
+#define set_mb(var, value) do { xchg(&var, value); } while (0)
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
Index: linux/include/asm-m68knommu/system.h
===================================================================
--- linux.orig/include/asm-m68knommu/system.h
+++ linux/include/asm-m68knommu/system.h
@@ -104,8 +104,7 @@ asmlinkage void resume(void);
 #define mb()   asm volatile (""   : : :"memory")
 #define rmb()  asm volatile (""   : : :"memory")
 #define wmb()  asm volatile (""   : : :"memory")
-#define set_rmb(var, value)    do { xchg(&var, value); } while (0)
-#define set_mb(var, value)     set_rmb(var, value)
+#define set_mb(var, value) do { xchg(&var, value); } while (0)
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
Index: linux/include/asm-sh64/system.h
===================================================================
--- linux.orig/include/asm-sh64/system.h
+++ linux/include/asm-sh64/system.h
@@ -62,8 +62,7 @@ extern void __xchg_called_with_bad_point
 #define smp_read_barrier_depends()	do { } while (0)
 #endif /* CONFIG_SMP */
 
-#define set_rmb(var, value) do { (void)xchg(&var, value); } while (0)
-#define set_mb(var, value) set_rmb(var, value)
+#define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
 
 /* Interrupt Control */
 #ifndef HARD_CLI
Index: linux/include/asm-v850/system.h
===================================================================
--- linux.orig/include/asm-v850/system.h
+++ linux/include/asm-v850/system.h
@@ -66,8 +66,7 @@ static inline int irqs_disabled (void)
 #define rmb()			mb ()
 #define wmb()			mb ()
 #define read_barrier_depends()	((void)0)
-#define set_rmb(var, value)	do { xchg (&var, value); } while (0)
-#define set_mb(var, value)	set_rmb (var, value)
+#define set_mb(var, value)	do { xchg (&var, value); } while (0)
 
 #define smp_mb()	mb ()
 #define smp_rmb()	rmb ()

-- 
Stefan Richter
-=====-=-=== =--- =--=-
http://arcgraph.de/sr/

