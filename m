Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbXLJQg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbXLJQg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 11:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbXLJQgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 11:36:47 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:27307
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752829AbXLJQgq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 11:36:46 -0500
Message-Id: <475D795E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 10 Dec 2007 16:37:34 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: restore proper asm constraints in do_IRQ()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two prior changes resulted in the "ecx" clobber being lost.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/x86/kernel/irq_32.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc4/arch/x86/kernel/irq_32.c	2007-12-07 09:00:59.000000000 +0100
+++ 2.6.24-rc4-i386-do_IRQ-constraints/arch/x86/kernel/irq_32.c	2007-12-04 16:09:33.000000000 +0100
@@ -134,7 +134,7 @@ fastcall unsigned int do_IRQ(struct pt_r
 			: "=a" (arg1), "=d" (arg2), "=b" (ebx)
 			:  "0" (irq),   "1" (desc),  "2" (isp),
 			   "D" (desc->handle_irq)
-			: "memory", "cc"
+			: "memory", "cc", "ecx"
 		);
 	} else
 #endif



