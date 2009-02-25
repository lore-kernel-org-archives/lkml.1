Return-Path: <linux-kernel-owner+w=401wt.eu-S1760997AbZBYPME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760997AbZBYPME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759937AbZBYPI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:08:56 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:56082 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbZBYPIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:08:35 -0500
Message-Id: <20090225150830.315661748@de.ibm.com>
References: <20090225150622.529143164@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 25 Feb 2009 16:06:34 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch/s390 12/46] cputime: initialize per thread timer values on fork
Content-Disposition: inline; filename=111-cputime-thread.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Initialize per thread timer values instead of just copying them from
the parent. That way it is easily possible to tell how much time a
thread spent in user/system context.
Doesn't fix a bug, this is just for debugging purposes.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/process.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: quilt-2.6/arch/s390/kernel/process.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/process.c
+++ quilt-2.6/arch/s390/kernel/process.c
@@ -163,6 +163,7 @@ int copy_thread(int nr, unsigned long cl
 		unsigned long unused,
 		struct task_struct *p, struct pt_regs *regs)
 {
+	struct thread_info *ti;
 	struct fake_frame
 	{
 		struct stack_frame sf;
@@ -214,6 +215,10 @@ int copy_thread(int nr, unsigned long cl
 	p->thread.mm_segment = get_fs();
 	/* Don't copy debug registers */
 	memset(&p->thread.per_info, 0, sizeof(p->thread.per_info));
+	/* Initialize per thread user and system timer values */
+	ti = task_thread_info(p);
+	ti->user_timer = 0;
+	ti->system_timer = 0;
 	return 0;
 }
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

