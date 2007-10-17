Return-Path: <linux-kernel-owner+w=401wt.eu-S1759639AbXJQKRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbXJQKRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 06:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbXJQKRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 06:17:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:13610 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbXJQKRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 06:17:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ng2I49WboMxkU6tkFzHYs/WXKGC2bm55+bUgLn9Gi7TPNbyAAChs3nlidnpK6MpFpNsRAN2xkdcE5JGuvtKpn8Ae+8lCAI80vav4ZIC0LejumnNvzKG5fredy78ddcViGUbDrMltzZWHifywIwIlihI5pKFZVlfEmnHJ5SMPCn0=
Message-ID: <3ae72650710170317m75d0a664oe2bfa98ab70298e9@mail.gmail.com>
Date: Wed, 17 Oct 2007 12:17:39 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-2.6.23-git3: Many sysfs-related warnings in dmesg
Cc: "Greg KH" <greg@kroah.com>, "Jens Axboe" <jens.axboe@oracle.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Tejun Heo" <htejun@gmail.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200710170158.10234.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710132126.33085.rjw@sisk.pl> <200710162313.20373.rjw@sisk.pl>
	 <20071016213626.GA21815@kroah.com> <200710170158.10234.rjw@sisk.pl>
X-Google-Sender-Auth: d8d40fb32528731a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, 16 October 2007 23:36, Greg KH wrote:
> > On Tue, Oct 16, 2007 at 11:13:19PM +0200, Rafael J. Wysocki wrote:
> > > On Tuesday, 16 October 2007 22:50, Jens Axboe wrote:
> > > > On Tue, Oct 16 2007, Greg KH wrote:
> > > > > On Tue, Oct 16, 2007 at 10:04:51PM +0200, Rafael J. Wysocki wrote:
> > > > > > On Tuesday, 16 October 2007 06:50, Greg KH wrote:
> > > > > > > On Sat, Oct 13, 2007 at 09:26:32PM +0200, Rafael J. Wysocki wrote:
> > > > > > > > Hi,
> > > > > > > >
> > > > > > > > There are many traces like this in my dmesg from 2.6.23-git3 (they don't
> > > > > > > > appear for vanilla 2.6.23):
> > > > > > > >
> > > > > > > > <4>sysfs: duplicate filename 'ethxx1' can not be created
> > > > > > > > WARNING: at /home/rafael/src/linux-2.6/fs/sysfs/dir.c:425 sysfs_add_one()
> > > > > > > >
> > > > > > > > Call Trace:
> > > > > > > >  [<ffffffff802d1532>] sysfs_add_one+0x5c/0xc9
> > > > > > > >  [<ffffffff802d2411>] sysfs_create_link+0xd1/0x12c
> > > > > > > >  [<ffffffff803756da>] device_rename+0x17a/0x1db
> > > > > > > >  [<ffffffff803c903d>] dev_change_name+0x114/0x20c
> > > > > > > >  [<ffffffff803c9339>] dev_ifsioc+0x204/0x2d0
> > > > > > > >  [<ffffffff803c9925>] dev_ioctl+0x520/0x633
> > > > > > > >  [<ffffffff803bf445>] sk_alloc+0x37/0x10c
> > > > > > > >  [<ffffffff8024b977>] up_read+0x9/0xb
> > > > > > > >  [<ffffffff803bc65e>] sock_ioctl+0x1fe/0x20c
> > > > > > > >  [<ffffffff8029b34a>] do_ioctl+0x2a/0x77
> > > > > > > >  [<ffffffff8029b5e8>] vfs_ioctl+0x251/0x26e
> > > > > > > >  [<ffffffff8029b664>] sys_ioctl+0x5f/0x83
> > > > > > > >  [<ffffffff8020bd4e>] system_call+0x7e/0x83
> > > > > > > >
> > > > > > > > net ethxx1: device_rename: sysfs_create_symlink failed (-17)
> > > > > > > > sysfs: duplicate filename 'eth1' can not be created
> > > > > > > >
> > > > > > > > Everything seems to work, but this just looks fishy.
> > > > > > >
> > > > > > > This is a userspace program renaming your network device to a name that
> > > > > > > is already in use.  What distro and release is this?
> > > > > >
> > > > > > openSUSE 10.2, with some updates (not the most recent, though).
> > > > >
> > > > > Can you try 10.3?  I think we fixed this issue there.
> > > >
> > > > Ehm nope:
> > > >
> > > > Oct 16 19:36:27 carl kernel: sysfs: duplicate filename 'wlan0_rename'
> > > > can not be created
> > > > Oct 16 19:36:27 carl kernel: udev: renamed network interface wmaster0 to
> > > > eth1
> > > > Oct 16 19:36:27 carl kernel: WARNING: at fs/sysfs/dir.c:425
> > > > sysfs_add_one()
> > > > Oct 16 19:36:27 carl kernel:  [<c01b2dbf>] sysfs_add_one+0x9f/0xe0
> > > > Oct 16 19:36:27 carl kernel:  [<c01b3b76>] sysfs_create_link+0x86/0x110
> > > > Oct 16 19:36:27 carl kernel:  [<c02398ca>] device_rename+0x17a/0x1e0
> > > > Oct 16 19:36:27 carl kernel:  [<c015b56f>] filemap_fault+0x1ff/0x400
> > > > Oct 16 19:36:27 carl kernel:  [<c02b8fc0>] dev_change_name+0xb0/0x210
> > > > Oct 16 19:36:27 carl kernel:  [<c02b9779>] dev_ioctl+0x3c9/0x530
> > > > Oct 16 19:36:27 carl kernel:  [<c01a1938>]
> > > > inotify_d_instantiate+0x18/0x80
> > > > Oct 16 19:36:27 carl kernel:  [<c0120044>] do_page_fault+0x4a4/0x6f0
> > > > Oct 16 19:36:27 carl kernel:  [<c02ac080>] sock_ioctl+0x0/0x220
> > > > Oct 16 19:36:27 carl kernel:  [<c01851ab>] do_ioctl+0x2b/0x90
> > > > Oct 16 19:36:27 carl kernel:  [<c02ad50b>] sys_socket+0x2b/0x50
> > > > Oct 16 19:36:27 carl kernel:  [<c018542e>] vfs_ioctl+0x21e/0x2a0
> > > > Oct 16 19:36:27 carl kernel:  [<c01854ed>] sys_ioctl+0x3d/0x70
> > > > Oct 16 19:36:27 carl kernel:  [<c01042d6>] sysenter_past_esp+0x6b/0xa1
> > > > Oct 16 19:36:27 carl kernel:  =======================
> > > > Oct 16 19:36:27 carl kernel: net wlan0_rename: device_rename:
> > > > sysfs_create_symlink failed (-17)
> > >
> > > Plus it doesn't happen on 2.6.23 on my system, so I count it as a regression.
> >
> > It's a new warning I've added to the kernel to catch stupid userspace
> > and kernel code that is quietly failing when they are doing things
> > incorrectly with kobjects and sysfs.
> >
> > So it's not really a "regression" in that we never notified anyone of
> > this kind of thing before, think of it as a new feature :)
>
> Well, it seems to be a little bit over the top, then. ;-)

In the network renaming it's a bit noisy, yes, but for other users
which we discovered by this, it already exposed real bugs.

Kay
