Return-Path: <linux-kernel-owner+w=401wt.eu-S1752345AbZJTTBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbZJTTBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 15:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbZJTTBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 15:01:43 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:57220 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbZJTTBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 15:01:41 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18sGM+g6cE33UgBnXPvb5B6
Date: Tue, 20 Oct 2009 12:01:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, sameo@linux.intel.com,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/4] OMAP: Platform support for twl4030_codec MFD
Message-ID: <20091020190138.GK12576@atomide.com>
References: <1255956140-4829-1-git-send-email-peter.ujfalusi@nokia.com> <1255956140-4829-2-git-send-email-peter.ujfalusi@nokia.com> <1255956140-4829-3-git-send-email-peter.ujfalusi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255956140-4829-3-git-send-email-peter.ujfalusi@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@nokia.com> [091019 05:42]:
> Add needed platform data for the twl4030_codec MFD on boards,
> where the audio part of the twl4030 codec is used.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>

This looks safe to merge with the twl/audio patches to keep
them together. So not adding to my queue.

Acked-by: Tony Lindgren <tony@atomide.com>



> ---
>  arch/arm/mach-omap2/board-3430sdp.c      |    9 +++++++++
>  arch/arm/mach-omap2/board-omap3beagle.c  |    9 +++++++++
>  arch/arm/mach-omap2/board-omap3evm.c     |    9 +++++++++
>  arch/arm/mach-omap2/board-omap3pandora.c |    9 +++++++++
>  arch/arm/mach-omap2/board-overo.c        |    9 +++++++++
>  arch/arm/mach-omap2/board-zoom2.c        |    9 +++++++++
>  6 files changed, 54 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
> index efaf053..4f91f7a 100644
> --- a/arch/arm/mach-omap2/board-3430sdp.c
> +++ b/arch/arm/mach-omap2/board-3430sdp.c
> @@ -410,6 +410,14 @@ static struct regulator_init_data sdp3430_vpll2 = {
>  	.consumer_supplies	= &sdp3430_vdvi_supply,
>  };
>  
> +static struct twl4030_codec_audio_data sdp3430_audio = {
> +	.audio_mclk = 26000000,
> +};
> +
> +static struct twl4030_codec_data sdp3430_codec = {
> +	.audio = &sdp3430_audio,
> +};
> +
>  static struct twl4030_platform_data sdp3430_twldata = {
>  	.irq_base	= TWL4030_IRQ_BASE,
>  	.irq_end	= TWL4030_IRQ_END,
> @@ -420,6 +428,7 @@ static struct twl4030_platform_data sdp3430_twldata = {
>  	.madc		= &sdp3430_madc_data,
>  	.keypad		= &sdp3430_kp_data,
>  	.usb		= &sdp3430_usb_data,
> +	.codec		= &sdp3430_codec,
>  
>  	.vaux1		= &sdp3430_vaux1,
>  	.vaux2		= &sdp3430_vaux2,
> diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
> index 70df6b4..2161d85 100644
> --- a/arch/arm/mach-omap2/board-omap3beagle.c
> +++ b/arch/arm/mach-omap2/board-omap3beagle.c
> @@ -254,6 +254,14 @@ static struct twl4030_usb_data beagle_usb_data = {
>  	.usb_mode	= T2_USB_MODE_ULPI,
>  };
>  
> +static struct twl4030_codec_audio_data beagle_audio_data = {
> +	.audio_mclk = 26000000,
> +};
> +
> +static struct twl4030_codec_data beagle_codec_data = {
> +	.audio = &beagle_audio_data,
> +};
> +
>  static struct twl4030_platform_data beagle_twldata = {
>  	.irq_base	= TWL4030_IRQ_BASE,
>  	.irq_end	= TWL4030_IRQ_END,
> @@ -261,6 +269,7 @@ static struct twl4030_platform_data beagle_twldata = {
>  	/* platform_data for children goes here */
>  	.usb		= &beagle_usb_data,
>  	.gpio		= &beagle_gpio_data,
> +	.codec		= &beagle_codec_data,
>  	.vmmc1		= &beagle_vmmc1,
>  	.vsim		= &beagle_vsim,
>  	.vdac		= &beagle_vdac,
> diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
> index e4ec0c5..d9a6103 100644
> --- a/arch/arm/mach-omap2/board-omap3evm.c
> +++ b/arch/arm/mach-omap2/board-omap3evm.c
> @@ -194,6 +194,14 @@ static struct twl4030_madc_platform_data omap3evm_madc_data = {
>  	.irq_line	= 1,
>  };
>  
> +static struct twl4030_codec_audio_data omap3evm_audio_data = {
> +	.audio_mclk = 26000000,
> +};
> +
> +static struct twl4030_codec_data omap3evm_codec_data = {
> +	.audio = &omap3evm_audio_data,
> +};
> +
>  static struct twl4030_platform_data omap3evm_twldata = {
>  	.irq_base	= TWL4030_IRQ_BASE,
>  	.irq_end	= TWL4030_IRQ_END,
> @@ -203,6 +211,7 @@ static struct twl4030_platform_data omap3evm_twldata = {
>  	.madc		= &omap3evm_madc_data,
>  	.usb		= &omap3evm_usb_data,
>  	.gpio		= &omap3evm_gpio_data,
> +	.codec		= &omap3evm_codec_data,
>  };
>  
>  static struct i2c_board_info __initdata omap3evm_i2c_boardinfo[] = {
> diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
> index 7f6bf87..5036b56 100644
> --- a/arch/arm/mach-omap2/board-omap3pandora.c
> +++ b/arch/arm/mach-omap2/board-omap3pandora.c
> @@ -281,11 +281,20 @@ static struct twl4030_usb_data omap3pandora_usb_data = {
>  	.usb_mode	= T2_USB_MODE_ULPI,
>  };
>  
> +static struct twl4030_codec_audio_data omap3pandora_audio_data = {
> +	.audio_mclk = 26000000,
> +};
> +
> +static struct twl4030_codec_data omap3pandora_codec_data = {
> +	.audio = &omap3pandora_audio_data,
> +};
> +
>  static struct twl4030_platform_data omap3pandora_twldata = {
>  	.irq_base	= TWL4030_IRQ_BASE,
>  	.irq_end	= TWL4030_IRQ_END,
>  	.gpio		= &omap3pandora_gpio_data,
>  	.usb		= &omap3pandora_usb_data,
> +	.codec		= &omap3pandora_codec_data,
>  	.vmmc1		= &pandora_vmmc1,
>  	.vmmc2		= &pandora_vmmc2,
>  	.keypad		= &pandora_kp_data,
> diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
> index 9917d2f..dc55008 100644
> --- a/arch/arm/mach-omap2/board-overo.c
> +++ b/arch/arm/mach-omap2/board-overo.c
> @@ -329,6 +329,14 @@ static struct regulator_init_data overo_vmmc1 = {
>  	.consumer_supplies	= &overo_vmmc1_supply,
>  };
>  
> +static struct twl4030_codec_audio_data overo_audio_data = {
> +	.audio_mclk = 26000000,
> +};
> +
> +static struct twl4030_codec_data overo_codec_data = {
> +	.audio = &overo_audio_data,
> +};
> +
>  /* mmc2 (WLAN) and Bluetooth don't use twl4030 regulators */
>  
>  static struct twl4030_platform_data overo_twldata = {
> @@ -336,6 +344,7 @@ static struct twl4030_platform_data overo_twldata = {
>  	.irq_end	= TWL4030_IRQ_END,
>  	.gpio		= &overo_gpio_data,
>  	.usb		= &overo_usb_data,
> +	.codec		= &overo_codec_data,
>  	.vmmc1		= &overo_vmmc1,
>  };
>  
> diff --git a/arch/arm/mach-omap2/board-zoom2.c b/arch/arm/mach-omap2/board-zoom2.c
> index b7b3220..f1b4e7c 100644
> --- a/arch/arm/mach-omap2/board-zoom2.c
> +++ b/arch/arm/mach-omap2/board-zoom2.c
> @@ -229,6 +229,14 @@ static struct twl4030_madc_platform_data zoom2_madc_data = {
>  	.irq_line	= 1,
>  };
>  
> +static struct twl4030_codec_audio_data zoom2_audio_data = {
> +	.audio_mclk = 26000000,
> +};
> +
> +static struct twl4030_codec_data zoom2_codec_data = {
> +	.audio = &zoom2_audio_data,
> +};
> +
>  static struct twl4030_platform_data zoom2_twldata = {
>  	.irq_base	= TWL4030_IRQ_BASE,
>  	.irq_end	= TWL4030_IRQ_END,
> @@ -239,6 +247,7 @@ static struct twl4030_platform_data zoom2_twldata = {
>  	.usb		= &zoom2_usb_data,
>  	.gpio		= &zoom2_gpio_data,
>  	.keypad		= &zoom2_kp_twl4030_data,
> +	.codec		= &zoom2_codec_data,
>  	.vmmc1          = &zoom2_vmmc1,
>  	.vmmc2          = &zoom2_vmmc2,
>  	.vsim           = &zoom2_vsim,
> -- 
> 1.6.5.1
> 
