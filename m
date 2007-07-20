Return-Path: <linux-kernel-owner+w=401wt.eu-S934589AbXGTSot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934589AbXGTSot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 14:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759424AbXGTSol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 14:44:41 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58331 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXGTSoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 14:44:39 -0400
Subject: [PATCH] CFS: Mark print_cfs_stats static
From: Josh Triplett <josh@kernel.org>
Reply-To: josh@kernel.org, josht@linux.vnet.ibm.com
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-rt-users@vger.kernel.org, mingo@elte.hu
Content-Type: text/plain
Date: Fri, 20 Jul 2007 11:44:57 -0700
Message-Id: <1184957097.2630.17.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sched_fair.c defines print_cfs_stats, and sched_debug.c uses it, but sched.c
includes both sched_fair.c and sched_debug.c, so all the references to
print_cfs_stats occur in the same compilation unit.  Thus, mark
print_cfs_stats static.

Eliminates a sparse warning:
warning: symbol 'print_cfs_stats' was not declared. Should it be static?

Signed-off-by: Josh Triplett <josh@kernel.org>
---
This patch applies both to current Git and to 2.6.22.1-rt4.

 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 6971db0..8b954b9 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1120,7 +1120,7 @@ struct sched_class fair_sched_class __read_mostly = {
 };
 
 #ifdef CONFIG_SCHED_DEBUG
-void print_cfs_stats(struct seq_file *m, int cpu, u64 now)
+static void print_cfs_stats(struct seq_file *m, int cpu, u64 now)
 {
 	struct rq *rq = cpu_rq(cpu);
 	struct cfs_rq *cfs_rq;
-- 
1.5.2.1


