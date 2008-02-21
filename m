Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368AbYBUJDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbYBUJDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759142AbYBUJDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:03:21 -0500
Received: from mail-04.jhb.wbs.co.za ([196.2.97.3]:33237 "EHLO
	mail-04.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbYBUJDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:03:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAANbMvEfEAmHElWdsb2JhbACQXQEBAQEHChEYnwM
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: 2.6.25-rc[12] Video4Linux Bttv Regression
Date: Thu, 21 Feb 2008 11:03:04 +0200
User-Agent: KMail/1.9.8
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
References: <200802171036.19619.bonganilinux@mweb.co.za> <20080219111640.409870a9@gaivota> <200802192237.58082.bonganilinux@mweb.co.za>
In-Reply-To: <200802192237.58082.bonganilinux@mweb.co.za>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802211103.04762.bonganilinux@mweb.co.za>
X-Original-Subject: Re: 2.6.25-rc[12] Video4Linux Bttv Regression
X-Scan-Signature: a37ae34199f81bcf42f9fb31860b0533
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've enabled MUTEX and SPINLOCK DEBUG, this is what I get

------------[ cut here ]------------
WARNING: at /home/bongani/kernel/git/linux-2.6/kernel/mutex.c:134 
mutex_lock_nested+0xc0/0x2a3()
Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq 
binfmt_misc loop nls_cp437 vfat fat nls_iso8859_1 ntfs dm_mod thermal 
processor fan container button pcspkr snd_pcm_oss snd_mixer_oss tuner 
snd_emu10k1 tea5767 tda8290 tuner_xc2028 tda9887 tuner_simple snd_rawmidi 
mt20xx snd_ac97_codec tea5761 ac97_bus snd_pcm bttv snd_seq_device snd_timer 
firewire_ohci videodev snd_page_alloc firewire_core v4l1_compat snd_util_mem 
uhci_hcd ehci_hcd ir_common snd_hwdep ide_cd_mod compat_ioctl32 crc_itu_t 
usbcore snd sr_mod v4l2_common ohci1394 videobuf_dma_sg cdrom ieee1394 
i2c_viapro videobuf_core emu10k1_gp tg3 btcx_risc gameport soundcore tveeprom 
sg evdev
Pid: 4563, comm: radio Not tainted 2.6.25-rc2-00015-g1309d4e #36
kernel:
Call Trace:
 [<ffffffff802324a3>] warn_on_slowpath+0x58/0x6b
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff8024eb31>] ? get_lock_stats+0x16/0x49
 [<ffffffff8024eb72>] ? put_lock_stats+0xe/0x27
 [<ffffffff8024ebe1>] ? lock_release_holdtime+0x56/0x5e
 [<ffffffff8039a269>] ? ide_dma_intr+0x0/0x8f
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff8046482e>] mutex_lock_nested+0xc0/0x2a3
 [<ffffffff88133f3f>] ? :bttv:radio_g_tuner+0x42/0xa8
 [<ffffffff802203de>] ? virt_to_highmap+0x9/0x18
 [<ffffffff80220566>] ? __change_page_attr+0x179/0x697
 [<ffffffff88133f3f>] :bttv:radio_g_tuner+0x42/0xa8
 [<ffffffff88118f83>] :videodev:__video_do_ioctl+0x2a6e/0x2e25
 [<ffffffff80220af0>] ? __change_page_attr_set_clr+0x6c/0xc0
 [<ffffffff80220d2d>] ? kernel_map_pages+0x130/0x13b
 [<ffffffff8810103c>] :v4l1_compat:v4l_compat_translate_ioctl+0xea9/0x1af5
 [<ffffffff88116515>] ? :videodev:__video_do_ioctl+0x0/0x2e25
 [<ffffffff802203de>] ? virt_to_highmap+0x9/0x18
 [<ffffffff80220566>] ? __change_page_attr+0x179/0x697
 [<ffffffff802afb2e>] ? __find_get_block+0x171/0x183
 [<ffffffff802203de>] ? virt_to_highmap+0x9/0x18
 [<ffffffff80220566>] ? __change_page_attr+0x179/0x697
 [<ffffffff80220af0>] ? __change_page_attr_set_clr+0x6c/0xc0
 [<ffffffff8026895f>] ? mempool_alloc_slab+0x11/0x13
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff80250dfb>] ? mark_held_locks+0x59/0x75
 [<ffffffff804659dd>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff80250fa5>] ? trace_hardirqs_on+0xf9/0x124
 [<ffffffff804659dd>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff8020b9c3>] ? restore_args+0x0/0x3d
 [<ffffffff8031bbe7>] ? __delay+0x33/0x4f
