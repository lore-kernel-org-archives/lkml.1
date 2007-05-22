Return-Path: <linux-kernel-owner+w=401wt.eu-S1764128AbXEVIIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764128AbXEVIIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757286AbXEVIGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:06:22 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:10692 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbXEVIGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:06:11 -0400
From: muli@il.ibm.com
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org, jdmason@kudzu.us,
       michaelv@il.ibm.com, guillaume.thouvenin@ext.bull.net, muli@il.ibm.com
Subject: [PATCH 1/15] x86-64: Calgary - generalize calgary_increase_split_completion_timeout
Date: Tue, 22 May 2007 04:05:50 -0400
Message-Id: <11798211643659-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.4.4
In-Reply-To: <11798211643534-git-send-email-muli@il.ibm.com>
References: <11798211643534-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>

... will be used by CalIOC2 later

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86_64/kernel/pci-calgary.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index 5bd20b5..4b0c3ad 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -775,8 +775,8 @@ static void calgary_watchdog(unsigned lo
 	}
 }
 
-static void __init calgary_increase_split_completion_timeout(void __iomem *bbar,
-	unsigned char busnum)
+static void __init calgary_set_split_completion_timeout(void __iomem *bbar,
+	unsigned char busnum, unsigned long timeout)
 {
 	u64 val64;
 	void __iomem *target;
@@ -802,7 +802,7 @@ static void __init calgary_increase_spli
 	/* zero out this PHB's timer bits */
 	mask = ~(0xFUL << phb_shift);
 	val64 &= mask;
-	val64 |= (CCR_2SEC_TIMEOUT << phb_shift);
+	val64 |= (timeout << phb_shift);
 	writeq(cpu_to_be64(val64), target);
 	readq(target); /* flush */
 }
@@ -836,7 +836,8 @@ static void __init calgary_enable_transl
 	 * http://bugzilla.kernel.org/show_bug.cgi?id=7180
 	 */
 	if (busnum == 1)
-		calgary_increase_split_completion_timeout(bbar, busnum);
+		calgary_set_split_completion_timeout(bbar, busnum,
+						     CCR_2SEC_TIMEOUT);
 
 	init_timer(&tbl->watchdog_timer);
 	tbl->watchdog_timer.function = &calgary_watchdog;
-- 
1.4.4

