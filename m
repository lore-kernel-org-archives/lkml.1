Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbZKMJ6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbZKMJ6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755787AbZKMJ6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:58:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:51986 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752AbZKMJ6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:58:07 -0500
Date: Fri, 13 Nov 2009 09:57:38 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, lizf@cn.fujitsu.com, efault@gmx.de,
       peterz@infradead.org, mitake@dcl.info.waseda.ac.jp, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, peterz@infradead.org,
       efault@gmx.de, mitake@dcl.info.waseda.ac.jp, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258103194-843-1-git-send-email-fweisbec@gmail.com>
References: <1258103194-843-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Rename 'lockdep' event subsystem into 'lock'
Message-ID: <tip-67178767b936fb47a3a5e88097cff41ccbda7acb@git.kernel.org>
Git-Commit-ID: 67178767b936fb47a3a5e88097cff41ccbda7acb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67178767b936fb47a3a5e88097cff41ccbda7acb
Gitweb:     http://git.kernel.org/tip/67178767b936fb47a3a5e88097cff41ccbda7acb
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 13 Nov 2009 10:06:34 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Nov 2009 10:48:27 +0100

tracing: Rename 'lockdep' event subsystem into 'lock'

Lockdep events subsystem gathers various locking related events
such as a request, release, contention or acquisition of a lock.

The name of this event subsystem is a bit of a misnomer since
these events are not quite related to lockdep but more generally
to locking, ie: these events are not reporting lock dependencies
or possible deadlock scenario but pure locking events.

Hence this rename.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <1258103194-843-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/{lockdep.h => lock.h} |    8 ++++----
 kernel/lockdep.c                           |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/lockdep.h b/include/trace/events/lock.h
similarity index 92%
rename from include/trace/events/lockdep.h
rename to include/trace/events/lock.h
index bcf1d20..a870ba1 100644
--- a/include/trace/events/lockdep.h
+++ b/include/trace/events/lock.h
@@ -1,8 +1,8 @@
 #undef TRACE_SYSTEM
-#define TRACE_SYSTEM lockdep
+#define TRACE_SYSTEM lock
 
-#if !defined(_TRACE_LOCKDEP_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_LOCKDEP_H
+#if !defined(_TRACE_LOCK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_LOCK_H
 
 #include <linux/lockdep.h>
 #include <linux/tracepoint.h>
@@ -90,7 +90,7 @@ TRACE_EVENT(lock_acquired,
 #endif
 #endif
 
-#endif /* _TRACE_LOCKDEP_H */
+#endif /* _TRACE_LOCK_H */
 
 /* This part must be outside protection */
 #include <trace/define_trace.h>
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 9af5672..f5dcd36 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -49,7 +49,7 @@
 #include "lockdep_internals.h"
 
 #define CREATE_TRACE_POINTS
-#include <trace/events/lockdep.h>
+#include <trace/events/lock.h>
 
 #ifdef CONFIG_PROVE_LOCKING
 int prove_locking = 1;
