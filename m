Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbYANTEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbYANTEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbYANTEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:04:16 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:65205 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbYANTEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:04:15 -0500
Message-ID: <478BB226.6090105@ct.jp.nec.com>
Date: Mon, 14 Jan 2008 11:04:06 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: mingo@elte.hu
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] x86_32: remove warning message not used
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

smp_num_siblings hasn't been updated at this point yet, so it's always 1.
This polling and HT warning message is never shown.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/process_32.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 69a69c3..f449b6d 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -305,10 +305,6 @@ static int __init idle_setup(char *str)
 	if (!strcmp(str, "poll")) {
 		printk("using polling idle threads.\n");
 		pm_idle = poll_idle;
-#ifdef CONFIG_X86_SMP
-		if (smp_num_siblings > 1)
-			printk("WARNING: polling idle and HT enabled, performance may degrade.\n");
-#endif
 	} else if (!strcmp(str, "mwait"))
 		force_mwait = 1;
 	else
-- 
1.5.3.6


