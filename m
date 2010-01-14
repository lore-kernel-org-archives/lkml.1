Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637Ab0ANPAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab0ANPAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756439Ab0ANPAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:00:38 -0500
Received: from mail.windriver.com ([147.11.1.11]:47487 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab0ANPAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:00:35 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 06/40] kgdb,sparc: Add in kgdb_arch_set_pc for sparc
Date: Thu, 14 Jan 2010 08:59:02 -0600
Message-Id: <1263481176-1897-7-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 14 Jan 2010 15:00:04.0600 (UTC) FILETIME=[410CBF80:01CA952A]
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
1.6.3.1.9.g95405b

