Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbXBFDx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbXBFDx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 22:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbXBFDxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 22:53:21 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:40361 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752664AbXBFDw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 22:52:56 -0500
Date: Mon, 5 Feb 2007 19:52:55 -0800
Message-Id: <200702060352.l163qttg000739@zach-dev.vmware.com>
Subject: [PATCH 4/11] Kprobe rpl fix
From: Zachary Amsden <zach@vmware.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 06 Feb 2007 03:52:55.0061 (UTC) FILETIME=[48581450:01C749A2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kprobes bugfix for paravirt compatibility - RPL on the CS when inserting
BPs must match running kernel.

Signed-off-by: Zachary Amsden <zach@vmware.com>
CC: Eric Biederman <ebiederm@xmission.com>

diff -r fad1c2108c13 arch/i386/kernel/kprobes.c
--- a/arch/i386/kernel/kprobes.c	Fri Feb 02 16:22:37 2007 -0800
+++ b/arch/i386/kernel/kprobes.c	Fri Feb 02 16:28:48 2007 -0800
@@ -408,7 +408,7 @@ fastcall void *__kprobes trampoline_hand
 	spin_lock_irqsave(&kretprobe_lock, flags);
 	head = kretprobe_inst_table_head(current);
 	/* fixup registers */
-	regs->xcs = __KERNEL_CS;
+	regs->xcs = __KERNEL_CS | get_kernel_rpl();
 	regs->eip = trampoline_address;
 	regs->orig_eax = 0xffffffff;
 
