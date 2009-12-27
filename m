Return-Path: <linux-kernel-owner+w=401wt.eu-S1751304AbZL0Xir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbZL0Xir (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 18:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbZL0XhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 18:37:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56324 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbZL0XhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 18:37:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 09/10] perf session: Remove redundant prefix & suffix from perf_event_ops
Date: Sun, 27 Dec 2009 21:37:05 -0200
Message-Id: <1261957026-15580-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1261957026-15580-1-git-send-email-acme@infradead.org>
References: <1261957026-15580-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Since now all that we have are perf event handlers, leave just the name
of the event.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c  |    8 +++---
 tools/perf/builtin-diff.c      |   12 ++++----
 tools/perf/builtin-kmem.c      |    4 +-
 tools/perf/builtin-report.c    |   14 +++++-----
 tools/perf/builtin-sched.c     |    6 ++--
 tools/perf/builtin-timechart.c |    8 +++---
 tools/perf/builtin-trace.c     |    4 +-
 tools/perf/util/session.c      |   54 ++++++++++++++++++++--------------------
 tools/perf/util/session.h      |   18 ++++++------
 9 files changed, 64 insertions(+), 64 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 593ff25..117bbae 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -451,10 +451,10 @@ static void perf_session__find_annotations(struct perf_session *self)
 }
 
 static struct perf_event_ops event_ops = {
-	.process_sample_event	= process_sample_event,
-	.process_mmap_event	= event__process_mmap,
-	.process_comm_event	= event__process_comm,
-	.process_fork_event	= event__process_task,
+	.sample	= process_sample_event,
+	.mmap	= event__process_mmap,
+	.comm	= event__process_comm,
+	.fork	= event__process_task,
 };
 
 static int __cmd_annotate(void)
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index e164b3d..1cbecaf 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -66,12 +66,12 @@ static int diff__process_sample_event(event_t *event, struct perf_session *sessi
 }
 
 static struct perf_event_ops event_ops = {
-	.process_sample_event = diff__process_sample_event,
-	.process_mmap_event   = event__process_mmap,
-	.process_comm_event   = event__process_comm,
-	.process_exit_event   = event__process_task,
-	.process_fork_event   = event__process_task,
-	.process_lost_event   = event__process_lost,
+	.sample	= diff__process_sample_event,
+	.mmap	= event__process_mmap,
+	.comm	= event__process_comm,
+	.exit	= event__process_task,
+	.fork	= event__process_task,
+	.lost	= event__process_lost,
 };
 
 static void perf_session__insert_hist_entry_by_name(struct rb_root *root,
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 73b0650..4c06828 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -343,8 +343,8 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 }
 
 static struct perf_event_ops event_ops = {
-	.process_sample_event	= process_sample_event,
-	.process_comm_event	= event__process_comm,
+	.sample	= process_sample_event,
+	.comm	= event__process_comm,
 };
 
 static double fragmentation(unsigned long n_req, unsigned long n_alloc)
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f695084..508934b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -184,13 +184,13 @@ static int perf_session__setup_sample_type(struct perf_session *self)
 }
 
 static struct perf_event_ops event_ops = {
-	.process_sample_event	= process_sample_event,
-	.process_mmap_event	= event__process_mmap,
-	.process_comm_event	= event__process_comm,
-	.process_exit_event	= event__process_task,
-	.process_fork_event	= event__process_task,
-	.process_lost_event	= event__process_lost,
-	.process_read_event	= process_read_event,
+	.sample	= process_sample_event,
+	.mmap	= event__process_mmap,
+	.comm	= event__process_comm,
+	.exit	= event__process_task,
+	.fork	= event__process_task,
+	.lost	= event__process_lost,
+	.read	= process_read_event,
 };
 
 static int __cmd_report(void)
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index e862e71..702322f 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1654,9 +1654,9 @@ static int process_lost_event(event_t *event __used,
 }
 
 static struct perf_event_ops event_ops = {
-	.process_sample_event	= process_sample_event,
-	.process_comm_event	= event__process_comm,
-	.process_lost_event	= process_lost_event,
+	.sample	= process_sample_event,
+	.comm	= event__process_comm,
+	.lost	= process_lost_event,
 };
 
 static int read_events(void)
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 8252837..5b68d81 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1030,10 +1030,10 @@ static void process_samples(struct perf_session *session)
 }
 
 static struct perf_event_ops event_ops = {
-	.process_comm_event	= process_comm_event,
-	.process_fork_event	= process_fork_event,
-	.process_exit_event	= process_exit_event,
-	.process_sample_event	= queue_sample_event,
+	.comm	= process_comm_event,
+	.fork	= process_fork_event,
+	.exit	= process_exit_event,
+	.sample	= queue_sample_event,
 };
 
 static int __cmd_timechart(void)
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index e94f346..1831434 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -104,8 +104,8 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 }
 
 static struct perf_event_ops event_ops = {
-	.process_sample_event	= process_sample_event,
-	.process_comm_event	= event__process_comm,
+	.sample	= process_sample_event,
+	.comm	= event__process_comm,
 };
 
 static int __cmd_trace(struct perf_session *session)
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 4f2eeb5..7f0537d 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -161,24 +161,24 @@ static int process_event_stub(event_t *event __used,
 
 static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 {
-	if (handler->process_sample_event == NULL)
-		handler->process_sample_event = process_event_stub;
-	if (handler->process_mmap_event == NULL)
-		handler->process_mmap_event = process_event_stub;
-	if (handler->process_comm_event == NULL)
-		handler->process_comm_event = process_event_stub;
-	if (handler->process_fork_event == NULL)
-		handler->process_fork_event = process_event_stub;
-	if (handler->process_exit_event == NULL)
-		handler->process_exit_event = process_event_stub;
-	if (handler->process_lost_event == NULL)
-		handler->process_lost_event = process_event_stub;
-	if (handler->process_read_event == NULL)
-		handler->process_read_event = process_event_stub;
-	if (handler->process_throttle_event == NULL)
-		handler->process_throttle_event = process_event_stub;
-	if (handler->process_unthrottle_event == NULL)
-		handler->process_unthrottle_event = process_event_stub;
+	if (handler->sample == NULL)
+		handler->sample = process_event_stub;
+	if (handler->mmap == NULL)
+		handler->mmap = process_event_stub;
+	if (handler->comm == NULL)
+		handler->comm = process_event_stub;
+	if (handler->fork == NULL)
+		handler->fork = process_event_stub;
+	if (handler->exit == NULL)
+		handler->exit = process_event_stub;
+	if (handler->lost == NULL)
+		handler->lost = process_event_stub;
+	if (handler->read == NULL)
+		handler->read = process_event_stub;
+	if (handler->throttle == NULL)
+		handler->throttle = process_event_stub;
+	if (handler->unthrottle == NULL)
+		handler->unthrottle = process_event_stub;
 }
 
 static const char *event__name[] = {
@@ -222,23 +222,23 @@ static int perf_session__process_event(struct perf_session *self,
 
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
-		return ops->process_sample_event(event, self);
+		return ops->sample(event, self);
 	case PERF_RECORD_MMAP:
-		return ops->process_mmap_event(event, self);
+		return ops->mmap(event, self);
 	case PERF_RECORD_COMM:
-		return ops->process_comm_event(event, self);
+		return ops->comm(event, self);
 	case PERF_RECORD_FORK:
-		return ops->process_fork_event(event, self);
+		return ops->fork(event, self);
 	case PERF_RECORD_EXIT:
-		return ops->process_exit_event(event, self);
+		return ops->exit(event, self);
 	case PERF_RECORD_LOST:
-		return ops->process_lost_event(event, self);
+		return ops->lost(event, self);
 	case PERF_RECORD_READ:
-		return ops->process_read_event(event, self);
+		return ops->read(event, self);
 	case PERF_RECORD_THROTTLE:
-		return ops->process_throttle_event(event, self);
+		return ops->throttle(event, self);
 	case PERF_RECORD_UNTHROTTLE:
-		return ops->process_unthrottle_event(event, self);
+		return ops->unthrottle(event, self);
 	default:
 		self->unknown_events++;
 		return -1;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 2ff77fe..77c5ee2 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -32,15 +32,15 @@ struct perf_session {
 typedef int (*event_op)(event_t *self, struct perf_session *session);
 
 struct perf_event_ops {
-	event_op	process_sample_event;
-	event_op	process_mmap_event;
-	event_op	process_comm_event;
-	event_op	process_fork_event;
-	event_op	process_exit_event;
-	event_op	process_lost_event;
-	event_op	process_read_event;
-	event_op	process_throttle_event;
-	event_op	process_unthrottle_event;
+	event_op sample,
+		 mmap,
+		 comm,
+		 fork,
+		 exit,
+		 lost,
+		 read,
+		 throttle,
+		 unthrottle;
 };
 
 struct perf_session *perf_session__new(const char *filename, int mode, bool force);
-- 
1.6.2.5

