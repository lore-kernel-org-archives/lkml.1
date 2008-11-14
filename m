Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbYKNXEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbYKNXEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbYKNXAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:00:52 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:57254 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072AbYKNXAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:00:51 -0500
Message-Id: <20081114224948.787822158@polymtl.ca>
References: <20081114224733.364965865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 17:47:43 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [patch 10/16] Tracepoints use rcu_*_sched_notrace
Content-Disposition: inline; filename=tracepoints-use-rcu-sched-notrace.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 14 Nov 2008 23:00:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure tracepoints can be called within ftrace callbacks.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Masami Hiramatsu <mhiramat@redhat.com>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
---
 include/linux/tracepoint.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/include/linux/tracepoint.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/tracepoint.h	2008-10-08 10:45:30.000000000 -0400
+++ linux-2.6-lttng/include/linux/tracepoint.h	2008-10-08 10:45:34.000000000 -0400
@@ -40,14 +40,14 @@ struct tracepoint {
 	do {								\
 		void **it_func;						\
 									\
-		rcu_read_lock_sched();					\
+		rcu_read_lock_sched_notrace();				\
 		it_func = rcu_dereference((tp)->funcs);			\
 		if (it_func) {						\
 			do {						\
 				((void(*)(proto))(*it_func))(args);	\
 			} while (*(++it_func));				\
 		}							\
-		rcu_read_unlock_sched();				\
+		rcu_read_unlock_sched_notrace();			\
 	} while (0)
 
 /*

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
