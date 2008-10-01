Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbYJADbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbYJADbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 23:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYJADaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 23:30:52 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:42167 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbYJADaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 23:30:52 -0400
Message-ID: <48E2EEEB.3010106@ct.jp.nec.com>
Date: Tue, 30 Sep 2008 20:30:51 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86_64: ia32_signal.c remove unnecessary function calls
References: <48E2EE54.2070009@ct.jp.nec.com>
In-Reply-To: <48E2EE54.2070009@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

the below 2 functions are called in save_i387_xstate_ia32()
- clear_used_math();
- stts();

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 690a480..4bc02b2 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -370,12 +370,9 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
 	tmp = save_i387_xstate_ia32(fpstate);
 	if (tmp < 0)
 		err = -EFAULT;
-	else {
-		clear_used_math();
-		stts();
+	else
 		err |= __put_user(ptr_to_compat(tmp ? fpstate : NULL),
 					&sc->fpstate);
-	}
 
 	/* non-iBCS2 extensions.. */
 	err |= __put_user(mask, &sc->oldmask);
-- 
1.5.6

