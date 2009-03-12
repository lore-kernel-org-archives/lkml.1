Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZCLKqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZCLKqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZCLKqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:46:36 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:32693 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZCLKqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:46:36 -0400
Message-Id: <49B8F641.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 10:47:13 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: remove unnecessary spill/reload of rbx from
	 memcpy
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should slightly improve its performance.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/lib/memcpy_64.S |    7 -------
 1 file changed, 7 deletions(-)

--- linux-2.6.29-rc7/arch/x86/lib/memcpy_64.S	2008-01-24 23:58:37.000000000 +0100
+++ 2.6.29-rc7-x86_64-memcpy-rbx/arch/x86/lib/memcpy_64.S	2008-12-18 10:58:11.000000000 +0100
@@ -33,9 +33,6 @@ ENDPROC(memcpy_c)
 ENTRY(__memcpy)
 ENTRY(memcpy)
 	CFI_STARTPROC
-	pushq %rbx
-	CFI_ADJUST_CFA_OFFSET 8
-	CFI_REL_OFFSET rbx, 0
 	movq %rdi,%rax
 
 	movl %edx,%ecx
@@ -102,11 +99,7 @@ ENTRY(memcpy)
 	jnz .Lloop_1
 
 .Lende:
-	popq %rbx
-	CFI_ADJUST_CFA_OFFSET -8
-	CFI_RESTORE rbx
 	ret
-.Lfinal:
 	CFI_ENDPROC
 ENDPROC(memcpy)
 ENDPROC(__memcpy)



