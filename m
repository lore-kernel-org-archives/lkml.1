Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbYKTRDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbYKTRDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 12:03:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbYKTRCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 12:02:05 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:22874 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123AbYKTRCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 12:02:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=I8fU5RFDQ7uHVvkKuWZnpX9gxNkrT3UUMXtn2PYyOZYgafvLzNmrs5n69U6BKxbbQB
         QGB7WbhCC3zq3mje6ejvKSMEYU2xwIspxA5Io5v5r7ZO9E8GKYdWS+5BN7XDc9CYad0f
         n6PNwbuDWY97sBMAQImWNERj7Y7/QW7bzLEfo=
Message-ID: <ea3b75ed0811200901p1bd9e746q5b3757dd6114f3bd@mail.gmail.com>
Date: Thu, 20 Nov 2008 12:01:58 -0500
From: "Brian Phelps" <lm317t@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: kernel BUG at mm/slab.c:601
Cc: linux-kernel@vger.kernel.org, "Al Viro" <viro@zeniv.linux.org.uk>,
       "Mikael Pettersson" <mikpe@it.uu.se>,
       "Alexander Shaduri" <ashaduri@gmail.com>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <19f34abd0811191419x3f6981ady7de5bf40f9ae2983@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ea3b75ed0811181524y7cdad2afl85e0281e293922cc@mail.gmail.com>
	 <19f34abd0811191419x3f6981ady7de5bf40f9ae2983@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay guys, here is the crash with the debug enabled using "make
CONFIG_DEBUG_SLAB=y"

