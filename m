Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbXGNQCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbXGNQCq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 12:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbXGNQCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 12:02:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475AbXGNQCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 12:02:32 -0400
Message-Id: <20070714175840.153584000@chello.nl>
References: <20070714175733.194012000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sat, 14 Jul 2007 19:57:37 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH -rt 4/5] use migrate_disable for __local_begin
Content-Disposition: inline; filename=local-no_migrate.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/asm-i386/local.h   |    7 ++++---
 include/asm-x86_64/local.h |    7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

Index: linux-2.6/include/asm-i386/local.h
===================================================================
--- linux-2.6.orig/include/asm-i386/local.h
+++ linux-2.6/include/asm-i386/local.h
@@ -197,11 +197,12 @@ static __inline__ long local_sub_return(
 #define __local_begin(__flags)					\
 {								\
 	(__flags) = 0;						\
-	preempt_disable();					\
+	migrate_disable();					\
 }
 
-static inline void __local_end(unsigned long flags) {
-	preempt_enable();
+static inline void __local_end(unsigned long flags)
+{
+	migrate_enable();
 }
 
 /* On x86, these are no better than the atomic variants. */
Index: linux-2.6/include/asm-x86_64/local.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/local.h
+++ linux-2.6/include/asm-x86_64/local.h
@@ -186,11 +186,12 @@ static __inline__ long local_sub_return(
 #define __local_begin(__flags)		\
 {					\
 	(__flags) = 0;			\
-	preempt_disable();		\
+	migrate_disable();		\
 }
 
-static inline void __local_end(unsigned long flags) {
-	preempt_enable();
+static inline void __local_end(unsigned long flags)
+{
+	migrate_enable();
 }
 
 #define __local_inc(l)		local_inc(l)

--

