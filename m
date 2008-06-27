Return-Path: <linux-kernel-owner+w=401wt.eu-S1763195AbYF0UbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763195AbYF0UbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbYF0U35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:29:57 -0400
Received: from lsg.lsg.lab.novell.com ([151.155.230.1]:8160 "EHLO
	lsg.lsg.lab.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759982AbYF0U3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:29:55 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/3] sched: terminate newidle balancing once at least one task
	has moved over
To: mingo@elte.hu, peterz@infradead.org
Cc: npiggin@suse.de, ghaskins@novell.com, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Date: Fri, 27 Jun 2008 14:29:55 -0600
Message-ID: <20080627202955.3829.78937.stgit@lsg.lsg.lab.novell.com>
In-Reply-To: <20080627202444.3829.21595.stgit@lsg.lsg.lab.novell.com>
References: <20080627202444.3829.21595.stgit@lsg.lsg.lab.novell.com>
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
index 56722b1..0b9f90e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2863,6 +2863,10 @@ static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 				max_load_move - total_load_moved,
 				sd, idle, all_pinned, &this_best_prio);
 		class = class->next;
+
+		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
+			break;
+
 	} while (class && max_load_move > total_load_moved);
 
 	return total_load_moved > 0;

