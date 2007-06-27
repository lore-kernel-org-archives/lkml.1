Return-Path: <linux-kernel-owner+w=401wt.eu-S1761535AbXF0OdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761535AbXF0OdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 10:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbXF0Oc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 10:32:56 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:37685 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbXF0Oc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 10:32:56 -0400
Date: Wed, 27 Jun 2007 08:32:53 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: pci.h stubs (was: EDD build error)
Message-ID: <20070627143252.GW22063@parisc-linux.org>
References: <20070626132622.3226261a.randy.dunlap@oracle.com> <20070627024505.GA30197@humbolt.us.dell.com> <20070627113048.GU22063@parisc-linux.org> <20070627145500.2e66fd49@the-village.bc.nu> <20070627140305.GV22063@parisc-linux.org> <20070627153258.50d5dac3@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627153258.50d5dac3@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 03:32:58PM +0100, Alan Cox wrote:
> On Wed, 27 Jun 2007 08:03:05 -0600
> Matthew Wilcox <matthew@wil.cx> wrote:
> 
> > On Wed, Jun 27, 2007 at 02:55:00PM +0100, Alan Cox wrote:
> > > On Wed, 27 Jun 2007 05:30:48 -0600
> > > Matthew Wilcox <matthew@wil.cx> wrote:
> > > > pci_get_bus_and_slot() shouldn't be used because it fails to work on
> > > > systems with multiple domains.  pci_get_slot() avoids this problem (and
> > > > is much faster too).
> > > 
> > > But requires you have a bus pointer to hand which is often not the
> > > case. Do we need pci_get_domain_bus_and_slot() ?
> > 
> > We have pci_find_bus(domain, busnr) which will get you the bus pointer.
> 
> So the answer is "yes" we should then, and move from pci_get_bus_and_slot
> to pci_get_bus_domain_and_slot() [or just add an argument]. The point of
> the functions is to be easy to use, so it should be handled internally.

My point was that code which doesn't currently keep the bus pointer to
hand should keep the bus pointer to hand instead of the bus number.
That's easier to use, particularly if you want to actually do any pci
config accesses.
