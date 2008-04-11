Return-Path: <linux-kernel-owner+w=401wt.eu-S1759227AbYDKJZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbYDKJZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 05:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758441AbYDKJZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 05:25:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55897 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758607AbYDKJZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 05:25:20 -0400
Date: Fri, 11 Apr 2008 11:24:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com
Subject: Re: [bug] mm/slab.c boot crash in -git, "kernel BUG at
	mm/slab.c:2103!"
Message-ID: <20080411092452.GE10801@elte.hu>
References: <20080411074145.GA4944@elte.hu> <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com> <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com> <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com> <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com> <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Fri, Apr 11, 2008 at 12:05 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> >  >  Right. Then you probably want to look into any changes in arch/x86/
> >  >  related to setting up the zonelists. I'm fairly certain this is not a
> >  >  slab bug and I don't see any recent changes to the page allocator
> >  >  either that would explain this.
> >
> >  I'd be willing to put some money on this:
> >
> >  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b7ad149d62ffffaccb9f565dfe7e5bae739d6836
> 
> And I'd lose as you're 32-bit. Oh well, that's the price to pay for 
> pretending to know x86 arch internals.

yeah, sorry - we are working hard to unify generic bits like that, but 
it's a huge architecture.

btw., i always felt that the zone/memory setup is rather fragile and 
ad-hoc in places and it trusts the architecture code too much. Just in 
the .25 cycle i've seen about a dozen bugs all around that thing. I 
believe we should work on making the info that an architecture feeds to 
the MM "fool proof" - i.e. sanity-check for overlaps and other common 
setup errors. It is easy for an architecture to mess up those things... 
Especially on oddball systems that are too large or too small to be 
normally tested. It's a common, reoccuring bug pattern that we could 
avoid by being a bit more resilient.

if this is a zone setup bug then a sanity-check could catch it right 
where it happens - not much later in the slab code or so.

	Ingo
