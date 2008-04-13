Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYDMVOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYDMVOh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 17:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbYDMVO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 17:14:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190AbYDMVOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 17:14:25 -0400
Date: Sun, 13 Apr 2008 14:13:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Daniel Barkalow <barkalow@iabervon.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>,
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
In-Reply-To: <47FFF7B5.3000609@garzik.org>
Message-ID: <alpine.LFD.1.00.0804131410340.2982@woody.linux-foundation.org>
References: <47FBDBE9.9040700@garzik.org> <20080409193850.GA11763@elte.hu> <47FD2325.2030705@intel.com> <47FE5C89.5060209@intel.com> <20080410192714.GA14055@elte.hu> <47FE8566.5040809@intel.com> <20080411112653.GC9205@elte.hu> <20080411113644.GA7767@infradead.org>
 <20080411121606.GA25661@elte.hu> <47FF9060.5040202@intel.com> <20080411164542.GA4066@infradead.org> <alpine.LFD.1.00.0804111028540.3143@woody.linux-foundation.org> <alpine.LNX.1.00.0804111700550.19665@iabervon.org> <alpine.LFD.1.00.0804111556200.3143@woody.linux-foundation.org>
 <47FFF7B5.3000609@garzik.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Apr 2008, Jeff Garzik wrote:
> Linus Torvalds wrote:
> > .. but that said, I think your patch is certainly better than what we have
> > now (or what Ingo was complaining about for the next merge window). I
> > certainly could live with it. I would just suggest against ever then
> > removing that "generic E1000" choice.
> 
> You mean never ever remove PCI-E support from e1000?

No. I mean never ever remove the *configure* level thinking that "e1000 is 
e1000".

There is no sense in *ever* showing it as two drivers to users, because 
users do not see them as separate chipsets. They look identical, down to 
the part names.

If it's a single family, and users can't even easily tell whether they 
have version 1 or version 2 (PCI vs PCI-E), you shouldn't even ask them. 
You should literally ask them: "do you want e1000 support".

That's it.

Once you have asked them that, you can then decide "ok, if you *really* 
know what version of the chip you have, you can decide to only get limited 
driver support".

But that's a secondary thing from a user perspective.

See the patch I already sent out.

			Linus
