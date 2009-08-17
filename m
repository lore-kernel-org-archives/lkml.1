Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbZHQWHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbZHQWHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 18:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758206AbZHQWHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 18:07:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:49472 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757338AbZHQWHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 18:07:14 -0400
Date: Mon, 17 Aug 2009 22:06:24 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1250543271-8383-2-git-send-email-fweisbec@gmail.com>
References: <1250543271-8383-2-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/tracing] perf tools: Warn while running perf trace without sample
Message-ID: <tip-4bf2364a951d3c043e132e4451d90c7bc74dee83@git.kernel.org>
Git-Commit-ID: 4bf2364a951d3c043e132e4451d90c7bc74dee83
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Aug 2009 22:06:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4bf2364a951d3c043e132e4451d90c7bc74dee83
Gitweb:     http://git.kernel.org/tip/4bf2364a951d3c043e132e4451d90c7bc74dee83
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 17 Aug 2009 23:07:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 00:00:18 +0200

perf tools: Warn while running perf trace without sample

When a user runs perf trace using an input with logged
counters without PERF_SAMPLE_RAW attribute, warn by giving a
nice tip.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1250543271-8383-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-trace.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index b160a9f..88eef71 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -184,6 +184,10 @@ static int __cmd_trace(void)
 	header = perf_header__read(input);
 	sample_type = perf_header__sample_type(header);
 
+	if (!(sample_type & PERF_SAMPLE_RAW))
+		die("No trace sample to read. Did you call perf record "
+		    "without -R?");
+
 	if (load_kernel() < 0) {
 		perror("failed to load kernel symbols");
 		return EXIT_FAILURE;
