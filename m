Return-Path: <linux-kernel-owner+w=401wt.eu-S933034AbXBLP5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbXBLP5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 10:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933011AbXBLP5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 10:57:38 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:63498 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933034AbXBLP5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 10:57:37 -0500
Date: Mon, 12 Feb 2007 16:57:35 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pavel Machek <pavel@ucw.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
       nigel@nigel.suspend2.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
In-Reply-To: <20070212150410.GA17400@elf.ucw.cz>
Message-ID: <Pine.LNX.4.62.0702121653160.2928@pademelon.sonytel.be>
References: <1171058269.1484.64.camel@nigel.suspend2.net>
 <1171059433.8675.195.camel@laptopd505.fenrus.org> <20070210193851.GA3956@ucw.cz>
 <200702102320.39531.rjw@sisk.pl> <Pine.LNX.4.62.0702120948230.10436@chinchilla.sonytel.be>
 <20070212150410.GA17400@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Feb 2007, Pavel Machek wrote:
> > > "If the device requires that, implement .suspend and .resume or at least
> >                                                                   ^^^^^^^^
> > > define .suspend that will always return -ENOSYS (then people will know they
> >   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > have to unload the driver before the suspend).  Similarly, if you aren't sure
> > > whether or not the device requires .suspend and .resume, define .suspend that
> >                                                            ^^^^^^^^^^^^^^^^^^^^
> > > will always return -ENOSYS."
> >   ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > Can't the upper layer just assume -ENOSYS if .resume/.suspend is NULL?
> > It's nicer if you don't have to implement dummy functions at all.
> 
> Unfortunately, drivers currently assume "NULL == nothing is needed",
> so we'd have t do big search & replace... 

Which means you also cannot easily keep track of which driver supports
suspend/resume and which doesn't, as there will always be drivers where a
missing suspend/resume function is correct.

Wouldn't it be more sensible to have

    .suspend = suspend_nothing_to_do

instead, and reserve NULL for `not yet implemented'?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
