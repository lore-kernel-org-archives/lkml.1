Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537Ab0AGTBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab0AGTBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319Ab0AGTBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:01:09 -0500
Received: from mail.windriver.com ([147.11.1.11]:60160 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab0AGTBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:01:08 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Sonic Zhang <sonic.adi@gmail.com>, Mike Frysinger <vapier@gentoo.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3/4] blackfin,kgdb: Do not put PC in gdb_regs into retx.
Date: Thu,  7 Jan 2010 12:59:55 -0600
Message-Id: <1262890796-25053-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1262890796-25053-1-git-send-email-jason.wessel@windriver.com>
References: <1262890796-25053-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 07 Jan 2010 19:00:41.0986 (UTC) FILETIME=[B582C620:01CA8FCB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.adi@gmail.com>

In blackfin, kgdb is running in delayed exception IRQ5 other than in
exception IRQ3 directly.  Register reti other than retx in pt_regs is
the kgdb return address. So, don't put PC in gdb_regs into retx.

CC: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/blackfin/kernel/kgdb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/kgdb.c b/arch/blackfin/kernel/kgdb.c
index da03848..34c7c3e 100644
--- a/arch/blackfin/kernel/kgdb.c
+++ b/arch/blackfin/kernel/kgdb.c
@@ -133,7 +133,7 @@ void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 	regs->lb1 = gdb_regs[BFIN_LB1];
 	regs->usp = gdb_regs[BFIN_USP];
 	regs->syscfg = gdb_regs[BFIN_SYSCFG];
-	regs->retx = gdb_regs[BFIN_PC];
+	regs->retx = gdb_regs[BFIN_RETX];
 	regs->retn = gdb_regs[BFIN_RETN];
 	regs->rete = gdb_regs[BFIN_RETE];
 	regs->pc = gdb_regs[BFIN_PC];
-- 
1.6.3.1.9.g95405b

