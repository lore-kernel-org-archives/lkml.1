Return-Path: <linux-kernel-owner+w=401wt.eu-S1760810AbXLTN1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760810AbXLTN1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758845AbXLTN11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:27:27 -0500
Received: from gir.skynet.ie ([193.1.99.77]:52391 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758139AbXLTN10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:27:26 -0500
Date: Thu, 20 Dec 2007 13:27:20 +0000
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
Message-ID: <20071220132719.GA29857@csn.ul.ie>
References: <20071218120300.7565AE3030@solo.franken.de> <20071218135828.GB24917@csn.ul.ie> <20071218160938.GA20688@alpha.franken.de> <20071220114405.GA9623@csn.ul.ie> <20071220124351.GA8880@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20071220124351.GA8880@alpha.franken.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (20/12/07 13:43), Thomas Bogendoerfer didst pronounce:
> On Thu, Dec 20, 2007 at 11:44:06AM +0000, Mel Gorman wrote:
> > --- a/include/asm-mips/page.h
> > +++ b/include/asm-mips/page.h
> > @@ -37,13 +37,6 @@
> >  #include <linux/pfn.h>
> >  #include <asm/io.h>
> >  
> > -/*
> > - * It's normally defined only for FLATMEM config but it's
> > - * used in our early mem init code for all memory models.
> > - * So always define it.
> > - */
> > -#define ARCH_PFN_OFFSET		PFN_UP(PHYS_OFFSET)
> > -
> 
> hmm, doesn't this break what I've fixed ? Without this #define
> ARCH_PFN_OFFSET gets defined to 0 and the bug is back. Or did
> I miss anything ?
> 

ARCH_PFN_OFFSET goes to 0, so page_to_pfn() is no longer adjusting by
PFN_UP(PHYS_OFFSET) like it was when your problem occured. I am guessing
that the nature of the crash was that page_to_pfn() was returning bogus
values early in boot and trying to initialise memmap that didn't exist.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
