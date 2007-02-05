Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbXBEFhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbXBEFhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 00:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbXBEFhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 00:37:36 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:26046 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbXBEFhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 00:37:35 -0500
Date: Sun, 4 Feb 2007 21:17:05 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Liontooth <liontooth@cogweb.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Eeek! page_mapcount(page) went negative! (-1)
Message-Id: <20070204211705.8cd3203b.randy.dunlap@oracle.com>
In-Reply-To: <45C6B71E.9050805@cogweb.net>
References: <45C698D1.1070208@cogweb.net>
	<45C6B71E.9050805@cogweb.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Feb 2007 20:48:30 -0800 David Liontooth wrote:

> David Liontooth wrote:
> > Running a script called thumbnails, which uses imagemagick's convert
> > utility, I got this on a mainline 2.6.16.38:
> >
> > Feb  4 17:04:01 prato /USR/SBIN/CRON[17173]: (tna) CMD (thumbnails
> > /db2/2006/2006-11/2006-11-16)
> >
> > Feb  4 17:20:49 prato kernel: swap_free: Unused swap offset entry 00000080
> > Feb  4 17:20:49 prato kernel: convert[23078]: segfault at
> > 0000000000008000 rip 00002b885c7d6590 rsp 00007fffffa49308 error 4
> > Feb  4 17:20:50 prato kernel: convert[23113]: segfault at
> > 0000000000008010 rip 00002b0914f305aa rsp 00007fffff984340 error 4
> >
> > Feb  4 17:50:57 prato kernel: swap_free: Unused swap offset entry 00000080
> > Feb  4 17:50:57 prato kernel: swap_free: Unused swap offset entry 00000080
> > Feb  4 17:50:57 prato kernel: Eeek! page_mapcount(page) went negative! (-1)
> > Feb  4 17:50:57 prato kernel:   page->flags = 10000000000083c
> > Feb  4 17:50:57 prato kernel:   page->count = 2
> > Feb  4 17:50:57 prato kernel:   page->mapping = ffff81002604c670
> > Feb  4 17:50:57 prato kernel: ----------- [cut here ] --------- [please
> > bite here ] ---------
> > Feb  4 17:50:57 prato kernel: Kernel BUG at mm/rmap.c:560
> > Feb  4 17:50:57 prato kernel: invalid opcode: 0000 [1] SMP
> > Feb  4 17:50:57 prato kernel: CPU 1
> > Feb 4 17:50:57 prato kernel: Modules linked in: lirc_serial lirc_dev
> > saa7134_alsa tuner saa7134 video_buf compat_ioctl32 v4l2_common v4l1_compat
> > ir_kbd_i2c ir_common videodev skge ehci_hcd ohci_hcd psmouse pcspkr evdev
> > Feb  4 17:50:57 prato kernel: Pid: 29168, comm: thumbnails Tainted:
> > GF     2.6.16.38 #1
> > Feb  4 17:50:57 prato kernel: RIP: 0010:[<ffffffff801581f0>]
> > <ffffffff801581f0>{page_remove_rmap+117}
> > Feb  4 17:50:57 prato kernel: RSP: 0018:ffff81000bc6dde8  EFLAGS: 00010286
> > Feb  4 17:50:57 prato kernel: RAX: 00000000ffffffff RBX:
> > ffff810001d1b290 RCX: 0000000000006507
> > Feb  4 17:50:57 prato kernel: RDX: 00000000ffffff01 RSI:
> > 0000000000000292 RDI: ffffffff80465dfc
> > Feb  4 17:50:57 prato kernel: RBP: 000000003be9e000 R08:
> > 0000000000000000 R09: 0000000000000001
> > Feb  4 17:50:57 prato kernel: R10: 0000000000000010 R11:
> > 0000000000000000 R12: 000000000062f000
> > Feb  4 17:50:57 prato kernel: R13: ffff810015ed7178 R14:
> > 00000000006d6000 R15: ffff810001e12220
> > Feb  4 17:50:57 prato kernel: FS:  00002b444df8a6d0(0000)
> > GS:ffff810001fc5ac0(0000) knlGS:0000000000000000
> > Feb  4 17:50:57 prato kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> > 000000008005003b
> > Feb  4 17:50:57 prato kernel: CR2: 00002b444ddb61f0 CR3:
> > 0000000013f22000 CR4: 00000000000006e0
> > Feb  4 17:50:57 prato kernel: Process thumbnails (pid: 29168, threadinfo
> > ffff81000bc6c000, task ffff81003fe25160)
> > Feb  4 17:50:57 prato kernel: Stack: ffff810001d1b290 ffffffff801519da
> > 0000000000000000 ffff81000bc6dec8
> > Feb  4 17:50:57 prato kernel:        ffffffffffffffff 0000000000000000
> > ffff81002955d648 ffff81000bc6ded0
> > Feb  4 17:50:57 prato kernel:        0000000000000000 000000012cf477b8
> > Feb  4 17:50:57 prato kernel: Call Trace:
> > <ffffffff801519da>{unmap_vmas+1012} <ffffffff80154a7d>{exit_mmap+120}
> > Feb  4 17:50:57 prato kernel:        <ffffffff80126c7d>{mmput+40}
> > <ffffffff8012bb38>{do_exit+489}
> > Feb  4 17:50:57 prato kernel:       
> > <ffffffff8012c217>{sys_exit_group+0} <ffffffff8010a936>{system_call+126}
> > Feb  4 17:50:57 prato kernel:
> > Feb  4 17:50:57 prato kernel: Code: 0f 0b 68 f8 21 40 80 c2 30 02 5b 48
> > 83 ce ff bf 20 00 00 00
> > Feb  4 17:50:57 prato kernel: RIP
> > <ffffffff801581f0>{page_remove_rmap+117} RSP <ffff81000bc6dde8>
> > Feb  4 17:50:57 prato kernel:  <1>Fixing recursive fault but reboot is
> > needed!
> > Feb  4 17:52:52 prato kernel: Bad page state in process 'kswapd0'
> > Feb  4 17:52:52 prato kernel: page:ffff810001d1b290
> > flags:0x0100000000000008 mapping:0000000000000000 mapcount:-1 count:0
> > Feb  4 17:52:52 prato kernel: Trying to fix it up, but a reboot is needed
> > Feb  4 17:52:52 prato kernel: Backtrace:
> > Feb  4 17:52:52 prato kernel:
> > Feb  4 17:52:52 prato kernel: Call Trace:
> > <ffffffff80149d38>{bad_page+80} <ffffffff8014a0f3>{free_hot_cold_page+116}
> > Feb  4 17:52:52 prato kernel:       
> > <ffffffff8014a19a>{__pagevec_free+33}
> > <ffffffff8014cfc6>{__pagevec_release_nonlru+122}
> > Feb  4 17:52:52 prato kernel:       
> > <ffffffff8014e341>{shrink_zone+2280} <ffffffff8014ec9d>{balance_pgdat+527}
> > Feb  4 17:52:52 prato kernel:        <ffffffff8014f21c>{kswapd+265}
> > <ffffffff8013ae86>{autoremove_wake_function+0}
> > Feb  4 17:52:52 prato kernel:        <ffffffff8010b782>{child_rip+8}
> > <ffffffff8014f113>{kswapd+0}
> > Feb  4 17:52:52 prato kernel:        <ffffffff8010b77a>{child_rip+0}
> >
> > lspci
> >
> > 00:00.0 Host bridge: nVidia Corporation nForce3 250Gb Host Bridge (rev a1)
> > 00:01.0 ISA bridge: nVidia Corporation nForce3 250Gb LPC Bridge (rev a2)
> > 00:01.1 SMBus: nVidia Corporation nForce 250Gb PCI System Management
> > (rev a1)
> > 00:02.0 USB Controller: nVidia Corporation CK8S USB Controller (rev a1)
> > 00:02.1 USB Controller: nVidia Corporation CK8S USB Controller (rev a1)
> > 00:02.2 USB Controller: nVidia Corporation nForce3 EHCI USB 2.0
> > Controller (rev a2)
> > 00:06.0 Multimedia audio controller: nVidia Corporation nForce3 250Gb
> > AC'97 Audio Controller (rev a1)
> > 00:08.0 IDE interface: nVidia Corporation CK8S Parallel ATA Controller
> > (v2.5) (rev a2)
> > 00:0a.0 IDE interface: nVidia Corporation CK8S Serial ATA Controller
> > (v2.5) (rev a2)
> > 00:0b.0 PCI bridge: nVidia Corporation nForce3 250Gb AGP Host to PCI
> > Bridge (rev a2)
> > 00:0e.0 PCI bridge: nVidia Corporation nForce3 250Gb PCI-to-PCI Bridge
> > (rev a2)
> > 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> > HyperTransport Technology Configuration
> > 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> > Address Map
> > 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> > DRAM Controller
> > 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> > Miscellaneous Control
> > 01:00.0 VGA compatible controller: nVidia Corporation NV18 [GeForce4 MX
> > 4000 AGP 8x] (rev c1)
> > 02:06.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
> > Video Broadcast Decoder (rev 10)
> > 02:07.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
> > Video Broadcast Decoder (rev 10)
> > 02:08.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
> > Video Broadcast Decoder (rev 10)
> > 02:09.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
> > Video Broadcast Decoder (rev 10)
> > 02:0a.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
> > Video Broadcast Decoder (rev 10)
> > 02:0b.0 Ethernet controller: Marvell Technology Group Ltd. 88E8001
> > Gigabit Ethernet Controller (rev 13)
> >
> > Let me know if more information would be useful, such as the kernel
> > .config file.
> >
> >   
> More from the same machine -- it really doesn't like the script, which
> simply does:
> 
> nice -n 19 transcode -q 0 -o $FIL.img/$FIL.img -y im -F png -x
> ffmpeg,null -i $FIL.avi -c \
> 0:00:00-0:00:00.1,0:00:10-0:00:10.1,0:00:20-0:00:20.1,0:00:30-0:00:30.1,0:00:40-0:00:40.1,0:00:50-0:00:50.1,\
> 0:01:00-0:01:00.1,0:01:10-0:01:10.1,0:01:20-0:01:20.1,0:01:30-0:01:30.1,0:01:40-0:01:40.1,0:01:50-0:01:50.1
> 
> nice -n 19 convert -thumbnail 80x60 $IMG.png $THUMBS/$IMG.jpg
> 
> nice -n 19 montage -tile 15 -geometry +1,+1 $FIL.img/$THUMBS/*.jpg $FIL.jpg
> 
> I run the same script on another machine without drama.
> 
> Any suggestions? Please cc: me.


Two things:
a.  Can you try a recent/current kernel to see if this happens?
b.  The "Tainted: GF" means that a module was forcibly loaded.
What module was this?  and is it compatible with a 2.6.16.38 kernel?
Can you reproduce this problem without having that module loaded?


> Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
> [<ffffffff8048df80>]
> PGD 297f8067 PUD 26c5c067 PMD 0
> Oops: 0002 [1] SMP
> CPU 0
> Modules linked in: lirc_serial lirc_dev saa7134_alsa tuner saa7134 skge
> video_buf compat_ioctl32 v4l2_common v4l1_compat ir_kbd_i2c ehci_hcd
> ohci_hcd ir_common pcspkr videodev psmouse evdev
> Pid: 1343, comm: thumbnails Tainted: GF     2.6.16.38 #1
> RIP: 0010:[<ffffffff8048df80>] [<ffffffff8048df80>]
> RSP: 0018:ffff81001d53be70  EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 000000000000000d RCX: 0000000000000000
> RDX: 000000000000000d RSI: ffff8100327db000 RDI: ffff810031b40feb
> RBP: ffff810001adf600 R08: 0000000000000000 R09: 00000000000019b6
> R10: 0000000000000000 R11: 0000000000000001 R12: 000000000000000d
> R13: 000000000001ffeb R14: ffff81003ec5dfc8 R15: ffff81003ec5de00
> FS:  00002aba9d14f6d0(0000) GS:ffffffff8054c000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000003096000 CR4: 00000000000006e0
> Process thumbnails (pid: 1343, threadinfo ffff81001d53a000, task
> ffff81003f797890)
> Stack: ffffffff8016ee92 000000003dcee118 0000000000000000 ffff810031b40000
>        ffff8100327db000 00000001005e4d88 ffff810000000000 ffff81003ec5de00
>        0000000000000080 ffff8100327db000
> Call Trace: <ffffffff8016ee92>{copy_strings+359}
> <ffffffff8016ef11>{copy_strings_kernel+42}
>        <ffffffff80170e4e>{do_execve+302} <ffffffff80109611>{sys_execve+54}
>        <ffffffff8010acef>{stub_execve+103}
> 
> Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> RIP [<ffffffff8048df80>] RSP <ffff81001d53be70>
> CR2: 0000000000000000
>  <1>Unable to handle kernel NULL pointer dereference at 0000000000000000
> RIP:
> [<ffffffff8048df80>]
> PGD 153ed067 PUD 104ef067 PMD 0
> Oops: 0002 [2] SMP
> CPU 0
> Modules linked in: lirc_serial lirc_dev saa7134_alsa tuner saa7134 skge
> video_buf compat_ioctl32 v4l2_common v4l1_compat ir_kbd_i2c ehci_hcd
> ohci_hcd ir_common pcspkr videodev psmouse evdev
> Pid: 1346, comm: thumbnails Tainted: GF     2.6.16.38 #1
> RIP: 0010:[<ffffffff8048df80>] [<ffffffff8048df80>]
> RSP: 0018:ffff81001e2b1e70  EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 000000000000000d RCX: 0000000000000000
> RDX: 000000000000000d RSI: ffff810035a1d000 RDI: ffff810006d85feb
> RBP: ffff81000117f518 R08: 0000000000000000 R09: 00000000000019b0
> R10: 0000000000000000 R11: 0000000000000001 R12: 000000000000000d
> R13: 000000000001ffeb R14: ffff81003e032bc8 R15: ffff81003e032a00
> FS:  00002aba9d14f6d0(0000) GS:ffffffff8054c000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000011203000 CR4: 00000000000006e0
> Process thumbnails (pid: 1346, threadinfo ffff81001e2b0000, task
> ffff81003f7089b0)
> Stack: ffffffff8016ee92 000000003dcee118 0000000000000000 ffff810006d85000
>        ffff810035a1d000 00000001005e4c88 ffff810000000000 ffff81003e032a00
>        0000000000000080 ffff810035a1d000
> Call Trace: <ffffffff8016ee92>{copy_strings+359}
> <ffffffff8016ef11>{copy_strings_kernel+42}
>        <ffffffff80170e4e>{do_execve+302} <ffffffff80109611>{sys_execve+54}
>        <ffffffff8010acef>{stub_execve+103}
> 
> Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> RIP [<ffffffff8048df80>] RSP <ffff81001e2b1e70>
> CR2: 0000000000000000
>  <1>Unable to handle kernel NULL pointer dereference at 0000000000000000
> RIP:
> [<ffffffff8048df80>]
> PGD 15158067 PUD 2081d067 PMD 0
> Oops: 0002 [3] SMP
> CPU 0
> Modules linked in: lirc_serial lirc_dev saa7134_alsa tuner saa7134 skge
> video_buf compat_ioctl32 v4l2_common v4l1_compat ir_kbd_i2c ehci_hcd
> ohci_hcd ir_common pcspkr videodev psmouse evdev
> Pid: 1349, comm: thumbnails Tainted: GF     2.6.16.38 #1
> RIP: 0010:[<ffffffff8048df80>] [<ffffffff8048df80>]
> RSP: 0018:ffff81002e56de70  EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 000000000000000d RCX: 0000000000000000
> RDX: 000000000000000d RSI: ffff810033533000 RDI: ffff810008abcfeb
> RBP: ffff8100011e5920 R08: 0000000000000000 R09: 00000000000019aa
> R10: 0000000000000000 R11: 0000000000000001 R12: 000000000000000d
> R13: 000000000001ffeb R14: ffff81003e5b23c8 R15: ffff81003e5b2200
> FS:  00002aba9d14f6d0(0000) GS:ffffffff8054c000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 000000003ce1f000 CR4: 00000000000006e0
> Process thumbnails (pid: 1349, threadinfo ffff81002e56c000, task
> ffff810014494240)
> Stack: ffffffff8016ee92 000000003dcee118 0000000000000000 ffff810008abc000
>        ffff810033533000 00000001005e4b88 ffff810000000000 ffff81003e5b2200
>        0000000000000080 ffff810033533000
> Call Trace: <ffffffff8016ee92>{copy_strings+359}
> <ffffffff8016ef11>{copy_strings_kernel+42}
>        <ffffffff80170e4e>{do_execve+302} <ffffffff80109611>{sys_execve+54}
>        <ffffffff8010acef>{stub_execve+103}
> 
> Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> RIP [<ffffffff8048df80>] RSP <ffff81002e56de70>
> CR2: 0000000000000000
> 
> Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> RIP [<ffffffff8048df80>] RSP <ffff810012921e70>
> CR2: 0000000000000000
>  <1>Unable to handle kernel NULL pointer dereference at 0000000000000000
> RIP:
> [<ffffffff8048df80>]
> PGD 3d82c067 PUD 328ae067 PMD 0
> Oops: 0002 [5] SMP
> CPU 1
> Modules linked in: lirc_serial lirc_dev saa7134_alsa tuner saa7134 skge
> video_buf compat_ioctl32 v4l2_common v4l1_compat ir_kbd_i2c ehci_hcd
> ohci_hcd ir_common pcspkr videodev psmouse evdev
> Pid: 29115, comm: thumbnails Tainted: GF     2.6.16.38 #1
> RIP: 0010:[<ffffffff8048df80>] [<ffffffff8048df80>]
> RSP: 0018:ffff810027397e70  EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 000000000000000d RCX: 0000000000000000
> RDX: 000000000000000d RSI: ffff810009847000 RDI: ffff81001ed3efeb
> RBP: ffff8100016be590 R08: 0000000000000000 R09: 0000000000000ddd
> R10: 0000000000000000 R11: 0000000000000001 R12: 000000000000000d
> R13: 000000000001ffeb R14: ffff81003e03c1c8 R15: ffff81003e03c000
> FS:  00002aba9d14f6d0(0000) GS:ffff810001fc5ac0(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 000000000a43d000 CR4: 00000000000006e0
> Process thumbnails (pid: 29115, threadinfo ffff810027396000, task
> ffff81001d0a3510)
> Stack: ffffffff8016ee92 000000003dcee118 0000000000000000 ffff81001ed3e000
>        ffff810009847000 00000001005ebd88 ffff810000000000 ffff81003e03c000
>        0000000000000080 ffff810009847000
> Call Trace: <ffffffff8016ee92>{copy_strings+359}
> <ffffffff8016ef11>{copy_strings_kernel+42}
>        <ffffffff80170e4e>{do_execve+302} <ffffffff80109611>{sys_execve+54}
>        <ffffffff8010acef>{stub_execve+103}
> 
> Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> RIP [<ffffffff8048df80>] RSP <ffff810027397e70>
> CR2: 0000000000000000

---
~Randy
