Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbYIDI2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbYIDI2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757714AbYIDI0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:26:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757164AbYIDI0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:26:21 -0400
Date: Thu, 4 Sep 2008 01:25:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: linux-next: Tree for September 3
Message-Id: <20080904012544.cabed847.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809040045190.3378@nehalem.linux-foundation.org>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
	<20080903214634.ea17ff53.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809032201510.3378@nehalem.linux-foundation.org>
	<20080903223318.84b6ce8b.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809040045190.3378@nehalem.linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 01:02:10 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So this all looks ok. I'd be happier if you also actually had some actual 
> _device_ in the Cardbus slot and reported that that works, but the patch 
> clearly 

<rummages for ten minutes>

<found it!>

<plugs it in>

cs: pcmcia_socket0: unable to apply power.
pccard: CardBus card inserted into slot 0
pci 0000:07:00.0: supports D1
pci 0000:07:00.0: supports D2
pci 0000:07:00.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:07:00.0: PME# disabled

sony:/home/akpm> lspci -s07:00
07:00.0 Ethernet controller: 3Com Corporation 3cCFE575CT CardBus [Cyclone] (rev 10)


seems OK.

<applies the patch, enables 3c59x.ko>

<reboots, plugs in card>

cs: pcmcia_socket0: unable to apply power.
pccard: CardBus card inserted into slot 0
pci 0000:07:00.0: supports D1
pci 0000:07:00.0: supports D2
pci 0000:07:00.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:07:00.0: PME# disabled
calling  vortex_init+0x0/0x9e [3c59x]
3c59x 0000:07:00.0: enabling device (0000 -> 0003)
3c59x 0000:07:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
3c59x: Donald Becker and others.
0000:07:00.0: 3Com PCI 3CCFE575CT Tornado CardBus at f8cb2000.
3c59x 0000:07:00.0: setting latency timer to 64
initcall vortex_init+0x0/0x9e [3c59x] returned 0 after 36 msecs

can't complain about that, apart from the apparently-bogus "unable to
apply power".
