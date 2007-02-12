Return-Path: <linux-kernel-owner+w=401wt.eu-S964904AbXBLNEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964904AbXBLNEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 08:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964908AbXBLNEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 08:04:51 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55663 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964904AbXBLNEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 08:04:51 -0500
Date: Mon, 12 Feb 2007 13:18:38 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Florian Schmidt <mista.tapas@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 "IRQ handler type mismatch for IRQ 4"
Message-ID: <20070212131838.04a2abcc@localhost.localdomain>
In-Reply-To: <200702102140.55155.mista.tapas@gmx.net>
References: <200702102140.55155.mista.tapas@gmx.net>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> [   23.783913] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ 
> sharing enabled
> [   23.787063] pnp: Device 00:0c activated.
> [   23.787420] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A

So the PnP layers put a device on IRQ 4, which is sensible

> [   37.516000] eth1: orinoco_cs at 0.0, irq 4, io 0x0100-0x013f

The PCMCIA layer then ignores this and takes IRQ 4 simply because
although PnP has used it the IRQ isnt currently live

> [   53.580000] IRQ handler type mismatch for IRQ 4
> [   53.580000] current handler: pcmcia0.0

The serial IRQ setup fails

> [   53.580000]  [<c0141a25>] setup_irq+0x135/0x1e0
> [   53.580000]  [<c0230930>] serial8250_interrupt+0x0/0xf0
> [   53.580000]  [<c0141b73>] request_irq+0xa3/0xc0
> [   53.580000]  [<c023086e>] serial8250_startup+0x47e/0x4b0
> [   53.580000]  [<c022bf58>] uart_startup+0x48/0x160
> [   53.580000]  [<c022cb9f>] uart_open+0xbf/0x460

This is all scary and generally not needed spew but handy for debug.

Looks like a PCMCIA layer bug. It should be respecting IRQ assignment
(not just allocation) by other resource configuration layers.

Alan
