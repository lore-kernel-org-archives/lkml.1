Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZKMJGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZKMJGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbZKMJGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:06:38 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:64582 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbZKMJG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:06:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aRd//2xD9N8V2YuPlpiY8yjOW5UUqDKgYPIOxAoP7hWn/s7toZp8ZDHC/TLnvFfSsq
         s0dEcuscQF3YyyKSKLqUjr+ECXQ+h5N9reYJZnKg00KTCn2ouPciHU5kJXIbDovzCLEp
         hG2AOtWK59LilCyxPqD2JlbdnWZAMRhR9uKbg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [PATCH] tracing: Rename lockdep event subsystem into lock
Date: Fri, 13 Nov 2009 10:06:34 +0100
Message-Id: <1258103194-843-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20091113085123.GA1318@elte.hu>
References: <20091113085123.GA1318@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lockdep events subsystem gathers various locking related events such
as a request, release, contention or acquisition of a lock.

The name of this event subsystem is a bit of a misnomer since these
events are not quite related to lockdep but more generally to locking,
ie: these events are not reporting lock dependencies or possible
deadlock scenario but pure locking events.

Hence this rename.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 include/trace/events/{lockdep.h => lock.h} |    8 ++++----
 kernel/lockdep.c                           |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)
 rename include/trace/events/{lockdep.h => lock.h} (92%)

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
-- 
1.6.2.3

