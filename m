Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbZLBKqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbZLBKqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZLBKqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:46:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:45056 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbZLBKqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:46:30 -0500
Date: Wed, 2 Dec 2009 10:46:03 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B0FF8F80200007800022708@vpn.id2.novell.com>
References: <4B0FF8F80200007800022708@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/alternatives: No need for alternatives-asm.h to re-invent stuff already in asm.h
Message-ID: <tip-99063c0bcebcc913165a5d168050326eba3e0996@git.kernel.org>
Git-Commit-ID: 99063c0bcebcc913165a5d168050326eba3e0996
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99063c0bcebcc913165a5d168050326eba3e0996
Gitweb:     http://git.kernel.org/tip/99063c0bcebcc913165a5d168050326eba3e0996
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Fri, 27 Nov 2009 15:06:16 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Dec 2009 11:39:45 +0100

x86/alternatives: No need for alternatives-asm.h to re-invent stuff already in asm.h

This at once also gets the alignment specification right for
x86-64.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4B0FF8F80200007800022708@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/alternative-asm.h |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/asm/alternative-asm.h
index e2077d3..b97f786 100644
--- a/arch/x86/include/asm/alternative-asm.h
+++ b/arch/x86/include/asm/alternative-asm.h
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
