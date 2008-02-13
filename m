Return-Path: <linux-kernel-owner+w=401wt.eu-S934544AbYBMVoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934544AbYBMVoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764034AbYBMVa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:56 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47533 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763998AbYBMVaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:55 -0500
Date: Wed, 13 Feb 2008 23:30:40 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] #if 0 tasklet_kill_immediate()
Message-ID: <20080213213040.GK3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch #if 0's the no longer used tasklet_kill_immediate().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 29 Jan 2008

 include/linux/interrupt.h |    1 -
 kernel/softirq.c          |    3 +++
 2 files changed, 3 insertions(+), 1 deletion(-)

06fc93a10822d4e9c53eaa2b4d0a16792305957e 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index c3db4a0..59d31dc 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -384,7 +384,6 @@ static inline void tasklet_hi_enable(struct tasklet_struct *t)
 }
 
 extern void tasklet_kill(struct tasklet_struct *t);
-extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
 extern void tasklet_init(struct tasklet_struct *t,
 			 void (*func)(unsigned long), unsigned long data);
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index bd89bc4..0f87c36 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -527,6 +527,8 @@ wait_to_die:
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
+
+#if 0
 /*
  * tasklet_kill_immediate is called to remove a tasklet which can already be
  * scheduled for execution on @cpu.
@@ -555,6 +557,7 @@ void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu)
 	}
 	BUG();
 }
+#endif  /*  0  */
 
 static void takeover_tasklets(unsigned int cpu)
 {

