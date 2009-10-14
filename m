Return-Path: <linux-kernel-owner+w=401wt.eu-S932994AbZJNKv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbZJNKv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 06:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbZJNKvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 06:51:25 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:61187 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946AbZJNKvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 06:51:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:x-operating-system:user-agent;
        b=TjmOoPjnNU9JpX5BW4/345FoyJHfuGESUIHK0rXF8BXSrA2GOYpsehiLOyHjom1bSP
         zQ+K4Amn3EoPVyMoYLX4bBTF+r1x/PPwcW+HlvjEljAPbbTzKUfb7L0bSIvlKdYHZ4g4
         sQnfa3odT8aB+tRABst4emOKyeSdjNe5RJj5M=
Date: Wed, 14 Oct 2009 18:50:39 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: irq.c rename 'performance counter interrupt'
Message-ID: <20091014105039.GA22670@uhli>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux uhli 2.6.28-11-generic 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 'cdd6c482c9ff9c55475ee7392ec8f672eddb7be6', Ingo Molnar has renamed
Performance Counters -> Performance Events. The name showed up in
/proc/interrupts also needs a change. I use PMI (Performance monitoring
interrupt) here, since it is the official name used in Intel's documents.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 arch/x86/kernel/irq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3912061..86fb2c8 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -63,10 +63,10 @@ static int show_other_interrupts(struct seq_file *p, int prec)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_spurious_count);
 	seq_printf(p, "  Spurious interrupts\n");
-	seq_printf(p, "%*s: ", prec, "CNT");
+	seq_printf(p, "%*s: ", prec, "PMI");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
-	seq_printf(p, "  Performance counter interrupts\n");
+	seq_printf(p, "  Performance monitoring interrupts\n");
 	seq_printf(p, "%*s: ", prec, "PND");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_pending_irqs);
-- 
1.6.0.4

