Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbYJWNhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbYJWNhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYJWNhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:37:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52098 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbYJWNhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:37:25 -0400
Message-Id: <20081023133723.268161704@goodmis.org>
References: <20081023133256.926296694@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Oct 2008 09:33:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wenji Huang <wenji.huang@oracle.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 04/12 v3] ftrace: comment arch ftrace code
Content-Disposition: inline; filename=ftrace-comment-mod-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add comments to explain what is happening in the x86 arch ftrace code.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-compile.git/arch/x86/kernel/ftrace.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/ftrace.c	2008-10-22 15:23:20.000000000 -0400
+++ linux-compile.git/arch/x86/kernel/ftrace.c	2008-10-22 15:24:15.000000000 -0400
@@ -66,18 +66,23 @@ ftrace_modify_code(unsigned long ip, uns
 	/*
 	 * Note: Due to modules and __init, code can
 	 *  disappear and change, we need to protect against faulting
-	 *  as well as code changing.
+	 *  as well as code changing. We do this by using the
+	 *  __copy_*_user functions.
 	 *
 	 * No real locking needed, this code is run through
 	 * kstop_machine, or before SMP starts.
 	 */
+
+	/* read the text we want to modify */
 	if (__copy_from_user_inatomic(replaced, (char __user *)ip,
 				      MCOUNT_INSN_SIZE))
 		return -EFAULT;
 
+	/* Make sure it is what we expect it to be */
 	if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
 		return -EINVAL;
 
+	/* replace the text with the new text */
 	if (__copy_to_user_inatomic((char __user *)ip, new_code,
 				    MCOUNT_INSN_SIZE))
 		return -EPERM;

-- 
