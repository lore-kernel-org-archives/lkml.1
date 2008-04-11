Return-Path: <linux-kernel-owner+w=401wt.eu-S1760259AbYDKXPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259AbYDKXPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 19:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758113AbYDKXPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 19:15:24 -0400
Received: from iabervon.org ([66.92.72.58]:41216 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757325AbYDKXPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 19:15:23 -0400
Date: Fri, 11 Apr 2008 19:15:21 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Christoph Hellwig <hch@infradead.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch] e1000=y && e1000e=m regression fix
In-Reply-To: <alpine.LFD.1.00.0804111556200.3143@woody.linux-foundation.org>
Message-ID: <alpine.LNX.1.00.0804111905420.19665@iabervon.org>
References: <47FBDBE9.9040700@garzik.org> <20080409193850.GA11763@elte.hu> <47FD2325.2030705@intel.com> <47FE5C89.5060209@intel.com> <20080410192714.GA14055@elte.hu> <47FE8566.5040809@intel.com> <20080411112653.GC9205@elte.hu> <20080411113644.GA7767@infradead.org>
 <20080411121606.GA25661@elte.hu> <47FF9060.5040202@intel.com> <20080411164542.GA4066@infradead.org> <alpine.LFD.1.00.0804111028540.3143@woody.linux-foundation.org> <alpine.LNX.1.00.0804111700550.19665@iabervon.org>
 <alpine.LFD.1.00.0804111556200.3143@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008, Linus Torvalds wrote:

> 
> 
> On Fri, 11 Apr 2008, Daniel Barkalow wrote:
> > 
> > Wouldn't it make more sense to turn E1000 into a option that does nothing 
> > except select both E1000E and E1000_PCI, and have those two be the options 
> > that build drivers?
> 
> Yes, that sounds fine too. Although you need to add a
> 
> 	depends on PCI
> 
> to the E1000 thing (because the "select" would not honor the dependencies 
> that E1000E and E1000_PCI have).

Oh, right.

> However:
> 
> > Then, after a while, we drop the E1000 option entirely
> 
> I agree we could, but as I tried to explain, I fundamentally don't think 
> we _should_.
> 
> Why should people _ever_ be asked about whether they want "E1000 PCI 
> support" vs "E1000 PCI-E" support, when it's almost impossible to tell 
> which kind of card you have?
> 
> In other words, I suspect that anybody who selects E1000 support would 
> actually want the "support both" case, and simply not care. Unless they 
> were _really_ deeply aware of their hardware.

Eh, they'll both default to Y on PCs individually, so it's only people who 
are turning unused stuff off who will even look, and they'll probably ask 
/sys/class/net/eth0/device/driver or lsmod.

	-Daniel
*This .sig left intentionally blank*
