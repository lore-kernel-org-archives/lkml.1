Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471Ab0BYTd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:33:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:34123 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933463Ab0BYTdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:33:17 -0500
Date: Thu, 25 Feb 2010 19:32:11 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       ananth@in.ibm.com, dle-develop@lists.sourceforge.net,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
       ananth@in.ibm.com, fweisbec@gmail.com,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20100225133604.6725.76820.stgit@localhost6.localdomain6>
References: <20100225133604.6725.76820.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] perf probe: Show more lines after last line
Message-ID: <tip-5c8d1cbbbed39dcab2ecf429d6e56ea548c0fda4@git.kernel.org>
Git-Commit-ID: 5c8d1cbbbed39dcab2ecf429d6e56ea548c0fda4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 19:32:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c8d1cbbbed39dcab2ecf429d6e56ea548c0fda4
Gitweb:     http://git.kernel.org/tip/5c8d1cbbbed39dcab2ecf429d6e56ea548c0fda4
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 25 Feb 2010 08:36:04 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 17:49:30 +0100

perf probe: Show more lines after last line

Show 2 more lines after the last probe-able line.
This will clearly show the last closed-brace of
inline functions.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
LKML-Reference: <20100225133604.6725.76820.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-event.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 71b0dd5..91f55f2 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -716,6 +716,7 @@ void del_trace_kprobe_events(struct strlist *dellist)
 }
 
 #define LINEBUF_SIZE 256
+#define NR_ADDITIONAL_LINES 2
 
 static void show_one_line(FILE *fp, unsigned int l, bool skip, bool show_num)
 {
@@ -776,5 +777,11 @@ void show_line_range(struct line_range *lr)
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
