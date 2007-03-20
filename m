Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbXCTQAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbXCTQAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbXCTQAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:00:09 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57354 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbXCTQAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:00:06 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Artem Bityutskiy <dedekind@infradead.org>, Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070320135231.GA6043@thunk.org>
References: <20070318162720.GI10459@waste.org>
	 <1174236579.17249.6.camel@sauron> <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org> <1174338393.17249.53.camel@sauron>
	 <20070319213628.GW4892@waste.org> <1174393549.17249.101.camel@sauron>
	 <20070320135231.GA6043@thunk.org>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 10:59:55 -0500
Message-Id: <1174406395.30079.139.camel@zod.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 09:52 -0400, Theodore Tso wrote:
> As a suggestion, let's stop right here and see if we can get both
> sides talking in a more constructive fashion.  Maybe it's just me, but
> I see both sides talking past each other in a rather dramatic fashion.

Perhaps, yes.  Though I've been trying to be open to Matt's suggestions.
Please don't mistake confusion for hostility.

> There a number of red herrings that have been introduced in this
> discussion; of *course* the existing block device layer can handle
> FLASH devices; Matt is proposing that they be extended.  And of

Sure.  But the larger question is *should* it be extended to do so.

> *course* you woulnd't propose to use ext2 on top of an 128k blocksize,
> anymore than you would force a flash filesystem to use a 4k or 512
> byte blocksize; there are plenty of configurations that won't make

Except that flash filesystems don't use block devices at all.  They use
MTD interfaces.

> sense, and by itself this isn't an indictment of the core idea that
> the block device layer and dm should be augmented to encompass flash
> functionality.

This is where the concept starts to lose me.  Augmented how?  To not use
MTD at all (obviously with the exception of the low-level flash
drivers)?  How is that not going to duplicate MTD?  Etc, etc.

Look at it from this point of view.  MTD is the existing interface for
dealing with flash devices.  UBI was written to solve issues with flash
devices.  UBI was written on top of MTD.  Suggesting that the UBI
developers go off and hack the block layer to work with flash devices
just to use dm seems completely foreign.  Most of the boards UBI is used
on disable the block layer as much as they can because it's not needed.

This is the biggest source of confusion/contention.  Making the somewhat
magical jump to representing flash as a block device without a bit more
detail as to how it's going to really cope with the requirements needed
for flash and why it's a great idea to do so is a bit hard to swallow.
Discussing the device mapper extensions is sort of pointless until this
is figured out.

> high-level architecture of what UBI is trying to achieve.  What are
> the interfaces at the top and the bottom of the stack?  For example,
> the fact that UBI exports Logical Erase blocks that are not a
> power-of-two (possibly 128k minus 128 bytes) means that it certainly
> might not be a good match for the dm stack.  But why is that the case?
> I can imagine good reasons for it, but a high-level description of the
> design decisions would be very useful.

Basically because you need to store metadata in each eraseblock (and not
in OOB).  That metadata consumes space reducing the usable storage in
each eraseblock by an amount and making it no longer a power-of-two.

> It would also help people understand why there are so many "units" in
> UBI, since hopefully the high-level documentation would explain why
> they fit together, and perhaps why some of the units weren't folded
> together.  What value do they add as separate components?

Artem is reworking the units per your (and other's) suggestions.  The
debugging code is also being worked on.

> There are hints of the overall system architecture in some of the
> indivdual comments for data structures, but even reading all of those,
> there isn't quite enough for people to figure out what it is; and that
> may be causing some of these comments of people saying there's too
> much code to evaluate, or why didn't you do it *this* way?   

Some of that can probably be added, sure.  Though to be fair, it'll add
even more lines to the patch and those links have been posted 4 times
already.  They're even posted at the start of _this_ thread.  Having it
in the patch under Documentation/ is a good idea, but you can't force
people to read that before they comment on things.

josh

