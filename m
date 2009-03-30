Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbZC3Olm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbZC3Olm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbZC3Olc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:41:32 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:43733 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZC3Ola (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:41:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EvZ8yHffu8Ko2edetpv0T0EnJtTtDCM07983x9DIc7kMqMs5SEKDMsx95LWnhCk0Nd
         B9jpBADqQxDLa5hhq3AZOeENWCSnNw89VIZ89Ca1EpufDTGdH1elIBleDEYtxKXc//ww
         NyqHNBX3fyeOU1arRBJjFsGZFJSiggOm9CHfo=
MIME-Version: 1.0
In-Reply-To: <200903301558.10598.arnd@arndb.de>
References: <49D071A8.4010703@petalogix.com> <200903301558.10598.arnd@arndb.de>
Date: Mon, 30 Mar 2009 16:41:27 +0200
Message-ID: <10f740e80903300741h387e6342veba0ccceea6714e9@mail.gmail.com>
Subject: Re: Removing __kernel_old_uid_t, git_t, dev_t
From: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: michal.simek@petalogix.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 15:58, Arnd Bergmann <arnd@arndb.de> wrote:
> diff --git a/include/asm-generic/types.h b/include/asm-generic/types.h
> new file mode 100644
> index 0000000..5841716
> --- /dev/null
> +++ b/include/asm-generic/types.h
> @@ -0,0 +1,56 @@
> +#ifndef __ASM_GENERIC_TYPES_H
> +#define __ASM_GENERIC_TYPES_H
> +
> +/*
> + * int-ll64 is used on all 32 bit architectures and on x86-64,
> + * so use it as a reasonable default.
> + */
> +#include <asm-generic/int-ll64.h>
> +

Most 64-bit archs have been migrated to ll64 by now.
Alpha, ia64, and mips64 are the remaining exceptions.

> +/*
> + * DMA addresses may be larger than pointers, but not smaller.
> + * Do not define the dma64_addr_t type, which never really
> + * worked.
> + */
> +#if defined(CONFIG_64BIT) || defined(CONFIG_PHYS_64BIT)
> +typedef u64 dma_addr_t;
> +#else
> +typedef u32 dma_addr_t;
> +#endif /* 64 bit DMA pointer */

Is there any specific reason why dma_addr_t is in <asm/types.h>, while
phys_addr_t is in
<linux/types.h>?

Furthermore, CONFIG_PHYS_64BIT is used on PPC only. Probably it should be
replaced by CONFIG_PHYS_ADDR_T_64BIT, which is always set if CONFIG_64BIT,
so the #ifdef above becomes even simpler?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
