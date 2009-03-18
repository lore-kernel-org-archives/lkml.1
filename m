Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbZCRAGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbZCRAGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 20:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZCRAGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 20:06:33 -0400
Received: from relay2.ptmail.sapo.pt ([212.55.154.22]:37459 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751944AbZCRAGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 20:06:32 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Wed, 18 Mar 2009 00:04:25 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2 -tip] sched: Jiffies not printed per CPU
Message-ID: <20090318000425.GA2228@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The jiffies value was being printed for each CPU, which does not seem to make
sense.  Moved jiffies to system section.

Signed-off-by: Luis Henriques <henrix@sapo.pt>
---
 kernel/sched_debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 1f16606..32ec9ab 100644
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
@@ -322,6 +321,7 @@ static int sched_debug_show(struct seq_file *m, void *v)
 	SEQ_printf(m, "  .%-40s: %Ld\n", #x, (long long)(x))
 #define PN(x) \
 	SEQ_printf(m, "  .%-40s: %Ld.%06ld\n", #x, SPLIT_NS(x))
+	P(jiffies);
 	PN(sysctl_sched_latency);
 	PN(sysctl_sched_min_granularity);
 	PN(sysctl_sched_wakeup_granularity);
-- 
1.6.2


-- 
Luis Henriques
