Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbZAVBQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbZAVBQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 20:16:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZAVBPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 20:15:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35880
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754745AbZAVBPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 20:15:51 -0500
Date: Wed, 21 Jan 2009 17:15:53 -0800 (PST)
Message-Id: <20090121.171553.142827920.davem@davemloft.net>
To: yinghai@kernel.org
CC: mpm@selenic.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: sparc64 build breakage...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n0M1G4wM017608


This change:

commit d7e51e66899f95dabc89b4d4c6674a6e50fa37fc
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Wed Jan 7 15:03:13 2009 -0800

    sparseirq: make some func to be used with genirq

breaks the sparc64 build:

arch/sparc/kernel/irq_64.c: In function â€˜show_interruptsâ€™:
arch/sparc/kernel/irq_64.c:188: error: â€˜struct kernel_statâ€™ has no member named â€˜irqsâ€™
make[1]: *** [arch/sparc/kernel/irq_64.o] Error 1

This should fix it:

sparc64: Fix build by using kstat_irqs_cpu().

Changeset d7e51e66899f95dabc89b4d4c6674a6e50fa37fc ("sparseirq: make
some func to be used with genirq") broke the build on sparc64:

arch/sparc/kernel/irq_64.c: In function â€˜show_interruptsâ€™:
arch/sparc/kernel/irq_64.c:188: error: â€˜struct kernel_statâ€™ has no member named â€˜irqsâ€™
make[1]: *** [arch/sparc/kernel/irq_64.o] Error 1

Fix by using the kstat_irqs_cpu() interface.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index 4ac5c65..5b33d59 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -185,7 +185,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
 		seq_printf(p, " %9s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