[   11.846855] [drm] Initialized i915 1.6.0 20060119 on minor 0
[   12.442537] set status page addr 0x00033000
[   15.251686] set status page addr 0x00033000
[   19.452026] eth1: no IPv6 routers present
[  527.562250] BUG: unable to handle kernel paging request at ffffffff23232a3b
[  527.562257] IP: [<ffffffff8043a2be>] mutex_lock+0x0/0xb
[  527.562266] PGD 203067 PUD 0
[  527.562269] Oops: 0002 [1] SMP
[  527.562272] CPU 2
[  527.562274] Modules linked in: i915 drm ipv6 dm_snapshot dm_mirror
dm_log dm_mod coretemp w83627ehf hwmon_vid bttv ir_common
compat_ioctl32 videodev v4l1_compat i2c_algo_bit v4l2_common
videobuf_dma_sg videobuf_core btcx_risc tveeprom shpchp rng_core
pci_hotplug i2c_i801 snd_hda_intel snd_pcsp iTCO_wdt ftdi_sio i2c_core
usbserial video snd_pcm output snd_timer snd soundcore snd_page_alloc
button intel_agp evdev ext2 mbcache sd_mod usb_storage ata_piix
ata_generic libata scsi_mod piix dock usbhid hid ff_memless floppy
ide_pci_generic ide_core r8169 mii ehci_hcd uhci_hcd thermal processor
fan thermal_sys
[  527.562324] Pid: 2740, comm: a.out Not tainted 2.6.27.6 #7
[  527.562327] RIP: 0010:[<ffffffff8043a2be>]  [<ffffffff8043a2be>]
mutex_lock+0x0/0xb
[  527.562331] RSP: 0000:ffff880018d87ad0  EFLAGS: 00010297
[  527.562334] RAX: ffffffffa0289f98 RBX: ffff88001e188000 RCX: ffff880018d87cd8
[  527.562337] RDX: 0000000000000004 RSI: ffff88001e13c600 RDI: ffffffff23232a3b
[  527.562339] RBP: ffff88001e13c600 R08: 0000000008048840 R09: 00000000ff804e78
[  527.562342] R10: ffff880018d86000 R11: ffffffff802f9753 R12: ffffffff23232a3b
[  527.562345] R13: 0000000000000280 R14: ffffffff23232323 R15: 00000000000001e0
[  527.562348] FS:  0000000000000000(0000) GS:ffff88001e93f1c0(0063)
knlGS:00000000f7d9e6b0
[  527.562351] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[  527.562353] CR2: ffffffff23232a3b CR3: 0000000011fcc000 CR4: 00000000000006e0
[  527.562355] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  527.562358] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  527.562361] Process a.out (pid: 2740, threadinfo ffff880018d86000,
task ffff88001ed17400)
[  527.562363] Stack:  ffffffffa0281a87 ffffffff802ac916
0000000400000000 ffff88001e188018
[  527.562369]  ffffffffa0289f98 000002801e13c600 ffffffffa024693d
000008008022fc03
[  527.562373]  ffffffff8043b157 0000000000200200 ffffffffa02810d4
ffff88001e13c600
[  527.562377] Call Trace:
[  527.562390]  [<ffffffffa0281a87>] ? buffer_prepare+0xf8/0x30a [bttv]
[  527.562395]  [<ffffffff802ac916>] ? __pollwait+0x0/0xe2
[  527.562403]  [<ffffffffa024693d>] ? videobuf_dqbuf+0x2b7/0x2f3
[videobuf_core]
[  527.562406]  [<ffffffff8043b157>] ? __down_read+0x15/0x99
[  527.562417]  [<ffffffffa02810d4>] ? bttv_qbuf+0x0/0x6c [bttv]
[  527.562432]  [<ffffffffa0246c2b>] ? videobuf_qbuf+0x2b2/0x397 [videobuf_core]
[  527.562438]  [<ffffffffa02810d4>] ? bttv_qbuf+0x0/0x6c [bttv]
[  527.562443]  [<ffffffffa0263caa>] ? __video_do_ioctl+0x1185/0x30d3 [videodev]
[  527.562447]  [<ffffffff80228e41>] ? enqueue_task+0x59/0x64
[  527.562449]  [<ffffffff80228f26>] ? activate_task+0x22/0x2a
[  527.562451]  [<ffffffff8022fbf1>] ? try_to_wake_up+0x183/0x195
[  527.562454]  [<ffffffff802291a8>] ? __wake_up_common+0x46/0x76
[  527.562457]  [<ffffffffa0265d74>] ? video_ioctl2+0x17c/0x20c [videodev]
[  527.562461]  [<ffffffff80247e06>] ? remove_wait_queue+0x12/0x41
[  527.562464]  [<ffffffffa026d04f>] ? native_ioctl+0x4f/0x60 [compat_ioctl32]
[  527.562467]  [<ffffffffa026e008>] ? v4l_compat_ioctl32+0xfa8/0x1770
[compat_ioctl32]
[  527.562469]  [<ffffffff80247e06>] ? remove_wait_queue+0x12/0x41
[  527.562472]  [<ffffffff8022a79f>] ? __wake_up+0x38/0x4f
[  527.562475]  [<ffffffff80376f1f>] ? tty_ldisc_deref+0x1e/0x6b
[  527.562478]  [<ffffffff8037271f>] ? tty_write+0x203/0x21e
[  527.562481]  [<ffffffff802cf564>] ? compat_sys_ioctl+0xc4/0x340
[  527.562484]  [<ffffffff802a0102>] ? vfs_write+0x121/0x156
[  527.562486]  [<ffffffff80225732>] ? ia32_sysret+0x0/0xa
[  527.562487]
[  527.562488]
[  527.562489] Code: 1c 24 44 89 64 24 08 48 c7 44 24 20 b4 7c 24 80
48 89 44 24 28 48 89 44 24 30 e8 25 ff ff ff 48 83 c4 48 5b 41 5c 41
5d 41 5e c3 <f0> ff 0f 79 05 e8 fa 00 00 00 c3 f0 ff 07 7f 05 e8 75 02
00 00
[  527.562512] RIP  [<ffffffff8043a2be>] mutex_lock+0x0/0xb
[  527.562514]  RSP <ffff880018d87ad0>
[  527.562516] CR2: ffffffff23232a3b
[  527.562517] ---[ end trace 21ba9ea650bd284a ]---
[  537.872407] BUG: unable to handle kernel paging request at ffff880026262200
[  537.872412] IP: [<ffffffff802845da>] handle_mm_fault+0x11f/0x71b
[  537.872419] PGD 202063 PUD 206063 PMD 0
[  537.872423] Oops: 0000 [2] SMP
[  537.872426] CPU 2
[  537.872427] Modules linked in: i915 drm ipv6 dm_snapshot dm_mirror
dm_log dm_mod coretemp w83627ehf hwmon_vid bttv ir_common
compat_ioctl32 videodev v4l1_compat i2c_algo_bit v4l2_common
videobuf_dma_sg videobuf_core btcx_risc tveeprom shpchp rng_core
pci_hotplug i2c_i801 snd_hda_intel snd_pcsp iTCO_wdt ftdi_sio i2c_core
usbserial video snd_pcm output snd_timer snd soundcore snd_page_alloc
button intel_agp evdev ext2 mbcache sd_mod usb_storage ata_piix
ata_generic libata scsi_mod piix dock usbhid hid ff_memless floppy
ide_pci_generic ide_core r8169 mii ehci_hcd uhci_hcd thermal processor
fan thermal_sys
[  537.872477] Pid: 2738, comm: a.out Tainted: G      D   2.6.27.6 #7
[  537.872479] RIP: 0010:[<ffffffff802845da>]  [<ffffffff802845da>]
handle_mm_fault+0x11f/0x71b
[  537.872484] RSP: 0000:ffff880017d9bd78  EFLAGS: 00010286
[  537.872487] RAX: ffff880026262200 RBX: ffff880018823000 RCX: 0000000000000000
[  537.872490] RDX: 0000000000000200 RSI: ffff88001d4aece8 RDI: ffff88001d49ca80
[  537.872492] RBP: 0000000008048cf6 R08: 0000000000000000 R09: 0000000000000000
[  537.872495] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000014
[  537.872497] R13: ffff88001e016f40 R14: ffff88001d4aece8 R15: 0000000008048cf6
[  537.872500] FS:  0000000000000000(0000) GS:ffff88001e93f1c0(0063)
knlGS:00000000f7e0a6b0
[  537.872503] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[  537.872506] CR2: ffff880026262200 CR3: 000000001d4a2000 CR4: 00000000000006e0
[  537.872508] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  537.872511] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  537.872513] Process a.out (pid: 2738, threadinfo ffff880017d9a000,
task ffff88001e016f40)
[  537.872516] Stack:  00000000c058560f 0000000000000000
0000000017d9bf40 ffff88001d49ca80
[  537.872521]  0000000000000000 ffff880026262200 0000000000000008
0000000000000000
[  537.872525]  0000000000000000 ffff88001d4aece8 0000000008048cf6
0000000000000014
[  537.872529] Call Trace:
[  537.872534]  [<ffffffff80221c90>] ? do_page_fault+0x42b/0x81b
[  537.872538]  [<ffffffff8022a79f>] ? __wake_up+0x38/0x4f
[  537.872542]  [<ffffffff80376f1f>] ? tty_ldisc_deref+0x1e/0x6b
[  537.872546]  [<ffffffff802cbf76>] ? compat_sys_select+0x10c/0x13d
[  537.872550]  [<ffffffff8043b4e9>] ? error_exit+0x0/0x51
[  537.872552]
[  537.872553]
[  537.872554] Code: 48 23 03 48 ba 00 00 00 00 00 88 ff ff 48 01 d0
4c 89 fa 48 c1 ea 12 81 e2 f8 0f 00 00 48 01 d0 48 89 44 24 28 0f 84
c8 05 00 00 <f6> 00 01 75 18 48 8b 7c 24 18 4c 89 fa 48 89 c6 e8 4d fe
ff ff
[  537.872588] RIP  [<ffffffff802845da>] handle_mm_fault+0x11f/0x71b
[  537.872592]  RSP <ffff880017d9bd78>
[  537.872594] CR2: ffff880026262200
[  537.872597] ---[ end trace 21ba9ea650bd284a ]---
[  537.872605] mm/memory.c:124: bad pud ffff880018823000(0000000026262626).
[  537.992386] ------------[ cut here ]------------
[  537.992391] kernel BUG at mm/mmap.c:2088!
[  537.992394] invalid opcode: 0000 [3] SMP
[  537.992397] CPU 0
[  537.992399] Modules linked in: i915 drm ipv6 dm_snapshot dm_mirror
dm_log dm_mod coretemp w83627ehf hwmon_vid bttv ir_common
compat_ioctl32 videodev v4l1_compat i2c_algo_bit v4l2_common
videobuf_dma_sg videobuf_core btcx_risc tveeprom shpchp rng_core
pci_hotplug i2c_i801 snd_hda_intel snd_pcsp iTCO_wdt ftdi_sio i2c_core
usbserial video snd_pcm output snd_timer snd soundcore snd_page_alloc
button intel_agp evdev ext2 mbcache sd_mod usb_storage ata_piix
ata_generic libata scsi_mod piix dock usbhid hid ff_memless floppy
ide_pci_generic ide_core r8169 mii ehci_hcd uhci_hcd thermal processor
fan thermal_sys
[  537.992450] Pid: 2738, comm: a.out Tainted: G      D   2.6.27.6 #7
[  537.992453] RIP: 0010:[<ffffffff8028797c>]  [<ffffffff8028797c>]
exit_mmap+0xe9/0xf4
[  537.992461] RSP: 0000:ffff880017d9ba58  EFLAGS: 00010202
[  537.992464] RAX: 0000000000000000 RBX: ffff880001023380 RCX: 0000000000000144
[  537.992467] RDX: ffff88001d49cae0 RSI: ffff88001ecf6c38 RDI: ffff88001e822380
[  537.992469] RBP: 0000000000000000 R08: ffff88001ed4dd80 R09: ffff880001101100
[  537.992472] R10: 0000000000000002 R11: ffffffff802f9752 R12: ffff88001d49ca80
[  537.992475] R13: ffff88001d49cae0 R14: ffff880017d9bcc8 R15: ffff88001d49cae0
[  537.992478] FS:  0000000000000000(0000) GS:ffffffff80576a00(0000)
knlGS:0000000000000000
[  537.992480] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[  537.992483] CR2: 00000000f7e71000 CR3: 0000000018d45000 CR4: 00000000000006e0
[  537.992485] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  537.992488] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  537.992491] Process a.out (pid: 2738, threadinfo ffff880017d9a000,
task ffff88001e016f40)
[  537.992493] Stack:  0000000000000043 ffff880001023380
ffff88001d49ca80 ffff88001e016f40
[  537.992498]  ffff88001d49ca80 ffffffff80233d81 0000000000000000
ffffffff80237535
[  537.992503]  0000000000000282 0000000000000009 ffff88001e016f40
0000000000000009
[  537.992507] Call Trace:
[  537.992511]  [<ffffffff80233d81>] mmput+0x20/0x9e
[  537.992515]  [<ffffffff80237535>] exit_mm+0xfd/0x108
[  537.992519]  [<ffffffff8023901f>] do_exit+0x21b/0x7ff
[  537.992523]  [<ffffffff8020dc29>] show_registers+0x1f7/0x21d
[  537.992526]  [<ffffffff8020d4a9>] oops_begin+0x0/0x86
[  537.992530]  [<ffffffff80221fb3>] do_page_fault+0x74e/0x81b
[  537.992535]  [<ffffffff80228e41>] enqueue_task+0x59/0x64
[  537.992538]  [<ffffffff80228f26>] activate_task+0x22/0x2a
[  537.992541]  [<ffffffff8022fbf1>] try_to_wake_up+0x183/0x195
[  537.992545]  [<ffffffff802291a8>] __wake_up_common+0x46/0x76
[  537.992549]  [<ffffffff8043b4e9>] error_exit+0x0/0x51
[  537.992553]  [<ffffffff802845da>] handle_mm_fault+0x11f/0x71b
[  537.992557]  [<ffffffff80221c90>] do_page_fault+0x42b/0x81b
[  537.992560]  [<ffffffff8022a79f>] __wake_up+0x38/0x4f
[  537.992565]  [<ffffffff80376f1f>] tty_ldisc_deref+0x1e/0x6b
[  537.992569]  [<ffffffff802cbf76>] compat_sys_select+0x10c/0x13d
[  537.992572]  [<ffffffff8043b4e9>] error_exit+0x0/0x51
[  537.992574]
[  537.992576]
[  537.992577] Code: 7b 18 e8 1c 65 00 00 c7 43 08 00 00 00 00 eb 0b
48 89 ef e8 c0 fe ff ff 48 89 c5 48 85 ed 75 f0 49 83 bc 24 e8 00 00
00 00 74 04 <0f> 0b eb fe 59 5e 5b 5d 41 5c c3 41 56 41 be f4 ff ff ff
41 55
[  537.992615] RIP  [<ffffffff8028797c>] exit_mmap+0xe9/0xf4
[  537.992618]  RSP <ffff880017d9ba58>
[  537.992620] ---[ end trace 21ba9ea650bd284a ]---
[  537.992621] Fixing recursive fault but reboot is needed!


