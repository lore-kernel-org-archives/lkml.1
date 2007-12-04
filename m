Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbXLDVNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbXLDVNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbXLDVHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:07:53 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53491
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755220AbXLDVHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:07:51 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 17/23] Subject: SCHED - restore the migratable conditional
To: mingo@elte.hu
Cc: rostedt@goodmis.org, ghaskins@novell.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2007 15:45:51 -0500
Message-ID: <20071204204551.3567.39375.stgit@novell1.haskins.net>
In-Reply-To: <20071204204236.3567.65491.stgit@novell1.haskins.net>
References: <20071204204236.3567.65491.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to bother searching if the task cannot be migrated

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---

 kernel/sched_rt.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index e007d2b..fe0b43f 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -174,7 +174,8 @@ static int select_task_rq_rt(struct task_struct *p, int sync)
 	 * that is just being woken and probably will have
 	 * cold cache anyway.
 	 */
-	if (unlikely(rt_task(rq->curr))) {
+	if (unlikely(rt_task(rq->curr)) &&
+	    (p->nr_cpus_allowed > 1)) {
 		int cpu = find_lowest_rq(p);
 
 		return (cpu == -1) ? task_cpu(p) : cpu;

