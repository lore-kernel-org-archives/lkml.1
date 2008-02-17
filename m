Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbYBQQwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbYBQQwM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 11:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYBQQv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 11:51:58 -0500
Received: from www.tglx.de ([62.245.132.106]:56301 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbYBQQv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 11:51:57 -0500
Date: Sun, 17 Feb 2008 17:51:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timer fixes for 2.6.25
Message-ID: <alpine.LFD.1.00.0802171745541.7583@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git

Thanks,
	tglx

---

Pavel Machek (1):
      timer_list: print relative expiry time signed

 kernel/time/timer_list.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index d3d94c1..67fe8fc 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -65,9 +65,9 @@ print_timer(struct seq_file *m, struct hrtimer *timer, int idx, u64 now)
 	SEQ_printf(m, ", %s/%d", tmp, timer->start_pid);
 #endif
 	SEQ_printf(m, "\n");
-	SEQ_printf(m, " # expires at %Lu nsecs [in %Lu nsecs]\n",
+	SEQ_printf(m, " # expires at %Lu nsecs [in %Ld nsecs]\n",
 		(unsigned long long)ktime_to_ns(timer->expires),
-		(unsigned long long)(ktime_to_ns(timer->expires) - now));
+		(long long)(ktime_to_ns(timer->expires) - now));
 }
 
 static void
