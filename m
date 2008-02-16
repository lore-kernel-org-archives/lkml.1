Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbYBPRKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbYBPRKP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 12:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYBPRKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 12:10:04 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:38035 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbYBPRKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 12:10:03 -0500
Message-ID: <47B718E5.6050905@tiscali.nl>
Date: Sat, 16 Feb 2008 18:09:57 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, rml@tech9.net
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/sched.c unlikely(x) || unlikely(y) => unlikely(x ||
 y)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not yet tested.
---
Replace unlikely(x) || unlikely(y) by unlikely(x || y)

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index f28f19e..816c299 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -137,7 +137,7 @@ static inline void sg_inc_cpu_power(struct sched_group *sg, u32 val)
 
 static inline int rt_policy(int policy)
 {
-	if (unlikely(policy == SCHED_FIFO) || unlikely(policy == SCHED_RR))
+	if (unlikely(policy == SCHED_FIFO || policy == SCHED_RR))
 		return 1;
 	return 0;
 }
@@ -3832,7 +3832,7 @@ static inline void schedule_debug(struct task_struct *prev)
 	 * schedule() atomically, we ignore that path for now.
 	 * Otherwise, whine if we are scheduling when we should not be.
 	 */
-	if (unlikely(in_atomic_preempt_off()) && unlikely(!prev->exit_state))
+	if (unlikely(in_atomic_preempt_off() && !prev->exit_state))
 		__schedule_bug(prev);
 
 	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
