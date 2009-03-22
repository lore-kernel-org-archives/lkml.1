Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbZCVK2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbZCVK2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 06:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZCVK22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 06:28:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:35488 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbZCVK22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 06:28:28 -0400
Subject: [PATCH -tip] x86: irq.c use same path for show_interrupts
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Mar 2009 15:57:04 +0530
Message-Id: <1237717624.3223.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Sun, 22 Mar 2009 15:43:14 +0530
Subject: [PATCH] x86: irq.c use same path for show_interrupts

Impact: cleanup

SMP and !SMP will use same path for show_interrupts

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/irq.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index b8ac3b6..5e7c3e6 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -133,23 +133,15 @@ int show_interrupts(struct seq_file *p, void *v)
 		return 0;
 
 	spin_lock_irqsave(&desc->lock, flags);
-#ifndef CONFIG_SMP
-	any_count = kstat_irqs(i);
-#else
 	for_each_online_cpu(j)
 		any_count |= kstat_irqs_cpu(i, j);
-#endif
 	action = desc->action;
 	if (!action && !any_count)
 		goto out;
 
 	seq_printf(p, "%*d: ", prec, i);
-#ifndef CONFIG_SMP
-	seq_printf(p, "%10u ", kstat_irqs(i));
-#else
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
-#endif
 	seq_printf(p, " %8s", desc->chip->name);
 	seq_printf(p, "-%-8s", desc->name);
 
-- 
1.6.0.6



