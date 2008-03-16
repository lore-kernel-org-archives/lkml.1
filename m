Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbYCPDdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbYCPDdd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 23:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYCPDdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 23:33:24 -0400
Received: from phunq.net ([64.81.85.152]:35385 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751681AbYCPDdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 23:33:23 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Sat, 15 Mar 2008 19:33:07 -0800
User-Agent: KMail/1.9.5
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803151533.10797.phillips@phunq.net> <20080315232221.GA24227@1wt.eu>
In-Reply-To: <20080315232221.GA24227@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803152033.08788.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 March 2008 16:22, Willy Tarreau wrote:
> > That would have been a miscommunication then.  I see arguments coming
> > in that suggest embedded solutions, EMC for example, are inherently more
> > reliable than a Linux based solution.  Well guess what?  Some of those
> > embedded solutions already use Linux.
> 
> But their RAM does not depend on a lot of factors to remain valid and
> usable, which is the problem with the common PC.

For example?

Anecdote time.  Remember there used to be "brand name" floppy disks and
generic floppy disks, and the brand name ones cost a lot more because
they were supposedly safer?  Well, big secret, studies were done and
the no-name disks came out better.  Why?  Because selling at commodity
prices the generic makers could not afford returns.  So they made them
well.

It is like that with PCs.  Supposedly you get a lot more reliability
when you spend more money and buy all high end near-custom gear.  In
fact, the cheap stuff just keeps on chugging, because those guys can't
afford to have it break.

So please don't underestimate the reliability of a PC.

There are bits of Linux that are undeniably dodgy.  We get a lot of bug
reports about usb for example, keyboards just quitting and it's not the
keyboard's fault.  Just say no to usb in a server, at least until some
fundamental cleanup happens there.

The worst bug I've seen in a server this year?  A buggy bios in a Dell
server that would issue a keyboard error and sit and wait for somebody
to press F1 when there was no keyboard attached.  That is embedded
software for you.  Personally, I think we do way better than that in
Linux.

> > Also, peecees are much more reliable than people give them credit for,
> > especially if you harden up the obvious points of failure such as fans
> > and spinning disks.
> 
> and PSU.

Yes.  Dual power supplies are highly recommended for this application.
With dual power supplies you can carry out preemptive maintenance on
the UPS.

> Securing every component simply reduces the risk of a loss of service.
> What is important with data is to know the consequences of loss of service.
> If that only means that no one can work and that the last second of work is
> lost, it's generally acceptable. If it means everything is lost to a corrupted
> FS, obviously it's not.

So mirror two of them, I keep saying.  If that is not good enough for
you, then make it three way, and replicate for good measure.  The thing
is, none of that hurts the microsecond level performance, and it gets
you whatever data security you desire.  Whereas anything that requires
waiting on disk transactions does hurt performance.  Since my interest
currently lies in high performance, that is where my effort goes.  And
do I need to say it: patches gratefully accepted.

For my immediate application... hacking the kernel in comfort... just
replicating will provide all the data safety I need.

> Sorry if I was not clear. I was not speaking about replacing the RAM with
> flash, but only the disks. You keep the RAM for the speed, and use flash
> for permanent storage instead of disks. No seek time, average RW speed now
> slightly better than disks, that combined with your ramdisk and ordered
> write-backs writes will have the best of both worlds : RAM speed and flash
> reliability.

Right.  What we are talking about is filling in a missing level in the
cache hierarchy, something like:

   L1 .3 ns
   L2 3 ns
   L3 30 ns
   Ramdisk 2 us
   Flash 20 us
   Disk 3 ms

Approximate, numbers not necessarily too accurate, but you know what I
mean.  Currently there is this gigantic performance cliff between L3
memory and disk.  Something like the Violin ramdisk fills it in nicely.
And see, you still need that rotating media because it always will be
an order of magnitude cheaper than flash.  Tape might still fit in
there too, though these days it seems increasingly doubtful.

Daniel
