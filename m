Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbZFVQcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbZFVQcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756418AbZFVQc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:32:27 -0400
Received: from fw08.mobotixserver.de ([213.183.84.168]:54912 "EHLO
	fw08.mobotixserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbZFVQc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:32:26 -0400
X-Greylist: delayed 1964 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jun 2009 12:32:25 EDT
From: Daniel Kabs <daniel.kabs@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: help me understand why oom-killer engages with lots of free memory left
Date: Mon, 22 Jun 2009 17:59:43 +0200
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906221759.43508.daniel.kabs@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I'd like some help in researching why oom-killer slashes processes although there seems to be plenty of RAM left.

I am talking about an embedded system using kernel 2.6.28.9 and 256 MByte of RAM, no swap space and the root filesystem residing in an tmpfs. When the 
system is up and running the regular workload, /proc/meminfo shows more than 22 MByte of free RAM - this is after I free pagecache, dentries and 
inodes using 
   echo 3 > /proc/sys/vm/drop_caches

Now sometimes executing a new process triggers OOM-Killer. With "new process" I mean something small like a shell or perl script, nothing that would 
consume MBytes of memory. Nevertheless, OOM-Killer starts to kill processes. 

In the output of the oom-killer (see example below), 20396kB of free memory is mentioned. So I see no need for oom-killer to bring complete 
pandemonium. Aside from that I fail to put the output of oom-killer to good use.

I hope someone here would help me interpret the kernel output, or tell me what could possibly have caused the oom-killer to kick in with so much free 
memory left.

Thanks a lot!

Cheers
Daniel


Quote of 1st oom-killer output:
checkd invoked oom-killer: gfp_mask=0x44d0, order=2, oomkilladj=0
[<c00328c8>] (dump_stack+0x0/0x14) from [<c006baf0>] (oom_kill_process+0x104/0x1cc)
[<c006b9ec>] (oom_kill_process+0x0/0x1cc) from [<c006bf44>] (out_of_memory+0x1b8/0x200)
[<c006bd8c>] (out_of_memory+0x0/0x200) from [<c006ea34>] (__alloc_pages_internal+0x2e8/0x3d4)
[<c006e74c>] (__alloc_pages_internal+0x0/0x3d4) from [<c006eb40>] (__get_free_pages+0x20/0x54)
[<c006eb20>] (__get_free_pages+0x0/0x54) from [<c008bee8>] (__kmalloc_track_caller+0xb8/0xd8)
[<c008be30>] (__kmalloc_track_caller+0x0/0xd8) from [<c0214064>] (__alloc_skb+0x5c/0x100)
 r8:c020f610 r7:c0354128 r6:00003ec0 r5:00003ec0 r4:cf1c26c0
[<c0214008>] (__alloc_skb+0x0/0x100) from [<c020f610>] (sock_alloc_send_skb+0x1e4/0x260)
[<c020f42c>] (sock_alloc_send_skb+0x0/0x260) from [<c0271488>] (unix_stream_sendmsg+0x1ec/0x2f4)
[<c027129c>] (unix_stream_sendmsg+0x0/0x2f4) from [<c020c5c8>] (sock_aio_write+0xf8/0xfc)
[<c020c4d0>] (sock_aio_write+0x0/0xfc) from [<c008dfe4>] (do_sync_write+0xc4/0x108)
[<c008df20>] (do_sync_write+0x0/0x108) from [<c008e974>] (vfs_write+0x13c/0x144)
 r8:c002f004 r7:cf093f78 r6:00007b8e r5:bee9db40 r4:c69ad980
[<c008e838>] (vfs_write+0x0/0x144) from [<c008edc0>] (sys_write+0x44/0x74)
 r7:00000000 r6:00000000 r5:fffffff7 r4:c69ad980
[<c008ed7c>] (sys_write+0x0/0x74) from [<c002ee80>] (ret_fast_syscall+0x0/0x2c)
 r7:00000004 r6:bee9db40 r5:00000016 r4:00007b8e
Mem-info:
Normal per-cpu:
CPU    0: hi:   90, btch:  15 usd:   0
Active_anon:8449 active_file:0 inactive_anon:10986
 inactive_file:14 unevictable:32228 dirty:0 writeback:14 unstable:0
 free:5099 slab:1535 mapped:1381 pagetables:140 bounce:0
Normal free:20396kB min:1996kB low:2492kB high:2992kB active_anon:33796kB inactive_anon:43944kB active_file:0kB inactive_file:56kB 
unevictable:128912kB present:249936kB pages_scanned:0 all_unreclaimable? no
handle_end_of_frame: 880 remained in px DMA-desc
lowmem_reserve[]: 0 0
Normal: 1445*4kB 1781*8kB 15*16kB 2*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 20396kB
48566 total pagecache pages
62976 pages of RAM
5256 free pages
1487 reserved pages
1388 slab pages
6670 pages shared
0 pages swap cached
Out of memory: kill process 995 (httpd) score 2646 or a child
Killed process 2491 (stream.cgi)
