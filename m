Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbYDJT3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbYDJT3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 15:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758556AbYDJT3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 15:29:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45073 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758552AbYDJT3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 15:29:41 -0400
Date: Thu, 10 Apr 2008 21:27:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch] e1000=y && e1000e=m regression fix
Message-ID: <20080410192714.GA14055@elte.hu>
References: <20080408193245.GG11962@parisc-linux.org> <20080408195123.GA28148@elte.hu> <47FBCE00.2020309@garzik.org> <20080408200652.GC28148@elte.hu> <47FBD34A.6080508@garzik.org> <20080408203314.GA28952@elte.hu> <47FBDBE9.9040700@garzik.org> <20080409193850.GA11763@elte.hu> <47FD2325.2030705@intel.com> <47FE5C89.5060209@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FE5C89.5060209@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kok, Auke <auke-jan.h.kok@intel.com> wrote:

> >>  config E1000E_ENABLED
> >> -	def_bool E1000E != n
> >> +	def_bool E1000E = y || ((E1000E != n) && (E1000 = E1000E))
> 
> > Uh, that's /not/ what Ingo's patch does.  His patch makes e1000 
> > claim the e1000e IDs if e1000 is built-in and e1000e is a module.
> 
> so that's definately _not_ what I would like to see at all. Matthew 
> points out that this will just prolong users to use e1000 instead of 
> e1000e (which is what they should be encouraged to switch to in those 
> cases).
> 
> so I'm dropping my ACK

why you want to cripple an existing, rather well working and popular 
Linux driver is beyond me.

You have a wide array of measures if you want to migrate users to the 
new and shiny e1000e driver: you can stop adding _new_ IDs to the old 
driver, you can unsupport it, you can claim that it wont work in certain 
situations, you can print out messages to the user in the dmesg (if 
those messages are true), you can even remove IDs from it if the user 
has the new driver enabled.

But what you cannot do is to intentionally cripple a popular driver. 
It's plain stupid. It does not matter how many times you've announced 
it, it's still madness. Unless your goal is to reduce the Linux userbase 
as quickly as possible that is ... ;-)

And please understand: _you_ are the maintainer of this code so 
_please_, if you wish to do so, solve the problem differently, but dont 
just stand there _talking_. I gave you ample feedback about what the 
problem is (which you initially denied to even exist) and i even wrote a 
patch. You might never use e1000=y && e1000e=m or e1000=y && e1000e=n 
but i do. Guys, the ball is in your court now.

> this patch doesn't solve anything [...]

huh? How can you claim that?? It definitely solved my problem. Did you 
miss that aspect of my patch?

> [...] and we'll have the same issue back when 2.6.26 ships which will 
> have no PCI Express device IDs in e1000.

... and not changing existing behavior for a perfectly well working 
system is exactly what compatibility and smooth migration is about. New 
drivers need several kernel releases to be fully known, to be fully 
trusted and to be fully accepted and integrated - and not the least, to 
be fully tested ...

These are all well-known principles. It's nothing new at all and there's 
nothing special about it: dont break existing drivers and setups and 
dont create silent side-effects between drivers.

	Ingo
