Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbZHUSxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbZHUSxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 14:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbZHUSxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 14:53:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737AbZHUSxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 14:53:53 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [BUGFIX PATCH -tip] perf tools: Add OPT_END to option array of
	perf-trace
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>
Date: Fri, 21 Aug 2009 14:56:03 -0400
Message-ID: <20090821185603.11039.62109.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
