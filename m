Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbXBEGMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbXBEGMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 01:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbXBEGMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 01:12:18 -0500
Received: from smtp-5.smtp.ucla.edu ([169.232.47.137]:49197 "EHLO
	smtp-5.smtp.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbXBEGMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 01:12:17 -0500
Message-ID: <45C6CA72.6020206@cogweb.net>
Date: Sun, 04 Feb 2007 22:10:58 -0800
From: David Liontooth <liontooth@cogweb.net>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Eeek! page_mapcount(page) went negative! (-1)
References: <45C698D1.1070208@cogweb.net>	<45C6B71E.9050805@cogweb.net> <20070204211705.8cd3203b.randy.dunlap@oracle.com>
In-Reply-To: <20070204211705.8cd3203b.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Probable-Spam: no
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Sun, 04 Feb 2007 20:48:30 -0800 David Liontooth wrote:
>
>   
>> David Liontooth wrote:
>>     
>>> Running a script called thumbnails, which uses imagemagick's convert
>>> utility, I got this on a mainline 2.6.16.38:
>>>
>>> Feb  4 17:04:01 prato /USR/SBIN/CRON[17173]: (tna) CMD (thumbnails
>>> /db2/2006/2006-11/2006-11-16)
>>>
>>> Feb  4 17:20:49 prato kernel: swap_free: Unused swap offset entry 00000080
>>> Feb  4 17:20:49 prato kernel: convert[23078]: segfault at
>>> 0000000000008000 rip 00002b885c7d6590 rsp 00007fffffa49308 error 4
>>> Feb  4 17:20:50 prato kernel: convert[23113]: segfault at
>>> 0000000000008010 rip 00002b0914f305aa rsp 00007fffff984340 error 4
>>>
>>> Feb  4 17:50:57 prato kernel: swap_free: Unused swap offset entry 00000080
>>> Feb  4 17:50:57 prato kernel: swap_free: Unused swap offset entry 00000080
>>> Feb  4 17:50:57 prato kernel: Eeek! page_mapcount(page) went negative! (-1)
>>> Feb  4 17:50:57 prato kernel:   page->flags = 10000000000083c
>>> Feb  4 17:50:57 prato kernel:   page->count = 2
>>> Feb  4 17:50:57 prato kernel:   page->mapping = ffff81002604c670
>>> Feb  4 17:50:57 prato kernel: ----------- [cut here ] --------- [please
>>> bite here ] ---------
>>> Feb  4 17:50:57 prato kernel: Kernel BUG at mm/rmap.c:560
>>> Feb  4 17:50:57 prato kernel: invalid opcode: 0000 [1] SMP
>>> Feb  4 17:50:57 prato kernel: CPU 1
>>> Feb 4 17:50:57 prato kernel: Modules linked in: lirc_serial lirc_dev
>>> saa7134_alsa tuner saa7134 video_buf compat_ioctl32 v4l2_common v4l1_compat
>>> ir_kbd_i2c ir_common videodev skge ehci_hcd ohci_hcd psmouse pcspkr evdev
>>> Feb  4 17:50:57 prato kernel: Pid: 29168, comm: thumbnails Tainted:
>>> GF     2.6.16.38 #1
>>> Feb  4 17:50:57 prato kernel: RIP: 0010:[<ffffffff801581f0>]
>>> <ffffffff801581f0>{page_remove_rmap+117}
>>> Feb  4 17:50:57 prato kernel: RSP: 0018:ffff81000bc6dde8  EFLAGS: 00010286
>>> Feb  4 17:50:57 prato kernel: RAX: 00000000ffffffff RBX:
>>> ffff810001d1b290 RCX: 0000000000006507
>>> Feb  4 17:50:57 prato kernel: RDX: 00000000ffffff01 RSI:
>>> 0000000000000292 RDI: ffffffff80465dfc
>>> Feb  4 17:50:57 prato kernel: RBP: 000000003be9e000 R08:
>>> 0000000000000000 R09: 0000000000000001
>>> Feb  4 17:50:57 prato kernel: R10: 0000000000000010 R11:
>>> 0000000000000000 R12: 000000000062f000
>>> Feb  4 17:50:57 prato kernel: R13: ffff810015ed7178 R14:
>>> 00000000006d6000 R15: ffff810001e12220
>>> Feb  4 17:50:57 prato kernel: FS:  00002b444df8a6d0(0000)
>>> GS:ffff810001fc5ac0(0000) knlGS:0000000000000000
>>> Feb  4 17:50:57 prato kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>>> 000000008005003b
>>> Feb  4 17:50:57 prato kernel: CR2: 00002b444ddb61f0 CR3:
>>> 0000000013f22000 CR4: 00000000000006e0
>>> Feb  4 17:50:57 prato kernel: Process thumbnails (pid: 29168, threadinfo
>>> ffff81000bc6c000, task ffff81003fe25160)
>>> Feb  4 17:50:57 prato kernel: Stack: ffff810001d1b290 ffffffff801519da
>>> 0000000000000000 ffff81000bc6dec8
>>> Feb  4 17:50:57 prato kernel:        ffffffffffffffff 0000000000000000
>>> ffff81002955d648 ffff81000bc6ded0
>>> Feb  4 17:50:57 prato kernel:        0000000000000000 000000012cf477b8
>>> Feb  4 17:50:57 prato kernel: Call Trace:
>>> <ffffffff801519da>{unmap_vmas+1012} <ffffffff80154a7d>{exit_mmap+120}
>>> Feb  4 17:50:57 prato kernel:        <ffffffff80126c7d>{mmput+40}
>>> <ffffffff8012bb38>{do_exit+489}
>>> Feb  4 17:50:57 prato kernel:       
>>> <ffffffff8012c217>{sys_exit_group+0} <ffffffff8010a936>{system_call+126}
>>> Feb  4 17:50:57 prato kernel:
>>> Feb  4 17:50:57 prato kernel: Code: 0f 0b 68 f8 21 40 80 c2 30 02 5b 48
>>> 83 ce ff bf 20 00 00 00
>>> Feb  4 17:50:57 prato kernel: RIP
>>> <ffffffff801581f0>{page_remove_rmap+117} RSP <ffff81000bc6dde8>
>>> Feb  4 17:50:57 prato kernel:  <1>Fixing recursive fault but reboot is
>>> needed!
>>> Feb  4 17:52:52 prato kernel: Bad page state in process 'kswapd0'
>>> Feb  4 17:52:52 prato kernel: page:ffff810001d1b290
>>> flags:0x0100000000000008 mapping:0000000000000000 mapcount:-1 count:0
>>> Feb  4 17:52:52 prato kernel: Trying to fix it up, but a reboot is needed
>>> Feb  4 17:52:52 prato kernel: Backtrace:
>>> Feb  4 17:52:52 prato kernel:
>>> Feb  4 17:52:52 prato kernel: Call Trace:
>>> <ffffffff80149d38>{bad_page+80} <ffffffff8014a0f3>{free_hot_cold_page+116}
>>> Feb  4 17:52:52 prato kernel:       
>>> <ffffffff8014a19a>{__pagevec_free+33}
>>> <ffffffff8014cfc6>{__pagevec_release_nonlru+122}
>>> Feb  4 17:52:52 prato kernel:       
>>> <ffffffff8014e341>{shrink_zone+2280} <ffffffff8014ec9d>{balance_pgdat+527}
>>> Feb  4 17:52:52 prato kernel:        <ffffffff8014f21c>{kswapd+265}
>>> <ffffffff8013ae86>{autoremove_wake_function+0}
>>> Feb  4 17:52:52 prato kernel:        <ffffffff8010b782>{child_rip+8}
>>> <ffffffff8014f113>{kswapd+0}
>>> Feb  4 17:52:52 prato kernel:        <ffffffff8010b77a>{child_rip+0}
>>>
>>> lspci
>>>
>>> 00:00.0 Host bridge: nVidia Corporation nForce3 250Gb Host Bridge (rev a1)
>>> 00:01.0 ISA bridge: nVidia Corporation nForce3 250Gb LPC Bridge (rev a2)
>>> 00:01.1 SMBus: nVidia Corporation nForce 250Gb PCI System Management
>>> (rev a1)
>>> 00:02.0 USB Controller: nVidia Corporation CK8S USB Controller (rev a1)
>>> 00:02.1 USB Controller: nVidia Corporation CK8S USB Controller (rev a1)
>>> 00:02.2 USB Controller: nVidia Corporation nForce3 EHCI USB 2.0
>>> Controller (rev a2)
>>> 00:06.0 Multimedia audio controller: nVidia Corporation nForce3 250Gb
>>> AC'97 Audio Controller (rev a1)
>>> 00:08.0 IDE interface: nVidia Corporation CK8S Parallel ATA Controller
>>> (v2.5) (rev a2)
>>> 00:0a.0 IDE interface: nVidia Corporation CK8S Serial ATA Controller
>>> (v2.5) (rev a2)
>>> 00:0b.0 PCI bridge: nVidia Corporation nForce3 250Gb AGP Host to PCI
>>> Bridge (rev a2)
>>> 00:0e.0 PCI bridge: nVidia Corporation nForce3 250Gb PCI-to-PCI Bridge
>>> (rev a2)
>>> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
>>> HyperTransport Technology Configuration
>>> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
>>> Address Map
>>> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
>>> DRAM Controller
>>> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
>>> Miscellaneous Control
>>> 01:00.0 VGA compatible controller: nVidia Corporation NV18 [GeForce4 MX
>>> 4000 AGP 8x] (rev c1)
>>> 02:06.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
>>> Video Broadcast Decoder (rev 10)
>>> 02:07.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
>>> Video Broadcast Decoder (rev 10)
>>> 02:08.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
>>> Video Broadcast Decoder (rev 10)
>>> 02:09.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
>>> Video Broadcast Decoder (rev 10)
>>> 02:0a.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
>>> Video Broadcast Decoder (rev 10)
>>> 02:0b.0 Ethernet controller: Marvell Technology Group Ltd. 88E8001
>>> Gigabit Ethernet Controller (rev 13)
>>>
>>> Let me know if more information would be useful, such as the kernel
>>> .config file.
>>>
>>>   
>>>       
>> More from the same machine -- it really doesn't like the script, which
>> simply does:
>>
>> nice -n 19 transcode -q 0 -o $FIL.img/$FIL.img -y im -F png -x
>> ffmpeg,null -i $FIL.avi -c \
>> 0:00:00-0:00:00.1,0:00:10-0:00:10.1,0:00:20-0:00:20.1,0:00:30-0:00:30.1,0:00:40-0:00:40.1,0:00:50-0:00:50.1,\
>> 0:01:00-0:01:00.1,0:01:10-0:01:10.1,0:01:20-0:01:20.1,0:01:30-0:01:30.1,0:01:40-0:01:40.1,0:01:50-0:01:50.1
>>
>> nice -n 19 convert -thumbnail 80x60 $IMG.png $THUMBS/$IMG.jpg
>>
>> nice -n 19 montage -tile 15 -geometry +1,+1 $FIL.img/$THUMBS/*.jpg $FIL.jpg
>>
>> I run the same script on another machine without drama.
>>
>> Any suggestions? Please cc: me.
>>     
>
>
> Two things:
> a.  Can you try a recent/current kernel to see if this happens?
> b.  The "Tainted: GF" means that a module was forcibly loaded.
> What module was this?  and is it compatible with a 2.6.16.38 kernel?
> Can you reproduce this problem without having that module loaded?
>   
Randy, thanks for responding. I discovered that the files the script was
operating on were corrupt, so let me see if it recurs with healthy files.

It's the lirc module that generates the GF flag --

    lirc_serial: no version for "lirc_unregister_plugin" found: kernel
tainted.

So it's not actually forced. I'll remove it if this problem recurs.

I've tried 2.6.18 and 2.6.19 on this box, and they are moderately stable
if I use acpi_use_timer_override. It's a production machine, so I can't
experiment much.

Dave


>
> ---
> ~Randy
>   

