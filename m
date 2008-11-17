Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbYKQXpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbYKQXpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 18:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbYKQXox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 18:44:53 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:45239 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbYKQXow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 18:44:52 -0500
Message-ID: <492201F2.1060804@ct.jp.nec.com>
Date: Mon, 17 Nov 2008 15:44:50 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com
Subject: [PATCH v2 1/5] x86: ia32_signal: cleanup macro COPY
References: <491E4101.7010405@ct.jp.nec.com>
In-Reply-To: <491E4101.7010405@ct.jp.nec.com>
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

