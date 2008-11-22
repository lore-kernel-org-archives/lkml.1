Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbYKVUme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbYKVUme (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 15:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYKVUmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 15:42:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37447 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbYKVUmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 15:42:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sascha Biberhofer <biberhofer@inode.at>
Subject: Re: [2.6.27.5] kernel panic (unable to handle paging request)
Date: Sat, 22 Nov 2008 21:41:38 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20081120160023.GA1019@aeris>
In-Reply-To: <20081120160023.GA1019@aeris>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811222141.39338.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(-stable regression, CCs added)

On Thursday, 20 of November 2008, Sascha Biberhofer wrote:
> When running 2.6.27.5 I'm experiencing kernel panics after some random
> amount of time. I'm not quite sure what triggers them, the first time it
> happened after 5 days uptime, the second time after 1 day, always doing
> the same random stuff. I've copied the Oops message from screen by hand 
> (at least the readable part of it):
> 
>   [<c03c7339>] schedule+0x149/0x270
>   [<c02f8967>] sys_send+0x37/0x40
>   [<c02f9aa8>] sys_socketcall+0x1d8/0x2c0
>   [<c0221c60>] copy_to_user+0x30/0x60
>   [<c0102f01>] sysenter_do_call+0x12/0x25
> 
> Code: 24 10 89 d6 89 5c 24 08 89 6c 24 14 89 c7 8b 4c 24 18 9c 5b fa 8b
> 90 80 00 00 00 8b a8 90 00 00 00 85 d2 74 35 8b 80 8c 00 00 00 <8b> 04
> 82 89 87 80 00 00 00 53 9d 31 c0 c1 ee 0f 85 d2 0f 95 c0
> 
> EIP: [<c015a6b4>] kmem_cache_alloc+0x34/0xa0 SS:ESP 0068:d7013a00
> ---[ end trace 629cc3bb84dd2447 ]---
> 
> Fixing recursive fault but reboot is needed!
> BUG: unable to handle kernel paging request at ff9f9042
> IP: [<c015b525>] __kmalloc_track_caller+0x45/0xf0
> *pde=00000000
> Oops: 0000 [#3]
> Pid: 0, comm: swapper Tainted: G     D  (2.6.27.5 #0)
> EIP: 0060:[<c015b525>] EFLAGS: 00010086 CPU: 0
> EIP is at __kmalloc_track_caller+0x45/0xf0
> EAX: 00000000 EBX: 00000286 ECX: 0000000b EDX: ff9f9042
> ESI: 00000020 EDI: c0498fde EBP: 00000800 ESP: c04a1ea0
>  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> Process swapper (pid: 0, ti=c04a0000 task=c0470300 task.ti=c04a0000)
> Stack: 00000282 df8849c0 c02fed79 df89f3c0 00000680 00000020 c0498aa8
>        c02fea05 00000000 8000061c df823360 df823360 0000003c c02fed79
>        ffffffff c027204e 00000000 df9520f8 8000061c df8849c0 df823360
>        0000003c c02731a3 d5c8df60
> 
> Call Trace:
>   [<c02fed79>] dev_alloc_skb+0x19/0x30
>   [<c02fea05>] __alloc_skb+0x55/0x120
>   [<c02fed79>] dev_alloc_skb+0x19/0x30
>   [<c027204e>] nv_alloc_rx+0x3e/0x170
>   [<c02731a3>] nv_napi_poll+0x403/0x603
>   [<c030596f>] net_rx_action+0x5f/0xf0
>   [<c011fe22>] __do_softirq+0x42/0x90
>   [<c011fe97>] do_doftirq+0x27/0x30
>   [<c0120185>] irq_exit+0x45/0x60
>   [<c010f0d0>] smp_apic_timer_interrupt+0x40/0x80
>   [<c01038fc>] apic_timer_interrupt+0x28/0x30
>   [<c0118f61>] finish_task_switch+0x21/0x70
>   [<c03c7339>] schedule+0x149/0x270
>   [<c0134f7d>] tick_nohz_restart_sched_tick+0xd/0x150
>   [<c0101b27>] cpu_idle+0x67/0x70
> 
> Code: 89 4c 24 08 77 70 e8 f2 ff ff 89 c7 83 ff 10 76 34 9c 5b fa 8b 97
> 80 00 00 00 8b af 90 00 00 00 85 d2 74 8b 87 8c 00 00 00 <8b> 04 82 89
> 87 80 00 00 00 53 9d 31 c0 cd ee 0f 85 d2 0f 95 c0
> 
> EIP: [<c015b525>] __kmalloc_track_caller+0x45/0xf0 SS:ESP 0068:c04a1ea0
> Kernel panic - not syncing: Fatal exception in interrupt.
> 
> 
> It looks like many things are going wrong at once.
> I'm now back running 2.6.27.4 which is and has been runing fine. 
> The machine itself is an AMD Athlon XP 2000+ with an ASUS A7N8X (having
> an nfroce2 chipset) with 512 MB RAM and some Geforce TI 4800 iirc. 
> Any help with this issue is really appreciated. 
> 
> greetings
>  Sascha Biberhofer
