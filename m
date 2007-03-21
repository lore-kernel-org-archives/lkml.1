Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbXCUGt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbXCUGt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 02:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbXCUGt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 02:49:58 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:16545 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbXCUGt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 02:49:57 -0400
Message-ID: <d4cf37a60703202349o7ef0273erefa598efad4bb09e@mail.gmail.com>
Date: Tue, 20 Mar 2007 23:49:56 -0700
From: "Wink Saville" <wink@saville.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] Add trec_snapshot and trec_print_snapshot to die()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wink Saville <wink@saville.com>
---
 arch/x86_64/kernel/traps.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86_64/kernel/traps.c b/arch/x86_64/kernel/traps.c
index 09d2e8a..c730176 100644
--- a/arch/x86_64/kernel/traps.c
+++ b/arch/x86_64/kernel/traps.c
@@ -33,6 +33,10 @@
 #include <linux/uaccess.h>
 #include <linux/bug.h>

+#ifdef CONFIG_TREC
+#include <linux/trec.h>
+#endif
+
 #include <asm/system.h>
 #include <asm/io.h>
 #include <asm/atomic.h>
@@ -547,9 +551,17 @@ void die(const char * str, struct pt_regs * regs, long err)
 {
 	unsigned long flags = oops_begin();

+#ifdef CONFIG_TREC
+	trec_snapshot();
+#endif
+
 	if (!user_mode(regs))
 		report_bug(regs->rip);

+#ifdef CONFIG_TREC
+	trec_print_snapshot();
+#endif
+
 	__die(str, regs, err);
 	oops_end(flags);
 	do_exit(SIGSEGV);
-- 
1.5.0.rc2
