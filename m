Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbYDPBoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbYDPBoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 21:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbYDPBoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 21:44:00 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:51058 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbYDPBn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 21:43:59 -0400
Message-ID: <480559DC.2060807@tiscali.nl>
Date: Wed, 16 Apr 2008 03:43:56 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: ralf@linux-mips.org
CC: linux-mips@linux-mips.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] MIPS: ip27-timer: fix unsigned irq < 0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq is unsigned, cast to signed to evaluate the allocate_irqno() return value,
    
Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---   
diff --git a/arch/mips/sgi-ip27/ip27-timer.c b/arch/mips/sgi-ip27/ip27-timer.c
index 25d3baf..3c08afd 100644
--- a/arch/mips/sgi-ip27/ip27-timer.c
+++ b/arch/mips/sgi-ip27/ip27-timer.c
@@ -222,19 +222,19 @@ static void __init hub_rt_clock_event_global_init(void)
 	unsigned int irq;
 
 	do {
 		smp_wmb();
 		irq = rt_timer_irq;
 		if (irq)
 			break;
 
 		irq = allocate_irqno();
-		if (irq < 0)
+		if ((int) irq < 0)
 			panic("Allocation of irq number for timer failed");
 	} while (xchg(&rt_timer_irq, irq));
 
 	set_irq_chip_and_handler(irq, &rt_irq_type, handle_percpu_irq);
 	setup_irq(irq, &hub_rt_irqaction);
 }
 
 static cycle_t hub_rt_read(void)
 {
