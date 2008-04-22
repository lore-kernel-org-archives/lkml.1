Return-Path: <linux-kernel-owner+w=401wt.eu-S1765963AbYDVPTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765963AbYDVPTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbYDVPTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:19:14 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15845 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbYDVPTN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:19:13 -0400
Message-Id: <480E1E1D.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 22 Apr 2008 16:19:25 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: fix signal type for iret exception
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

---
 arch/x86/kernel/traps_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.25/arch/x86/kernel/traps_32.c	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-i386-sigill/arch/x86/kernel/traps_32.c	2008-04-15 10:49:20.000000000 +0200
@@ -592,7 +592,7 @@ DO_ERROR(10, SIGSEGV, "invalid TSS", inv
 DO_ERROR(11, SIGBUS,  "segment not present", segment_not_present)
 DO_ERROR(12, SIGBUS,  "stack segment", stack_segment)
 DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0, 0)
-DO_ERROR_INFO(32, SIGSEGV, "iret exception", iret_error, ILL_BADSTK, 0, 1)
+DO_ERROR_INFO(32, SIGILL, "iret exception", iret_error, ILL_BADSTK, 0, 1)
 
 void __kprobes do_general_protection(struct pt_regs * regs,
 					      long error_code)



