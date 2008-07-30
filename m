Return-Path: <linux-kernel-owner+w=401wt.eu-S1760950AbYG3SXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760950AbYG3SXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbYG3SWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:22:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39917 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbYG3SWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:22:41 -0400
Message-Id: <20080730182239.346811562@goodmis.org>
References: <20080730182053.872043059@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 30 Jul 2008 14:20:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.org>
Subject: [PATCH 1/2] rcu: just rename call_rcu_bh instead of making it a macro
Content-Disposition: inline; filename=call_rcu_bh-rename-of-call_rcu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems that I found a box that has a config that passes call_rcu_bh as a
function pointer (see net/sctp/sm_make_chunk.c), so declaring the
call_rcu_bh has a macro function isn't good enough.

This patch makes it just another name of call_rcu for rcupreempt.

Signed-off-by: Steven Rostedt <srostedt@redhat.org>

---
 include/linux/rcupreempt.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-compile.git/include/linux/rcupreempt.h
===================================================================
--- linux-compile.git.orig/include/linux/rcupreempt.h	2008-07-30 13:56:28.000000000 -0400
+++ linux-compile.git/include/linux/rcupreempt.h	2008-07-30 13:57:57.000000000 -0400
@@ -57,7 +57,13 @@ static inline void rcu_qsctr_inc(int cpu
 	rdssp->sched_qs++;
 }
 #define rcu_bh_qsctr_inc(cpu)
-#define call_rcu_bh(head, rcu) call_rcu(head, rcu)
+
+/*
+ * Someone might want to pass call_rcu_bh as a function pointer.
+ * So this needs to just be a rename and not a macro function.
+ *  (no parentheses)
+ */
+#define call_rcu_bh	 	call_rcu
 
 /**
  * call_rcu_sched - Queue RCU callback for invocation after sched grace period.

-- 
