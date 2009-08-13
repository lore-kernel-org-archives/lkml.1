Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbZHMWGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbZHMWGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 18:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbZHMWGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 18:06:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:43253 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754285AbZHMWGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 18:06:45 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1972mcVmMx7vnkcZF+y3TDWEA7GjCc99BoXZANFsp
	LkLCqEvNY4F/eH
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Greg KH <gregkh@suse.de>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [patch 28/74] thinkpad-acpi: fix incorrect use of TPACPI_BRGHT_MODE_ECNVRAM
Date: Fri, 14 Aug 2009 00:06:43 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-sidux-amd64; KDE/4.3.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       Len Brown <len.brown@intel.com>
References: <20090813194935.985368088@mini.kroah.org> <20090813195128.703325684@mini.kroah.org>
In-Reply-To: <20090813195128.703325684@mini.kroah.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908140006.45800.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thursday 13 August 2009, Greg KH wrote:
> 2.6.30-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> 
> commit 59fe4fe34d7afdf63208124f313be9056feaa2f4 upstream.
> 
> HBRV-based default selection of backlight control strategy didn't work
> well, at least the X41 defines it but doesn't use it and I don't think
> it will stop there.
> 
> Switch to a white/blacklist.  All models that have HBRV defined have
> been included in the list, and initially all ATI GPUs will get
> ECNVRAM, and the Intel GPUs will get UCMS_STEP.
> 
> Symptoms of incorrect backlight mode selection are:
> 
> 1. Non-working backlight control through sysfs;
> 
> 2. Backlight gets reset to the lowest level at every shutdown, reboot
>    and when thinkpad-acpi gets unloaded;
> 
> This fixes a regression in 2.6.30, bugzilla #13826

As already reported in [1] and confirmed by hmh in [2], this patch breaks 
compiling thinkpad_acpi in 2.6.31-rc5.

[...]
  CC [M]  drivers/platform/x86/hp-wmi.o
  CC [M]  drivers/platform/x86/sony-laptop.o
  CC [M]  drivers/platform/x86/thinkpad_acpi.o
drivers/platform/x86/thinkpad_acpi.c:5769: error: array type has incomplete element type
drivers/platform/x86/thinkpad_acpi.c:5771: error: implicit declaration of function 'TPACPI_Q_IBM'
drivers/platform/x86/thinkpad_acpi.c: In function 'brightness_init':
drivers/platform/x86/thinkpad_acpi.c:5799: error: implicit declaration of function 'tpacpi_check_quirks'
drivers/platform/x86/thinkpad_acpi.c:5800: warning: type defaults to 'int' in declaration of 'type name'
drivers/platform/x86/thinkpad_acpi.c:5800: warning: type defaults to 'int' in declaration of 'type name'
drivers/platform/x86/thinkpad_acpi.c:5800: error: size of array 'type name' is negative
make[6]: *** [drivers/platform/x86/thinkpad_acpi.o] Error 1
make[5]: *** [drivers/platform/x86] Error 2
make[4]: *** [drivers/platform] Error 2
make[3]: *** [drivers] Error 2

Regards
	Stefan Lippers-Hollmann

[1]	From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
	Date: Fri, 7 Aug 2009 01:08:10 +0200
	Subject: Re: patch thinkpad-acpi-fix-incorrect-use-of-tpacpi_brght_mode_ecnvram.patch added to 2.6.30-stable tree
	Message-Id: <200908070108.15095.s.L-H@gmx.de>
	http://lkml.indiana.edu/hypermail/linux/kernel/0908.0/02520.html
[2]	From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
	Date: Thu, 6 Aug 2009 20:31:11 -0300
	Subject: Re: patch thinkpad-acpi-fix-incorrect-use-of-tpacpi_brght_mode_ecnvram.patch added to 2.6.30-stable tree
	Message-ID: <20090806233111.GB14381@khazad-dum.debian.net>
	http://lkml.indiana.edu/hypermail/linux/kernel/0908.0/02526.html

