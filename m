Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbZETBls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbZETBls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 21:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbZETBlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 21:41:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:30333 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbZETBlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 21:41:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer;
        b=Mqht/myEPZebVutmzBebVDZ5egplGYmC989zNt0mFE1x6m41wKnshEfI26MNV1c+mS
         DGvaQiQg8Rrtv2MqsL5+b4vvRZTR2tgLZRNEd1q/8kxdCbY93CporQbSO8kbRcwjDwln
         WjSxjOwiH45To0ItKdSHLgJDveVEawyXUzNiQ=
Subject: [PATCH 1/1] ftrace: fix typo in ftrace.txt file
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>,
       williams <williams@redhat.com>
Content-Type: multipart/mixed; boundary="=-6Ih8P79J4J1g0dZLXpZ6"
Organization: Private
Date: Wed, 20 May 2009 10:41:32 +0900
Message-Id: <1242783692.31161.56.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6Ih8P79J4J1g0dZLXpZ6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



commit 43bf3fdddfd6b0ac65ef59bec3c79d9f9064e8bd
Author: GeunSik,Lim <leemgs1@gmail.com>
Date:   Thu May 14 13:39:18 2009 +0900

    ftrace: fix typo in ftrace.txt file.
    
    Fix typo about chart to map the kernel priority to
    user land priorities.
    
    About sched_setscheduler(2)
    Processes scheduled under SCHED_FIFO or SCHED_RR
    can have a static priority in the range 1 to 99.
    
        Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index fd9a3e6..0e17632 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -518,9 +518,14 @@ priority with zero (0) being the highest priority and the nice
 values starting at 100 (nice -20). Below is a quick chart to map
 the kernel priority to user land priorities.
 
-  Kernel priority: 0 to 99    ==> user RT priority 99 to 0
-  Kernel priority: 100 to 139 ==> user nice -20 to 19
-  Kernel priority: 140        ==> idle task priority
+ Kernel priority: 0(high) to 99(low)    ==> user RT priority 99(high) to 1(low)
+ Kernel priority: 100(high) to 139(low) ==> user nice -20(high) to 19(low)
+ Kernel priority: 140                   ==> idle task priority
+
+Processes scheduled with SCHED_OTHER or SCHED_BATCH must be assigned
+the static priority 0. Processes scheduled under SCHED_FIFO or SCHED_RR 
+can have a static priority in the range 1 to 99. 
+ (reference: $> man 2 sched_setscheduler)
 
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

--=-6Ih8P79J4J1g0dZLXpZ6
Content-Disposition: attachment; filename=fix-typo-chart-map-priority-ftrace.patch
Content-Type: text/x-patch; name=fix-typo-chart-map-priority-ftrace.patch; charset=euckr
Content-Transfer-Encoding: 7bit

commit 43bf3fdddfd6b0ac65ef59bec3c79d9f9064e8bd
Author: GeunSik,Lim <leemgs1@gmail.com>
Date:   Thu May 14 13:39:18 2009 +0900

    ftrace: fix typo in ftrace.txt file.
    
    Fix typo about chart to map the kernel priority to
    user land priorities.
    
    About sched_setscheduler(2)
    Processes scheduled under SCHED_FIFO or SCHED_RR
    can have a static priority in the range 1 to 99.
    
        Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index fd9a3e6..0e17632 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -518,9 +518,14 @@ priority with zero (0) being the highest priority and the nice
 values starting at 100 (nice -20). Below is a quick chart to map
 the kernel priority to user land priorities.
 
-  Kernel priority: 0 to 99    ==> user RT priority 99 to 0
-  Kernel priority: 100 to 139 ==> user nice -20 to 19
-  Kernel priority: 140        ==> idle task priority
+ Kernel priority: 0(high) to 99(low)    ==> user RT priority 99(high) to 1(low)
+ Kernel priority: 100(high) to 139(low) ==> user nice -20(high) to 19(low)
+ Kernel priority: 140                   ==> idle task priority
+
+Processes scheduled with SCHED_OTHER or SCHED_BATCH must be assigned
+the static priority 0. Processes scheduled under SCHED_FIFO or SCHED_RR 
+can have a static priority in the range 1 to 99. 
+ (reference: $> man 2 sched_setscheduler)
 
 The task states are:
 

--=-6Ih8P79J4J1g0dZLXpZ6--

