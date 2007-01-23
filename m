Return-Path: <linux-kernel-owner+w=401wt.eu-S965508AbXAWWBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965508AbXAWWBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965509AbXAWWBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:01:15 -0500
Received: from www.osadl.org ([213.239.205.134]:35860 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933158AbXAWWBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:01:02 -0500
Message-Id: <20070123211205.865612000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 20/46] uninline irq_enter()
Content-Disposition: inline; filename=dynticks-uninline-irq_enter.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

Uninline irq_enter().  [dynticks adds more stuff to it]

No functional changes.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/hardirq.h |    7 +------
 kernel/softirq.c        |   10 ++++++++++
 2 files changed, 11 insertions(+), 6 deletions(-)

Index: linux-2.6.20-rc4-mm1-bo/include/linux/hardirq.h
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/include/linux/hardirq.h
+++ linux-2.6.20-rc4-mm1-bo/include/linux/hardirq.h
@@ -106,12 +106,7 @@ static inline void account_system_vtime(
  * always balanced, so the interrupted value of ->hardirq_context
  * will always be restored.
  */
-#define irq_enter()					\
-	do {						\
-		account_system_vtime(current);		\
-		add_preempt_count(HARDIRQ_OFFSET);	\
-		trace_hardirq_enter();			\
-	} while (0)
+extern void irq_enter(void);
 
 /*
  * Exit irq context without processing softirqs:
Index: linux-2.6.20-rc4-mm1-bo/kernel/softirq.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/softirq.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/softirq.c
@@ -273,6 +273,16 @@ EXPORT_SYMBOL(do_softirq);
 
 #endif
 
+/*
+ * Enter an interrupt context.
+ */
+void irq_enter(void)
+{
+	account_system_vtime(current);
+	add_preempt_count(HARDIRQ_OFFSET);
+	trace_hardirq_enter();
+}
+
 #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
 # define invoke_softirq()	__do_softirq()
 #else

--

