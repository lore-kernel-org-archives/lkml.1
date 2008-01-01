Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbYAAXFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbYAAXFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 18:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270AbYAAXFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 18:05:47 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:44457 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbYAAXFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 18:05:46 -0500
Date: Wed, 2 Jan 2008 00:05:45 +0100
From: Christer Weinigel <christer@weinigel.se>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080102000545.5c68f183@weinigel.se>
In-Reply-To: <477AAEEB.5060407@zytor.com>
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
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Jan 2008 13:21:47 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Christer Weinigel wrote:
> > 
> > out 80h, al is only two bytes.  Any alternative that has been
> > suggested in this discussion will use more space.  mov dx,
> > alt_port; out dx, al will be larger, a function call will
> > definitely be a lot larger. People have been making changes to the
> > kernel to save a couple of hundred bytes of text size.
> 
> If text size becomes a problem in this case, then we can use an 
> alternatives-like mechanism to fix up the kernel.  However, 
> realistically this probably should be a function call *combined with* 
> the out and in; that reduces the impact somewhat.

That's a very good point.  So for the PIT it should be possible to have
two clocksources, one with the _p and one without, that one can switch
between with a kernel command line option.  So there shouldn't be any
slowdown at all due to that.

The i8259 init code is not time critical, so should be able to use a
"reasonable" delay.  

Besides the above there are only a handful of _p uses outside of real
ISA device drivers, and those should not be relevant for a modern PC
unless somebody wants to use an 8390 based PCMCIA card, but we could
tell them "don't do that then".

But I'd better shut up and let Alan continue on his review of the _p
use in the drivers.

  /Christer


