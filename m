Return-Path: <linux-kernel-owner+w=401wt.eu-S1162425AbYCSWsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162425AbYCSWsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936930AbYCSVSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:18:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936924AbYCSVSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:18:00 -0400
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
Subject: [PATCH 1/8] ptrace: forced_successful_syscall_return() macro
X-Shopping-List: (1) Domestic condensation wavechords
   (2) Negligent circumcision vagrants
   (3) Asynchronous prosecutors
   (4) Elastic muscular suction bugs
   (5) Obsequious ostentatious inquisitions
Message-Id: <20080319211714.8B14226F995@magilla.localdomain>
Date: Wed, 19 Mar 2008 14:17:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the forced_successful_syscall_return() macro, a mate to
force_successful_syscall_return() to test rather than set the condition.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/ptrace.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index ebe0c17..9272e63 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -124,8 +124,13 @@ int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data);
  * is a no-op and the spurious error condition needs to be filtered out by some
  * other means (e.g., in user-level, by passing an extra argument to the
  * syscall handler, or something along those lines).
+ *
+ * On architectures that define force_successful_syscall_return(),
+ * forced_successful_syscall_return() should also be defined.
+ * It returns nonzero if force_successful_syscall_return() was just used.
  */
 #define force_successful_syscall_return() do { } while (0)
+#define forced_successful_syscall_return() 0
 #endif
 
 /*
