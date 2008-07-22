Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbYGVQPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbYGVQPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 12:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYGVQOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 12:14:55 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:19646 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYGVQOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 12:14:54 -0400
Date: Tue, 22 Jul 2008 18:14:16 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, heukelum@fastmail.fm
Subject: x86_64, dwarf2: push pushes 8 bytes and popf pops 8
Message-ID: <20080722161416.GA17699@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Tue, 22 Jul 2008 18:14:38 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.11; VDF: 7.0.5.152; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CFI_ADJUST_CFA_OFFSET dwarf2 annotation of a push/popf
pair in ret_from_fork wrongly used a value of 4. It should
have been 8. Fix that.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index ae63e58..5f6cac6 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -269,9 +269,9 @@ ENTRY(native_usergs_sysret64)
 ENTRY(ret_from_fork)
 	CFI_DEFAULT_STACK
 	push kernel_eflags(%rip)
-	CFI_ADJUST_CFA_OFFSET 4
+	CFI_ADJUST_CFA_OFFSET 8
 	popf				# reset kernel eflags
-	CFI_ADJUST_CFA_OFFSET -4
+	CFI_ADJUST_CFA_OFFSET -8
 	call schedule_tail
 	GET_THREAD_INFO(%rcx)
 	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT),TI_flags(%rcx)

