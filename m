Return-Path: <linux-kernel-owner+w=401wt.eu-S967274AbXEGXdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967274AbXEGXdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 19:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967267AbXEGXdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 19:33:51 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967268AbXEGXdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 19:33:49 -0400
Date: Mon, 7 May 2007 16:33:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sleeping function called from invalid context at
 block/cfq-iosched.c (Was: Re: 2.6.21-mm1)
Message-Id: <20070507163335.f5f5ea6e.akpm@linux-foundation.org>
In-Reply-To: <463FB697.6060902@simon.arlott.org.uk>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
	<463E3C50.9080207@simon.arlott.org.uk>
	<20070506135403.a6785f7d.akpm@linux-foundation.org>
	<463FAF1C.8060500@simon.arlott.org.uk>
	<20070507162349.0790706f.akpm@linux-foundation.org>
	<463FB697.6060902@simon.arlott.org.uk>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 May 2007 00:30:31 +0100
Simon Arlott <simon@fire.lp0.eu> wrote:

> On 08/05/07 00:23, Andrew Morton wrote:
> > On Mon, 07 May 2007 23:58:36 +0100
> > Simon Arlott <simon@fire.lp0.eu> wrote:
> > 
> >> I've just got this under mainline too now (0ec54aa8af5e6faa346aa55a1ad15ee6c25bb42d 2007-05-05 22:08:06):
> >>
> >> [84567.084000] BUG: scheduling while atomic: pdflush/0xeff84acf/186
> >> [84567.084000] INFO: lockdep is turned off.
> >> [84567.084000] do_IRQ: stack overflow: 440
> >> [84567.084000]  [<b0104f3a>] show_trace_log_lvl+0x1a/0x30
> >> [84567.084000]  [<b0104f62>] show_trace+0x12/0x20
> >> [84567.084000]  [<b0105075>] dump_stack+0x15/0x20
> >> [84567.084000]  [<b01069a8>] do_IRQ+0xd8/0xe0
> >> [84567.084000]  [<b0104bd6>] common_interrupt+0x2e/0x34
> >> [84567.084000]  [<b0120a28>] printk+0x18/0x20
> >> [84567.084000]  [<b0140b33>] debug_show_held_locks+0x23/0x30
> >> [84567.084000]  [<b04e7fea>] schedule+0x52a/0x680
> >> [84567.084000]  [<b04e8a0a>] schedule_timeout+0x8a/0x90
> >> [84567.084000]  [<b026c61e>] xlog_state_sync+0x21e/0x260
> >> [84567.084000]  [<b0269274>] _xfs_log_force+0x44/0x70
> >> [84567.084000]  [<b022dd22>] xfs_alloc_search_busy+0xd2/0xe0
> >> [84567.084000]  [<b022d1e6>] xfs_alloc_get_freelist+0xe6/0x100
> >> [84567.084000]  [<b022fb7f>] xfs_alloc_split+0x1f/0x4c0
> >> [84567.084000]  [<b022ec3d>] xfs_alloc_insrec+0x35d/0x3b0
> >> [84567.084000]  [<b02304f9>] xfs_alloc_insert+0x59/0xd0
> >> [84567.084000]  [<b022c847>] xfs_free_ag_extent+0x297/0x640
> >> [84567.084000]  [<b022ce11>] xfs_alloc_fix_freelist+0x1d1/0x4c0
> >> [84567.084000]  [<b022d73b>] xfs_alloc_vextent+0x1eb/0x4b0
> >> [84567.084000]  [<b023d4bb>] xfs_bmap_btalloc+0x3bb/0x8f0
> >> [84567.084000]  [<b023da11>] xfs_bmap_alloc+0x21/0x40
> >> [84567.084000]  [<b02411bf>] xfs_bmapi+0xdbf/0x1450
> >> [84567.084000]  [<b0266b4a>] xfs_iomap_write_allocate+0x2ba/0x520
> >> [84567.084000]  [<b026587b>] xfs_iomap+0x45b/0x470
> >> [84567.084000]  [<b028d85c>] xfs_bmap+0x2c/0x40
> >> [84567.084000]  [<b0284a0c>] xfs_map_blocks+0x3c/0x80
> >> [84567.084000]  [<b0285953>] xfs_page_state_convert+0x2f3/0x670
> >> [84567.084000]  [<b0285d2a>] xfs_vm_writepage+0x5a/0xf0
> >> [84567.084000]  [<b01539a6>] generic_writepages+0x226/0x360
> >> [84567.084000]  [<b0285de4>] xfs_vm_writepages+0x24/0x60
> >> [84567.084000]  [<b0153b0c>] do_writepages+0x2c/0x50
> >> [84567.084000]  [<b01887d9>] __sync_single_inode+0x59/0x1f0
> >> [84567.084000]  [<b01889b4>] __writeback_single_inode+0x44/0x1d0
> >> [84567.084000]  [<b0188d09>] sync_sb_inodes+0x1c9/0x2e0
> >> [84567.084000]  [<b0188eee>] writeback_inodes+0xce/0xe0
> >> [84567.084000]  [<b01535c3>] wb_kupdate+0x73/0xf0
> >> [84567.084000]  [<b015419e>] __pdflush+0xce/0x1a0
> >> [84567.084000]  [<b0154295>] pdflush+0x25/0x30
> >> [84567.084000]  [<b01342b4>] kthread+0x94/0xd0
> >> [84567.084000]  [<b0104d7b>] kernel_thread_helper+0x7/0x1c
> >> [84567.084000]  =======================
> >> [84567.087000]  [<b0104f3a>] show_trace_log_lvl+0x1a/0x30
> >> [84567.087000]  [<b0104f62>] do_IRQ: stack overflow: 328
> >> [84567.087000]  [<b0104f3a>] show_trace_log_lvl+0x1a/0x30
> >> [84567.087000]  [<b0104f62>] show_trace+0x12/0x20
> >> [84567.087000]  [<b0105075>] dump_stack+0x15/0x20
> >> [84567.087000]  [<b01069a8>] do_IRQ+0xd8/0xe0
> >> [84567.087000]  [<b0104bd6>] common_interrupt+0x2e/0x34
> >> [84567.087000]  [<b0120a28>] printk+0x18/0x20
> >> [84567.087000]  [<b0104f0d>] print_trace_address+0x1d/0x30
> >> [84567.087000]  [<b0104e18>] dump_trace+0x48/0xb0
> >> [84567.087000]  [<b0104f3a>] show_trace_log_lvl+0x1a/0x30
> >> [84567.087000]  [<b0104f62>] show_trace+0x12/0x20
> >> [84567.087000]  [<b0105075>] dump_stack+0x15/0x20
> >> [84567.087000]  [<b04e7ffa>] schedule+0x53a/0x680
> >> [84567.087000]  [<b04e8a0a>] schedule_timeout+0x8a/0x90
> >> [84567.087000]  [<b026c61e>] xlog_state_sync+0x21e/0x260
> >> [84567.087000]  [<b0269274>] _xfs_log_force+0x44/0x70
> >> [84567.087000]  [<b022dd22>] xfs_alloc_search_busy+0xd2/0xe0
> >> [84567.087000]  [<b022d1e6>] xfs_alloc_get_freelist+0xe6/0x100
> >> [84567.087000]  [<b022fb7f>] xfs_alloc_split+0x1f/0x4c0
> >> [84567.087000]  [<b022ec3d>] xfs_alloc_insrec+0x35d/0x3b0
> >> [84567.087000]  [<b02304f9>] xfs_alloc_insert+0x59/0xd0
> >> [84567.087000]  [<b022c847>] xfs_free_ag_extent+0x297/0x640
> >> [84567.087000]  [<b022ce11>] xfs_alloc_fix_freelist+0x1d1/0x4c0
> >> [84567.087000]  [<b022d73b>] xfs_alloc_vextent+0x1eb/0x4b0
> >> [84567.087000]  [<b023d4bb>] xfs_bmap_btalloc+0x3bb/0x8f0
> >> [84567.087000]  [<b023da11>] xfs_bmap_alloc+0x21/0x40
> >> [84567.087000]  [<b02411bf>] xfs_bmapi+0xdbf/0x1450
> >> [84567.087000]  [<b0266b4a>] xfs_iomap_write_allocate+0x2ba/0x520
> >> [84567.087000]  [<b026587b>] xfs_iomap+0x45b/0x470
> >> [84567.087000]  [<b028d85c>] xfs_bmap+0x2c/0x40
> >> [84567.087000]  [<b0284a0c>] xfs_map_blocks+0x3c/0x80
> >> [84567.087000]  [<b0285953>] xfs_page_state_convert+0x2f3/0x670
> >> [84567.087000]  [<b0285d2a>] xfs_vm_writepage+0x5a/0xf0
> >> [84567.087000]  [<b01539a6>] generic_writepages+0x226/0x360
> >> [84567.087000]  [<b0285de4>] xfs_vm_writepages+0x24/0x60
> >> [84567.087000]  [<b0153b0c>] do_writepages+0x2c/0x50
> >> [84567.087000]  [<b01887d9>] __sync_single_inode+0x59/0x1f0
> >> [84567.087000]  [<b01889b4>] __writeback_single_inode+0x44/0x1d0
> >> [84567.087000]  [<b0188d09>] sync_sb_inodes+0x1c9/0x2e0
> >> [84567.087000]  [<b0188eee>] writeback_inodes+0xce/0xe0
> >> [84567.087000]  [<b01535c3>] wb_kupdate+0x73/0xf0
> >> [84567.087000]  [<b015419e>] __pdflush+0xce/0x1a0
> >> [84567.087000]  [<b0154295>] pdflush+0x25/0x30
> >> [84567.087000]  [<b01342b4>] kthread+0x94/0xd0
> >> [84567.087000]  [<b0104d7b>] kernel_thread_helper+0x7/0x1c
> >> [84567.087000] BUG: unable to handle kernel paging request at virtual address 00008034
> >> [84567.087000]  printing eip:
> >> [84567.087000] b0104e36
> >> [84567.087000] *pde = 00000000
> >> [84567.087000] Oops: 0000 [#1]
> >> [84567.087000] PREEMPT
> >> [84567.087000] Modules linked in: drbd mt352 saa7134_dvb dvb_pll video_buf_dvb dvb_core
> >> [84567.087000] CPU:    0
> >> [84567.087000] EIP:    0060:[<b0104e36>]    Not tainted VLI
> >> [84567.087000] EFLAGS: 00010046   (2.6.21-git #197)
> >> [84567.087000] EIP is at dump_trace+0x66/0xb0
> >> [84567.087000] eax: 00000000   ebx: b18f6fe0   ecx: b06323ec   edx: b05afc71
> >> [84567.087000] esi: 00008000   edi: 00008ffd   ebp: b18f6138   esp: b18f6120
> >> [84567.087000] ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
> >> [84567.087000] Process pdflush (pid: 186, ti=b18f5000 task=eff84ad0 task.ti=b18f6000)
> >> [84567.087000] Stack: b18f6130 b04ea9af 00000001 b05b9937 0000000a b06d656e b18f6158 b0104f3a
> >> [84567.087000]        b06323ec b05b9937 00000000 b06356a8 b18f6160 b18f622a b18f6168 b0104f62
> >> [84567.087000]        b05b9937 b06d656e b18f6178 b0105075 b05afeac b18f6184 b18f61a8 b01069a8
> >> [84567.087000] Call Trace:
> >> [84567.087000] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000034
> >> [84567.087000]  printing eip:
> >> [84567.087000] b0104e36
> >> [84567.087000] *pde = 00000000
> >> [84567.087000] Oops: 0000 [#2]
> >> [84567.087000] PREEMPT
> >> [84567.087000] Modules linked in: drbd mt352 saa7134_dvb dvb_pll video_buf_dvb dvb_core
> >> [84567.087000] CPU:    0
> >> [84567.087000] EIP:    0060:[<b0104e36>]    Not tainted VLI
> >> [84567.087000] EFLAGS: 00010046   (2.6.21-git #197)
> >> [84567.087000] EIP is at dump_trace+0x66/0xb0
> >> [84567.087000] eax: 00000000   ebx: b18f5f60   ecx: b06323ec   edx: b05afc71
> >> [84567.087000] esi: 00000000   edi: 00000ffd   ebp: b18f5f60   esp: b18f5f48
> >> [84567.087000] ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
> >> [84567.087000] Process pdflush (pid: 186, ti=b18f5000 task=eff84ad0 task.ti=b18f6000)
> >> [84567.087000] Stack: 5b3e303c 36353438 38302e37 b05afcde 00000018 00000000 b18f5f80 b0104f3a
> >> [84567.087000]        b06323ec b05afcde 
> >>
> >> Then it just gave up doing anything sane, presumably because of the stack overflow  in do_IRQ:
> >> http://redrum.lp0.eu/tmp/100_4037.jpg
> >> http://redrum.lp0.eu/tmp/100_4038.jpg
> >>
> > 
> > ugly.  And you're using 8k stacks?
> 
> 4k stacks, I will try to reproduce it with 8k stacks - which shouldn't be hard (see below).
>  
> > The way we'll fix this is to wait for someone to do a git-bisect on it. 
> > Perhaps you can do that?
> 
> It will take a while, I need to boot to a good kernel so unattended DVB-T recording works 
> reliably, I'm assuming switching to a different IO scheduler will avoid any problems for 
> that (and not using the XFS filesystem...). It happened again not 5 minutes later when I 
> continued compiling the kernel after sending that email so reproducing it should be easy.
> 

Oh, OK, in that case it is perhaps a genuine stack overflow.

> esp: b18f6120

That's not good.

Please enable 8k stacks before doing any other debugging things, see if
that fixes it.


