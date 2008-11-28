Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbYK1POM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbYK1POM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 10:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYK1PN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 10:13:56 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:12409 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbYK1PNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 10:13:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nqO14foLjOw4iTJ6AFW9jxfWmNXVOJL8bL++UqbA3RgYC3In7UErRPd1y0VuGJUXnJ
         3pMTOmhg3LHR0lMv3oE/Wwh0fcjrTt5ywgKdrLSIY31XorZfTWAFQPfeyzGW1VG71d39
         6akasl4FWHJ5eryjZcKhSmqmyo0kKXHzLjj6k=
Date: Fri, 28 Nov 2008 18:17:55 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: next-2008-11-28: bfin vs cpumask fixlet
Message-ID: <20081128151755.GA27660@x200.localdomain>
References: <20081128213620.2ec593d4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081128213620.2ec593d4.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- a/arch/blackfin/kernel/time-ts.c
+++ b/arch/blackfin/kernel/time-ts.c
@@ -162,7 +162,6 @@ static struct clock_event_device clockevent_bfin = {
 	.name		= "bfin_core_timer",
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.shift		= 32,
-	.cpumask	= CPU_MASK_CPU0,
 	.set_next_event = bfin_timer_set_next_event,
 	.set_mode	= bfin_timer_set_mode,
 };
@@ -193,6 +192,7 @@ static int __init bfin_clockevent_init(void)
 	clockevent_bfin.mult = div_sc(timer_clk, NSEC_PER_SEC, clockevent_bfin.shift);
 	clockevent_bfin.max_delta_ns = clockevent_delta2ns(-1, &clockevent_bfin);
 	clockevent_bfin.min_delta_ns = clockevent_delta2ns(100, &clockevent_bfin);
+	clockevent_bfin.cpumask = cpumask_of(0);
 	clockevents_register_device(&clockevent_bfin);
 
 	return 0;