On Wed, Nov 19, 2008 at 5:19 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Wed, Nov 19, 2008 at 12:24 AM, Brian Phelps <lm317t@gmail.com> wrote:
>> This possible kernel bug (see bottom) is very reproducible when the
>> pci bus gets loaded with traffic, specifically video data.
>> It has been reproduced on 2 identical machines.
>>
>> Please let me know if you need more information
>
> Hi,
>
> Can you reproduce this with CONFIG_DEBUG_SLAB=y?
>
> Can you reproduce this with CONFIG_SLUB=y instead of SLAB? If not,
> could be a genuine bug in SLAB (but I doubt it). If yes, then SLUB
> debugging might help us more than SLAB debugging can.
>
> It sounds likely that bttv driver is involved somehow -- it would fit
> with your description too. Maybe the fact that the same driver is
> serving many devices on the same IRQ? But I guess that shouldn't
> really be a problem.
>
> It would also be interesting to see if you can find more different
> crashes in other places, like the corrupted page tables. Those are
> important clues. Like this:
>
>> [ 2128.370257] PGD 10869067 PUD 23232323 BAD
>
> That looks like a magic number of sorts. This was the only one I could
> find, however:
>
> crypto/anubis.c:      0x83838383U, 0x1b1b1b1bU, 0x0e0e0e0eU, 0x23232323U,
>
> But google has some more info. A google for "23232323 bug" turned up
> this thread:
>
> http://lkml.org/lkml/2008/1/5/51
>
> ...which also involves bttv driver. I've added the Ccs of that discussion.
>
> But it seems that it is not a regression at least. Did you try earlier
> kernels as well?
>
>
> Vegard
>
> --
> "The animistic metaphor of the bug that maliciously sneaked in while
> the programmer was not looking is intellectually dishonest as it
> disguises that the error is the programmer's own creation."
>        -- E. W. Dijkstra, EWD1036
>
