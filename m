Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbYDKXo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbYDKXo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 19:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbYDKXoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 19:44:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48499 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228AbYDKXoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 19:44:16 -0400
Message-ID: <47FFF7B5.3000609@garzik.org>
Date: Fri, 11 Apr 2008 19:43:49 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Daniel Barkalow <barkalow@iabervon.org>,
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
References: <47FBDBE9.9040700@garzik.org> <20080409193850.GA11763@elte.hu> <47FD2325.2030705@intel.com> <47FE5C89.5060209@intel.com> <20080410192714.GA14055@elte.hu> <47FE8566.5040809@intel.com> <20080411112653.GC9205@elte.hu> <20080411113644.GA7767@infradead.org> <20080411121606.GA25661@elte.hu> <47FF9060.5040202@intel.com> <20080411164542.GA4066@infradead.org> <alpine.LFD.1.00.0804111028540.3143@woody.linux-foundation.org> <alpine.LNX.1.00.0804111700550.19665@iabervon.org> <alpine.LFD.1.00.0804111556200.3143@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0804111556200.3143@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> .. but that said, I think your patch is certainly better than what we have 
> now (or what Ingo was complaining about for the next merge window). I 
> certainly could live with it. I would just suggest against ever then 
> removing that "generic E1000" choice.


You mean never ever remove PCI-E support from e1000?

Won't that will inflict long term headaches on the people that matter 
most -- users and maintainers -- to avoid short term headaches for 
kernel power users?

To review the overall situation,

* e1000 supports so many chips, that making a change for new hardware in 
e1000 involves breaking stability of older chips

* //You know this// from past kernel history, when late-breaking e1000 
changes for new hardware wound up breaking working setups on multiple 
occasions

* There is 100% agreement that e1000 is a maintenance nightmare, from 
the people who actually touch the code (or even read it).

* Therefore, e1000e receives new h/w support and new devel, leaving 
e1000 to sit and be stable


However, due to a mistake now released to the public -- a tiny few PCI-E 
chips are supported by e1000 -- you have a widely disparate feature set:

	e1000, old chips:		full support

	e1000, a few PCI-E chips:	basic support

	e1000e, all PCI-E chips:	full support

Since e1000e is all new and fancy AND CLEAN, the code for the same chips 
is different -- thus Intel must make every PCI-E fix _twice_.

It also means WE HAVE TO KEEP TOUCHING E1000, while supporting PCI-E 
chips.  After this PCI-E issue is resolved, I want to let e1000 sit and 
be stable and not be touched.

For a temporary situation, this is fine.  Give me transition 
suggestions, please!

For a permanent situation, that sucks.

Distros will ship e1000 sans PCI-E support, which means you are asking 
that PCI-E support be maintained indefinitely, purely for the few kernel 
hackers that still use it?

I __don't care__ how we get there, but a permanent situation where e1000 
continues to support a few PCI-E chips in basic mode seems the least 
desireable of all available options.

Wait six months?  Sure.  Whatever.  As long as we get to where we can 
disable PCI-E support in e1000.

	Jeff




