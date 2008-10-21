Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbYJUBMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbYJUBMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 21:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYJUBMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 21:12:13 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:45035 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbYJUBMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 21:12:12 -0400
Message-ID: <48FD2C74.2070608@lougher.demon.co.uk>
Date: Tue, 21 Oct 2008 02:12:20 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
CC: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 00/16] Squashfs: compressed read-only	filesystem
References: <E1KqrTW-0001x8-3h@dylan> <1224268027.18940.78.camel@moss-terrapins.epoch.ncsc.mil>
In-Reply-To: <1224268027.18940.78.camel@moss-terrapins.epoch.ncsc.mil>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Quigley wrote:
> Looking through the code I see two references to xattrs, one is the
> index of the xattr table in the superblock and there seems to be struct
> member in one of the inode structures that is an index into this table.
> Looking through the code I don't see either of these used at all. Do you
> intend to add xattr support at some point? I saw reference to the desire
> to add xattr support in an email from 2004 but you said that the code
> has been rewritten since then. If you are going to add xattr support you
> probably want to add it to more than just regular files. In SELinux and
> other LSMs symlinks and directories are also labeled so they will need
> xattr entries.

Yes and yes.  I am intending to add xattr support, something that's been 
on my to-do list for a long time (since 2004 as you said), but it's been 
something which I've never got the time to do.  Once (if) Squashfs is 
mainlined, it will be the next thing.

The xattr references in the layout is my attempt at forward planning to 
avoid making an incompatible layout change when I finally get around to 
implementing it.  My plan is to put xattrs in a table (referenced by the 
  superblock), and then put indexes in "extended" inodes which index 
into the table (as you noticed).  The general idea in Squashfs is that 
inodes get optimised for normally occurring cases, and less common cases 
(that  would need a bigger inode) get to use an extended inode. 
Squashfs currently has an extended regular file inode, which is where 
the xattr index will sit, and so this has had an xattr index added.  The 
other inodes don't currently have extended inodes, these will be defined 
when I implement xattrs (which is why they're missing).

Having said that, I've fscked up and forgotten to add an xattr field to 
the extended directory inode which is currently defined :)

Thanks for spotting this.

Phillip

> Dave
> 
> 

