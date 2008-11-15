Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbYKOD3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbYKOD3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 22:29:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYKOD2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 22:28:53 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:64356 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbYKOD2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 22:28:53 -0500
Message-ID: <491E41F2.4030403@ct.jp.nec.com>
Date: Fri, 14 Nov 2008 19:28:50 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] x86: ia32_signal: change order of storing in setup_sigcontext()
References: <491E4101.7010405@ct.jp.nec.com>
In-Reply-To: <491E4101.7010405@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Change order of storing to match the sigcontext_ia32.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 2883f41..909181a 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -360,13 +360,13 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
 	err |= __put_user(regs->dx, &sc->dx);
 	err |= __put_user(regs->cx, &sc->cx);
 	err |= __put_user(regs->ax, &sc->ax);
-	err |= __put_user(regs->cs, &sc->cs);
-	err |= __put_user(regs->ss, &sc->ss);
 	err |= __put_user(current->thread.trap_no, &sc->trapno);
 	err |= __put_user(current->thread.error_code, &sc->err);
 	err |= __put_user(regs->ip, &sc->ip);
+	err |= __put_user(regs->cs, (unsigned int __user *)&sc->cs);
 	err |= __put_user(regs->flags, &sc->flags);
 	err |= __put_user(regs->sp, &sc->sp_at_signal);
+	err |= __put_user(regs->ss, (unsigned int __user *)&sc->ss);
 
 	err |= __put_user(ptr_to_compat(fpstate), &sc->fpstate);
 
-- 
1.5.6

