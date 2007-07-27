Return-Path: <linux-kernel-owner+w=401wt.eu-S937053AbXG0JvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937053AbXG0JvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933715AbXG0Jq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:46:58 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:36202 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935985AbXG0Jq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:46:56 -0400
Date: Fri, 27 Jul 2007 11:45:31 +0200 (MEST)
Message-Id: <200707270945.LAA17306@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 14/68] 0 -> NULL, for arch/sh
Cc: lethal@linux-sh.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
From: Yoann Padioleau <padator@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When comparing a pointer, it's clearer to compare it to NULL than to 0.

Here is an excerpt of the semantic patch: 

@@
expression *E;
@@

  E ==
- 0
+ NULL

@@
expression *E;
@@

  E !=
- 0
+ NULL

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: lethal@linux-sh.org
Cc: akpm@linux-foundation.org
---

 cchips/hd6446x/hd64461.c       |    2 +-
 cchips/hd6446x/hd64465/gpio.c  |    4 ++--
 cchips/hd6446x/hd64465/setup.c |    2 +-
 cchips/voyagergx/irq.c         |    2 +-
 kernel/sh_bios.c               |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/sh/cchips/hd6446x/hd64461.c b/arch/sh/cchips/hd6446x/hd64461.c
index 97f6512..6117fd7 100644
--- a/arch/sh/cchips/hd6446x/hd64461.c
+++ b/arch/sh/cchips/hd6446x/hd64461.c
@@ -116,7 +116,7 @@ int hd64461_irq_demux(int irq)
 			irq = CONFIG_HD64461_IRQ;
 		else {
 			irq = HD64461_IRQBASE + i;
-			if (hd64461_demux[i].func != 0) {
+			if (hd64461_demux[i].func != NULL) {
 				irq = hd64461_demux[i].func(irq, hd64461_demux[i].dev);
 			}
 		}
diff --git a/arch/sh/cchips/hd6446x/hd64465/gpio.c b/arch/sh/cchips/hd6446x/hd64465/gpio.c
index 4343185..8ed39e2 100644
--- a/arch/sh/cchips/hd6446x/hd64465/gpio.c
+++ b/arch/sh/cchips/hd6446x/hd64465/gpio.c
@@ -96,7 +96,7 @@ static irqreturn_t hd64465_gpio_interrup
 	    	mask = 1<<pin;
 	    	if (isr & mask) {
 		    portpin = (port<<3)|pin;
-		    if (handlers[portpin].func != 0)
+		    if (handlers[portpin].func != NULL)
 		    	handlers[portpin].func(portpin, handlers[portpin].dev);
     	    	    else
 		    	printk(KERN_NOTICE "unexpected GPIO interrupt, pin %c%d\n",
@@ -117,7 +117,7 @@ void hd64465_gpio_register_irq(int portp
     	unsigned long flags;
 	unsigned short icr, mask;
 
-	if (handler == 0)
+	if (handler == NULL)
 	    return;
 	    
 	local_irq_save(flags);
diff --git a/arch/sh/cchips/hd6446x/hd64465/setup.c b/arch/sh/cchips/hd6446x/hd64465/setup.c
index d126e1f..f6c4139 100644
--- a/arch/sh/cchips/hd6446x/hd64465/setup.c
+++ b/arch/sh/cchips/hd6446x/hd64465/setup.c
@@ -140,7 +140,7 @@ int hd64465_irq_demux(int irq)
 
     	    	if (i < HD64465_IRQ_NUM) {
 		    irq = HD64465_IRQ_BASE + i;
-    	    	    if (hd64465_demux[i].func != 0)
+    	    	    if (hd64465_demux[i].func != NULL)
 		    	irq = hd64465_demux[i].func(irq, hd64465_demux[i].dev);
 		}
 	}
diff --git a/arch/sh/cchips/voyagergx/irq.c b/arch/sh/cchips/voyagergx/irq.c
index d70e5c8..9631e9a 100644
--- a/arch/sh/cchips/voyagergx/irq.c
+++ b/arch/sh/cchips/voyagergx/irq.c
@@ -128,7 +128,7 @@ int voyagergx_irq_demux(int irq)
 		pr_debug("voyagergx_irq_demux %ld \n", i);
 		if (i < VOYAGER_IRQ_NUM) {
 			irq = VOYAGER_IRQ_BASE + i;
-			if (voyagergx_demux[i].func != 0)
+			if (voyagergx_demux[i].func != NULL)
 				irq = voyagergx_demux[i].func(irq,
 						voyagergx_demux[i].dev);
 		}
diff --git a/arch/sh/kernel/sh_bios.c b/arch/sh/kernel/sh_bios.c
index d1bcac4..c91585c 100644
--- a/arch/sh/kernel/sh_bios.c
+++ b/arch/sh/kernel/sh_bios.c
@@ -56,7 +56,7 @@ int sh_bios_in_gdb_mode(void)
 	    gdb_mode_p = (char *)r;
 	queried = 1;
     }
-    return (gdb_mode_p != 0 ? *gdb_mode_p : 0);
+    return (gdb_mode_p != NULL ? *gdb_mode_p : 0);
 }
 
 void sh_bios_gdb_detach(void)

