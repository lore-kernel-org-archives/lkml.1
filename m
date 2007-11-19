Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbXKSQxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbXKSQxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 11:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbXKSQxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 11:53:39 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:56464
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753418AbXKSQxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 11:53:38 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] RT: restore the migratable conditional
To: Steven Rostedt <rostedt@goodmis.org>, "LKML <linux-kernel"@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>
Date: Mon, 19 Nov 2007 11:34:10 -0500
Message-ID: <20071119163316.17268.1072.stgit@novell1.haskins.net>
In-Reply-To: <473EE2BE.BA47.005A.0@novell.com>
References: <473EE2BE.BA47.005A.0@novell.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(This applies to the end of Steven's "v3" series
http://lkml.org/lkml/2007/11/17/10)

----------

We don't need to bother searching if the task cannot be migrated

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched_rt.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 9c640c8..0026f11 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -173,7 +173,8 @@ static int select_task_rq_rt(struct task_struct *p, int sync)
 	 * that is just being woken and probably will have
 	 * cold cache anyway.
 	 */
-	if (unlikely(rt_task(rq->curr))) {
+	if (unlikely(rt_task(rq->curr)) &&
+	    (p->nr_cpus_allowed > 1)) {
 		int cpu = find_lowest_rq(p);
 
 		return (cpu == -1) ? task_cpu(p) : cpu;

