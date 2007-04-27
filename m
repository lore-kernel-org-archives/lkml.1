Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbXD1AAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbXD1AAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 20:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757934AbXD0X7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:59:45 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757930AbXD0X7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:59:42 -0400
Date: Fri, 27 Apr 2007 16:59:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <200704280145.26253.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.98.0704271647340.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704280041.17617.rjw@sisk.pl>
 <alpine.LFD.0.98.0704271612380.9964@woody.linux-foundation.org>
 <200704280145.26253.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:
>
> Actually, the less things happen while we're creating and saving the image,
> the less sources of potential problems there are and by freezing the kernel
> threads (not all of them), we cause less things to happen at that time.

That makes no sense.

You have to create the snapshot image with interrupts disabled *anyway*.

I really don't see how you can say that stopping threads etc can make any 
difference what-so-ever. If you don't create the snapshot with interrupts 
disabled (and just with a single CPU running) you have so many other 
problems that it's not even remotely funny.

So there's *by*definition* nothing at all that can happen while you 
snapshot the system. Claiming otherwise is just silly.

> To make you happy, we could stop doing that, but what actual _advantage_
> that would bring?

Like getting rid of all the magic "I don't want you to freeze me" crud? 

Or getting rid of this horribly idiotic "three times widdershins" kind of 
black magic mentality! It looks like the main reason for the process 
freezing has nothing to do with technology, but some irrational fear of 
other things happening at the same time, even though they CANNOT happen if 
you do things even half-way sanely.

The "let's stop all kernel threads" is superstition. It's the same kind of 
superstition that made people write "sync" three times before turning off 
the power in the olden times. It's the kind of superstition that comes 
from "we don't do things right, so let's be vewy vewy quiet and _pray_ 
that it works when we are beign quiet".

That's bad.

It's doubly bad, because that idiocy has also infected s2ram. Again, 
another thing that really makes no sense at all - and we do it not just 
for snapshotting, but for s2ram too. Can you tell me *why*?

> > Trying to freeze kernel threads has _caused_ problems. It has _added_ 
> > these interdependencies. It hasn't removed a single dependency at any 
> > time, it has just added new problems!
> 
> What problems are you talking about?

Like you wouldn't know. Look at commit b43376927a that you yourself are 
credited with, just a month ago. 

Then, do something as simple as

	git grep create_freezeable_workthread

and ponder the end results of that grep. If you don't see something wrong, 
you're blind.

> > NONE of these are valid explanations at all. You're listing totally 
> > theoretical problems, and ignoring all the _real_ problems that trying to 
> > freeze kernel threads has _caused_.
> 
> Example, please?

Who do you think you are kidding? See above.

And if you think that's an isolated example, look again. And start 
grepping for PF_NOFREEZE, and other examples.

The fact is, there is not a *single* reason to freeze kernel threads. But 
some rocket scientist decided to, and then screwed everybody else over.

			Linus
