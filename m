Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbYAGMQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbYAGMQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 07:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbYAGMP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 07:15:56 -0500
Received: from gir.skynet.ie ([193.1.99.77]:45197 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbYAGMPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 07:15:55 -0500
Date: Mon, 7 Jan 2008 12:15:51 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-kernel@vger.kernel.org, Bob Picco <bob.picco@hp.com>,
       Dave Hansen <haveblue@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>,
       Andi Kleen <ak@muc.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Keith Mannthey <kmannth@gmail.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@osdl.org>, ralf@linux-mips.org
Subject: Re: [PATCH] Fix crash with FLAT_MEMORY and ARCH_PFN_OFFSET != 0
Message-ID: <20080107121551.GD29254@csn.ul.ie>
References: <20071218120300.7565AE3030@solo.franken.de> <20071218135828.GB24917@csn.ul.ie> <20071218160938.GA20688@alpha.franken.de> <20071220114405.GA9623@csn.ul.ie> <20071220124351.GA8880@alpha.franken.de> <20071220132719.GA29857@csn.ul.ie> <20071230113713.GA9434@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20071230113713.GA9434@alpha.franken.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (30/12/07 12:37), Thomas Bogendoerfer didst pronounce:
> On Thu, Dec 20, 2007 at 01:27:20PM +0000, Mel Gorman wrote:
> > On (20/12/07 13:43), Thomas Bogendoerfer didst pronounce:
> > > On Thu, Dec 20, 2007 at 11:44:06AM +0000, Mel Gorman wrote:
> > > > --- a/include/asm-mips/page.h
> > > > +++ b/include/asm-mips/page.h
> > > > @@ -37,13 +37,6 @@
> > > >  #include <linux/pfn.h>
> > > >  #include <asm/io.h>
> > > >  
> > > > -/*
> > > > - * It's normally defined only for FLATMEM config but it's
> > > > - * used in our early mem init code for all memory models.
> > > > - * So always define it.
> > > > - */
> > > > -#define ARCH_PFN_OFFSET		PFN_UP(PHYS_OFFSET)
> > > > -
> > > 
> > > hmm, doesn't this break what I've fixed ? Without this #define
> > > ARCH_PFN_OFFSET gets defined to 0 and the bug is back. Or did
> > > I miss anything ?
> > > 
> > 
> > ARCH_PFN_OFFSET goes to 0, so page_to_pfn() is no longer adjusting by
> > PFN_UP(PHYS_OFFSET) like it was when your problem occured. I am guessing
> > that the nature of the crash was that page_to_pfn() was returning bogus
> > values early in boot and trying to initialise memmap that didn't exist.
> 
> ic, your patch works for me.
> 

Grand. For the moment, your patch is the correct fix. This is a
micro-optimisation that can be picked up again at a later date. Thanks
for the testing and the fix.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
