Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbXBECmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbXBECmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 21:42:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbXBECmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 21:42:09 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:22954 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbXBECmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 21:42:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=KsrGQAEkAjwcbDCNiGkr6INlBOeRnTifATKKv/DEtCQ5CQftncl6aGuZyz77MaU2XCuyzLWqG+Kt7N/rRtf18vA8Hsu/TcxUlhTFifVS1O/cziSomki9enyPnXpNp7CsZqDsyowvd7TQJHoQD8das8urG2nGjXM/o33dZL5Ltgo=
Date: Mon, 5 Feb 2007 04:41:51 +0200
To: gerg@uclinux.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20] arch M68KNOMMU: user ARRAY_SIZE macro when appropriate
Message-ID: <20070205024151.GJ18118@Ahmed>
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
Patch isn't compile checked cause I have no M68KNOMMU board at hand.
Thanks,

diff --git a/arch/m68knommu/kernel/ptrace.c b/arch/m68knommu/kernel/ptrace.c
index 9130119..72d3496 100644
--- a/arch/m68knommu/kernel/ptrace.c
+++ b/arch/m68knommu/kernel/ptrace.c
@@ -62,7 +62,7 @@ static inline long get_reg(struct task_struct *task, int regno)
 
 	if (regno == PT_USP)
 		addr = &task->thread.usp;
-	else if (regno < sizeof(regoff)/sizeof(regoff[0]))
+	else if (regno < ARRAY_SIZE(regoff))
 		addr = (unsigned long *)(task->thread.esp0 + regoff[regno]);
 	else
 		return 0;
@@ -79,7 +79,7 @@ static inline int put_reg(struct task_struct *task, int regno,
 
 	if (regno == PT_USP)
 		addr = &task->thread.usp;
-	else if (regno < sizeof(regoff)/sizeof(regoff[0]))
+	else if (regno < ARRAY_SIZE(regoff))
 		addr = (unsigned long *) (task->thread.esp0 + regoff[regno]);
 	else
 		return -1;
diff --git a/arch/m68knommu/kernel/traps.c b/arch/m68knommu/kernel/traps.c
index 9129b3a..bed5f47 100644
--- a/arch/m68knommu/kernel/traps.c
+++ b/arch/m68knommu/kernel/traps.c
@@ -158,7 +158,7 @@ void show_stack(struct task_struct *task, unsigned long *stack)
 void bad_super_trap(struct frame *fp)
 {
 	console_verbose();
-	if (fp->ptregs.vector < 4*sizeof(vec_names)/sizeof(vec_names[0]))
+	if (fp->ptregs.vector < 4 * ARRAY_SIZE(vec_names))
 		printk (KERN_WARNING "*** %s ***   FORMAT=%X\n",
 			vec_names[(fp->ptregs.vector) >> 2],
 			fp->ptregs.format);

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
