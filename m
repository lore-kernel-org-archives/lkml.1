Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYAHVoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYAHVoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:44:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYAHVnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:43:53 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:46450 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbYAHVnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:43:52 -0500
Date: Tue, 8 Jan 2008 22:43:51 +0100
From: Christer Weinigel <christer@weinigel.se>
To: "David P. Reed" <dpreed@reed.com>
Cc: Ondrej Zary <linux@rainbow-software.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
Message-ID: <20080108224351.3a6a4016@weinigel.se>
In-Reply-To: <4783DCD3.8010201@reed.com>
References: <9BdU5-1YW-9@gated-at.bofh.it>
	<200801081810.58904.linux@rainbow-software.org>
	<4783B1B2.6070005@reed.com>
	<200801081838.16241.linux@rainbow-software.org>
	<4783C4A6.9060402@reed.com>
	<20080108202519.1057cb75@cw05linux>
	<4783DCD3.8010201@reed.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jan 2008 15:28:03 -0500
"David P. Reed" <dpreed@reed.com> wrote:

> Register compatible.  Not  the same chips or even the same  masks or 
> timing requirements.

No, but somehow people keep making similar mistakes.  The DEC HiNote
needed outb_p to function correctly?  That was definitely a much more
modern design than the original PC and most probably did not use any
discrete Intel chips, but the same timing problems were there.  I belive
that problem had to do with the keyboard controller though.

> > The discrete Intel
> > chips or clones got aggregated into Super I/O chips, and the Super
> > I/O chips were put on a LPC bus (an ISA bus with another name) or
> > integrated into the southbrige.
> Don't try to teach your grandmother to suck eggs: I've been
> programming PC compatibles since probably before you were able to do
> long division - including writing code on the first prototype IBM
> PCs, the first pre-manufacturing PC-ATs, and zillions of clones.
> (and I was also involved in designing hardware including the
> so-called "Lotus Intel" expanded memory cards and the original PC
> cards)  

Argument by personal authority.  Thats good.  I guess that's why you
don't seem to understand the difference between reading the serial port
status register and not being allowed to access a register at all
due to such this as the 4 cycle delay you quoted yourself from the 8390
data sheet, and similar issues with the I8253 that I quoted from its
data sheet a few posts ago.

> The 8259 PIC is an *interrupt controller*. It was NEVER
> present in a Super I/O chip, or an LPC chip.  Its functionality was
> absorbed into the chipsets that control interrupt mapping, like the
> PIIX and the nForce. 

Yup, sorry about that, it got integrated into some other chip instead.
I was thinking of another timer, the RTC which is usually a part of the
Super I/O. And which is yet another troublesome area since apparently a
lot of chipsets have problems with it.  But the sequence is the same,
discrete chips get aggregated into larger chips. Sometimes the
sometimes old macrocells are reused, sometimes they are redesigned from
scratch (and new bugs are introduced).

> > And the "if it ain't broken, don't fix
> > it" mantra probably means that some modern chipsets are still using
> > exactly the same internal design as the 25 year old chips and will
> > still be subject to some of those ancient limitations.
> >   
> Oh, come on.  Give the VLSI designers some credit for brains.   The
> CAD tools used to design the 8259 and 8253 were so primitive you
> couldn't even get a chip manufactured with designs from that era
> today.  When people design chips today they do it with simulators
> that can't even work, and testers that run from test suites that were
> not available at the time.

And they still keep making the same mistakes...  Registers that require
wait states before being read again, register that assume that there
are going to be some spare cycles between each access so that some
internal logic has time to update, registers that would have needed a
one byte FIFO to avoid DMA overruns (I'd almost forgotten about that
specific bug on SPI controller of the Samsung 2410, but it bit me last
week and I only managed to chase it down properly yesterday), and so on.

I'm quite impressed with what some VLSI designers manage to do.  I just
saw a company roll out a completely new ARM9 design with lots of fun
stuff and as far as I know they only made one single mistake on that
chip.  On the other hand, on other designs you can see how the same old
macrocell has been reused long past the "best before" date, because
some bugs crop up over and over again.  

  /Christer
