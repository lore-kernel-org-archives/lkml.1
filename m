Return-Path: <linux-kernel-owner+w=401wt.eu-S1946808AbXBJLzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946808AbXBJLzF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946804AbXBJLxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:53:15 -0500
Received: from ns1.suse.de ([195.135.220.2]:50401 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933428AbXBJLwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:52:44 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101252.033732000@suse.de>
In-Reply-To: <200702101252.033732000@suse.de>
To: Zachary Amsden <zach@vmware.com>, Eric Biederman <ebiederm@xmission.com>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review II] [8/10] VMI: Kprobe rpl fix
Message-Id: <20070210115236.7DC3F13E01@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:52:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Zachary Amsden <zach@vmware.com>
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
 

