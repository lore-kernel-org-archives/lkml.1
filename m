Return-Path: <linux-kernel-owner+w=401wt.eu-S1762734AbXK2L7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762734AbXK2L7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 06:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760974AbXK2L7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 06:59:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760266AbXK2L7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 06:59:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH x86/mm 03/11] x86: ptrace FLAG_MASK cleanup
In-Reply-To: Roland McGrath's message of  Thursday, 29 November 2007 03:57:11 -0800 <20071129115711.9FC8526F8E7@magilla.localdomain>
References: <20071129115711.9FC8526F8E7@magilla.localdomain>
Emacs: ed  ::  20-megaton hydrogen bomb : firecracker
Message-Id: <20071129115924.7544526F8E7@magilla.localdomain>
Date: Thu, 29 Nov 2007 03:59:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This cleans up the FLAG_MASK macro to use symbolic constants instead of a
magic number.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index fed83d0..b71226d 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -32,10 +32,15 @@
 
 /*
  * Determines which flags the user has access to [1 = access, 0 = no access].
- * Prohibits changing ID(21), VIP(20), VIF(19), VM(17), NT(14), IOPL(12-13), IF(9).
- * Also masks reserved bits (31-22, 15, 5, 3, 1).
  */
-#define FLAG_MASK 0x00050dd5
+#define FLAG_MASK_32		((unsigned long)			\
+				 (X86_EFLAGS_CF | X86_EFLAGS_PF |	\
+				  X86_EFLAGS_AF | X86_EFLAGS_ZF |	\
+				  X86_EFLAGS_SF | X86_EFLAGS_TF |	\
+				  X86_EFLAGS_DF | X86_EFLAGS_OF |	\
+				  X86_EFLAGS_RF | X86_EFLAGS_AC))
+
+#define FLAG_MASK		FLAG_MASK_32
 
 static long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
 {
