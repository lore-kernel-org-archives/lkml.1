Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbZKHP3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbZKHP3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZKHP3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:29:22 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:63949 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbZKHP3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:29:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=v5fmVRVu0GREyRJb1pcScYbUh6Biyjg7qpOFiDMiwwjtkiNL9wzU0xV/TRvTS/iSz5
         8VIk1doY7Q7iDoDGK0RhWsofs9vIYoUJVBX2AKhN/OnFFj9IYH980UAx8KKLiymbB/xV
         0YaLK0OJDOezE4HOutp9m7MPvKHWQ/DOTpFoo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 7/7 v6] ksym_tracer: Remove KSYM_SELFTEST_ENTRY
Date: Sun,  8 Nov 2009 16:29:01 +0100
Message-Id: <1257694141-5670-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1257694141-5670-1-git-send-email-fweisbec@gmail.com>
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

The macro used to be used in both trace_selftest.c and
trace_ksym.c, but no longer, so remove it from header file.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.h          |    1 -
 kernel/trace/trace_selftest.c |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index d72f06f..ee00475 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -367,7 +367,6 @@ int register_tracer(struct tracer *type);
 void unregister_tracer(struct tracer *type);
 int is_tracing_stopped(void);
 
-#define KSYM_SELFTEST_ENTRY "ksym_selftest_dummy"
 extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
 
 extern unsigned long nsecs_to_usecs(unsigned long nsecs);
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 27c5072..dc98309 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -828,7 +828,8 @@ trace_selftest_startup_ksym(struct tracer *trace, struct trace_array *tr)
 
 	ksym_selftest_dummy = 0;
 	/* Register the read-write tracing request */
-	ret = process_new_ksym_entry(KSYM_SELFTEST_ENTRY,
+
+	ret = process_new_ksym_entry("ksym_selftest_dummy",
 				     HW_BREAKPOINT_R | HW_BREAKPOINT_W,
 					(unsigned long)(&ksym_selftest_dummy));
 
-- 
1.6.2.3

