Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbZCQOWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbZCQOWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 10:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbZCQOV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 10:21:59 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55276 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbZCQOV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 10:21:58 -0400
Subject: Re: [Jfs-discussion] [BUG/JFS/2.6.29-rc8] kernel BUG at
 fs/mpage.c:473!
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: jfs-discussion@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <49BDFB4F.7040405@in.ibm.com>
References: <49BDFB4F.7040405@in.ibm.com>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 09:21:50 -0500
Message-Id: <1237299710.26674.6.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-16 at 12:40 +0530, Sachin Sant wrote:
> While running file system stress (fsstress) on a JFS partition
> with 2.6.29-rc8, i hit the following BUG.

I tried reproducing this yesterday, but was unsuccessful.  Maybe I
didn't let it run long enough.  Have you run this successfully on
earlier kernels?  If so, what was the most recent that worked for you.
Have you seen it more than once?  I'm not sure how easy it is to
reproduce.

Thanks,
Shaggy

> ------------[ cut here ]------------
> kernel BUG at fs/mpage.c:473!
> cpu 0x0: Vector: 700 (Program Check) at [c0000000be9daba0]
>     pc: c00000000014e3a0: .__mpage_writepage+0xd0/0x630
>     lr: c0000000000dfedc: .write_cache_pages+0x288/0x42c
>     sp: c0000000be9dae20
>    msr: 8000000000029032
>   current = 0xc00000003f30dd10
>   paca    = 0xc000000000753400
>     pid   = 27402, comm = fsstress
> kernel BUG at fs/mpage.c:473!
> enter ? for help
> [c0000000be9db3a0] c0000000000dfedc .write_cache_pages+0x288/0x42c
> [c0000000be9db530] c00000000014e298 .mpage_writepages+0x54/0x8c
> [c0000000be9db5d0] d0000000032f1720 .jfs_writepages+0x1c/0x34 [jfs]
> [c0000000be9db650] c0000000000e0120 .do_writepages+0x68/0xa4
> [c0000000be9db6d0] c0000000000d764c .__filemap_fdatawrite_range+0x8c/0xbc
> [c0000000be9db7c0] c0000000000d76bc .filemap_write_and_wait_range+0x40/0x8c
> [c0000000be9db860] c0000000000d79f4 .generic_file_buffered_write+0x2ec/0x358
> [c0000000be9db9a0] c0000000000d7f88
> .__generic_file_aio_write_nolock+0x300/0x3ec
> [c0000000be9dbaa0] c0000000000d8390 .generic_file_aio_write+0x80/0x114
> [c0000000be9dbb60] c000000000118a24 .do_sync_write+0xc4/0x124
> [c0000000be9dbcf0] c00000000011959c .vfs_write+0xd8/0x1a4
> [c0000000be9dbd90] c000000000119768 .SyS_write+0x50/0x90
> [c0000000be9dbe30] c000000000008534 syscall_exit+0x0/0x40
> --- Exception: c01 (System Call) at 000000000ff0d8c8
> SP (ff87c6f0) is in userspace
> 
> This is a powerpc box (IBM,9133-55A). I have attached the dmesg log
> as well as the jfs-fsstress.log
> 
> Partition Table information : 
> 
> /dev/sda3 on / type ext3 (rw)
> proc on /proc type proc (rw)
> sysfs on /sys type sysfs (rw)
> devpts on /dev/pts type devpts (rw,gid=5,mode=620)
> /dev/sda2 on /boot type ext3 (rw)
> tmpfs on /dev/shm type tmpfs (rw)
> none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
> sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
> /dev/sda6 on /mnt/tmp type jfs (rw)
> 
> Let me know if there is any other information that i can provide.
> 
> Thanks
> -Sachin

-- 
David Kleikamp
IBM Linux Technology Center

