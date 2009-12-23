Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbZLWVYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbZLWVYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbZLWVVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:21:48 -0500
Received: from mail.windriver.com ([147.11.1.11]:45304 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbZLWVVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:21:43 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 07/37] kgdb,sparc: Add in kgdb_arch_set_pc for sparc
Date: Wed, 23 Dec 2009 15:19:20 -0600
Message-Id: <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:20:06.0473 (UTC) FILETIME=[B2EFF390:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new debug core api requires all architectures that use to debug
core to implement a function to set the program counter.

CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/sparc/kernel/kgdb_32.c |    6 ++++++
 arch/sparc/kernel/kgdb_64.c |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/sparc/kernel/kgdb_32.c b/arch/sparc/kernel/kgdb_32.c
index 04df4ed..79bcba6 100644
--- a/arch/sparc/kernel/kgdb_32.c
+++ b/arch/sparc/kernel/kgdb_32.c
@@ -158,6 +158,12 @@ void kgdb_arch_exit(void)
 {
 }
 
+void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
+{
+       regs->pc = regs->npc;
+       regs->npc = ip;
+}
+
 struct kgdb_arch arch_kgdb_ops = {
 	/* Breakpoint instruction: ta 0x7d */
 	.gdb_bpt_instr		= { 0x91, 0xd0, 0x20, 0x7d },
diff --git a/arch/sparc/kernel/kgdb_64.c b/arch/sparc/kernel/kgdb_64.c
index f5a0fd4..ebe9f0b 100644
--- a/arch/sparc/kernel/kgdb_64.c
+++ b/arch/sparc/kernel/kgdb_64.c
@@ -180,6 +180,12 @@ void kgdb_arch_exit(void)
 {
 }
 
+void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
+{
+	regs->tpc = regs->tnpc;
+	regs->tnpc = ip;
+}
+
 struct kgdb_arch arch_kgdb_ops = {
 	/* Breakpoint instruction: ta 0x72 */
 	.gdb_bpt_instr		= { 0x91, 0xd0, 0x20, 0x72 },
-- 
1.6.4.rc1

