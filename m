Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbXLLL7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbXLLL7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163AbXLLL6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:58:52 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:35543 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbXLLL6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:58:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r7C5+9Us23F9pdQrI7aDIWDK5VjERdwbRn1Vc/DZvfujphDrgFVCmJSI7kfdPoG43usruedsi0G+emrBjjmfS9ULQkqNbDaPC+XtBaeloEGZrzJ/xsGiPaZ47aNEYV9FOdpn0zWwMl9XhLaz1EzFad0BXPpqWWKxO/hEK12S5Mc=
Message-ID: <cabda6420712120358y38ea040bj1f589db65334d27e@mail.gmail.com>
Date: Wed, 12 Dec 2007 12:58:46 +0100
From: chri <chripell@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] max3100 driver
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071212014941.9bc998bf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11968504052105-git-send-email-chripell@gmail.com>
	 <20071212014941.9bc998bf.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thank you for your extensive review, I will fix and resubmitt. Anyway
I learned an important lesson: checkpatch.pl will be my best friend.
Sorry I haven't read about it earlier.

Just a question:

>
> > +/*
> > + *
> > + *  Copyright (C) 2007 Christian Pellegrin
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> > +
> > +
> > +#ifndef _LINUX_SERIAL_MAX3100_H
> > +#define _LINUX_SERIAL_MAX3100_H 1
> > +
> > +struct plat_max3100 {
> > +     int loopback;
> > +/* force MAX3100 in loopback */
> > +     int crystal;
> > +/* 0 for 3.6864 Mhz, 1 for 1.8432  */
> > +     int only_edge_irq;
> > +/* for archs like PXA with only edge irqs */
> > +};
>
> Does this header file need to exist?  afaict plat_max3100 is only used by
> drivers/serial/max3100.c and hence could be defined there?
>

It's used in the machine definition file for platform devices that
cannot be autoprobed. Anyway where is the best place to put such
struct definition / include files? And what is the best way to
document them (if not inline)? For example I put in my machine
definition file (let's say arch/arm/mach-s3c2410/mach-smdk2410.c):

static struct plat_max3100 max3100_plat_data = {
        .loopback = 0,
        .crystal = 0,
        .only_edge_irq = 0,
};

static struct spi_board_info spi_board_info[] = {
        {
                .modalias       = "max3100",
                .platform_data  = &max3100_plat_data,
                .irq            = IRQ_EINT12,
                .max_speed_hz   = 5*1000*1000,
                .chip_select    = 0,
        },
};

...

   spi_register_board_info(spi_board_info, ARRAY_SIZE(spi_board_info));



-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
