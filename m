Return-Path: <linux-kernel-owner+w=401wt.eu-S1765553AbYDVPQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765553AbYDVPQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbYDVPQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:16:42 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15727 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765464AbYDVPQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:16:41 -0400
Message-Id: <480E1D82.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 22 Apr 2008 16:16:50 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: fix asm constraint in do_IRQ()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two prior changes resulted in the "ecx" clobber being lost.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/irq_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.25/arch/x86/kernel/irq_32.c	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-i386-do_IRQ-constraints/arch/x86/kernel/irq_32.c	2008-04-15 10:49:20.000000000 +0200
@@ -134,7 +134,7 @@ unsigned int do_IRQ(struct pt_regs *regs
 			: "=a" (arg1), "=d" (arg2), "=b" (bx)
 			:  "0" (irq),   "1" (desc),  "2" (isp),
 			   "D" (desc->handle_irq)
-			: "memory", "cc"
+			: "memory", "cc", "ecx"
 		);
 	} else
 #endif



