Return-Path: <linux-kernel-owner+w=401wt.eu-S1758306AbYDPJQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbYDPJQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 05:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbYDPJQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 05:16:06 -0400
Received: from elvis.franken.de ([193.175.24.41]:55474 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbYDPJQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 05:16:05 -0400
Date: Wed, 16 Apr 2008 11:15:54 +0200
To: Roel Kluin <12o3l@tiscali.nl>
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] MIPS: ip27-timer: fix unsigned irq < 0
Message-ID: <20080416091554.GA6026@alpha.franken.de>
References: <480559DC.2060807@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480559DC.2060807@tiscali.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 03:43:56AM +0200, Roel Kluin wrote:
> irq is unsigned, cast to signed to evaluate the allocate_irqno() return value,
>     
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---   
> diff --git a/arch/mips/sgi-ip27/ip27-timer.c b/arch/mips/sgi-ip27/ip27-timer.c
> index 25d3baf..3c08afd 100644
> --- a/arch/mips/sgi-ip27/ip27-timer.c
> +++ b/arch/mips/sgi-ip27/ip27-timer.c
> @@ -222,19 +222,19 @@ static void __init hub_rt_clock_event_global_init(void)
>  	unsigned int irq;
>  
>  	do {
>  		smp_wmb();
>  		irq = rt_timer_irq;
>  		if (irq)
>  			break;
>  
>  		irq = allocate_irqno();
> -		if (irq < 0)
> +		if ((int) irq < 0)

Why don't you just make irq and rt_timer_irq an int ?

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
