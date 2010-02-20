Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab0BTOQb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:16:31 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:45193 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab0BTOQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:16:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=f0mUZ2rLGY2JFMgHhzvz67csOzcJQGXx+Xm20i+0eHEB0nfR9HQB3yV7NUtifTAly/
         nGqB9aMQttH2ijX9xc5w5CZVIALV1vYJyFr3LvWY1SVWCXKYrsnWiHPIunDdaFC3GURm
         pvKpP4rhpyPhr1x4pJuawbi4udbfveIrZXMRQ=
Date: Sat, 20 Feb 2010 22:16:20 +0800
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
Subject: [PATCH 10/18] sysctl extern cleanup - rcu
Message-ID: <20100220141620.GI3195@darkstar>
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
---
 include/linux/rcupdate.h |    6 ++++++
 kernel/sysctl.c          |    3 ---
 2 files changed, 6 insertions(+), 3 deletions(-)

--- linux-2.6.32.orig/include/linux/rcupdate.h	2010-02-20 14:02:21.664925977 +0800
+++ linux-2.6.32/include/linux/rcupdate.h	2010-02-20 14:21:31.394811788 +0800
@@ -41,6 +41,12 @@
 #include <linux/lockdep.h>
 #include <linux/completion.h>
 
+#ifdef CONFIG_SYSCTL
+#ifdef CONFIG_RCU_TORTURE_TEST
+extern int rcutorture_runnable;
+#endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
+#endif
+
 /**
  * struct rcu_head - callback structure for use with RCU
  * @next: next update requests in a list
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-20 14:18:05.088997885 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-20 14:20:08.432318998 +0800
@@ -75,9 +75,6 @@
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
-#ifdef CONFIG_RCU_TORTURE_TEST
-extern int rcutorture_runnable;
-#endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 #ifdef CONFIG_BLOCK
 extern int blk_iopoll_enabled;
 #endif
