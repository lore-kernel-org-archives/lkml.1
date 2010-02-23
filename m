Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0BWCGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 21:06:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab0BWCF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 21:05:59 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v3 8/9] perf probe: show more lines after last line
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Date: Mon, 22 Feb 2010 21:09:14 -0500
Message-ID: <20100223020914.26668.10326.stgit@localhost6.localdomain6>
In-Reply-To: <20100223020818.26668.79685.stgit@localhost6.localdomain6>
References: <20100223020818.26668.79685.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show 2 more lines after the last probe-able line.
This will clearly show the last closed-brace of
inline functions.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
---

 tools/perf/util/probe-event.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 01c229b..e7918e2 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -718,6 +718,7 @@ void del_trace_kprobe_events(struct strlist *dellist)
 }
 
 #define LINEBUF_SIZE 256
+#define NR_ADDITIONAL_LINES 2
 
 static void show_one_line(FILE *fp, unsigned int l, bool skip, bool show_num)
 {
@@ -778,5 +779,11 @@ void show_line_range(struct line_range *lr)
 			show_one_line(fp, (l++) - lr->offset, false, false);
 		show_one_line(fp, (l++) - lr->offset, false, true);
 	}
+
+	if (lr->end == INT_MAX)
+		lr->end = l + NR_ADDITIONAL_LINES;
+	while (l < lr->end && !feof(fp))
+		show_one_line(fp, (l++) - lr->offset, false, false);
+
 	fclose(fp);
 }


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
