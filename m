Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbXEDK0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbXEDK0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 06:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbXEDK0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 06:26:13 -0400
Received: from opal.biophys.uni-duesseldorf.de ([134.99.176.7]:51551 "EHLO
	opal.biophys.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993188AbXEDK0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 06:26:11 -0400
Date: Fri, 4 May 2007 12:25:53 +0200 (CEST)
From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Michael Schmitz <schmitz@debian.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 04/33] m68k: Atari keyboard and mouse support.
In-Reply-To: <d120d5000705031206l2c675c22t5aab3eb648aa1cf8@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0705041222080.13799@xplor.biophys.uni-duesseldorf.de>
References: <20070501195052.390551603@mail.of.borg>  <20070501195129.842338339@mail.of.borg>
  <d120d5000705011346h263bb5c4nb534692c11e7081b@mail.gmail.com> 
 <Pine.LNX.4.58.0705031832450.9408@xplor.biophys.uni-duesseldorf.de>
 <d120d5000705031206l2c675c22t5aab3eb648aa1cf8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > +       // need to init core driver if not already done so
> > > > +       if (atari_keyb_init())
> > >
> > > Memory leak
> >
> > How so? If the core has been initialized already this will just return ...
> >
>
> You just allocated atakbd_dev. If atari_keyb_init() fails you leak it.

I see. Won't probably happen, but there's no reason to take a risk.

> > > It looks like this driver is not using standard input event codes. If
> > > Roman does not want to adjust keymaps on Amiga and Atari that should
> > > be handled in legacy keyboard driver (drivers/char/keyboard.c). As it
> > > is programs using /dev/input/eventX have no chance of working.
> >
> > The translation map should not have been overwritten like above, is that
> > what you mean?
> > My original patch didn't have that bit; scancodes were translated to
> > input keycodes using atakbd_keycode[scancode] instead. I'll have that
> > reverted...
> >
>
> Does KEY_1 actually  maps to scancode 2 on atari?

It sure does. For most of the keys, the identity mapping is in fact OK.
There's a lot of keys where this breaks, though. Plus the notorious
scancode 0 :-)

	Michael
