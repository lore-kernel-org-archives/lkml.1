Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbYKRCCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbYKRCCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 21:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbYKRCB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 21:01:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42004 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYKRCB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 21:01:58 -0500
Date: Mon, 17 Nov 2008 21:01:54 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Paul Mackerras <paulus@samba.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large stack usage in fs code (especially for PPC64)
In-Reply-To: <alpine.DEB.1.10.0811172020260.26123@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0811172059440.26123@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com> <alpine.DEB.1.10.0811171557370.26123@gandalf.stny.rr.com> <alpine.LFD.2.00.0811171309580.18283@nehalem.linux-foundation.org> <alpine.DEB.1.10.0811171936480.26123@gandalf.stny.rr.com>
 <18722.5316.582974.95373@cargo.ozlabs.ibm.com> <alpine.DEB.1.10.0811172020260.26123@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 17 Nov 2008, Steven Rostedt wrote:
> 
> And here's my i386 max stack:
> 
> [root@mirhel51 ~]# cat /debug/tracing/stack_trace 
>         Depth   Size      Location    (47 entries)
>         -----   ----      --------
>   0)     2216     240   blk_recount_segments+0x39/0x51
>   1)     1976      12   bio_phys_segments+0x16/0x1c
>   2)     1964      20   blk_rq_bio_prep+0x29/0xae
>   3)     1944      16   init_request_from_bio+0xc9/0xcd
>   4)     1928      60   __make_request+0x2f6/0x3c1
>   5)     1868     136   generic_make_request+0x36a/0x3a0
>   6)     1732      56   submit_bio+0xcd/0xd8
>   7)     1676      28   submit_bh+0xd1/0xf0
>   8)     1648     112   block_read_full_page+0x299/0x2a9
>   9)     1536       8   blkdev_readpage+0x14/0x16
>  10)     1528      28   read_cache_page_async+0x7e/0x109
>  11)     1500      16   read_cache_page+0x11/0x49
>  12)     1484      32   read_dev_sector+0x3c/0x72
>  13)     1452      48   read_lba+0x4d/0xaa
>  14)     1404     168   efi_partition+0x85/0x61b
>  15)     1236      84   rescan_partitions+0x14b/0x316
>  16)     1152      40   __blkdev_get+0x1b2/0x258
>  17)     1112       8   blkdev_get+0xf/0x11
>  18)     1104      36   register_disk+0xbc/0x112
>  19)     1068      32   add_disk+0x9f/0xf3
>  20)     1036      48   sd_probe+0x2d4/0x394
>  21)      988      20   driver_probe_device+0xa5/0x120
>  22)      968       8   __device_attach+0xd/0xf
>  23)      960      28   bus_for_each_drv+0x3e/0x67
>  24)      932      24   device_attach+0x56/0x6a
>  25)      908      16   bus_attach_device+0x26/0x4d
>  26)      892      64   device_add+0x380/0x4aa
>  27)      828      28   scsi_sysfs_add_sdev+0xa1/0x1c9
>  28)      800     160   scsi_probe_and_add_lun+0x97e/0xa8f
>  29)      640      36   __scsi_add_device+0x88/0xae
>  30)      604      40   ata_scsi_scan_host+0x8b/0x1cd
>  31)      564      28   ata_host_register+0x1da/0x1ea
>  32)      536      24   ata_host_activate+0x98/0xb5
>  33)      512     188   ahci_init_one+0xa23/0xa4f
>  34)      324      20   pci_device_probe+0x3e/0x5e
>  35)      304      20   driver_probe_device+0xa5/0x120
>  36)      284      20   __driver_attach+0x51/0x70
>  37)      264      32   bus_for_each_dev+0x40/0x62
>  38)      232      12   driver_attach+0x19/0x1b
>  39)      220      28   bus_add_driver+0x9c/0x1ac
>  40)      192      28   driver_register+0x76/0xd2
>  41)      164      20   __pci_register_driver+0x44/0x70
>  42)      144       8   ahci_init+0x14/0x16
>  43)      136      92   _stext+0x4f/0x116
>  44)       44      16   kernel_init+0xf7/0x145
>  45)       28      28   kernel_thread_helper+0x7/0x10
> 
> Note, the i386 box had 4KSTACKS defined and the PPC did not have 
> IRQSTACKS defined. I'll compile with IRQSTACKS defined and post that 
> result.

Here's the PPC32 with IRQSTACKS on:

rostedt@gollum:~$ cat /debug/tracing/stack_trace 
        Depth   Size      Location    (42 entries)
        -----   ----      --------
  0)     2940      48   ftrace_call+0x4/0x48
  1)     2892      16   ide_map_sg+0x4c/0x88
  2)     2876      32   ide_build_sglist+0x30/0xa0
  3)     2844      64   pmac_ide_dma_setup+0x90/0x2a0
  4)     2780      48   do_rw_taskfile+0x250/0x2a0
  5)     2732      96   ide_do_rw_disk+0x290/0x2f8
  6)     2636      16   ide_gd_do_request+0x30/0x48
  7)     2620     176   ide_do_request+0x8e8/0xa70
  8)     2444      16   do_ide_request+0x34/0x4c
  9)     2428      16   __generic_unplug_device+0x4c/0x64
 10)     2412      16   generic_unplug_device+0x4c/0x90
 11)     2396      16   blk_unplug+0x34/0x4c
 12)     2380      80   dm_table_unplug_all+0x54/0xc0 [dm_mod]
 13)     2300      16   dm_unplug_all+0x34/0x54 [dm_mod]
 14)     2284      16   blk_unplug+0x34/0x4c
 15)     2268      16   blk_backing_dev_unplug+0x28/0x40
 16)     2252      16   sync_buffer+0x60/0x80
 17)     2236      48   __wait_on_bit+0x78/0xd4
 18)     2188      80   out_of_line_wait_on_bit+0x88/0xa0
 19)     2108      16   __wait_on_buffer+0x40/0x58
 20)     2092      16   __bread+0xbc/0xf0
 21)     2076      48   ext3_get_branch+0x90/0x118 [ext3]
 22)     2028     208   ext3_get_blocks_handle+0xac/0xa10 [ext3]
 23)     1820      48   ext3_get_block+0xc4/0x114 [ext3]
 24)     1772     160   do_mpage_readpage+0x26c/0x6f4
 25)     1612     144   mpage_readpages+0xe8/0x148
 26)     1468      16   ext3_readpages+0x38/0x50 [ext3]
 27)     1452      80   __do_page_cache_readahead+0x19c/0x248
 28)     1372      32   do_page_cache_readahead+0x80/0x98
 29)     1340      80   filemap_fault+0x1b0/0x444
 30)     1260      80   __do_fault+0x68/0x61c
 31)     1180      64   handle_mm_fault+0x500/0xafc
 32)     1116     176   do_page_fault+0x2d4/0x450
 33)      940      84   handle_page_fault+0xc/0x80
 34)      856     140   0xdeaffa78
 35)      716     128   load_elf_binary+0x6a0/0x1048
 36)      588      64   search_binary_handler+0x10c/0x310
 37)      524     176   load_script+0x248/0x268
 38)      348      64   search_binary_handler+0x10c/0x310
 39)      284      64   do_execve+0x15c/0x210
 40)      220      32   sys_execve+0x68/0x98
 41)      188     188   ret_from_syscall+0x0/0x40

It does indeed help.

-- Steve

