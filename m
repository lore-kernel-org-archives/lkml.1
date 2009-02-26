Return-Path: <linux-kernel-owner+w=401wt.eu-S1759598AbZBZWZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598AbZBZWZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759824AbZBZWZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:25:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759748AbZBZWZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:25:25 -0500
Date: Thu, 26 Feb 2009 14:25:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@openedhand.com, linux-kernel@vger.kernel.org,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] mfd: Use the value of the final spin when reading
 the AUXADC
Message-Id: <20090226142516.fdef29b5.akpm@linux-foundation.org>
In-Reply-To: <1235579015-16193-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1235579015-16193-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<1235579015-16193-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 16:23:35 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8350-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
> index a285cc0..c2be308 100644
> --- a/drivers/mfd/wm8350-core.c
> +++ b/drivers/mfd/wm8350-core.c
> @@ -1111,7 +1111,7 @@ int wm8350_read_auxadc(struct wm8350 *wm8350, int channel, int scale, int vref)
>  	do {
>  		schedule_timeout_interruptible(1);
>  		reg = wm8350_reg_read(wm8350, WM8350_DIGITISER_CONTROL_1);
> -	} while (--tries && (reg & WM8350_AUXADC_POLL));
> +	} while ((reg & WM8350_AUXADC_POLL) && --tries);
>  
>  	if (!tries)
>  		dev_err(wm8350->dev, "adc chn %d read timeout\n", channel);

Please do not ever send any unchangelogged patches ever again, at all, ever.

OK?
