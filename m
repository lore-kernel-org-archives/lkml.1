Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbZEUFp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbZEUFp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 01:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbZEUFpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 01:45:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:35804 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZEUFpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 01:45:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer;
        b=fOsMACwTr5oFmRbkxfB1p0RRseeFD/uaKYDsdlwD5+omaYyV8b6vX/2rJsToQ5RNpa
         nTCWM79N8butKYxV+z0cGWW6cNuUKp6oHUpHQ7VBlyCrba3kJz65nT2srKSnZRv/1cbp
         /xA+IJPEyTXy+KmrnHdChV37PlDNJ8U1VB6sw=
Subject: [PATCH 1/1 ,v3] ftrace: fix typo in ftrace.txt file
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Ingo Molnar <mingo@elte.hu>
Cc: williams <williams@redhat.com>, tglx <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-iMR7aJYC9XANTYDiyTeo"
Organization: Private
Date: Thu, 21 May 2009 14:39:25 +0900
Message-Id: <1242884365.31161.78.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iMR7aJYC9XANTYDiyTeo
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


-- 

commit 16d92cb2334b19751db851d221aab814cd9da1af
Author: GeunSik,Lim <leemgs1@gmail.com>
Date:   Thu May 21 14:31:17 2009 +0900

            ftrace: fix typo in ftrace.txt file.
    
            Fix typo about chart to map the kernel priority to
            user land priorities.
    
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
 

-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim (ELS - OS Group - S/W Lab - SAIT - SAMSUNG)
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://intomail.dnip.net/invain/me/
-----------------------------------------------

--=-iMR7aJYC9XANTYDiyTeo
Content-Disposition: attachment; filename=fix-typo-chart-map-priority-ftrace.v3.patch
Content-Type: text/x-patch; name=fix-typo-chart-map-priority-ftrace.v3.patch; charset=euckr
Content-Transfer-Encoding: 7bit

commit 16d92cb2334b19751db851d221aab814cd9da1af
Author: GeunSik,Lim <leemgs1@gmail.com>
Date:   Thu May 21 14:31:17 2009 +0900

            ftrace: fix typo in ftrace.txt file.
    
            Fix typo about chart to map the kernel priority to
            user land priorities.
    
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
 

--=-iMR7aJYC9XANTYDiyTeo--

