Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab0CCI6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 03:58:15 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51475 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753328Ab0CCI6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 03:58:10 -0500
X-Sasl-enc: 9OQa580B8p4XSWONugTZQnO0/pTNva6Uyd39XLoBIcoo 1267606688
Message-ID: <4B8E249E.2090806@ladisch.de>
Date: Wed, 03 Mar 2010 09:58:06 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [alsa-devel] [patch] oxygen: change || to &&
References: <20100303070818.GD5086@bicker>
In-Reply-To: <20100303070818.GD5086@bicker>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter wrote:
> In the original code the condition was always true (hopefully) because
> WM8776_HPLVOL is zero.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Thanks; applied.

> diff --git a/sound/pci/oxygen/xonar_wm87x6.c b/sound/pci/oxygen/xonar_wm87x6.c
> index 7754db1..dbc4b89 100644
> --- a/sound/pci/oxygen/xonar_wm87x6.c
> +++ b/sound/pci/oxygen/xonar_wm87x6.c
> @@ -68,7 +68,7 @@ static void wm8776_write(struct oxygen *chip,
>  			 OXYGEN_SPI_CEN_LATCH_CLOCK_LO,
>  			 (reg << 9) | value);
>  	if (reg < ARRAY_SIZE(data->wm8776_regs)) {
> -		if (reg >= WM8776_HPLVOL || reg <= WM8776_DACMASTER)
> +		if (reg >= WM8776_HPLVOL && reg <= WM8776_DACMASTER)
>  			value &= ~WM8776_UPDATE;
>  		data->wm8776_regs[reg] = value;
>  	}
