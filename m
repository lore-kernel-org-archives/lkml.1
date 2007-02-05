Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbXBECn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbXBECn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 21:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbXBECn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 21:43:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:22954 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbXBECnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 21:43:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=kEKUs/mjccgqSdqNY97VSAfBaoYixBhri/3ner1kVejDOOYSQKp4WRTWGGqfS4IzX8uST9IkvIYFVb9NyqrMkR+Qf+Jvbr925PZOnjYszikDzU0+xrNuWz+wOfcgwZGkWfLwskgrE/JaXaX771Lpko7UcuAmNNHK19VLoflM3LM=
Date: Mon, 5 Feb 2007 04:43:42 +0200
To: geert@linux-m68k.org, linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20] arch M68K: user ARRAY_SIZE macro when appropriate
Message-ID: <20070205024341.GO18118@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205023935.GG18118@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A patch to use ARRAY_SIZE macro already defined in linux/kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
Patch isn't compile checked since I have no m68k machine at hand.

diff --git a/arch/m68k/kernel/ptrace.c b/arch/m68k/kernel/ptrace.c
index ef89060..7fd2720 100644
--- a/arch/m68k/kernel/ptrace.c
+++ b/arch/m68k/kernel/ptrace.c
@@ -76,7 +76,7 @@ static inline long get_reg(struct task_struct *task, int regno)
 
 	if (regno == PT_USP)
 		addr = &task->thread.usp;
-	else if (regno < sizeof(regoff)/sizeof(regoff[0]))
+	else if (regno < ARRAY_SIZE(regoff))
 		addr = (unsigned long *)(task->thread.esp0 + regoff[regno]);
 	else
 		return 0;
@@ -93,7 +93,7 @@ static inline int put_reg(struct task_struct *task, int regno,
 
 	if (regno == PT_USP)
 		addr = &task->thread.usp;
-	else if (regno < sizeof(regoff)/sizeof(regoff[0]))
+	else if (regno < ARRAY_SIZE(regoff))
 		addr = (unsigned long *)(task->thread.esp0 + regoff[regno]);
 	else
 		return -1;
diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index 759fa24..a27a4fa 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -1011,7 +1011,7 @@ EXPORT_SYMBOL(dump_stack);
 void bad_super_trap (struct frame *fp)
 {
 	console_verbose();
-	if (fp->ptregs.vector < 4*sizeof(vec_names)/sizeof(vec_names[0]))
+	if (fp->ptregs.vector < 4 * ARRAY_SIZE(vec_names))
 		printk ("*** %s ***   FORMAT=%X\n",
 			vec_names[(fp->ptregs.vector) >> 2],
 			fp->ptregs.format);


-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
