Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbYAOTB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbYAOTB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 14:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbYAOTBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 14:01:19 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:20183 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbYAOTBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 14:01:18 -0500
Message-ID: <478D02F4.5060704@ct.jp.nec.com>
Date: Tue, 15 Jan 2008 11:01:08 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86_64: move select_idle_routine() call after detect_ht()
References: <478BB226.6090105@ct.jp.nec.com> <20080114190904.GA2288@elte.hu> <478C1475.7060706@ct.jp.nec.com> <20080115132607.GE7025@elte.hu> <478D01E4.8010000@ct.jp.nec.com>
In-Reply-To: <478D01E4.8010000@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: [PATCH] x86_64: move select_idle_routine() call after detect_ht()

Move the select_idle_routine() call to after the detect_ht() call at
identify_cpu() on 64-bit.
This change is for printing the polling idle and HT enabled warning
message properly.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/setup_64.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index c8dcdd2..8ebf990 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -1067,7 +1067,6 @@ void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 		break;
 	}
 
-	select_idle_routine(c);
 	detect_ht(c);
 
 	/*
@@ -1085,6 +1084,8 @@ void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 #ifdef CONFIG_X86_MCE
 	mcheck_init(c);
 #endif
+	select_idle_routine(c);
+
 	if (c != &boot_cpu_data)
 		mtrr_ap_init();
 #ifdef CONFIG_NUMA
-- 
1.5.3.6

