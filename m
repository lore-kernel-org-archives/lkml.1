Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYJCUhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYJCUhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 16:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYJCUhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 16:37:06 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:7944 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbYJCUhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 16:37:05 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 6/9] traps: x86_64: use task_pid_nr(tsk) instead of tsk->pid in do_general_protection
Date: Fri,  3 Oct 2008 22:00:37 +0200
Message-Id: <1223064040-23170-7-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1223064040-23170-6-git-send-email-heukelum@fastmail.fm>
References: <1223064040-23170-1-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-2-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-3-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-4-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-5-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-6-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Fri, 03 Oct 2008 22:36:50 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.242; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use task_pid_nr(tsk) instead of tsk->pid in do_general_protection.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 6bce291..59dcee1 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -205,7 +205,7 @@ do_general_protection(struct pt_regs *regs, long error_code)
 			printk_ratelimit()) {
 		printk(KERN_INFO
 			"%s[%d] general protection ip:%lx sp:%lx error:%lx",
-			tsk->comm, tsk->pid,
+			tsk->comm, task_pid_nr(tsk),
 			regs->ip, regs->sp, error_code);
 		print_vma_addr(" in ", regs->ip);
 		printk("\n");
-- 
1.5.4.3

