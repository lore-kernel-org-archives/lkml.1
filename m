Return-Path: <linux-kernel-owner+w=401wt.eu-S932680Ab0AFTs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab0AFTs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932671Ab0AFTs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:48:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:60446 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932670Ab0AFTsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:48:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,230,1262592000"; 
   d="scan'208";a="481836991"
Date: Wed, 6 Jan 2010 20:50:01 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Update WM8350 drivers for changed interrupt
 numbers
Message-ID: <20100106195000.GC23473@sortiz.org>
References: <y>
 <1262805865-15605-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262805865-15605-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Jan 06, 2010 at 07:24:25PM +0000, Mark Brown wrote:
> The headphone detect and charger are using the IRQ numbers so need
> to take account of irq_base with the genirq conversion. I obviously
> picked the wrong system for initial testing.
Patch applied to my for-next branch, thanks.

Cheers,
Samuel.


> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/power/wm8350_power.c |    2 +-
>  sound/soc/codecs/wm8350.c    |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/power/wm8350_power.c b/drivers/power/wm8350_power.c
> index 3839a5e..0693902 100644
> --- a/drivers/power/wm8350_power.c
> +++ b/drivers/power/wm8350_power.c
> @@ -190,7 +190,7 @@ static irqreturn_t wm8350_charger_handler(int irq, void *data)
>  	struct wm8350_power *power = &wm8350->power;
>  	struct wm8350_charger_policy *policy = power->policy;
>  
> -	switch (irq) {
> +	switch (irq - wm8350->irq_base) {
>  	case WM8350_IRQ_CHG_BAT_FAIL:
>  		dev_err(wm8350->dev, "battery failed\n");
>  		break;
> diff --git a/sound/soc/codecs/wm8350.c b/sound/soc/codecs/wm8350.c
> index f45845a..93f1e4e 100644
> --- a/sound/soc/codecs/wm8350.c
> +++ b/sound/soc/codecs/wm8350.c
> @@ -1349,7 +1349,7 @@ static irqreturn_t wm8350_hp_jack_handler(int irq, void *data)
>  	int mask;
>  	struct wm8350_jack_data *jack = NULL;
>  
> -	switch (irq) {
> +	switch (irq - wm8350->irq_base) {
>  	case WM8350_IRQ_CODEC_JCK_DET_L:
>  		jack = &priv->hpl;
>  		mask = WM8350_JACK_L_LVL;
> @@ -1424,7 +1424,7 @@ int wm8350_hp_jack_detect(struct snd_soc_codec *codec, enum wm8350_jack which,
>  	wm8350_set_bits(wm8350, WM8350_JACK_DETECT, ena);
>  
>  	/* Sync status */
> -	wm8350_hp_jack_handler(irq, priv);
> +	wm8350_hp_jack_handler(irq + wm8350->irq_base, priv);
>  
>  	return 0;
>  }
> -- 
> 1.6.5.7
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
