Return-Path: <linux-kernel-owner+w=401wt.eu-S933540AbXIUWvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540AbXIUWvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764221AbXIUWc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:56 -0400
Received: from ns.suse.de ([195.135.220.2]:57139 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764175AbXIUWcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:51 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [49/50] x86_64: Initialize 64bit registers for a.out executables
Message-Id: <20070921223250.0624313DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Previously the data from before the exec was kept in there. Zero
them instead
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/ia32/ia32_aout.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/arch/x86_64/ia32/ia32_aout.c
===================================================================
--- linux.orig/arch/x86_64/ia32/ia32_aout.c
+++ linux/arch/x86_64/ia32/ia32_aout.c
@@ -422,6 +422,8 @@ beyond_if:
 	(regs)->eflags = 0x200;
 	(regs)->cs = __USER32_CS;
 	(regs)->ss = __USER32_DS;
+	regs->r8 = regs->r9 = regs->r10 = regs->r11 =
+	regs->r12 = regs->r13 = regs->r14 = regs->r15 = 0;
 	set_fs(USER_DS);
 	if (unlikely(current->ptrace & PT_PTRACED)) {
 		if (current->ptrace & PT_TRACE_EXEC)
