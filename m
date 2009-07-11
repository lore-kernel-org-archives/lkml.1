Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbZGKR0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbZGKR0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 13:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZGKRZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 13:25:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:39226 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbZGKRZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 13:25:39 -0400
Date: Sat, 11 Jul 2009 17:24:53 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1247325517-12272-1-git-send-email-acme@redhat.com>
References: <1247325517-12272-1-git-send-email-acme@redhat.com>
Subject: [tip:perfcounters/core] perf report: Tidy up reporting of symbols not found
Message-ID: <tip-60c1baf1248e00d423604f018c8af1cf750ad885@git.kernel.org>
Git-Commit-ID: 60c1baf1248e00d423604f018c8af1cf750ad885
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 11 Jul 2009 17:25:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60c1baf1248e00d423604f018c8af1cf750ad885
Gitweb:     http://git.kernel.org/tip/60c1baf1248e00d423604f018c8af1cf750ad885
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 11 Jul 2009 12:18:33 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 11 Jul 2009 19:20:25 +0200

perf report: Tidy up reporting of symbols not found

Always printing the level info about if it is in the kernel,
hypervisor or userspace as that is in the hist_entry.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1247325517-12272-1-git-send-email-acme@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 740da43..617f4cb 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -705,10 +705,9 @@ sort__sym_print(FILE *fp, struct hist_entry *self, unsigned int width __used)
 	if (verbose)
 		ret += repsep_fprintf(fp, "%#018llx  ", (u64)self->ip);
 
+	ret += repsep_fprintf(fp, "[%c] ", self->level);
 	if (self->sym) {
-		ret += repsep_fprintf(fp, "[%c] %s",
-			self->dso == kernel_dso ? 'k' :
-			self->dso == hypervisor_dso ? 'h' : '.', self->sym->name);
+		ret += repsep_fprintf(fp, "%s", self->sym->name);
 
 		if (self->sym->module)
 			ret += repsep_fprintf(fp, "\t[%s]",
