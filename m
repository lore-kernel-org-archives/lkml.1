Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbYAAVRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbYAAVRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 16:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbYAAVRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 16:17:08 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53532 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754629AbYAAVRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 16:17:07 -0500
Date: Tue, 1 Jan 2008 21:07:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: "David P. Reed" <dpreed@reed.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@gmail.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080101210734.03414931@the-village.bc.nu>
In-Reply-To: <20080101184524.GA6655@elte.hu>
References: <4765DCB0.8030901@gmail.com>
	<4765EE7F.80002@zytor.com>
	<47667366.7010405@gmail.com>
	<4766AE88.4080904@zytor.com>
	<4766D175.7040807@reed.com>
	<20071217212509.5edaa372@the-village.bc.nu>
	<477A634C.8040000@reed.com>
	<20080101161557.3ce2d5f8@the-village.bc.nu>
	<20080101164338.GA901@elte.hu>
	<20080101173212.1bba4939@the-village.bc.nu>
	<20080101184524.GA6655@elte.hu>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > #1 udelay has to be for the worst case bus clock (6MHz) while the 
> > #device may be at 10Mhz or even 12MHz ISA. So it slows it down stuff
> > unneccessarily- and stuff that really really is slow enough as is.
> 
> udelay is supposed to be reliable. If someone runs a new kernel and has 
> no TSC (which might happen even on modern hardware or with notsc) _and_ 
> finds that udelay is not calibrated well enough then that's a kernel bug 
> we want to fix.

You miss the point entirely. The delay is in bus clocks not CPU clocks,
not tsc clocks not PIT clocks, and it is permitted to vary by a factor of
two. So you'll worst case halve the speed of network packet up/download
even if your udelay is accurate.

> > #2 Most of the ancient wind up relics with ISA bus don't have a tsc so
> > their udelay value is kind of iffy.
> 
> iffy in what way? Again, we might be hiding real udelay bugs.

As you say - its only a few instructions so small udelays tend to be
inaccurate - overlong.

> yes, there are always risks in changing something, but using udelay is a 
> common-sense consolidation of code.

Not for ISA bus hardware. For chipset logic, for PCI yes - for ISA stuff
no. It's all about ISA clocks not wall clocks.

Alan
