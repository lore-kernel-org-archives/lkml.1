Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbXGXEKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbXGXEKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 00:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbXGXEKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 00:10:22 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:49492 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbXGXEKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 00:10:20 -0400
Message-ID: <46A57B40.9010807@gmail.com>
Date: Tue, 24 Jul 2007 06:08:32 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>
CC: linux-fsdevel@vger.kernel.org, Al Boldi <a1426z@gawab.com>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFH] Partition table recovery
References: <200707200813.03553.a1426z@gawab.com> <46A24846.7050803@gmail.com> <20070722011141.GJ26752@thunk.org> <200707220710.31402.a1426z@gawab.com> <20070722162802.GA20174@thunk.org> <46A46399.5090406@gmail.com> <20070723135832.GD19927@thunk.org>
In-Reply-To: <20070723135832.GD19927@thunk.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2007 03:58 PM, Theodore Tso wrote:

> Well, I'm considering this to be a MBR backup scheme, so Minix and BSD 
> slices are legacy systems which are out of scope.  If they are busted in
> the same way as MBR in terms of not having redundant backups of critical
> data, when they have a lot fewer excuses that MBR, and they can address
> that issue in their own way.  The number of Linux users that also have
> Minix and BSD partitions are a vanishingly small number in any case.

I'd in fact expect quite a few people to have a FreeBSD partition around. 
And MINIX if they are in university and in an operating systems course...

But "they should take whatever precautions they want themselves" is a valid 
argument.

[ blkid ]

> Yeah, good point, I'd have to add that support into blkid.  It's been
> on my todo list, but I just haven't gotten around to it yet.

I'll for now stop updating the partbackup thingy as posted. Given that Linux 
  only follows the first extended in the list of extendeds (which sort of 
destroys the nice recursion anyway) it might want to be iterative instead of 
recursive if the thing has a future -- not very important though.

> My concern of sysfs is that #1, it won't work on older kernels since
> you would need to add new fields to backup what we want,

I'd be okay with that.

> and #2, I'm still fundamentally distrustful of sysfs because there isn't
> a bright line between what is an exported interface that will never
> change, and something which is considered an "internal implementation
> detail" that can change whenever some kernel hacker feels like it.  (Or
> when some kernel hacker is careless...)  So as far as I'm concerned sysfs
> is a terrible, TERRIBLE way to export a published interface where we 
> promise stability to userspace.

Oh come on, that's going overboard a bit, it's not all _that_ bad! Finding 
say "sda" will be possible without breaking too many times. Admittedly, the 
kernel's partittion scanning order is also not likely to change as it would 
certainly break userspace, but code duplication, with the possiblity of bugs 
slipping in at least userspace-ways (considering the kernel the reference no 
matter what it does) is a concern. Somewhat. A little.

> So I'd just as soon do this in userspace; after all, the entire partition
> manager (and there are multiple ones; fdisk, sfdisk, gpart, etc.) all in
> userspace, and that needs to be in synch with the kernel partition
> reading code anyway.  So one more userspace implementation is in my mind
> much cleaner than trying to push the needed functionality into sysfs, and
> then hoping against hope that it doesn't accidentally change in the
> future.

* rene envisions /lib/libpart.so...

Not to mention my Grand Visions of a totally new Linux native partitioning 
scheme probably modelled after BSD slices (as also mentioned in a previous 
message just now). Or perhaps LVM already fills that role comfortably. It's 
certainly what I hear everyone talking about these days.

Rene.
