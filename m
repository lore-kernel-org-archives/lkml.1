Return-Path: <linux-kernel-owner+w=401wt.eu-S1762596AbYBLXuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762596AbYBLXuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYBLXt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:49:58 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61147 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180AbYBLXt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:49:56 -0500
Date: Tue, 12 Feb 2008 18:49:04 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212234904.GB9063@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
	arjan@infradead.org, sfr@canb.auug.org.au,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
	linux-arch@vger.kernel.org, akpm@linux-foundation.org
References: <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <20080212174824.GA1919@kroah.com> <alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org> <20080212191552.GA20883@kroah.com> <alpine.LFD.1.00.0802121133210.2920@woody.linux-foundation.org> <20080212204813.GA21650@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212204813.GA21650@kroah.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 12:48:13PM -0800, Greg KH wrote:
> On Tue, Feb 12, 2008 at 11:55:45AM -0800, Linus Torvalds wrote:
> > > 
> > > Not it isn't.  To quote you a number of years ago:
> > > 	"Linux is evolution, not intelligent design"

I think this statement has been used unfortunately as a hard and fast
rule (which we all know how much Linus loves :-) to mean, in its most
extreme form, that we should *never* try to do some careful reflection
about careful API design, and that the extremes of "no interface
without an in-tree user" applies to (a) parameters in a function call
(heck, we can always sweep through all the in-tree users to add that
extra parameter later, and thats a *good* thing because it breaks
those evil out-of-tree drivers) and (b) to not even thinking if some
particular interface (that is not needed now but which reasonably will
be needed later) is even *possible* without doing a sweep of all of
the in-tree users of the interface.

Related to this syndrome is the assumption that measuring the rate of
changes in lines of code changed per second implies that any
development process which causes the number of lines of code changed
second, including frequent sweeps through the tree changing all
interfaces, is a *good* thing.

Yes, this is an extreme position, and I'm not accusing anyone of
holding the above in its entirety --- but I've seen aspects of all of
these from one developer or another.

We come to it from the attacking another strawman, which assumes that
*all* interfaces which don't have an in-tree are evil, and that
keeping old __deprecated interfaces for a long time is an evil which
causes intolerable pain, and that it's never worthwhile to try to
anticipate future expandibility into an interface because you will
inevitably get it wrong.

Clearly, we are right to mock Solaris for making claims that they will
never, ever, *ever* change an interface, not even one that goes back
sixteen years to Solaris 2.3.  But it doesn't follow the opposite
point of view, that constant mutability of kernel interfaces to make
sure that things are always perfect and pure and clean is the right
one either.

> > The examples are legion. The mammalian eye has the retina "backwards", 
> > with the blind spot appearing because the fundmanetal infrastructure (the 
> > optical nerves) actually being in *front* of the light sensor and needing 
> > a hole in the retina to get the information (and blood flow) to go to the 
> > brain!

Also, evolution also means that things like vestigal organs (like our
appendix) are tolerated.  So are things like clearly very badly
designed things, like human backs.  To the extent that we don't like
vestigal old __deprecated interfaces, and want things to be perfect,
we are actually straying into the realms where we want the sort of
things that you would get if you *did* have an intelligent designer
designing the human body from scratch.

So the "Linux is evolution, not intelligent design" quote is
unfortunately getting used to imply that no amount of intelligent
foresight is worthwhile, and I think that's unfortunate.  It implies
an extreme position which is not warranted.

> > > But they do happen about once or twice a kernel release, just by virtue
> > > of the way things need to happen.
> > 
> > And I violently disagree.
> > 
> > It should not be "once of twice a kernel release".
> > 
> > It should be "once or twice a year" that you hit a flag-day issue. The 
> > rest of the time you should be able to do it without breakage. It's 
> > doable. You just HAVEN'T EVEN TRIED, and seem to be actively against even 
> > doing so.
> 
> No, not at all.
> 
> I have tried, and successfully done this many times in the past.  The
> kobject change was one example: add a new function, migrate all users of
> a direct pointer over to that function, after that work is all done and
> in, change the structure and do the needed work afterward.  All is
> bisectable completly, with no big "flag day" needed.

Collectively, we need to try harder.

We can debate exactly where the right line is, in terms of whether
it's only "once or twice a kernel release", or "once or twice a year",
but clearly the current amount of interface changes and cross-tree
dependencies has been causing Andrew pain.  And to me, that means we
need to turn the knob back a quarter turn towards tolerating
__deprecated old interfaces a little bit more, and trying to get
interfaces right just a little bit more and try building in just a
little bit more future expandability, and to try just *little* bit
harder to preserve a *little* bit more stable API.

In other words, maybe we need to write a counterpoint to the
stable_api_nonsense.txt and call it unstable_api_nonsense.txt --- and
in it, we note that if we start burning out Andrew and he starts
getting really, REALLY grumpy --- and if especially we start making
Stephen (normally a very mild-mannered and not terribly excitable guy)
grumpy, that it's time that we try just a little bit harder to make
our API's a little bit more stable.  Suckers^H^H^H^H^H^H^H^H, err.,
dedicated release managers like like Andrew and Stephen are very
precious resources and we shouldn't be burning them out by assuming
that "stable_api_nonsense.txt" is a license to constantly churn our
internal API's, to the point where they start complaining.

					- Ted
