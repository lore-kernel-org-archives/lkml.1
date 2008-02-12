Return-Path: <linux-kernel-owner+w=401wt.eu-S1764334AbYBLUx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764334AbYBLUx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756229AbYBLUxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:53:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43346 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421AbYBLUxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:53:16 -0500
Date: Tue, 12 Feb 2008 12:48:13 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212204813.GA21650@kroah.com>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org> <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <20080212174824.GA1919@kroah.com> <alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org> <20080212191552.GA20883@kroah.com> <alpine.LFD.1.00.0802121133210.2920@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802121133210.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 11:55:45AM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 12 Feb 2008, Greg KH wrote:
> > 
> > > That's the point.
> > 
> > Not it isn't.  To quote you a number of years ago:
> > 	"Linux is evolution, not intelligent design"
> 
> Umm. Have you read a lot of books on evolution?
> 
> It doesn't sound like you have.
> 
> The fact is, evolution often does odd (and "suboptimal") things exactly 
> because it does incremental changes that DO NOT BREAK at any point.

Hm, I think we are in violent agreement here :)

> The examples are legion. The mammalian eye has the retina "backwards", 
> with the blind spot appearing because the fundmanetal infrastructure (the 
> optical nerves) actually being in *front* of the light sensor and needing 
> a hole in the retina to get the information (and blood flow) to go to the 
> brain!
> 
> In other words, exactly *because* evolution requires "bisectability" (any 
> non-viable point in between is a dead end by definition) and does things 
> incrementally, it doesn't do big flips. It fixes the problems on an 
> incremental scale both when it comes to the details and when it comes to 
> both "details" (actual protein-coding genes that code directly for some 
> expression) and "infrastructure" (homeobox and non-coding genes).
> 
> So quite frankly, you're the "intelligent designer" here. You're the one 
> who seems to claim that we need those leaps of faith and wild jumps.

No, I might have mistyped previously, but I really do not believe in
this at all.

> > > And simply avoiding cross-subsystem API changes unless there is a major 
> > > *MAJOR* reason for them is the obvious thing to do. Simply face the fact 
> > > that even in open source there are major reasons to stay with an old 
> > > interface even if it's not optimal.
> > 
> > I strongly disagree here.  We lived with that kset/ktype crap for years,
> > and I finally broke down and cleaned it up, simplifying things, removing
> > code, making the kernel smaller, leaner, and easier for others to change
> > and use in the future.  With your statement, such a change should have
> > never taken place as it what we had at the time was "not optimal", but
> > good enough to live with.
> 
> You didn't listen at all.
> 
> I said that the threshold should be high, not that it should be 
> impossible. I also said that we should strive for making it unnecessary to 
> have the painful total synchronization points.

I agree with this.  But I was reacting to your "there are major reasons
to stay with an old interface..." portion above, while I feel we should
always work to fixe those interfaces as best as possible.

> > But they do happen about once or twice a kernel release, just by virtue
> > of the way things need to happen.
> 
> And I violently disagree.
> 
> It should not be "once of twice a kernel release".
> 
> It should be "once or twice a year" that you hit a flag-day issue. The 
> rest of the time you should be able to do it without breakage. It's 
> doable. You just HAVEN'T EVEN TRIED, and seem to be actively against even 
> doing so.

No, not at all.

I have tried, and successfully done this many times in the past.  The
kobject change was one example: add a new function, migrate all users of
a direct pointer over to that function, after that work is all done and
in, change the structure and do the needed work afterward.  All is
bisectable completly, with no big "flag day" needed.

Same goes for a lot of USB changes.  Hell, we've been slowly moving
toward changing the USB urb callback for _years_ yet, not quite getting
there, but the groundwork is done, making it much simpler and easy for
it to happen.  Eventually things will flip over and the eventual patch
for all callback functions will be trivial and easily reviewed and
merged.

In short, I agree that flag days are bad and should be avoided at all
costs, and that slow incremental, bisectable changes are how we evolve
properly.  And that we need to always be able to do this kind of work,
and never be stuck with the "can't change an old, internal api" model.

To bring it around to the original topic, -next should help us in
finding these issues out, exactly like -mm is.

If we want to make a new rule of "only merging api or cross-subsystem
changes after everything else", that's wonderful with me, I have no
objection to it at all.

thanks,

greg k-h
