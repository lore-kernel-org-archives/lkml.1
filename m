Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYAHWZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYAHWZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:25:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYAHWYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:24:52 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:64185 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbYAHWYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:24:50 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Iw1NqU+3naZdgCD13kWL4
Message-ID: <4783F80C.4020903@reed.com>
Date: Tue, 08 Jan 2008 17:24:12 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Christer Weinigel <christer@weinigel.se>
CC: Ondrej Zary <linux@rainbow-software.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it>	<200801081810.58904.linux@rainbow-software.org>	<4783B1B2.6070005@reed.com>	<200801081838.16241.linux@rainbow-software.org>	<4783C4A6.9060402@reed.com>	<20080108202519.1057cb75@cw05linux>	<4783DCD3.8010201@reed.com> <20080108224351.3a6a4016@weinigel.se>
In-Reply-To: <20080108224351.3a6a4016@weinigel.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christer Weinigel wrote:
> Argument by personal authority.  Thats good.
There is no other kind of argument.  Are you claiming supernatural 
authority drives your typing fingers, or is your argument based on what 
you think you know?  I have piles of code that I wrote, spec sheets (now 
that I'm back in my home office), code that others wrote at the time, 
and documentation from vendors that come from my personal experiences.  
That doesn't mean I'm always right - always happy to learn something 
new.  Just don't condescend to a 55 year old who has been writing 
operating systems, compilers, and designing hardware for almost 40 years 
professionally (yes, I got my first job at 16 writing FORTRAN code to 
simulate hydrodynamic systems).
> I guess that's why you
> don't seem to understand the difference between reading the serial port
> status register and not being allowed to access a register at all
> due to such this as the 4 cycle delay you quoted yourself from the 8390
> data sheet,
If you read what I said carefully, I said that the 8390 was a very 
special case.   The "chip select" problem it experienced was pretty much 
unique among boards of the time.  Those of us who looked at its design 
and had any experience designing hardware for buses like the unibus or 
even the buses on PDP-8's and DG machines thought it had to be a joke.  
Of course it saved money per board, so it beat the 3Com boards on price 
- and you could program it after a fashion.  So it involved "cheaping out".

The normal timing problem was that an out or in operation to a board or 
chip required some time to elapse before the chip performed the side 
effects internally so that the next operation to it would have an 
effect.  This is exactly the reason why most chips and boards are 
designed to either have a polling of a flag indicate operation 
completion.  The serial "buffer empty" flag is the simplest possible 
explanatory example of such handshaking that came to mind (writing a 
character to a serial output device twice often leads to surprises, 
unless you wait for the previous character to clock out).  See my 
comment on RTC below, for a more complex to explain example.
> and similar issues with the I8253 that I quoted from its
> data sheet a few posts ago.
>
>   
The 8253 was a motherboard chip.  I am not sure it had any timing 
problems with its electrical signalling.  I just don't remember.  The 
spec sheet doesn't say it's internal state can get scrambled.
>
> I was thinking of another timer, the RTC which is usually a part of the
> Super I/O.
The RTC has very well documented timing requirements.  But none of the 
spec sheets, nor my experience with it, mention electrical issues that 
prevented back-to-back port operations.  The documented timing 
requirements have to do with the state during the time it ticks over 
internally once per second.  But it is carefully designed to have a flag 
that is "on" during 244 microseconds prior to and covering the time it 
is unsafe to read the registers.   That design is special because it is 
designed to operate when the machine is powered off, so it has two 
internal clock domains, one of which is used in "low power" mode and is 
very slow to minimize power.

