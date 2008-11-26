Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbYKZMJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbYKZMJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 07:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYKZMJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 07:09:04 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:54870 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYKZMJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 07:09:01 -0500
Date: Wed, 26 Nov 2008 13:08:57 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-fbdev-devel@lists.sourceforge.net,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Ben Gardner <bgardner@wabtec.com>, Eric Miao <eric.miao@marvell.com>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [Linux-fbdev-devel] [RFC 2.6.27 1/1] gpiolib: add support for
 batch set of pins
In-Reply-To: <45a44e480811260225k5dc2bedal41ccac33626f3b4c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0811261306260.2632@anakin>
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com>
 <492D125D.5010607@teltonika.lt> <45a44e480811260118v440716bbqa8d37c8b696c148a@mail.gmail.com>
 <Pine.LNX.4.64.0811261106180.2632@anakin> <45a44e480811260225k5dc2bedal41ccac33626f3b4c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, Jaya Kumar wrote:
> On Wed, Nov 26, 2008 at 5:08 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > On Wed, 26 Nov 2008, Jaya Kumar wrote:
> >> On Wed, Nov 26, 2008 at 4:09 AM, Paulius Zaleckas
> >> <paulius.zaleckas@teltonika.lt> wrote:
> >> > Jaya Kumar wrote:
> >> >>   * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
> >> >>   *   implementation may not sleep
> >> >>   * @dbg_show: optional routine to show contents in debugfs; default code
> >> >> @@ -84,6 +86,9 @@ struct gpio_chip {
> >> >>                                               unsigned offset, int value);
> >> >>       void                    (*set)(struct gpio_chip *chip,
> >> >>                                               unsigned offset, int value);
> >> >> +     void                    (*set_bus)(struct gpio_chip *chip,
> >> >> +                                             unsigned offset, int values,
> >> >
> >> > I think values should be unsigned
> >>
> >> Okay, can do but it is unusual no? since set uses int value, i figured
> >> set_bus should be similar right?
> >
> > ->set() sets one pin, right? So it's either 0 or 1.
> >
> > ->set_bus() sets multiple pins. With `int', it will fail for bit 31, as that's
> > the sign bit.
> 
> I'm not sure I understood this. I imagine the usage will be like
> 
> int values = 0x8000_0000;
> set_bus(..., start_pin, values);
> 
> write_32(register, values); // will still work to set bit 31

Tehcnically, it will work. But it's more confusing if it's int.

> (values >> 31) == 1;

However, be careful with shifts, as right shifts on signed values will
duplicate te sign bit.

> > Perhaps you even want u32, to make it clear what's the maximum number of pins
> > you can set in one shot?
> 
> Yes, I agree, I will change to use u32 as it is then explicit.

OK. Thx!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
