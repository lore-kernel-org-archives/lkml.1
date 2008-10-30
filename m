Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbYJ3Kpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbYJ3Kpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 06:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYJ3KpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 06:45:21 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:26870 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbYJ3KpT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 06:45:19 -0400
Message-Id: <49099E60.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 30 Oct 2008 10:45:36 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: add two missing unwind annotations
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/entry_64.S |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.28-rc2/arch/x86/kernel/entry_64.S	2008-10-30 11:28:00.000000000 +0100
+++ 2.6.28-rc2-x86_64-unwind-annotations/arch/x86/kernel/entry_64.S	2008-10-30 00:00:00.000000000 +0100
@@ -255,6 +255,7 @@ ENTRY(ret_from_fork)
 	call schedule_tail
 	GET_THREAD_INFO(%rcx)
 	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT),TI_flags(%rcx)
+	CFI_REMEMBER_STATE
 	jnz rff_trace
 rff_action:	
 	RESTORE_REST
@@ -264,6 +265,7 @@ rff_action:	
 	jnz  int_ret_from_sys_call
 	RESTORE_TOP_OF_STACK %rdi,ARGOFFSET
 	jmp ret_from_sys_call
+	CFI_RESTORE_STATE
 rff_trace:
 	movq %rsp,%rdi
 	call syscall_trace_leave



