Return-Path: <linux-kernel-owner+w=401wt.eu-S936055AbXGUI2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936055AbXGUI2Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 04:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761729AbXGUI1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 04:27:54 -0400
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:42755 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937419AbXGUI1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 04:27:50 -0400
Date: Sat, 21 Jul 2007 10:27:47 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz, linuxppc-dev@ozlabs.org
Subject: Re: [patch 1/3] m68k/mac: Make mac_hid_mouse_emulate_buttons()
 declaration visible
In-Reply-To: <d120d5000707201151q433f1f3eteb479109291a54bd@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707211026070.18493@anakin>
References: <20070720164043.523003359@mail.of.borg> <20070720164323.625963918@mail.of.borg>
 <d120d5000707201047y2d22167co882a10176d79fce4@mail.gmail.com>
 <20070720183503.GC3801@stusta.de> <d120d5000707201151q433f1f3eteb479109291a54bd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007, Dmitry Torokhov wrote:
> On 7/20/07, Adrian Bunk <bunk@stusta.de> wrote:
> > On Fri, Jul 20, 2007 at 01:47:36PM -0400, Dmitry Torokhov wrote:
> > > On 7/20/07, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > >> From: Geert Uytterhoeven <geert@linux-m68k.org>
> > >>
> > >> m68k/mac: Make mac_hid_mouse_emulate_buttons() declaration visible
> > >>
> > >> drivers/char/keyboard.c: In function 'kbd_keycode':
> > >> drivers/char/keyboard.c:1142: error: implicit declaration of function
> > >> 'mac_hid_mouse_emulate_buttons'
> > >>
> > >> The forward declaration of mac_hid_mouse_emulate_buttons() is not visible
> > >> on
> > >> m68k because it's hidden in the middle of a big #ifdef block.
> > >>
> > >> Move it to <linux/hid.h>, correct the type of the second parameter, and
> > >> include <linux/hid.h> where needed.
> > >
> > > linux/hid.h contains definitions needed for drivers speaking HID
> > > protocol, I don't think we want to put quirks for legacy keyboard
> > > driver there. I'd just move the #ifdef within drivers/char/keyboard.c
> > > for now.
> > >...
> > 
> > If you only move it you will keep the bug of the wrong second parameter.
> > 
> > But if you move it to any header file gcc is able to figure out such
> > errors itself instead of them being nasty runtime errors.
> > 
> > Such prototypes in C files are really bad since (like in this case) they
> > prevent the finding of bugs. It doesn't matter which header file you put
> > the prototype into (it can even be a new one), but it belongs into a
> > header file.
> > 
> 
> I am OK with adding a new header file. I was just saying that placing
> that declaration in linux/hid.h makes about the same sense as putting
> it into linux/scsi.h

At first I just wanted to move it. Then I thought about the angry
comments I would get about not moving it to a header file ;-)

<linux/hid.h> looked like the best candidate. <linux/kbd_kern.h> is
another option.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
