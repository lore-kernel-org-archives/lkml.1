Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbYI3Sob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbYI3Sob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 14:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbYI3SoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 14:44:22 -0400
Received: from www.tglx.de ([62.245.132.106]:58024 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbYI3SoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 14:44:22 -0400
Message-Id: <20080930121337.905084180@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 30 Sep 2008 18:44:09 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Veen <arjan@infradead.org>
Subject: [patch 1/3] timer_list: print real timer address
References: <20080930121310.879471299@linutronix.de>
Content-Disposition: inline; filename=timerlist-make-output-useful.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current timer_list output prints the address of the on stack copy
of the active hrtimer instead of the hrtimer itself.

Print the address of the real timer instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timer_list.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6-tip/kernel/time/timer_list.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/timer_list.c
+++ linux-2.6-tip/kernel/time/timer_list.c
@@ -47,13 +47,14 @@ static void print_name_offset(struct seq
 }
 
 static void
-print_timer(struct seq_file *m, struct hrtimer *timer, int idx, u64 now)
+print_timer(struct seq_file *m, struct hrtimer *taddr, struct hrtimer *timer,
+	    int idx, u64 now)
 {
 #ifdef CONFIG_TIMER_STATS
 	char tmp[TASK_COMM_LEN + 1];
 #endif
 	SEQ_printf(m, " #%d: ", idx);
-	print_name_offset(m, timer);
+	print_name_offset(m, taddr);
 	SEQ_printf(m, ", ");
 	print_name_offset(m, timer->function);
 	SEQ_printf(m, ", S:%02lx", timer->state);
@@ -99,7 +100,7 @@ next_one:
 		tmp = *timer;
 		spin_unlock_irqrestore(&base->cpu_base->lock, flags);
 
-		print_timer(m, &tmp, i, now);
+		print_timer(m, timer, &tmp, i, now);
 		next++;
 		goto next_one;
 	}


