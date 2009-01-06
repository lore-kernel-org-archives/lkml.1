Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbZAFJlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbZAFJlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbZAFJla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:41:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60695 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbZAFJl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:41:29 -0500
Message-ID: <49632714.90208@cn.fujitsu.com>
Date: Tue, 06 Jan 2009 17:40:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: fix section mismatch
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: section mismatch fixes

init_rootdomain() calls alloc_bootmem_cpumask_var() at system boot,
so does cpupri_init().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched.c        |    2 +-
 kernel/sched_cpupri.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 2bad712..ce691f2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6957,7 +6957,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	spin_unlock_irqrestore(&rq->lock, flags);
 }
 
-static int init_rootdomain(struct root_domain *rd, bool bootmem)
+static int __init_refok init_rootdomain(struct root_domain *rd, bool bootmem)
 {
 	memset(rd, 0, sizeof(*rd));
 
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index 018b7be..1e00bfa 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -151,7 +151,7 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
  *
  * Returns: -ENOMEM if memory fails.
  */
-int cpupri_init(struct cpupri *cp, bool bootmem)
+int __init_refok cpupri_init(struct cpupri *cp, bool bootmem)
 {
 	int i;
 
-- 
1.5.4.rc3