-- 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Reported-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>
> Signed-off-by: Len Brown <len.brown@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/platform/x86/thinkpad_acpi.c |   61 ++++++++++++++++++++++++++---------
>  1 file changed, 47 insertions(+), 14 deletions(-)
> 
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -5757,14 +5757,48 @@ static struct backlight_ops ibm_backligh
>  
>  /* --------------------------------------------------------------------- */
>  
> +/*
> + * These are only useful for models that have only one possibility
> + * of GPU.  If the BIOS model handles both ATI and Intel, don't use
> + * these quirks.
> + */
> +#define TPACPI_BRGHT_Q_NOEC	0x0001	/* Must NOT use EC HBRV */
> +#define TPACPI_BRGHT_Q_EC	0x0002  /* Should or must use EC HBRV */
> +#define TPACPI_BRGHT_Q_ASK	0x8000	/* Ask for user report */
> +
> +static const struct tpacpi_quirk brightness_quirk_table[] __initconst = {
> +	/* Models with ATI GPUs known to require ECNVRAM mode */
> +	TPACPI_Q_IBM('1', 'Y', TPACPI_BRGHT_Q_EC),	/* T43/p ATI */
> +
> +	/* Models with ATI GPUs (waiting confirmation) */
> +	TPACPI_Q_IBM('1', 'R', TPACPI_BRGHT_Q_ASK|TPACPI_BRGHT_Q_EC),
> +	TPACPI_Q_IBM('1', 'Q', TPACPI_BRGHT_Q_ASK|TPACPI_BRGHT_Q_EC),
> +	TPACPI_Q_IBM('7', '6', TPACPI_BRGHT_Q_ASK|TPACPI_BRGHT_Q_EC),
> +	TPACPI_Q_IBM('7', '8', TPACPI_BRGHT_Q_ASK|TPACPI_BRGHT_Q_EC),
> +
> +	/* Models with Intel Extreme Graphics 2 (waiting confirmation) */
> +	TPACPI_Q_IBM('1', 'V', TPACPI_BRGHT_Q_ASK|TPACPI_BRGHT_Q_NOEC),
> +	TPACPI_Q_IBM('1', 'W', TPACPI_BRGHT_Q_ASK|TPACPI_BRGHT_Q_NOEC),
> +	TPACPI_Q_IBM('1', 'U', TPACPI_BRGHT_Q_ASK|TPACPI_BRGHT_Q_NOEC),
> +
> +	/* Models with Intel GMA900 */
> +	TPACPI_Q_IBM('7', '0', TPACPI_BRGHT_Q_NOEC),	/* T43, R52 */
> +	TPACPI_Q_IBM('7', '4', TPACPI_BRGHT_Q_NOEC),	/* X41 */
> +	TPACPI_Q_IBM('7', '5', TPACPI_BRGHT_Q_NOEC),	/* X41 Tablet */
> +};
> +
>  static int __init brightness_init(struct ibm_init_struct *iibm)
>  {
>  	int b;
> +	unsigned long quirks;
>  
>  	vdbg_printk(TPACPI_DBG_INIT, "initializing brightness subdriver\n");
>  
>  	mutex_init(&brightness_mutex);
>  
> +	quirks = tpacpi_check_quirks(brightness_quirk_table,
> +				ARRAY_SIZE(brightness_quirk_table));
> +
>  	/*
>  	 * We always attempt to detect acpi support, so as to switch
>  	 * Lenovo Vista BIOS to ACPI brightness mode even if we are not
> @@ -5821,23 +5855,13 @@ static int __init brightness_init(struct
>  	/* TPACPI_BRGHT_MODE_AUTO not implemented yet, just use default */
>  	if (brightness_mode == TPACPI_BRGHT_MODE_AUTO ||
>  	    brightness_mode == TPACPI_BRGHT_MODE_MAX) {
> -		if (thinkpad_id.vendor == PCI_VENDOR_ID_IBM) {
> -			/*
> -			 * IBM models that define HBRV probably have
> -			 * EC-based backlight level control
> -			 */
> -			if (acpi_evalf(ec_handle, NULL, "HBRV", "qd"))
> -				/* T40-T43, R50-R52, R50e, R51e, X31-X41 */
> -				brightness_mode = TPACPI_BRGHT_MODE_ECNVRAM;
> -			else
> -				/* all other IBM ThinkPads */
> -				brightness_mode = TPACPI_BRGHT_MODE_UCMS_STEP;
> -		} else
> -			/* All Lenovo ThinkPads */
> +		if (quirks & TPACPI_BRGHT_Q_EC)
> +			brightness_mode = TPACPI_BRGHT_MODE_ECNVRAM;
> +		else
>  			brightness_mode = TPACPI_BRGHT_MODE_UCMS_STEP;
>  
>  		dbg_printk(TPACPI_DBG_BRGHT,
> -			   "selected brightness_mode=%d\n",
> +			   "driver auto-selected brightness_mode=%d\n",
>  			   brightness_mode);
>  	}
>  
> @@ -5858,6 +5882,15 @@ static int __init brightness_init(struct
>  	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_BRGHT,
>  			"brightness is supported\n");
>  
> +	if (quirks & TPACPI_BRGHT_Q_ASK) {
> +		printk(TPACPI_NOTICE
> +			"brightness: will use unverified default: "
> +			"brightness_mode=%d\n", brightness_mode);
> +		printk(TPACPI_NOTICE
> +			"brightness: please report to %s whether it works well "
> +			"or not on your ThinkPad\n", TPACPI_MAIL);
> +	}
> +
>  	ibm_backlight_device->props.max_brightness =
>  				(tp_features.bright_16levels)? 15 : 7;
>  	ibm_backlight_device->props.brightness = b & TP_EC_BACKLIGHT_LVLMSK;