last message repeated 2 times
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff8024eb31>] ? get_lock_stats+0x16/0x49
 [<ffffffff8024eb72>] ? put_lock_stats+0xe/0x27
 [<ffffffff80250dfb>] ? mark_held_locks+0x59/0x75
 [<ffffffff80464740>] ? __mutex_unlock_slowpath+0xf9/0x11c
 [<ffffffff80250fa5>] ? trace_hardirqs_on+0xf9/0x124
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff802520d7>] ? __lock_acquire+0xc93/0xcb4
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff8024eb31>] ? get_lock_stats+0x16/0x49
 [<ffffffff8024eb72>] ? put_lock_stats+0xe/0x27
 [<ffffffff8024ebe1>] ? lock_release_holdtime+0x56/0x5e
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff802520d7>] ? __lock_acquire+0xc93/0xcb4
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff8024eb31>] ? get_lock_stats+0x16/0x49
 [<ffffffff8024eb72>] ? put_lock_stats+0xe/0x27
 [<ffffffff8811664e>] :videodev:__video_do_ioctl+0x139/0x2e25
 [<ffffffff802520d7>] ? __lock_acquire+0xc93/0xcb4
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff8024eb72>] ? put_lock_stats+0xe/0x27
 [<ffffffff8024ebe1>] ? lock_release_holdtime+0x56/0x5e
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff881196b1>] :videodev:video_ioctl2+0x1b8/0x259
 [<ffffffff8046668b>] ? _spin_unlock_irqrestore+0x3f/0x68
 [<ffffffff80250fa5>] ? trace_hardirqs_on+0xf9/0x124
 [<ffffffff8029b22e>] vfs_ioctl+0x5e/0x77
 [<ffffffff8029b4a2>] do_vfs_ioctl+0x25b/0x270
 [<ffffffff804659dd>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8029b4f9>] sys_ioctl+0x42/0x65
 [<ffffffff8020b36b>] system_call_after_swapgs+0x7b/0x80
kernel:
---[ end trace bb0fc13470ac3add ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff8031f5d4>] __list_add+0x2e/0x5b
PGD 68e90067 PUD 6833a067 PMD 0
Oops: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
CPU 1
Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq 
binfmt_misc loop nls_cp437 vfat fat nls_iso8859_1 ntfs dm_mod thermal 
processor fan container button pcspkr snd_pcm_oss snd_mixer_oss tuner 
snd_emu10k1 tea5767 tda8290 tuner_xc2028 tda9887 tuner_simple snd_rawmidi 
mt20xx snd_ac97_codec tea5761 ac97_bus snd_pcm bttv snd_seq_device snd_timer 
firewire_ohci videodev snd_page_alloc firewire_core v4l1_compat snd_util_mem 
uhci_hcd ehci_hcd ir_common snd_hwdep ide_cd_mod compat_ioctl32 crc_itu_t 
usbcore snd sr_mod v4l2_common ohci1394 videobuf_dma_sg cdrom ieee1394 
i2c_viapro videobuf_core emu10k1_gp tg3 btcx_risc gameport soundcore tveeprom 
sg evdev
Pid: 4563, comm: radio Not tainted 2.6.25-rc2-00015-g1309d4e #36
RIP: 0010:[<ffffffff8031f5d4>]  [<ffffffff8031f5d4>] __list_add+0x2e/0x5b
RSP: 0018:ffff81005231d5b8  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffffffffffffff RCX: 0000000000000000
RDX: ffff81007f2bc378 RSI: ffff81007f2bc378 RDI: ffff81005231d5d8
RBP: ffff81005231d5b8 R08: 0000000000000000 R09: 0000000000000001
R10: ffff81005231d2d8 R11: 0000000000007420 R12: ffff81007f2bc338
R13: 0000000000000246 R14: ffff81007f2bc3a0 R15: ffff81005da847c0
FS:  00007f3c348aa6f0(0000) GS:ffff81007f0554c8(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000075c6e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process radio (pid: 4563, threadinfo ffff81005231c000, task ffff81005da847c0)
Stack:  ffff81005231d638 ffffffff8046487f ffffffff88133f3f 000000005da84808
 ffff81005231d5d8 ffff81005231d5d8 1111111111111111 ffff81007f2bc338
 ffff81005231d5d8 ffff81006002d000 ffff81005231d6e8 ffff81005231daa8
Call Trace:
 [<ffffffff8046487f>] mutex_lock_nested+0x111/0x2a3
 [<ffffffff88133f3f>] ? :bttv:radio_g_tuner+0x42/0xa8
 [<ffffffff88133f3f>] :bttv:radio_g_tuner+0x42/0xa8
 [<ffffffff88118f83>] :videodev:__video_do_ioctl+0x2a6e/0x2e25
 [<ffffffff80220af0>] ? __change_page_attr_set_clr+0x6c/0xc0
 [<ffffffff80220d2d>] ? kernel_map_pages+0x130/0x13b
 [<ffffffff8810103c>] :v4l1_compat:v4l_compat_translate_ioctl+0xea9/0x1af5
 [<ffffffff88116515>] ? :videodev:__video_do_ioctl+0x0/0x2e25
 [<ffffffff802203de>] ? virt_to_highmap+0x9/0x18
 [<ffffffff80220566>] ? __change_page_attr+0x179/0x697
 [<ffffffff802afb2e>] ? __find_get_block+0x171/0x183
 [<ffffffff802203de>] ? virt_to_highmap+0x9/0x18
 [<ffffffff80220566>] ? __change_page_attr+0x179/0x697
 [<ffffffff80220af0>] ? __change_page_attr_set_clr+0x6c/0xc0
 [<ffffffff8026895f>] ? mempool_alloc_slab+0x11/0x13
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff80250dfb>] ? mark_held_locks+0x59/0x75
 [<ffffffff804659dd>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff80250fa5>] ? trace_hardirqs_on+0xf9/0x124
 [<ffffffff804659dd>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff8020b9c3>] ? restore_args+0x0/0x3d
 [<ffffffff8031bbe7>] ? __delay+0x33/0x4f
