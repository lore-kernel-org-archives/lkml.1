Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbYDKMQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbYDKMQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 08:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbYDKMQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 08:16:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58893 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbYDKMQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 08:16:42 -0400
Date: Fri, 11 Apr 2008 14:16:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, Jeff Garzik <jeff@garzik.org>,
       Matthew Wilcox <matthew@wil.cx>,
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
Message-ID: <20080411121606.GA25661@elte.hu>
References: <47FBD34A.6080508@garzik.org> <20080408203314.GA28952@elte.hu> <47FBDBE9.9040700@garzik.org> <20080409193850.GA11763@elte.hu> <47FD2325.2030705@intel.com> <47FE5C89.5060209@intel.com> <20080410192714.GA14055@elte.hu> <47FE8566.5040809@intel.com> <20080411112653.GC9205@elte.hu> <20080411113644.GA7767@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411113644.GA7767@infradead.org>
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


* Christoph Hellwig <hch@infradead.org> wrote:

> And this is not really comparable to the libata transition at all, 
> there's no user-visible changed. [...]

well it was Auke who compared it to the libata transition not me ...

> [...] For every distro kernel that just builds both driver it's a 
> completely seamless transition, and for people who build their own 
> kernel we should find some Kconfig trickery to make the transition 
> easier.  For example we could just built e1000e when CONFIG_E1000 is 
> set and spill a warning that starting from 1.1.2009 you will have to 
> have CONFIG_E1000E set aswell.

firstly, a good deal of our alpha testers use =y drivers. Secondly, your 
kind of constructive email is exactly what i wanted to see in the first 
place...

i dont really care _how_ this gets solved - i'm not maintaining this 
code. What forced me to deal with it was this outright denial of my 
problem, the ridiculing and NACK-ing of it and general stonewalling.

I'd have preferred to have sent only my first report. The networking 
driver guys on the other hand:

 1) forced me to send a full bugreport about something that i described
    adequately in my very first mail already, and which they should have
    immediately recognized, based on the trouble they had with Linus. (i
    wasnt aware of that back when i made my report)

 2) repeatedly denied that there is any problem. Claimed that "this is a 
    careful migration balance we decided" and other babbling.

 3) forced me to write a patch for code they are supposed to be 
    maintaining to actually get things moving.

 4) moved the regression bugzilla entry to REJECTED+INVALID without 
    actually resolving the bug and forced me to write several comments 
    there too. (See http://bugzilla.kernel.org/show_bug.cgi?id=10427)

 5) forced me to write 20 mails with still no clear resolution yet at
    this point.

it's insane and i'm really curious what kind of language you'd use in 
your replies if i ever forced you through such an excercise in arch/x86 
or the scheduler ;-)

and no, it wasnt a case of miscommunication. My bug was i think 
well-understood in the very first mailings already, but it was 
discounted as unimportant and resolution was delayed all the way up 
until this point. That shows fundamental insensitivity to bug reporters 
which is more worrisome than the bug itself (the bug is fairly minor and 
i never claimed otherwise).

Hours of my time wasted on something that should have been a 2 minutes 
matter - and yes, as i go through these chores i do get increasingly 
annoyed about it, and rightfully so. I cannot just let this happen 
silently, way too much crap like this gets pulled off. If the networking 
driver guys are pulling off a show like that with a fellow kernel 
developer how do they manage to deal with plain users (who, in 
comparison, are in essence defense-less against rejections from 
maintainers)?

and yes, moving those IDs over into e1000e in v2.6.26 might work out 
fine in the end, if the migration is all totally problem free up to that 
point. We simply cannot make that determination right now. What exactly 
is so hard to understand about the concept of not degrading the quality 
of an existing, rather well-working driver?

	Ingo
