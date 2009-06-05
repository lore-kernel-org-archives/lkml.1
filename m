Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbZFESqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbZFESqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbZFESqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:46:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:37589 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbZFESqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:46:38 -0400
Date: Fri, 5 Jun 2009 18:46:07 GMT
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
Subject: [tip:perfcounters/core] perf record: Set frequency correctly
Message-ID: <tip-1dba15e74aba5a90c1f2557f37e5d09f8a2df643@git.kernel.org>
Git-Commit-ID: 1dba15e74aba5a90c1f2557f37e5d09f8a2df643
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 05 Jun 2009 18:46:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1dba15e74aba5a90c1f2557f37e5d09f8a2df643
Gitweb:     http://git.kernel.org/tip/1dba15e74aba5a90c1f2557f37e5d09f8a2df643
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 5 Jun 2009 18:37:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 5 Jun 2009 18:37:22 +0200

perf record: Set frequency correctly

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index 43ddab3..c22ea0c 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -348,7 +348,10 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	attr.config		= event_id[counter];
 	attr.sample_period	= event_count[counter];
 	attr.sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_PERIOD;
-	attr.freq		= freq;
+	if (freq) {
+		attr.freq		= 1;
+		attr.sample_freq	= freq;
+	}
 	attr.mmap		= track;
 	attr.comm		= track;
 	attr.inherit		= (cpu < 0) && inherit;
@@ -544,10 +547,6 @@ int cmd_record(int argc, const char **argv, const char *prefix)
 		event_id[0] = 0;
 	}
 
-	if (freq) {
-		default_interval = freq;
-		freq = 1;
-	}
 	for (counter = 0; counter < nr_counters; counter++) {
 		if (event_count[counter])
 			continue;
