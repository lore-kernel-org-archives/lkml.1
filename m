Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbXDZXQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbXDZXQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbXDZXQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:16:48 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753569AbXDZXQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:16:47 -0400
Date: Thu, 26 Apr 2007 16:15:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: Back to the future.
In-Reply-To: <200704270008.19017.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.98.0704261608160.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
 <alpine.LFD.0.98.0704261021160.9964@woody.linux-foundation.org>
 <1177618081.4737.42.camel@nigel.suspend2.net>
 <200704270008.19017.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Apr 2007, Rafael J. Wysocki wrote:
> 
> Well, I think that much of what Linus is saying indicates that he hasn't tried
> to write any such thing himself. ;-)

That's definitely true. The only interaction I ever had with "hibernation" 
(and yes, we should just call it that) is when I was working on s2ram and 
cleaning up the PCI device suspend/resume in particular, and trying 
(_mostly_ successfully - I think I broke it once or twice mainly due to 
interactions with the console, but on the whole I think it mostly worked) 
to not break hibernation in the process without actually running it.

> Now that I know much more than before, I can say I agree with Linus on his
> opinion about the separation of s2ram form the snapshot/restore functionality
> (I'll call it 'hibernation' for simplicity from now on).

So my strong opinion on it literally comes from the other end (ie _not_ 
knowing about hibernation, but trying to work with s2ram, and cursing the 
mixups).

> It should be done, because it would make things simpler and cleaner.  
> Still, it will be difficult to do without screwing users en masse and 
> that's my main concern here.

I do agree. It will inevitably affect a lot of devices. That's always 
painful.

> I don't agree that we don't need the tasks freezer for suspending and
> hibernation.  We need it, because we need to be sure that the (other) tasks
> will not get us in the way, and that also applies to kernel threads (and I
> don't think the tasks freezer is 'screwing' them, BTW).

I actually feel much less strongly about that, because just separating out 
s2ram and hibernate entirely from each other would already really get the 
thing _I_ care about taken care of - being able to work on one of the 
other without fear of breaking the other one.

And besides, I actually came into the whole discussion because I'm not a 
huge fan of thinking that user-land is "better". If the thing can sanely 
be done in kernel, I'm actually all for that. What drives me wild is 
having three different things, and nobody driving.

It needs somebody who (a) cares (b) has good taste and (c) has enough time 
and personal karma to burn that he can actually take the (obviously) 
inevitable heat from just doing things right, and convincing people to 
select *one* implementation.

That kind of person is really really hard to find. And if you're it, 
you're in for some pain ;)

		Linus
