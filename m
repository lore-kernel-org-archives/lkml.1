Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbZLMUBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbZLMUBr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 15:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbZLMUBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 15:01:46 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53423 "HELO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754052AbZLMUBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 15:01:46 -0500
Date: Sun, 13 Dec 2009 21:01:42 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] regulator: add voltage selection capability to
	mc13783 regulators.
Message-ID: <20091213200142.GC14024@pengutronix.de>
References: <1260635829.2054.16.camel@climbing-alby> <1260636523.2054.28.camel@climbing-alby> <1260636819.2054.33.camel@climbing-alby> <1260636976.2054.36.camel@climbing-alby>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1260636976.2054.36.camel@climbing-alby>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 12, 2009 at 05:56:16PM +0100, Alberto Panizzo wrote:
> This patch, complete the mc13783 regulator subsystem driver with 
> voltage selecting capability.
> Main Switches (SW1AB, SW2AB) are not supported yet.
> 
> Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
> ---
>  drivers/regulator/mc13783-regulator.c |  375 ++++++++++++++++++++++++++++++---
>  1 files changed, 348 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
> index 9f99862..ed78137 100644
> --- a/drivers/regulator/mc13783-regulator.c
> +++ b/drivers/regulator/mc13783-regulator.c
> @@ -2,6 +2,7 @@
>   * Regulator Driver for Freescale MC13783 PMIC
>   *
>   * Copyright (C) 2008 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
> + * Copyright 2009 Alberto Panizzo <maramaopercheseimorto@gmail.com>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -18,9 +19,47 @@
>  
>  #define MC13783_REG_SWITCHERS4			28
>  #define MC13783_REG_SWITCHERS4_PLLEN			(1 << 18)
> +#define MC13783_REG_SWITCHERS4_PLLVSEL			(1 << 19)
> +#define MC13783_REG_SWITCHERS4_PLLVSEL_M		(7 << 19)
>  
>  #define MC13783_REG_SWITCHERS5			29
>  #define MC13783_REG_SWITCHERS5_SW3EN			(1 << 20)
> +#define MC13783_REG_SWITCHERS5_SW3VSEL			18
This looks inconsitent:
	MC13783_REG_SWITCHERS4_PLLVSEL	(1 << 19)
	MC13783_REG_SWITCHERS5_SW3VSEL	18

I didn't check the rest of the patch though it would be great if you
wouldn't need all those arrays as they occupy much memory.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
