Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZLMT5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZLMT5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 14:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbZLMT5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 14:57:24 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38605 "HELO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751869AbZLMT5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 14:57:24 -0500
Date: Sun, 13 Dec 2009 20:57:21 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] mfd: mc13783: When probing, unlock the mc13783
	before subsystems initialisation.
Message-ID: <20091213195721.GB14024@pengutronix.de>
References: <1260635829.2054.16.camel@climbing-alby> <1260636523.2054.28.camel@climbing-alby> <1260636819.2054.33.camel@climbing-alby>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1260636819.2054.33.camel@climbing-alby>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alberto,

On Sat, Dec 12, 2009 at 05:53:39PM +0100, Alberto Panizzo wrote:
> With this, mc13783 subsystems drivers can configure the mc13783 chip
> reading and writing registers.
> 
> Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
> ---
>  drivers/mfd/mc13783-core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/mc13783-core.c b/drivers/mfd/mc13783-core.c
> index aa1f79a..35dcc2a 100644
> --- a/drivers/mfd/mc13783-core.c
> +++ b/drivers/mfd/mc13783-core.c
> @@ -631,6 +631,8 @@ err_revision:
>  	}
>  	/* This should go away (END) */
>  
> +	mc13783_unlock(mc13783);
> +
>  	if (pdata->flags & MC13783_USE_ADC)
>  		mc13783_add_subdevice(mc13783, "mc13783-adc");
>  
> @@ -653,8 +655,6 @@ err_revision:
>  	if (pdata->flags & MC13783_USE_TOUCHSCREEN)
>  		mc13783_add_subdevice(mc13783, "mc13783-ts");
>  
> -	mc13783_unlock(mc13783);
> -
>  	return 0;
>  }
Looks reasonable.  You can take my Acked-by: for that.

Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
