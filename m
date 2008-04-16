Return-Path: <linux-kernel-owner+w=401wt.eu-S1764675AbYDPPKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764675AbYDPPKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 11:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759030AbYDPPKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 11:10:07 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:33379 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758316AbYDPPKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:10:06 -0400
Message-ID: <480616C6.3080203@tiscali.nl>
Date: Wed, 16 Apr 2008 17:09:58 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
CC: ralf@linux-mips.org, linux-mips@linux-mips.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6 v2] MIPS: ip27-timer: unsigned irq to evaluate allocate_irqno()
References: <480559DC.2060807@tiscali.nl> <20080416091554.GA6026@alpha.franken.de>
In-Reply-To: <20080416091554.GA6026@alpha.franken.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Bogendoerfer wrote:
> On Wed, Apr 16, 2008 at 03:43:56AM +0200, Roel Kluin wrote:
>> irq is unsigned, cast to signed to evaluate the allocate_irqno() return value,
 
>> +		if ((int) irq < 0)
> 
> Why don't you just make irq and rt_timer_irq an int ?

Ok, thanks, It should be right, but I cannot test this (no hardware).
---
when allocate_irqno() returns a negative error value, but is stored in an
unsigned variable 'irq', the test '(irq < 0)' won't work.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/mips/sgi-ip27/ip27-timer.c b/arch/mips/sgi-ip27/ip27-timer.c
index 25d3baf..9cebc9e 100644
--- a/arch/mips/sgi-ip27/ip27-timer.c
+++ b/arch/mips/sgi-ip27/ip27-timer.c
@@ -158,7 +158,7 @@ static void rt_set_mode(enum clock_event_mode mode,
 	}
 }
 
-unsigned int rt_timer_irq;
+int rt_timer_irq;
 
 static irqreturn_t hub_rt_counter_handler(int irq, void *dev_id)
 {
@@ -219,7 +219,7 @@ static void __cpuinit hub_rt_clock_event_init(void)
 
 static void __init hub_rt_clock_event_global_init(void)
 {
-	unsigned int irq;
+	int irq;
 
 	do {
 		smp_wmb();

