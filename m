Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407AbZEIMoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbZEIMoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 08:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZEIMoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 08:44:30 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40209 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbZEIMo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 08:44:29 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 9 May 2009 14:44:25 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 2.6.30-rc: reiserfs_delete_xattrs log spam (bug 13122)
To: Jeff Mahoney <jeffm@suse.com>
cc: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4A057951.8040501@s5r6.in-berlin.de>
Message-ID: <tkrat.fe49a8c298128f65@s5r6.in-berlin.de>
References: <4A057951.8040501@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On  9 May, Stefan Richter wrote:
> I just switched from 2.6.29.1 to 2.6.30-rc5, and I'm getting the same as 
> the reporter of http://bugzilla.kernel.org/show_bug.cgi?id=13122 alias
> http://marc.info/?l=linux-kernel&m=123990989515105, i.e. repetitions of
>  >>>
> May  9 14:27:22 stein REISERFS warning (device sda1): jdm-20004 
> reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
> May  9 14:27:22 stein
> <<<
> 
> This happens in irregular intervals, but a lot of times --- presumably 
> when certain files are accessed.  I'm on a recently set-up Gentoo 
> machine.  I created its root filesystem using the Gentoo x86-64 minimal 
> boot CD; my guess is that the kernel of the boot CD had 
> CONFIG_REISERFS_FS_XATTR enabled.  All kernels which I used since then 
> have it disabled:  2.6.27-gentoo-r8, 2.6.29.1, now 2.6.30-rc5.

PS:  Also, the following came up at this (= first) boot of 2.6.30-rc, as
a warm reboot from 2.6.29.1. I have no idea whether it's connected to
the issue.

May  9 13:56:53 stein REISERFS (device sda1): found reiserfs format "3.6" with standard journal
May  9 13:56:53 stein REISERFS (device sda1): using ordered data mode
May  9 13:56:53 stein REISERFS (device sda1): journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
May  9 13:56:53 stein REISERFS (device sda1): checking transaction log (sda1)
May  9 13:56:53 stein REISERFS (device sda1): Using r5 hash to sort names
May  9 13:56:53 stein ------------[ cut here ]------------
May  9 13:56:53 stein WARNING: at fs/namei.c:1251 lookup_one_len+0x39/0xc0()
May  9 13:56:53 stein Hardware name: System Product Name
May  9 13:56:53 stein Modules linked in:
May  9 13:56:53 stein Pid: 1, comm: swapper Not tainted 2.6.30-rc5 #1
May  9 13:56:53 stein Call Trace:
May  9 13:56:53 stein [<ffffffff80231fa6>] ? warn_slowpath_fmt+0xd9/0x10b
May  9 13:56:53 stein [<ffffffff8044b3f7>] ? printk+0x4e/0x57
May  9 13:56:53 stein [<ffffffff802e229e>] ? reiserfs_info+0x71/0x91
May  9 13:56:53 stein [<ffffffff80291617>] ? lookup_one_len+0x39/0xc0
May  9 13:56:53 stein [<ffffffff802f08c5>] ? reiserfs_xattr_init+0x2c/0x8b
May  9 13:56:53 stein [<ffffffff802e11bb>] ? reiserfs_fill_super+0x85f/0x950
May  9 13:56:53 stein [<ffffffff8037ce9b>] ? get_device+0x14/0x1a
May  9 13:56:53 stein [<ffffffff8044d818>] ? __down_write_nested+0x34/0xa9
May  9 13:56:53 stein [<ffffffff8028ad68>] ? sget+0x3d8/0x3ea
May  9 13:56:53 stein [<ffffffff8028b479>] ? get_sb_bdev+0x11a/0x16b
May  9 13:56:53 stein [<ffffffff802e095c>] ? reiserfs_fill_super+0x0/0x950
May  9 13:56:53 stein [<ffffffff8026f97c>] ? kstrdup+0x2b/0x43
May  9 13:56:53 stein [<ffffffff8028a2be>] ? vfs_kern_mount+0x4f/0x95
May  9 13:56:53 stein [<ffffffff8028a357>] ? do_kern_mount+0x43/0xdc
May  9 13:56:53 stein [<ffffffff8029ebb1>] ? do_mount+0x6fd/0x747
May  9 13:56:53 stein [<ffffffff8029ec85>] ? sys_mount+0x8a/0xd9
May  9 13:56:53 stein [<ffffffff8056ed3a>] ? mount_block_root+0xe3/0x27c
May  9 13:56:53 stein [<ffffffff8056f04e>] ? prepare_namespace+0x12c/0x156
May  9 13:56:53 stein [<ffffffff8056e61e>] ? kernel_init+0x173/0x183
May  9 13:56:53 stein [<ffffffff8020be2a>] ? child_rip+0xa/0x20
May  9 13:56:53 stein [<ffffffff8056e4ab>] ? kernel_init+0x0/0x183
May  9 13:56:53 stein [<ffffffff8020be20>] ? child_rip+0x0/0x20
May  9 13:56:53 stein ---[ end trace 36cf86746b5051e0 ]---
May  9 13:56:53 stein VFS: Mounted root (reiserfs filesystem) readonly on device 8:1.

-- 
Stefan Richter
-=====-==--= -=-= -=--=
http://arcgraph.de/sr/

