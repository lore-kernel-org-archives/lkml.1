Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab0BLKtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 05:49:53 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45099 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab0BLKtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 05:49:51 -0500
Date: Fri, 12 Feb 2010 11:49:47 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: ixp2000: fix type of ixp2000_timer_interrupt
Message-ID: <20100212104947.GB6590@pengutronix.de>
References: <1264280500-22878-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1264280500-22878-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Sat, Jan 23, 2010 at 10:01:39PM +0100, Uwe Kleine-König wrote:
> This fixes a build warning for 2.6.33-rc5:
> 
> 	arch/arm/mach-ixp2000/core.c:217: warning: initialization from incompatible pointer type
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  arch/arm/mach-ixp2000/core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-ixp2000/core.c b/arch/arm/mach-ixp2000/core.c
> index babb225..e24e3d0 100644
> --- a/arch/arm/mach-ixp2000/core.c
> +++ b/arch/arm/mach-ixp2000/core.c
> @@ -197,7 +197,7 @@ unsigned long ixp2000_gettimeoffset (void)
>  	return offset / ticks_per_usec;
>  }
>  
> -static int ixp2000_timer_interrupt(int irq, void *dev_id)
> +static irqreturn_t ixp2000_timer_interrupt(int irq, void *dev_id)
>  {
>  	/* clear timer 1 */
>  	ixp2000_reg_wrb(IXP2000_T1_CLR, 1);
what do you think about this patch?  It's (IMHO) trivial and fixes a
long standing build warning.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
