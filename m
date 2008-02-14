Return-Path: <linux-kernel-owner+w=401wt.eu-S1764633AbYBNKEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764633AbYBNKEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 05:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759738AbYBNKEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 05:04:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61098 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758082AbYBNKED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 05:04:03 -0500
Message-ID: <47B411A6.9030007@cn.fujitsu.com>
Date: Thu, 14 Feb 2008 18:02:14 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-rt-users@vger.kernel.org
CC: linux-kernel@vger.kernel.org, khilman@mvista.com, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2.6.24-rt1] timer:fix build warning in timer.c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following compile warning without CONFIG_PREEMPT_RT:
kernel/timer.c:937: warning: ‘count_active_rt_tasks’ defined but not used

Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com> 

---
diff -urpN linux-2.6.24-rt1.orig/kernel/timer.c linux-2.6.24-rt1/kernel/timer.c
--- linux-2.6.24-rt1.orig/kernel/timer.c	2008-02-14 17:01:49.000000000 +0800
+++ linux-2.6.24-rt1/kernel/timer.c	2008-02-14 17:31:10.000000000 +0800
@@ -930,20 +930,18 @@ static unsigned long count_active_tasks(
 #endif
 }
 
+#ifdef CONFIG_PREEMPT_RT
 /*
  * Nr of active tasks - counted in fixed-point numbers
  */
 static unsigned long count_active_rt_tasks(void)
 {
-#ifdef CONFIG_PREEMPT_RT
 	extern unsigned long rt_nr_running(void);
 	extern unsigned long rt_nr_uninterruptible(void);
 
 	return (rt_nr_running() + rt_nr_uninterruptible()) * FIXED_1;
-#else
-	return 0;
-#endif
 }
+#endif
 
 /*
  * Hmm.. Changed this, as the GNU make sources (load.c) seems to

