Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbZHUTqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbZHUTqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 15:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932408AbZHUTqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 15:46:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:40638 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbZHUTql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 15:46:41 -0400
Date: Fri, 21 Aug 2009 19:45:36 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: acme@redhat.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       zhaolei@cn.fujitsu.com, dle-develop@lists.sourceforge.net,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mhiramat@redhat.com, systemtap@sources.redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       lizf@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       efault@gmx.de, zhaolei@cn.fujitsu.com,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mhiramat@redhat.com, systemtap@sources.redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       xiaoguangrong@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <20090821185603.11039.62109.stgit@localhost.localdomain>
References: <20090821185603.11039.62109.stgit@localhost.localdomain>
Subject: [tip:perfcounters/tracing] perf trace: Add OPT_END to option array of perf-trace
Message-ID: <tip-1909629fb1ec9800cf2cb0091870d6a1c1ca665f@git.kernel.org>
Git-Commit-ID: 1909629fb1ec9800cf2cb0091870d6a1c1ca665f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 21 Aug 2009 19:45:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1909629fb1ec9800cf2cb0091870d6a1c1ca665f
Gitweb:     http://git.kernel.org/tip/1909629fb1ec9800cf2cb0091870d6a1c1ca665f
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 21 Aug 2009 14:56:03 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 Aug 2009 21:42:43 +0200

perf trace: Add OPT_END to option array of perf-trace

Add OPT_END to option array of perf-trace for fixing a SEGV bug when
showing perf-trace help message.

Without this patch;
 ./perf trace -h

 usage: perf trace [<options>] <command>

    -D, --dump-raw-trace  dump raw trace in ASCII
    -v, --verbose         be more verbose (show symbol address, etc)
    -f, Segmentation fault

With this patch:
 ./perf trace -h

 usage: perf trace [<options>] <command>

    -D, --dump-raw-trace  dump raw trace in ASCII
    -v, --verbose         be more verbose (show symbol address, etc)

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20090821185603.11039.62109.stgit@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-trace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 88eef71..dd3c2e7 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -257,6 +257,7 @@ static const struct option options[] = {
 		    "dump raw trace in ASCII"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
+	OPT_END()
 };
 
 int cmd_trace(int argc, const char **argv, const char *prefix __used)
