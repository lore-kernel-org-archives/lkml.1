Return-Path: <linux-kernel-owner+w=401wt.eu-S1750895AbXBKVgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750895AbXBKVgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 16:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbXBKVgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 16:36:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:52538 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbXBKVgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 16:36:11 -0500
Subject: Re: remote debugging via FireWire
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andi Kleen <ak@suse.de>, Bernhard Kaindl <bk@suse.de>, discuss@x86-64.org,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <45CE19F3.2070603@s5r6.in-berlin.de>
References: <200702101242.48467.ak@suse.de> <200702101502.59431.ak@suse.de>
	 <45CDE14C.4040203@s5r6.in-berlin.de> <200702101641.36239.ak@suse.de>
	 <45CE19F3.2070603@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 08:35:38 +1100
Message-Id: <1171229738.20494.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-10 at 20:16 +0100, Stefan Richter wrote:
> [ohci1394_early]
> 
> Some remarks to the September 2006 version at
> http://www.suse.de/~bk/firewire/ :
> 
>   - Seems its .remove won't work properly if more than one OHCI-1394
>     controller is installed.  And it's .probe isn't reentrant, but that
>     might be less of a problem.
>   - Its functionality will be lost if there is a FireWire bus reset,
>     e.g. when something is plugged in or out.  To keep physical DMA
>     alive, an interrupt handler had to be installed which writes ~0
>     to OHCI1394_PhyReqFilter{Hi,Lo}Set.  Can interrupt handlers be
>     registered in an early setup stage?
>   - There might be some register accesses in the setup which could be
>     omitted; I'd have to look this up.
>   - Could be optimized to not use ohci1394.h::struct ti_ohci.
>   - PCI_CLASS_FIREWIRE_OHCI can be replaced by
>     include/linux/pci_ids.h::PCI_CLASS_SERIAL_FIREWIRE_OHCI which
>     was newly added in 2.6.20-git#.
>   - I suppose .probe should check for PCI_CLASS_SERIAL_FIREWIRE_OHCI
>     instead of PCI_CLASS_SERIAL_FIREWIRE.
>   - How about dropping support for configuring this as module, to
>     simplify the code?  Unless this would interfere with ohci1394; and
>     it probably would if there was an interrupt handler...
>   - "depends on X86_64" is missing in Kconfig.
>   - Maybe put it into arch/x86_64/drivers/ instead of drivers/ieee1394?
>   - Plus what I mentioned earlier in the thread.
> 
> I could send code to address some of this at next weekend or later.

I'd like to have that on ppc as well, so I'd rather keep it in drivers/

I agree that it doesn't need to be a module. If you can load modules,
then you can load the full ohci driver. Thus, if it's an early thingy
initialized by arch, it can export a special "takeover" hook that the
proper ohci module can then call to override it (important if we start
having an irq handler).

Andi, also, how do you deal with iommu ? Not at all ? :-)

Ben.


