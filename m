Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbYCPG5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbYCPG5f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 02:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYCPG50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 02:57:26 -0400
Received: from 1wt.eu ([62.212.114.60]:2492 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYCPG50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 02:57:26 -0400
Date: Sun, 16 Mar 2008 07:56:25 +0100
From: Willy Tarreau <w@1wt.eu>
To: Daniel Phillips <phillips@phunq.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080316065625.GA32135@1wt.eu>
References: <200803092346.17556.phillips@phunq.net> <200803151533.10797.phillips@phunq.net> <20080315232221.GA24227@1wt.eu> <200803152033.08788.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803152033.08788.phillips@phunq.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2008 at 07:33:07PM -0800, Daniel Phillips wrote:
> On Saturday 15 March 2008 16:22, Willy Tarreau wrote:
> > > That would have been a miscommunication then.  I see arguments coming
> > > in that suggest embedded solutions, EMC for example, are inherently more
> > > reliable than a Linux based solution.  Well guess what?  Some of those
> > > embedded solutions already use Linux.
> > 
> > But their RAM does not depend on a lot of factors to remain valid and
> > usable, which is the problem with the common PC.
> 
> For example?

What I mean is that in a PC, RAM contents are very fragile :
 - weak batteries in your UPS => end of game
 - loosy power cable between UPS and PC => end of game (BTW I have a customer
   who had such a problem, cables had both disconnected because of their own
   weight).
 - kernel panic => end of game
 - user error during planned maintenance => end of game
 - flaky driver writing to wrong memory location => can't trust your data

In a normal PC, even if the RAM itself is a reliable component (ECC, ...)
a lot of such problems which may happen will render it unusable. If you
have to reboot, your BIOS will clean it up for you. That's why people are
trying to explain to you that linux is not reliable enough to work like
this.

Now if you have all your RAM on a PCI-E board with a battery and which is
not initialized by the BIOS so that it survives reboots, it changes a LOT
of things, because all the problems mentionned above go away. Let me
repeat it, the problem is not that those components are too unreliable
to build a transactional system, it is that used in this manner, a very
simple failure of any of them is enough to lose/corrupt all of your data.
Reason why people insist on ordered writes with regular flushes.

> Anecdote time.  Remember there used to be "brand name" floppy disks and
> generic floppy disks, and the brand name ones cost a lot more because
> they were supposedly safer?  Well, big secret, studies were done and
> the no-name disks came out better.  Why?  Because selling at commodity
> prices the generic makers could not afford returns.  So they made them
> well.

That was not my experience when I was a student. We would buy very cheap
diskettes which were only sold by 100. 20% of them were already defective,
and 20% of the remaining ones could not keep our data till the next morning!
I knew guys who finally stopped copying games due to those diskettes, so
we believed they were sold by game editors :-)

> It is like that with PCs.  Supposedly you get a lot more reliability
> when you spend more money and buy all high end near-custom gear.  In
> fact, the cheap stuff just keeps on chugging, because those guys can't
> afford to have it break.
> 
> So please don't underestimate the reliability of a PC.

If you have understood what I explained above, now you'll understand that
I'm not underestimating the reliability of my PC, just the fact that keeping
access to my RAM contents involves a lot of components, any of which will
definitely ruin my data in case of failure.

> There are bits of Linux that are undeniably dodgy.  We get a lot of bug
> reports about usb for example, keyboards just quitting and it's not the
> keyboard's fault.  Just say no to usb in a server, at least until some
> fundamental cleanup happens there.

unfortunately, new servers are often USB-only.

> The worst bug I've seen in a server this year?  A buggy bios in a Dell
> server that would issue a keyboard error and sit and wait for somebody
> to press F1 when there was no keyboard attached.

I thought this stupidity disappeared about 5 years ago ? I was about to
build PIC-based PS/2 "terminators" to plug into machines to avoid this
problem at that time.

> That is embedded software for you.  Personally, I think we do way
> better than that in Linux.
>
> > > Also, peecees are much more reliable than people give them credit for,
> > > especially if you harden up the obvious points of failure such as fans
> > > and spinning disks.
> > 
> > and PSU.
> 
> Yes.  Dual power supplies are highly recommended for this application.
> With dual power supplies you can carry out preemptive maintenance on
> the UPS.
> 
> > Securing every component simply reduces the risk of a loss of service.
> > What is important with data is to know the consequences of loss of service.
> > If that only means that no one can work and that the last second of work is
> > lost, it's generally acceptable. If it means everything is lost to a corrupted
> > FS, obviously it's not.
> 
> So mirror two of them, I keep saying.  If that is not good enough for
> you, then make it three way, and replicate for good measure.  The thing
> is, none of that hurts the microsecond level performance, and it gets
> you whatever data security you desire.  Whereas anything that requires
> waiting on disk transactions does hurt performance.  Since my interest
> currently lies in high performance, that is where my effort goes.

I never spoke about waiting for disk transactions. The RAM must be the
only source and target of user data. Disk is there for permanent storage
and should be written to in the background. YOU proposed the write-through
alternative with your "echo 1". But obviously this voids any advantage of
your work.

> And do I need to say it: patches gratefully accepted.

Hey thanks, but we're not on freshmeat : "here's version 0.1 of foobar,
right now it does nothing but given a massive amount of contributors it
will replace a datacenter in a matchbox".

> For my immediate application... hacking the kernel in comfort... just
> replicating will provide all the data safety I need.

Daniel, you must understand that it is not because it suits *your* needs
that your project will get broad adoption. Many people are showing you
what they don't like in it, and it's not even a design problem, it's just
the way data are synchronized. I think that if you spent your time on
your code instead of arguing by mail against each of us, you would have
already got ordered writes working.

> > Sorry if I was not clear. I was not speaking about replacing the RAM with
> > flash, but only the disks. You keep the RAM for the speed, and use flash
> > for permanent storage instead of disks. No seek time, average RW speed now
> > slightly better than disks, that combined with your ramdisk and ordered
> > write-backs writes will have the best of both worlds : RAM speed and flash
> > reliability.
> 
> Right.  What we are talking about is filling in a missing level in the
> cache hierarchy, something like:
> 
>    L1 .3 ns
>    L2 3 ns
>    L3 30 ns
>    Ramdisk 2 us
>    Flash 20 us
>    Disk 3 ms
> 
> Approximate, numbers not necessarily too accurate, but you know what I
> mean.  Currently there is this gigantic performance cliff between L3
> memory and disk.  Something like the Violin ramdisk fills it in nicely.
> And see, you still need that rotating media because it always will be
> an order of magnitude cheaper than flash.

"always" is far from being a certitude here. "still" is right though.
Prices are driven by customer demand. And building a 128 GB flash
requires a lot less efforts than a hard drive containing a lot of
fragile mechanics. However, I'm not sure that flash will be as much
resistant to environmental annoyances that we're happy to ignore
today, such as solar winds and cosmic rays. Future will tell.

> Tape might still fit in
> there too, though these days it seems increasingly doubtful.

Tapes are used for long-term archival. You can read a tape 20 years
after having written it. A disk... well, the interface to plug it
does not exist anymore, even the electronics process have changed,
as well as voltage levels. Check in your boxes if you have an old
MFM or RLL disk, and see where you can plug it. Maybe you'll find
an old ISA controller with a corrupted BIOS (too old) or at least
which does not support machines faster than 25 MHz.

Tape vendors will still sell you the tape drive (at an amazing
price BTW).

Willy

