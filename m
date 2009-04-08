Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbZDHKaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbZDHKaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758797AbZDHKaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:30:20 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:33694 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758360AbZDHKaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:30:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18908.31922.411398.147810@cargo.ozlabs.ibm.com>
Date: Wed, 8 Apr 2009 20:30:10 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] perfcounters: fix powerpc build
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4af4998b ("perf_counter: rework context time") changed struct
perf_counter_context to have a 'time' field instead of a 'time_now'
field, but neglected to fix the place in the powerpc perf_counter.c
where the time_now field was accessed.  This fixes it.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
Ingo, please pull this and the following patch ("perfcounters:
powerpc: set sample enable bit for marked instruction events") from
the master branch of my perfcounters.git repository at:

 git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master

 arch/powerpc/kernel/perf_counter.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index f88c35d..0e56513 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -457,8 +457,7 @@ static void counter_sched_in(struct perf_counter *counter, int cpu)
 {
 	counter->state = PERF_COUNTER_STATE_ACTIVE;
 	counter->oncpu = cpu;
-	counter->tstamp_running += counter->ctx->time_now -
-		counter->tstamp_stopped;
+	counter->tstamp_running += counter->ctx->time - counter->tstamp_stopped;
 	if (is_software_counter(counter))
 		counter->hw_ops->enable(counter);
 }
-- 
1.5.6.3

