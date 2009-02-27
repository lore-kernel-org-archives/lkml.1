Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbZB0S1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbZB0S1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 13:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbZB0S1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 13:27:07 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:62950 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbZB0S1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 13:27:06 -0500
Message-ID: <49A83078.3020207@ct.jp.nec.com>
Date: Fri, 27 Feb 2009 10:27:04 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] x86: signal: add __user annotation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Add missing __user annotation to the parameter of get_sigframe().
Also change cast type to void __user * of *fpstate.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 4d34410..d6883b7 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -215,7 +215,7 @@ static const struct {
  */
 static inline void __user *
 get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
-	     void **fpstate)
+	     void __user **fpstate)
 {
 	unsigned long sp;
 
@@ -243,7 +243,7 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 
 	if (used_math()) {
 		sp = sp - sig_xstate_size;
-		*fpstate = (struct _fpstate *) sp;
+		*fpstate = (void __user *) sp;
 		if (save_i387_xstate(*fpstate) < 0)
 			return (void __user *)-1L;
 	}
-- 
1.6.1.2

