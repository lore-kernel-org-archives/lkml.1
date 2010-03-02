Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab0CBHzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 02:55:21 -0500
Received: from mail-yx0-f182.google.com ([209.85.210.182]:50960 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab0CBHzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 02:55:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=OfPxngH/QspKkF7UcQ6hwO/0p0rePWOAqgReWCgAK2nuJ6Utu5xjMIPfrUfPSJPeUp
         JKIKSJkX3EZyoGv0fhRJ7NHF0q7KnIhDWS+9L6bjSGxUYO/VvwHNDyxUfYLQL2vtKGHI
         uppvTvVKD+m15b2J5XixXaA2sYT2vhnuLgeQ8=
Date: Mon, 1 Mar 2010 23:55:13 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
       linux-input@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Luotao Fu <l.fu@pengutronix.de>
Subject: Re: [PATCH 2/6] input/mc13783-ts: Don't use deprecated mc13783 API
 calls
Message-ID: <20100302075513.GC17307@core.coreip.homeip.net>
References: <1267440825-14694-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1267440825-14694-2-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1267440825-14694-2-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 11:53:41AM +0100, Uwe Kleine-König wrote:
> mc13783_ackirq is deprecated, use the drop in replacement mc13783_irq_ack.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

I assume it will go thourgh MFD tree?

Acked-by: Dmitry Torokhov <dtor@mail.ru>

> ---
> Hello,
> 
> note this obviously depends on patch 1/6.
> 
> Best regards
> Uwe
> 
>  drivers/input/touchscreen/mc13783_ts.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/mc13783_ts.c b/drivers/input/touchscreen/mc13783_ts.c
> index be115b3..be54fd6 100644
> --- a/drivers/input/touchscreen/mc13783_ts.c
> +++ b/drivers/input/touchscreen/mc13783_ts.c
> @@ -44,7 +44,7 @@ static irqreturn_t mc13783_ts_handler(int irq, void *data)
>  {
>  	struct mc13783_ts_priv *priv = data;
>  
> -	mc13783_ackirq(priv->mc13783, irq);
> +	mc13783_irq_ack(priv->mc13783, irq);
>  
>  	/*
>  	 * Kick off reading coordinates. Note that if work happens already
> @@ -135,7 +135,7 @@ static int mc13783_ts_open(struct input_dev *dev)
>  
>  	mc13783_lock(priv->mc13783);
>  
> -	mc13783_ackirq(priv->mc13783, MC13783_IRQ_TS);
> +	mc13783_irq_ack(priv->mc13783, MC13783_IRQ_TS);
>  
>  	ret = mc13783_irq_request(priv->mc13783, MC13783_IRQ_TS,
>  		mc13783_ts_handler, MC13783_TS_NAME, priv);
> -- 
> 1.7.0
> 

-- 
Dmitry
