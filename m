Return-Path: <linux-kernel-owner+w=401wt.eu-S932236AbZJLUaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbZJLUaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZJLU37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:29:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:39233 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbZJLU37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:29:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,547,1249282800"; 
   d="scan'208";a="198061481"
Subject: Re: 2.6.32-rc4: Reported regressions from 2.6.31
From: David Woodhouse <david.woodhouse@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
In-Reply-To: <alpine.LFD.2.01.0910121028040.3438@localhost.localdomain>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
	 <alpine.LFD.2.01.0910111554400.3438@localhost.localdomain>
	 <1255342738.24732.265.camel@macbook.infradead.org>
	 <alpine.LFD.2.01.0910120725350.3438@localhost.localdomain>
	 <1255362962.32729.63.camel@macbook.infradead.org>
	 <alpine.LFD.2.01.0910121028040.3438@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation. Pipers Way, Swindon, Wiltshire, SN3 1RJ,
 UK.
Date: Mon, 12 Oct 2009 21:29:19 +0100
Message-Id: <1255379359.32729.625.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 18:35 +0100, Linus Torvalds wrote:
> 
> On Mon, 12 Oct 2009, David Woodhouse wrote:
> > 
> > > The other solution would be to just _enable_ (and do all the setup) of the 
> > > IOMMU early. And then just leave a legacy mapping for the IOMMU, and then 
> > > _after_all_devices_are_set_up_ can you then remove the legacy mapping.
> > 
> > That involves allocating a _shitload_ of page tables for a 1:1 mapping
> > of all of physical memory.
> 
> I don't think that's true.
> 
> Nobody cares about "all physical memory". For one thing, we know that 
> anything that we consider to be normal memory (ie it's listed in the e820 
> tables as RAM) can't be all that interesting, since the BIOS definitely 
> released that to us.

Yeah, that's probably true. I was thinking of the 1:1 mappings we set up
for crappy drivers under Linux, which do need access to all of memory
and don't use the DMA API correctly. This is different, though.

We have talked about dma-mapping all of E820-reserved memory, but that
would allow a rogue device to scribble over arbitrary bits of memory
belonging to the BIOS, which isn't necessarily such a good thing. Even
if we did tear it down as soon as a real driver came along, the TXT
folks would still object -- and rightly so.

As you said, it's sufficient just to enable the IOMMU after the quirks
have run. So the patches I posted earlier should be just fine.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

