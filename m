Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbZA0Ul5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbZA0Ul5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 15:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZA0Ult
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 15:41:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35108 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbZA0Ult (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 15:41:49 -0500
Subject: [PATCH] x86: little cleanup of cpu_init()
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, Brian Gerst <brgerst@gmail.com>,
       L-K <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 27 Jan 2009 21:41:34 +0100
Message-Id: <1233088894.10992.35.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While I was looking through the new and improved bootstrap code - great
work that, thanks! I found the below a slight improvement.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/common.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 9394f73..5ecf97f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1088,22 +1088,19 @@ void __cpuinit cpu_init(void)
 	 */
 	if (kgdb_connected && arch_kgdb_ops.correct_hw_break)
 		arch_kgdb_ops.correct_hw_break();
-	else {
+	else
 #endif
-	/*
-	 * Clear all 6 debug registers:
-	 */
-
-	set_debugreg(0UL, 0);
-	set_debugreg(0UL, 1);
-	set_debugreg(0UL, 2);
-	set_debugreg(0UL, 3);
-	set_debugreg(0UL, 6);
-	set_debugreg(0UL, 7);
-#ifdef CONFIG_KGDB
-	/* If the kgdb is connected no debug regs should be altered. */
+	{
+		/*
+		 * Clear all 6 debug registers:
+		 */
+		set_debugreg(0UL, 0);
+		set_debugreg(0UL, 1);
+		set_debugreg(0UL, 2);
+		set_debugreg(0UL, 3);
+		set_debugreg(0UL, 6);
+		set_debugreg(0UL, 7);
 	}
-#endif
 
 	fpu_init();
 


