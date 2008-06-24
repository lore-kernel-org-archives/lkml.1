Return-Path: <linux-kernel-owner+w=401wt.eu-S1760095AbYFXOQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095AbYFXOQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbYFXOQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:16:15 -0400
Received: from lsg.lsg.lab.novell.com ([151.155.230.1]:5025 "EHLO
	lsg.lsg.lab.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759354AbYFXOQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:16:13 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 3/3] sched: terminate newidle balancing once at least one task
	has moved over
To: mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       linux-rt-users@vger.kernel.org, ghaskins@novell.com, dbahi@novell.com,
       npiggin@suse.de
Date: Tue, 24 Jun 2008 08:16:12 -0600
Message-ID: <20080624141612.28487.18128.stgit@lsg.lsg.lab.novell.com>
In-Reply-To: <20080624141527.28487.77778.stgit@lsg.lsg.lab.novell.com>
References: <20080624141527.28487.77778.stgit@lsg.lsg.lab.novell.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inspired by Peter Zijlstra.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e40c575..094a84b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2774,6 +2774,10 @@ static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 				max_load_move - total_load_moved,
 				sd, idle, all_pinned, &this_best_prio);
 		class = class->next;
+
+		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
+			break;
+
 	} while (class && max_load_move > total_load_moved);
 
 	return total_load_moved > 0;

