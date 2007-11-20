Return-Path: <linux-kernel-owner+w=401wt.eu-S1763704AbXKTWJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763704AbXKTWJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbXKTWJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:09:31 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46819 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753307AbXKTWJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:09:30 -0500
Date: Tue, 20 Nov 2007 22:07:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       zaitcev@redhat.com
Subject: Re: [PATCH] mct232: speed, new termios and compliance cleanups
Message-ID: <20071120220709.49b60de2@the-village.bc.nu>
In-Reply-To: <20071120110413.5f84e092.zaitcev@redhat.com>
References: <20071119152211.4be48986@the-village.bc.nu>
	<20071120110413.5f84e092.zaitcev@redhat.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >   * we do not know how to support. We ignore them for the moment.
> >   * XXX Rate-limit the error message, it's user triggerable.
> 
> This XXX item is fixed by this patch, so should be removed.

Ok

> 
> > +		/* FIXME: Can we use any divider - should we do
> > +		   divider = 115200/value;
> > +		   real baud = 115200/divider */
> >  		switch (value) {
> >  		case 300: break;
> 
> I do not understand this FIXME comment. What is wrong with current
> code? The result of the function is given to the device's sequencer.
> Do you want to get rid of the switch? Please unconfuse me.

What should happen ideally and I didnt have the hw to check is that
we take whatever baud rate the use requested (arbitary value). From that
we compute the best divider. From the best divider we compute the actual
speed. The actual speed is then written back into the termios structure.

(The kernel knows about a few percent off being ok and will report
appropriately in those cases)

Alan
