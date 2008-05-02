Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbYEBEwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbYEBEwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 00:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbYEBEwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 00:52:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062AbYEBEwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 00:52:46 -0400
Date: Thu, 1 May 2008 21:52:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lothar =?ISO-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.25: 'mkdir -p' does not work with rootdir as mount
 point inside a read only filesystem
Message-Id: <20080501215231.297e0d9d.akpm@linux-foundation.org>
In-Reply-To: <18456.34604.472989.35082@ipc1.ka-ro>
References: <18456.34604.472989.35082@ipc1.ka-ro>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 16:50:20 +0200 Lothar Wa__mann <LW@KARO-electronics.de> wrote:

> Hi,

(y'know that ~4000 people read your email and hit 'n'?  Except for me?
That's one bug I'd like to get fixed)

> when trying to create a directory path with 'mkdir -p' with the root
> being a mount point of a writeable filesystem that exists inside a
> read-only file system, mkdir return -EROFS.
> 
> This was tested with the latest git-tree from:
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
> 
> The last kernel I know of this has been working was 2.6.22.
> 
> E.g.:
> |root@triton1:/# mount
> |rootfs on / type rootfs (rw)
> |/dev/root on / type jffs2 (ro)
> |proc on /proc type proc (rw)
> |sysfs on /sys type sysfs (rw)
> |/dev/root on /dev/.static/dev type jffs2 (ro)
> |tmpfs on /dev type tmpfs (rw,size=10240k,mode=755)
> |tmpfs on /var type tmpfs (rw)
> |tmpfs on /tmp type tmpfs (rw)
> |devpts on /dev/pts type devpts (rw,gid=5,mode=620)
> |tmpfs on /dev/shm type tmpfs (rw)
> |root@triton1:/# mkdir -p /dev/.udev/db
> |mkdir: Cannot create directory `/dev/': Read-only file system
> 
> While:
> |root@triton1:/# cd /dev
> |root@triton1:/# mkdir -p .udev/db
> works as expected...
> 
> Has anyone else encountered this problem already?
> I've searched the archives but could not find anything related to this
> problem.

I had a shot at scripting this, but for me, everything works OK.

#!/bin/sh
dd if=/dev/zero of=file1 bs=1M count=32
dd if=/dev/zero of=file2 bs=1M count=32
yes | mkfs -t ext2 file1
yes | mkfs -t ext2 file2
mkdir -p mountpoint
mount -o loop file1 mountpoint
mkdir mountpoint/dir
umount mountpoint
mount -o loop,ro file1 mountpoint
mount -o loop file2 mountpoint/dir
mkdir -p $(/bin/pwd)/mountpoint/dir/subdir


are you able to modify the above so that it demonstrates the failure?

Thanks.
