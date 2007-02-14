Return-Path: <linux-kernel-owner+w=401wt.eu-S932466AbXBNTPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbXBNTPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932470AbXBNTPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:15:32 -0500
Received: from fmx03.freemail.hu ([195.228.245.53]:37158 "HELO
	fmx03.freemail.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932468AbXBNTPb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:15:31 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Feb 2007 14:15:31 EST
Date: Wed, 14 Feb 2007 20:06:35 +0100 (CET)
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Subject: Re: [PATCH] input: extend EV_LED
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
In-Reply-To: <d120d5000702121031o1ea5ff20lf4e0946c8c1e2980@mail.gmail.com>
Message-ID: <freemail.20070114200635.96983@fm13.freemail.hu>
X-Originating-IP: [80.98.105.91]
X-HTTP-User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; hu-HU; rv:1.8.0.6) Gecko/20060729 SeaMonkey/1.0.4
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2
Content-Transfer-Encoding: 8BIT
X-Freemail: message scanned
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Dmitry Torokhov <dmitry.torokhov@gmail.com> írta:

> On 2/11/07, Németh Márton <nm127@freemail.hu> wrote:
> >
> > Extend EV_LED handling code so that it can handle not
> > only two states (on/off) but also others. For example
> > a LED can blink using hardware acceleration. The code
> > changed so that it is similar to the code at EV_SND.
> >
> 
> Hi,
> 
> I am not sure we would need this, could you explain what
are you
> trying to use input leds for?
> 
> Generally speaking leds within input subsystem are
supposed to be very
> simple on/off objects, mostly for reporting state of input
devices
> (keyboards), I am not even sure that LED_MAIL and
LED_CHARGING make
> much sense here. For more compex objects(blinking/different
> colors/different brightness) we have a separate LED subsystem
> (drivers/leds).

The background is that I own a Clevo notebook model D4J,
product D410J which has a mail led near to the other LEDs.
The mail LED in question has three known state: off, blink
slow (0.5Hz), and blink fast (1Hz).

The mail LED can be programmed through the ports 0x60 and
0x64. These ports belog to the i8042 controller, which is
operated by the input subsystem. To be able to access the
i8042 controller correctly, I need the spinlock i8042_lock
held, which is defined as static in
linux/drivers/input/serio/i8042.c .

What I miss currently from the input subsystem is that the
EV_LED can only handle on/off state.

I do not know the LED subsystem in detail, but I do not know
any possibility to access the i8042 from different subsystem
than the input subsystem.

What do you think and recommend?

        NMarci

P.S.: my project home page is located at
http://clevo-mailled.sourceforge.net/





______________________________________________________________________
Könyvszerda a Gabo, Akkord, Talentum, Ciceró Kiadókkal! 
Több mint 700 féle könyv 30% kedvezménnyel! 
http://www.bookline.hu/control/news?newsid=397&affiliate=frekszkar3435

