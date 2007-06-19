Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbXFSIqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbXFSIqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 04:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbXFSIpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 04:45:24 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:37642 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbXFSIpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 04:45:15 -0400
Message-Id: <20070619084642.673859525@de.ibm.com>
References: <20070619084516.457715754@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Jun 2007 10:45:21 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 5/6] Move psw_set_key.
Content-Disposition: inline; filename=005-set-key.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Move psw_set_key() from ptrace.h to processor.h which is a more
suitable place for it. In addition the moves makes the function
invisible to user space.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/traps.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: quilt-2.6/arch/s390/kernel/traps.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/traps.c
+++ quilt-2.6/arch/s390/kernel/traps.c
@@ -253,20 +253,22 @@ void die(const char * str, struct pt_reg
 {
 	static int die_counter;
 
+	oops_enter();
 	debug_stop_all();
 	console_verbose();
 	spin_lock_irq(&die_lock);
 	bust_spinlocks(1);
 	printk("%s: %04lx [#%d]\n", str, err & 0xffff, ++die_counter);
 	print_modules();
-        show_regs(regs);
+	show_regs(regs);
 	bust_spinlocks(0);
-        spin_unlock_irq(&die_lock);
+	spin_unlock_irq(&die_lock);
 	if (in_interrupt())
 		panic("Fatal exception in interrupt");
 	if (panic_on_oops)
 		panic("Fatal exception: panic_on_oops");
-        do_exit(SIGSEGV);
+	oops_exit();
+	do_exit(SIGSEGV);
 }
 
 static void inline

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

