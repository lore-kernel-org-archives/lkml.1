Return-Path: <linux-kernel-owner+w=401wt.eu-S1946180AbXBBXyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946180AbXBBXyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 18:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946179AbXBBXyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 18:54:11 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:41392 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946185AbXBBXyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 18:54:09 -0500
Date: Fri, 2 Feb 2007 19:26:19 -0500
From: Adam Kropelin <akropel1@rochester.rr.com>
To: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Adrian Bunk <bunk@stusta.de>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: MSI failure on nForce 430 (WAS: intel 82571EB gigabit fails to see link on 2.6.20-rc5 in-tree e1000 driver (regression))
Message-ID: <20070202192619.A23633@mail.kroptech.com>
References: <20070117190448.A20184@mail.kroptech.com> <45AEB79B.2010205@intel.com> <00d701c73c1f$b2bb2390$84163e05@kroptech.com> <45B1562C.8070503@intel.com> <011101c73c29$9f6f5db0$84163e05@kroptech.com> <45B16491.7030207@intel.com> <023401c73cca$05bc5f00$84163e05@kroptech.com> <20070202164726.GH3754@stusta.de> <45C37412.70205@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <45C37412.70205@intel.com>; from auke-jan.h.kok@intel.com on Fri, Feb 02, 2007 at 09:25:38AM -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 09:25:38AM -0800, Auke Kok wrote:
> Adrian Bunk wrote:
> > On Sat, Jan 20, 2007 at 02:34:37PM -0500, Adam Kropelin wrote:
> >> (cc: list trimmed and thread moved to linux-pci)
> >>
> >> I have a PCI-E e1000 card that does not see interrupts on 2.6.20-rc5 
> >> unless CONFIG_PCI_MSI is disabled. An e1000 maintainer indicated that 
> >> the PHY state is correct, it's just that the interrupt is not getting 
> >> thru to the kernel. Interestingly, on 2.6.19 PHY interrupts get thru ok 
> >> with MSI enabled (link status responds appropriately) but packet tx 
> >> fails with timeout errors, implying that perhaps MAC interrupts are not 
> >> arriving.
> >>
> >> I've attached the contents dmesg, 'lspci -vvv', and 'cat 
> >> /proc/interrupts' from 2.6.20-rc5.
> >>
> >> This is an nForce 430 based chipset on a Dell E521 which has had 
> >> interrupt routing issues before. Prior to 2.6.19 it had to be booted 
> >> with 'noapic' in order to come up at all. It also had USB lockup 
> >> problems until I applied the latest BIOS update (v1.1.4). So a BIOS 
> >> interrupt routing bug with MSI is not out of the question.
> >>
> >> I'm happy to gather more data or run tests...
> > 
> > Was this regression fixed by Eric's patch that is included in -rc7?
> 
> no, this is a different issue afaics. Eric's patch solves a msi vector leak 
> where MSI's were no longer recovered after all 256 of them were handed out. The 
> issue here seems to be a very different regression (no vector at all or vector 
> not setup correctly to begin with).
> 
> I do suggest re-testing the issue with 2.6.20rc7, but it's unlikely it fixes the 
> problem for Adam.

Your thought is correct: 2.6.20-rc7 still fails.

--Adam

