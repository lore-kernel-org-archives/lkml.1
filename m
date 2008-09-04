Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbYIDJwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbYIDJwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 05:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbYIDJwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 05:52:01 -0400
Received: from mail.rz.uni-duesseldorf.de ([134.99.128.30]:56021 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752133AbYIDJwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 05:52:00 -0400
Date: Thu, 04 Sep 2008 11:51:11 +0200 (CEST)
From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: [patch 6/8] m68k: Define rtc_lock on Atari
In-reply-to: <20080903071742.640740341@mail.of.borg>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <alpine.DEB.1.00.0809041150040.12258@zirkon.biophys.uni-duesseldorf.de>
MIME-version: 1.0
Content-type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Content-transfer-encoding: 7BIT
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
References: <20080903071542.615137611@mail.of.borg>
 <20080903071742.640740341@mail.of.borg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Acked as well ...

> The nvram and rtc-cmos drivers use the spinlock rtc_lock to protect against
> concurrent accesses to the CMOS memory. As m68k doesn't support SMP or preempt
> yet, the spinlock calls tend to get optimized away, but not for all
> configurations, causing in some rare cases:
>
> | ERROR: "rtc_lock" [drivers/rtc/rtc-cmos.ko] undefined!
> | ERROR: "rtc_lock" [drivers/char/nvram.ko] undefined!
>
> Add the spinlock to the Atari core code to avoid this.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Michael Schmitz <schmitz@debian.org>

> ---
> arch/m68k/atari/time.c |    3 +++
> 1 file changed, 3 insertions(+)
>
> --- a/arch/m68k/atari/time.c
> +++ b/arch/m68k/atari/time.c
> @@ -20,6 +20,9 @@
>
> #include <asm/atariints.h>
>
> +DEFINE_SPINLOCK(rtc_lock);
> +EXPORT_SYMBOL_GPL(rtc_lock);
> +
> void __init
> atari_sched_init(irq_handler_t timer_routine)
> {
>
> --
> Gr{oetje,eeting}s,
>
> 						Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-m68k" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
