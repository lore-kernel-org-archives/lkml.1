Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbYAAUO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbYAAUO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 15:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbYAAUOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 15:14:51 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:53034 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbYAAUOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 15:14:50 -0500
Date: Tue, 1 Jan 2008 21:14:49 +0100
From: Christer Weinigel <christer@weinigel.se>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080101211449.1f39da07@weinigel.se>
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
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jan 2008 19:45:24 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > there strong counter-arguments against doing the clean thing and 
> > > adding an udelay(2) (or udelay(1)) to replace those _p() uses in
> > > ISA drivers?
> > 
> > #1 udelay has to be for the worst case bus clock (6MHz) while the 
> > #device may be at 10Mhz or even 12MHz ISA. So it slows it down stuff
> > unneccessarily- and stuff that really really is slow enough as is.
> 
> udelay is supposed to be reliable. If someone runs a new kernel and
> has no TSC (which might happen even on modern hardware or with notsc)
> _and_ finds that udelay is not calibrated well enough then that's a
> kernel bug we want to fix.

How do you find out the speed of the ISA bus?  AFAIK there is no
standardized way to do that.  On the Geode SC2200 the ISA bus speed is
usually the PCI clock divided by 4 giving 33MHz/4=8.3MHz or
30/4=7.5MHz, but with no external ISA devices it's possible to
overclock the ISA bus to /3 to run it at 11MHz or so.  But without
poking at some CPU and southbridge specific registers to find out the
PCI bus speed and the ISA bus divisor you can't really tell.

So if you do udelay based on a 6MHz clock (I think you can safely
assume that any 386 based system runs the ISA bus at least that fast)
you'll waste at least 30% and maybe even 100% more time for the delay
after every _p call.

  /Christer
