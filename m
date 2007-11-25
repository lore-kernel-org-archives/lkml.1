Return-Path: <linux-kernel-owner+w=401wt.eu-S1759144AbXKYWJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144AbXKYWJm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758810AbXKYWJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:09:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758770AbXKYWJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:09:03 -0500
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
Subject: [PATCH 27/27] x86: PTRACE_SINGLEBLOCK
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20071125220859.28B7726F8DE@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:08:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This adds the PTRACE_SINGLEBLOCK request on x86, matching the ia64 feature.
The implementation comes from the generic ptrace code and relies on the
low-level machine support provided by arch_has_block_step() et al.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/ptrace32.c     |    1 +
 include/asm-x86/ptrace-abi.h |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/ia32/ptrace32.c b/arch/x86/ia32/ptrace32.c
index 5661abd..d1fe78c 100644
--- a/arch/x86/ia32/ptrace32.c
+++ b/arch/x86/ia32/ptrace32.c
@@ -212,6 +212,7 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 	case PTRACE_KILL:
 	case PTRACE_CONT:
 	case PTRACE_SINGLESTEP:
+	case PTRACE_SINGLEBLOCK:
 	case PTRACE_DETACH:
 	case PTRACE_SYSCALL:
 	case PTRACE_OLDSETOPTIONS:
diff --git a/include/asm-x86/ptrace-abi.h b/include/asm-x86/ptrace-abi.h
index 7524e12..adce6b5 100644
--- a/include/asm-x86/ptrace-abi.h
+++ b/include/asm-x86/ptrace-abi.h
@@ -78,4 +78,6 @@
 # define PTRACE_SYSEMU_SINGLESTEP 32
 #endif
 
+#define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
+
 #endif
