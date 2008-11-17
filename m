Return-Path: <linux-kernel-owner+w=401wt.eu-S1753734AbYKQXsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbYKQXsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 18:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYKQXs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 18:48:29 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:47980 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbYKQXs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 18:48:28 -0500
Message-ID: <492202CB.4000604@ct.jp.nec.com>
Date: Mon, 17 Nov 2008 15:48:27 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com
Subject: [PATCH v2 4/5] x86: ia32_signal: remove using temporary variable
References: <491E4101.7010405@ct.jp.nec.com> <492201F2.1060804@ct.jp.nec.com>
In-Reply-To: <492201F2.1060804@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

No need to use temporary variable.
Also rename the variable same as arch/x86/kernel/signal_32.c.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Reviewed-by: WANG Cong <wangcong@zeuux.org>
---
 arch/x86/ia32/ia32_signal.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 0b7fcf6..2883f41 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -218,7 +218,7 @@ struct rt_sigframe
 
 static int ia32_restore_sigcontext(struct pt_regs *regs,
 				   struct sigcontext_ia32 __user *sc,
-				   unsigned int *peax)
+				   unsigned int *pax)
 {
 	unsigned int tmpflags, gs, oldgs, err = 0;
 	void __user *buf;
@@ -265,9 +265,7 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 	buf = compat_ptr(tmp);
 	err |= restore_i387_xstate_ia32(buf);
 
-	err |= __get_user(tmp, &sc->ax);
-	*peax = tmp;
-
+	err |= __get_user(*pax, &sc->ax);
 	return err;
 }
 
-- 
1.5.6

