Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbZCYCKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbZCYCKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 22:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbZCYCJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 22:09:48 -0400
Received: from THUNK.ORG ([69.25.196.29]:57230 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756791AbZCYCJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 22:09:47 -0400
Date: Tue, 24 Mar 2009 22:09:15 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090325020915.GI32307@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <20090324160353.06a4a5ed@hobbes.virtuouswap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324160353.06a4a5ed@hobbes.virtuouswap>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 04:03:53PM -0700, Jesse Barnes wrote:
> 
> You make it sound like this is hard to do...  I was running into this
> problem *every day* until I moved to XFS recently.  I'm running a
> fairly beefy desktop (VMware running a crappy Windows install w/AV junk
> on it, builds, icecream and large mailboxes) and have a lot of RAM, but
> it became unusable for minutes at a time, which was just totally
> unacceptable, thus the switch.  Things have been better since, but are
> still a little choppy.
> 

I have 4 gigs of memory on my laptop, and I've never seen it these
sorts of issues.  So maybe filesystem hackers don't have enough
memory; or we don't use the right workloads?  It would help if I
understood how to trigger these disaster cases.  I've had to work
*really* hard (as in dd if=/dev/zero of=/mnt/dirty-me-harder) in order
to get even a 30 second fsync() delay.  So understanding what sort of
things you do that cause that many files data blocks to be dirtied,
and/or what is causing a major read workload, would be useful.

It may be that we just need to tune the VM to be much more aggressive
about pushing dirty pages to the disk sooner.  Understanding how the
dynamics are working would be the first step.

> I remember early in the 2.6.x days there was a lot of focus on making
> interactive performance good, and for a long time it was.  But this I/O
> problem has been around for a *long* time now... What happened?  Do not
> many people run into this daily?  Do all the filesystem hackers run
> with special mount options to mitigate the problem?

All I can tell you is that *I* don't run into them, even when I was
using ext3 and before I got an SSD in my laptop.  I don't understand
why; maybe because I don't get really nice toys like systems with
32G's of memory.  Or maybe it's because I don't use icecream (whatever
that is).  What ever it is, it would be useful to get some solid
reproduction information, with details about hardware configuration,
and information collecting using sar and scripts that gather
/proc/meminfo every 5 seconds, and what the applications were doing at
the time.

It might also be useful for someone to try reducing the amount of
memory the system is using by using mem= on the boot line, and see if
that changes things, and to try simplifying the application workload,
and/or using iotop to determine what is most contributing to the
problem.  (And of course, this needs to be done with someone using
ext3, since both ext4 and XFS use delayed allocation, which will
largely make this problem go away.)

					- Ted
