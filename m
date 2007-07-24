Return-Path: <linux-kernel-owner+w=401wt.eu-S1760004AbXGXVGC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004AbXGXVGC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:06:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbXGXVFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:05:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59333 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249AbXGXVFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:05:53 -0400
Message-ID: <46A669AD.6070803@garzik.org>
Date: Tue, 24 Jul 2007 17:05:49 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>,
       =?ISO-8859-1?Q?S=E9bastie?= =?ISO-8859-1?Q?n_Dugu=E9?= 
	<sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to
 platform devices - broke my serial console
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <200707241434.32374.bjorn.helgaas@hp.com> <46A663CA.3050000@garzik.org> <200707241456.35769.bjorn.helgaas@hp.com>
In-Reply-To: <200707241456.35769.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> Keith Owens did report an issue with the double probe, but I confess
> I don't fully understand it.

heh, ok...


> The real problem was that the serial driver claimed a non-serial
> device.  On many laptops, there's an IR device at 0x3e8, IRQ 3.
> The serial driver claimed this as ttyS2, using IRQ 4.  So if you
> wanted to use the IR device, you had to either:
> 
>   - use setserial to make the serial driver forget about ttyS2
>     so an IR driver could claim it, or
> 
>   - use setserial to change the IRQ to 3 and just use the device
>     in SIR mode, which is 16550-compatible so you can use the
>     serial driver
> 
> I didn't express that very clearly in the changelog.

That cannot be a justification for breaking serial port probe that has 
been working for 10+ years.

The VAST MAJORITY of computers, all told, have one or more serial ports 
in the expected places.  We must consider the majority first, then 
tackle edge cases like weirdo laptops that can be detected by other means.

Now that we have established the double-probe problem as potentially 
bogus, and not investigated at all, we are left with:

You changed legacy serial probing, affecting millions of computers, due 
to a few machines with unusual IR configurations.

At this point the "revert! revert!" submarine alarm is sounding quite 
loudly.  You can fix IR without breaking legacy serial.

	Jeff


