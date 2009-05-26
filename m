Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbZEZSK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbZEZSK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 14:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbZEZSKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 14:10:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:44322 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbZEZSKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 14:10:14 -0400
Date: Tue, 26 May 2009 18:09:30 GMT
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
Subject: [tip:perfcounters/core] perf report: add counter for unknown events
Message-ID: <tip-3e70611460fe74ad32534fa9791774f6bbdd4159@git.kernel.org>
Git-Commit-ID: 3e70611460fe74ad32534fa9791774f6bbdd4159
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 18:09:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e70611460fe74ad32534fa9791774f6bbdd4159
Gitweb:     http://git.kernel.org/tip/3e70611460fe74ad32534fa9791774f6bbdd4159
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 26 May 2009 18:53:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 18:53:17 +0200

perf report: add counter for unknown events

Add a counter for unknown event records.

[ Impact: improve debugging ]

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
 Documentation/perf_counter/builtin-report.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 8ea8aaa..4b5ccc5 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -645,7 +645,7 @@ static int __cmd_report(void)
 	char *buf;
 	event_t *event;
 	int ret, rc = EXIT_FAILURE;
-	unsigned long total = 0, total_mmap = 0, total_comm = 0;
+	unsigned long total = 0, total_mmap = 0, total_comm = 0, total_unknown;
 
 	input = open(input_name, O_RDONLY);
 	if (input < 0) {
@@ -785,6 +785,7 @@ more:
 	default: {
 		fprintf(stderr, "skipping unknown header type: %d\n",
 			event->header.type);
+		total_unknown++;
 	}
 	}
 
@@ -796,9 +797,10 @@ done:
 	close(input);
 
 	if (dump_trace) {
-		fprintf(stderr, "   IP events: %10ld\n", total);
-		fprintf(stderr, " mmap events: %10ld\n", total_mmap);
-		fprintf(stderr, " comm events: %10ld\n", total_comm);
+		fprintf(stderr, "      IP events: %10ld\n", total);
+		fprintf(stderr, "    mmap events: %10ld\n", total_mmap);
+		fprintf(stderr, "    comm events: %10ld\n", total_comm);
+		fprintf(stderr, " unknown events: %10ld\n", total_unknown);
 
 		return 0;
 	}
