Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289AbZC1Amn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbZC1Amn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 20:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZC1Ame
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 20:42:34 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:59517 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbZC1Amd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 20:42:33 -0400
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
Date: Fri, 27 Mar 2009 20:42:14 -0400
User-Agent: KMail/1.11.1 (Linux/2.6.28.9; KDE/4.2.1; i686; ; )
References: <20090327112438.GQ6239@mit.edu>
 <200903271837.08755.gene.heskett@verizon.net> <20090327225553.GE5176@mit.edu>
In-reply-to: <20090327225553.GE5176@mit.edu>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200903272042.15080.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 March 2009, Theodore Tso wrote:
>On Fri, Mar 27, 2009 at 06:37:08PM -0400, Gene Heskett wrote:
>> Thanks Ted, I will build 2.6.28.9 with this:
>> [root@coyote linux-2.6.28.9]# grep EXT .config
>> [...]
>> CONFIG_PAGEFLAGS_EXTENDED=y
>> CONFIG_EXT2_FS=m
>> CONFIG_EXT2_FS_XATTR=y
>> CONFIG_EXT2_FS_POSIX_ACL=y
>> # CONFIG_EXT2_FS_SECURITY is not set
>> CONFIG_EXT2_FS_XIP=y
>> CONFIG_EXT3_FS=m
>> CONFIG_EXT3_FS_XATTR=y
>> CONFIG_EXT3_FS_POSIX_ACL=y
>> CONFIG_EXT3_FS_SECURITY=y
>> CONFIG_EXT4_FS=y
>> # CONFIG_EXT4DEV_COMPAT is not set
>> # CONFIG_EXT4_FS_XATTR is not set
>> CONFIG_GENERIC_FIND_NEXT_BIT=y
>>
>> Anything there that isn't compatible?
>
>Well, if you need extended attributes (if you are using SELinux, then
>you need extended attributes) you'll want to enable
>CONFIG_EXT4_FS_XATTR.
>
>If you want to use ext4 on your root filesystem, you may need to take
>some special measures depending on your distribution.  Using the boot
>command-line option rootfstype=ext4 will work on many distributions,
>but I haven't tested all of them.  It definitely works on Ubuntu, and
>it should work if you're not using an initial ramdisk.
>
>Oh yeah; the other thing I should warn you about is that 2.6.28.9
>won't have the replace-via-rename and replace-via-truncate
>workarounds.  So if you crash and your applications aren't using
>fsync(), you could end up seeing the zero-length files.  I very much
>doubt that will make a big difference for your /amandatapes partition,
>but if you want to use this for the filesystem where you have home
>directory, you'll probably want the workaround patches.  I've heard
>reports of KDE users telling me that when they initial start up their
>desktop, literally hundreds of files are rewritten by their desktop,
>just starting it up.  (Why?  Who knows?  It's not good for SSD
>endurance, in any case.)  But if you crash while initially logging in,
>your KDE configuration files might get wiped out w/o the
>replace-via-rename and replace-via-truncate workaround patches.
>
>> I'll build that, but only switch the /amandatapes mount in fstab for
>> testing tonight unless you spot something above.
>
>OK, so you're not worried about your root filesystem, and presumably
>the issue with your home directory won't be an issue for you either.
>The only question then is whether you need extended attribute support.
>
>Regards,
>
>					- Ted

Thanks Ted, its building w/o the extra CONFIG_EXT4_FS_XATTR atm, but I'll 
enable that and do it again before I reboot.  I had just fired off the build 
when I saw your answer. NBD, my 'makeit' script is pretty complete.

Thank you.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The only rose without thorns is friendship.

