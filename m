Return-Path: <linux-kernel-owner+w=401wt.eu-S1760618AbYEEXIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618AbYEEXIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYEEXIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:08:21 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:22266 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYEEXIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:08:20 -0400
Message-ID: <481F935D.1040603@googlemail.com>
Date: Tue, 06 May 2008 01:08:13 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Prakash Punnoor <prakash@punnoor.de>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Jacek Luczak <difrost.kernel@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>, neilb@suse.de
Subject: Re: WARNING in 2.6.25-07422-gb66e1f1
References: <200805031151.44287.prakash@punnoor.de> <481DB3F3.5080102@gmail.com> <20080504183839.GN12774@kernel.dk> <200805051931.14116.prakash@punnoor.de>
In-Reply-To: <200805051931.14116.prakash@punnoor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 May 2008 23:01:21.0456 (UTC) FILETIME=[EF4C0B00:01C8AF03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prakash Punnoor wrote:
> On the day of Sunday 04 May 2008 Jens Axboe hast written:
>> On Sun, May 04 2008, Jacek Luczak wrote:
>>> Hi,
>>>
>>> I've CC:-ed few guys which may help.
>>>
>>> Prakash Punnoor pisze:
>>>> Hi, I got this on boot:
>>>>
>>>> usb 2-1.3: new full speed USB device using ehci_hcd and address 3
>>>> usb 2-1.3: configuration #1 chosen from 1 choice
>>>> Clocksource tsc unstable (delta = -117343945 ns)
>>>> ------------[ cut here ]------------
>>>> WARNING: at include/linux/blkdev.h:443 blk_remove_plug+0x7d/0x90()
>>>> Modules linked in: kvm_amd kvm powernow_k8 ehci_hcd ohci_hcd usbcore
>>>> forcedeth Pid: 1681, comm: fsck.ext3 Not tainted
>>>> 2.6.25-07422-gb66e1f1-dirty #74
>>>>
>>>> Call Trace:
>>>>  [<ffffffff80236354>] warn_on_slowpath+0x64/0xa0
>>>>  [<ffffffff803b6a04>] generic_make_request+0x194/0x250
>>>>  [<ffffffff803b82e7>] submit_bio+0x97/0x140
>>>>  [<ffffffff803b756d>] blk_remove_plug+0x7d/0x90
>>>>  [<ffffffff8049d4d4>] raid5_unplug_device+0x44/0x110
>>>>  [<ffffffff802666ce>] sync_page+0x2e/0x50
>>>>  [<ffffffff805a0985>] __wait_on_bit+0x65/0x90
>>>>  [<ffffffff802669c8>] wait_on_page_bit+0x78/0x80
>>>>  [<ffffffff8024bb70>] wake_bit_function+0x0/0x40
>>>>  [<ffffffff8026f1ba>] pagevec_lookup_tag+0x1a/0x30
>>>>  [<ffffffff80266fbd>] wait_on_page_writeback_range+0xbd/0x130
>>>>  [<ffffffff8026d5e0>] do_writepages+0x20/0x40
>>>>  [<ffffffff802670a2>] __filemap_fdatawrite_range+0x52/0x60
>>>>  [<ffffffff80267334>] filemap_write_and_wait+0x44/0x50
>>>>  [<ffffffff802bd968>] __blkdev_put+0x148/0x1b0
>>>>  [<ffffffff80293441>] __fput+0xb1/0x1c0
>>>>  [<ffffffff80290178>] filp_close+0x48/0x80
>>>>  [<ffffffff80291a1f>] sys_close+0x9f/0x110
>>>>  [<ffffffff8020c42b>] system_call_after_swapgs+0x7b/0x80
>>>>
>>>> ---[ end trace 94c0787a2e4d19eb ]---
> 
> [...]
>> Looks like it caught a real bug there - unfortunately we have to check
>> for ->queue_lock here as well, if this is another stacked devices and
>> not the bottom device. Does this make the warning go away for you?
> 
> Nope it does not. But I see some other comments have already been posted about 
> this issue...

Hmm I get a similar warning with raid1 also.

[  415.851920] kjournald starting.  Commit interval 5 seconds
[  416.282180] ------------[ cut here ]------------
[  416.282184] WARNING: at include/linux/blkdev.h:443 blk_remove_plug+0x51/0x84()
[  416.282186] Modules linked in: i915 drm fuse snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_seq_device loop usbhid ff_memless firewire_ohci firewire_core thermal shpchp uhci_hcd sr_mod pci_hotplug pata_acpi i2c_i801 ehci_hcd crc_itu_t button serio_raw processor i2c_core evdev
[  416.282241] Pid: 1118, comm: md0_raid1 Not tainted 2.6.26-rc1-00065-g5717922-dirty #824
[  416.282243]
[  416.282244] Call Trace:
[  416.282250]  [<ffffffff8022f035>] warn_on_slowpath+0x51/0x8c
[  416.282255]  [<ffffffff802299f5>] __wake_up+0x38/0x4f
[  416.282260]  [<ffffffff80243237>] enqueue_hrtimer+0xdd/0xea
[  416.282263]  [<ffffffff802fddc1>] blk_remove_plug+0x51/0x84
[  416.282267]  [<ffffffff803e8204>] flush_pending_writes+0x3b/0x84
[  416.282271]  [<ffffffff803e831d>] raid1d+0x4b/0xd97
[  416.282274]  [<ffffffff802a3e44>] sync_buffer+0x0/0x3f
[  416.282277]  [<ffffffff8022c01d>] hrtick_set+0x9d/0x106
[  416.282282]  [<ffffffff804bc8c9>] thread_return+0x68/0xbb
[  416.282288]  [<ffffffff804bcad6>] schedule_timeout+0x1e/0xc9
[  416.282292]  [<ffffffff803fb4d1>] md_thread+0xe4/0x102
[  416.282296]  [<ffffffff80240f6c>] autoremove_wake_function+0x0/0x2e
[  416.282300]  [<ffffffff803fb3ed>] md_thread+0x0/0x102
[  416.282303]  [<ffffffff80240c68>] kthread+0x47/0x73
[  416.282306]  [<ffffffff8022c93d>] schedule_tail+0x27/0x5b
[  416.282315]  [<ffffffff8020cd58>] child_rip+0xa/0x12
[  416.282319]  [<ffffffff80240c21>] kthread+0x0/0x73
[  416.282322]  [<ffffffff8020cd4e>] child_rip+0x0/0x12
[  416.282325]
[  416.282328] ---[ end trace 4873a8598d8bf786 ]---
[  416.282463] EXT3 FS on md0, internal journal


Is there any other patch to try out ?

Regards,

Gabriel C
