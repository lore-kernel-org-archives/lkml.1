Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbYGKSrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbYGKSrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 14:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbYGKSrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 14:47:40 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64692 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755762AbYGKSrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 14:47:39 -0400
Date: Fri, 11 Jul 2008 19:47:15 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Recover timer_ack lost in the merge of the NMI watchdog
Message-ID: <Pine.LNX.4.55.0807111936480.31940@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 In the course of the recent unification of the NMI watchdog an assignment
to timer_ack to switch off unnecesary POLL commands to the 8259A in the
case of a watchdog failure has been accidentally removed.  The statement
used to be limited to the 32-bit variation as since the rewrite of the
timer code it has been relevant for the 82489DX only.  This change brings
it back.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-next-2.6.26-rc9-20080710-nmi-timer_ack-2
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080710.macro/arch/x86/kernel/nmi.c linux-next-2.6.26-rc9-20080710/arch/x86/kernel/nmi.c
--- linux-next-2.6.26-rc9-20080710.macro/arch/x86/kernel/nmi.c	2008-07-11 02:57:31.000000000 +0000
+++ linux-next-2.6.26-rc9-20080710/arch/x86/kernel/nmi.c	2008-07-11 03:20:33.000000000 +0000
@@ -171,6 +171,9 @@ int __init check_nmi_watchdog(void)
 error:
 	if (nmi_watchdog == NMI_IO_APIC && !timer_through_8259)
 		disable_8259A_irq(0);
+#ifdef CONFIG_X86_32
+	timer_ack = 0;
+#endif
 	return -1;
 }
 
