Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbZEDQX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbZEDQX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757754AbZEDQW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:22:58 -0400
Received: from 170-13.widener.edu ([147.31.170.13]:38676 "EHLO
	bender.cs.widener.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875AbZEDQW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:22:58 -0400
X-Greylist: delayed 1083 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 May 2009 12:22:56 EDT
From: Samuel Bronson <naesten@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
       Samuel Bronson <naesten@gmail.com>
Subject: [PATCH] vm86: Make it clear that the default return value is actually VM86_SIGNAL ... not just any old zero!
Date: Mon,  4 May 2009 13:06:10 -0400
Message-Id: <1241456770-2054-1-git-send-email-naesten@gmail.com>
X-Mailer: git-send-email 1.6.3.rc3.24.g6ffd5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The magic 0 tripped me up in trying to extend the vm86(2) manpage to
actually explain vm86()'s interface -- my greps for VM86_SIGNAL came up
fruitless.

Signed-off-by: Samuel Bronson <naesten@gmail.com>
---
I'm not on the list, so please CC: me in any responses. Thanks!
If anyone wants to take a look at the WIP manpage, see:
    http://repo.or.cz/w/man-pages/vm86.git?a=blob;f=man2/vm86.2;hb=HEAD
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

