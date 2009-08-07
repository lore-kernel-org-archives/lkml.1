Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbZHGQTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbZHGQTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 12:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbZHGQTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 12:19:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:58206 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbZHGQTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 12:19:44 -0400
Date: Fri, 7 Aug 2009 16:18:36 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, lizf@cn.fujitsu.com,
       penberg@cs.helsinki.fi, a.p.zijlstra@chello.nl, efault@gmx.de,
       eduard.munteanu@linux360.ro, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, lizf@cn.fujitsu.com, efault@gmx.de,
       eduard.munteanu@linux360.ro, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <1249660478.32113.736.camel@twins>
References: <1249660478.32113.736.camel@twins>
Subject: [tip:perfcounters/core] perfcounters: Support for ftrace event records sampling, fix modules
Message-ID: <tip-11c1870ca7e8dfede9f8aab654814a7a67378857@git.kernel.org>
Git-Commit-ID: 11c1870ca7e8dfede9f8aab654814a7a67378857
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 07 Aug 2009 16:18:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11c1870ca7e8dfede9f8aab654814a7a67378857
Gitweb:     http://git.kernel.org/tip/11c1870ca7e8dfede9f8aab654814a7a67378857
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 7 Aug 2009 17:54:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Aug 2009 18:14:58 +0200

perfcounters: Support for ftrace event records sampling, fix modules

Fix:

  ERROR: "tracing_generic_entry_update" [fs/jbd2/jbd2.ko] undefined!
  ERROR: "tracing_generic_entry_update" [fs/ext4/ext4.ko] undefined!

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1249660478.32113.736.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8930e39..c22b40f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -848,6 +848,7 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
 		(need_resched() ? TRACE_FLAG_NEED_RESCHED : 0);
 }
+EXPORT_SYMBOL_GPL(tracing_generic_entry_update);
 
 struct ring_buffer_event *trace_buffer_lock_reserve(struct trace_array *tr,
 						    int type,
