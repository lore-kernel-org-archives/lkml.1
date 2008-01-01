Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbYAAUz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbYAAUz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 15:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbYAAUzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 15:55:48 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:39876 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYAAUzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 15:55:48 -0500
Date: Tue, 1 Jan 2008 21:55:45 +0100
From: Christer Weinigel <christer@weinigel.se>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@gmail.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080101215545.0785beef@weinigel.se>
In-Reply-To: <477A9B98.2090608@keyaccess.nl>
References: <4765DCB0.8030901@gmail.com>
	<4765EE7F.80002@zytor.com>
	<47667366.7010405@gmail.com>
	<4766AE88.4080904@zytor.com>
	<4766D175.7040807@reed.com>
	<20071217212509.5edaa372@the-village.bc.nu>
	<477A634C.8040000@reed.com>
	<20080101161557.3ce2d5f8@the-village.bc.nu>
	<20080101164338.GA901@elte.hu>
	<20080101183238.74307174@weinigel.se>
	<20080101184659.GA9250@elte.hu>
	<20080101203518.26e889f2@weinigel.se>
	<477A9B98.2090608@keyaccess.nl>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Jan 2008 20:59:20 +0100
Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 01-01-08 20:35, Christer Weinigel wrote:
> 
> > On old hardware (or anything with an ISA bus which I'd guess
> > includes the Geode SCx200 SoC which is basically a MediaGX
> > processor, a southbridge and an ISA bus with a Super I/O chip on
> > it) an out to 80h will use exactly one ISA cycle.
> 
> Not to disagree with the point but more like 8 (1 us at 8 MHz). It's
> the timeout property.

Ah, sorry, you're right of course.

> > I'm not sure what Alan meant with his comments about locking, but if
> > changing outb_p to use an udelay means that we have to add locking,
> > that is also going to affect the code size and speed.
> 
> Explained here:
> 
> http://lkml.org/lkml/2007/12/30/136
> 
> However, that's not an argument. Missing locking is a bug, and
> current outb I/O delay use hiding it doesn't change that.

Thanks, I had missed that one.

Regarding Alan's comment:

>For that matter does anyone actually have video cards old enough for us
>to care actually still in use with Linux today ? 

I'm afraid that some PC104 systems may still use ancient video cards.

  /Christer
