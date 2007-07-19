Return-Path: <linux-kernel-owner+w=401wt.eu-S936264AbXGSKOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936264AbXGSKOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760491AbXGSJzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759326AbXGSJzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:24 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: jbeulich@novell.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [34/58] x86_64: ia32entry adjustments
Message-Id: <20070719095520.2124414E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
Consolidate the three 32-bit system call entry points so that they all
treat registers in similar ways.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 arch/x86_64/ia32/ia32entry.S |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux.orig/arch/x86_64/ia32/ia32entry.S
+++ linux/arch/x86_64/ia32/ia32entry.S
@@ -104,7 +104,7 @@ ENTRY(ia32_sysenter_target)
 	pushq	%rax
 	CFI_ADJUST_CFA_OFFSET 8
 	cld
-	SAVE_ARGS 0,0,0
+	SAVE_ARGS 0,0,1
  	/* no need to do an access_ok check here because rbp has been
  	   32bit zero extended */ 
 1:	movl	(%rbp),%r9d
@@ -294,7 +294,7 @@ ia32_badarg:
  */ 				
 
 ENTRY(ia32_syscall)
-	CFI_STARTPROC	simple
+	CFI_STARTPROC32	simple
 	CFI_SIGNAL_FRAME
 	CFI_DEF_CFA	rsp,SS+8-RIP
 	/*CFI_REL_OFFSET	ss,SS-RIP*/
@@ -330,6 +330,7 @@ ia32_sysret:
 
 ia32_tracesys:			 
 	SAVE_REST
+	CLEAR_RREGS
 	movq $-ENOSYS,RAX(%rsp)	/* really needed? */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
