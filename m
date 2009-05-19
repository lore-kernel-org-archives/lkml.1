Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZESIcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZESIcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 04:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZESIcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 04:32:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:60745 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbZESIcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 04:32:07 -0400
Date: Tue, 19 May 2009 08:31:12 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, tytso@mit.edu, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, tytso@mit.edu, mingo@elte.hu
In-Reply-To: <4A125503.5060406@cn.fujitsu.com>
References: <4A125503.5060406@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/events: Documentation updates
Message-ID: <tip-143c145e3a475065a4be661468d0df1bd0b25f74@git.kernel.org>
Git-Commit-ID: 143c145e3a475065a4be661468d0df1bd0b25f74
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 19 May 2009 08:31:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  143c145e3a475065a4be661468d0df1bd0b25f74
Gitweb:     http://git.kernel.org/tip/143c145e3a475065a4be661468d0df1bd0b25f74
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 19 May 2009 14:43:15 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 19 May 2009 10:29:21 +0200

tracing/events: Documentation updates

- fix some typos
- document the difference between '>' and '>>'
- document the 'enable' toggle
- remove section "Defining an event-enabled tracepoint", since it's
  out-dated and sample/trace_events/ already serves this purpose.

v2: add "Updated by Li Zefan"

[ Impact: make documentation up-to-date ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
LKML-Reference: <4A125503.5060406@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/trace/events.txt |  159 ++++++++++++++-------------------------
 1 files changed, 57 insertions(+), 102 deletions(-)

diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index abdee66..f157d75 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -1,9 +1,10 @@
 			     Event Tracing
 
 		Documentation written by Theodore Ts'o
+			Updated by Li Zefan
 
-Introduction
-============
+1. Introduction
+===============
 
 Tracepoints (see Documentation/trace/tracepoints.txt) can be used
 without creating custom kernel modules to register probe functions
@@ -12,30 +13,37 @@ using the event tracing infrastructure.
 Not all tracepoints can be traced using the event tracing system;
 the kernel developer must provide code snippets which define how the
 tracing information is saved into the tracing buffer, and how the
-the tracing information should be printed.
+tracing information should be printed.
 
-Using Event Tracing
-===================
+2. Using Event Tracing
+======================
+
+2.1 Via the 'set_event' interface
+---------------------------------
 
 The events which are available for tracing can be found in the file
-/sys/kernel/debug/tracing/available_events.
+/debug/tracing/available_events.
 
 To enable a particular event, such as 'sched_wakeup', simply echo it
-to /sys/debug/tracing/set_event. For example:
+to /debug/tracing/set_event. For example:
 
-	# echo sched_wakeup > /sys/kernel/debug/tracing/set_event
+	# echo sched_wakeup >> /debug/tracing/set_event
 
-[ Note: events can also be enabled/disabled via the 'enabled' toggle
-  found in the /sys/kernel/tracing/events/ hierarchy of directories. ]
+[ Note: '>>' is necessary, otherwise it will firstly disable
+  all the events. ]
 
 To disable an event, echo the event name to the set_event file prefixed
 with an exclamation point:
 
-	# echo '!sched_wakeup' >> /sys/kernel/debug/tracing/set_event
+	# echo '!sched_wakeup' >> /debug/tracing/set_event
+
+To disable all events, echo an empty line to the set_event file:
+
+	# echo > /debug/tracing/set_event
 
-To disable events, echo an empty line to the set_event file:
+To enable all events, echo '*:*' or '*:' to the set_event file:
 
-	# echo > /sys/kernel/debug/tracing/set_event
+	# echo *:* > /debug/tracing/set_event
 
 The events are organized into subsystems, such as ext4, irq, sched,
 etc., and a full event name looks like this: <subsystem>:<event>.  The
@@ -44,92 +52,39 @@ file.  All of the events in a subsystem can be specified via the syntax
 "<subsystem>:*"; for example, to enable all irq events, you can use the
 command:
 
-	# echo 'irq:*' > /sys/kernel/debug/tracing/set_event
-
-Defining an event-enabled tracepoint
-------------------------------------
-
-A kernel developer which wishes to define an event-enabled tracepoint
-must declare the tracepoint using TRACE_EVENT instead of DECLARE_TRACE.
-This is done via two header files in include/trace.  For example, to
-event-enable the jbd2 subsystem, we must create two files,
-include/trace/jbd2.h and include/trace/jbd2_event_types.h.  The
-include/trace/jbd2.h file should be included by kernel source files that
-will have a tracepoint inserted, and might look like this:
-
-#ifndef _TRACE_JBD2_H
-#define _TRACE_JBD2_H
-
-#include <linux/jbd2.h>
-#include <linux/tracepoint.h>
-
-#include <trace/jbd2_event_types.h>
-
-#endif
-
-In a file that utilizes a jbd2 tracepoint, this header file would be
-included.  Note that you still have to use DEFINE_TRACE().  So for
-example, if fs/jbd2/commit.c planned to use the jbd2_start_commit
-tracepoint, it would have the following near the beginning of the file:
-
-#include <trace/jbd2.h>
-
-DEFINE_TRACE(jbd2_start_commit);
-
-Then in the function that would call the tracepoint, it would call the
-tracepoint function.  (For more information, please see the tracepoint
-documentation in Documentation/trace/tracepoints.txt):
-
-	trace_jbd2_start_commit(journal, commit_transaction);
-
-The code snippets which allow jbd2_start_commit to be an event-enabled
-tracepoint are placed in the file include/trace/jbd2_event_types.h:
-
-/* use <trace/jbd2.h> instead */
-#ifndef TRACE_EVENT
-# error Do not include this file directly.
-# error Unless you know what you are doing.
-#endif
-
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM jbd2
-
-#include <linux/jbd2.h>
-
-TRACE_EVENT(jbd2_start_commit,
-	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
-	TP_ARGS(journal, commit_transaction),
-	TP_STRUCT__entry(
-		__array(	char,	devname, BDEVNAME_SIZE+24 )
-		__field(	int,	transaction		  )
-	),
-	TP_fast_assign(
-		memcpy(__entry->devname, journal->j_devname, BDEVNAME_SIZE+24);
-		__entry->transaction	= commit_transaction->t_tid;
-	),
-	TP_printk("dev %s transaction %d",
-		  __entry->devname, __entry->transaction)
-);
-
-The TP_PROTO and TP_ARGS are unchanged from DECLARE_TRACE.  The new
-arguments to TRACE_EVENT are TP_STRUCT__entry, TP_fast_assign, and
-TP_printk.
-
-TP_STRUCT__entry defines the data structure which will be stored in the
-trace buffer.  Normally, fields in __entry will be arrays or simple
-types.  It is possible to place data structures in __entry --- however,
-pointers in the data structure can not be trusted, since they will be
-accessed sometime later by TP_printk, and if the data structure contains
-fields that will not or cannot be used by TP_printk, this will waste
-space in the trace buffer.  In general, data structures should be
-avoided, unless they do only contain non-pointer types and all of the
-fields will be used by TP_printk.
-
-TP_fast_assign defines the code snippet which saves information into the
-__entry data structure, using the passed-in arguments defined in
-TP_PROTO and TP_ARGS.
-
-Finally, TP_printk will print the __entry data structure.  At the time
-when the code snippet defined by TP_printk is executed, it will not have
-access to the TP_ARGS arguments; it can only use the information saved
-in the __entry data structure.
+	# echo 'irq:*' > /debug/tracing/set_event
+
+2.2 Via the 'enable' toggle
+---------------------------
+
+The events available are also listed in /debug/tracing/events/ hierarchy
+of directories.
+
+To enable event 'sched_wakeup':
+
+	# echo 1 > /debug/tracing/events/sched/sched_wakeup/enable
+
+To disable it:
+
+	# echo 0 > /debug/tracing/events/sched/sched_wakeup/enable
+
+To enable all events in sched subsystem:
+
+	# echo 1 > /debug/tracing/events/sched/enable
+
+To eanble all events:
+
+	# echo 1 > /debug/tracing/events/enable
+
+When reading one of these enable files, there are four results:
+
+ 0 - all events this file affects are disabled
+ 1 - all events this file affects are enabled
+ X - there is a mixture of events enabled and disabled
+ ? - this file does not affect any event
+
+3. Defining an event-enabled tracepoint
+=======================================
+
+See The example provided in samples/trace_events
+
