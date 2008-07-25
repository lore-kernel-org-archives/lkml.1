Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbYGYTK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbYGYTK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 15:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbYGYTKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 15:10:46 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:60490 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbYGYTKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 15:10:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding;
	b=TXcD6US/N1RiE3wcealvIaZnzhkCz+VxvebGdt+GKGHWKYAHe9AtZb5rwwDZ8Ebwils6mMp10kM4CNE7Llw2Zz6c4+5fhCp418maWMPsgJmsPOUrm8OfiOhaedN+/0OR;
Message-ID: <488A2532.7010807@simon.arlott.org.uk>
Date: Fri, 25 Jul 2008 20:10:42 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.14 (X11/20080706)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: BUG: scheduling while atomic: md0_raid1/1379/0x00000002
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This only seems to happen when the array isn't clean.

Last known good kernel: 33af79d12e0fa25545d49e86afc67ea8ad5f2f40
First bad kernel: e89970aa93b06d0605a488e74af3b0a2a80e03b5

[    7.123394] md: md0 still in use.
[    7.327984] md: bind<sdc3>
[    7.328295] md: bind<sdb3>
[    7.328435] md: md0: raid array is not clean -- starting background reconstruction
[    7.328836] raid1: raid set md0 active with 2 out of 2 mirrors
[    7.354117] md0: bitmap initialized from disk: read 15/15 pages, set 0 bits
[    7.354238] created bitmap (233 pages) for device md0
[    7.373700] md: resync of RAID array md0
[    7.373703] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[    7.373707] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
[    7.373712] md: using 128k window, over a total of 975747840 blocks.
[    7.421444] md: md0: resync done.
[    7.506594] RAID1 conf printout:
[    7.506713]  --- wd:2 rd:2
[    7.506829]  disk 0, wo:0, o:1, dev:sdb3
[    7.506945]  disk 1, wo:0, o:1, dev:sdc3
[    7.858561] EXT3-fs: INFO: recovery required on readonly filesystem.
[    7.858691] EXT3-fs: write access will be enabled during recovery.
[    8.735551] ------------[ cut here ]------------
[    8.735667] WARNING: at include/linux/blkdev.h:447 blk_plug_device+0x5e/0x97()
[    8.735877] Modules linked in:
[    8.736011] Pid: 1403, comm: exe Not tainted 2.6.26 #06912-g8e053ca
[    8.736130] 
[    8.736131] Call Trace:
[    8.736353]  [<ffffffff80231f34>] warn_on_slowpath+0x58/0x86
[    8.736476]  [<ffffffff8025f50f>] ? mempool_alloc_slab+0x11/0x13
[    8.736596]  [<ffffffff8025f5fd>] ? mempool_alloc+0x2c/0xe8
[    8.736704]  [<ffffffff8025f50f>] ? mempool_alloc_slab+0x11/0x13
[    8.736835]  [<ffffffff804c4368>] ? bitmap_get_counter+0x156/0x1fa
[    8.736945]  [<ffffffff80338b10>] blk_plug_device+0x5e/0x97
[    8.737073]  [<ffffffff804c4ecc>] bitmap_startwrite+0x12a/0x172
[    8.737194]  [<ffffffff802acf3c>] ? bio_alloc_bioset+0x4b/0x8f
[    8.737315]  [<ffffffff804b0835>] make_request+0x5c3/0x658
[    8.737438]  [<ffffffff80247c9b>] ? up_read+0x9/0xb
[    8.737551]  [<ffffffff8033808b>] generic_make_request+0x1e3/0x21a
[    8.737677]  [<ffffffff802acecb>] ? bvec_alloc_bs+0x81/0xa7
[    8.737786]  [<ffffffff8033964f>] submit_bio+0x111/0x11a
[    8.737917]  [<ffffffff802a8f79>] submit_bh+0xf0/0x114
[    8.738025]  [<ffffffff802aac0d>] __block_write_full_page+0x1c2/0x2ae
[    8.738155]  [<ffffffff802aee0f>] ? blkdev_get_block+0x0/0x4d
[    8.738264]  [<ffffffff802aee0f>] ? blkdev_get_block+0x0/0x4d
[    8.738382]  [<ffffffff802aadeb>] block_write_full_page+0xf2/0xfb
[    8.738510]  [<ffffffff802aea50>] blkdev_writepage+0x13/0x15
[    8.738623]  [<ffffffff8026340c>] __writepage+0x12/0x2b
[    8.738742]  [<ffffffff802638c1>] write_cache_pages+0x1ae/0x318
[    8.738851]  [<ffffffff802633fa>] ? __writepage+0x0/0x2b
[    8.738969]  [<ffffffff80263a4a>] generic_writepages+0x1f/0x25
[    8.739087]  [<ffffffff80263a78>] do_writepages+0x28/0x37
[    8.739217]  [<ffffffff8025d9fe>] __filemap_fdatawrite_range+0x55/0x60
[    8.739337]  [<ffffffff8025dba3>] filemap_fdatawrite+0x1a/0x1c
[    8.739455]  [<ffffffff8025dbbe>] filemap_write_and_wait+0x19/0x38
[    8.739576]  [<ffffffff802a9c35>] sync_blockdev+0x1b/0x1d
[    8.739696]  [<ffffffff802e46dc>] journal_recover+0x9b/0xab
[    8.739815]  [<ffffffff802e6baf>] journal_load+0x4d/0x89
[    8.739933]  [<ffffffff802dc143>] ext3_fill_super+0xec5/0x14c6
[    8.740054]  [<ffffffff805cf2c6>] ? __down_write+0xb/0xd
[    8.740174]  [<ffffffff8028a43a>] get_sb_bdev+0xfe/0x14d
[    8.740289]  [<ffffffff802db27e>] ? ext3_fill_super+0x0/0x14c6
[    8.740418]  [<ffffffff802d991f>] ext3_get_sb+0x13/0x15
[    8.740536]  [<ffffffff8028a1fc>] vfs_kern_mount+0x52/0x9a
[    8.740654]  [<ffffffff8028a2a1>] do_kern_mount+0x47/0xe2
[    8.740773]  [<ffffffff8029fc62>] do_new_mount+0x5f/0x92
[    8.740890]  [<ffffffff8029fe44>] do_mount+0x1af/0x1de
[    8.746963]  [<ffffffff805d4625>] ? bad_gs+0x10ab/0x2476
[    8.747073]  [<ffffffff8029fefc>] sys_mount+0x89/0xd5
[    8.747209]  [<ffffffff8020b4eb>] system_call_fastpath+0x16/0x1b
[    8.747317] 
[    8.747431] ---[ end trace 2e59dd16bd35ee32 ]---
[    9.027047] BUG: scheduling while atomic: md0_raid1/1379/0x00000002
[    9.027182] Modules linked in:
[    9.027327] Pid: 1379, comm: md0_raid1 Tainted: G        W 2.6.26 #06912-g8e053ca
[    9.027543] 
[    9.027544] Call Trace:
[    9.027769]  [<ffffffff80341aa2>] ? cfq_set_request+0x2b3/0x339
[    9.027890]  [<ffffffff8022de0c>] __schedule_bug+0x62/0x66
[    9.028015]  [<ffffffff805cd8b8>] schedule+0xab/0x5f1
[    9.028135]  [<ffffffff805ce02f>] io_schedule+0x28/0x33
[    9.028254]  [<ffffffff80339012>] get_request_wait+0x91/0xf1
[    9.028375]  [<ffffffff802449df>] ? autoremove_wake_function+0x0/0x38
[    9.028485]  [<ffffffff8033932c>] __make_request+0x2ba/0x359
[    9.028623]  [<ffffffff8025f50f>] ? mempool_alloc_slab+0x11/0x13
[    9.028742]  [<ffffffff8033808b>] generic_make_request+0x1e3/0x21a
[    9.028866]  [<ffffffff802acecb>] ? bvec_alloc_bs+0x81/0xa7
[    9.028979]  [<ffffffff8033964f>] submit_bio+0x111/0x11a
[    9.029089]  [<ffffffff802acfb8>] ? bio_clone+0x38/0x40
[    9.029674]  [<ffffffff804bc7fa>] md_super_write+0xb2/0xbe
[    9.029801]  [<ffffffff804c3fae>] write_page+0x198/0x305
[    9.029926]  [<ffffffff803365b1>] ? elv_rqhash_reposition+0x36/0x38
[    9.030110]  [<ffffffff8033663d>] ? elv_merged_request+0x39/0x46
[    9.030246]  [<ffffffff804c5007>] bitmap_unplug+0xb7/0x188
[    9.030390]  [<ffffffff804aeeb9>] flush_pending_writes+0x5d/0x97
[    9.030539]  [<ffffffff804af46f>] raid1d+0x74/0xd4c
[    9.030685]  [<ffffffff8023ae5e>] ? lock_timer_base+0x26/0x4a
[    9.030814]  [<ffffffff8023aed8>] ? try_to_del_timer_sync+0x56/0x62
[    9.031048]  [<ffffffff8023aef8>] ? del_timer_sync+0x14/0x20
[    9.031196]  [<ffffffff805ce11e>] ? schedule_timeout+0x98/0xb4
[    9.031334]  [<ffffffff8023ab0e>] ? process_timeout+0x0/0xb
[    9.031480]  [<ffffffff804c322f>] md_thread+0xd5/0xed
[    9.031619]  [<ffffffff802449df>] ? autoremove_wake_function+0x0/0x38
[    9.031785]  [<ffffffff804c315a>] ? md_thread+0x0/0xed
[    9.031936]  [<ffffffff802448ad>] kthread+0x49/0x78
[    9.032089]  [<ffffffff8020c409>] child_rip+0xa/0x11
[    9.032245]  [<ffffffff80244864>] ? kthread+0x0/0x78
[    9.032390]  [<ffffffff8020c3ff>] ? child_rip+0x0/0x11
[    9.032524] 

-- 
Simon Arlott
