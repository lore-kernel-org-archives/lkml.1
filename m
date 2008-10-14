Return-Path: <linux-kernel-owner+w=401wt.eu-S1761205AbYJNHby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761205AbYJNHby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 03:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758998AbYJNH3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 03:29:31 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:53340 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760054AbYJNH33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 03:29:29 -0400
Date: Tue, 14 Oct 2008 09:29:26 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Bolle <pebolle@tiscali.nl>
cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/18] m68k: Disable Amiga serial console support if
 modular
In-Reply-To: <1223932097.3619.51.camel@x41.thuisdomein>
Message-ID: <Pine.LNX.4.64.0810140928480.6220@anakin>
References: <20081013195846.674654386@mail.of.borg> <20081013195915.659336491@mail.of.borg>
 <1223932097.3619.51.camel@x41.thuisdomein>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008, Paul Bolle wrote:
> On Mon, 2008-10-13 at 21:58 +0200, Geert Uytterhoeven wrote:
> > Apparently console_initcall() is not defined in the modular case.
> 
> Yes, see include/linux/init.h:
> #ifndef MODULE
> [...]
> #define console_initcall(fn) \
>         static initcall_t __initcall_##fn \
>         __used __section(.con_initcall.init) = fn
> [...]
> 
> > Any better alternative fix?
> 
> Well, (a number of) other serial consoles cannot be selected if the
> corresponding serial driver is modular. Try:
> grep -B 2 -E "depends on .*=y" drivers/serial/Kconfig | \
>     grep -A 2 -E "^config .*CONSOLE"
> 
> For instance:
> config SERIAL_8250_CONSOLE
> 	bool "Console on 8250/16550 and compatible serial port"
> 	depends on SERIAL_8250=y

Yes, I saw those.

> Maybe this config entry (in arch/m68k/Kconfig) could be cleaned up (or
> split into multiple entries):
> config SERIAL_CONSOLE
>         bool "Support for serial port console"
>         depends on (AMIGA || ATARI || MAC || SUN3 || SUN3X || VME ||
> APOLLO) && (ATARI_MFPSER=y || ATARI_MIDI=y || MAC_SCC=y ||
> AMIGA_BUILTIN_SERIAL=y || GVPIOEXT=y || MULTIFACE_III_TTY=y || SERIAL=y
> || MVME147_SCC || SERIAL167 || MVME162_SCC || BVME6000_SCC || DN_SERIAL)
> [...]
> 
> That "depends on" line seems likely to lead to problems like the one you
> ran into. But your patch (which I didn't test) is probably simpler.

Adding all those extra config symbols seems like a bit overkill to me...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
