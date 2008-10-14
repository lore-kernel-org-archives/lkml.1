Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYJNTWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYJNTWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 15:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbYJNTW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 15:22:29 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:39392 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbYJNTW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 15:22:28 -0400
Date: Tue, 14 Oct 2008 21:22:18 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 06/18] m68k: Disable Amiga serial console support if
 modular
In-Reply-To: <alpine.LFD.2.00.0810141018590.3288@nehalem.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0810142118440.25759@anakin>
References: <20081013195846.674654386@mail.of.borg> <20081013195915.659336491@mail.of.borg>
 <alpine.LFD.2.00.0810141018590.3288@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

On Tue, 14 Oct 2008, Linus Torvalds wrote:
> On Mon, 13 Oct 2008, Geert Uytterhoeven wrote:
> > Apparently console_initcall() is not defined in the modular case.
> 
> We can certainly fix that. 
> 
> Does this make things work for you? If so, send it back with a sign-off 
> (add you can add mine too - but I'm not going to add it until it's tested)
> 
> 		Linus
> ---
>  include/linux/init.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/init.h b/include/linux/init.h
> index 93538b6..d9625b5 100644
> --- a/include/linux/init.h
> +++ b/include/linux/init.h
> @@ -273,6 +273,7 @@ void __init parse_early_param(void);
>  #else /* MODULE */
>  
>  /* Don't use these in modules, but some people do... */
> +#define console_initcall(fn)		module_init(fn)
>  #define core_initcall(fn)		module_init(fn)
>  #define postcore_initcall(fn)		module_init(fn)
>  #define arch_initcall(fn)		module_init(fn)

That won't help amiserial.c, as there's already a module_init() in that
file for the normal serial driver part.

But even if it would work, does it really make sense to have a modular
serial console driver?

  - If you have only one console driver, it would be registered and become
    your console when you load the module; but you wouldn't have had any
    console before it got loaded.
  - If you have several console drivers, you need a `console=' parameter
    anyway to control which one is used.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
