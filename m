Return-Path: <linux-kernel-owner+w=401wt.eu-S964799AbZLGQ4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964799AbZLGQ4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935508AbZLGQ4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:56:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935445AbZLGQ4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:56:45 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [BUGFIX PATCH -tip 4/5] perf probe: Check e_snprintf() format string
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 07 Dec 2009 12:00:53 -0500
Message-ID: <20091207170053.19230.7690.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091207170027.19230.39491.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091207170027.19230.39491.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check e_snprintf() format string by gcc, and fix a bug of
e_snprintf() caller.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
