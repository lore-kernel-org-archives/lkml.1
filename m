Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbXI1RQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbXI1RQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 13:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXI1RQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 13:16:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33258 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbXI1RQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:16:41 -0400
Date: Thu, 27 Sep 2007 16:13:44 -0700
From: Greg KH <greg@kroah.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jesse Barnes <jesse.barnes@intel.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PCI: Fix boot-time hang on G31/G33 PC
Message-ID: <20070927231344.GD869@kroah.com>
References: <20070826015556.GC14130@parisc-linux.org> <200709261455.56165.jesse.barnes@intel.com> <20070926215648.GA24505@kroah.com> <200709261520.40859.jesse.barnes@intel.com> <20070927183129.A17565@jurassic.park.msu.ru> <46FBF830.9000704@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FBF830.9000704@intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 11:36:32AM -0700, Kok, Auke wrote:
> Ivan Kokshaysky wrote:
> > On Wed, Sep 26, 2007 at 03:20:40PM -0700, Jesse Barnes wrote:
> >> Ivan, your concern is about disabling things like interrupt controllers 
> >> and power management chips during probe right?  You're right that doing 
> >> that could cause problems if we get and interrupt or PMU event at just 
> >> the wrong time, but that could just as easily happen if decode was 
> >> still enabled but the BAR had a bogus address programmed (as it would 
> >> during probing).
> > 
> > Yes, nobody is arguing that moving the BAR around is unsafe, but generally
> > it's the less of two evils.
> > 
> > The major problem here is that with IO and MEM bits cleared in the command
> > register you disable *all* address decoders on the device, not just ranges
> > that have respective BARs. At least this behaviour is required by PCI spec.
> > Examples:
> > - legacy VGA IO and memory (no corresponding BARs);
> > - base/limit registers of P2P bridge;
> > - PMU and SMBus registers (sort of normal BARs, but hidden elsewhere
> >   in the config space);
> > - IDE legacy mode registers;
> > - IO-APIC registers (typically sort of read-only BAR).
> > 
> > For all of these address ranges our current BAR probe is effectively
> > a no-op, but disable/re-enable clearly isn't.
> > 
> >> Ultimately, I don't care much one way or another as long as we can get 
> >> the desktop platforms fixed somehow.  I think disabling decode is the 
> >> most correct way of doing this, but I'm open to other solutions (this 
> >> is the only patch I've seen though that's been tested to solve the 
> >> problem).
> > 
> > There are two other solutions: one is to disable decode selectively,
> > only on devices or systems where it's necessary and known to be safe.
> > I've posted a patch which introduces "disable_while_probe" pci_dev field
> > for that purpose.
> > Another one is to delay mmconfig probe until after the PCI probe is done,
> > as Matthew suggested, and Robert confirmed that it's feasible.
> 
> 
> for everyone who's using this quirk or has the same boot issue: I just confirmed
> that the new dg33tl bios update v0287 (released 9/20) fixes the boot issue for my
> systems. I encourage everyone to update their BIOS image and see if this works.

Thanks for letting us know.  So, another reason to drop this patch :)

thanks,

greg k-h
