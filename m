Return-Path: <linux-kernel-owner+w=401wt.eu-S933372AbXK2VIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372AbXK2VIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbXK2VIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:08:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53790 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364AbXK2VIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:08:34 -0500
Date: Thu, 29 Nov 2007 13:07:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Cc: linux-kernel@vger.kernel.org, trond.myklebust@fys.uio.no,
       stefanr@s5r6.in-berlin.de, "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: 2.6.24-rc3-mm2
Message-Id: <20071129130756.7550ce13.akpm@linux-foundation.org>
In-Reply-To: <64bb37e0711291258v1a51598bm36a1b953eab9fdd1@mail.gmail.com>
References: <20071128034140.648383f0.akpm@linux-foundation.org>
	<64bb37e0711291258v1a51598bm36a1b953eab9fdd1@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 21:58:16 +0100
"Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:

> On Nov 28, 2007 12:41 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm2/
> >
> > - All patches against subsystem trees were recently sent to the relevant
> >   maintainers.  Many (probably most) were ignored.  I don't know why this
> >   happens.
> >
> > - First bug report: after ten minutes happily compiling kernels my
> >   2.6.24-rc3-mm2 x86_64 box spontaneously rebooted.
> 
> The problem I reported againts 2.6.24-rc3-mm1, that the time is not
> connected to the IO-APIC is gone, 2.6.24-rc3-mm2 boots for me.

whew.  That was a nasty one - it's good that it went away.

> But after ~1h of usage I got two different crashes on my x86_64 box.

Nice, thanks.  By finding these now you (hopefully) saved a whole lot of
people a whole lot of grief a couple months from now.

> I hope, the CC's are correct...

Bruce works on NFS things too.

