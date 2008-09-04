Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbYIDMtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbYIDMtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbYIDMth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:49:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33119 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752645AbYIDMtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:49:36 -0400
Date: Thu, 4 Sep 2008 13:49:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>
Subject: Re: [PATCH 5/9] ASoC: Blackfin: AC97 Blackfin CPU DAI driver
Message-ID: <20080904124934.GC13735@rakim.wolfsonmicro.main>
Mail-Followup-To: Bryan Wu <cooloney@kernel.org>,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
	Cliff Cai <cliff.cai@analog.com>
References: <1220516528-20301-1-git-send-email-cooloney@kernel.org> <1220516528-20301-6-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220516528-20301-6-git-send-email-cooloney@kernel.org>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 04:22:04PM +0800, Bryan Wu wrote:

> +static void bf5xx_ac97_cold_reset(struct snd_ac97 *ac97)
> +{
> +#ifdef CONFIG_SND_BF5XX_HAVE_COLD_RESET
> +	pr_debug("%s enter\n", __func__);
> +
> +	/* It is specified for bf548-ezkit */
> +	gpio_set_value(CONFIG_SND_BF5XX_RESET_GPIO_NUM, 0);
> +	/* Keep reset pin low for 1 ms */
> +	mdelay(1);
> +	gpio_set_value(CONFIG_SND_BF5XX_RESET_GPIO_NUM, 1);
> +	/* Wait for bit clock recover */
> +	mdelay(1);
> +#endif
> +}

Sorry, I did mean to say: shouldn't this print a warning like the warm
reset does if it's not implemented?
