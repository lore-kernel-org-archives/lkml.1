Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbYAHDQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbYAHDQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 22:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbYAHDQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 22:16:00 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:59490 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbYAHDQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 22:16:00 -0500
Date: Tue, 8 Jan 2008 04:15:57 +0100
From: Christer Weinigel <christer@weinigel.se>
To: 7eggert@gmx.de
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@gmail.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080108041557.652b7ba9@weinigel.se>
In-Reply-To: <E1JBxnV-00046d-CS@be1.7eggert.dyndns.org>
References: <9BdU5-1YW-9@gated-at.bofh.it>
	<9BeZN-3Gf-5@gated-at.bofh.it>
	<9BnTB-1As-31@gated-at.bofh.it>
	<9BrX4-8go-1@gated-at.bofh.it>
	<9BuBG-4eR-51@gated-at.bofh.it>
	<9BvRd-6aL-71@gated-at.bofh.it>
	<9GRQW-1DX-13@gated-at.bofh.it>
	<9GSah-23W-1@gated-at.bofh.it>
	<9GSDy-2GD-23@gated-at.bofh.it>
	<9GTpK-40d-15@gated-at.bofh.it>
	<9GUvy-5H2-11@gated-at.bofh.it>
	<9GVKU-7SS-25@gated-at.bofh.it>
	<E1JBxnV-00046d-CS@be1.7eggert.dyndns.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Jan 2008 20:38:09 +0100
Bodo Eggert <7eggert@gmx.de> wrote:

> Christer Weinigel <christer@weinigel.se> wrote:
> 
> > How do you find out the speed of the ISA bus?  AFAIK there is no
> > standardized way to do that.  On the Geode SC2200 the ISA bus speed
> > is usually the PCI clock divided by 4 giving 33MHz/4=8.3MHz or
> > 30/4=7.5MHz, but with no external ISA devices it's possible to
> > overclock the ISA bus to /3 to run it at 11MHz or so.  But without
> > poking at some CPU and southbridge specific registers to find out
> > the PCI bus speed and the ISA bus divisor you can't really tell.
> 
> If you overclock, you are on your own. IIRC I've used 13,3 MHz for
> some time and used a lower PIO mode to compensate.

That would not be overclocking, rather that the hardware designer would
have determined that on that specific hardware design, all peripherals
are able to run at 12MHz.  

Also note that on some other system the hardware designer might have
decided to have a slower ISA clock, to save power, fulfil some EMI
requirement or whatever.

> > So if you do udelay based on a 6MHz clock (I think you can safely
> > assume that any 386 based system runs the ISA bus at least that
> > fast) you'll waste at least 30% and maybe even 100% more time for
> > the delay after every _p call.
> 
> Defaulting to 8 MHz and offering an option to set another clock speed
> (like idebus=) should be OK.

Sounds like a big regression to have to start using a command line
option, when the current state of affairs is "it just works".

  /Christer
