Return-Path: <linux-kernel-owner+w=401wt.eu-S932509AbXBNTtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbXBNTtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932510AbXBNTtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:49:49 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:19630 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbXBNTts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:49:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Lldk13IrnmSF0R7z8HaLG9gHlFQBnvDqAUdNIvni5nX8OpAuxXpvkGgfEUEqwcpFZJhKXopdpaA9kXIN/kgH1f3GVvzikwLyF+azwP1clXEiN2Hgpatdu9N/5+l8bpGrefS0/ZSdFs5tadodTMeWR/lRnvl9pA9br9QQqzeaINM=
Message-ID: <d120d5000702141149g772840e7h87e4362b3f380bc0@mail.gmail.com>
Date: Wed, 14 Feb 2007 14:49:46 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "=?ISO-8859-1?Q?N=E9meth_M=E1rton?=" <nm127@freemail.hu>
Subject: Re: [PATCH] input: extend EV_LED
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
In-Reply-To: <freemail.20070114200635.96983@fm13.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <d120d5000702121031o1ea5ff20lf4e0946c8c1e2980@mail.gmail.com>
	 <freemail.20070114200635.96983@fm13.freemail.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/14/07, Németh Márton <nm127@freemail.hu> wrote:
>
>
> Dmitry Torokhov <dmitry.torokhov@gmail.com> írta:
>
> > On 2/11/07, Németh Márton <nm127@freemail.hu> wrote:
> > >
> > > Extend EV_LED handling code so that it can handle not
> > > only two states (on/off) but also others. For example
> > > a LED can blink using hardware acceleration. The code
> > > changed so that it is similar to the code at EV_SND.
> > >
> >
> > Hi,
> >
> > I am not sure we would need this, could you explain what
> are you
> > trying to use input leds for?
> >
> > Generally speaking leds within input subsystem are
> supposed to be very
> > simple on/off objects, mostly for reporting state of input
> devices
> > (keyboards), I am not even sure that LED_MAIL and
> LED_CHARGING make
> > much sense here. For more compex objects(blinking/different
> > colors/different brightness) we have a separate LED subsystem
> > (drivers/leds).
>
> The background is that I own a Clevo notebook model D4J,
> product D410J which has a mail led near to the other LEDs.
> The mail LED in question has three known state: off, blink
> slow (0.5Hz), and blink fast (1Hz).
>
> The mail LED can be programmed through the ports 0x60 and
> 0x64. These ports belog to the i8042 controller, which is
> operated by the input subsystem. To be able to access the
> i8042 controller correctly, I need the spinlock i8042_lock
> held, which is defined as static in
> linux/drivers/input/serio/i8042.c .
>
> What I miss currently from the input subsystem is that the
> EV_LED can only handle on/off state.
>
> I do not know the LED subsystem in detail, but I do not know
> any possibility to access the i8042 from different subsystem
> than the input subsystem.
>
> What do you think and recommend?
>

I think you need to use leds framework for what you are trying to do.
I could export i8042_command() so you could access keyboard controller
from your driver.

-- 
Dmitry
