Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbXLDVLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbXLDVLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbXLDVH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:07:28 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53465
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754415AbXLDVH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:07:26 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 12/23] Subject: SCHED - Allow current_cpu to be included in
	search
To: mingo@elte.hu
Cc: rostedt@goodmis.org, ghaskins@novell.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2007 15:45:26 -0500
Message-ID: <20071204204526.3567.35485.stgit@novell1.haskins.net>
In-Reply-To: <20071204204236.3567.65491.stgit@novell1.haskins.net>
References: <20071204204236.3567.65491.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't hurt if we allow the current CPU to be included in the
search.  We will just simply skip it later if the current CPU turns out
to be the lowest.

We will use this later in the series

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---

 kernel/sched_rt.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 7e26c2c..7e444f4 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -275,9 +275,6 @@ static int find_lowest_rq(struct task_struct *task)
 	for_each_cpu_mask(cpu, *cpu_mask) {
 		struct rq *rq = cpu_rq(cpu);
 
-		if (cpu == rq->cpu)
-			continue;
-
 		/* We look for lowest RT prio or non-rt CPU */
 		if (rq->rt.highest_prio >= MAX_RT_PRIO) {
 			lowest_rq = rq;
@@ -305,7 +302,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
 	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
 		cpu = find_lowest_rq(task);
 
-		if (cpu == -1)
+		if ((cpu == -1) || (cpu == rq->cpu))
 			break;
 
 		lowest_rq = cpu_rq(cpu);

