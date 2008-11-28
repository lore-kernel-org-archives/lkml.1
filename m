Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbYK1Kf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbYK1Kf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 05:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYK1KfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 05:35:15 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:42174 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbYK1KfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 05:35:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=DH8jIvxJRybJodbGOL7j33g/U3lyeHrdNojXrU6X30Zwl+VcSCyHeahv5V7H5EKFsJ
         E6dWm5MorRNjdcNDlVCU3VTC2UcbpzSsR56SIEdLupZjcY+kMxnG1ZKsofu3HHYjsW+N
         uRqwwJQ31pWOflOFQjeXsSarfqo2hzSvvmDdY=
Date: Fri, 28 Nov 2008 13:39:13 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: sfr@canb.auug.org.au
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: [PATCH -next] at91rm9200 vs cpumask changes
Message-ID: <20081128103913.GA8488@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- a/arch/arm/mach-at91/at91rm9200_time.c
+++ b/arch/arm/mach-at91/at91rm9200_time.c
@@ -169,7 +169,6 @@ static struct clock_event_device clkevt = {
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.shift		= 32,
 	.rating		= 150,
-	.cpumask	= CPU_MASK_CPU0,
 	.set_next_event	= clkevt32k_next_event,
 	.set_mode	= clkevt32k_mode,
 };
@@ -197,7 +196,7 @@ void __init at91rm9200_timer_init(void)
 	clkevt.mult = div_sc(AT91_SLOW_CLOCK, NSEC_PER_SEC, clkevt.shift);
 	clkevt.max_delta_ns = clockevent_delta2ns(AT91_ST_ALMV, &clkevt);
 	clkevt.min_delta_ns = clockevent_delta2ns(2, &clkevt) + 1;
-	clkevt.cpumask = cpumask_of_cpu(0);
+	clkevt.cpumask = cpumask_of(0);
 	clockevents_register_device(&clkevt);
 
 	/* register clocksource */
