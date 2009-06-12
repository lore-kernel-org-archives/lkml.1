Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbZFLMoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbZFLMoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757795AbZFLMnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:43:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:52567 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520AbZFLMn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:43:29 -0400
Date: Fri, 12 Jun 2009 12:43:04 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf record: Explicity program a default counter
Message-ID: <tip-bbd36e5e6aa6f1757c84cdb406b6eb81686d14af@git.kernel.org>
Git-Commit-ID: bbd36e5e6aa6f1757c84cdb406b6eb81686d14af
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 12 Jun 2009 12:43:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbd36e5e6aa6f1757c84cdb406b6eb81686d14af
Gitweb:     http://git.kernel.org/tip/bbd36e5e6aa6f1757c84cdb406b6eb81686d14af
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 11 Jun 2009 23:11:50 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 12 Jun 2009 14:28:52 +0200

perf record: Explicity program a default counter

Up until now record has worked on the assumption that type=0, config=0
was a suitable configuration - which it is. Lets make this a little more
explicit and more readable via the use of proper symbols.

[ Impact: cleanup ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 29259e7..0f5771f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -568,8 +568,11 @@ int cmd_record(int argc, const char **argv, const char *prefix)
 	if (!argc && target_pid == -1 && !system_wide)
 		usage_with_options(record_usage, options);
 
-	if (!nr_counters)
-		nr_counters = 1;
+	if (!nr_counters) {
+		nr_counters	= 1;
+		attrs[0].type	= PERF_TYPE_HARDWARE;
+		attrs[0].config = PERF_COUNT_HW_CPU_CYCLES;
+	}
 
 	for (counter = 0; counter < nr_counters; counter++) {
 		if (attrs[counter].sample_period)
