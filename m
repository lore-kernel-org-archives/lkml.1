Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYJAD2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYJAD2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 23:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYJAD2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 23:28:23 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:41924 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbYJAD2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 23:28:22 -0400
Message-ID: <48E2EE54.2070009@ct.jp.nec.com>
Date: Tue, 30 Sep 2008 20:28:20 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86_64: ia32_signal.c: remove unnecessary cast to u32
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

__put_user() looks type of the 2nd parameter, so casting the 1st parameter
is not necessary.

   text	   data	    bss	    dec	    hex	filename
   6227	      0	      8	   6235	   185b	ia32_signal.o.new
   6227	      0	      8	   6235	   185b	ia32_signal.o.old

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index e47bed2..690a480 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -351,21 +351,21 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
 	savesegment(es, tmp);
 	err |= __put_user(tmp, (unsigned int __user *)&sc->es);
 
-	err |= __put_user((u32)regs->di, &sc->di);
-	err |= __put_user((u32)regs->si, &sc->si);
-	err |= __put_user((u32)regs->bp, &sc->bp);
-	err |= __put_user((u32)regs->sp, &sc->sp);
-	err |= __put_user((u32)regs->bx, &sc->bx);
-	err |= __put_user((u32)regs->dx, &sc->dx);
-	err |= __put_user((u32)regs->cx, &sc->cx);
-	err |= __put_user((u32)regs->ax, &sc->ax);
-	err |= __put_user((u32)regs->cs, &sc->cs);
-	err |= __put_user((u32)regs->ss, &sc->ss);
+	err |= __put_user(regs->di, &sc->di);
+	err |= __put_user(regs->si, &sc->si);
+	err |= __put_user(regs->bp, &sc->bp);
+	err |= __put_user(regs->sp, &sc->sp);
+	err |= __put_user(regs->bx, &sc->bx);
+	err |= __put_user(regs->dx, &sc->dx);
+	err |= __put_user(regs->cx, &sc->cx);
+	err |= __put_user(regs->ax, &sc->ax);
+	err |= __put_user(regs->cs, &sc->cs);
+	err |= __put_user(regs->ss, &sc->ss);
 	err |= __put_user(current->thread.trap_no, &sc->trapno);
 	err |= __put_user(current->thread.error_code, &sc->err);
-	err |= __put_user((u32)regs->ip, &sc->ip);
-	err |= __put_user((u32)regs->flags, &sc->flags);
-	err |= __put_user((u32)regs->sp, &sc->sp_at_signal);
+	err |= __put_user(regs->ip, &sc->ip);
+	err |= __put_user(regs->flags, &sc->flags);
+	err |= __put_user(regs->sp, &sc->sp_at_signal);
 
 	tmp = save_i387_xstate_ia32(fpstate);
 	if (tmp < 0)
-- 
1.5.6

