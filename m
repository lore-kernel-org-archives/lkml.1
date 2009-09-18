Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbZIRGkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbZIRGkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 02:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbZIRGkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 02:40:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:53942 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbZIRGj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 02:39:59 -0400
Date: Fri, 18 Sep 2009 06:39:35 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1253254944.20589.11.camel@marge.simson.net>
References: <1253254944.20589.11.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf sched: Add --input=file option to builtin-sched.c
Message-ID: <tip-4b77a7297795229eca96c41e1709a3c87909fabe@git.kernel.org>
Git-Commit-ID: 4b77a7297795229eca96c41e1709a3c87909fabe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 18 Sep 2009 06:39:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b77a7297795229eca96c41e1709a3c87909fabe
Gitweb:     http://git.kernel.org/tip/4b77a7297795229eca96c41e1709a3c87909fabe
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Fri, 18 Sep 2009 08:22:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Sep 2009 08:36:06 +0200

perf sched: Add --input=file option to builtin-sched.c

perf sched record passes unparsed args on to perf record, so
specifying an output file via perf sched record -o FILE (cmd) just
works.  Ergo, provide an option to specify input file as well.

Also add the missing 'map' command to help.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1253254944.20589.11.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-sched.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

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
