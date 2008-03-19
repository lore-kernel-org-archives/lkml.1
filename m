Return-Path: <linux-kernel-owner+w=401wt.eu-S941642AbYCSWvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941642AbYCSWvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757207AbYCSVUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:20:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765559AbYCSVUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:20:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Cc: Richard Henderson <rth@twiddle.net>
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 5/8] sparc64 ptrace: forced_successful_syscall_return()
In-Reply-To: Roland McGrath's message of  Wednesday, 19 March 2008 14:17:14 -0700 <20080319211714.8B14226F995@magilla.localdomain>
References: <20080319211714.8B14226F995@magilla.localdomain>
X-Windows: let it get in *your* way.
Message-Id: <20080319212001.2DB8526F995@magilla.localdomain>
Date: Wed, 19 Mar 2008 14:20:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the forced_successful_syscall_return() macro to
pair with our force_successful_syscall_return() definition.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/asm-sparc64/ptrace.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-sparc64/ptrace.h b/include/asm-sparc64/ptrace.h
index 6da1978..3f8826e 100644
--- a/include/asm-sparc64/ptrace.h
+++ b/include/asm-sparc64/ptrace.h
@@ -100,6 +100,8 @@ struct sparc_trapf {
 #define force_successful_syscall_return()	    \
 do {	current_thread_info()->syscall_noerror = 1; \
 } while (0)
+#define forced_successful_syscall_return()	\
+	(current_thread_info()->syscall_noerror != 0)
 #define user_mode(regs) (!((regs)->tstate & TSTATE_PRIV))
 #define instruction_pointer(regs) ((regs)->tpc)
 #define regs_return_value(regs) ((regs)->u_regs[UREG_I0])
