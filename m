Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011Ab0A1BoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab0A1BoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 20:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858Ab0A1BoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 20:44:08 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1498 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab0A1BoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 20:44:06 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5874"; a="32940422"
Message-ID: <4B60EBD1.9020005@codeaurora.org>
Date: Wed, 27 Jan 2010 17:43:45 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Yinghai Lu <yinghai@kernel.org>, Tony Lindgren <tony@atomide.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Kalle Valo <kalle.valo@iki.fi>, Jean Pihet <jpihet@mvista.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Colin Tuckley <colin.tuckley@arm.com>,
       Philby John <pjohn@in.mvista.com>,
       Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
       Alessandro Rubini <rubini@unipv.it>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>,
       linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 3/5] gic: Add set_type callback
References: <1264620749-24527-1-git-send-email-adharmap@codeaurora.org> <1264620749-24527-4-git-send-email-adharmap@codeaurora.org> <20100127231832.GF29665@n2100.arm.linux.org.uk>
In-Reply-To: <20100127231832.GF29665@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Wed, Jan 27, 2010 at 11:32:27AM -0800, adharmap@codeaurora.org wrote:
>> +	if (flow_type & (IRQ_TYPE_EDGE_RISING|IRQ_TYPE_EDGE_FALLING)) {
>> +		reg_value |= (2<<bit_index);
>> +		writel(reg_value, gic_dist_base(irq) + GIC_DIST_CONFIG
>> +							+ register_index);
>> +		__set_irq_handler_unlocked(irq, handle_edge_irq);
>> +	}
>> +
>> +	if (flow_type & (IRQ_TYPE_LEVEL_HIGH|IRQ_TYPE_LEVEL_LOW)) {
> 
> This is actually where things start to get rather sticky - because
> there may well be on-chip inverters between the GIC and external
> peripherals.
Actually the comment in gic_dist_init mentions about configuring SPI's 
as level low when the GIC only supports level high. That suggests 
presence of an inverter.
> 
> Since the GIC can only sense one edge or one level depending on the
> hardware setup, it seems wrong to allow the configuration of both
> high and low levels, and both edges.
Agree, but this change at least lets us configure them as edge/level 
triggered.

One solution (a rather easy one) is we simply reject LEVEL_LOW and 
EDGE_FALLING and think as if the inverters belong to the peripherals 
rather than the GIC.

Please suggest alternative implementation ideas.





