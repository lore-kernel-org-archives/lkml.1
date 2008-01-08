Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbYAHTZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbYAHTZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbYAHTZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:25:24 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:47998 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbYAHTZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:25:22 -0500
Date: Tue, 8 Jan 2008 20:25:19 +0100
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
Message-ID: <20080108202519.1057cb75@cw05linux>
In-Reply-To: <4783C4A6.9060402@reed.com>
References: <9BdU5-1YW-9@gated-at.bofh.it>
	<200801081810.58904.linux@rainbow-software.org>
	<4783B1B2.6070005@reed.com>
	<200801081838.16241.linux@rainbow-software.org>
	<4783C4A6.9060402@reed.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jan 2008 13:44:54 -0500
"David P. Reed" <dpreed@reed.com> wrote:

> Ondrej Zary wrote:
> > On Tuesday 08 January 2008 18:24:02 David P. Reed wrote:
> >   
> >> Windows these days does delays with timing loops or the
> >> scheduler.  It doesn't use a "port".  Also, Windows XP only
> >> supports machines that tend not to have timing problems that use
> >> delays.  Instead, if a device takes a while to respond, it has a
> >> "busy bit" in some port or memory slot that can be tested.
> >>     
> There is no need to use io writes to supposedly/theoretically "unused 
> ports" to make drivers work on any bus.
> ISA included!  You can, for example, wait for an ISA bus serial
> adapter to put out its next character by looping reading the port
> that has the output buffer full flag in a tight loop, with no delay
> code at all.  And if you need to time things, just call a timing loop
> subroutine that you calibrate at boot time.

Now you're totally confusing things.  You're talking about looking at
bits in a register to see if a transmit register is empty.  
That's easy.

The delays needed for the Intel M8259 and M8253 say that you're not
even allowed to access the registers _at_ _all_ for some time after a
register access.  If you do a write to a register immediately followed
by any access, including a read of the status register, you can corrupt
the state of the chip.

And the Intel chips are not the only ones with that kind of brain
damage.  But what makes the 8259 and 8253 a big problem is that every
modern PC has a descendant of those chips in them.  The discrete Intel
chips or clones got aggregated into Super I/O chips, and the Super I/O
chips were put on a LPC bus (an ISA bus with another name) or
integrated into the southbrige.  And the "if it ain't broken, don't fix
it" mantra probably means that some modern chipsets are still using
exactly the same internal design as the 25 year old chips and will
still be subject to some of those ancient limitations.

  /Christer
