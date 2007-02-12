Return-Path: <linux-kernel-owner+w=401wt.eu-S964920AbXBLNel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964920AbXBLNel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 08:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964918AbXBLNel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 08:34:41 -0500
Received: from mail.gmx.net ([213.165.64.20]:50656 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S964917AbXBLNek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 08:34:40 -0500
X-Provags-ID: V01U2FsdGVkX18TeJQs2rATxF/9Dzci6bY5CDwrp3rf/GgJWMJllc
	dUgA==
From: Florian Schmidt <mista.tapas@gmx.net>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.20 "IRQ handler type mismatch for IRQ 4"
Date: Mon, 12 Feb 2007 14:34:38 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200702102140.55155.mista.tapas@gmx.net> <20070212131838.04a2abcc@localhost.localdomain>
In-Reply-To: <20070212131838.04a2abcc@localhost.localdomain>
X-Face: %EpW[IH18fBP*R?oz~]%Klbl.q!_(Xs_q"t?K~RVx[c7~3|C3kDdA(8y_KOB\{(Rn(=?utf-8?q?MZhm=0A=09=7B/l=2E?=>O48>i9k<+(,c^Y%mGm)M\+RxuxL4r<7-W63sB$+w\}hkT"Q2?v&N:y\Z
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702121434.38403.mista.tapas@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 February 2007, Alan wrote:
> > [   23.783913] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ
> > sharing enabled
> > [   23.787063] pnp: Device 00:0c activated.
> > [   23.787420] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>
> So the PnP layers put a device on IRQ 4, which is sensible
>
> > [   37.516000] eth1: orinoco_cs at 0.0, irq 4, io 0x0100-0x013f
>
> The PCMCIA layer then ignores this and takes IRQ 4 simply because
> although PnP has used it the IRQ isnt currently live
>
> > [   53.580000] IRQ handler type mismatch for IRQ 4
> > [   53.580000] current handler: pcmcia0.0
>
> The serial IRQ setup fails
>
> > [   53.580000]  [<c0141a25>] setup_irq+0x135/0x1e0
> > [   53.580000]  [<c0230930>] serial8250_interrupt+0x0/0xf0
> > [   53.580000]  [<c0141b73>] request_irq+0xa3/0xc0
> > [   53.580000]  [<c023086e>] serial8250_startup+0x47e/0x4b0
> > [   53.580000]  [<c022bf58>] uart_startup+0x48/0x160
> > [   53.580000]  [<c022cb9f>] uart_open+0xbf/0x460
>
> This is all scary and generally not needed spew but handy for debug.
>
> Looks like a PCMCIA layer bug. It should be respecting IRQ assignment
> (not just allocation) by other resource configuration layers.

Ah thanks for taking a look. I was slowly getting the impression from older 
lkml posts, that this isn't really what stopped my wifi from functioning. It 
seems there are other reasons and i just stumbled across this harmless 
message in dmesg.. Thanks for clearing it up :)

Flo

-- 
Palimm Palimm!
http://tapas.affenbande.org
