Return-Path: <linux-kernel-owner+w=401wt.eu-S1763436AbXLOOhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763436AbXLOOhW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 09:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757323AbXLOOhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 09:37:06 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36100 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757000AbXLOOhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 09:37:04 -0500
Date: Sat, 15 Dec 2007 14:29:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rene Herman <rene.herman@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80 on
 some AMD64x2 laptops, etc.
Message-ID: <20071215142929.5462b329@the-village.bc.nu>
In-Reply-To: <20071215132725.GA23166@elte.hu>
References: <1184218962.12353.209.camel@chaos>
	<46964352.7040301@reed.com>
	<1184253339.12353.223.camel@chaos>
	<469697C6.50903@reed.com>
	<1184274754.12353.254.camel@chaos>
	<4761F193.7090400@reed.com>
	<20071214131502.GA14359@elte.hu>
	<4762C551.5070003@zytor.com>
	<20071215074358.GD12110@elte.hu>
	<4763891A.3010004@gmail.com>
	<20071215132725.GA23166@elte.hu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Dec 2007 14:27:25 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Rene Herman <rene.herman@gmail.com> wrote:
> 
> > The issue is -- how do you safely replace the outb pre-loops_per_jiffy 
> > calibration? I'm currently running with the attached hack (not 
> > submitted, only for 32-bit and discussion) the idea of which might be 
> > the best we can do?
> 
> how about doing a known-NOP chipset cycle? For example:
> 
>   inb(PIC_SLAVE_IMR)

It needs tobe a different chip to the main one (or macrocell anyway) - so
PIC for PIT and vice versa. However since we know 0x80 works for
everything on the planet but this one specifies of laptop which seems to
need a firmware update its a very high risk approach.

Alan
