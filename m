Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbZFDNbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbZFDNbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 09:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbZFDNbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 09:31:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:44077 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbZFDNbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:31:13 -0400
Date: Thu, 4 Jun 2009 13:30:32 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Add consistent spacing rules
Message-ID: <tip-11fbe0555ffa7ad1e5359fc42cdf6e4019dd7879@git.kernel.org>
Git-Commit-ID: 11fbe0555ffa7ad1e5359fc42cdf6e4019dd7879
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 13:30:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11fbe0555ffa7ad1e5359fc42cdf6e4019dd7879
Gitweb:     http://git.kernel.org/tip/11fbe0555ffa7ad1e5359fc42cdf6e4019dd7879
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 4 Jun 2009 15:16:56 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Jun 2009 15:26:19 +0200

perf report: Add consistent spacing rules

Make the sort header and the print function have the same column width.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   30 ++++++++++++++------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index be392e0..132242d 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -344,11 +344,11 @@ sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
 static size_t
 sort__thread_print(FILE *fp, struct hist_entry *self)
 {
-	return fprintf(fp, " %16s:%5d", self->thread->comm ?: "", self->thread->pid);
+	return fprintf(fp, "%16s:%5d", self->thread->comm ?: "", self->thread->pid);
 }
 
 static struct sort_entry sort_thread = {
-	.header = "         Command: Pid ",
+	.header = "         Command:  Pid",
 	.cmp	= sort__thread_cmp,
 	.print	= sort__thread_print,
 };
@@ -382,11 +382,11 @@ sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
 static size_t
 sort__comm_print(FILE *fp, struct hist_entry *self)
 {
-	return fprintf(fp, "  %16s", self->thread->comm);
+	return fprintf(fp, "%16s", self->thread->comm);
 }
 
 static struct sort_entry sort_comm = {
-	.header		= "          Command",
+	.header 	= "         Command",
 	.cmp		= sort__comm_cmp,
 	.collapse	= sort__comm_collapse,
 	.print		= sort__comm_print,
@@ -416,13 +416,13 @@ static size_t
 sort__dso_print(FILE *fp, struct hist_entry *self)
 {
 	if (self->dso)
-		return fprintf(fp, "  %-25s", self->dso->name);
+		return fprintf(fp, "%-25s", self->dso->name);
 
-	return fprintf(fp, "  %016llx         ", (__u64)self->ip);
+	return fprintf(fp, "%016llx         ", (__u64)self->ip);
 }
 
 static struct sort_entry sort_dso = {
-	.header = " Shared Object            ",
+	.header = "Shared Object            ",
 	.cmp	= sort__dso_cmp,
 	.print	= sort__dso_print,
 };
@@ -449,18 +449,18 @@ sort__sym_print(FILE *fp, struct hist_entry *self)
 	size_t ret = 0;
 
 	if (verbose)
-		ret += fprintf(fp, "  %#018llx", (__u64)self->ip);
+		ret += fprintf(fp, "%#018llx  ", (__u64)self->ip);
 
 	if (self->sym)
-		ret += fprintf(fp, "  %s", self->sym->name);
+		ret += fprintf(fp, "%s", self->sym->name);
 	else
-		ret += fprintf(fp, "  %#016llx", (__u64)self->ip);
+		ret += fprintf(fp, "%#016llx", (__u64)self->ip);
 
 	return ret;
 }
 
 static struct sort_entry sort_sym = {
-	.header = " Symbol",
+	.header = "Symbol",
 	.cmp	= sort__sym_cmp,
 	.print	= sort__sym_print,
 };
@@ -553,8 +553,10 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, uint64_t total_samples)
 	} else
 		ret = fprintf(fp, "%12d ", self->count);
 
-	list_for_each_entry(se, &hist_entry__sort_list, list)
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		fprintf(fp, "  ");
 		ret += se->print(fp, self);
+	}
 
 	ret += fprintf(fp, "\n");
 
@@ -727,7 +729,7 @@ static size_t output__fprintf(FILE *fp, uint64_t total_samples)
 
 	fprintf(fp, "# Overhead");
 	list_for_each_entry(se, &hist_entry__sort_list, list)
-		fprintf(fp, " %s", se->header);
+		fprintf(fp, "  %s", se->header);
 	fprintf(fp, "\n");
 
 	fprintf(fp, "# ........");
@@ -735,7 +737,7 @@ static size_t output__fprintf(FILE *fp, uint64_t total_samples)
 		int i;
 
 		fprintf(fp, "  ");
-		for (i = 0; i < strlen(se->header)-1; i++)
+		for (i = 0; i < strlen(se->header); i++)
 			fprintf(fp, ".");
 	}
 	fprintf(fp, "\n");
