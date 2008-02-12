Return-Path: <linux-kernel-owner+w=401wt.eu-S1762770AbYBLT40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762770AbYBLT40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbYBLT4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:56:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43651 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751113AbYBLT4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:56:15 -0500
Date: Tue, 12 Feb 2008 11:55:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <20080212191552.GA20883@kroah.com>
Message-ID: <alpine.LFD.1.00.0802121133210.2920@woody.linux-foundation.org>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org> <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
 <20080212174824.GA1919@kroah.com> <alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org> <20080212191552.GA20883@kroah.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, Greg KH wrote:
> 
> > That's the point.
> 
> Not it isn't.  To quote you a number of years ago:
> 	"Linux is evolution, not intelligent design"

Umm. Have you read a lot of books on evolution?

It doesn't sound like you have.

The fact is, evolution often does odd (and "suboptimal") things exactly 
because it does incremental changes that DO NOT BREAK at any point.

The examples are legion. The mammalian eye has the retina "backwards", 
with the blind spot appearing because the fundmanetal infrastructure (the 
optical nerves) actually being in *front* of the light sensor and needing 
a hole in the retina to get the information (and blood flow) to go to the 
brain!

In other words, exactly *because* evolution requires "bisectability" (any 
non-viable point in between is a dead end by definition) and does things 
incrementally, it doesn't do big flips. It fixes the problems on an 
incremental scale both when it comes to the details and when it comes to 
both "details" (actual protein-coding genes that code directly for some 
expression) and "infrastructure" (homeobox and non-coding genes).

So quite frankly, you're the "intelligent designer" here. You're the one 
who seems to claim that we need those leaps of faith and wild jumps.

> Oh, it's been painful at times, but they are, overall, very rare.

No, overall, they have *not* been rare lately. We've had them all over. 
And not just the one introduced by you.

> If you look at the rate of change we are currently running at, it's
> amazing that we do not get _more_ of these kinds of problems.

I don't think that's a valid argument.

Sure, we have lots of changes, but 99.9% of them have no cross-subsystem 
effect what-so-ever.

> > And simply avoiding cross-subsystem API changes unless there is a major 
> > *MAJOR* reason for them is the obvious thing to do. Simply face the fact 
> > that even in open source there are major reasons to stay with an old 
> > interface even if it's not optimal.
> 
> I strongly disagree here.  We lived with that kset/ktype crap for years,
> and I finally broke down and cleaned it up, simplifying things, removing
> code, making the kernel smaller, leaner, and easier for others to change
> and use in the future.  With your statement, such a change should have
> never taken place as it what we had at the time was "not optimal", but
> good enough to live with.

You didn't listen at all.

I said that the threshold should be high, not that it should be 
impossible. I also said that we should strive for making it unnecessary to 
have the painful total synchronization points.

The fact is, we *have* been able to do things like this gradually and 
well, without introducing breakage. Take the VM changes, for example: 
those were pretty damn fundamental, where we've changed the calling 
convention totally for fault handling.

But that thing was done without at any point really seriously breaking 
code. It involved adding the new interface, and letting the old one live 
in parallel. 

The last remnant of the old "nopage()" interface still exists, but I think 
right now it's only used by DRM. 

Did it require the drivers to be updated? Yes. But it did NOT require the 
total synchronization, because it still worked with the old interface.

> But they do happen about once or twice a kernel release, just by virtue
> of the way things need to happen.

And I violently disagree.

It should not be "once of twice a kernel release".

It should be "once or twice a year" that you hit a flag-day issue. The 
rest of the time you should be able to do it without breakage. It's 
doable. You just HAVEN'T EVEN TRIED, and seem to be actively against even 
doing so.

		Linus
