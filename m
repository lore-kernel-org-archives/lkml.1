Return-Path: <linux-kernel-owner+w=401wt.eu-S1751666AbYCKXD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbYCKXD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 19:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbYCKXDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 19:03:15 -0400
Received: from phunq.net ([64.81.85.152]:39308 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750885AbYCKXDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 19:03:14 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Tue, 11 Mar 2008 15:02:53 -0800
User-Agent: KMail/1.9.5
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Grzegorz Kulewski <kangur@polcom.net>,
       linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803110450.19390.phillips@phunq.net> <20080311215601.GM23784@marowsky-bree.de>
In-Reply-To: <20080311215601.GM23784@marowsky-bree.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803111602.53835.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008 14:56, Lars Marowsky-Bree wrote:
> And yes, I'm not saying I don't see your point for specialised
> deployments (filesystems which are easy to rebuild from scratch), but
> transactional integrity is a requirement I'd rank really high on the
> desirable list of features if I was you.

It is ranked high, nonetheless I perceive this spate of sky-is-falling
comments as low level FUD.  Which of the following do you think is the
least reliable component in your transactional system:

  1) Linux
  2) The computer
  3) The hard disk
  4) The battery
  5) The fan

Correct answer: the fan.  The rest are roughly a tie (though of course
you will find variations) and depend on how much money you spend on
each of them.  I know I do not have to explain this to you, but the way
you calculate reliability for a complete system is to multiply the
reliability of each component.  The number of nines that drop out of
this calculation is your reliability.

At the moment, the version of Linux I run is looking like a 1.0, so is
the UPS.  Already got me through about 4 blackouts and half a dozen
vacuum cleaner events.  Though obviously neither is 1.0, both are darn
close.  The hard disk on the other hand... I have a box full of broken
ones here, how about you?

I have never had a PC go bad on me, ever.   Had a couple of fans die,
but these days I only buy PCs that run fine without a fan.

So your proposition is, I can add nines to this system by introducing
atomic update of the backing store.  Fine, I agree with you.  However
if I already sit at six or seven nines then should I be putting my
effort there, or where?

Also no need to explain: when you introduce two way redundancy, you
square the reliability.  So have two independent power supplies on two
independent UPSes.  Sleep easy, plus you gain the ability to do
scheduled battery maintenance, so reliability increases by more than
the square.

No matter how much you fiddle with atomic update of backing store, one
disgruntled sysop going postal can still destroy your data with the
help of a sledgehammer.  You need to get this reliability thing in
perspective.

So how about you draft a Suse engineer to get working on the atomic
backing store update, ETA six months?  In the mean time, we can
configure a transactional system using this driver (once stabilized)
to as many nines as you want.  Offsite replication using
ddsnap+zumastor?  You got it.  5 second latency between replication
cycles?  No problem.  Incidentally, Ramback totally solves the ddsnap
copy-before-write seek bottleneck, turning replication into a really
elegant fallback solution.

By the way, if you want to fly to the moon you will need a rocket.
Streams of liquid hydrogen coursing through gigantic pipes sitting
right next to violently burning roman candles are less reliable than
bicycle pedals, but only one of these arrangements will get you to the
moon on time.  In other words, if you need the speed this is the only
game in town, so you better just take care to buy reliable rocket
parts.

> > > So "perfectly reliable if UPS power does not fail" seems a bit over the
> > > top.
> > It works for EMC :-)
> 
> Where they control the hardware and run a rather specialized OS as well,
> not a general purpose system like Linux on "commodity" hardware ;-)

Heh.  Maybe you better ask Ric about that commodity hardware thing.  I
am sure you are aware that servers with dual power supplies are now
commodity items.

> I'm afraid with those properties it doesn't really meet my needs :-(

See you around then, and thanks for all the effort.  Not.

> And, wouldn't a simpler way to achieve something similar not be to use
> the plain Linux fs caching/buffers, just disabling forced write out
> maybe via a mount option? This strikes me as similar to the effect I get
> from remounting NFS (a)sync. Make the fs ignore fsync et al.

Maybe move it up into the VM/VFS after it is completely worked out at
the block layer.  If it can't work as a block device it can't work
period.

Bear in mind that our VM is currently stuck together with bailing
wire and chewing gum, reliable only because of the man-machine-Morton
effect and Linus's annual Christmas race chase.  Careful in there.

> It would have the advantage of using all memory available for caching
> and not otherwise requested, too.

Good point, a ram disk does not work like that.  Oh wait, it does.

Bis spaeter,

Daniel
