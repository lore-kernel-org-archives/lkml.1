Return-Path: <linux-kernel-owner+w=401wt.eu-S934230AbZJGImj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934230AbZJGImj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934224AbZJGImi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:42:38 -0400
Received: from mxout-08.mxes.net ([216.86.168.183]:50262 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933993AbZJGImh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:42:37 -0400
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 7/7] x86 dumpstack: fix log level of the first line in the stack dump
Date: Wed,  7 Oct 2009 09:39:47 +0100
Message-Id: <1254904787-11323-8-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk>
References: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first line of the stack dump is currently missing a log level;
it will be printed as KERN_DEFAULT.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 arch/x86/kernel/dumpstack_32.c |    1 +
 arch/x86/kernel/dumpstack_64.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 8f1fb21..9db2370 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -84,6 +84,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 			sp = (unsigned long *)&sp;
 	}
 
+	printk("%s", log_lvl);
 	stack = sp;
 	for (i = 0; i < kstack_depth_to_print; i++) {
 		if (kstack_end(stack))
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index dbe1734..5b766a4 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -224,6 +224,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 			sp = (unsigned long *)&sp;
 	}
 
+	printk("%s", log_lvl);
 	stack = sp;
 	for (i = 0; i < kstack_depth_to_print; i++) {
 		if (stack >= irq_stack && stack <= irq_stack_end) {
-- 
1.6.3.2

