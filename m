Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842Ab0ADReN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab0ADReN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214Ab0ADReK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:34:10 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57296 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab0ADReJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:34:09 -0500
Subject: Re: [PATCH 2.6.33] regulator: Specify REGULATOR_CHANGE_STATUS for
 WM835x LED constraints
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <1262619054-26795-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1262619054-26795-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jan 2010 17:34:00 +0000
Message-ID: <1262626440.2968.31.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 15:30 +0000, Mark Brown wrote:
> The WM8350 LED driver needs to be able to enable and disable the
> regulators it is using. Previously the core wasn't properly enforcing
> status change constraints so the driver was able to function but this
> has always been intended to be required.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: stable@kernel.org
> ---
>  drivers/regulator/wm8350-regulator.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
> index 1bbff09..e7b89e7 100644
> --- a/drivers/regulator/wm8350-regulator.c
> +++ b/drivers/regulator/wm8350-regulator.c
> @@ -1504,7 +1504,8 @@ int wm8350_register_led(struct wm8350 *wm8350, int lednum, int dcdc, int isink,
>  	led->isink_init.consumer_supplies = &led->isink_consumer;
>  	led->isink_init.constraints.min_uA = 0;
>  	led->isink_init.constraints.max_uA = pdata->max_uA;
> -	led->isink_init.constraints.valid_ops_mask = REGULATOR_CHANGE_CURRENT;
> +	led->isink_init.constraints.valid_ops_mask
> +		= REGULATOR_CHANGE_CURRENT | REGULATOR_CHANGE_STATUS;
>  	led->isink_init.constraints.valid_modes_mask = REGULATOR_MODE_NORMAL;
>  	ret = wm8350_register_regulator(wm8350, isink, &led->isink_init);
>  	if (ret != 0) {
> @@ -1517,6 +1518,7 @@ int wm8350_register_led(struct wm8350 *wm8350, int lednum, int dcdc, int isink,
>  	led->dcdc_init.num_consumer_supplies = 1;
>  	led->dcdc_init.consumer_supplies = &led->dcdc_consumer;
>  	led->dcdc_init.constraints.valid_modes_mask = REGULATOR_MODE_NORMAL;
> +	led->dcdc_init.constraints.valid_ops_mask =  REGULATOR_CHANGE_STATUS;
>  	ret = wm8350_register_regulator(wm8350, dcdc, &led->dcdc_init);
>  	if (ret != 0) {
>  		platform_device_put(pdev);

Applied.

Thanks

Liam

