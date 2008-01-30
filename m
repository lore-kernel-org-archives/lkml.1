Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbYA3DWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbYA3DWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 22:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbYA3DTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 22:19:04 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:49350 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbYA3DSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 22:18:49 -0500
Message-Id: <20080130031841.972414785@goodmis.org>
References: <20080130031521.258552785@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jan 2008 22:15:33 -0500
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
Subject: [PATCH 12/22 -v7] Make the task State char-string visible to all
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
--- linux-mcount.git.orig/include/linux/sched.h	2008-01-25 21:46:55.000000000 -0500
+++ linux-mcount.git/include/linux/sched.h	2008-01-25 21:47:21.000000000 -0500
@@ -2055,6 +2055,8 @@ static inline void migration_init(void)
 }
 #endif
 
+#define TASK_STATE_TO_CHAR_STR "RSDTtZX"
+
 #endif /* __KERNEL__ */
 
 #endif
Index: linux-mcount.git/kernel/sched.c
===================================================================
--- linux-mcount.git.orig/kernel/sched.c	2008-01-25 21:47:19.000000000 -0500
+++ linux-mcount.git/kernel/sched.c	2008-01-25 21:47:21.000000000 -0500
@@ -5149,7 +5149,7 @@ out_unlock:
 	return retval;
 }
 
-static const char stat_nam[] = "RSDTtZX";
+static const char stat_nam[] = TASK_STATE_TO_CHAR_STR;
 
 void sched_show_task(struct task_struct *p)
 {

-- 
