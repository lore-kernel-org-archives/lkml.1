Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbXEGOFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbXEGOFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 10:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbXEGOFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 10:05:11 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1260 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754356AbXEGOFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 10:05:10 -0400
Date: Mon, 7 May 2007 14:04:54 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Anton Vorontsov <cbou@mail.ru>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
Message-ID: <20070507140453.GD3868@ucw.cz>
References: <20070503213303.GH20067@zarina>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503213303.GH20067@zarina>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This probably should be marked as BROKEN because, according
> to David Woodhouse, EC-acccess method will change. Plus currently
> it lacks mutexes. So this driver is just for reference. Converted
> from the battery-2.6 repository, 1:1.
> 
> But nevertheless it should work.
> 
> Signed-off-by: Anton Vorontsov <cbou@mail.ru>
> ---
>  drivers/power/Kconfig        |    6 +
>  drivers/power/Makefile       |    1 +
>  drivers/power/olpc_battery.c |  300 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 307 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/power/olpc_battery.c
> 
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index 051724f..3ac79c3 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -42,4 +42,10 @@ config BATTERY_PMU
>  	  Say Y here to expose battery information on Apple machines
>  	  through the generic battery class.
>  
> +config BATTERY_OLPC
> +	tristate "One Laptop Per Child battery"
> +	depends on X86_32
> +	help
> +	  Say Y to enable support for the battery on the $100 laptop.
> +
>  endif # POWER_SUPPLY
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index 0ebdc6d..62b58ca 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -19,3 +19,4 @@ obj-$(CONFIG_APM_POWER)            += apm_power.o
>  
>  obj-$(CONFIG_BATTERY_DS2760)       += ds2760_battery.o
>  obj-$(CONFIG_BATTERY_PMU)          += pmu_battery.o
> +obj-$(CONFIG_BATTERY_OLPC)         += olpc_battery.o
> diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
> new file mode 100644
> index 0000000..40f76bb
> --- /dev/null
> +++ b/drivers/power/olpc_battery.c
> @@ -0,0 +1,300 @@
> +/*
> + * Battery driver for One Laptop Per Child ($100 laptop) board.
> + *
> + *	Copyright ?? 2006  David Woodhouse <dwmw2@infradead.org>

Can we stick to ascii in sources?

> +#define wBAT_VOLTAGE     0xf900  /* *9.76/32,    mV   */
> +#define wBAT_CURRENT     0xf902  /* *15.625/120, mA   */
> +#define wBAT_TEMP        0xf906  /* *256/1000,   ??C  */
> +#define wAMB_TEMP        0xf908  /* *256/1000,   ??C  */

Ascii? And those defines seem affected by hungarian convention.


> +#define sMBAT_STATUS     0xfaa4
> +#define	sBAT_PRESENT          1
> +#define	sBAT_FULL             2
> +#define	sBAT_DESTROY          4  /* what is this exactly? */
> +#define	sBAT_LOW             32
> +#define	sBAT_DISCHG          64
> +#define sMCHARGE_STATUS  0xfaa5
> +#define	sBAT_CHARGE           1
> +#define	sBAT_OVERTEMP         4
> +#define	sBAT_NiMH             8
> +#define sPOWER_FLAG      0xfa40


							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
