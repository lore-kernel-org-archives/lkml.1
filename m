Return-Path: <linux-kernel-owner+w=401wt.eu-S1761765AbXF0PC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761765AbXF0PC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXF0PCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:02:19 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47777 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758792AbXF0PCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:02:19 -0400
Date: Wed, 27 Jun 2007 16:07:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: pci.h stubs (was: EDD build error)
Message-ID: <20070627160756.68c59fff@the-village.bc.nu>
In-Reply-To: <20070627143252.GW22063@parisc-linux.org>
References: <20070626132622.3226261a.randy.dunlap@oracle.com>
	<20070627024505.GA30197@humbolt.us.dell.com>
	<20070627113048.GU22063@parisc-linux.org>
	<20070627145500.2e66fd49@the-village.bc.nu>
	<20070627140305.GV22063@parisc-linux.org>
	<20070627153258.50d5dac3@the-village.bc.nu>
	<20070627143252.GW22063@parisc-linux.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > So the answer is "yes" we should then, and move from pci_get_bus_and_slot
> > to pci_get_bus_domain_and_slot() [or just add an argument]. The point of
> > the functions is to be easy to use, so it should be handled internally.
> 
> My point was that code which doesn't currently keep the bus pointer to
> hand should keep the bus pointer to hand instead of the bus number.
> That's easier to use, particularly if you want to actually do any pci
> config accesses.

If you've got the bus pointer yes. If you don't then teaching
pci_get_bus_and_slot() to handle it makes sense.

Another problem here - which bus has the legacy decode mappings ? That
will matter for ATA which also uses pci_get_bus_and_slot...

