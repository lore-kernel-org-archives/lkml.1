Return-Path: <linux-kernel-owner+w=401wt.eu-S932330AbXKOSbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbXKOSbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759861AbXKOSa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:30:57 -0500
Received: from lobo.ruivo.org ([66.92.68.119]:42405 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757811AbXKOSa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:30:57 -0500
Date: Thu, 15 Nov 2007 13:30:46 -0500
From: Aristeu Rozanski <aris@ruivo.org>
To: Dan Aloni <da-x@monatomic.org>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: fix a deadlock in set_rtc_mmss()
Message-ID: <20071115183046.GD8068@cathedrallabs.org>
References: <20071115165528.GA25520@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115165528.GA25520@localdomain>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dan,
> Patch is valid only for 2.6.23.x, guessing from the recent arch/ changes 
> in 2.6.24-rc.
> 
> set_rtc_mmss() was used to be called from interrupt context in 2.6.22,
> however in 2.6.23, it is called from a timer context, where interrupts
> are enabled. This patch ensures that rtc_interrupt() won't dead-lock 
> with set_rtc_mmss().

> diff --git a/arch/x86_64/kernel/time.c b/arch/x86_64/kernel/time.c
> index 6241b50..8414236 100644
> --- a/arch/x86_64/kernel/time.c
> +++ b/arch/x86_64/kernel/time.c
> @@ -87,13 +87,14 @@ static int set_rtc_mmss(unsigned long nowtime)
>  	int retval = 0;
>  	int real_seconds, real_minutes, cmos_minutes;
>  	unsigned char control, freq_select;
> +	unsigned long flags;
>  
>  /*
>   * IRQs are disabled when we're called from the timer interrupt,
>   * no need for spin_lock_irqsave()
>   */
>  
> -	spin_lock(&rtc_lock);
> +	spin_lock_irqsave(&rtc_lock, flags);
I think it's a good idea to update or just remove the comment above.

-- 
Aristeu

