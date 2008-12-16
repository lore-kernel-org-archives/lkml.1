Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758937AbYLPWEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbYLPWEz (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 17:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYLPWEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 17:04:44 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:57002 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbYLPWEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 17:04:44 -0500
Message-ID: <494825FB.1040700@ct.jp.nec.com>
Date: Tue, 16 Dec 2008 14:04:43 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: ia32_signal: use proper macro __USER32_DS
References: <49482568.3020108@ct.jp.nec.com>
In-Reply-To: <49482568.3020108@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Use __USER32_DS instead of __USER_DS in ia32_signal.c.
No impact, because __USER32_DS is defined __USER_DS.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 8738cc5..ee1ad4a 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -396,7 +396,7 @@ static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 	}
 
 	/* This is the legacy signal stack switching. */
-	else if ((regs->ss & 0xffff) != __USER_DS &&
+	else if ((regs->ss & 0xffff) != __USER32_DS &&
 		!(ka->sa.sa_flags & SA_RESTORER) &&
 		 ka->sa.sa_restorer)
 		sp = (unsigned long) ka->sa.sa_restorer;
-- 
1.6.0.4

