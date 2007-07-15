Return-Path: <linux-kernel-owner+w=401wt.eu-S1761650AbXGOXV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650AbXGOXV3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbXGOXVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:21:22 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34150 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754371AbXGOXVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:21:21 -0400
Date: Mon, 16 Jul 2007 01:20:40 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Russell Harmon <eatnumber1@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oops... not sure why.
Message-ID: <20070715232039.GM3565@stusta.de>
References: <9c4865a10707150926t48281f35w7a9593da20dd9781@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9c4865a10707150926t48281f35w7a9593da20dd9781@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2007 at 12:26:27PM -0400, Russell Harmon wrote:
> Hey all, just updated to 2.6.22.1, and have been getting the following
> oops rather often in my dmesg. It eventually makes it so no programs
> will start, and I lose internet connectivity and so have to reboot. I
> have a centrino duo system running SMP.
>
> I'm using SLAB.

You told much but missed the most important point:

Whatever you call "2.6.22.1" isn't the vanilla 2.6.22.1 kernel from 
ftp.kernel.org but the 2.6.22.1 kernel with a huge pile of external 
drivers and/or patches, and therefore off-topic on this list.

Since your Oops involves unionfs that is not part of the 2.6.22.1 kernel 
contacting the unionfs developers might be a good starting point for you 
for looking for help.

> Thanks
> ~Russ
>
> BUG: unable to handle kernel NULL pointer dereference at virtual
> address 00000000
> printing eip:
> 00000000
> *pde = 00000000
> Oops: 0000 [#2]
> SMP
> Modules linked in: snd_seq snd_seq_device snd_hda_intel snd_pcm
> snd_timer snd snd_page_alloc rlocate tp_smapi thinkpad_ec iwl3945
> e1000 firewire_ohci firewire_core
> CPU:    0
> EIP:    0060:[<00000000>]    Not tainted VLI
> EFLAGS: 00010246   (2.6.22-kamikaze1-r1 #12)
> EIP is at run_init_process+0x4fefff50/0x20
> eax: e6299800   ebx: 00000000   ecx: b190d460   edx: b157cd40
> esi: b157cd40   edi: f6af0ee4   ebp: 00000000   esp: e4cb1c5c
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process gnome-pty-helpe (pid: 9708, ti=e4cb0000 task=f75b3a30 
> task.ti=e4cb0000)
> Stack: b014b22e 000000d0 00000000 e6299800 e6299800 f6af0e40 e6299140 
> b014d370
>       e6299800 b142d680 b01eeb24 e6299800 b142d680 e6299800 b142d680 
> 00000000
>       b17a4a00 00000000 b0151c70 000000d0 e4cb1d0c f607cebc f607ceb0 
> e6299140
> Call Trace:
> [<b014b22e>] read_cache_page_async+0x8e/0x160
> [<b014d370>] read_cache_page+0x10/0x50
> [<b01eeb24>] unionfs_readpage+0x84/0x1d0
> [<b0151c70>] __do_page_cache_readahead+0x1f0/0x2a0
> [<b011c0ae>] dequeue_entity+0x7e/0xb0
> [<b0119f77>] dequeue_task+0x27/0x40
> [<b011b1cb>] update_stats_wait_end+0x9b/0xc0
> [<b0151df0>] ra_submit+0xd0/0xe0
> [<b0152798>] page_cache_readahead_adaptive+0x108/0x5e0
> [<b01eecd4>] unionfs_commit_write+0x64/0x1e0
> [<b014ba61>] do_generic_mapping_read+0x3a1/0x600
> [<b014db13>] generic_file_aio_read+0xd3/0x1d0
> [<b014abe0>] file_read_actor+0x0/0x120
> [<b01e52c1>] unionfs_aio_read+0x51/0xc0
> [<b016ad07>] do_sync_read+0xc7/0x110
> [<b01366a0>] autoremove_wake_function+0x0/0x50
> [<b0139452>] enqueue_hrtimer+0x72/0x100
> [<b0139b67>] hrtimer_start+0xc7/0x140
> [<b01e53f2>] unionfs_read+0x42/0xa0
> [<b016b5fc>] vfs_read+0xbc/0x160
> [<b01e53b0>] unionfs_read+0x0/0xa0
> [<b016bb31>] sys_read+0x41/0x70
> [<b0102a1a>] sysenter_past_esp+0x5f/0x85
> =======================
> Code:  Bad EIP value.
> EIP: [<00000000>] run_init_process+0x4fefff50/0x20 SS:ESP 0068:e4cb1c5c

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

