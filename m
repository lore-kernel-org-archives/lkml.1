Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777Ab0BYVWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:22:22 -0500
Received: from mail.windriver.com ([147.11.1.11]:63508 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375Ab0BYVWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:22:21 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 04/28] kgdb,sparc: Add in kgdb_arch_set_pc for sparc
Date: Thu, 25 Feb 2010 15:21:09 -0600
Message-Id: <1267132893-23624-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 25 Feb 2010 21:21:43.0055 (UTC) FILETIME=[86F131F0:01CAB660]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new debug core api requires all architectures that use to debug
core to implement a function to set the program counter.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/kernel/kgdb_32.c |    6 ++++++
 arch/sparc/kernel/kgdb_64.c |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/sparc/kernel/kgdb_32.c b/arch/sparc/kernel/kgdb_32.c
index 04df4ed..539243b 100644
--- a/arch/sparc/kernel/kgdb_32.c
+++ b/arch/sparc/kernel/kgdb_32.c
@@ -158,6 +158,12 @@ void kgdb_arch_exit(void)
 {
 }
 
+void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
+{
+	regs->pc = ip;
+	regs->npc = regs->pc + 4;
+}
+
 struct kgdb_arch arch_kgdb_ops = {
 	/* Breakpoint instruction: ta 0x7d */
 	.gdb_bpt_instr		= { 0x91, 0xd0, 0x20, 0x7d },
diff --git a/arch/sparc/kernel/kgdb_64.c b/arch/sparc/kernel/kgdb_64.c
index f5a0fd4..9bf387b 100644
--- a/arch/sparc/kernel/kgdb_64.c
+++ b/arch/sparc/kernel/kgdb_64.c
@@ -180,6 +180,12 @@ void kgdb_arch_exit(void)
 {
 }
 
+void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
+{
+	regs->tpc = ip;
+	regs->tnpc = regs->tpc + 4;
+}
+
 struct kgdb_arch arch_kgdb_ops = {
 	/* Breakpoint instruction: ta 0x72 */
 	.gdb_bpt_instr		= { 0x91, 0xd0, 0x20, 0x72 },
-- 
1.6.4.rc1

