Return-Path: <linux-kernel-owner+w=401wt.eu-S1756247AbXKWKjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbXKWKjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbXKWKj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:39:27 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52450 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753559AbXKWKj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:39:26 -0500
Date: Fri, 23 Nov 2007 10:36:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: niessner@jpl.nasa.gov, Kyle McMartin <kyle@mcmartin.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: Where is the interrupt going?
Message-ID: <20071123103655.1ee713f1@the-village.bc.nu>
In-Reply-To: <200711230258.56066.bzolnier@gmail.com>
References: <1195693710.5544.240.camel@morte.jpl.nasa.gov>
	<20071122164853.cfdplzj5o744sw40@webmail.jpl.nasa.gov>
	<20071123012525.126010d5@the-village.bc.nu>
	<200711230258.56066.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2007 02:58:55 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Friday 23 November 2007, Alan Cox wrote:
> > On Thu, 22 Nov 2007 16:48:53 -0800
> > niessner@jpl.nasa.gov wrote:
> > 
> > > 
> > > I tried the hammer and the problem persists.
> > 
> > See my earlier email - your driver registers the irq with IRQF_DISABLED
> > then never enables it.
> 
> As already explained by Kyle IRQF_DISABLED shouldn't matter here.
> 
> [ Nowadays IRQF_DISABLED only tells kernel/irq/handle.c::handle_IRQ_event()
>   to not enable local interrupts before calling your IRQ handler.
> 
>   I've recently removed IRQF_DISABLED from IDE after noticing this. ]

Bartlomiej is of course correct. Thats what you get for replying late at
night in a hurry.

I'm not sure IDE can work without it because you need to lock out the
timer events (old IDE doesn't handle this at all on SMP though so it
wants fixing properly anyway).

Alan
