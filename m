Return-Path: <linux-kernel-owner+w=401wt.eu-S1761294AbYARNhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294AbYARNhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080AbYARNg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:36:57 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:41938 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491AbYARNg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:36:56 -0500
Message-ID: <4790AB82.1010404@davidnewall.com>
Date: Sat, 19 Jan 2008 00:07:06 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       David Woodhouse <dwmw2@infradead.org>, Zachary Amsden <zach@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christer Weinigel <christer@weinigel.se>,
       Ondrej Zary <linux@rainbow-software.org>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol <rol@witbe.net>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it>	<4783B1B2.6070005@reed.com>	<200801081838.16241.linux@rainbow-software.org>	<4783C4A6.9060402@reed.com>	<20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>	<4783CBD9.7020709@reed.com>	<1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>	<47845972.9090803@zytor.com>	<1199915614.7369.367.camel@bodhitayantram.eng.vmware.com>	<47854916.4080703@reed.com>	<1200015388.6192.22.camel@bodhitayantram.eng.vmware.com>	<4786DD05.20804@keyaccess.nl>	<47877ECD.9060408@reed.com>	<1200347847.2647.97.camel@shinybook.infradead.org>	<478BE08B.3090306@reed.com>	<478E1668.9040404@davidnewall.com>	<20080116145515.6d84dc7b@lxorguk.ukuu.org.uk>	<478E57C8.2080403@davidnewall.com>	<20080116200829.26040351@lxorguk.ukuu.org.uk>	<478EF4C9.8030406@davidnewall.com> <20080117120227.3d09baf5@lxorguk.ukuu.org.uk> <478F59CC.8050907@davidnewall.com> <478F5E47.6000204@keyaccess.nl> <478FCF99.4060505@davidnewall.com> <478FD31E.5090104@keyaccess.nl>
In-Reply-To: <478FD31E.5090104@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene,

Here is why you shouldn't leap so quickly to rudeness.  Everything is
being repeated over and over and over again (as you put it) because
people like you shout down people like me without making any apparent
effort to understand the truth of the problem.


Rene Herman wrote:
> We've already talked about ISA bus speed, and how it's not in a sane
> sense portably determinable, we've already talked about kernel
> parameters, about udelay and it's usefulness in early boot, about how
> your rude "Junk I/O" is exactly what is needed for some ISA devices
> and so on...

The problem is that _p is widely used for non-ISA devices.  For example,
a quick grep reveals the following (and more) all use outb_p:

    ./i2c/busses/i2c-amd756.c
    ./i2c/busses/i2c-ali1535.c
    ./i2c/busses/i2c-ali15x3.c
    ./i2c/busses/i2c-i801.c
    ./i2c/busses/i2c-piix4.c
    ./i2c/busses/i2c-viapro.c
    ./i2c/busses/i2c-nforce2.c
    ./i2c/busses/i2c-ali1563.c
    ./telephony/ixj.c
    ./char/pc8736x_gpio.c
    ./char/epca.c
    ./char/dtlk.c
    ./char/watchdog/w83697hf_wdt.c
    ./char/watchdog/wafer5823wdt.c
    ./char/watchdog/wdt.c
    ./char/watchdog/sc1200wdt.c
    ./char/watchdog/pc87413_wdt.c
    ./char/watchdog/wdt_pci.c
    ./char/watchdog/w83977f_wdt.c
    ./char/watchdog/pcwd_pci.c
    ./char/watchdog/w83877f_wdt.c
    ./char/watchdog/mixcomwd.c
    ./char/watchdog/w83627hf_wdt.c
    ./char/watchdog/advantechwdt.c
    ./char/watchdog/ib700wdt.c
    ./char/watchdog/pcwd.c
    ./char/watchdog/wdt977.c
    ./char/rocket_int.h
    ./char/sonypi.c


Most of these go nowhere near the ISA bus.  This has been said before,
but perhaps you missed that.  Which is another reason to use good
manners, isn't it?

The argument that you can't know how long to delay is utter rubbish.

> In fact, we're blue in the face from talking about it. So say
> something useful or go away. 

I think I'm saying something useful.  I'll keep an eye out for your
humble apology.  (Are you big enough to give one?)   In the mean time,
perhaps you'll follow your own advice and say something useful or go
away.  :-p

I hope you'll see this in the positive and constructive light that it is
intended.
