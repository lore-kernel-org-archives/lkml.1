Return-Path: <linux-kernel-owner+w=401wt.eu-S1757508AbZEGC5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbZEGC5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 22:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZEGC44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 22:56:56 -0400
Received: from 170-23.widener.edu ([147.31.170.23]:41103 "EHLO
	naruto.cs.widener.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbZEGC44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 22:56:56 -0400
X-Greylist: delayed 1497 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 May 2009 22:56:55 EDT
From: Samuel Bronson <naesten@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Samuel Bronson <naesten@gmail.com>
Subject: [PATCH] x86: vm86() defaults to returning VM86_SIGNAL -- make this explicit
Date: Wed,  6 May 2009 22:27:55 -0400
Message-Id: <1241663275-31491-1-git-send-email-naesten@gmail.com>
X-Mailer: git-send-email 1.6.3.rc3.24.g6ffd5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code has apparently used "0" and not VM86_SIGNAL since Linux
1.1.9, when Linus added VM86_SIGNAL to vm86.h. This patch changes the
code to use the symbolic name.

The magic 0 tripped me up in trying to extend the vm86(2) manpage to
actually explain vm86()'s interface -- my greps for VM86_SIGNAL came up
fruitless.

Signed-off-by: Samuel Bronson <naesten@gmail.com>
---
 arch/x86/kernel/vm86_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index d7ac84e..b8035a0 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -318,9 +318,9 @@ static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk
 	}
 
 /*
- * Save old state, set default return value (%ax) to 0
+ * Save old state, set default return value (%ax) to 0 (VM86_SIGNAL)
  */
-	info->regs32->ax = 0;
+	info->regs32->ax = VM86_SIGNAL;
 	tsk->thread.saved_sp0 = tsk->thread.sp0;
 	tsk->thread.saved_fs = info->regs32->fs;
 	tsk->thread.saved_gs = get_user_gs(info->regs32);
-- 
1.6.3.rc3.24.g6ffd5

