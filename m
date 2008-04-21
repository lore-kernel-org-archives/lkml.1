Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbYDUHpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbYDUHpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 03:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbYDUHpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 03:45:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:32995 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYDUHpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 03:45:06 -0400
Date: Mon, 21 Apr 2008 08:42:41 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, kernel@wantstofly.org,
       linux-arm-kernel@lists.arm.linux.org.uk, galak@kernel.crashing.org,
       David Miller <davem@davemloft.net>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, cooloney@kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [git patches] minor irq handler cleanups
Message-ID: <20080421074240.GA1938@flint.arm.linux.org.uk>
References: <20080421013551.GA25960@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421013551.GA25960@havoc.gtf.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 09:35:51PM -0400, Jeff Garzik wrote:
> diff --git a/arch/arm/mach-integrator/time.c b/arch/arm/mach-integrator/time.c
> index 5278f58..5235f64 100644
> --- a/arch/arm/mach-integrator/time.c
> +++ b/arch/arm/mach-integrator/time.c
> @@ -125,7 +125,7 @@ static int rtc_probe(struct amba_device *dev, void *id)
>  	xtime.tv_sec = __raw_readl(rtc_base + RTC_DR);
>  
>  	ret = request_irq(dev->irq[0], arm_rtc_interrupt, IRQF_DISABLED,
> -			  "rtc-pl030", dev);
> +			  "rtc-pl030", NULL);
>  	if (ret)
>  		goto map_out;
>  

BTW, if you're removing the dev_id argument from request_irq(), that
also needs to happen for the corresponding free_irq() calls.
arch/arm/mach-integrator/time.c does:

        free_irq(dev->irq[0], dev);

and these are untouched.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
