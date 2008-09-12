Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbYILRlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbYILRlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 13:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbYILRjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 13:39:55 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:41172 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754435AbYILRjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 13:39:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wls2LdCe+Y6z4QUSAED1HSHHGtEJwFjAOzExymQatDM0fDKpakOjAkzEwuTOs6GvMTQxkoCuai7DcmSKqqexyS5J+aoLIGZY6kuPAxWeGzUrBpIGNqEcQemwsb9hHMg6A81zlUwz0neTK68LxpiOOcEE9f++WqpSytplMf7RynQ=  ;
X-YMail-OSG: lfP3ussVM1n7EZvHK21BUVIwCSglUucC9EVuvx4k28UY88RvtzF5AlMUs7QpAkI0NZd6k1kg0cN2YT2iOLcO44jbQa7BH9lFmrrEvqjw9aNaxBOSy6p1M4xglaAGDUg-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.27-rc6] x86_64 minor HPET tweakage
Date: Fri, 12 Sep 2008 10:18:04 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809121018.04427.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Minor HPET tweakage on x86_64: Label the /proc/interrupts entry
as "hpet" or "pit", matching the device and its clockevent name
in /proc/timer_list.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 arch/x86/kernel/time_64.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -103,13 +103,15 @@ static struct irqaction irq0 = {
 	.handler	= timer_event_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | IRQF_NOBALANCING,
 	.mask		= CPU_MASK_NONE,
-	.name		= "timer"
+	.name		= "hpet"
 };
 
 void __init hpet_time_init(void)
 {
-	if (!hpet_enable())
+	if (!hpet_enable()) {
+		irq0.name = "pit";
 		setup_pit_timer();
+	}
 
 	setup_irq(0, &irq0);
 }
