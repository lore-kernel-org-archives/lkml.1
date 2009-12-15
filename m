Return-Path: <linux-kernel-owner+w=401wt.eu-S1758313AbZLOIKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313AbZLOIKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 03:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758218AbZLOIKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 03:10:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:33904 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbZLOIKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 03:10:20 -0500
Date: Tue, 15 Dec 2009 08:09:37 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091214162713.GA31060@elte.hu>
References: <20091214162713.GA31060@elte.hu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Fix return of trace_dump_stack()
Message-ID: <tip-e36c54582c6f14adc9e10473e2aec2cc4f0acc03@git.kernel.org>
Git-Commit-ID: e36c54582c6f14adc9e10473e2aec2cc4f0acc03
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e36c54582c6f14adc9e10473e2aec2cc4f0acc03
Gitweb:     http://git.kernel.org/tip/e36c54582c6f14adc9e10473e2aec2cc4f0acc03
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Mon, 14 Dec 2009 15:58:33 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 08:36:11 +0100

tracing: Fix return of trace_dump_stack()

The trace_dump_stack() returned a value for a void function.

Also, added the missing stub for trace_dump_stack() when tracing is
not configured.

Reported-by: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20091214162713.GA31060@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/kernel.h |    1 +
 kernel/trace/trace.c   |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 5ad4199..f1dc752 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -527,6 +527,7 @@ trace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 2)));
 static inline void tracing_start(void) { }
 static inline void tracing_stop(void) { }
 static inline void ftrace_off_permanent(void) { }
+static inline void trace_dump_stack(void) { }
 static inline int
 trace_printk(const char *fmt, ...)
 {
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bd7b969..ee61915 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1158,7 +1158,7 @@ void trace_dump_stack(void)
 	unsigned long flags;
 
 	if (tracing_disabled || tracing_selftest_running)
-		return 0;
+		return;
 
 	local_save_flags(flags);
 
