Return-Path: <linux-kernel-owner+w=401wt.eu-S1760511AbXGXTHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760511AbXGXTHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbXGXTHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:07:13 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58068 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbXGXTHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:07:12 -0400
Message-ID: <46A64DD8.6000607@garzik.org>
Date: Tue, 24 Jul 2007 15:07:04 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       =?ISO-8859-1?Q?S=E9bastien_Du?= =?ISO-8859-1?Q?gu=E9?= 
	<sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to
 platform devices - broke my serial console
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>	<200707240948.45916.bjorn.helgaas@hp.com>	<46A63BC3.3050208@garzik.org> <20070724110946.8678d202.akpm@linux-foundation.org>
In-Reply-To: <20070724110946.8678d202.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Well I queued up a tentative revert patch but then I re-read the changlog:
> 
>     x86, serial: convert legacy COM ports to platform devices
>     
>     Make x86 COM ports into platform devices and don't probe for them
>     if we have PNP.
>     
>     This prevents double discovery, where a device was found both by
>     the legacy probe and by 8250_pnp, e.g.,
>     
>         serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>         00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A

If this actually causes a problem, then the drivers are buggy.  We have 
standard APIs for checking this stuff...

Turning off legacy serial probing is just a bandaid, the resource bug is 
still there [by definition, if double-probing problems exist].


>     This also means IRDA devices without a UART PNP ID will no longer be
>     claimed by the serial driver, which might require changes in IRDA
>     drivers and administration.

This was completely unaddressed, I presume?


>     In addition to this patch, you may need to configure a setserial init
>     script, e.g., /etc/init.d/setserial, so it doesn't poke legacy UART
>     stuff back in.  On Debian, "dpkg-reconfigure setserial" with the "kernel"
>     option does this.

So this patch breaks some userspace too?


>     To force the old legacy probe behavior even when we have PNPBIOS or
>     ACPI, load the new legacy_serial module (or build 8250 static) with
>     the "legacy_serial.force" option.
> 
> So 7e92b4fc345f5b6f57585fbe5ffdb0f24d7c9b26 fixed a bunch of longstanding
> nasties while breaking Sebastien's machine (at least).
> 
> We of course want the best of both worlds here, so I'll keep the revert
> patch in -mm for a while, see what happens.  Although I can't immediately
> see any way in which this can be fixed...

I see VERY few positives, a whole lot of trouble, and a couple band-aids.

	Jeff


