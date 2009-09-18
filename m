Return-Path: <linux-kernel-owner+w=401wt.eu-S1752529AbZIRGW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbZIRGW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 02:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbZIRGWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 02:22:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:33994 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751672AbZIRGWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 02:22:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+IC5cLNA6Io+BWIHOxBeZm7tAx08bY2WV/dH5EXs
	Ctr8H3Ng+FVtnx
Subject: [patchlet] perf_counter tools: add --input=file option to
 builtin-sched.c
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 08:22:24 +0200
Message-Id: <1253254944.20589.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


perf_counter tools: add --input=file option to builtin-sched.c.

perf sched record passes unparsed args on to perf record, so specifying an output
file via perf sched record -o FILE (cmd) just works.  Ergo, provide an option to
specify input file as well.

Also add the missing 'map' command to help.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 9e04827..275d79c 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1859,11 +1859,13 @@ static void __cmd_replay(void)
 
 
 static const char * const sched_usage[] = {
-	"perf sched [<options>] {record|latency|replay|trace}",
+	"perf sched [<options>] {record|latency|map|replay|trace}",
 	NULL
 };
 
 static const struct option sched_options[] = {
+	OPT_STRING('i', "input", &input_name, "file",
+		    "input file name"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,


