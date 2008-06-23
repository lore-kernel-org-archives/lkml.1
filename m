Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbYFWXG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbYFWXG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbYFWXFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:05:40 -0400
Received: from lsg.lsg.lab.novell.com ([151.155.230.1]:8687 "EHLO
	lsg.lsg.lab.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbYFWXEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:04:50 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 3/3] sched: terminate newidle balancing once at least one task
	has moved over
To: mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       linux-rt-users@vger.kernel.org, ghaskins@novell.com, dbahi@novell.com
Date: Mon, 23 Jun 2008 17:04:50 -0600
Message-ID: <20080623230450.31515.75112.stgit@lsg.lsg.lab.novell.com>
In-Reply-To: <20080623225645.31515.36393.stgit@lsg.lsg.lab.novell.com>
References: <20080623225645.31515.36393.stgit@lsg.lsg.lab.novell.com>
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
index 3efbbc5..c8e8520 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2775,6 +2775,10 @@ static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 				max_load_move - total_load_moved,
 				sd, idle, all_pinned, &this_best_prio);
 		class = class->next;
+
+		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
+			break;
+
 	} while (class && max_load_move > total_load_moved);
 
 	return total_load_moved > 0;

