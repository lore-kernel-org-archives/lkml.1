Return-Path: <linux-kernel-owner+w=401wt.eu-S1761911AbZE1Bgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761911AbZE1Bgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 21:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760327AbZE1BgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 21:36:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:60703 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759931AbZE1BgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 21:36:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=VIpFXYxUFbLVwMiy8PMkR8YKy6i8HrtzOFRTrAwF612N0qIO8nSxTRAgUAlR2q1FPR
         EcmVr+ua7GGTiR4MXT8TxCcOFQkWNgnTqS9jYm8tXEsNH7bRnFMTMG0ldSNc2KH8DfaF
         SEzDcM+KR/5AB//Q201jrLMQJXqlBgrRpq2Is=
Subject: [RESEND] [PATCH 1/2 V3] ftrace: fix typo about map of kernel
	priority in ftrace.txt file.
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       tglx <tglx@linutronix.de>, williams <williams@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1242884360.31161.77.camel@centos51>
References: <1242884360.31161.77.camel@centos51>
Content-Type: text/plain
Organization: Private
Date: Thu, 28 May 2009 10:36:11 +0900
Message-Id: <1243474571.14685.37.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>From 5764d50e29e08d86f7f3b7dff66d7c1ad4762ff8 Mon Sep 17 00:00:00 2001
From: GeunSik,Lim <leemgs1@gmail.com>
Date: Thu, 28 May 2009 09:57:28 +0900
Subject: [PATCH 1/2] ftrace: fix typo about map of kernel priority in ftrace.txt file.

Fix typo about chart to map the kernel priority to user land priorities.

   * About sched_setscheduler(2)
      Processes scheduled under SCHED_FIFO or SCHED_RR
      can have a (user-space) static priority in the range 1 to 99.
      (reference: http://www.kernel.org/doc/man-pages/online/pages/
                  man2/sched_setscheduler.2.html)

   * From: Steven Rostedt
      0 to 98 - maps to RT tasks 99 to 1 (SCHED_RR or SCHED_FIFO)

      99 - maps to internal kernel threads that want to be lower than RT tasks
      but higher than SCHED_OTHER tasks. Although I'm not sure if any
      kernel thread actually uses this. I'm not even sure how this can be
      set, because the internal sched_setscheduler function does not allow
      for it.

      100 to 139 - maps nice levels -20 to 19. These are not set via
      sched_setscheduler, but are set via the nice system call.

      140 - reserved for idle tasks.

        Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
        Acked-by     : Steven Rostedt <rostedt@goodmis.org>
        CC           : Ingo Molnar <mingo@elte.hu>
---
 Documentation/trace/ftrace.txt |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index fd9a3e6..e362f50 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -518,9 +518,18 @@ priority with zero (0) being the highest priority and the nice
 values starting at 100 (nice -20). Below is a quick chart to map
 the kernel priority to user land priorities.
 
-  Kernel priority: 0 to 99    ==> user RT priority 99 to 0
-  Kernel priority: 100 to 139 ==> user nice -20 to 19
-  Kernel priority: 140        ==> idle task priority
+   Kernel Space                     User Space
+ ===============================================================
+   0(high) to  98(low)     user RT priority 99(high) to 1(low)
+                           with SCHED_RR or SCHED_FIFO
+ ---------------------------------------------------------------
+  99                       sched_priority is not used in scheduling
+                           decisions(it must be specified as 0)
+ ---------------------------------------------------------------
+ 100(high) to 139(low)     user nice -20(high) to 19(low)
+ ---------------------------------------------------------------
+ 140                       idle task priority
+ ---------------------------------------------------------------
 
 The task states are:
 
-- 
1.6.3.1


-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim (  S A M S U N G     E L E C T R O N I C S  )
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://blog.naver.com/invain/
-----------------------------------------------

