Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbZHTNPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbZHTNPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbZHTNPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:15:34 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:15166 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754105AbZHTNPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:15:33 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KOOFHK-02-7K5-02
X-M-MSG: 
Date: Thu, 20 Aug 2009 15:15:21 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/15] x86, sched: Add config option for multi-node CPU
	scheduling
Message-ID: <20090820131521.GP29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090820131243.GO29327@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Aug 2009 13:15:22.0347 (UTC) FILETIME=[45CFC3B0:01CA2198]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've decided to add this as a subitem of MC scheduling.
I think the normal case will be that a multi-node CPU has more than 1
core on each of its nodes. Thus using MN scheduling without MC
scheduling does not make much sense.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/Kconfig |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 65fb791..594e7bc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -713,6 +713,16 @@ config SCHED_MC
 	  making when dealing with multi-core CPU chips at a cost of slightly
 	  increased overhead in some places. If unsure say N here.
 
+config SCHED_MN
+	def_bool n
+	prompt "Multi-node CPU scheduler support"
+	depends on X86_HT && SCHED_MC
+	---help---
+	  Multi-node CPU scheduler support improves the CPU
+	  scheduler's decision making when dealing with multi-node
+	  CPUs (e.g. AMD Magny-Cours) at a cost of slightly increased
+	  overhead in some places. If unsure say N here.
+
 source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
-- 
1.6.0.4



