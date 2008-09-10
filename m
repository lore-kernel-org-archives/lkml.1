Return-Path: <linux-kernel-owner+w=401wt.eu-S1752327AbYIJAV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbYIJAV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 20:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYIJAVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 20:21:19 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:34539 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbYIJAVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 20:21:19 -0400
Message-ID: <48C712FD.7020304@ct.jp.nec.com>
Date: Tue, 09 Sep 2008 17:21:17 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86_64: signal: arg for restore_i387_xstate() is void
 __user *
References: <48C7126A.5010304@ct.jp.nec.com>
In-Reply-To: <48C7126A.5010304@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

restore_i387_xstate() is declared;
int restore_i387_xstate(void __user *buf);

so, make the variable buf void __user *.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_64.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 552a331..321da93 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -94,7 +94,8 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	}
 
 	{
-		struct _fpstate __user *buf;
+		void __user *buf;
+
 		err |= __get_user(buf, &sc->fpstate);
 		err |= restore_i387_xstate(buf);
 	}
-- 
1.5.6

