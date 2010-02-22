Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab0BVW5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 17:57:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:5889 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554Ab0BVW5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 17:57:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,521,1262592000"; 
   d="scan'208";a="774971869"
Message-Id: <20100222225240.642169080@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 22 Feb 2010 14:51:34 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com,
       suresh.b.siddha@intel.com
Subject: [patch 3/3] x86, ptrace: remove set_stopped_child_used_math() in [x]fpregs_set
References: <20100222225240.397523600@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=fix_fpregset_set_stopped_child_used_math.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_fpu() already ensures that the used_math() is set for the stopped child.
Remove the redundant set_stopped_child_used_math() in [x]fpregs_set()

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/i387.c |    4 ----
 1 file changed, 4 deletions(-)

Index: tip/arch/x86/kernel/i387.c
===================================================================
--- tip.orig/arch/x86/kernel/i387.c
+++ tip/arch/x86/kernel/i387.c
@@ -209,8 +209,6 @@ int xfpregs_set(struct task_struct *targ
 	if (ret)
 		return ret;
 
-	set_stopped_child_used_math(target);
-
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 				 &target->thread.xstate->fxsave, 0, -1);
 
@@ -471,8 +469,6 @@ int fpregs_set(struct task_struct *targe
 	if (ret)
 		return ret;
 
-	set_stopped_child_used_math(target);
-
 	if (!HAVE_HWFP)
 		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
 


