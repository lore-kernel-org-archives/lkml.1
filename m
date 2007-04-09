Return-Path: <linux-kernel-owner+w=401wt.eu-S1030574AbXDJORZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030574AbXDJORZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030579AbXDJORY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:17:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2115 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030521AbXDJOQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:16:57 -0400
Date: Mon, 9 Apr 2007 20:10:51 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Alan Hourihane <alanh@fairlite.demon.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/01] New FBDev driver for Intel Vermilion Range
Message-ID: <20070409201050.GA4302@ucw.cz>
References: <1175769886.10382.29.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175769886.10382.29.camel@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +struct cr_sys {
> +	struct vml_sys sys;
> +	struct pci_dev *mch_dev;
> +	struct pci_dev *lpc_dev;
> +	__u32 mch_bar;
> +	__u8 *mch_regs_base;
> +	__u32 gpio_bar;
> +	__u32 saved_panel_state;
> +	__u32 saved_clock;

u32/u8 is right type to use here.

> +static struct vml_sys *my_sys = NULL;

No need for zero initing.

> +static int crvml_sysinit(struct cr_sys *crsys)
> +{
> +	__u32 dev_en;
> +	__u8 dev_en8;

u8/u32, please.

> +static void crvml_panel_on(const struct vml_sys *sys)
> +{
> +	const struct cr_sys *crsys = container_of(sys, struct cr_sys, sys);
> +	__u32 addr = crsys->gpio_bar + CRVML_PANEL_PORT;
> +	__u32 cur = inl(addr);

here too, and everywhere outside headers.

> +static void crvml_backlight_on(const struct vml_sys *sys)
> +{
> +	const struct cr_sys *crsys = container_of(sys, struct cr_sys, sys);
> +	__u32 addr = crsys->gpio_bar + CRVML_PANEL_PORT;
> +	__u32 cur = inl(addr);
> +
> +	if (cur & CRVML_BACKLIGHT_OFF) {
> +		cur &= ~CRVML_BACKLIGHT_OFF;
> +		outl(cur, addr);
> +	}
> +}
> +
> +static void crvml_backlight_off(const struct vml_sys *sys)
> +{
> +	const struct cr_sys *crsys = container_of(sys, struct cr_sys, sys);
> +	__u32 addr = crsys->gpio_bar + CRVML_PANEL_PORT;
> +	__u32 cur = inl(addr);
> +
> +	if (!(cur & CRVML_BACKLIGHT_OFF)) {
> +		cur |= CRVML_BACKLIGHT_OFF;
> +		outl(cur, addr);
> +	}
> +}


Should this go to driv*/video/backlight?

> +static int crvml_false(const struct vml_sys *sys)
> +{
> +	return 0;
> +}
> +
> +static int crvml_true(const struct vml_sys *sys)
> +{
> +	return 1;
> +}

Ugly but useful... should be done once for all fbdevs?

> +#if (defined(CONFIG_X86) && defined(X86_FEATURE_PAT) && defined(X86_FEATURE_MSR))
> +
> +/*
> + * Use the i386 Page Attribute Table for write-combining.
> + * We can't include this code in the kernel submission, since some of it
> + * belongs at kernel startup.
> + */
> +
> +#define USE_PAT_WC
> +#else
> +#undef USE_PAT_WC
> +#endif

Eh? Did you want to remove this?


> +/**************************************************************************
> + * 
> + * Copyright (c) Intel Corp. 2007.
> + * All Rights Reserved.
> + * 
> + * Intel funded Tungsten Graphics (http://www.tungstengraphics.com) to
> + * develop this driver.
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a
> + * copy of this software and associated documentation files (the
> + * "Software"), to deal in the Software without restriction, including
> + * without limitation the rights to use, copy, modify, merge, publish,
> + * distribute, sub license, and/or sell copies of the Software, and to
> + * permit persons to whom the Software is furnished to do so, subject to
> + * the following conditions:
> + * 
> + * The above copyright notice and this permission notice (including the
> + * next paragraph) shall be included in all copies or substantial portions
> + * of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
> + * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
> + * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
> + * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE 
> + * USE OR OTHER DEALINGS IN THE SOFTWARE.

Can you just use GPL here?

> +#ifdef __KERNEL__
> +#include<linux/ioctl.h>
> +#include<linux/types.h>

Missingspaces.

> +#define __u64 uint64_t

No.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
