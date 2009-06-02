Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZFBUTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZFBUTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbZFBUSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:18:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:39551 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502AbZFBUST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:18:19 -0400
Date: Tue, 2 Jun 2009 20:17:49 GMT
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
Subject: [tip:perfcounters/core] perf report: Fix column width/alignment of dsos
Message-ID: <tip-cf25c63c609e99bfb9303b68a7a90a56a3a32cea@git.kernel.org>
Git-Commit-ID: cf25c63c609e99bfb9303b68a7a90a56a3a32cea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 20:17:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf25c63c609e99bfb9303b68a7a90a56a3a32cea
Gitweb:     http://git.kernel.org/tip/cf25c63c609e99bfb9303b68a7a90a56a3a32cea
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 2 Jun 2009 22:12:14 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 22:12:14 +0200

perf report: Fix column width/alignment of dsos

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
 Documentation/perf_counter/builtin-report.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 6d68f3a..b84aaf1 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -303,11 +303,11 @@ sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
 static size_t
 sort__thread_print(FILE *fp, struct hist_entry *self)
 {
-	return fprintf(fp, "  %16s:%5d", self->thread->comm ?: "", self->thread->pid);
+	return fprintf(fp, " %16s:%5d", self->thread->comm ?: "", self->thread->pid);
 }
 
 static struct sort_entry sort_thread = {
-	.header = "          Command: Pid ",
+	.header = "         Command: Pid ",
 	.cmp	= sort__thread_cmp,
 	.print	= sort__thread_print,
 };
@@ -363,11 +363,11 @@ sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 static size_t
 sort__dso_print(FILE *fp, struct hist_entry *self)
 {
-	return fprintf(fp, "  %s", self->dso ? self->dso->name : "<unknown>");
+	return fprintf(fp, "  %-25s", self->dso ? self->dso->name : "<unknown>");
 }
 
 static struct sort_entry sort_dso = {
-	.header = " Shared Object",
+	.header = " Shared Object          ",
 	.cmp	= sort__dso_cmp,
 	.print	= sort__dso_print,
 };
