Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbYA3VHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbYA3VHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758127AbYA3VFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:05:40 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:54865 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976AbYA3VFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:05:34 -0500
Message-Id: <20080130210526.850796785@goodmis.org>
References: <20080130210357.927754294@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 30 Jan 2008 16:04:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 13/23 -v8] Make the task State char-string visible to all
Content-Disposition: inline; filename=parse-out-task-state-to-char-string.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tracer wants to be able to convert the state number
into a user visible character. This patch pulls that conversion
string out the scheduler into the header. This way if it were to
ever change, other parts of the kernel will know.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/sched.h |    2 ++
 kernel/sched.c        |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-mcount.git/include/linux/sched.h
===================================================================
--- linux-mcount.git.orig/include/linux/sched.h	2008-01-30 14:36:00.000000000 -0500
+++ linux-mcount.git/include/linux/sched.h	2008-01-30 15:26:37.000000000 -0500
@@ -2055,6 +2055,8 @@ static inline void migration_init(void)
 }
 #endif
 
+#define TASK_STATE_TO_CHAR_STR "RSDTtZX"
+
 #endif /* __KERNEL__ */
 
 #endif
Index: linux-mcount.git/kernel/sched.c
===================================================================
--- linux-mcount.git.orig/kernel/sched.c	2008-01-30 15:25:31.000000000 -0500
+++ linux-mcount.git/kernel/sched.c	2008-01-30 15:26:37.000000000 -0500
@@ -5149,7 +5149,7 @@ out_unlock:
 	return retval;
 }
 
-static const char stat_nam[] = "RSDTtZX";
+static const char stat_nam[] = TASK_STATE_TO_CHAR_STR;
 
 void sched_show_task(struct task_struct *p)
 {

-- 
