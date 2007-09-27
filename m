Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbXI0Sgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbXI0Sgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 14:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbXI0Sgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 14:36:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:55075 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612AbXI0Sgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 14:36:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,204,1188802800"; 
   d="scan'208";a="234313222"
Message-ID: <46FBF830.9000704@intel.com>
Date: Thu, 27 Sep 2007 11:36:32 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Jesse Barnes <jesse.barnes@intel.com>, Greg KH <greg@kroah.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>,
       Matthew Wilcox <matthew@wil.cx>, "Li, Shaohua" <shaohua.li@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PCI: Fix boot-time hang on G31/G33 PC
References: <20070826015556.GC14130@parisc-linux.org> <200709261455.56165.jesse.barnes@intel.com> <20070926215648.GA24505@kroah.com> <200709261520.40859.jesse.barnes@intel.com> <20070927183129.A17565@jurassic.park.msu.ru>
In-Reply-To: <20070927183129.A17565@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Sep 2007 18:36:42.0679 (UTC) FILETIME=[59843470:01C80135]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> On Wed, Sep 26, 2007 at 03:20:40PM -0700, Jesse Barnes wrote:
>> Ivan, your concern is about disabling things like interrupt controllers 
>> and power management chips during probe right?  You're right that doing 
>> that could cause problems if we get and interrupt or PMU event at just 
>> the wrong time, but that could just as easily happen if decode was 
>> still enabled but the BAR had a bogus address programmed (as it would 
>> during probing).
> 
> Yes, nobody is arguing that moving the BAR around is unsafe, but generally
> it's the less of two evils.
> 
> The major problem here is that with IO and MEM bits cleared in the command
> register you disable *all* address decoders on the device, not just ranges
> that have respective BARs. At least this behaviour is required by PCI spec.
> Examples:
> - legacy VGA IO and memory (no corresponding BARs);
> - base/limit registers of P2P bridge;
> - PMU and SMBus registers (sort of normal BARs, but hidden elsewhere
>   in the config space);
> - IDE legacy mode registers;
> - IO-APIC registers (typically sort of read-only BAR).
> 
> For all of these address ranges our current BAR probe is effectively
> a no-op, but disable/re-enable clearly isn't.
> 
>> Ultimately, I don't care much one way or another as long as we can get 
>> the desktop platforms fixed somehow.  I think disabling decode is the 
>> most correct way of doing this, but I'm open to other solutions (this 
>> is the only patch I've seen though that's been tested to solve the 
>> problem).
> 
> There are two other solutions: one is to disable decode selectively,
> only on devices or systems where it's necessary and known to be safe.
> I've posted a patch which introduces "disable_while_probe" pci_dev field
> for that purpose.
> Another one is to delay mmconfig probe until after the PCI probe is done,
> as Matthew suggested, and Robert confirmed that it's feasible.


for everyone who's using this quirk or has the same boot issue: I just confirmed
that the new dg33tl bios update v0287 (released 9/20) fixes the boot issue for my
systems. I encourage everyone to update their BIOS image and see if this works.

Cheers,

Auke
