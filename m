Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbZFBOnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbZFBOnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbZFBOnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:43:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:59627 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbZFBOnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:43:05 -0400
Date: Tue, 2 Jun 2009 14:42:31 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Clean up the default output
Message-ID: <tip-4593bba8679b925a056f84edac061676e7eda71c@git.kernel.org>
Git-Commit-ID: 4593bba8679b925a056f84edac061676e7eda71c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 14:42:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4593bba8679b925a056f84edac061676e7eda71c
Gitweb:     http://git.kernel.org/tip/4593bba8679b925a056f84edac061676e7eda71c
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 2 Jun 2009 15:34:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 16:39:25 +0200

perf report: Clean up the default output

 - extra space between columns
 - left-aligned the symbol column
 - moved the no-symbols printout to -v

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   55 ++++++++++++++-------------
 1 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 0558c1e..19c1e05 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -84,24 +84,25 @@ static struct dso *dsos__findnew(const char *name)
 	struct dso *dso = dsos__find(name);
 	int nr;
 
-	if (dso == NULL) {
-		dso = dso__new(name, 0);
-		if (!dso)
-			goto out_delete_dso;
-
-		nr = dso__load(dso, NULL);
-		if (nr < 0) {
-			fprintf(stderr, "Failed to open: %s\n", name);
-			goto out_delete_dso;
-		}
-		if (!nr) {
-			fprintf(stderr,
-		"Failed to find debug symbols for: %s, maybe install a debug package?\n",
-					name);
-		}
+	if (dso)
+		return dso;
+
+	dso = dso__new(name, 0);
+	if (!dso)
+		goto out_delete_dso;
 
-		dsos__add(dso);
+	nr = dso__load(dso, NULL);
+	if (nr < 0) {
+		fprintf(stderr, "Failed to open: %s\n", name);
+		goto out_delete_dso;
 	}
+	if (!nr && verbose) {
+		fprintf(stderr,
+		"No symbols found in: %s, maybe install a debug package?\n",
+				name);
+	}
+
+	dsos__add(dso);
 
 	return dso;
 
@@ -302,11 +303,11 @@ sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
 static size_t
 sort__thread_print(FILE *fp, struct hist_entry *self)
 {
-	return fprintf(fp, " %16s:%5d", self->thread->comm ?: "", self->thread->pid);
+	return fprintf(fp, "  %16s:%5d", self->thread->comm ?: "", self->thread->pid);
 }
 
 static struct sort_entry sort_thread = {
-	.header = "         Command: Pid ",
+	.header = "          Command: Pid ",
 	.cmp	= sort__thread_cmp,
 	.print	= sort__thread_print,
 };
@@ -332,11 +333,11 @@ sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
 static size_t
 sort__comm_print(FILE *fp, struct hist_entry *self)
 {
-	return fprintf(fp, " %16s", self->thread->comm ?: "<unknown>");
+	return fprintf(fp, "  %16s", self->thread->comm ?: "<unknown>");
 }
 
 static struct sort_entry sort_comm = {
-	.header = "         Command",
+	.header = "          Command",
 	.cmp	= sort__comm_cmp,
 	.print	= sort__comm_print,
 };
@@ -362,11 +363,11 @@ sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 static size_t
 sort__dso_print(FILE *fp, struct hist_entry *self)
 {
-	return fprintf(fp, " %64s", self->dso ? self->dso->name : "<unknown>");
+	return fprintf(fp, "  %s", self->dso ? self->dso->name : "<unknown>");
 }
 
 static struct sort_entry sort_dso = {
-	.header = "                                                    Shared Object",
+	.header = " Shared Object",
 	.cmp	= sort__dso_cmp,
 	.print	= sort__dso_print,
 };
@@ -391,9 +392,9 @@ sort__sym_print(FILE *fp, struct hist_entry *self)
 	size_t ret = 0;
 
 	if (verbose)
-		ret += fprintf(fp, " %#018llx", (unsigned long long)self->ip);
+		ret += fprintf(fp, "  %#018llx", (unsigned long long)self->ip);
 
-	ret += fprintf(fp, " %s: %s",
+	ret += fprintf(fp, "  %s: %s",
 			self->dso ? self->dso->name : "<unknown>",
 			self->sym ? self->sym->name : "<unknown>");
 
@@ -401,7 +402,7 @@ sort__sym_print(FILE *fp, struct hist_entry *self)
 }
 
 static struct sort_entry sort_sym = {
-	.header = "Shared Object: Symbol",
+	.header = " Shared Object: Symbol",
 	.cmp	= sort__sym_cmp,
 	.print	= sort__sym_print,
 };
@@ -595,8 +596,8 @@ static size_t output__fprintf(FILE *fp, uint64_t total_samples)
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		int i;
 
-		fprintf(fp, " ");
-		for (i = 0; i < strlen(se->header); i++)
+		fprintf(fp, "  ");
+		for (i = 0; i < strlen(se->header)-1; i++)
 			fprintf(fp, ".");
 	}
 	fprintf(fp, "\n");
