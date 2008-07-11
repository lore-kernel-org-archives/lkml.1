Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbYGKTyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbYGKTyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYGKTyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:54:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47672 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbYGKTyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:54:14 -0400
Date: Fri, 11 Jul 2008 21:54:52 +0200
From: Pavel Machek <pavel@suse.cz>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26-rc7: BUG at kernel/power/snapshot.c:493
Message-ID: <20080711195452.GB7190@elf.ucw.cz>
References: <1214584985.22228.15.camel@localhost> <200806271907.29968.rjw@sisk.pl> <1214590455.22228.16.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1214590455.22228.16.camel@localhost>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Anyone else seeing this? Happened after resuming from s2both (from
> > > disk)...
> > 
> > At what point exactly did it happen?
> 
> I am attaching the full dmesg.

Something is seriously wrong here.

> usbcore: registered new interface driver usbhid
> usbhid: v2.6:USB HID core driver
> TCP cubic registered
> NET: Registered protocol family 10
> lo: Disabled Privacy Extensions
> Mobile IPv6
> NET: Registered protocol family 17
> NET: Registered protocol family 15
> Using IPI No-Shortcut mode
> RAMDISK: ext2 filesystem found at block 0
> RAMDISK: Loading 2000KiB [1 disk] into ram disk... |/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|done.
> EXT2-fs warning: checktime reached, running e2fsck is recommended
> VFS: Mounted root (ext2 filesystem).
> ------------[ cut here ]------------
> kernel BUG at kernel/power/snapshot.c:493!
> invalid opcode: 0000 [#1] PREEMPT SMP 
> Modules linked in:

This is _after_ we mounted filesystems... we should not be resuming at
this point.

> Pid: 568, comm: linuxrc Not tainted (2.6.26-rc7-sonne #35)
> EIP: 0060:[<c0157f99>] EFLAGS: 00010282 CPU: 0
> EIP is at memory_bm_set_bit+0x29/0x30
> EAX: fffffff2 EBX: f7165f1c ECX: 00000000 EDX: 03000200
> ESI: f7115000 EDI: b7f2a008 EBP: f7165f28 ESP: f7165f18
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process linuxrc (pid: 568, ti=f7164000 task=f7b65f80 task.ti=f7164000)
> Stack: f7165f1c 00000013 f7117000 00000002 f7165f5c c0158e9b bf96e5ec c02dd570 
>        00001000 c05fa980 00000008 00000008 00000000 00000000 f7000200 c05fa980 
>        b7f2a008 f7165f70 c015b3af f7000200 b7f2a008 00001000 f7165f90 c0185e28 
> Call Trace:
>  [<c0158e9b>] ? snapshot_write_next+0xcb/0x7a0
>  [<c02dd570>] ? write_chan+0x0/0x380
>  [<c015b3af>] ? snapshot_write+0x1f/0x70
>  [<c0185e28>] ? vfs_write+0x98/0x120
>  [<c015b390>] ? snapshot_write+0x0/0x70
>  [<c0185f6d>] ? sys_write+0x3d/0x70
>  [<c010333a>] ? syscall_call+0x7/0xb
>  =======================
> Code: 00 00 55 89 e5 53 83 ec 0c 8d 4d f8 8d 5d f4 89 1c 24 e8 4b ff ff ff 85 c0 75 10 8b 55 f8 8b 45 f4 f0 0f ab 02 83 c4 0c 5b 5d c3 <0f> 0b eb fe 8d 76 00 8b 0d 0c a9 5f c0 55 89 e5 85 c9 74 14 8b 
> EIP: [<c0157f99>] memory_bm_set_bit+0x29/0x30 SS:ESP 0068:f7165f18
> ---[ end trace 70a926e889075b3c ]---

> Clocksource tsc unstable (delta = -208377644 ns)
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on sda3, internal journal
> ext3_orphan_cleanup: deleting unreferenced inode 1805649
> ext3_orphan_cleanup: deleting unreferenced inode 1228813
> EXT3-fs: sda3: 2 orphan inodes deleted
> EXT3-fs: recovery complete.
> EXT3-fs: mounted filesystem with ordered data mode.
> VFS: Mounted root (ext3 filesystem).
> Trying to move old root to /initrd ... /initrd does not exist. Ignored.
> Unmounting old root
> Trying to free ramdisk memory ... okay
> Freeing unused kernel memory: 268k freed
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs warning: mounting fs with errors, running e2fsck is recommended
> EXT3 FS on dm-0, internal journal
> EXT3-fs: recovery complete.
> EXT3-fs: mounted filesystem with ordered data mode.

You should really fsck at this point.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
