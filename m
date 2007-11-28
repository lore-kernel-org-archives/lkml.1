Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbXK1FId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbXK1FId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 00:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbXK1FIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 00:08:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbXK1FIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 00:08:23 -0500
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
X-Fcc: ~/Mail/linus
Subject: [PATCH 1/2] x86: setup64 eflags constants
Emacs: the definitive fritterware.
Message-Id: <20071128050745.357E826F8E7@magilla.localdomain>
Date: Tue, 27 Nov 2007 21:07:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This cleans up arch/x86/kernel/setup64.c to use the X86_EFLAGS_* constants
from <asm/processor-flags.h> instead of the EF_* enum in <asm/ptrace.h>.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/setup64.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup64.c b/arch/x86/kernel/setup64.c
index 3558ac7..51297cc 100644
--- a/arch/x86/kernel/setup64.c
+++ b/arch/x86/kernel/setup64.c
@@ -169,7 +169,8 @@ void syscall_init(void)
 #endif
 
 	/* Flags to clear on syscall */
-	wrmsrl(MSR_SYSCALL_MASK, EF_TF|EF_DF|EF_IE|0x3000); 
+	wrmsrl(MSR_SYSCALL_MASK,
+	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|X86_EFLAGS_IOPL);
 }
 
 void __cpuinit check_efer(void)
