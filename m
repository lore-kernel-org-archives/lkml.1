Return-Path: <linux-kernel-owner+w=401wt.eu-S932340AbZKZIoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbZKZIoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760002AbZKZIoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:44:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:58728 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759859AbZKZIoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:44:09 -0500
Date: Thu, 26 Nov 2009 08:43:31 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, arjan@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: arjan@infradead.org, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B0E28C2.1090906@cn.fujitsu.com>
References: <4B0E28C2.1090906@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Convert some power events to DEFINE_EVENT
Message-ID: <tip-7703466b4c0a21b88d701882bef0d45bcb0a0281@git.kernel.org>
Git-Commit-ID: 7703466b4c0a21b88d701882bef0d45bcb0a0281
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7703466b4c0a21b88d701882bef0d45bcb0a0281
Gitweb:     http://git.kernel.org/tip/7703466b4c0a21b88d701882bef0d45bcb0a0281
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 26 Nov 2009 15:05:38 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 09:14:03 +0100

tracing: Convert some power events to DEFINE_EVENT

Use DECLARE_EVENT_CLASS to remove duplicate code:

   text    data     bss     dec     hex filename
   4312     524      12    4848    12f0 kernel/trace/power-traces.o.old
   3455     524       8    3987     f93 kernel/trace/power-traces.o

Two events are converted:

  power: power_start, power_frequency

No change in functionality.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>
LKML-Reference: <4B0E28C2.1090906@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/power.h |   36 +++++++++++++++---------------------
 1 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 9bb96e5..c4efe9b 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -16,7 +16,7 @@ enum {
 };
 #endif
 
-TRACE_EVENT(power_start,
+DECLARE_EVENT_CLASS(power,
 
 	TP_PROTO(unsigned int type, unsigned int state),
 
@@ -35,42 +35,36 @@ TRACE_EVENT(power_start,
 	TP_printk("type=%lu state=%lu", (unsigned long)__entry->type, (unsigned long)__entry->state)
 );
 
-TRACE_EVENT(power_end,
-
-	TP_PROTO(int dummy),
+DEFINE_EVENT(power, power_start,
 
-	TP_ARGS(dummy),
+	TP_PROTO(unsigned int type, unsigned int state),
 
-	TP_STRUCT__entry(
-		__field(	u64,		dummy		)
-	),
+	TP_ARGS(type, state)
+);
 
-	TP_fast_assign(
-		__entry->dummy = 0xffff;
-	),
+DEFINE_EVENT(power, power_frequency,
 
-	TP_printk("dummy=%lu", (unsigned long)__entry->dummy)
+	TP_PROTO(unsigned int type, unsigned int state),
 
+	TP_ARGS(type, state)
 );
 
+TRACE_EVENT(power_end,
 
-TRACE_EVENT(power_frequency,
-
-	TP_PROTO(unsigned int type, unsigned int state),
+	TP_PROTO(int dummy),
 
-	TP_ARGS(type, state),
+	TP_ARGS(dummy),
 
 	TP_STRUCT__entry(
-		__field(	u64,		type		)
-		__field(	u64,		state		)
+		__field(	u64,		dummy		)
 	),
 
 	TP_fast_assign(
-		__entry->type = type;
-		__entry->state = state;
+		__entry->dummy = 0xffff;
 	),
 
-	TP_printk("type=%lu state=%lu", (unsigned long)__entry->type, (unsigned long) __entry->state)
+	TP_printk("dummy=%lu", (unsigned long)__entry->dummy)
+
 );
 
 #endif /* _TRACE_POWER_H */
