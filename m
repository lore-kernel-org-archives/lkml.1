Return-Path: <linux-kernel-owner+w=401wt.eu-S1758545AbXGXWA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545AbXGXWA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 18:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbXGXWAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 18:00:20 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:32811 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753232AbXGXWAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 18:00:19 -0400
Date: Tue, 24 Jul 2007 23:06:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jeff Garzik <jeff@garzik.org>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to
 platform devices - broke my serial console
Message-ID: <20070724230626.72f8ad2a@the-village.bc.nu>
In-Reply-To: <200707241456.35769.bjorn.helgaas@hp.com>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
	<200707241434.32374.bjorn.helgaas@hp.com>
	<46A663CA.3050000@garzik.org>
	<200707241456.35769.bjorn.helgaas@hp.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>   - use setserial to make the serial driver forget about ttyS2
>     so an IR driver could claim it, or
> 
>   - use setserial to change the IRQ to 3 and just use the device
>     in SIR mode, which is 16550-compatible so you can use the
>     serial driver
> 
> I didn't express that very clearly in the changelog.

So the actual problem is quite different. Your IR driver for the port
should have an interface to tell the serial layer to make it unavailable.
End of problem and you can then use either service without setserial magic

Alan
