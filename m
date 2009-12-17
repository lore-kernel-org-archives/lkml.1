Return-Path: <linux-kernel-owner+w=401wt.eu-S1764752AbZLQQjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764752AbZLQQjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 11:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764360AbZLQQjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 11:39:49 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:33978 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1764425AbZLQQjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 11:39:46 -0500
Date: Thu, 17 Dec 2009 19:39:44 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, David Vrabel <dvrabel@arcom.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Kumar Gala <galak@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 6/7] spi/mpc8xxx: don't check platform_get_irq's return
 value against zero
Message-ID: <20091217163944.GA6453@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1260979809-24811-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260979809-24811-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260979809-24811-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260979809-24811-4-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260979809-24811-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260979809-24811-6-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1260979809-24811-6-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 05:10:08PM +0100, Uwe Kleine-König wrote:
> platform_get_irq returns -ENXIO on failure, so !irq was probably
> always true.  Better use (int)irq <= 0.  Note that a return value of
> zero is still handled as error even though this could mean irq0.
> 
> This is a followup to 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0 that
> changed the return value of platform_get_irq from 0 to -ENXIO on error.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: David Vrabel <dvrabel@arcom.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Kumar Gala <galak@kernel.crashing.org>
> Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: spi-devel-general@lists.sourceforge.net
> ---
>  drivers/spi/spi_mpc8xxx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/spi_mpc8xxx.c b/drivers/spi/spi_mpc8xxx.c
> index e9390d7..b13501a 100644
> --- a/drivers/spi/spi_mpc8xxx.c
> +++ b/drivers/spi/spi_mpc8xxx.c
> @@ -1339,7 +1339,7 @@ static int __devinit plat_mpc8xxx_spi_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  
>  	irq = platform_get_irq(pdev, 0);
> -	if (!irq)
> +	if ((int)irq <= 0)

I tend to think that it's really hopeless to fix the
platform_get_irq() in its current form, so can you get rid
of this ugly cast and just make the irq signed?

And I'll be fine with it. :-(

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
