Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbYD2W5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbYD2W5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYD2W5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:57:33 -0400
Received: from www.tglx.de ([62.245.132.106]:46649 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbYD2W5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:57:32 -0400
Date: Wed, 30 Apr 2008 00:55:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Helge Wagner <Helge.Wagner@gefanuc.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: restrict keyboard io ports reservation to make ipmi
 driver work
In-Reply-To: <86802c440804291502q59fc50faue59988b4787d3458@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0804300055010.6003@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0804292342060.6003@apollo.tec.linutronix.de> <86802c440804291502q59fc50faue59988b4787d3458@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Apr 2008, Yinghai Lu wrote:

> On Tue, Apr 29, 2008 at 2:46 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > From: Helge Wagner <Helge.Wagner@gefanuc.com>
> >
> >  On some of our (single board computer) boards (x86) we are using an
> >  IPMI controller that uses I/O ports 0x62 and 0x66 for a KCS (keyboard
> >  controller style) IPMI system interface.
> >
> >  Trying to load the openipmi driver fails, because the ports
> >  (0x62/0x66) are reserved for keyboard. keyboard reserves the full
> >  range 0x60-0x6F while it doesn't need to.
> >
> >  Reserve only ports 0x60 and 0x64 for the legacy PS/2 i8042 keyboad
> >  controller instead of 0x60-0x6F to allow the openipmi driver to work.
> >
> >  Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> >  ---
> >   arch/x86/kernel/setup_32.c |    7 ++++++-
> >   1 file changed, 6 insertions(+), 1 deletion(-)
> >
> >  Index: linux-2.6/arch/x86/kernel/setup_32.c
> >  ===================================================================
> >  --- linux-2.6.orig/arch/x86/kernel/setup_32.c
> >  +++ linux-2.6/arch/x86/kernel/setup_32.c
> >  @@ -127,7 +127,12 @@ static struct resource standard_io_resou
> >   }, {
> >         .name   = "keyboard",
> >         .start  = 0x0060,
> >  -       .end    = 0x006f,
> >  +       .end    = 0x0060,
> >  +       .flags  = IORESOURCE_BUSY | IORESOURCE_IO
> >  +}, {
> >  +       .name   = "keyboard",
> >  +       .start  = 0x0064,
> >  +       .end    = 0x0064,
> >         .flags  = IORESOURCE_BUSY | IORESOURCE_IO
> >   }, {
> >         .name   = "dma page reg",
> >  --
> 
> 64 bit need to be fixed too...
>         { .name = "keyboard", .start = 0x60, .end = 0x6f,
>                 .flags = IORESOURCE_BUSY | IORESOURCE_IO },

Doh, yes.

Thanks,
	tglx
 
