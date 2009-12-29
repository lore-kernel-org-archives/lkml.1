Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbZL2I32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbZL2I32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 03:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbZL2I31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 03:29:27 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50599 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZL2I30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 03:29:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=dGYsMlnWZ/apegEWJ//1oPeARpbQ2TbN4hreupOn1AaXFXjaU64XYFnyoleC3PNQCP
         acP1NhYi73EEL2p4k3h/JQHaU2qiSQvw1qvYkv+Ir0SuplHt/ZQbl0pj6nk1UO8HeIIn
         x0lgGqUu+wE0Es+wF6McjxMuzWHQww3IXa+Aw=
To: "Luke-Jr" <luke@dashjr.org>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Balbi Felipe \(Nokia-D\/Helsinki\)" <felipe.balbi@nokia.com>
Subject: Re: [PATCH] OMAP2: add USB platform data and initialization for Nokia N800 and N810
References: <200912290152.16357.luke@dashjr.org>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 29 Dec 2009 10:29:22 +0200
In-Reply-To: <200912290152.16357.luke@dashjr.org> (Luke-Jr's message of "Tue\, 29 Dec 2009 01\:52\:04 -0600")
Message-ID: <87d41yxjx9.fsf@purkki.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Luke-Jr" <luke@dashjr.org> writes:

> Add platform data and initialization for USB on Nokia N800 and N810 devices
> via the TUSB6010 chipset.

Excellent, thank you for doing this.

> Tested on Nokia N810 in Linux-OMAP tree. Mainline is not bootable yet.

What's the problem in mainline? I haven't tested n8x0 for months :(

> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -117,6 +117,11 @@ config MACH_NOKIA_N8X0
>  	select MACH_NOKIA_N810
>  	select MACH_NOKIA_N810_WIMAX
>  
> +config MACH_NOKIA_N8X0_USB
> +	bool
> +	depends on MACH_NOKIA_N8X0 && MACH_OMAP2_TUSB6010
> +	default y
> +

Is is really needed to add new kconfig variable? Can't we just use
MACH_OMAP2_TUSB6010 in code?

> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-n8x0-usb.c

I think a separate file is not needed, it's not that much code. I
recommend to just adding it directly to board-n8x0.c. It's simple and
easier for everyone.

> --- a/arch/arm/mach-omap2/board-n8x0.c
> +++ b/arch/arm/mach-omap2/board-n8x0.c
> @@ -109,8 +109,16 @@ static void __init n8x0_init_irq(void)
>  	omap_gpio_init();
>  }
>  
> +#ifdef CONFIG_MACH_NOKIA_N8X0_LCD
> +extern void n8x0_usb_init(void);
> +#else
> +static inline void n8x0_usb_init (void) {}
> +#endif

CONFIG_MACH_NOKIA_N8X0_LCD does not look right here.

-- 
Kalle Valo
