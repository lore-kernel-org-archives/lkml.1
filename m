Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbZLVSuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbZLVSuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 13:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbZLVSuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 13:50:16 -0500
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:58863 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbZLVSuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 13:50:15 -0500
Date: Tue, 22 Dec 2009 13:50:11 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: sky2 panic in 2.6.32.1 under load
In-reply-to: <4B300E30.9090707@majjas.com>
To: "Berck E. Nash" <flyboy@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <4B3114E3.1070602@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <4B300A2A.8040305@gmail.com> <4B300E30.9090707@majjas.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.5)
 Gecko/20091204 Thunderbird/3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I updated my firmware (Marvell/Yukon)) from .12 to .14. Going to leave 
my kernel version unchanged for the next week or so and see if this recurs.
On 12/21/2009 7:09 PM, Michael Breuer wrote:
> Just an FYI - I got one of these today as well - also 2.6.32 (last git 
> before 2.6.33 rc1). I also had two similar events previously - one 
> 2.6.31, and one 2.6.32 rc7.
>
> I was doing some research today and came across a fair sampling of 
> error reports all suggesting that new firmware is a solution. Gigabyte 
> (not my MB) has firmware posted, but I haven't yet attempted to apply 
> it (nor am I sure how to test it after doing so).
>
> For what it's worth, my three recent events were heavy smb usage - 
> windows system backing up. Today's event did not generate an oops as 
> my watchdog kicked in and rebooted the system after the kernel 
> reported a sky2 error.
>
> The last messages before watchdog:
> Dec 20 05:33:58 mail kernel: DRHD: handling fault status reg 2
> Dec 20 05:33:58 mail kernel: DMAR:[DMA Read] Request device [06:00.0] 
> fault addr ffe1a7ffe000
> Dec 20 05:33:58 mail kernel: DMAR:[fault reason 06] PTE Read access is 
> not set
> Dec 20 05:33:58 mail kernel: sky2 0000:06:00.0: error interrupt 
> status=0x80000000
> Dec 20 05:33:58 mail kernel: sky2 0000:06:00.0: PCI hardware error 
> (0x2010)
>
> During the previous event I had vt-d disabled - it was enabled this time.
>
>
> On 12/21/2009 6:52 PM, Berck E. Nash wrote:
>> Since 2.6.32, I've been getting kernel panics under heavy network load
>> (bittorrent usage).
>>
>> [ 8673.345873] sky2 eth0: receiver hang detected
>> [ 8673.350368] sky2 eth0: disabling interface
>> [ 8673.354749] BUG: unable to handle kernel NULL pointer dereference at
>> 0000000000000010
>> [ 8673.359748] IP: [<ffffffffa00373d3>] sky2_xmit_frame+0x321/0x5d8 
>> [sky2]
>> [ 8673.364675] PGD a09a6067 PUD a09a5067 PMD 0
>> [ 8673.373838] Oops: 0002 [#1] SMP
>> [ 8673.373838] last sysfs file: 
>> /sys/devices/platform/coretemp.1/temp1_label
>> [ 8673.383900] CPU 0
>> [ 8673.383900] Modules linked in: nfsd exportfs nfs lockd nfs_acl
>> auth_rpcgss sunrpc nls_cp437 msdos fat kvm_intel kvm fuse snd_rtctimer
>> hwmon_vid nvidia(P) usbhid tuner_simple tuner_types wm8775 tda9887
>> snd_hda_codec_realtek tda8290 snd_hda_intel tuner snd_hda_codec
>> snd_pcm_oss snd_mixer_oss snd_pcm cx25840 snd_seq_dummy snd_seq_oss
>> snd_seq_midi_event ivtv snd_seq i2c_algo_bit cx2341x v4l2_common
>> snd_timer videodev uhci_hcd snd_seq_device v4l1_compat ehci_hcd snd
>> v4l2_compat_ioctl32 i2c_i801 soundcore snd_page_alloc floppy sky2
>> usbcore tveeprom
>> [ 8673.435268] Pid: 4, comm: ksoftirqd/0 Tainted: P           2.6.32.1
>> #3 P5W DH Deluxe
>> [ 8673.438943] RIP: 0010:[<ffffffffa00373d3>]  [<ffffffffa00373d3>]
>> sky2_xmit_frame+0x321/0x5d8 [sky2]
>> [ 8673.448539] RSP: 0018:ffff880001603df8  EFLAGS: 00010246
>> [ 8673.458678] RAX: 0000000000000000 RBX: ffff8800bd201d40 RCX:
>> 0000000000000000
>> [ 8673.465016] RDX: 0000000000000000 RSI: 000000000000008c RDI:
>> 0000000000000000
>> [ 8673.472396] RBP: ffff880001603e48 R08: 0000000000000001 R09:
>> 0000000000000000
>> [ 8673.474083] R10: 000000000000001e R11: 0000000000000ef8 R12:
>> ffff88009bf3ab48
>> [ 8673.484317] R13: ffff8800bef4d000 R14: 0000000000000000 R15:
>> 00000000955fa87e
>> [ 8673.492381] FS:  0000000000000000(0000) GS:ffff880001600000(0000)
>> knlGS:0000000000000000
>> [ 8673.501448] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>> [ 8673.509707] CR2: 0000000000000010 CR3: 00000000a09bf000 CR4:
>> 00000000000026f0
>> [ 8673.514146] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> 0000000000000000
>> [ 8673.520661] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>> 0000000000000400
>> [ 8673.528842] Process ksoftirqd/0 (pid: 4, threadinfo ffff8800bf8b4000,
>> task ffff8800bf8a8650)
>> [ 8673.539212] Stack:
>> [ 8673.539212]  ffff8800992f5980 ffff8800955fa87e ffff8800bd201800
>> 000000428122a659
>> [ 8673.548658]<0>  ffff880001603e48 ffff88009bf3ab48 ffff8800992f5980
>> ffffffff813eaf30
>> [ 8673.556929]<0>  ffff8800bd201800 ffff8800bef03940 ffff880001603e98
>> ffffffff81231de8
>> [ 8673.565432] Call Trace:
>> [ 8673.565432]<IRQ>
>> [ 8673.565432]  [<ffffffff81231de8>] dev_hard_start_xmit+0x21c/0x2b7
>> [ 8673.574516]  [<ffffffff81041746>] ? run_timer_softirq+0x4f/0x1c9
>> [ 8673.579515]  [<ffffffff81240252>] sch_direct_xmit+0x5e/0x154
>> [ 8673.584559]  [<ffffffff81240404>] __qdisc_run+0xbc/0xd5
>> [ 8673.592673]  [<ffffffff8122fb19>] net_tx_action+0xbb/0x10e
>> [ 8673.598719]  [<ffffffff8103dc16>] __do_softirq+0x91/0x11b
>> [ 8673.601787]  [<ffffffff8100be9c>] call_softirq+0x1c/0x28
>> [ 8673.609833]<EOI>
>> [ 8673.610994]  [<ffffffff8100d907>] do_softirq+0x33/0x6b
>> [ 8673.614419]  [<ffffffff8103d71e>] ksoftirqd+0x60/0xd7
>> [ 8673.620082]  [<ffffffff8103d6be>] ? ksoftirqd+0x0/0xd7
>> [ 8673.620082]  [<ffffffff8104aee7>] kthread+0x7a/0x82
>> [ 8673.629310]  [<ffffffff8100bd9a>] child_rip+0xa/0x20
>> [ 8673.634137]  [<ffffffff8104ae6d>] ? kthread+0x0/0x82
>> [ 8673.639492]  [<ffffffff8100bd90>] ? child_rip+0x0/0x20
>> [ 8673.647639] Code: 06 00 00 00 00 89 08 66 c7 40 04 00 00 c6 40 06 01
>> c6 40 07 9f 41 0f b7 c6 48 89 c7 48 c1 e0 03 48 c1 e7 05 48 89 f9 48 03
>> 4b 20<4c>  89 79 10 48 c7 41 08 01 00 00 00 8b 75 cc 89 71 18 48 03 7b
>> [ 8673.667726] RIP  [<ffffffffa00373d3>] sky2_xmit_frame+0x321/0x5d8 
>> [sky2]
>> [ 8673.674902]  RSP<ffff880001603df8>
>> [ 8673.674902] CR2: 0000000000000010
>> [ 8673.682956] hda-intel: IRQ timing workaround is activated for card
>> #0. Suggest a bigger bdl_pos_adj.
>> [ 8673.683015] ---[ end trace 2c387977cf1c7c9a ]---
>> [ 8673.683017] Kernel panic - not syncing: Fatal exception in interrupt
>> [ 8673.683020] Pid: 4, comm: ksoftirqd/0 Tainted: P      D    
>> 2.6.32.1 #3
>> [ 8673.683021] Call Trace:
>> [ 8673.683023]<IRQ>   [<ffffffff8129839d>] panic+0x75/0x11c
>> [ 8673.683030]  [<ffffffff8100e9a7>] oops_end+0x81/0x8e
>> [ 8673.683033]  [<ffffffff81026e5f>] no_context+0x1ee/0x1fd
>> [ 8673.683036]  [<ffffffff81032a6d>] ? find_busiest_group+0x387/0x8d8
>> [ 8673.683039]  [<ffffffff81026fe0>] __bad_area_nosemaphore+0x172/0x195
>> [ 8673.683041]  [<ffffffff81027011>] bad_area_nosemaphore+0xe/0x10
>> [ 8673.683044]  [<ffffffff8102724b>] do_page_fault+0x114/0x252
>> [ 8673.683047]  [<ffffffff8129a97f>] page_fault+0x1f/0x30
>> [ 8673.683054]  [<ffffffffa00373d3>] ? sky2_xmit_frame+0x321/0x5d8 
>> [sky2]
>> [ 8673.683058]  [<ffffffffa00371b8>] ? sky2_xmit_frame+0x106/0x5d8 
>> [sky2]
>> [ 8673.683061]  [<ffffffff81231de8>] dev_hard_start_xmit+0x21c/0x2b7
>> [ 8673.683065]  [<ffffffff81041746>] ? run_timer_softirq+0x4f/0x1c9
>> [ 8673.683067]  [<ffffffff81240252>] sch_direct_xmit+0x5e/0x154
>> [ 8673.683070]  [<ffffffff81240404>] __qdisc_run+0xbc/0xd5
>> [ 8673.683072]  [<ffffffff8122fb19>] net_tx_action+0xbb/0x10e
>> [ 8673.683075]  [<ffffffff8103dc16>] __do_softirq+0x91/0x11b
>> [ 8673.683078]  [<ffffffff8100be9c>] call_softirq+0x1c/0x28
>> [ 8673.683079]<EOI>   [<ffffffff8100d907>] do_softirq+0x33/0x6b
>> [ 8673.683083]  [<ffffffff8103d71e>] ksoftirqd+0x60/0xd7
>> [ 8673.683085]  [<ffffffff8103d6be>] ? ksoftirqd+0x0/0xd7
>> [ 8673.683088]  [<ffffffff8104aee7>] kthread+0x7a/0x82
>> [ 8673.683090]  [<ffffffff8100bd9a>] child_rip+0xa/0x20
>> [ 8673.683093]  [<ffffffff8104ae6d>] ? kthread+0x0/0x82
>> [ 8673.683095]  [<ffffffff8100bd90>] ? child_rip+0x0/0x20
>>
>> Note that sometimes I get the receiver hang and things continue without
>> the crash:
>>
>> [ 1219.346571] sky2 eth0: receiver hang detected
>> [ 1219.351145] sky2 eth0: disabling interface
>> [ 1219.357389] sky2 eth0: enabling interface
>> [ 1222.572980] sky2 eth0: Link is up at 1000 Mbps, full duplex, flow
>> control both
>>
>> Please CC as I'm not subscribed.
>>
>> Thanks,
>> Berck Nash
>> -- 
>> To unsubscribe from this list

