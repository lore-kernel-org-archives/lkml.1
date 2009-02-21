Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbZBUDAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbZBUDAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 22:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbZBUDAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 22:00:16 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:59704 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbZBUDAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:00:14 -0500
Message-ID: <499F6E3D.1020905@ct.jp.nec.com>
Date: Fri, 20 Feb 2009 19:00:13 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86: ia32_signal: introduce GET_SEG() macro
References: <499F6DB6.3060500@ct.jp.nec.com>
In-Reply-To: <499F6DB6.3060500@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

introduce GET_SEG() macro like arch/x86/kernel/signal.c.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index adc63f8..8dd0903 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -192,11 +192,15 @@ asmlinkage long sys32_sigaltstack(const stack_ia32_t __user *uss_ptr,
 	get_user_ex(regs->x, &sc->x);		\
 }
 
-#define COPY_SEG_CPL3(seg)	{			\
-		unsigned short tmp;			\
-		get_user_ex(tmp, &sc->seg);		\
-		regs->seg = tmp | 3;			\
-}
+#define GET_SEG(seg)		({			\
+	unsigned short tmp;				\
+	get_user_ex(tmp, &sc->seg);			\
+	tmp;						\
+})
+
+#define COPY_SEG_CPL3(seg)	do {			\
+	regs->seg = GET_SEG(seg) | 3;			\
+} while (0)
 
 #define RELOAD_SEG(seg)		{		\
 	unsigned int cur, pre;			\
-- 
1.6.1.2

