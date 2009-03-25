Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbZCYD5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbZCYD5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 23:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbZCYD53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 23:57:29 -0400
Received: from outbound-mail-21.bluehost.com ([69.89.21.16]:56348 "HELO
	outbound-mail-21.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753990AbZCYD52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 23:57:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=FcrwnrtCQZH8MikHlP2swu5gdVN9yuOZQpH/2+rs7aXZtkFA79NOV4rBpeqTqeUTXcV64qWUF30hDdom2gSeTOIC0ryIoCyqPqAcaLEjVAZjHH/4fvMTYVpXpfWqNrT9;
Date: Tue, 24 Mar 2009 20:57:22 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090324205722.1392e3db@hobbes.virtuouswap>
In-Reply-To: <20090325020915.GI32307@mit.edu>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	<49C87B87.4020108@krogh.cc>
	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	<20090324091545.758d00f5@lxorguk.ukuu.org.uk>
	<20090324093245.GA22483@elte.hu>
	<20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
	<20090324103111.GA26691@elte.hu>
	<20090324132032.GK5814@mit.edu>
	<20090324160353.06a4a5ed@hobbes.virtuouswap>
	<20090325020915.GI32307@mit.edu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009 22:09:15 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Tue, Mar 24, 2009 at 04:03:53PM -0700, Jesse Barnes wrote:
> > 
> > You make it sound like this is hard to do...  I was running into
> > this problem *every day* until I moved to XFS recently.  I'm
> > running a fairly beefy desktop (VMware running a crappy Windows
> > install w/AV junk on it, builds, icecream and large mailboxes) and
> > have a lot of RAM, but it became unusable for minutes at a time,
> > which was just totally unacceptable, thus the switch.  Things have
> > been better since, but are still a little choppy.
> > 
> 
> I have 4 gigs of memory on my laptop, and I've never seen it these
> sorts of issues.  So maybe filesystem hackers don't have enough
> memory; or we don't use the right workloads?  It would help if I
> understood how to trigger these disaster cases.  I've had to work
> *really* hard (as in dd if=/dev/zero of=/mnt/dirty-me-harder) in order
> to get even a 30 second fsync() delay.  So understanding what sort of
> things you do that cause that many files data blocks to be dirtied,
> and/or what is causing a major read workload, would be useful.
> 
> It may be that we just need to tune the VM to be much more aggressive
> about pushing dirty pages to the disk sooner.  Understanding how the
> dynamics are working would be the first step.

Well I think that's part of the problem; this is bigger than just
filesystems; I've been using ext3 since before I started seeing this,
so it seems like a bad VM/fs interaction may be to blame.

> > I remember early in the 2.6.x days there was a lot of focus on
> > making interactive performance good, and for a long time it was.
> > But this I/O problem has been around for a *long* time now... What
> > happened?  Do not many people run into this daily?  Do all the
> > filesystem hackers run with special mount options to mitigate the
> > problem?
> 
> All I can tell you is that *I* don't run into them, even when I was
> using ext3 and before I got an SSD in my laptop.  I don't understand
> why; maybe because I don't get really nice toys like systems with
> 32G's of memory.  Or maybe it's because I don't use icecream (whatever
> that is).  What ever it is, it would be useful to get some solid
> reproduction information, with details about hardware configuration,
> and information collecting using sar and scripts that gather
> /proc/meminfo every 5 seconds, and what the applications were doing at
> the time.

icecream is a distributed compiler system.  Like distcc but a bit more
cross-compile & heterogeneous compiler friendly.

> It might also be useful for someone to try reducing the amount of
> memory the system is using by using mem= on the boot line, and see if
> that changes things, and to try simplifying the application workload,
> and/or using iotop to determine what is most contributing to the
> problem.  (And of course, this needs to be done with someone using
> ext3, since both ext4 and XFS use delayed allocation, which will
> largely make this problem go away.)

Yep, and that's where my blame comes in.  I whined about this to a few
people, like Arjan, who provided workarounds, but never got beyond
that.  Some real debugging would be needed to find & fix the root
cause(s).

-- 
Jesse Barnes, Intel Open Source Technology Center
