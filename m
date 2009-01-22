Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbZAVBZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbZAVBZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 20:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbZAVBYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 20:24:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57438
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754904AbZAVBYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 20:24:49 -0500
Date: Wed, 21 Jan 2009 17:24:51 -0800 (PST)
Message-Id: <20090121.172451.72573335.davem@davemloft.net>
To: yinghai@kernel.org
Cc: mpm@selenic.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: sparc64 build breakage...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090121.171553.142827920.davem@davemloft.net>
References: <20090121.171553.142827920.davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n0M1PCwM017651

From: David Miller <davem@davemloft.net>
Date: Wed, 21 Jan 2009 17:15:53 -0800 (PST)

> 
> This change:
> 
> commit d7e51e66899f95dabc89b4d4c6674a6e50fa37fc
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Wed Jan 7 15:03:13 2009 -0800
> 
>     sparseirq: make some func to be used with genirq
> 
> breaks the sparc64 build:
..
> This should fix it:
> 
> sparc64: Fix build by using kstat_irqs_cpu().

And here is a mix for the next failure.

But really, either linux/kernel_stat.h provides the
kstat_incr_irqs_this_cpu interface or linux/irq.h does, not both.

sparc64: Fix build by including linux/irq.h into time_64.c

Changeset d7e51e66899f95dabc89b4d4c6674a6e50fa37fc ("sparseirq: make
some func to be used with genirq") broke the build on sparc64:
    
arch/sparc/kernel/time_64.c: In function â€˜timer_interruptâ€™:
arch/sparc/kernel/time_64.c:732: error: implicit declaration of function â€˜kstat_incr_irqs_this_cpuâ€™
make[1]: *** [arch/sparc/kernel/time_64.o] Error 1

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index db310aa..f95066b 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -36,10 +36,10 @@
 #include <linux/clocksource.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/irq.h>
 
 #include <asm/oplib.h>
 #include <asm/timer.h>
-#include <asm/irq.h>
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/starfire.h>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
