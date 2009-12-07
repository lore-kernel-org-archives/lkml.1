Return-Path: <linux-kernel-owner+w=401wt.eu-S964890AbZLGRjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964890AbZLGRjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964873AbZLGRjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:39:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:41716 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964860AbZLGRjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:39:11 -0500
Date: Mon, 7 Dec 2009 17:37:17 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, dle-develop@lists.sourceforge.net,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
In-Reply-To: <20091207170053.19230.7690.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091207170053.19230.7690.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Check e_snprintf() format string
Message-ID: <tip-849884508ecbe2d220131840e4cc7c32ca24ebe3@git.kernel.org>
Git-Commit-ID: 849884508ecbe2d220131840e4cc7c32ca24ebe3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  849884508ecbe2d220131840e4cc7c32ca24ebe3
Gitweb:     http://git.kernel.org/tip/849884508ecbe2d220131840e4cc7c32ca24ebe3
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 7 Dec 2009 12:00:53 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 7 Dec 2009 18:33:21 +0100

perf probe: Check e_snprintf() format string

Check e_snprintf() format string by gcc, and fix a bug of
e_snprintf() caller.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091207170053.19230.7690.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-event.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index de0d913..88e1804 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -48,6 +48,9 @@
 
 /* If there is no space to write, returns -E2BIG. */
 static int e_snprintf(char *str, size_t size, const char *format, ...)
+	__attribute__((format(printf, 3, 4)));
+
+static int e_snprintf(char *str, size_t size, const char *format, ...)
 {
 	int ret;
 	va_list ap;
@@ -258,7 +261,7 @@ int synthesize_perf_probe_event(struct probe_point *pp)
 		ret = e_snprintf(buf, MAX_CMDLEN, "%s%s%s%s", pp->function,
 				 offs, pp->retprobe ? "%return" : "", line);
 	else
-		ret = e_snprintf(buf, MAX_CMDLEN, "%s%s%s%s", pp->file, line);
+		ret = e_snprintf(buf, MAX_CMDLEN, "%s%s", pp->file, line);
 	if (ret <= 0)
 		goto error;
 	len = ret;
