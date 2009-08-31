Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbZHaIh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbZHaIh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 04:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbZHaIh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 04:37:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:57228 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbZHaIh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 04:37:56 -0400
Date: Mon, 31 Aug 2009 08:37:31 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1251693921-6579-2-git-send-email-fweisbec@gmail.com>
References: <1251693921-6579-2-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf tools: Resolve idle thread cmdline for perf trace
Message-ID: <tip-3a2684ca58e06941ff00e3f096ca44f898a6d13e@git.kernel.org>
Git-Commit-ID: 3a2684ca58e06941ff00e3f096ca44f898a6d13e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 08:37:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a2684ca58e06941ff00e3f096ca44f898a6d13e
Gitweb:     http://git.kernel.org/tip/3a2684ca58e06941ff00e3f096ca44f898a6d13e
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 31 Aug 2009 06:45:19 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 Aug 2009 10:04:48 +0200

perf tools: Resolve idle thread cmdline for perf trace

The cmd-trace tool used the cmdline file and resolved the idle
thread using a hardcoded check for the 0 task pid.

Now we have a centralized way to do that from perf using
register_idle_thread() API.

Before:
	:0-0     [000]     0.000000: irq_handler_entry: irq=0 handler=name
	:0-0     [000]     0.000000: irq_handler_entry: irq=0 handler=name

After:
	[idle]-0     [000]     0.000000: irq_handler_entry: irq=0 handler=name
	[idle]-0     [000]     0.000000: irq_handler_entry: irq=0 handler=name

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1251693921-6579-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-trace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index dd3c2e7..8247fd0 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -164,6 +164,7 @@ static int __cmd_trace(void)
 	char *buf;
 
 	trace_report();
+	register_idle_thread(&threads, &last_match);
 
 	input = open(input_name, O_RDONLY);
 	if (input < 0) {
