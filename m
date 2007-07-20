Return-Path: <linux-kernel-owner+w=401wt.eu-S935752AbXGTVgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935752AbXGTVgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935731AbXGTVfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:35:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39969 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbXGTVfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:35:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Fri, 20 Jul 2007 23:43:28 +0200
User-Agent: KMail/1.9.5
Cc: Jim Crilly <jim@why.dont.jablowme.net>, Milton Miller <miltonm@bga.com>,
       linux-pm <linux-pm@lists.linuxfoundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm> <20070720152744.GH20529@grifter.jdc.home> <Pine.LNX.4.64.0707200835380.19248@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707200835380.19248@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707202343.29307.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 20 July 2007 17:36, david@lang.hm wrote:
> On Fri, 20 Jul 2007, Jim Crilly wrote:
> 
> >>> has
> >>> requested the image to be not greater than 50% of RAM.  In that case you
> >>> have
> >>> to free some memory _before_ identifying memory to save and you must not
> >>> race with applications that attempt to allocate memory while you're doing
> >>> it.
> >>
> >> I disagree a little bit.
> >>
> >> first off, only the suspending kernel can know what can be freed and what
> >> is needed to do so (remember this is kernel internals, it can change from
> >> patch to patch, let alone version to version)
> >>
> >> second, if you have a lot of memory to free, and you can't just throw away
> >> caches to do so, you don't know what is going to be involved in freeing
> >> the memory, it's very possilbe that it is going to involve userspace, so
> >> you can't freeze any significant portion of the system, so you can't
> >> eliminate all chance of races
> >>
> >> what you can do is
> >>
> >> 1. try to free stuff
> >> 2. stop the system and account for memory, is enough free
> >> if not goto 1
> >>
> >> if userspace is dirtying memory fast enough, or is just useing enough
> >> memory that you can't meet your limit you just won't be able to suspend.
> >>
> >> but under any other conditions you will eventually get enough memory free.
> >>
> >> so try several times and if you still fail tell the user they have too
> >> much stuff running and they need to kill something.
> >
> > Which would be a pretty big regression from what we have now. With the
> > current implementation I can hibernate under virtually any workload because
> > the freezer stops everything and there's no competition for resources.
> 
> as long as what you are trying to save is <=50% of ram (at least with some 
> implementations). if you are trying to save more then 50% of ram with some 
> current implmenetations you just can't

With some, you can't, with the others, you can. :-)

The argument given was about the freezer and IMO it was valid.

Why didn't you address it directly?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