> First crash:
> 
> [ 1116.083651] Unable to handle kernel NULL pointer dereference at
> 0000000000000378 RIP:
> [ 1116.089216]  [<ffffffff8047cb88>] ether1394_dg_complete+0x28/0xa0
> [ 1116.097883] PGD 51880067 PUD 4a08b067 PMD 0
> [ 1116.102232] Oops: 0000 [1] SMP
> [ 1116.105423] last sysfs file:
> /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
> [ 1116.113344] CPU 0
> [ 1116.115393] Modules linked in: radeon drm nfsd exportfs w83792d
> ipv6 tuner tea5767 tda8290 tuner_xc2028 tda9887 tuner_simple mt20xx
> tea5761 tvaudio msp3400 bttv ir_common compat_ioctl32 videobuf_dma_sg
> videobuf_core btcx_risc tveeprom videodev v4l2_common usbhid
> v4l1_compat i2c_nforce2 hid pata_amd sg
> [ 1116.142687] Pid: 509, comm: khpsbpkt Not tainted 2.6.24-rc3-mm2 #1
> [ 1116.148956] RIP: 0010:[<ffffffff8047cb88>]  [<ffffffff8047cb88>]
> ether1394_dg_complete+0x28/0xa0
> [ 1116.157857] RSP: 0000:ffff81007ee71e80  EFLAGS: 00010282
> [ 1116.163225] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [ 1116.170457] RDX: ffff810051509480 RSI: 0000000000000000 RDI: ffff8100525a41c0
> [ 1116.177676] RBP: ffff81007ee71eb0 R08: 0000000000000000 R09: 0000000000000001
> [ 1116.184882] R10: ffffffff80952570 R11: 0000000000000001 R12: ffff8100525a41c0
> [ 1116.192110] R13: ffff81004a035d00 R14: 0000000000000001 R15: ffff8100525a41c0
> [ 1116.199324] FS:  00002abffda7a6f0(0000) GS:ffffffff807d4000(0000)
> knlGS:0000000000000000
> [ 1116.207512] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [ 1116.213314] CR2: 0000000000000378 CR3: 000000004a193000 CR4: 00000000000006e0
> [ 1116.220538] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1116.227757] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 1116.234971] Process khpsbpkt (pid: 509, threadinfo
> FFFF81007EE70000, task FFFF81007EE4E000)
> [ 1116.243409] Stack:  ffff81007ee71e90 ffff810051509cc0
> ffff8100525a41c0 0000000000000000
> [ 1116.251538]  0000000000000001 0000000000000000 ffff81007ee71ee0
> ffffffff8047cea3
> [ 1116.259063]  ffff81007ee71ec8 ffff81007ee71ef0 ffffffff8046d690
> 0000000000000000
> [ 1116.266372] Call Trace:
> [ 1116.269045]  [<ffffffff8047cea3>] ether1394_complete_cb+0xb3/0xd0
> [ 1116.275203]  [<ffffffff8046d690>] hpsbpkt_thread+0x0/0x140
> [ 1116.280753]  [<ffffffff8046d74b>] hpsbpkt_thread+0xbb/0x140
> [ 1116.286402]  [<ffffffff8024c2bd>] kthread+0x4d/0x80
> [ 1116.291341]  [<ffffffff8020cbc8>] child_rip+0xa/0x12
> [ 1116.296374]  [<ffffffff8020c2df>] restore_args+0x0/0x30
> [ 1116.301675]  [<ffffffff8024c270>] kthread+0x0/0x80
> [ 1116.306534]  [<ffffffff8020cbbe>] child_rip+0x0/0x12
> [ 1116.311548]
> [ 1116.313052] INFO: lockdep is turned off.
> [ 1116.317032]
> [ 1116.317032] Code: 4c 8b a0 78 03 00 00 4d 8d b4 24 d0 00 00 00 4c
> 89 f7 e8 21
> [ 1116.326198] RIP  [<ffffffff8047cb88>] ether1394_dg_complete+0x28/0xa0
> [ 1116.332729]  RSP <ffff81007ee71e80>
> [ 1116.336264] CR2: 0000000000000378
> [ 1116.339681] Unable to handle kernel NULL pointer dereference at
> 0000000000000000 RIP:
> [ 1116.345219]  [<ffffffff80297323>] kmem_cache_alloc_node+0x63/0x90
> [ 1116.353823] PGD 51880067 PUD 4a08b067 PMD 0
> [ 1116.358163] Oops: 0000 [2] SMP
> [ 1116.361156] last sysfs file:
> /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
> [ 1116.369269] CPU 0
> [ 1116.371307] Modules linked in: radeon drm nfsd exportfs w83792d
> ipv6 tuner tea5767 tda8290 tuner_xc2028 tda9887 tuner_simple mt20xx
> tea5761 tvaudio msp3400 bttv ir_common compat_ioctl32 videobuf_dma_sg
> videobuf_core btcx_risc tveeprom videodev v4l2_common usbhid
> v4l1_compat i2c_nforce2 hid pata_amd sg
> [ 1116.398316] Pid: 509, comm: khpsbpkt Tainted: G      D 2.6.24-rc3-mm2 #1
> [ 1116.405279] RIP: 0010:[<ffffffff80297323>]  [<ffffffff80297323>]
> kmem_cache_alloc_node+0x63/0x90
> [ 1116.414143] RSP: 0000:ffffffff80859ae0  EFLAGS: 00010046
> [ 1116.414145] RAX: 0000000000000000 RBX: ffff810001006780 RCX: ffffffff8052e079
> [ 1116.426733] RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffffffff807e7e80
> [ 1116.426735] RBP: ffffffff80859b00 R08: 00000000000005e0 R09: 000000000000ffc1
> [ 1116.441159] R10: 0000000000000001 R11: ffff81007ed5e3e0 R12: 00000000ffffffff
> [ 1116.441161] R13: 0000000000000020 R14: 0000000000000020 R15: ffffffff807e7e80
> [ 1116.455559] FS:  00002abffda7a6f0(0000) GS:ffffffff807d4000(0000)
> knlGS:0000000000000000
> [ 1116.455561] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [ 1116.469540] CR2: 0000000000000000 CR3: 000000004a193000 CR4: 00000000000006e0
> [ 1116.469542] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1116.483948] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 1116.483950] Process khpsbpkt (pid: 509, threadinfo
> FFFF81007EE70000, task FFFF81007EE4E000)
> [ 1116.499601] Stack:  ffffffff80859b10 00000000000005e0
> 00000000ffffffff 0000000000000609
> [ 1116.507739]  ffffffff80859b40 ffffffff8052e079 0000000080859b50
> 00000000000005e0
> [ 1116.515065]  ffff81007ee25010 00000000000005e0 ffff81007ee25010
> ffff81007ee93000
> [ 1116.521078] Call Trace:
> [ 1116.521079]  <IRQ>
> -> Here ends the output from the serial console
> 

Yep, looks like a genuine 1394 bug.

