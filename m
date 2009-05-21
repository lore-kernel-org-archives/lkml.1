Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbZEUFqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbZEUFqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 01:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbZEUFqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 01:46:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:32756 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZEUFqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 01:46:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer;
        b=Ph4e2h6KpWJJOHjsjC9cllCN25XUakxyRs3zGMac3OY80ZNTH8qWAEyKiMq7U0UJun
         33gzYyz5Kij7BY0o7BNsGqwocU//zsyzBF+f2TVKkIsR3jCVyEgwTgKNByshhEDOmYxJ
         6pOednoo50Q7iMsNiq7lrVgst0IEsHTQuqBNw=
Subject: [PATCH 0/1 ,v3] sched: fix typo in sched-rt-group.txt file
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       tglx <tglx@linutronix.de>, williams <williams@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: multipart/mixed; boundary="=-ltacyN9FSQbNQGx1C6+J"
Organization: Private
Date: Thu, 21 May 2009 14:39:20 +0900
Message-Id: <1242884360.31161.77.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ltacyN9FSQbNQGx1C6+J
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



Dear Ingo,

I made 2 patch files again about static prioriy levels to map between kernel-space
and usper-space according to opinions and helps from Peter, Ingo, Steven.

Fix static priority related range and chart map(userspace/kernelspace) of ftrace.
  - about chart map of static priority  in ftrace.txt file
  - about static priority levels(range) in sched-rt-group.txt file

Please, drop my previous version and merge this. 

Changelog since V3
 o Modified kernel static priority to map user rt priority ( 99 ~ 1).
    - Archives: http://marc.info/?l=linux-kernel&m=124279443511114&w=2
    - before  : Kernel priority: 0(high) to 99(low)  --> user RT priority 99(high) to 1(low)
    - after   : Kernel priority: 0(high) to 98(low)  --> user RT priority 99(high) to 1(low)


Changelog since V2
 o Modified description static priority(SCHED_FIFO,SCHED_RR) levels of user-space using sched_setscheduler(2)
     - Archives: http://marc.info/?t=124211992800003&r=1&w=2     
     - before  : Kernel priority: 0(high) to 99(low)  --> user RT priority 99(high) to 0(low)
     - after   : Kernel priority: 0(high) to 99(low)  --> user RT priority 99(high) to 1(low)
 o Modified static priority related quick chart of sched_switch section in ./Documentation/trace/ftrace.txt file


Changelog since V1
 o Changed static priority levels of kernel-space. ( 0 ~ 139 --> 0-99 ) in sched-rt-group.txt file


commit d6af702008117ca489a2f5476239d1688a517e98
Author: GeunSik,Lim <leemgs1@gmail.com>
Date:   Tue May 12 17:20:32 2009 +0900

    sched: fix typo in sched-rt-group.txt file
    
    Fix typo about static priority's range.

    * Kernel Space priority 0(high) to 98(low)   --> User Space RT priority 99(high) to 1(low) with SCHED_RR or SCHED_FIFO
    * Kernel Space priority 99 --> sched_priority is not used in scheduling decisions (it must be specified as 0)
    * Kernel Space priority 100(high) to 139(low)--> User Space nice -20(high) to 19(low)

    For processes scheduled under one of the normal scheduling policies
    (SCHED_OTHER, SCHED_IDLE, SCHED_BATCH), sched_priority is not used in
    scheduling decisions (it must be specified as 0).

    Processes scheduled under one of the real-time policies(SCHED_FIFO,SCHED_RR)
    have a sched_priority value in the range 1 (low) to 99 (high). 
    (reference: http://www.kernel.org/doc/man-pages/online/pages/man2/sched_setscheduler.2.html)
    
    Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>

diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
index 5ba4d3f..1537146 100644
--- a/Documentation/scheduler/sched-rt-group.txt
+++ b/Documentation/scheduler/sched-rt-group.txt
@@ -169,7 +169,7 @@ get their allocated time.
 
 Implementing SCHED_EDF might take a while to complete. Priority Inheritance is
 the biggest challenge as the current linux PI infrastructure is geared towards
-the limited static priority levels 0-139. With deadline scheduling you need to
+the limited static priority levels 0-99. With deadline scheduling you need to
 do deadline inheritance (since priority is inversely proportional to the
 deadline delta (deadline - now).
 




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

--=-ltacyN9FSQbNQGx1C6+J
Content-Disposition: attachment; filename=fix-typo-static-priority-levels-sched-rt-group.v3.patch
Content-Type: text/x-patch; name=fix-typo-static-priority-levels-sched-rt-group.v3.patch; charset=euckr
Content-Transfer-Encoding: 7bit

commit d6af702008117ca489a2f5476239d1688a517e98
Author: GeunSik,Lim <leemgs1@gmail.com>
Date:   Tue May 12 17:20:32 2009 +0900

    sched: fix typo in sched-rt-group.txt file
    
    Fix typo about static priority's range.

    * Kernel Space priority 0(high) to 98(low)   --> User Space RT priority 99(high) to 1(low) with SCHED_RR or SCHED_FIFO
    * Kernel Space priority 99 --> sched_priority is not used in scheduling decisions (it must be specified as 0)
    * Kernel Space priority 100(high) to 139(low)--> User Space nice -20(high) to 19(low)

    For processes scheduled under one of the normal scheduling policies
    (SCHED_OTHER, SCHED_IDLE, SCHED_BATCH), sched_priority is not used in
    scheduling decisions (it must be specified as 0).

    Processes scheduled under one of the real-time policies(SCHED_FIFO,SCHED_RR)
    have a sched_priority value in the range 1 (low) to 99 (high). 
    (reference: http://www.kernel.org/doc/man-pages/online/pages/man2/sched_setscheduler.2.html)
    
    Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>

diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
index 5ba4d3f..1537146 100644
--- a/Documentation/scheduler/sched-rt-group.txt
+++ b/Documentation/scheduler/sched-rt-group.txt
@@ -169,7 +169,7 @@ get their allocated time.
 
 Implementing SCHED_EDF might take a while to complete. Priority Inheritance is
 the biggest challenge as the current linux PI infrastructure is geared towards
-the limited static priority levels 0-139. With deadline scheduling you need to
+the limited static priority levels 0-99. With deadline scheduling you need to
 do deadline inheritance (since priority is inversely proportional to the
 deadline delta (deadline - now).
 

--=-ltacyN9FSQbNQGx1C6+J--

