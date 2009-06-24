Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbZFXKcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbZFXKcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 06:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbZFXKce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 06:32:34 -0400
Received: from mailout5.samsung.com ([203.254.224.35]:40095 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbZFXKcc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 06:32:32 -0400
Date: Wed, 24 Jun 2009 12:30:05 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
In-reply-to: <200906240149.41013.david-b@pacbell.net>
To: "'David Brownell'" <david-b@pacbell.net>
Cc: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>,
       "'Alan Stern'" <stern@rowland.harvard.edu>,
       "'Peter Korsgaard'" <jacmet@sunsite.dk>,
       "'USB list'" <linux-usb@vger.kernel.org>,
       "'Kernel development list'" <linux-kernel@vger.kernel.org>,
       kyungmin.park@samsung.com, Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <003b01c9f4b6$c39002b0$4ab00810$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=iso-8859-2
Content-language: pl
Content-transfer-encoding: 8BIT
Thread-index: Acn0qM5TQEhkipXWSlavVv11TunQrQAB0SCg
References: <001201c9f341$20b8b710$622a2530$%szyprowski@samsung.com>
 <200906230952.37592.david-b@pacbell.net>
 <002101c9f49a$6cfcaf50$46f60df0$%szyprowski@samsung.com>
 <200906240149.41013.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wednesday, June 24, 2009 10:50 AM, David Brownell wrote:

> > I did some additional tests and found another bug. When I enabled debug in my
> > low level udc driver then I can easily trigger the following bug:
> >
> > [   55.630000] Unable to handle kernel NULL pointer dereference at virtual address 00000014
> > [   55.630000] pgd = c0004000
> > [   55.630000] [00000014] *pgd=00000000
> > [   55.630000] Internal error: Oops: 17 [#1] PREEMPT
> > [   55.630000] Modules linked in:
> > [   55.630000] CPU: 0    Not tainted  (2.6.30 #355)
> > [   55.630000] PC is at __lock_acquire+0xa0/0xa6c
> > [   55.630000] LR is at lock_acquire+0x58/0x6c
> > [   55.630000] ...
> > [   55.630000] [<c005786c>] (__lock_acquire+0xa0/0xa6c) from [<c0058290>] (lock_acquire+0x58/0x6c)
> > [   55.630000] [<c0058290>] (lock_acquire+0x58/0x6c) from [<c0274e74>]
> (_spin_lock_irqsave+0x44/0x58)
> > [   55.630000] [<c0274e74>] (_spin_lock_irqsave+0x44/0x58) from [<c019d608>]
> (gs_write_room+0x10/0x58)
> > [   55.630000] [<c019d608>] (gs_write_room+0x10/0x58) from [<c0156058>] (tty_write_room+0x20/0x28)
> 
> So it's looking like tty->driver_data is somehow NULL.  That's
> never supposed to happen.  Did gs_open() fail or something?

I've triggered this bug by running a 'getty -L 115200 ttyGS0 vt100' and trying
to login on that usb console and then pressing 'enter' key for longer time.
getty might abort after a few failed logins, so the /dev/ttyGS0 file might be
closed before all characters that need to be echoed were processed (usb udc debug
messages really slows it down). This is however a pure guessing, I know nothing
about tty framework and internals.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center



