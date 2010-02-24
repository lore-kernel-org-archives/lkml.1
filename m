Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab0BXVAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 16:00:54 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:45084 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041Ab0BXVAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 16:00:53 -0500
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2010 16:00:53 EST
X-Spam-Processed: digidescorp.com, Wed, 24 Feb 2010 15:00:51 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=167138bab6=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH] microblaze: Begin stack dump with caller of dump_stack()
Date: Wed, 24 Feb 2010 15:00:39 -0600
Message-Id: <1267045239-7091-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust the pointer used as the start of a stack dump so that the dump
begins with the caller of dump_stack(). This makes the dump easier to 
interpret.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
--- a/arch/microblaze/kernel/traps.c	2010-02-24 14:12:01.000000000 -0600
+++ b/arch/microblaze/kernel/traps.c	2010-02-24 14:56:21.000000000 -0600
@@ -73,8 +73,10 @@ void show_stack(struct task_struct *task
 		if (task)
 			sp = (unsigned long *) ((struct thread_info *)
 						(task->stack))->cpu_context.r1;
-		else
+		else {
 			sp = (unsigned long *)&sp;
+			sp -= 2;	/* Pick up caller of dump_stack() */
+		}
 	}
 
 	stack = sp;