last message repeated 2 times
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff8024eb31>] ? get_lock_stats+0x16/0x49
 [<ffffffff8024eb72>] ? put_lock_stats+0xe/0x27
 [<ffffffff80250dfb>] ? mark_held_locks+0x59/0x75
 [<ffffffff80464740>] ? __mutex_unlock_slowpath+0xf9/0x11c
 [<ffffffff80250fa5>] ? trace_hardirqs_on+0xf9/0x124
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff802520d7>] ? __lock_acquire+0xc93/0xcb4
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff8024eb31>] ? get_lock_stats+0x16/0x49
 [<ffffffff8024eb72>] ? put_lock_stats+0xe/0x27
 [<ffffffff8024ebe1>] ? lock_release_holdtime+0x56/0x5e
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff802520d7>] ? __lock_acquire+0xc93/0xcb4
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff8024eb31>] ? get_lock_stats+0x16/0x49
 [<ffffffff8024eb72>] ? put_lock_stats+0xe/0x27
 [<ffffffff8811664e>] :videodev:__video_do_ioctl+0x139/0x2e25
 [<ffffffff802520d7>] ? __lock_acquire+0xc93/0xcb4
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff8024eb72>] ? put_lock_stats+0xe/0x27
 [<ffffffff8024ebe1>] ? lock_release_holdtime+0x56/0x5e
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff881196b1>] :videodev:video_ioctl2+0x1b8/0x259
 [<ffffffff8046668b>] ? _spin_unlock_irqrestore+0x3f/0x68
 [<ffffffff80250fa5>] ? trace_hardirqs_on+0xf9/0x124
 [<ffffffff8029b22e>] vfs_ioctl+0x5e/0x77
 [<ffffffff8029b4a2>] do_vfs_ioctl+0x25b/0x270
 [<ffffffff804659dd>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8029b4f9>] sys_ioctl+0x42/0x65
 [<ffffffff8020b36b>] system_call_after_swapgs+0x7b/0x80
kernel:
kernel:
Code: 42 08 49 89 f0 48 89 d6 48 89 e5 4c 39 c0 74 1b 48 89 d1 4c 89 c6 48 89 
c2 48 c7 c7 b4 ed 54 80 31 c0 e8 6d 3d f1 ff 0f 0b eb fe <48> 8b 10 48 39 f2 
74 15 48 89 c1 48 c7 c7 04 ee 54 80 31 c0 e8
RIP  [<ffffffff8031f5d4>] __list_add+0x2e/0x5b
 RSP <ffff81005231d5b8>
CR2: 0000000000000000
---[ end trace bb0fc13470ac3add ]---

