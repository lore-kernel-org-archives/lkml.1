Return-Path: <linux-kernel-owner+w=401wt.eu-S1163303AbXD1SNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163303AbXD1SNF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163430AbXD1SNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:13:04 -0400
Received: from ns2.suse.de ([195.135.220.15]:38638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163303AbXD1Rwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:47 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: "Jan Beulich" <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [18/35] x86_64: a few missing entry.S annotations
Message-Id: <20070428175243.1A28D1518D@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/entry.S |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/arch/x86_64/kernel/entry.S
===================================================================
--- linux.orig/arch/x86_64/kernel/entry.S
+++ linux/arch/x86_64/kernel/entry.S
@@ -701,6 +701,7 @@ END(spurious_interrupt)
 	CFI_ADJUST_CFA_OFFSET 8
 	pushq %rax	/* push real oldrax to the rdi slot */ 
 	CFI_ADJUST_CFA_OFFSET 8
+	CFI_REL_OFFSET rax,0
 	leaq  \sym(%rip),%rax
 	jmp error_entry
 	CFI_ENDPROC
@@ -710,6 +711,7 @@ END(spurious_interrupt)
 	XCPT_FRAME
 	pushq %rax
 	CFI_ADJUST_CFA_OFFSET 8
+	CFI_REL_OFFSET rax,0
 	leaq  \sym(%rip),%rax
 	jmp error_entry
 	CFI_ENDPROC
@@ -817,6 +819,7 @@ paranoid_schedule\trace:
  */ 		  				
 KPROBE_ENTRY(error_entry)
 	_frame RDI
+	CFI_REL_OFFSET rax,0
 	/* rdi slot contains rax, oldrax contains error code */
 	cld	
 	subq  $14*8,%rsp
@@ -824,6 +827,7 @@ KPROBE_ENTRY(error_entry)
 	movq %rsi,13*8(%rsp)
 	CFI_REL_OFFSET	rsi,RSI
 	movq 14*8(%rsp),%rsi	/* load rax from rdi slot */
+	CFI_REGISTER	rax,rsi
 	movq %rdx,12*8(%rsp)
 	CFI_REL_OFFSET	rdx,RDX
 	movq %rcx,11*8(%rsp)
@@ -857,6 +861,7 @@ error_swapgs:	
 	swapgs
 error_sti:	
 	movq %rdi,RDI(%rsp) 	
+	CFI_REL_OFFSET	rdi,RDI
 	movq %rsp,%rdi
 	movq ORIG_RAX(%rsp),%rsi	/* get error code */ 
 	movq $-1,ORIG_RAX(%rsp)
