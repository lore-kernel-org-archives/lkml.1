Return-Path: <linux-kernel-owner+w=401wt.eu-S1760622AbYBLGKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622AbYBLGKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 01:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbYBLGK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 01:10:29 -0500
Received: from rex.snapgear.com ([203.143.235.140]:60801 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753551AbYBLGK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 01:10:27 -0500
Date: Tue, 12 Feb 2008 16:07:39 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802120607.m1C67dJ9009907@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: fix coldfire interrupt exit path
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Walter T Gruczka <walter.t.gruczka@boeing.com>

Remove bogus conditional jump in return from interrupt path.
Reorder the code path now that is not there.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naurp linux-2.6.25-rc1/arch/m68knommu/platform/coldfire/entry.S linux-2.6.x/arch/m68knommu/platform/coldfire/entry.S
--- linux-2.6.25-rc1/arch/m68knommu/platform/coldfire/entry.S	2008-02-11 14:50:21.000000000 +1000
+++ linux-2.6.x/arch/m68knommu/platform/coldfire/entry.S	2008-02-12 14:05:13.000000000 +1000
@@ -197,14 +197,13 @@ ENTRY(fasthandler)
 	RESTORE_LOCAL
 
 ENTRY(ret_from_interrupt)
-	jeq	2f
-1:
-	RESTORE_ALL
-2:
 	moveb	%sp@(PT_SR),%d0
 	andl	#0x7,%d0
-	jhi	1b
+	jeq	1f
 
+	RESTORE_ALL
+
+1:
 	/* check if we need to do software interrupts */
 	movel	irq_stat+CPUSTAT_SOFTIRQ_PENDING,%d0
 	jeq	ret_from_exception
