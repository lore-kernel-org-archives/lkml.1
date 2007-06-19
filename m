Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbXFSIqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbXFSIqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 04:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbXFSIpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 04:45:22 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:15984 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbXFSIpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 04:45:14 -0400
Message-Id: <20070619084642.276549848@de.ibm.com>
References: <20070619084516.457715754@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Jun 2007 10:45:20 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 4/6] Print list of modules on die().
Content-Disposition: inline; filename=004-printk-modules.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Print list of modules on die() like a lot of other architectures do.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/traps.c |    1 +
 1 file changed, 1 insertion(+)

Index: quilt-2.6/arch/s390/kernel/traps.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/traps.c
+++ quilt-2.6/arch/s390/kernel/traps.c
@@ -258,6 +258,7 @@ void die(const char * str, struct pt_reg
 	spin_lock_irq(&die_lock);
 	bust_spinlocks(1);
 	printk("%s: %04lx [#%d]\n", str, err & 0xffff, ++die_counter);
+	print_modules();
         show_regs(regs);
 	bust_spinlocks(0);
         spin_unlock_irq(&die_lock);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

