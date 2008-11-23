Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbYKWC3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbYKWC3l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 21:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbYKWC3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 21:29:31 -0500
Received: from mailout-venus.uni-duesseldorf.de ([134.99.128.32]:41764 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755290AbYKWC3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 21:29:30 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sun, 23 Nov 2008 03:29:19 +0100 (CET)
From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: vme_scc.c breakage (was: Re: linux-next: Tree for November 21)
In-reply-to: <20081122164738.2226b63e@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Message-id: <alpine.DEB.1.00.0811230250290.8478@zirkon.biophys.uni-duesseldorf.de>
References: <20081121181948.ee771502.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0811221558340.30025@anakin>
 <20081122164738.2226b63e@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > Issues:
> >   1. When Atari support is enabled, `scc' is defined in
> >      include/asm-m68k/atari.h as:
> > 
> > 	# define scc ((*(volatile struct SCC*)SCC_BAS))

This can be renamed - it is only used for control and data port address init 
(aside from serial console, which should probably be separated out if it cannot 
be reconciled). 

> > 
> >      However, renaming the variable `scc' doesn't help, as
> > 
> >   2. the variable `scc' is not used in scc_carrier_raised(),
> > 
> >   3. `port->channel' on line 635 still fails as `port' is not longer `struct
> >      scc_port', but a 'struct tty_port', which has no member named 'channel'.
> 
> Will take a look at this, but gs is going to away so at some point
> someone with hardware is going to have to admit to owning this driver or
> just mark it BROKEN..

Time to merge with pmac_zilog or ip22zilog (the latter even needing similar 
register access delays as Ataris). 

What is the time frame to gs being removed? I admit to 'owning' atari_scc which 
was based on vme_scc so I'll have to deal with that sooner or later.

	Michael

