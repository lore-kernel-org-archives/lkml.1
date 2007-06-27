Return-Path: <linux-kernel-owner+w=401wt.eu-S1761446AbXF0O1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446AbXF0O1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 10:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbXF0O1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 10:27:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34800 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753959AbXF0O1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 10:27:04 -0400
Date: Wed, 27 Jun 2007 15:32:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: pci.h stubs (was: EDD build error)
Message-ID: <20070627153258.50d5dac3@the-village.bc.nu>
In-Reply-To: <20070627140305.GV22063@parisc-linux.org>
References: <20070626132622.3226261a.randy.dunlap@oracle.com>
	<20070627024505.GA30197@humbolt.us.dell.com>
	<20070627113048.GU22063@parisc-linux.org>
	<20070627145500.2e66fd49@the-village.bc.nu>
	<20070627140305.GV22063@parisc-linux.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 08:03:05 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Jun 27, 2007 at 02:55:00PM +0100, Alan Cox wrote:
> > On Wed, 27 Jun 2007 05:30:48 -0600
> > Matthew Wilcox <matthew@wil.cx> wrote:
> > > pci_get_bus_and_slot() shouldn't be used because it fails to work on
> > > systems with multiple domains.  pci_get_slot() avoids this problem (and
> > > is much faster too).
> > 
> > But requires you have a bus pointer to hand which is often not the
> > case. Do we need pci_get_domain_bus_and_slot() ?
> 
> We have pci_find_bus(domain, busnr) which will get you the bus pointer.

So the answer is "yes" we should then, and move from pci_get_bus_and_slot
to pci_get_bus_domain_and_slot() [or just add an argument]. The point of
the functions is to be easy to use, so it should be handled internally.

Alan
