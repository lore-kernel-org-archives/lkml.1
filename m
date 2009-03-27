Return-Path: <linux-kernel-owner+w=401wt.eu-S1757145AbZC0Whg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbZC0Whg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbZC0Wh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:37:26 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:38771 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbZC0WhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:37:25 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Date: Fri, 27 Mar 2009 18:37:08 -0400
User-Agent: KMail/1.11.1 (Linux/2.6.28.9; KDE/4.2.1; i686; ; )
References: <20090327112438.GQ6239@mit.edu>
 <200903271519.10921.gene.heskett@verizon.net> <20090327194836.GZ6239@mit.edu>
In-reply-to: <20090327194836.GZ6239@mit.edu>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200903271837.08755.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 March 2009, Theodore Tso wrote:
>On Fri, Mar 27, 2009 at 03:19:10PM -0400, Gene Heskett wrote:
>> >You've said for a long that that ext3 is really bad in that it
>> >inflicts this --- I agree with you.  People should use other
>> >filesystems which are better.  This includes ext4, which is completely
>> >format compatible with ext3.  They don't even have to switch on
>> >extents support to get better behaviour.  Just mounting an ext3
>> >filesystem with ext4 will result in better behaviour.
>>
>> Ohkay.  But in a 'make xconfig' of 2.6.28.9, how much of ext4 can be
>> turned on without rendering the old ext3 fstab defaults incompatible
>> should I be forced to boot a kernel with no ext4 support?
>
>Ext4 doesn't make any non-backwards compatible changes to the
>filesystem.  So if you just take an ext3 filesystem, and mount it as
>ext4, it will work just fine; you will get delayed allocation, you
>will get a slightly boosted write priority for kjournald, and then
>when you unmount it, that filesystem will work *just* *fine* on a
>kernel with no ext4 support.  You can mount it as an ext3 filesystem.
>
>If you use tune2fs to enable various ext4 features, such as extents,
>etc., then when you mount the filesystem as ext4, you will get the
>benefit of extents for any new files which are created, and once you
>do that, the filesystem can't be mounted on an ext3-only system, since
>ext3 doesn't know how to deal with extents.
>
>And of course, if you want *all* of ext4's benefits, including the
>full factor of 6-8 improvement in fsck times, then you will be best
>served by creating a new ext4 filesystem from scratch and doing a
>backup/reformat/restore pass.
>
>But if you're just annoyed by the large latencies in Ingo's "make
>-j32" example, simply taking the ext3 filesystem and mounting it as
>ext4 should make those problems go away.  And it won't make any
>incompatible changes to the filesystem.  (This didn't use to be true
>in the pre-2.6.26 days, but I insisted on getting this fixed so people
>could always mount an ext2 or ext3 filesystems using ext4 without the
>kernel making any irreversible filesystem format changes behind the
>user's back.)
>
>					- Ted

Thanks Ted, I will build 2.6.28.9 with this:
[root@coyote linux-2.6.28.9]# grep EXT .config
[...]
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=m
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
# CONFIG_EXT4DEV_COMPAT is not set
# CONFIG_EXT4_FS_XATTR is not set
CONFIG_GENERIC_FIND_NEXT_BIT=y

Anything there that isn't compatible?

I'll build that, but only switch the /amandatapes mount in fstab for testing 
tonight unless you spot something above.

Thanks.
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Losing your drivers' license is just God's way of saying "BOOGA, BOOGA!"

