Return-Path: <linux-kernel-owner+w=401wt.eu-S1751958AbXCTWDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbXCTWDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 18:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXCTWDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 18:03:36 -0400
Received: from THUNK.ORG ([69.25.196.29]:42897 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbXCTWDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 18:03:35 -0400
Date: Tue, 20 Mar 2007 18:03:12 -0400
From: Theodore Tso <tytso@mit.edu>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>, Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
Message-ID: <20070320220312.GC29493@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Matt Mackall <mpm@selenic.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Christoph Hellwig <hch@infradead.org>,
	David Woodhouse <dwmw2@infradead.org>
References: <20070318191812.GM4892@waste.org> <20070318203149.GC29295@crusty.rchland.ibm.com> <20070319170838.GP4892@waste.org> <1174328188.30079.46.camel@zod.rchland.ibm.com> <20070319195442.GT4892@waste.org> <1174338393.17249.53.camel@sauron> <20070319213628.GW4892@waste.org> <1174393549.17249.101.camel@sauron> <20070320135231.GA6043@thunk.org> <1174406395.30079.139.camel@zod.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174406395.30079.139.camel@zod.rchland.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 10:59:55AM -0500, Josh Boyer wrote:
> Sure.  But the larger question is *should* it be extended to do so.

Absolutely, and so let's focus on that.

> Except that flash filesystems don't use block devices at all.  They use
> MTD interfaces.

Yes, so that would be first issue.  We would need to change the flash
filesystems to the block interface issue, and expand the block device
to use MTD.  Now, maybe Matt is conversant about what would be
involved to do this, but I will admit to being MTD ignorant.  But if
that's there is a huge impendance mismatch right there, that that
might be enough to kill it right there.

> > high-level architecture of what UBI is trying to achieve.  What are
> > the interfaces at the top and the bottom of the stack?  For example,
> > the fact that UBI exports Logical Erase blocks that are not a
> > power-of-two (possibly 128k minus 128 bytes) means that it certainly
> > might not be a good match for the dm stack.  But why is that the case?
> > I can imagine good reasons for it, but a high-level description of the
> > design decisions would be very useful.
> 
> Basically because you need to store metadata in each eraseblock (and not
> in OOB).  That metadata consumes space reducing the usable storage in
> each eraseblock by an amount and making it no longer a power-of-two.

So this is probably a stupid question, but what drives the design
decision to store the metadata in-band instead of out-of-band (and you
don't have to answer me here; putting it in the overall system
architecture document is just as good, and probably better.  :-)

> > It would also help people understand why there are so many "units" in
> > UBI, since hopefully the high-level documentation would explain why
> > they fit together, and perhaps why some of the units weren't folded
> > together.  What value do they add as separate components?
> 
> Artem is reworking the units per your (and other's) suggestions.  The
> debugging code is also being worked on.

As I mentioned to you in IRC, in the future if there is pending
changes in response to reviewer comments, it might be a good idea to
mention that, so that reviewers know not make those comments again, or
worry that the comments had been ignored.

> > There are hints of the overall system architecture in some of the
> > indivdual comments for data structures, but even reading all of those,
> > there isn't quite enough for people to figure out what it is; and that
> > may be causing some of these comments of people saying there's too
> > much code to evaluate, or why didn't you do it *this* way?   
> 
> Some of that can probably be added, sure.  Though to be fair, it'll add
> even more lines to the patch and those links have been posted 4 times
> already.  They're even posted at the start of _this_ thread.  Having it
> in the patch under Documentation/ is a good idea, but you can't force
> people to read that before they comment on things.

Well, having spent some time looking at the FAQ's and all of the
comments kernel docs embedded in the header files and source files,
there are sections that I would move to an overall system architecture
documentation, but there is still a lot that was missing that makes it
hard to review the patches.  I'm sure a lot of it is my own ignorance,
but that's probably one of the challenges with the UBI layer; not as
more people have a basic background in say say scheduling or VM or
filesystem than there are people who have a basic background in flash
devices.

Regards,

						- Ted

