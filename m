Return-Path: <linux-kernel-owner+w=401wt.eu-S932988AbZLPS7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988AbZLPS7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759949AbZLPS7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:59:37 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:60083 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762882AbZLPS73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:59:29 -0500
X-Auth-Info: Zwp9ph72Tv1+lIV8f3Pmy4FBhXrjBoRNqVV8UFWu4W0=
Message-ID: <4B292DDE.6080906@grandegger.com>
Date: Wed, 16 Dec 2009 19:58:38 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: linux-kernel@vger.kernel.org, David Vrabel <dvrabel@arcom.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Urs Thuermann <urs.thuermann@volkswagen.de>,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>,
       "David S. Miller" <davem@davemloft.net>,
       Kurt Van Dijck <kurt.van.dijck@eia.be>, netdev@vger.kernel.org
Subject: Re: [PATCH 4/7] can/at91: don't check platform_get_irq's return value
 against zero
References: <1260979809-24811-1-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-2-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-3-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-4-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1260979809-24811-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König wrote:
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
> Cc: Urs Thuermann <urs.thuermann@volkswagen.de>
> Cc: Oliver Hartkopp <oliver.hartkopp@volkswagen.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: Kurt Van Dijck <kurt.van.dijck@eia.be>
> Cc: netdev@vger.kernel.org

Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>

> ---
>  drivers/net/can/at91_can.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
> index cbe3fce..631d404 100644
> --- a/drivers/net/can/at91_can.c
> +++ b/drivers/net/can/at91_can.c
> @@ -1037,7 +1037,7 @@ static int __init at91_can_probe(struct platform_device *pdev)
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	irq = platform_get_irq(pdev, 0);
> -	if (!res || !irq) {
> +	if (!res || irq <= 0) {
>  		err = -ENODEV;
>  		goto exit_put;
>  	}

Thanks,

Wolfgang.
