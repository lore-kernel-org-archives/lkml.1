Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYJUQ3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYJUQ3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 12:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYJUQ3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 12:29:22 -0400
Received: from zombie2.ncsc.mil ([144.51.88.133]:49196 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbYJUQ3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 12:29:20 -0400
Subject: Re: Subject: [PATCH 00/16] Squashfs: compressed
	read-only	filesystem
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
In-Reply-To: <48FD2C74.2070608@lougher.demon.co.uk>
References: <E1KqrTW-0001x8-3h@dylan>
	 <1224268027.18940.78.camel@moss-terrapins.epoch.ncsc.mil>
	 <48FD2C74.2070608@lougher.demon.co.uk>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 12:09:08 -0400
Message-Id: <1224605348.31157.67.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 02:12 +0100, Phillip Lougher wrote:
> David P. Quigley wrote:
> > Looking through the code I see two references to xattrs, one is the
> > index of the xattr table in the superblock and there seems to be struct
> > member in one of the inode structures that is an index into this table.
> > Looking through the code I don't see either of these used at all. Do you
> > intend to add xattr support at some point? I saw reference to the desire
> > to add xattr support in an email from 2004 but you said that the code
> > has been rewritten since then. If you are going to add xattr support you
> > probably want to add it to more than just regular files. In SELinux and
> > other LSMs symlinks and directories are also labeled so they will need
> > xattr entries.
> 
> Yes and yes.  I am intending to add xattr support, something that's been 
> on my to-do list for a long time (since 2004 as you said), but it's been 
> something which I've never got the time to do.  Once (if) Squashfs is 
> mainlined, it will be the next thing.
> 
> The xattr references in the layout is my attempt at forward planning to 
> avoid making an incompatible layout change when I finally get around to 
> implementing it.  My plan is to put xattrs in a table (referenced by the 
>   superblock), and then put indexes in "extended" inodes which index 
> into the table (as you noticed).  The general idea in Squashfs is that 
> inodes get optimised for normally occurring cases, and less common cases 
> (that  would need a bigger inode) get to use an extended inode. 
> Squashfs currently has an extended regular file inode, which is where 
> the xattr index will sit, and so this has had an xattr index added.  The 
> other inodes don't currently have extended inodes, these will be defined 
> when I implement xattrs (which is why they're missing).
> 
> Having said that, I've fscked up and forgotten to add an xattr field to 
> the extended directory inode which is currently defined :)
> 
> Thanks for spotting this.
> 
> Phillip
> 
> > Dave
> > 
> > 

Looking through the code I noticed that you give certain object types
the same inode number for all instances of it (devices, fifo/sockets).
How is this done internally? Do these types of objects occupy the same
position on the inode table? If so how do you differentiate between a
device and a socket?

I have some other comments but I'll post them under the specific
patches.

I use to work on Unionfs and we used CVS initially for our SCM. When we
started working on mainlining Unionfs we moved over to a GIT based
system and we found it worked a lot better. You might want to consider
moving your patches to a GIT tree that you make publically available so
people can just clone, compile, and test them. I don't see anything that
stops Squashfs from being compiled and loaded as a module so it might
not be necessary but it makes it easier for people who want to test the
code or even contribute patches.

Dave

