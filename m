Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbXLMIvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbXLMIvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 03:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbXLMIvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 03:51:46 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:29947
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232AbXLMIvp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 03:51:45 -0500
Message-Id: <476100E2.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 13 Dec 2007 08:52:34 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: iret exception must use SIGILL
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.. since it uses ILL_BADSTK (which is meaningless in the context of
SIGSEGV).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/x86/kernel/traps_32.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc5/arch/x86/kernel/traps_32.c	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-i386-sigill/arch/x86/kernel/traps_32.c	2007-12-04 16:09:33.000000000 +0100
@@ -560,7 +560,7 @@ DO_ERROR(10, SIGSEGV, "invalid TSS", inv
 DO_ERROR(11, SIGBUS,  "segment not present", segment_not_present)
 DO_ERROR(12, SIGBUS,  "stack segment", stack_segment)
 DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0, 0)
-DO_ERROR_INFO(32, SIGSEGV, "iret exception", iret_error, ILL_BADSTK, 0, 1)
+DO_ERROR_INFO(32, SIGILL, "iret exception", iret_error, ILL_BADSTK, 0, 1)
 
 fastcall void __kprobes do_general_protection(struct pt_regs * regs,
 					      long error_code)



