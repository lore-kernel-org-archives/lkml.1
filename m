Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbZCaIHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbZCaIHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZCaIHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:07:21 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:53072 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZCaIHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:07:20 -0400
Message-Id: <49D1EB87.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 31 Mar 2009 09:08:07 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND][PATCH -tip] x86: smarten /proc/interrupts output
	 for newcounters
References: <49D1CC84.2020102@jp.fujitsu.com>
In-Reply-To: <49D1CC84.2020102@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jan Beulich <jbeulich@novell.com>

>>> Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> 31.03.09 09:55 >>>
Now /proc/interrupts of tip tree has new counters:
  CNT: Performance counter interrupts
  PLT: Platform interrupts

Format change of output as like that by commit:
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



