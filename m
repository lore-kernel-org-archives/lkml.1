Return-Path: <linux-kernel-owner+w=401wt.eu-S1761169AbZBYIMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761169AbZBYIMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 03:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760573AbZBYILl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 03:11:41 -0500
Received: from cuda1.bluetone.cz ([212.158.128.5]:35822 "EHLO mail.bluetone.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760555AbZBYILk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 03:11:40 -0500
Message-ID: <49A4FD51.6000501@slax.org>
Date: Wed, 25 Feb 2009 09:12:01 +0100
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Tomas M <tomas@slax.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: New filesystem for Linux kernel
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl> <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org> <49A3AC14.2050107@slax.org> <20090224141548.GB5482@mit.edu>
In-Reply-To: <20090224141548.GB5482@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I suggest to remove unionfs from Andrew's -mm tree and replace it by aufs2!
>> Tell me why this should not happen...
> 
> Um, you need to tell us why aufs2 is better than Unionfs.  The burden
> of proof rests on your shoulders.

I understand and agree.

At the time Slax switched from unionfs to aufs, there were the following issues:
(unionfs people are welcome to comment on what's improved in newest unionfs 2.x)

1) Better branch manipulation in aufs
- unionfs used ioctls to manipulate branches, aufs used remount. I do not quite understand which one was better, but remount didn't need any special binary to manipulate branches so that was better for me.

I guess unionfs switched to remount too; not because it is better, but because it was needed just to get mainlined. From my point of view, they do many things just because they desperately need to be mainlined, even if they would like to do it differently (the ioctl branch manipulation is just an example)

2) More branches in one aufs union
- unionfs supported (if I remember correctly) only 128 branches. Aufs supported 1024 branches and if there was an option to support 32767 branches (didn't test it though).

3) Fully working mmap support in aufs
- unionfs wasn't even able to mount a loop file from the union. At the time of my switch, there were no mmap support in unionfs at all. I think they already implemented it, re-using aufs's method.

4) Persistent inode support in aufs
- I'm not sure if I remember this correctly. In unionfs, when a branch was added, I believe that all the inode numbers changed. That had fatal impact on many programs, since it is not supposed to happen. Aufs maintain persistent inode numbers just perfectly.

5) Better stability in aufs
- it is always said that this is a subjective issue. In my opinion, it's pretty objective. Unionfs didn't work well in the past, and they keep fixing race conditions all the time, even now in -mm tree. Aufs simply worked, and it still simply works. I do not remember any single system freeze with aufs, but I remember a lot of freezes with unionfs.

6) Branch information through /sys instead of /proc/mounts
- imagine you added 1000 branches, what happens with your /proc/mounts with unionfs? In aufs, it's just OK.


Tomas M
slax.org


