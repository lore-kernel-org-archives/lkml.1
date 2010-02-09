Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab0BIOuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 09:50:13 -0500
Received: from mail-iw0-f183.google.com ([209.85.223.183]:65084 "EHLO
	mail-iw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab0BIOuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 09:50:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hx44Pi4r5yE9wNVf0d8D9vSYafhqYK5EmlZuqKrddq4WwHRlsbjiadXF+wjtTAfoQQ
         Ly3Lw08aBhA6rMuRqnCCotKQQh9iBjaA/LNQHixWRLpVexqqfSym/cg7i7zrVRiaHO/E
         vav3C+esj2b4eESJ8cKHRg+BQZ/bENZU6TSQ4=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] sched: cleanup pre_schedule_rt
Date: Tue,  9 Feb 2010 22:43:59 +0800
Message-Id: <1265726639-21534-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since [commit 9a897c5a:
sched: RT-balance, replace hooks with pre/post schedule and wakeup methods]
we must call pre_schedule_rt if prev is rt task.
So condition rt_task(prev) is always true and the 'unlikely' declaration is
odd.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/sched_rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index f48328a..704b790 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1459,7 +1459,7 @@ static int pull_rt_task(struct rq *this_rq)
 static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
 {
 	/* Try to pull RT tasks here if we lower this rq's prio */
-	if (unlikely(rt_task(prev)) && rq->rt.highest_prio.curr > prev->prio)
+	if (rq->rt.highest_prio.curr > prev->prio)
 		pull_rt_task(rq);
 }
 
-- 
1.6.3.3

