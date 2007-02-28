Return-Path: <linux-kernel-owner+w=401wt.eu-S1751642AbXB1EsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbXB1EsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 23:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbXB1EsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 23:48:24 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:54942 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbXB1EsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 23:48:23 -0500
Date: Wed, 28 Feb 2007 10:17:44 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] init_new_context: Use the passed task argument  
Message-ID: <20070228044744.GA14739@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 arch/i386/kernel/ldt.c   |    2 +-
 arch/x86_64/kernel/ldt.c |    2 +-
 kernel/fork.c            |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/i386/kernel/ldt.c b/arch/i386/kernel/ldt.c
index b410e5f..925354c 100644
--- a/arch/i386/kernel/ldt.c
+++ b/arch/i386/kernel/ldt.c
@@ -97,7 +97,7 @@ int init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 
 	init_MUTEX(&mm->context.sem);
 	mm->context.size = 0;
-	old_mm = current->mm;
+	old_mm = tsk->mm;
 	if (old_mm && old_mm->context.size > 0) {
 		down(&old_mm->context.sem);
 		retval = copy_ldt(&mm->context, &old_mm->context);
diff --git a/arch/x86_64/kernel/ldt.c b/arch/x86_64/kernel/ldt.c
index d7e5d0c..16ae79d 100644
--- a/arch/x86_64/kernel/ldt.c
+++ b/arch/x86_64/kernel/ldt.c
@@ -101,7 +101,7 @@ int init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 
 	init_MUTEX(&mm->context.sem);
 	mm->context.size = 0;
-	old_mm = current->mm;
+	old_mm = tsk->mm;
 	if (old_mm && old_mm->context.size > 0) {
 		down(&old_mm->context.sem);
 		retval = copy_ldt(&mm->context, &old_mm->context);
diff --git a/kernel/fork.c b/kernel/fork.c
index d154cc7..2184ef5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -477,7 +477,7 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
  */
 static struct mm_struct *dup_mm(struct task_struct *tsk)
 {
-	struct mm_struct *mm, *oldmm = current->mm;
+	struct mm_struct *mm, *oldmm = tsk->mm;
 	int err;
 
 	if (!oldmm)
@@ -551,7 +551,7 @@ static int copy_mm(unsigned long clone_flags, struct task_struct * tsk)
 	}
 
 	retval = -ENOMEM;
-	mm = dup_mm(tsk);
+	mm = dup_mm(current);
 	if (!mm)
 		goto fail_nomem;
 
-- 
1.5.0.1.227.g99d42-dirty

