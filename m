Return-Path: <linux-kernel-owner+w=401wt.eu-S1758463AbXKTKMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbXKTKMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 05:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbXKTKLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 05:11:42 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:13217 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbXKTKLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 05:11:40 -0500
Message-Id: <20071120101138.342515469@de.ibm.com>
References: <20071120101046.904031933@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 20 Nov 2007 11:10:47 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 1/2] Add missing die_notifier() call to die().
Content-Disposition: inline; filename=011-die-notifier.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/traps.c |    1 +
 1 file changed, 1 insertion(+)

Index: quilt-2.6/arch/s390/kernel/traps.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/traps.c
+++ quilt-2.6/arch/s390/kernel/traps.c
@@ -260,6 +260,7 @@ void die(const char * str, struct pt_reg
 	bust_spinlocks(1);
 	printk("%s: %04lx [#%d]\n", str, err & 0xffff, ++die_counter);
 	print_modules();
+	notify_die(DIE_OOPS, str, regs, err, current->thread.trap_no, SIGSEGV);
 	show_regs(regs);
 	bust_spinlocks(0);
 	add_taint(TAINT_DIE);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