> 
> I then change the network from ether1394 to a real network card, but
> this also crashed:
> [  602.464580] ------------[ cut here ]------------
> [  602.469250] kernel BUG at lib/list_debug.c:33!
> [  602.473731] invalid opcode: 0000 [1] SMP
> [  602.477828] last sysfs file:
> /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
> [  602.485751] CPU 0
> [  602.487808] Modules linked in: radeon drm nfsd exportfs w83792d
> ipv6 tuner tea5767 tda8290 tuner_xc2028 tda9887 tuner_simple mt20xx
> tea5761 tvaudio msp3400 bttv ir_common compat_ioctl32 videobuf_dma_sg
> videobuf_core btcx_risc tveeprom videodev usbhid v4l2_common
> v4l1_compat hid sg pata_amd i2c_nforce2
> [  602.515102] Pid: 7452, comm: nfsv4-svc Not tainted 2.6.24-rc3-mm2 #1
> [  602.521554] RIP: 0010:[<ffffffff803bae54>]  [<ffffffff803bae54>]
> __list_add+0x54/0x60
> [  602.529491] RSP: 0018:ffff81007ad25dc0  EFLAGS: 00010282
> [  602.534864] RAX: 0000000000000088 RBX: ffff81007c5cdc00 RCX: 0000000000000003
> [  602.542092] RDX: ffff81007d29e000 RSI: 0000000000000001 RDI: ffffffff807590c0
> [  602.549312] RBP: ffff81007ad25dc0 R08: 0000000000000001 R09: 0000000000000000
> [  602.556536] R10: ffff810080061d48 R11: 0000000000000001 R12: ffff81007ed09f00
> [  602.563765] R13: ffff81007ed09f38 R14: ffff81007ed09f38 R15: ffff81007c528100
> [  602.571002] FS:  00007ff7d66326f0(0000) GS:ffffffff807d4000(0000)
> knlGS:0000000000000000
> [  602.579200] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  602.585012] CR2: 0000000005584118 CR3: 000000007c46a000 CR4: 00000000000006e0
> [  602.592243] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  602.599480] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  602.606710] Process nfsv4-svc (pid: 7452, threadinfo
> FFFF81007AD24000, task FFFF81007D29E000)
> [  602.615340] Stack:  ffff81007ad25e00 ffffffff805be18e
> ffff81007ed09f08 ffff81007c528100
> [  602.623496]  ffff81007c5cdc00 ffff81007ad78000 ffff8100625abc00
> ffff81007c528110
> [  602.631011]  ffff81007ad25e10 ffffffff805be287 ffff81007ad25ee0
> ffffffff805befcc
> [  602.638327] Call Trace:
> [  602.640997]  [<ffffffff805be18e>] svc_xprt_enqueue+0x1ae/0x250
> [  602.646916]  [<ffffffff805be287>] svc_xprt_received+0x17/0x20
> [  602.652744]  [<ffffffff805befcc>] svc_recv+0x39c/0x840
> [  602.657950]  [<ffffffff805be95f>] svc_send+0xaf/0xd0
> [  602.662977]  [<ffffffff8022f590>] default_wake_function+0x0/0x10
> [  602.669066]  [<ffffffff803163ea>] nfs_callback_svc+0x7a/0x130
> [  602.674894]  [<ffffffff805cfdc2>] trace_hardirqs_on_thunk+0x35/0x3a
> [  602.681261]  [<ffffffff80259f8f>] trace_hardirqs_on+0xbf/0x160
> [  602.687176]  [<ffffffff8020cbc8>] child_rip+0xa/0x12
> [  602.692189]  [<ffffffff8020c2df>] restore_args+0x0/0x30
> [  602.697499]  [<ffffffff80316370>] nfs_callback_svc+0x0/0x130
> [  602.703231]  [<ffffffff8020cbbe>] child_rip+0x0/0x12
> [  602.708257]
> [  602.709777] INFO: lockdep is turned off.
> [  602.713748]
> [  602.713748] Code: 0f 0b eb fe 0f 1f 84 00 00 00 00 00 55 48 8b 16
> 48 89 e5 e8
> [  602.722915] RIP  [<ffffffff803bae54>] __list_add+0x54/0x60
> [  602.728500]  RSP <ffff81007ad25dc0>
> [  602.732058] Kernel panic - not syncing: Aiee, killing interrupt handler!
> 
> Both times the system hung with Caps Lock and Scroll Lock where blinking.
> 

And one in NFS.

Thanks!
