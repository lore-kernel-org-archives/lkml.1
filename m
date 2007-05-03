Return-Path: <linux-kernel-owner+w=401wt.eu-S1767693AbXECTG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767693AbXECTG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767704AbXECTG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:06:57 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:56370 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767693AbXECTGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:06:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h4yhuevPCMxkKvP3mbsCQjnIq8Ife3DD31rDGBabNpfQWrtXxK0mxxRFDbcUsWA2faToNPrFg9xWh9lImVSbaq6y6QI9RzJ5PUm4XcTv3zFK3acyuWH6O+43IHSknTvwQpxGw8+SugfXUGatHepFNQXmLoq+jtXYSIvyoNrAfm0=
Message-ID: <d120d5000705031206l2c675c22t5aab3eb648aa1cf8@mail.gmail.com>
Date: Thu, 3 May 2007 15:06:54 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Michael Schmitz" <schmitz@opal.biophys.uni-duesseldorf.de>
Subject: Re: [patch 04/33] m68k: Atari keyboard and mouse support.
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Michael Schmitz" <schmitz@debian.org>,
       "Roman Zippel" <zippel@linux-m68k.org>
In-Reply-To: <Pine.LNX.4.58.0705031832450.9408@xplor.biophys.uni-duesseldorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070501195052.390551603@mail.of.borg>
	 <20070501195129.842338339@mail.of.borg>
	 <d120d5000705011346h263bb5c4nb534692c11e7081b@mail.gmail.com>
	 <Pine.LNX.4.58.0705031832450.9408@xplor.biophys.uni-duesseldorf.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On 5/3/07, Michael Schmitz <schmitz@mail.biophys.uni-duesseldorf.de> wrote:
> >
> > > +
> > > +       if (!(atakbd_dev = input_allocate_device()))
> > > +               return -ENOMEM;
> > > +
> > > +       // need to init core driver if not already done so
> > > +       if (atari_keyb_init())
> >
> > Memory leak
>
> How so? If the core has been initialized already this will just return ...
>

You just allocated atakbd_dev. If atari_keyb_init() fails you leak it.

> > > +       for (i = 1; i < 0x72; i++) {
> > > +               atakbd_keycode[i] = i;
> > > +               set_bit(atakbd_keycode[i], atakbd_dev->keybit);
> >
> > It looks like this driver is not using standard input event codes. If
> > Roman does not want to adjust keymaps on Amiga and Atari that should
> > be handled in legacy keyboard driver (drivers/char/keyboard.c). As it
> > is programs using /dev/input/eventX have no chance of working.
>
> The translation map should not have been overwritten like above, is that
> what you mean?
> My original patch didn't have that bit; scancodes were translated to
> input keycodes using atakbd_keycode[scancode] instead. I'll have that
> reverted...
>

Does KEY_1 actually  maps to scancode 2 on atari?


Thanks,

-- 
Dmitry
