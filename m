Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbZETBqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbZETBqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 21:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbZETBqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 21:46:37 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:37300 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbZETBqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 21:46:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer;
        b=mQFBhD3ag/S1peVAxGSVXWr1iX4px3n1XS0FSrGNINdQOkFFalQlZnp1mACdmiY5Oe
         VZqV33c34jOBjXJBXC5nlOPFT+63OuFmJfwgXFD8MvjeGg6tMogyv4lo0Moro1o18GdU
         q5dIwJ9RXPopGYuhoc3kJ2qewECBoovjTLbzc=
Subject: [PATCH 0/1] sched: fix typo in sched-rt-group.txt file
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, tglx <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-0ZxL3H7JOejuuPCyGgBd"
Organization: Private
Date: Wed, 20 May 2009 10:39:12 +0900
Message-Id: <1242783552.31161.53.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0ZxL3H7JOejuuPCyGgBd
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



Dear Ingo,


I made 2 patch files again about static prioriy levels according to ingo's advice 
and explanation. (Reference: http://marc.info/?t=124211992800003&r=1&w=2 archives. )

Fix static priority related range and chart map(userspace/kernelspace) of ftrace.
   - about chart map of static priority in  ftrace.txt file
   - about static priority levels(range) in sched-rt-group.txt file 


commit d6af702008117ca489a2f5476239d1688a517e98
Author: GeunSik,Lim <leemgs1@gmail.com>
Date:   Tue May 12 17:20:32 2009 +0900

    sched: fix typo in sched-rt-group.txt file
    
    Fix typo about static priority's range.

    * Kernel Space priority 0(high) to 99(low)   --> User Space RT priority 99(high) to 1(low)
    * Kernel Space priority 100(high) to 139(low)--> User Space nice -20(high) to 19(low)

    Processes scheduled with SCHED_OTHER or SCHED_BATCH must be assigned
    the static priority 0. Processes scheduled under SCHED_FIFO or SCHED_RR 
    can have a static priority in the range 1 to 99. 
    (reference: $> man 2 sched_setscheduler)
    
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

--=-0ZxL3H7JOejuuPCyGgBd
Content-Disposition: attachment; filename=fix-typo-static-priority-levels-sched-rt-group.patch
Content-Type: text/x-patch; name=fix-typo-static-priority-levels-sched-rt-group.patch; charset=euckr
Content-Transfer-Encoding: 7bit

commit d6af702008117ca489a2f5476239d1688a517e98
Author: GeunSik,Lim <leemgs1@gmail.com>
Date:   Tue May 12 17:20:32 2009 +0900

    sched: fix typo in sched-rt-group.txt file
    
    Fix typo about static priority's range.

    * Kernel Space priority 0(high) to 99(low)   --> User Space RT priority 99(high) to 1(low)
    * Kernel Space priority 100(high) to 139(low)--> User Space nice -20(high) to 19(low)

    Processes scheduled with SCHED_OTHER or SCHED_BATCH must be assigned
    the static priority 0. Processes scheduled under SCHED_FIFO or SCHED_RR 
    can have a static priority in the range 1 to 99. 
    (reference: $> man 2 sched_setscheduler)
    
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
 

--=-0ZxL3H7JOejuuPCyGgBd--

