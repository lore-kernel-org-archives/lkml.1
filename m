Return-Path: <linux-kernel-owner+w=401wt.eu-S933184AbZKFWl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184AbZKFWl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933169AbZKFWlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:41:50 -0500
Received: from www.tglx.de ([62.245.132.106]:53997 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933099AbZKFWlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:41:49 -0500
Message-Id: <20091106223806.479814997@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 06 Nov 2009 22:41:09 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [patch 02/16] mips: Replace old style spin lock initializer
References: <20091106223547.784916750@linutronix.de>
Content-Disposition: inline; filename=mips-remove-old-style-lock-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED is deprecated. Use __SPIN_LOCK_UNLOCKED instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/kernel/vpe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/mips/kernel/vpe.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/vpe.c
+++ linux-2.6/arch/mips/kernel/vpe.c
@@ -149,9 +149,9 @@ struct {
 	spinlock_t tc_list_lock;
 	struct list_head tc_list;	/* Thread contexts */
 } vpecontrol = {
-	.vpe_list_lock	= SPIN_LOCK_UNLOCKED,
+	.vpe_list_lock	= __SPIN_LOCK_UNLOCKED(vpecontrol.vpe_list_lock),
 	.vpe_list	= LIST_HEAD_INIT(vpecontrol.vpe_list),
-	.tc_list_lock	= SPIN_LOCK_UNLOCKED,
+	.tc_list_lock	= __SPIN_LOCK_UNLOCKED(vpecontrol.tc_list_lock),
 	.tc_list	= LIST_HEAD_INIT(vpecontrol.tc_list)
 };
 


