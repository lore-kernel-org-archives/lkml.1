Return-Path: <linux-kernel-owner+w=401wt.eu-S1761175AbYDKSwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761175AbYDKSwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 14:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760299AbYDKSwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 14:52:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760281AbYDKSwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 14:52:21 -0400
Date: Fri, 11 Apr 2008 11:51:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Christoph Hellwig <hch@infradead.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>,
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
In-Reply-To: <20080411175304.GF11962@parisc-linux.org>
Message-ID: <alpine.LFD.1.00.0804111146450.3143@woody.linux-foundation.org>
References: <47FD2325.2030705@intel.com> <47FE5C89.5060209@intel.com> <20080410192714.GA14055@elte.hu> <47FE8566.5040809@intel.com> <20080411112653.GC9205@elte.hu> <20080411113644.GA7767@infradead.org> <20080411121606.GA25661@elte.hu> <47FF9060.5040202@intel.com>
 <20080411164542.GA4066@infradead.org> <alpine.LFD.1.00.0804111028540.3143@woody.linux-foundation.org> <20080411175304.GF11962@parisc-linux.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Apr 2008, Matthew Wilcox wrote:
> 
> I think it's a little over-engineered ... why not simply:

Because your version has exactly the same problem that the current code 
has: it asks questions that aren't sensible to people who don't care. It 
also keeps the old E1000 name for "PCI chips only", which means that 
people who just use an old config and ignore new questions will suddenly 
lose their ability to use the E1000 driver if they have a PCI-E card.

So most users:
 - want to just say "E1000", and not care about type.
 - want to have old configurations continue working (ie if you haev had 
   "E1000" driving your hardware before, it should _continue_ to do so, 
   with no need to select a _new_ E1000E question!

Nobody wants to care deeply whether it's a PCI-E or PCI chip. In fact, 
it's almost impossible to tell. Here, quickly, tell me which one mine is 
(this is from /sbin/lspci):

	00:19.0 Ethernet controller: Intel Corporation 82566DM Gigabit Network Connection (rev 02)

and tell me how you knew..

		Linus
