Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbZC0W4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbZC0W4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758447AbZC0W4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:56:08 -0400
Received: from THUNK.ORG ([69.25.196.29]:50518 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757940AbZC0W4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:56:07 -0400
Date: Fri, 27 Mar 2009 18:55:54 -0400
From: Theodore Tso <tytso@mit.edu>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327225553.GE5176@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Gene Heskett <gene.heskett@verizon.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090327112438.GQ6239@mit.edu> <200903271519.10921.gene.heskett@verizon.net> <20090327194836.GZ6239@mit.edu> <200903271837.08755.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903271837.08755.gene.heskett@verizon.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 06:37:08PM -0400, Gene Heskett wrote:
> Thanks Ted, I will build 2.6.28.9 with this:
> [root@coyote linux-2.6.28.9]# grep EXT .config
> [...]
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_EXT2_FS=m
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> # CONFIG_EXT2_FS_SECURITY is not set
> CONFIG_EXT2_FS_XIP=y
> CONFIG_EXT3_FS=m
> CONFIG_EXT3_FS_XATTR=y
> CONFIG_EXT3_FS_POSIX_ACL=y
> CONFIG_EXT3_FS_SECURITY=y
> CONFIG_EXT4_FS=y
> # CONFIG_EXT4DEV_COMPAT is not set
> # CONFIG_EXT4_FS_XATTR is not set
> CONFIG_GENERIC_FIND_NEXT_BIT=y
> 
> Anything there that isn't compatible?

Well, if you need extended attributes (if you are using SELinux, then
you need extended attributes) you'll want to enable
CONFIG_EXT4_FS_XATTR.

If you want to use ext4 on your root filesystem, you may need to take
some special measures depending on your distribution.  Using the boot
command-line option rootfstype=ext4 will work on many distributions,
but I haven't tested all of them.  It definitely works on Ubuntu, and
it should work if you're not using an initial ramdisk.

Oh yeah; the other thing I should warn you about is that 2.6.28.9
won't have the replace-via-rename and replace-via-truncate
workarounds.  So if you crash and your applications aren't using
fsync(), you could end up seeing the zero-length files.  I very much
doubt that will make a big difference for your /amandatapes partition,
but if you want to use this for the filesystem where you have home
directory, you'll probably want the workaround patches.  I've heard
reports of KDE users telling me that when they initial start up their
desktop, literally hundreds of files are rewritten by their desktop,
just starting it up.  (Why?  Who knows?  It's not good for SSD
endurance, in any case.)  But if you crash while initially logging in,
your KDE configuration files might get wiped out w/o the
replace-via-rename and replace-via-truncate workaround patches.

> I'll build that, but only switch the /amandatapes mount in fstab for testing 
> tonight unless you spot something above.

OK, so you're not worried about your root filesystem, and presumably
the issue with your home directory won't be an issue for you either.
The only question then is whether you need extended attribute support.

Regards,

					- Ted
