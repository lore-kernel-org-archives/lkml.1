Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbZLWTUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbZLWTUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZLWTUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:20:40 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44447 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbZLWTUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:20:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KwfX+t6Kt6MnJEYve8mPadV2eDr5nzg14TLQ3VqgFUkNOWFEZj7nj4uqrnAttZmkJO
         XeeRncgLwmnVqNiaFaBZs3BU72IMjK41RaEwsNJbGXdDu9D1o8anMvCwz4RJtGFmBmpd
         rDctS7Iqq9J5R5mEIHZ78FYOrTMbnwH5P7Uxw=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0908021047280.15557@ask.diku.dk>
References: <Pine.LNX.4.64.0908021047280.15557@ask.diku.dk>
Date: Wed, 23 Dec 2009 20:20:37 +0100
X-Google-Sender-Auth: 37ada2ba8acdede7
Message-ID: <10f740e80912231120r363c4e0cg9b10053788fc16d9@mail.gmail.com>
Subject: Re: [PATCH 9/15] arch/m68k: Use DIV_ROUND_CLOSEST
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Julia Lawall <julia@diku.dk>
Cc: zippel@linux-m68k.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 2, 2009 at 09:47, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
> but is perhaps more readable.

Thanks, applied.

> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
>
> // <smpl>
> @haskernel@
> @@
>
> #include <linux/kernel.h>
>
> @depends on haskernel@
> expression x,__divisor;
> @@
>
> - (((x) + ((__divisor) / 2)) / (__divisor))
> + DIV_ROUND_CLOSEST(x,__divisor)
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
>
> ---
>  arch/m68k/amiga/config.c            |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
> index 6e56275..002b9b0 100644
> --- a/arch/m68k/amiga/config.c
> +++ b/arch/m68k/amiga/config.c
> @@ -480,7 +480,7 @@ static void __init amiga_sched_init(irq_handler_t timer_routine)
>        static struct resource sched_res = {
>                .name = "timer", .start = 0x00bfd400, .end = 0x00bfd5ff,
>        };
> -       jiffy_ticks = (amiga_eclock+HZ/2)/HZ;
> +       jiffy_ticks = DIV_ROUND_CLOSEST(amiga_eclock, HZ);
>
>        if (request_resource(&mb_resources._ciab, &sched_res))
>                printk("Cannot allocate ciab.ta{lo,hi}\n");
>



-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
