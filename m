Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZLWQD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZLWQD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 11:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbZLWQDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 11:03:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44862 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745AbZLWQDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 11:03:24 -0500
Date: Wed, 23 Dec 2009 17:03:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fix
Message-ID: <20091223160308.GA12413@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      sched: Revert 738d2be, simplify set_task_cpu()


 kernel/sched.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 87f1f47..c535cc4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2045,11 +2045,10 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 
 	trace_sched_migrate_task(p, new_cpu);
 
-	if (task_cpu(p) == new_cpu)
-		return;
-
-	p->se.nr_migrations++;
-	perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
+	if (task_cpu(p) != new_cpu) {
+		p->se.nr_migrations++;
+		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
+	}
 
 	__set_task_cpu(p, new_cpu);
 }
