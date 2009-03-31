Return-Path: <linux-kernel-owner+w=401wt.eu-S1760597AbZCaNeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760597AbZCaNeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760271AbZCaNd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:33:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:25809 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760168AbZCaNd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:33:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="677481194"
Date: Tue, 31 Mar 2009 14:53:51 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 2/21] sched: add task_is_running() fucntion to sched.h
Message-ID: <20090331145351.A12494@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to query whether a task is currently running on any cpu.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/include/linux/sched.h
===================================================================
--- git-tip.orig/include/linux/sched.h	2009-03-30 13:31:10.000000000 +0200
+++ git-tip/include/linux/sched.h	2009-03-30 13:36:56.000000000 +0200
@@ -2280,6 +2280,7 @@ static inline void set_task_cpu(struct t
 
 #endif /* CONFIG_SMP */
 
+extern int task_is_running(struct task_struct *p);
 extern void arch_pick_mmap_layout(struct mm_struct *mm);
 
 #ifdef CONFIG_TRACING
Index: git-tip/kernel/sched.c
===================================================================
--- git-tip.orig/kernel/sched.c	2009-03-30 13:30:56.000000000 +0200
+++ git-tip/kernel/sched.c	2009-03-30 13:47:39.000000000 +0200
@@ -1933,6 +1933,22 @@ migrate_task(struct task_struct *p, int 
 }
 
 /*
+ * Is the task currently running on any cpu?
+ */
+int task_is_running(struct task_struct *p)
+{
+	struct rq *rq;
+	unsigned long flags;
+	int running;
+
+	rq = task_rq_lock(p, &flags);
+	running = task_running(rq, p);
+	task_rq_unlock(rq, &flags);
+
+	return running;
+}
+
+/*
  * wait_task_inactive - wait for a thread to unschedule.
  *
  * If @match_state is nonzero, it's the @p->state value just checked and
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

