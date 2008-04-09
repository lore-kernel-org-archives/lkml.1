Return-Path: <linux-kernel-owner+w=401wt.eu-S1758329AbYDIU43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329AbYDIU43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbYDIU4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:56:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36472 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753455AbYDIU4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:56:20 -0400
Date: Wed, 9 Apr 2008 21:52:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Dmitry <dbaryshkov@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       lethal@linux-sh.org, philipp.zabel@gmail.com, pavel@ucw.cz,
       tony@atomide.com, paul@pwsan.com
Subject: Re: [PATCH 5/6] Clocklib: Use correct clock for IrDA on pxa
Message-ID: <20080409215233.1a1c0002@core>
In-Reply-To: <20080409192009.GB13891@flint.arm.linux.org.uk>
References: <20080403132142.GA26882@doriath.ww600.siemens.net>
	<20080403132402.GA27008@doriath.ww600.siemens.net>
	<20080407160029.f1f9ce4f.akpm@linux-foundation.org>
	<20080407230434.GA525@flint.arm.linux.org.uk>
	<bc64b4640804080247s82ba84chd740c08b2fbb9b1a@mail.gmail.com>
	<20080408193309.GA18053@flint.arm.linux.org.uk>
	<bc64b4640804090015m7dd640d5j31c54b99007f09a7@mail.gmail.com>
	<20080409190504.GA13891@flint.arm.linux.org.uk>
	<20080409200916.78615f39@core>
	<20080409192009.GB13891@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It's called a line discipline, we've had them for many years. We may need
> > a way for ldiscs and drivers to co-operate a bit more but these days we
> > support proper buffering and arbitary baud rates (except on a few
> > platforms whose maintainers are not paying attention ;)).
> 
> I feel that's a "it would be nice if" solution - and something worth
> aiming for, but the amount of work required to get there is not going
> to be insignificant.

The work required to fix up the existing FIR hacks is not insignifcant
either. Also right now the tty layer is getting a major rework so now is
actually the time to sort out anything extra that is needed.

If you want 4MBit please just use an ldisc and do

	struct ktermios tmp;
	mutex_lock(&tty->termios_mutex);
	tmp = *tty->termios;
	tty_encode_baud_rate(tty, 4000000, 4000000);
	tty->driver->set_termios(tty, &tmp);
	mutex_unlock(&tty->termios_mutex);

Alan
