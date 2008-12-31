Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbYLaHeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbYLaHeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 02:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYLaHeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 02:34:09 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:46687 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbYLaHeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 02:34:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hOfDOb1RUJbHf+1QpSjdyJjX2/22N2Lh8rd195oTgwTXxzxrHrmcRaqUkD7UXTwizo
         HUZJVN8mkKqXyxWnh5D+URAhCI1+MLsp6RNyRkmS6dgworPcdrMRI8vJb/3XSXGZ17+t
         0N+d8F4iaFC42hbz867Q9sHnuIWfxIqz7Xvqo=
Message-ID: <9bd6b5360812302334t2c6aca67s62ba54438d2bda9e@mail.gmail.com>
Date: Wed, 31 Dec 2008 15:34:03 +0800
From: sniper <s3c24xx@gmail.com>
To: "Daniel Phillips" <phillips@phunq.net>
Subject: Re: Tux3 report: A Golden Copy
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tux3@tux3.org
In-Reply-To: <200812301935.49303.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200812301935.49303.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 11:35 AM, Daniel Phillips <phillips@phunq.net> wrote:
> All versions of Tux3 are special, we think, but this one is a little
> more special than all the rest: for the first time, it survives
> repeated fsx-linux runs.  That is mainly due to a burst of amazingly
> accurate work by Hirofumi, and finishing up the SMP lock coverage.
>
> Here is the HowTo again, lightly updated to install the first official
> Tux3 Golden Copy:
>
>    # Get a kernel tree:
>    wget http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.5.tar.bz2
>    tar -xjf linux-2.6.26.5.tar.bz2
>    cd linux-2.6.26.5
>
>    # Get the Christmas tux3 patch and patch the kernel:
>    wget http://tux3.org/patches/tux3-2.6.26.5-4
>    patch <tux3-2.6.26.5-4 -p1
>
>    # Build linux with tux3:
>    make defconfig
>    make CONFIG_TUX3=y
>    sudo make install
>
>    # Get the Christmas tux3 userspace snapshot:
>    wget http://tux3.org/downloads/snapshots/tux3-20081230.tar.gz
>    tar -xzf tux3-20081230.tar.gz
>    cd tux3/user
>    make
>
>    # make a tux3 filesystem
>    sudo ./tux3 mkfs /dev/<testpartition>
>
> Boot and mount!
>
>    cat /proc/filesystems | grep tux3 && mount /dev/<testpartition> /mnt
>
> Recovery after crash or unexpected shutdown is easy:
>
>   tux3 mkfs <volname>
>
> In other words, do not expect Tux3 to survive this kind of treatment
> just yet.  Atomic commit is on the way, and is the last major change
> planned before starting review.
>
> Caveats are the same as before:
>
>   http://kerneltrap.org/mailarchive/linux-fsdevel/2008/12/26/4493214
>   "Tux3 for Christmas"
>
> And finally the usual offer:  If you drop by to lend a hand we will
> treat you with respect and admiration for showing such courage, and we
> will make you even more famous than you already are, by carving your
> name in the Tux3 Hall of Fame:
>
>  http://tux3.org/about.html
>
> Regards,
>
> Daniel
> --

Great, I have mounted tux3 filesystem under UML with stuffs in this mail,
but I still can't debug it with gdb. Anyone gives me suggestion?

fqh@ubuntu:~/Desktop/linux-2.6.26.5$ gdb -args linux ubda=tuxroot ubdb=testdev
GNU gdb 6.8-debian
Copyright (C) 2008 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "i486-linux-gnu"...
(gdb) run
Starting program: /home/fqh/Desktop/linux-2.6.26.5/linux ubda=tuxroot
ubdb=testdev
Locating the bottom of the address space ...
Program received signal SIGSEGV, Segmentation fault.
0x08066c7f in page_ok (page=<value optimized out>) at
arch/um/os-Linux/sys-i386/task_size.c:31
31                      n = *address;
(gdb)
