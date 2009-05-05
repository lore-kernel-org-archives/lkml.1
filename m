Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbZEEXxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbZEEXxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 19:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbZEEXxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 19:53:37 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:32136
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753464AbZEEXxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 19:53:36 -0400
X-BigFish: VS28(zzzz1202h10c0jzzz2dh6bh15fn87il62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
Message-ID: <4A00D16A.3000908@am.sony.com>
Date: Tue, 5 May 2009 16:53:14 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: mingo@redhat.com
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [patch] RT: calc_load() uses wrong variable to calculate RT load
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 May 2009 23:53:22.0949 (UTC) FILETIME=[ACA0D350:01C9CDDC]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In calc_load() use RT tasks to calculate the RT load.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>

---

Ingo,

In calc_load():

#ifdef CONFIG_PREEMPT_RT
                active_rt_tasks = count_active_rt_tasks();
#endif

but active_rt_tasks is then not used.  I have not read through enough code
to verify my supposition, but the obvious use of this variable would be for
the calculation of the RT load average.

If my supposition is correct, this patch fixes the problem.

The patch is compile tested only.

-Frank Rowand
Sony Corporation of America


Index: linux-2.6.29.2/kernel/timer.c
===================================================================
--- linux-2.6.29.2.orig/kernel/timer.c
+++ linux-2.6.29.2/kernel/timer.c
@@ -1249,9 +1249,9 @@ static inline void calc_load(unsigned lo
 			CALC_LOAD(avenrun[1], EXP_5, active_tasks);
 			CALC_LOAD(avenrun[2], EXP_15, active_tasks);
 #ifdef CONFIG_PREEMPT_RT
-			CALC_LOAD(avenrun_rt[0], EXP_1, active_tasks);
-			CALC_LOAD(avenrun_rt[1], EXP_5, active_tasks);
-			CALC_LOAD(avenrun_rt[2], EXP_15, active_tasks);
+			CALC_LOAD(avenrun_rt[0], EXP_1, active_rt_tasks);
+			CALC_LOAD(avenrun_rt[1], EXP_5, active_rt_tasks);
+			CALC_LOAD(avenrun_rt[2], EXP_15, active_rt_tasks);
 #endif
 			count += LOAD_FREQ;
 

