Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab0BRXWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 18:22:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab0BRXWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 18:22:11 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 8/9] perf probe: show more lines after last line
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Roland McGrath <roland@redhat.com>,
       Mike Galbraith <efault@gmx.de>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Thu, 18 Feb 2010 18:28:06 -0500
Message-ID: <20100218232806.21679.72022.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20100218232701.21679.5195.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100218232701.21679.5195.stgit@dhcp-100-2-132.bos.redhat.com>
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
index 8f05688..bc70323 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -719,6 +719,7 @@ void del_trace_kprobe_events(struct strlist *dellist)
 }
 
 #define LINEBUF_SIZE 256
+#define NR_ADDITIONAL_LINES 2
 
 static void show_one_line(FILE *fp, unsigned int l, bool skip, bool show_num)
 {
@@ -779,5 +780,11 @@ void show_line_range(struct line_range *lr)
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
