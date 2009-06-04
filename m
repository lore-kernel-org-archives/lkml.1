Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbZFDNKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbZFDNKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 09:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbZFDNKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 09:10:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:47899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228AbZFDNKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:10:21 -0400
Date: Thu, 4 Jun 2009 13:09:43 GMT
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
Subject: [tip:perfcounters/core] perf report: Simplify symbol output
Message-ID: <tip-95ed6fd06e52bf850cd17524f0b36ed14300c10d@git.kernel.org>
Git-Commit-ID: 95ed6fd06e52bf850cd17524f0b36ed14300c10d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 13:09:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  95ed6fd06e52bf850cd17524f0b36ed14300c10d
Gitweb:     http://git.kernel.org/tip/95ed6fd06e52bf850cd17524f0b36ed14300c10d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 4 Jun 2009 15:00:45 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Jun 2009 14:04:50 +0200

perf report: Simplify symbol output

The DSO can be printed already - no need to repeat it in the
symbol field.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index ff6f657..56c664d 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -382,7 +382,7 @@ sort__comm_print(FILE *fp, struct hist_entry *self)
 }
 
 static struct sort_entry sort_comm = {
-	.header 	= "          Command",
+	.header		= "          Command",
 	.cmp		= sort__comm_cmp,
 	.collapse	= sort__comm_collapse,
 	.print		= sort__comm_print,
@@ -414,11 +414,11 @@ sort__dso_print(FILE *fp, struct hist_entry *self)
 	if (self->dso)
 		return fprintf(fp, "  %-25s", self->dso->name);
 
-	return fprintf(fp, "  %016llx", (__u64)self->ip);
+	return fprintf(fp, "  %016llx         ", (__u64)self->ip);
 }
 
 static struct sort_entry sort_dso = {
-	.header = " Shared Object          ",
+	.header = " Shared Object            ",
 	.cmp	= sort__dso_cmp,
 	.print	= sort__dso_print,
 };
@@ -447,21 +447,16 @@ sort__sym_print(FILE *fp, struct hist_entry *self)
 	if (verbose)
 		ret += fprintf(fp, "  %#018llx", (__u64)self->ip);
 
-	if (self->dso)
-		ret += fprintf(fp, "  %s: ", self->dso->name);
-	else
-		ret += fprintf(fp, "  %#016llx: ", (__u64)self->ip);
-
 	if (self->sym)
-		ret += fprintf(fp, "%s", self->sym->name);
+		ret += fprintf(fp, "  %s", self->sym->name);
 	else
-		ret += fprintf(fp, "%#016llx", (__u64)self->ip);
+		ret += fprintf(fp, "  %#016llx", (__u64)self->ip);
 
 	return ret;
 }
 
 static struct sort_entry sort_sym = {
-	.header = " Shared Object: Symbol",
+	.header = " Symbol",
 	.cmp	= sort__sym_cmp,
 	.print	= sort__sym_print,
 };
