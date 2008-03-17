Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbYCQFAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbYCQFAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 01:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYCQFAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 01:00:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbYCQFAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 01:00:09 -0400
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64 sys32_execve PT_DTRACE
X-Zippy-Says: An air of FRENCH FRIES permeates my nostrils!!
Message-Id: <20080317050005.31D2926F995@magilla.localdomain>
Date: Sun, 16 Mar 2008 22:00:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The PT_DTRACE flag is meaningless and obsolete.
Don't touch it.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/sys_ia32.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index abf71d2..fa47939 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -804,11 +804,6 @@ asmlinkage long sys32_execve(char __user *name, compat_uptr_t __user *argv,
 	if (IS_ERR(filename))
 		return error;
 	error = compat_do_execve(filename, argv, envp, regs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 	return error;
 }
