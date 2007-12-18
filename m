Return-Path: <linux-kernel-owner+w=401wt.eu-S1760356AbXLRRUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760356AbXLRRUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760717AbXLRRUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:20:04 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:58691 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758471AbXLRRUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:20:03 -0500
Date: Tue, 18 Dec 2007 18:19:21 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Remy Bohmer" <linux@bohmer.net>
Cc: "Andrew Victor" <linux@maxim.org.za>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atmel_serial: Split the interrupt handler
Message-ID: <20071218181921.2478baa9@dhcp-252-066.norway.atmel.com>
In-Reply-To: <3efb10970712180723x2cd22c5ei6b342f0ab7cc39c2@mail.gmail.com>
References: <1197987255-23045-1-git-send-email-hskinnemoen@atmel.com>
	<3efb10970712180723x2cd22c5ei6b342f0ab7cc39c2@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Crud...my mailer helpfully filtered this into the huge linux-kernel
bin instead of leaving it in my inbox...

On Tue, 18 Dec 2007 16:23:11 +0100
"Remy Bohmer" <linux@bohmer.net> wrote:

> Hello Haavard,
> 
> A few remarks:
> 
> > From: Remy Bohmer <hskinnemoen@atmel.com>
> 
> My name, at your address ;-)))

Right. Wonder how that happened...I'll try to fix it manually before I
send the next patchbomb.

> > This patch splits up the interrupt handler of the serial port
> > into a interrupt top-half and a tasklet.
> 
> I see you moved the handling of the sysrq-key to the tasklet. This was
> actually a very nice feature in the IRQ-top half on preempt-RT. This
> helps debugging running away RT-processes.

Ah. Good point. I guess we should move it back, then.

> > In this version of the patch, we try to only do things that are
> > absolutely necessary in the interrupt handler, storing away the
> > status register along with the received character and letting the
> > tasklet handle break, sysrq, error flags, etc.
> 
> Preempt-RT now absolutely requires my (4th) IRQ_NODELAY patch, because
> the spinlock now is always inside the code, and not only in
> theexception path, and thus without my NO_DELAY patch we have a panic
> during boot.
> On preempt-RT this spinlock must be a raw-spinlock. (If this type is
> known in the mainline kernel, you can apply that patch it anyway)

I'll see if that works.

> BTW: Attached I have added a 2nd patch that I use for Preempt-RT. (For
> cleaner startup, and to get rid of useless IRQ-threads.

Hrm. That assumption isn't valid on AVR32...on AP7000, for example,
IRQ1 is used by the LCD controller.

> > This patch should apply on top of the cleanup patch I sent earlier
> 
> For the cleanup patch:
> Acked-by: Remy Bohmer <linux@bohmer.net>
> 
> > today. Or at least I think so...I'll send the full series once
> > everyone are happy.
> 
> So, for this patch: I am almost happy ;-)

Great :-)

Haavard
