Return-Path: <linux-kernel-owner+w=401wt.eu-S935777AbYBHUQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935777AbYBHUQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932651AbYBHUNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:13:49 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:32862 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935420AbYBHUNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:13:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TUCD6O/ZxBmOBnKVnTVsN1/BByw9vzuEtqaI4J7pnWRUf1YVBNBg575yZ9h7Z/zGgp7VwgRSfxilnjaAsGkl8Bmtir40GAreb7OZc+UvVmPR0L93c3Vw+tDRofMNNxs6IpiTCEJQfKJJm3NeVmSo46+ddHRbkBIN0ZugAb2q8vY=
Subject: [PATCH 8/9] x86: Unify argument names in signal_32|64.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 12:10:02 -0800
Message-Id: <1202501402.12966.27.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prax/peax becomes pax.  Change from int to unsigned long in X86_32.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/signal_32.c |    9 ++++-----
 arch/x86/kernel/signal_64.c |    4 ++--
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 858a71f..5f30627 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -108,9 +108,8 @@ sys_sigaltstack(unsigned long bx)
 /*
  * Do a signal return; undo the signal stack.
  */
-
 static int
-restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, int *peax)
+restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, unsigned long *pax)
 {
 	unsigned int err = 0;
 
@@ -166,19 +165,19 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, int *peax
 		}
 	}
 
-	err |= __get_user(*peax, &sc->ax);
+	err |= __get_user(*pax, &sc->ax);
 	return err;
 
 badframe:
 	return 1;
 }
 
-asmlinkage int sys_sigreturn(unsigned long __unused)
+asmlinkage unsigned long sys_sigreturn(unsigned long __unused)
 {
 	struct pt_regs *regs = (struct pt_regs *) &__unused;
 	struct sigframe __user *frame = (struct sigframe __user *)(regs->sp - 8);
 	sigset_t set;
-	int ax;
+	unsigned long ax;
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index f006ea1..40b30cd 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -61,7 +61,7 @@ sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
  * Do a signal return; undo the signal stack.
  */
 static int
-restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, unsigned long *prax)
+restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, unsigned long *pax)
 {
 	unsigned int err = 0;
 
@@ -114,7 +114,7 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, unsigned
 		}
 	}
 
-	err |= __get_user(*prax, &sc->ax);
+	err |= __get_user(*pax, &sc->ax);
 	return err;
 
 badframe:
-- 
1.5.4.1219.g65b9


