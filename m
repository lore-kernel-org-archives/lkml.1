Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbZGKPTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbZGKPTZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 11:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbZGKPSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 11:18:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35224 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbZGKPSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 11:18:42 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH tip 1/5] perf report: Tidy up reporting of symbols not found
Date: Sat, 11 Jul 2009 12:18:33 -0300
Message-Id: <1247325517-12272-1-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always printing the level info about if it is in the kernel, hypervisor
or userspace as that is in the hist_entry.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
-- 
1.6.2.5

