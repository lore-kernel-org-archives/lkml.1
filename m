Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657Ab0AMKf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab0AMKf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611Ab0AMKfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:35:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:34600 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755597Ab0AMKfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:35:24 -0500
Date: Wed, 13 Jan 2010 10:33:41 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       dle-develop@lists.sourceforge.net, rostedt@goodmis.org,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
In-Reply-To: <20100105224641.19431.34967.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100105224641.19431.34967.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/kprobe: Update example output in documentation
Message-ID: <tip-ec3a9039601af210fca4650d229621fe5a21df0b@git.kernel.org>
Git-Commit-ID: ec3a9039601af210fca4650d229621fe5a21df0b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:33:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec3a9039601af210fca4650d229621fe5a21df0b
Gitweb:     http://git.kernel.org/tip/ec3a9039601af210fca4650d229621fe5a21df0b
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 5 Jan 2010 17:46:41 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 10:09:11 +0100

tracing/kprobe: Update example output in documentation

Update example output in documentation according to current
implementation.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100105224641.19431.34967.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/trace/kprobetrace.txt |   33 +++++++++++++++++----------------
 1 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index 47aabee..c3eff6f 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -97,23 +97,24 @@ recording return value as "myretprobe" event.
 
   cat /sys/kernel/debug/tracing/events/kprobes/myprobe/format
 name: myprobe
-ID: 75
+ID: 780
 format:
-	field:unsigned short common_type;	offset:0;	size:2;
-	field:unsigned char common_flags;	offset:2;	size:1;
-	field:unsigned char common_preempt_count;	offset:3;	size:1;
-	field:int common_pid;	offset:4;	size:4;
-	field:int common_tgid;	offset:8;	size:4;
-
-	field: unsigned long ip;	offset:16;tsize:8;
-	field: int nargs;	offset:24;tsize:4;
-	field: unsigned long dfd;	offset:32;tsize:8;
-	field: unsigned long filename;	offset:40;tsize:8;
-	field: unsigned long flags;	offset:48;tsize:8;
-	field: unsigned long mode;	offset:56;tsize:8;
-
-print fmt: "(%lx) dfd=%lx filename=%lx flags=%lx mode=%lx", REC->ip, REC->dfd, REC->filename, REC->flags, REC->mode
-
+        field:unsigned short common_type;       offset:0;       size:2; signed:0;
+        field:unsigned char common_flags;       offset:2;       size:1; signed:0;
+        field:unsigned char common_preempt_count;       offset:3; size:1;signed:0;
+        field:int common_pid;   offset:4;       size:4; signed:1;
+        field:int common_lock_depth;    offset:8;       size:4; signed:1;
+
+        field:unsigned long __probe_ip; offset:12;      size:4; signed:0;
+        field:int __probe_nargs;        offset:16;      size:4; signed:1;
+        field:unsigned long dfd;        offset:20;      size:4; signed:0;
+        field:unsigned long filename;   offset:24;      size:4; signed:0;
+        field:unsigned long flags;      offset:28;      size:4; signed:0;
+        field:unsigned long mode;       offset:32;      size:4; signed:0;
+
+
+print fmt: "(%lx) dfd=%lx filename=%lx flags=%lx mode=%lx", REC->__probe_ip,
+REC->dfd, REC->filename, REC->flags, REC->mode
 
  You can see that the event has 4 arguments as in the expressions you specified.
 
