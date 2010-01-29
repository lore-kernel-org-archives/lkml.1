Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575Ab0A2Cup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab0A2Cup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 21:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246Ab0A2Cuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 21:50:44 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38433 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab0A2Cuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 21:50:44 -0500
Date: Fri, 29 Jan 2010 11:50:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux@arm.linux.org.uk, eric.y.miao@gmail.com, tony@atomide.com,
       linux-kernel@vger.kernel.org, khilman@deeprootsystems.com,
       ben-linux@fluff.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 05/06] sh: Let INTC set IRQF_VALID on ARM platforms
Message-ID: <20100129025041.GB7396@linux-sh.org>
References: <20100128124028.8982.16123.sendpatchset@rxone.opensource.se> <20100128124121.8982.71803.sendpatchset@rxone.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100128124121.8982.71803.sendpatchset@rxone.opensource.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 09:41:21PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Reuse the SuperH INTC code on ARM by using set_irq_flags()
> to set IRQF_VALID on ARM platforms. Reworking the shared ARM
> interrupt code and removing IRQF_VALID is another option.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  drivers/sh/intc.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- 0001/drivers/sh/intc.c
> +++ work/drivers/sh/intc.c	2010-01-21 19:53:15.000000000 +0900
> @@ -658,6 +658,11 @@ static void __init intc_register_irq(str
>  
>  	if (desc->ack_regs)
>  		ack_handle[irq] = intc_ack_data(desc, d, enum_id);
> +
> +	/* Set IRQF_VALID to enable IRQ on ARM systems */
> +#ifdef CONFIG_ARCH_SHMOBILE
> +	set_irq_flags(irq, IRQF_VALID);
> +#endif
>  }
>  
This should be CONFIG_ARM rather than ARCH_SHMOBILE, as it's hardly
SH-Mobile specific.
