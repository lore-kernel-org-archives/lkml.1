Return-Path: <linux-kernel-owner+w=401wt.eu-S1750757AbXB0LC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750757AbXB0LC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 06:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbXB0LC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 06:02:58 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:42947 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750757AbXB0LC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 06:02:57 -0500
Date: Tue, 27 Feb 2007 12:02:50 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kyle McMartin <kyle@parisc-linux.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: resource_size_t printk whinging
In-Reply-To: <20070227041648.GB13669@athena.road.mcmartin.ca>
Message-ID: <Pine.LNX.4.62.0702271201330.21803@pademelon.sonytel.be>
References: <20070227041648.GB13669@athena.road.mcmartin.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007, Kyle McMartin wrote:
> I submitted this patch a while ago, but nobody commented on it.
> All these casts of resource_size_t to (unsigned long long) seem horribly
> wasteful to me...
> 
> Of course, to add a new format qualifier, we lose out on checking the format
> string by gcc... Nowadays, this role can be done by sparse.

But we don't run sparse on every build. We do run gcc (a lot).

> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -477,6 +478,8 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
>  			num = (unsigned short) va_arg(args, int);
>  			if (flags & SIGN)
>  				num = (signed short) num;
> +		} else if (qualifier == 'R' || qualifier == 'R') {
                                         ^                   ^
One of them must be lowercase `r'.

> +			num = va_arg(args, resource_size_t);
>  		} else {
>  			num = va_arg(args, unsigned int);
>  			if (flags & SIGN)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
