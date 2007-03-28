Return-Path: <linux-kernel-owner+w=401wt.eu-S932279AbXC1P0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbXC1P0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 11:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932290AbXC1P0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 11:26:22 -0400
Received: from sandeen.net ([209.173.210.139]:21715 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279AbXC1P0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 11:26:21 -0400
X-Greylist: delayed 1795 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Mar 2007 11:26:21 EDT
Message-ID: <460A821B.4080308@sandeen.net>
Date: Wed, 28 Mar 2007 09:56:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: Oliver Joa <oliver@j-o-a.de>
CC: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       xfs-oss <xfs@oss.sgi.com>
Subject: Re: Corrupt XFS -Filesystems on new Hardware and Kernel
References: <46094344.4090007@j-o-a.de> <20070328113141.GQ32597093@melbourne.sgi.com> <460A6298.4040702@j-o-a.de>
In-Reply-To: <460A6298.4040702@j-o-a.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Joa wrote:
> Ok, here is a test:
> 
> test:/# find / -xdev | cpio -padm /test/
> cpio: /usr/src/linux-2.6.20.2/Documentation/networking/NAPI_HOWTO.txt: 
> Structure needs cleaning
> 3648371 blocks
> test:/#

That, cryptically enough, means that the filesystem has detected a 
problem and has shut down.

> test:/home/olli# uname -a
> Linux test 2.6.20.4-majestix-1 #1 SMP PREEMPT Tue Mar 27 12:15:41 CEST 
> 2007 i686 GNU/Linux
> 
> dmesg gives the following:
> [15442.935941] Filesystem "sda3": XFS internal error xfs_iformat(6) at 
> line 492 of file fs/xfs/xfs_inode.c.  Caller 0xc0211f94
> [15442.936003]  [<c0216dba>] xfs_iread+0x4ee/0x6e8
> [15442.936039]  [<c0211f94>] xfs_iget+0x2e4/0x714
> [15442.936071]  [<c0211f94>] xfs_iget+0x2e4/0x714
> [15442.936101]  [<c02293be>] xfs_dir_lookup_int+0x7d/0xd4
> [15442.936135]  [<c022cc6b>] xfs_lookup+0x52/0x78
> [15442.936167]  [<c0238a22>] xfs_vn_lookup+0x3b/0x70
> [15442.936201]  [<c0153e6d>] do_lookup+0xa3/0x140
> [15442.936234]  [<c015578e>] __link_path_walk+0x73d/0xb5e
> [15442.936278]  [<c0211655>] xfs_iunlock+0x51/0x6d
> [15442.936309]  [<c0155bf3>] link_path_walk+0x44/0xb3
> [15442.936342]  [<c0155efe>] do_path_lookup+0x176/0x191
> [15442.936373]  [<c0154ef8>] getname+0x59/0x8f
> [15442.936402]  [<c01566b8>] __user_walk_fd+0x2f/0x45
> [15442.936431]  [<c0150a09>] vfs_lstat_fd+0x16/0x3d
> [15442.936461]  [<c0150a75>] sys_lstat64+0xf/0x23
> [15442.936490]  [<c0102bd8>] syscall_call+0x7/0xb
> [15442.936519]  =======================

For one reason or another, xfs has detected a corrupted on-disk inode 
format which it cannot recognize, and shuts down.  It is likely the 
result of something which has gone wrong previously.  xfs_repair should 
fix it.  Are there other non-xfs messages in your logs indicating other 
problems prior to this?

-Eric
