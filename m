Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbZCRJCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbZCRJCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbZCRJB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:01:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:53526 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986AbZCRJB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:01:58 -0400
Date: Wed, 18 Mar 2009 09:00:28 GMT
From: Luis Henriques <henrix@sapo.pt>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, henrix@sapo.pt, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, henrix@sapo.pt, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090318000425.GA2228@hades.domain.com>
References: <20090318000425.GA2228@hades.domain.com>
Subject: [tip:sched/debug] sched: jiffies not printed per CPU
Message-ID: <tip-af66df5ecf9c9e2d2ff86e8203510c1c4519d64c@git.kernel.org>
Git-Commit-ID: af66df5ecf9c9e2d2ff86e8203510c1c4519d64c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Mar 2009 09:00:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af66df5ecf9c9e2d2ff86e8203510c1c4519d64c
Gitweb:     http://git.kernel.org/tip/af66df5ecf9c9e2d2ff86e8203510c1c4519d64c
Author:     Luis Henriques <henrix@sapo.pt>
AuthorDate: Wed, 18 Mar 2009 00:04:25 +0000
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 Mar 2009 09:57:26 +0100

sched: jiffies not printed per CPU

The jiffies value was being printed for each CPU, which does not seem to make
sense.  Moved jiffies to system section.

Signed-off-by: Luis Henriques <henrix@sapo.pt>
Acked-by: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090318000425.GA2228@hades.domain.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 2b1260f..4daebff 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -272,7 +272,6 @@ static void print_cpu(struct seq_file *m, int cpu)
 	P(nr_switches);
 	P(nr_load_updates);
 	P(nr_uninterruptible);
-	SEQ_printf(m, "  .%-30s: %lu\n", "jiffies", jiffies);
 	PN(next_balance);
 	P(curr->pid);
 	PN(clock);
@@ -325,6 +324,7 @@ static int sched_debug_show(struct seq_file *m, void *v)
 	SEQ_printf(m, "  .%-40s: %Ld\n", #x, (long long)(x))
 #define PN(x) \
 	SEQ_printf(m, "  .%-40s: %Ld.%06ld\n", #x, SPLIT_NS(x))
+	P(jiffies);
 	PN(sysctl_sched_latency);
 	PN(sysctl_sched_min_granularity);
 	PN(sysctl_sched_wakeup_granularity);
