Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYDCK1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYDCK1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 06:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYDCK1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 06:27:02 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47105 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbYDCK1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 06:27:00 -0400
To: clameter@sgi.com
CC: miles.lane@gmail.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-reply-to: <Pine.LNX.4.64.0804022016160.1510@schroedinger.engr.sgi.com>
	(message from Christoph Lameter on Wed, 2 Apr 2008 20:31:20 -0700
	(PDT))
Subject: Re: 2.6.25-rc8-mm1 -- BUG buffer_head: Redzone overwritten
References: <47F43B7F.6090505@gmail.com> <Pine.LNX.4.64.0804022016160.1510@schroedinger.engr.sgi.com>
Message-Id: <E1JhMek-0000Mp-SY@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 03 Apr 2008 12:26:54 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > [11543.669979] BUG buffer_head: Redzone overwritten
> > [11543.669984] 
> > -----------------------------------------------------------------------------
> > [11543.669987]
> > [11543.669992] INFO: 0xd62af5d4-0xd62af5d7. First byte 0x5a instead of 0xbb
> > [11543.669997] INFO: Allocated in 0x5a5a5a5a age=2783036320 
> > cpu=1515870810 pid=1515870810
> > [11543.670023] INFO: Freed in 0x5a5a5a5a age=2783036320 cpu=1515870810 
> > pid=1515870810
> > [11543.670036] INFO: Slab 0xc14db748 objects=42 used=23 fp=0xd62af5a0 
> > flags=0x150000c3
> > [11543.670041] INFO: Object 0xd62af5a0 @offset=1440 fp=0x5a5a5a5a
> > [11543.670044]
> > [11543.670048] Bytes b4 0xd62af590:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 
> > 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> > [11543.670078]   Object 0xd62af5a0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 
> > 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> > [11543.670108]   Object 0xd62af5b0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 
> > 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> > [11543.670137]   Object 0xd62af5c0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 
> > 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> > [11543.670166]   Object 0xd62af5d0:  5a 5a 5a 
> > 5a                                     ZZZZ            
> > [11543.670195]  Redzone 0xd62af5d4:  5a 5a 5a 
> > 5a                                     ZZZZ            
> > [11543.670223]  Padding 0xd62af5fc:  5a 5a 5a 
> > 5a                                     ZZZZ            
> > [11543.670254] Pid: 2977, comm: mount.ntfs-3g Not tainted 2.6.25-rc8-mm1 #13
> > [11543.670263]  [print_trailer+0xf6/0xfe] print_trailer+0xf6/0xfe
> > [11543.670280]  [check_bytes_and_report+0x73/0x8f] 
> > check_bytes_and_report+0x73/0x8f
> > [11543.670293]  [check_object+0x44/0x18c] check_object+0x44/0x18c
> > [11543.670307]  [__slab_alloc+0x486/0x547] __slab_alloc+0x486/0x547
> > [11543.670323]  [pci_slot:kmem_cache_alloc+0x5a/0xcf] 
> > kmem_cache_alloc+0x5a/0xcf
> > [11543.670331]  [alloc_buffer_head+0x11/0x64] ? alloc_buffer_head+0x11/0x64
> > [11543.670343]  [alloc_buffer_head+0x11/0x64] ? alloc_buffer_head+0x11/0x64
> > [11543.670357]  [alloc_buffer_head+0x11/0x64] alloc_buffer_head+0x11/0x64
> > [11543.670367]  [alloc_page_buffers+0x1e/0xa8] alloc_page_buffers+0x1e/0xa8
> > [11543.670379]  [create_empty_buffers+0x14/0x95] 
> > create_empty_buffers+0x14/0x95
> > [11543.670390]  [block_read_full_page+0x41/0x259] 
> > block_read_full_page+0x41/0x259
> > [11543.670399]  [blkdev_get_block+0x0/0x3a] ? blkdev_get_block+0x0/0x3a
> > [11543.670414]  [snd_pcm:_write_unlock_irq+0x36/0x102] ? 
> > _write_unlock_irq+0x36/0x4b
> > [11543.670427]  [add_to_page_cache+0xbf/0xe3] ? add_to_page_cache+0xbf/0xe3
> > [11543.670441]  [lru_cache_add+0x64/0x7a] ? lru_cache_add+0x64/0x7a
> > [11543.670456]  [blkdev_readpage+0xf/0x11] blkdev_readpage+0xf/0x11
> > [11543.670465]  [__do_page_cache_readahead+0x124/0x154] 
> > __do_page_cache_readahead+0x124/0x154
> > [11543.670481]  [ondemand_readahead+0x11a/0x128] 
> > ondemand_readahead+0x11a/0x128
> > [11543.670494]  [page_cache_async_readahead+0x53/0x5e] 
> > page_cache_async_readahead+0x53/0x5e
> > [11543.670507]  [fuse:generic_file_aio_read+0x1ef/0x650] 
> > generic_file_aio_read+0x1ef/0x493
> > [11543.670533]  [fuse:do_sync_read+0xbb/0x8c3] do_sync_read+0xbb/0xf9
> > [11543.670552]  [<c0130fc5>] ? autoremove_wake_function+0x0/0x30
> > [11543.670568]  [snd_hda_intel:_spin_unlock_irqrestore+0x56/0x6c] ? 
> > _spin_unlock_irqrestore+0x56/0x6c

> sound driver going to fuse?

Both of them look like trash remaining on the stack.  The process is
mount.ntfs-3g which is the fuse server, highly unlikely to recurse
into it's own mount or to access the sound card.  The top part of the
trace confirms that, fuse doesn't call into the block layer (and
neither do sound drivers ;)

> > [11543.670581]  [hrtick_set+0xcf/0xd7] ? hrtick_set+0xcf/0xd7
> > [11543.670595]  [<c017d64d>] ? do_sync_read+0x0/0xf9
> > [11543.670605]  [vfs_read+0x8a/0x106] vfs_read+0x8a/0x106
> > [11543.670616]  [sys_pread64+0x43/0x5c] sys_pread64+0x43/0x5c
> > [11543.670628]  [sysenter_past_esp+0x6d/0xc5] sysenter_past_esp+0x6d/0xc5
> > [11543.670648]  =======================

Miklos
