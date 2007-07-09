Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbXGIBz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbXGIBz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 21:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757535AbXGIBzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 21:55:17 -0400
Received: from smtp.xtech.com.ar ([200.68.115.49]:2710 "EHLO smtp.xtech.com.ar"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757455AbXGIBzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 21:55:15 -0400
From: Diego Woitasen <diego@woitasen.com.ar>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Diego Woitasen <diego@woitasen.com.ar>
Subject: [PATCH] Use the tsk argument in init_new_context()
Date: Sun,  8 Jul 2007 22:55:08 -0300
Message-Id: <1183946108509-git-send-email-diego@woitasen.com.ar>
X-Mailer: git-send-email 1.5.2.3
X-Bogosity: No, tests=bogofilter, spamicity=0.000000, version=0.94.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Diego Woitasen <diego@woitasen.com.ar>
---
 arch/i386/kernel/ldt.c   |    2 +-
 arch/x86_64/kernel/ldt.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/i386/kernel/ldt.c b/arch/i386/kernel/ldt.c
index e0b2d17..c2eb4fb 100644
--- a/arch/i386/kernel/ldt.c
+++ b/arch/i386/kernel/ldt.c
@@ -96,7 +96,7 @@ int init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 
 	init_MUTEX(&mm->context.sem);
 	mm->context.size = 0;
-	old_mm = current->mm;
+	old_mm = tsk->mm;
 	if (old_mm && old_mm->context.size > 0) {
 		down(&old_mm->context.sem);
 		retval = copy_ldt(&mm->context, &old_mm->context);
diff --git a/arch/x86_64/kernel/ldt.c b/arch/x86_64/kernel/ldt.c
index bc9ffd5..99a92ed 100644
--- a/arch/x86_64/kernel/ldt.c
+++ b/arch/x86_64/kernel/ldt.c
@@ -100,7 +100,7 @@ int init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 
 	init_MUTEX(&mm->context.sem);
 	mm->context.size = 0;
-	old_mm = current->mm;
+	old_mm = tsk->mm;
 	if (old_mm && old_mm->context.size > 0) {
 		down(&old_mm->context.sem);
 		retval = copy_ldt(&mm->context, &old_mm->context);
-- 
1.5.2.3

