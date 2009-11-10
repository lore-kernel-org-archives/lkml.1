Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbZKJD6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbZKJD6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 22:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbZKJD6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 22:58:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57720 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbZKJD6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 22:58:22 -0500
Date: Tue, 10 Nov 2009 04:58:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH v2 0/4] perf bench: Common option for specifying style
 formatting
Message-ID: <20091110035812.GB29454@elte.hu>
References: <1257808802-9420-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257808802-9420-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> This patch series adds new option "--format" to
> bench subcommand of perf.
> 
> Users of perf bench will be able to specify
> style formatting with this option in common way.
> 
> Hitoshi Mitake (4):
>   perf bench: Add stuffs to bench.h for unified output formatting
>   perf bench: Modify builtin-bench.c for processing common options
>   perf bench: Modified bench/bench-messaging.c to adopt unified output
>     formatting
>   perf bench: Modify builtin-pipe.c for processing common options
> 
>  tools/perf/bench/bench.h           |    9 ++++
>  tools/perf/bench/sched-messaging.c |   18 +++++---
>  tools/perf/bench/sched-pipe.c      |   22 ++++++----
>  tools/perf/builtin-bench.c         |   79 +++++++++++++++++++++++++++++------
>  4 files changed, 99 insertions(+), 29 deletions(-)

Very nice, applied to tip:perf/bench, thanks!

A (very) small detail about initializers in bench.h:

 - No need to break the line for function prototypes, they are more
   readable in a single line. (even if checkpatch complains about it)

 - We try to align definitions / structure fields vertically, to make it 
   all a bit more readable.

Something like the (untested) cleanup patch below. (Just put it into 
your next batch of commits.)

Thanks,

	Ingo

---
 tools/perf/bench/bench.h |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

Index: tip/tools/perf/bench/bench.h
===================================================================
--- tip.orig/tools/perf/bench/bench.h
+++ tip/tools/perf/bench/bench.h
@@ -1,17 +1,15 @@
 #ifndef BENCH_H
 #define BENCH_H
 
-extern int bench_sched_messaging(int argc, const char **argv,
-				 const char *prefix);
-extern int bench_sched_pipe(int argc, const char **argv,
-			    const char *prefix);
+extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
+extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
 
-#define BENCH_FORMAT_DEFAULT_STR "default"
-#define BENCH_FORMAT_DEFAULT 0
-#define BENCH_FORMAT_SIMPLE_STR "simple"
-#define BENCH_FORMAT_SIMPLE 1
+#define BENCH_FORMAT_DEFAULT_STR	"default"
+#define BENCH_FORMAT_DEFAULT		0
+#define BENCH_FORMAT_SIMPLE_STR		"simple"
+#define BENCH_FORMAT_SIMPLE		1
 
-#define BENCH_FORMAT_UNKNOWN -1
+#define BENCH_FORMAT_UNKNOWN		-1
 
 extern int bench_format;
 
