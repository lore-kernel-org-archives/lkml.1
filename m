Return-Path: <linux-kernel-owner+w=401wt.eu-S1760008AbXIZSU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbXIZSU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbXIZSUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:20:20 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:58849 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbXIZSUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:20:18 -0400
Subject: [PATCH] just rename call_rcu_bh instead of making it a macro
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: RT <linux-rt-users@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 14:17:47 -0400
Message-Id: <1190830667.20235.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seems that I found a box that has a config that passes call_rcu_bh as a
function pointer (see net/sctp/sm_make_chunk.c), so declaring the
call_rcu_bh has a macro function isn't good enough.

This patch makes it just another name of call_rcu for rcupreempt.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.23-rc8-rt1/include/linux/rcupreempt.h
===================================================================
--- linux-2.6.23-rc8-rt1.orig/include/linux/rcupreempt.h
+++ linux-2.6.23-rc8-rt1/include/linux/rcupreempt.h
@@ -42,9 +42,14 @@
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 
-#define rcu_qsctr_inc(cpu)
-#define rcu_bh_qsctr_inc(cpu)
-#define call_rcu_bh(head, rcu) call_rcu(head, rcu)
+#define rcu_qsctr_inc(cpu)	do { } while (0)
+#define rcu_bh_qsctr_inc(cpu)	do { } while (0)
+/*
+ * Someone might want to pass call_rcu_bh as a function pointer.
+ * So this needs to just be a rename and not a macro function.
+ *  (no parentheses)
+ */
+#define call_rcu_bh		 call_rcu
 
 extern void __rcu_read_lock(void);
 extern void __rcu_read_unlock(void);


