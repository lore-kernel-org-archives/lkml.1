Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbZJFGKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbZJFGKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 02:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756208AbZJFGKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 02:10:43 -0400
Received: from mail-yx0-f173.google.com ([209.85.210.173]:42675 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304AbZJFGKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 02:10:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sJvCqvZDB+AdFLefnTITviAQY+ceKluaZhpWhZGuA1BA929rPwEJ/ttSoC6og6impz
         0hABB+bV4q5mo0y0ZdzOuDfnqjEQ97nsVyc3niLYqXKnWUqQJzdSFGZEzshR9GIBDl3V
         Xhu3t1gAhl7G9vZZM2UgDSFYtY/AD7tFKURJg=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, hch@infradead.org
Subject: [RFC][PATCH 2/9] perf trace: Add subsystem string to struct event
Date: Tue,  6 Oct 2009 01:09:51 -0500
Message-Id: <1254809398-8078-3-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed to fully qualify event names for event stream processing.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
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
 
-- 
1.6.4.GIT

