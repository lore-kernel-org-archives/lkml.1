Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbZCYBvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbZCYBvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 21:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbZCYBvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 21:51:01 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52987 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbZCYBvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 21:51:01 -0400
Message-ID: <49C98DEA.8060208@jp.fujitsu.com>
Date: Wed, 25 Mar 2009 10:50:34 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>
Subject: [PATCH -tip] x86: smarten /proc/interrupts output for new counters
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now /proc/interrupts of tip tree has new counters:
  CNT: Performance counter interrupts
  PLT: Platform interrupts

Format change of output, as like that by commit:
  commit 7a81d9a7da03d2f27840d659f97ef140d032f609
  x86: smarten /proc/interrupts output
should be applied to these new counters too.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jan Beulich <jbeulich@novell.com>
---
 arch/x86/kernel/irq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 9c27543..35b3725 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -63,13 +63,13 @@ static int show_other_interrupts(struct seq_file *p, int prec)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_spurious_count);
 	seq_printf(p, "  Spurious interrupts\n");
-	seq_printf(p, "CNT: ");
+	seq_printf(p, "%*s: ", prec, "CNT");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
 	seq_printf(p, "  Performance counter interrupts\n");
 #endif
 	if (generic_interrupt_extension) {
-		seq_printf(p, "PLT: ");
+		seq_printf(p, "%*s: ", prec, "PLT");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", irq_stats(j)->generic_irqs);
 		seq_printf(p, "  Platform interrupts\n");
-- 
1.6.2.1


