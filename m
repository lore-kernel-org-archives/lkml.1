Return-Path: <linux-kernel-owner+w=401wt.eu-S1762134AbXGUO6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762134AbXGUO6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 10:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758300AbXGUO5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 10:57:50 -0400
Received: from il.qumranet.com ([82.166.9.18]:45572 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbXGUO5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 10:57:49 -0400
From: Avi Kivity <avi@qumranet.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
       Richard Gooch <rgooch@atnf.csiro.au>
Subject: [PATCH 1/4] [MTRR] Simplify smp_call_function_single() call sequence
Date: Sat, 21 Jul 2007 17:57:54 +0300
Message-Id: <11850298771165-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <11850298772540-git-send-email-avi@qumranet.com>
References: <11850298772540-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

smp_call_function_single() now knows how to call the function on the
current cpu.

Cc: Richard Gooch <rgooch@atnf.csiro.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/i386/kernel/cpu/mtrr/main.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/i386/kernel/cpu/mtrr/main.c b/arch/i386/kernel/cpu/mtrr/main.c
index 75dc6d5..d8db59a 100644
--- a/arch/i386/kernel/cpu/mtrr/main.c
+++ b/arch/i386/kernel/cpu/mtrr/main.c
@@ -738,13 +738,7 @@ void mtrr_ap_init(void)
  */
 void mtrr_save_state(void)
 {
-	int cpu = get_cpu();
-
-	if (cpu == 0)
-		mtrr_save_fixed_ranges(NULL);
-	else
-		smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
-	put_cpu();
+	smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
 }
 
 static int __init mtrr_init_finialize(void)
-- 
1.5.2.4

