Return-Path: <linux-kernel-owner+w=401wt.eu-S1760062AbZFRGKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062AbZFRGKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 02:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbZFRGKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 02:10:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:51801 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613AbZFRGKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 02:10:24 -0400
Date: Thu, 18 Jun 2009 06:09:45 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Tidy up the --collapse call-chain feature
Message-ID: <tip-9e2e73305665c363fe173b2da53ae98dd6e7ae0d@git.kernel.org>
Git-Commit-ID: 9e2e73305665c363fe173b2da53ae98dd6e7ae0d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 06:09:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e2e73305665c363fe173b2da53ae98dd6e7ae0d
Gitweb:     http://git.kernel.org/tip/9e2e73305665c363fe173b2da53ae98dd6e7ae0d
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 18 Jun 2009 07:01:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Jun 2009 07:01:03 +0200

perf report: Tidy up the --collapse call-chain feature

 - rename --call <regex> to --collapse <regex>

 - add pagefaults to the default collapsing pattern too

 - rename [unmatched] to [other] - to signal that this is not
   an error but the inverse set

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 707f60c..57b6e2f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -44,7 +44,7 @@ static int		full_paths;
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
-static char		*call = "^sys_";
+static char		*call = "^sys_|^do_page_fault";
 static regex_t		call_regex;
 
 struct ip_chain_event {
@@ -637,7 +637,7 @@ sort__call_print(FILE *fp, struct hist_entry *self)
 {
 	size_t ret = 0;
 
-	ret += fprintf(fp, "%-20s", self->call ? self->call->name : "[unmatched]");
+	ret += fprintf(fp, "%-20s", self->call ? self->call->name : "[other]");
 
 	return ret;
 }
@@ -1457,11 +1457,11 @@ static const struct option options[] = {
 		    "dump raw trace in ASCII"),
 	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol. Default: pid,symbol"),
+		   "sort by key(s): pid, comm, dso, symbol, call"),
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
 		    "Don't shorten the pathnames taking into account the cwd"),
-	OPT_STRING('c', "call", &call, "regex",
-		   "regex to use for --sort call"),
+	OPT_STRING('g', "grep", &call, "regex",
+		   "regex filter to use for '--sort call'"),
 	OPT_END()
 };
 
