Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab0BUOY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:24:27 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:63691 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab0BUOYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:24:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=cmsU/2GPoqxfOPCP7Egsn7yEFXCY1TRlbe/Ds4sRVYXaRX7GMR1WQ4YgW2fxlhr9su
         8uXUwmain94PAR1n3sbp/2v7caVC6jqi/4yZIikZThrv8EkaBsYFIHU6FZ3YXeJ9vVr2
         7ctcSCTGwsoJpF+tqVJ5dkGzYY5wRAyHcH1ak=
Date: Sun, 21 Feb 2010 22:24:12 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Dipankar Sarma <dipankar@in.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Josh Triplett <josh@joshtriplett.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 09/17] sysctl extern cleanup - rcu
Message-ID: <20100221142412.GA3011@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move rcutorture_runnable extern declaration to linux/rcupdate.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Acked-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/rcupdate.h |    4 ++++
 kernel/sysctl.c          |    3 ---
 2 files changed, 4 insertions(+), 3 deletions(-)

--- linux-2.6.32.orig/include/linux/rcupdate.h	2010-02-21 09:35:58.013190490 +0800
+++ linux-2.6.32/include/linux/rcupdate.h	2010-02-21 10:03:53.296358225 +0800
@@ -41,6 +41,10 @@
 #include <linux/lockdep.h>
 #include <linux/completion.h>
 
+#ifdef CONFIG_RCU_TORTURE_TEST
+extern int rcutorture_runnable; /* for sysctl */
+#endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
+
 /**
  * struct rcu_head - callback structure for use with RCU
  * @next: next update requests in a list
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-21 09:58:40.029722800 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-21 10:01:30.257204779 +0800
@@ -75,9 +75,6 @@
 
 /* External variables not in a header file. */
 extern int max_threads;
-#ifdef CONFIG_RCU_TORTURE_TEST
-extern int rcutorture_runnable;
-#endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 #ifdef CONFIG_BLOCK
 extern int blk_iopoll_enabled;
 #endif
