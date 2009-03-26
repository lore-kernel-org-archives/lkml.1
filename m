Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbZCZXoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbZCZXoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760035AbZCZXoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:44:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57478
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753776AbZCZXo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:44:29 -0400
Date: Thu, 26 Mar 2009 16:44:17 -0700 (PDT)
Message-Id: <20090326.164417.155660865.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH]: Fix sparc64 build.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n2QNj2qu023423


Ingo, didn't we fix this (a few times)? :-)

Linus, please apply:

sparc64: Fix build of timer_interrupt().

arch/sparc/kernel/time_64.c: In function â€˜timer_interruptâ€™:
arch/sparc/kernel/time_64.c:732: error: â€˜struct kernel_statâ€™ has no member named â€˜irqsâ€™
make[1]: *** [arch/sparc/kernel/time_64.o] Error 1

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index 642562d..4ee2e48 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -724,12 +724,14 @@ void timer_interrupt(int irq, struct pt_regs *regs)
 	unsigned long tick_mask = tick_ops->softint_mask;
 	int cpu = smp_processor_id();
 	struct clock_event_device *evt = &per_cpu(sparc64_events, cpu);
+	struct irq_desc *desc;
 
 	clear_softint(tick_mask);
 
 	irq_enter();
 
-	kstat_this_cpu.irqs[0]++;
+	desc = irq_to_desc(0);
+	kstat_incr_irqs_this_cpu(0, desc);
 
 	if (unlikely(!evt->event_handler)) {
 		printk(KERN_WARNING
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
