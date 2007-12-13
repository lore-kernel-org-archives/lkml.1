Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbXLMNeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbXLMNeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 08:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbXLMNdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 08:33:52 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60774 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752889AbXLMNdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 08:33:51 -0500
Date: Thu, 13 Dec 2007 13:27:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: benh@kernel.crashing.org
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Robert Hancock <hancockr@shaw.ca>, linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Possible issue with dangling PCI BARs
Message-ID: <20071213132735.000a2a04@the-village.bc.nu>
In-Reply-To: <1197544621.15741.132.camel@pasglop>
References: <fa.YfTvVN5C3e6zwXPW5biWgeZ9XXc@ifi.uio.no>
	<fa.EhUqlM3V3y3HCcQkLBLSEKTJxBs@ifi.uio.no>
	<fa.4FjaYKIciOijtgO+0DDrMkrLjv0@ifi.uio.no>
	<4760B37E.3010002@shaw.ca>
	<20071213120403.B21124@jurassic.park.msu.ru>
	<20071213102424.18b621a7@the-village.bc.nu>
	<1197544621.15741.132.camel@pasglop>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We may be taking a small risk here, but what else do you propose ? The
> problem of dangling BARs is real... One option is for me to address it
> on powerpc and leave x86 alone as it might be more of an issue with
> random crazy embedded firmware for us than it is for x86. As I said, the
> workaround is completely self contained within arch code for now.

I think the cases like the SIL680 are still covered by the comment below

> > Supporting pci_enable_device_io / pci_enable_device_mmio / pci_iomap_io /
> > pci_iomap_mmio seems to cover pretty much all the use cases we have. 
> > 
> > The users we have right now that are:
> > 
> >         - pata_cs5520   (can be dealt with easily)
> >         - old IDE       (with the new resource handling for legacy IDE
> > can use pci_enable_device_io I think, ditto pci/cs5520)
> >         - scx200_acb    (looks like a simple substitution works)
> >         - lpfc          pci_enable_device_mmio
> >         - qla2xxx       pci_enable_device ? (enables IO and MMIO)
> 
> Ok.

If we get those in I can fix up libata in no time and sort out the CS5520
devices. Rest is easy providing Bartlomiej can sort out old IDE core.