BUG: sleeping function called from invalid context 
at /home/bongani/kernel/git/linux-2.6/kernel/rwsem.c:21
in_atomic():0, irqs_disabled():1
INFO: lockdep is turned off.
irq event stamp: 7544
hardirqs last  enabled at (7543): [<ffffffff804659dd>] 
trace_hardirqs_on_thunk+0x35/0x3a
hardirqs last disabled at (7544): [<ffffffff804647ea>] 
mutex_lock_nested+0x7c/0x2a3
softirqs last  enabled at (7516): [<ffffffff802377c7>] __do_softirq+0xbf/0xc8
softirqs last disabled at (7511): [<ffffffff8020c65c>] call_softirq+0x1c/0x28
Pid: 4563, comm: radio Tainted: G      D  2.6.25-rc2-00015-g1309d4e #36
kernel:
Call Trace:
 [<ffffffff8024e6bf>] ? print_irqtrace_events+0x110/0x114
 [<ffffffff80229c52>] __might_sleep+0xda/0xdc
 [<ffffffff80464ecf>] down_read+0x20/0x68
 [<ffffffff802604ed>] acct_collect+0x42/0x1a9
 [<ffffffff80235bfe>] do_exit+0x20a/0x6f3
 [<ffffffff8036be33>] ? do_unblank_screen+0x29/0x125
 [<ffffffff80466eae>] oops_begin+0x0/0x95
 [<ffffffff80468d15>] do_page_fault+0x708/0x7bf
 [<ffffffff804669ad>] error_exit+0x0/0xa9
 [<ffffffff8031f5d4>] ? __list_add+0x2e/0x5b
 [<ffffffff8046487f>] ? mutex_lock_nested+0x111/0x2a3
 [<ffffffff88133f3f>] ? :bttv:radio_g_tuner+0x42/0xa8
 [<ffffffff88133f3f>] ? :bttv:radio_g_tuner+0x42/0xa8
 [<ffffffff88118f83>] ? :videodev:__video_do_ioctl+0x2a6e/0x2e25
 [<ffffffff80220af0>] ? __change_page_attr_set_clr+0x6c/0xc0
 [<ffffffff80220d2d>] ? kernel_map_pages+0x130/0x13b
 [<ffffffff8810103c>] ? :v4l1_compat:v4l_compat_translate_ioctl+0xea9/0x1af5
 [<ffffffff88116515>] ? :videodev:__video_do_ioctl+0x0/0x2e25
 [<ffffffff802203de>] ? virt_to_highmap+0x9/0x18
 [<ffffffff80220566>] ? __change_page_attr+0x179/0x697
 [<ffffffff802afb2e>] ? __find_get_block+0x171/0x183
 [<ffffffff802203de>] ? virt_to_highmap+0x9/0x18
 [<ffffffff80220566>] ? __change_page_attr+0x179/0x697
 [<ffffffff80220af0>] ? __change_page_attr_set_clr+0x6c/0xc0
 [<ffffffff8026895f>] ? mempool_alloc_slab+0x11/0x13
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff80250dfb>] ? mark_held_locks+0x59/0x75
 [<ffffffff804659dd>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff80250fa5>] ? trace_hardirqs_on+0xf9/0x124
 [<ffffffff804659dd>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff8020b9c3>] ? restore_args+0x0/0x3d
 [<ffffffff8031bbe7>] ? __delay+0x33/0x4f
last message repeated 2 times
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff8024eb31>] ? get_lock_stats+0x16/0x49
 [<ffffffff8024eb72>] ? put_lock_stats+0xe/0x27
 [<ffffffff80250dfb>] ? mark_held_locks+0x59/0x75
 [<ffffffff80464740>] ? __mutex_unlock_slowpath+0xf9/0x11c
 [<ffffffff80250fa5>] ? trace_hardirqs_on+0xf9/0x124
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff802520d7>] ? __lock_acquire+0xc93/0xcb4
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff8024eb31>] ? get_lock_stats+0x16/0x49
 [<ffffffff8024eb72>] ? put_lock_stats+0xe/0x27
 [<ffffffff8024ebe1>] ? lock_release_holdtime+0x56/0x5e
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff802520d7>] ? __lock_acquire+0xc93/0xcb4
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff8024eb31>] ? get_lock_stats+0x16/0x49
 [<ffffffff8024eb72>] ? put_lock_stats+0xe/0x27
 [<ffffffff8811664e>] ? :videodev:__video_do_ioctl+0x139/0x2e25
 [<ffffffff802520d7>] ? __lock_acquire+0xc93/0xcb4
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff8024eb72>] ? put_lock_stats+0xe/0x27
 [<ffffffff8024ebe1>] ? lock_release_holdtime+0x56/0x5e
 [<ffffffff80211799>] ? native_sched_clock+0x4d/0x6c
 [<ffffffff881196b1>] ? :videodev:video_ioctl2+0x1b8/0x259
 [<ffffffff8046668b>] ? _spin_unlock_irqrestore+0x3f/0x68
 [<ffffffff80250fa5>] ? trace_hardirqs_on+0xf9/0x124
 [<ffffffff8029b22e>] ? vfs_ioctl+0x5e/0x77
 [<ffffffff8029b4a2>] ? do_vfs_ioctl+0x25b/0x270
 [<ffffffff804659dd>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8029b4f9>] ? sys_ioctl+0x42/0x65
 [<ffffffff8020b36b>] ? system_call_after_swapgs+0x7b/0x80

