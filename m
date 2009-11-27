Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbZK0PGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbZK0PGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 10:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbZK0PGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 10:06:08 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:10110 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbZK0PGH convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;3:1>);
	Fri, 27 Nov 2009 10:06:07 -0500
Message-Id: <4B0FF8F80200007800022708@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 27 Nov 2009 15:06:16 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/alternatives: no need for alternatives-asm.h to
	 re-invent stuff already in asm.h
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This at once also gets the alignment specification right for x86-64.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/alternative-asm.h |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- linux-2.6.32-rc8/arch/x86/include/asm/alternative-asm.h
+++ 2.6.32-rc8-x86-alternative/arch/x86/include/asm/alternative-asm.h
@@ -1,17 +1,13 @@
 #ifdef __ASSEMBLY__
 
-#ifdef CONFIG_X86_32
-# define X86_ALIGN .long
-#else
-# define X86_ALIGN .quad
-#endif
+#include <asm/asm.h>
 
 #ifdef CONFIG_SMP
 	.macro LOCK_PREFIX
 1:	lock
 	.section .smp_locks,"a"
-	.align 4
-	X86_ALIGN 1b
+	_ASM_ALIGN
+	_ASM_PTR 1b
 	.previous
 	.endm
 #else



