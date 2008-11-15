Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbYKODY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbYKODY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 22:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbYKODYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 22:24:52 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:63661 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbYKODYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 22:24:51 -0500
Message-ID: <491E4101.7010405@ct.jp.nec.com>
Date: Fri, 14 Nov 2008 19:24:49 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] x86: ia32_signal: cleanup macro COPY
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

No need to use temporary variable in this case.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index e886907..a28790a 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -197,10 +197,8 @@ struct rt_sigframe
 	/* fp state follows here */
 };
 
-#define COPY(x)		{ 		\
-	unsigned int reg;		\
-	err |= __get_user(reg, &sc->x);	\
-	regs->x = reg;			\
+#define COPY(x)			{		\
+	err |= __get_user(regs->x, &sc->x);	\
 }
 
 #define RELOAD_SEG(seg,mask)						\
-- 
1.5.6

