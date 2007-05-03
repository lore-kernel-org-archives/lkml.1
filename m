Return-Path: <linux-kernel-owner+w=401wt.eu-S1767741AbXECTRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767741AbXECTRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767742AbXECTRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:17:39 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:47135 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767741AbXECTRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:17:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WbaF6K8Czk9PLoYO7VbB7uAozgW3+c6bvMlIJv8csaLR3Ed82MniULSM+AGknCZANipNViKshYiCBKlqv3xdsG4yswAXLCZQW9RlKAdJbYnV7RtfHOclJl8uXPsluFVLhOP9yL6v1ALLmc789epZ3N4kpzjCxm+oHB0FEqZcEVU=
Message-ID: <d120d5000705031217h64db0644qb1e8bc8d8af6e78c@mail.gmail.com>
Date: Thu, 3 May 2007 15:17:32 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: [patch 04/33] m68k: Atari keyboard and mouse support.
Cc: "Michael Schmitz" <schmitz@opal.biophys.uni-duesseldorf.de>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Michael Schmitz" <schmitz@debian.org>
In-Reply-To: <Pine.LNX.4.64.0705031917150.2956@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070501195052.390551603@mail.of.borg>
	 <20070501195129.842338339@mail.of.borg>
	 <d120d5000705011346h263bb5c4nb534692c11e7081b@mail.gmail.com>
	 <Pine.LNX.4.58.0705031832450.9408@xplor.biophys.uni-duesseldorf.de>
	 <Pine.LNX.4.64.0705031917150.2956@scrub.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman,

On 5/3/07, Roman Zippel <zippel@linux-m68k.org> wrote:
> Hi,
>
> On Thu, 3 May 2007, Michael Schmitz wrote:
>
> > > > +       for (i = 1; i < 0x72; i++) {
> > > > +               atakbd_keycode[i] = i;
> > > > +               set_bit(atakbd_keycode[i], atakbd_dev->keybit);
> > >
> > > It looks like this driver is not using standard input event codes.
>
> Actually it does, it just sort of works because Atari generates mostly
> AT keycodes.
>

But not the input core codes, does it?

> > > If
> > > Roman does not want to adjust keymaps on Amiga and Atari that should
> > > be handled in legacy keyboard driver (drivers/char/keyboard.c). As it
> > > is programs using /dev/input/eventX have no chance of working.
>
> I explained already at a earlier occasion, why this "generic" keycode
> thing is broken by design, which makes connecting multiple keyboards with
> different mappings impossible.
>

No, I don't think so. Your points were:

1) You did not want to adjust your legacy keymap on Amiga
2) You want userspace programs to know how to program scancodes for
every type of keyboard and have different keymaps for different type
of keyboards (So you need to have n_kbd_types *
n_international_mappings keymaps).

Answering 1) I sent you once a patch for review that would have amikbd
send raw scancode events in additional to standard input events and
drivers/char/keyboard.c pick these raw events on amiga so both legacy
driver and evdev could work, but I never heard from you.

As far as 2) goes I think it is better to have unified keyboard map
across different types of keyboards and then overlay
internatinalization/other settings. And you still have per-keyboard
configurability as you can change scancode->keycode mapping on a
per-device basis via evdev ioctl.

-- 
Dmitry
