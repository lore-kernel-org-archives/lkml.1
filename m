Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbZEDHLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbZEDHLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 03:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbZEDHLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 03:11:35 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:47836 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbZEDHLe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 03:11:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Drv0mFpR+Fods6jRjbEWgT5lPpltx5/vWWdt/1te479YWEssoGfp8lDF7oqo/6ZadJ
         LOzk7FF+0IiSudomky5QoxxzfhYam/gqbPNph102CBtSIBi661J9PRZWb+eSNpgO7E9R
         8KOC3SUz3ARO/aRZ8d/BfAdwAdCIhOMPLJrAQ=
MIME-Version: 1.0
In-Reply-To: <821a570574a4dadc0c0c838f90f41dd5df81f090.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
	 <821a570574a4dadc0c0c838f90f41dd5df81f090.1241105648.git.arnd@arndb.de>
Date: Mon, 4 May 2009 09:11:33 +0200
X-Google-Sender-Auth: e831f3287d361c87
Message-ID: <10f740e80905040011u57e17420w9df8758f87027328@mail.gmail.com>
Subject: Re: [PATCH 11/27] asm-generic: add generic page.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 16:55, Arnd Bergmann <arnd@arndb.de> wrote:
> Architectures that have no mmu should not have to
> describe their page tables. This adds a new page.h
> file based on the existing nommu architectures
> that adds a lot of dummy definitions to let you
> correctly compile a nommu kernel.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/asm-generic/page.h |   99 ++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 99 insertions(+), 0 deletions(-)
>  create mode 100644 include/asm-generic/page.h
>
> diff --git a/include/asm-generic/page.h b/include/asm-generic/page.h
> new file mode 100644
> index 0000000..75fec18
> --- /dev/null
> +++ b/include/asm-generic/page.h
> @@ -0,0 +1,99 @@
> +#ifndef __ASM_GENERIC_PAGE_H
> +#define __ASM_GENERIC_PAGE_H
> +/*
> + * Generic page.h implementation, for NOMMU architectures.
> + * This provides the dummy definitions for the memory management.
> + */
> +
> +#ifdef CONFIG_MMU
> +#error need to prove a real asm/page.h
> +#endif
> +
> +
> +/* PAGE_SHIFT determines the page size */
> +
> +#define PAGE_SHIFT     12
> +#ifdef __ASSEMBLY__
> +#define PAGE_SIZE      (1 << PAGE_SHIFT)
> +#else
> +#define PAGE_SIZE      (1UL << PAGE_SHIFT)
> +#endif

#include <linux/const.h> and use (_AC(1, UL) << PAGE_SHIFT)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
