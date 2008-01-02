Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYABAXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYABAXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 19:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbYABAXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 19:23:33 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:55407 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbYABAXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 19:23:32 -0500
Date: Wed, 2 Jan 2008 01:23:31 +0100
From: Christer Weinigel <christer@weinigel.se>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       "David P. Reed" <dpreed@reed.com>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080102012331.6fdd6e17@weinigel.se>
In-Reply-To: <20080101231250.054b7352@the-village.bc.nu>
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
	<477AAEEB.5060407@zytor.com>
	<20080102000545.5c68f183@weinigel.se>
	<20080101231250.054b7352@the-village.bc.nu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jan 2008 23:12:50 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Besides the above there are only a handful of _p uses outside of
> > real ISA device drivers, and those should not be relevant for a
> > modern PC unless somebody wants to use an 8390 based PCMCIA card,
> > but we could tell them "don't do that then".
> 
> We need to build 8390.c twice anyway - once for PCI once for ISA with
> the _p changes whichever way it gets done. PCMCIA can use whichever
> we decide is right. Anyone know if PCMCIA is guaranteed to be 8MHz ?

It's not.  It's perfectly ok to drive a PCMCIA bus slower than that,
IIRC we used a much slower clock speed than that on a StrongARM
platform I worked a couple of years ago.  

The PCMCIA CIS (Card information services) allows the following device
speeds: 100, 150, 200 and 250 ns.  The memory card spec also allows 600
and 300 ns.  The standard I/O card cycle speed is 255 ns.  I believe
that is "the shortest access time for a read/write cycle", and I can't
tell if that is comparable to one ISA clock cycles or if it's
comparable to 8 ISA bus cycles.

On the other hand, there is no clock line in a PCMCIA connector, so for
PCMCIA devices any delays should be absolute times, or based on some
clock that is internal to the card.  How that fits with the 8390 data
sheet talking about bus clocks, I don't know.

  /Christer
