Return-Path: <linux-kernel-owner+w=401wt.eu-S1763110AbYALATu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763110AbYALATu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 19:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760225AbYALATn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 19:19:43 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59832 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757584AbYALATn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 19:19:43 -0500
Date: Sat, 12 Jan 2008 00:17:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Zachary Amsden <zach@vmware.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8390: split up 8390 with ISA delay and 8390 without
Message-ID: <20080112001711.08361cd8@lxorguk.ukuu.org.uk>
In-Reply-To: <1200093391.21817.27.camel@bodhitayantram.eng.vmware.com>
References: <20080111180848.10a7f012@lxorguk.ukuu.org.uk>
	<1200093391.21817.27.camel@bodhitayantram.eng.vmware.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/drivers/net/hp.c linux-2.6.24-rc6-mm1/drivers/net/hp.c
> > --- linux.vanilla-2.6.24-rc6-mm1/drivers/net/hp.c	2008-01-02 16:04:00.000000000 +0000
> > +++ linux-2.6.24-rc6-mm1/drivers/net/hp.c	2008-01-11 14:47:44.000000000 +0000
> 
> > @@ -176,7 +176,7 @@
> >  				outb_p(irqmap[irq] | HP_RUN, ioaddr + HP_CONFIGURE);
> >  				outb_p( 0x00 | HP_RUN, ioaddr + HP_CONFIGURE);
> 
> ... didn't you miss two here?  Otherwise, code looks great.

The patch only changes the _p usage within the shared library. The hp.c
code is used solely by the ISA HP driver and needed.

> How will the user know when they need to use 8390p?  

They don't need to, any more than they need to know about 8390 right now.
It is added to the Makefile so will be sucked in and built by Make as an
extra module. The 8390p and 8390 use different wrapper symbols for
ei_open etc so depmod will load the right one.

Alan
