Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbYJCFTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbYJCFTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 01:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbYJCFTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 01:19:13 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:36811 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbYJCFTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 01:19:12 -0400
Message-ID: <48E5AB37.30109@ct.jp.nec.com>
Date: Thu, 02 Oct 2008 22:18:47 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: signal: remove indent in restore_sigcontext()
References: <48E5A900.6090308@ct.jp.nec.com>
In-Reply-To: <48E5A900.6090308@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

remove braces and indent for flags and fpstate in restore_sigcontext().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |   21 +++++++--------------
 arch/x86/kernel/signal_64.c |   19 +++++++------------
 2 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 545448b..d6dd057 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -142,6 +142,8 @@ static int
 restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 		   unsigned long *pax)
 {
+	void __user *buf;
+	unsigned int tmpflags;
 	unsigned int err = 0;
 
 	/* Always make any pending restarted system calls return -EINTR */
@@ -156,21 +158,12 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	COPY_SEG_STRICT(cs);
 	COPY_SEG_STRICT(ss);
 
-	{
-		unsigned int tmpflags;
+	err |= __get_user(tmpflags, &sc->flags);
+	regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
+	regs->orig_ax = -1;		/* disable syscall checks */
 
-		err |= __get_user(tmpflags, &sc->flags);
-		regs->flags = (regs->flags & ~FIX_EFLAGS) |
-						(tmpflags & FIX_EFLAGS);
-		regs->orig_ax = -1;		/* disable syscall checks */
-	}
-
-	{
-		void __user *buf;
-
-		err |= __get_user(buf, &sc->fpstate);
-		err |= restore_i387_xstate(buf);
-	}
+	err |= __get_user(buf, &sc->fpstate);
+	err |= restore_i387_xstate(buf);
 
 	err |= __get_user(*pax, &sc->ax);
 	return err;
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index feff4a9..a5c9627 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -69,6 +69,8 @@ static int
 restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 		   unsigned long *pax)
 {
+	void __user *buf;
+	unsigned int tmpflags;
 	unsigned int err = 0;
 
 	/* Always make any pending restarted system calls return -EINTR */
@@ -90,19 +92,12 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	 * App's signal handler can save/restore other segments if needed. */
 	COPY_SEG_STRICT(cs);
 
-	{
-		unsigned int tmpflags;
-		err |= __get_user(tmpflags, &sc->flags);
-		regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
-		regs->orig_ax = -1;		/* disable syscall checks */
-	}
-
-	{
-		void __user *buf;
+	err |= __get_user(tmpflags, &sc->flags);
+	regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
+	regs->orig_ax = -1;		/* disable syscall checks */
 
-		err |= __get_user(buf, &sc->fpstate);
-		err |= restore_i387_xstate(buf);
-	}
+	err |= __get_user(buf, &sc->fpstate);
+	err |= restore_i387_xstate(buf);
 
 	err |= __get_user(*pax, &sc->ax);
 	return err;
