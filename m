Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbZJFNIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbZJFNIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757269AbZJFNIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:08:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:43899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757268AbZJFNIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:08:02 -0400
Date: Tue, 6 Oct 2009 13:06:55 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1254809398-8078-3-git-send-email-tzanussi@gmail.com>
References: <1254809398-8078-3-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Add subsystem string to struct event
Message-ID: <tip-2774601811bedd04ee7e38624343ea80b4a62d7e@git.kernel.org>
Git-Commit-ID: 2774601811bedd04ee7e38624343ea80b4a62d7e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 06 Oct 2009 13:06:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2774601811bedd04ee7e38624343ea80b4a62d7e
Gitweb:     http://git.kernel.org/tip/2774601811bedd04ee7e38624343ea80b4a62d7e
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Tue, 6 Oct 2009 01:09:51 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Oct 2009 15:04:46 +0200

perf trace: Add subsystem string to struct event

Needed to fully qualify event names for event stream processing.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org
Cc: lizf@cn.fujitsu.com
Cc: hch@infradead.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1254809398-8078-3-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/trace-event-parse.c |    4 +++-
 tools/perf/util/trace-event.h       |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index be8412d..de3fc8b 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -2950,7 +2950,7 @@ int parse_ftrace_file(char *buf, unsigned long size)
 	return 0;
 }
 
-int parse_event_file(char *buf, unsigned long size, char *system__unused __unused)
+int parse_event_file(char *buf, unsigned long size, char *sys)
 {
 	struct event *event;
 	int ret;
@@ -2977,6 +2977,8 @@ int parse_event_file(char *buf, unsigned long size, char *system__unused __unuse
 	if (ret < 0)
 		die("failed to read event print fmt");
 
+	event->system = strdup(sys);
+
 #define PRINT_ARGS 0
 	if (PRINT_ARGS && event->print_fmt.args)
 		print_args(event->print_fmt.args);
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 00b440d..cb92978 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -133,6 +133,7 @@ struct event {
 	int			flags;
 	struct format		format;
 	struct print_fmt	print_fmt;
+	char			*system;
 };
 
 enum {
@@ -167,7 +168,7 @@ void print_funcs(void);
 void print_printk(void);
 
 int parse_ftrace_file(char *buf, unsigned long size);
-int parse_event_file(char *buf, unsigned long size, char *system);
+int parse_event_file(char *buf, unsigned long size, char *sys);
 void print_event(int cpu, void *data, int size, unsigned long long nsecs,
 		  char *comm);
 
