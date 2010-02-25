Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab0BYKHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:07:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:47452 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab0BYKHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:07:38 -0500
Date: Thu, 25 Feb 2010 10:07:10 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1264580883-15324-4-git-send-email-tzanussi@gmail.com>
References: <1264580883-15324-4-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/scripts: Move common code out of Perl-specific files
Message-ID: <tip-7397d80ddde8eef3b1dce6c29e0c53bd322ef824@git.kernel.org>
Git-Commit-ID: 7397d80ddde8eef3b1dce6c29e0c53bd322ef824
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:07:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7397d80ddde8eef3b1dce6c29e0c53bd322ef824
Gitweb:     http://git.kernel.org/tip/7397d80ddde8eef3b1dce6c29e0c53bd322ef824
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Wed, 27 Jan 2010 02:27:54 -0600
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 23 Feb 2010 20:37:29 +0100

perf/scripts: Move common code out of Perl-specific files

This stuff is needed by all scripting engines; move it from the Perl
engine source to a more common place.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Keiichi KII <k-keiichi@bx.jp.nec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1264580883-15324-4-git-send-email-tzanussi@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |    5 ++-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |    3 +-
 tools/perf/util/trace-event-parse.c                |   15 +++++++++++
 tools/perf/util/trace-event-perl.c                 |   27 --------------------
 tools/perf/util/trace-event-perl.h                 |    8 ------
 tools/perf/util/trace-event.h                      |    9 ++++++-
 6 files changed, 28 insertions(+), 39 deletions(-)

diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
index af78d9a..01a64ad 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
@@ -31,13 +31,14 @@
 #include "EXTERN.h"
 #include "perl.h"
 #include "XSUB.h"
-#include "../../../util/trace-event-perl.h"
+#include "../../../perf.h"
+#include "../../../util/trace-event.h"
 
 #ifndef PERL_UNUSED_VAR
 #  define PERL_UNUSED_VAR(var) if (0) var = var
 #endif
 
-#line 41 "Context.c"
+#line 42 "Context.c"
 
 XS(XS_Perf__Trace__Context_common_pc); /* prototype to pass -Wmissing-prototypes */
 XS(XS_Perf__Trace__Context_common_pc)
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
index fb78006..549cf04 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
@@ -22,7 +22,8 @@
 #include "EXTERN.h"
 #include "perl.h"
 #include "XSUB.h"
-#include "../../../util/trace-event-perl.h"
+#include "../../../perf.h"
+#include "../../../util/trace-event.h"
 
 MODULE = Perf::Trace::Context		PACKAGE = Perf::Trace::Context
 PROTOTYPES: ENABLE
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index c4b3cb8..9b3c20f 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -3286,3 +3286,18 @@ void parse_set_info(int nr_cpus, int long_sz)
 	cpus = nr_cpus;
 	long_size = long_sz;
 }
+
+int common_pc(struct scripting_context *context)
+{
+	return parse_common_pc(context->event_data);
+}
+
+int common_flags(struct scripting_context *context)
+{
+	return parse_common_flags(context->event_data);
+}
+
+int common_lock_depth(struct scripting_context *context)
+{
+	return parse_common_lock_depth(context->event_data);
+}
diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/trace-event-perl.c
index 6d6d76b..5b49df0 100644
--- a/tools/perf/util/trace-event-perl.c
+++ b/tools/perf/util/trace-event-perl.c
@@ -239,33 +239,6 @@ static inline struct event *find_cache_event(int type)
 	return event;
 }
 
-int common_pc(struct scripting_context *context)
-{
-	int pc;
-
-	pc = parse_common_pc(context->event_data);
-
-	return pc;
-}
-
-int common_flags(struct scripting_context *context)
-{
-	int flags;
-
-	flags = parse_common_flags(context->event_data);
-
-	return flags;
-}
-
-int common_lock_depth(struct scripting_context *context)
-{
-	int lock_depth;
-
-	lock_depth = parse_common_lock_depth(context->event_data);
-
-	return lock_depth;
-}
-
 static void perl_process_event(int cpu, void *data,
 			       int size __unused,
 			       unsigned long long nsecs, char *comm)
diff --git a/tools/perf/util/trace-event-perl.h b/tools/perf/util/trace-event-perl.h
index e88fb26..01efcc9 100644
--- a/tools/perf/util/trace-event-perl.h
+++ b/tools/perf/util/trace-event-perl.h
@@ -44,12 +44,4 @@ void boot_DynaLoader(pTHX_ CV *cv);
 typedef PerlInterpreter * INTERP;
 #endif
 
-struct scripting_context {
-	void *event_data;
-};
-
-int common_pc(struct scripting_context *context);
-int common_flags(struct scripting_context *context);
-int common_lock_depth(struct scripting_context *context);
-
 #endif /* __PERF_TRACE_EVENT_PERL_H */
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 6ad4056..aaf2da2 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -279,7 +279,14 @@ struct scripting_ops {
 
 int script_spec_register(const char *spec, struct scripting_ops *ops);
 
-extern struct scripting_ops perl_scripting_ops;
 void setup_perl_scripting(void);
 
+struct scripting_context {
+	void *event_data;
+};
+
+int common_pc(struct scripting_context *context);
+int common_flags(struct scripting_context *context);
+int common_lock_depth(struct scripting_context *context);
+
 #endif /* __PERF_TRACE_EVENTS_H */
