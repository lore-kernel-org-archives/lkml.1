Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbYAJPlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbYAJPlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758434AbYAJPlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:41:23 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:50756 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757984AbYAJPlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:41:22 -0500
Date: Thu, 10 Jan 2008 16:41:18 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dtor@mail.ru>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>
Subject: Re: [PATCH 6/6] Build system and MAINTAINERS entry for WM97xx touchscreen drivers
Message-ID: <20080110154118.GC15361@uranus.ravnborg.org>
References: <1199965870-4629-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-2-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-3-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-4-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-5-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-6-git-send-email-broonie@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199965870-4629-6-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark.

On Thu, Jan 10, 2008 at 11:51:10AM +0000, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
> ---
>  MAINTAINERS                        |    9 ++++++
>  drivers/input/touchscreen/Kconfig  |   52 ++++++++++++++++++++++++++++++++++++
>  drivers/input/touchscreen/Makefile |   17 +++++++++++
>  3 files changed, 78 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
> index 35d4097..864d3b7 100644
> --- a/drivers/input/touchscreen/Makefile
> +++ b/drivers/input/touchscreen/Makefile
> @@ -4,6 +4,8 @@
>  
>  # Each configuration option enables a list of files.
>  
> +wm97xx-ts-objs := wm97xx-core.o
Use 
wm97xx-ts-y := wm97xx-core.o

> +
>  obj-$(CONFIG_TOUCHSCREEN_ADS7846)	+= ads7846.o
>  obj-$(CONFIG_TOUCHSCREEN_BITSY)		+= h3600_ts_input.o
>  obj-$(CONFIG_TOUCHSCREEN_CORGI)		+= corgi_ts.o
> @@ -19,3 +21,18 @@ obj-$(CONFIG_TOUCHSCREEN_PENMOUNT)	+= penmount.o
>  obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT)	+= touchright.o
>  obj-$(CONFIG_TOUCHSCREEN_TOUCHWIN)	+= touchwin.o
>  obj-$(CONFIG_TOUCHSCREEN_UCB1400)	+= ucb1400_ts.o
> +obj-$(CONFIG_TOUCHSCREEN_WM97XX)	+= wm97xx-ts.o
> +obj-$(CONFIG_TOUCHSCREEN_WM97XX_PXA)	+= pxa-wm97xx.o
> +
> +ifeq ($(CONFIG_TOUCHSCREEN_WM9713),y)
> +wm97xx-ts-objs += wm9713.o
> +endif
So this becomes:
wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9713) += wm9713.o

Same for the other two assignments.

	Sam


> +
> +ifeq ($(CONFIG_TOUCHSCREEN_WM9712),y)
> +wm97xx-ts-objs += wm9712.o
> +endif
> +
> +ifeq ($(CONFIG_TOUCHSCREEN_WM9705),y)
> +wm97xx-ts-objs += wm9705.o
> +endif
> +
