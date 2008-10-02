Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbYJBJzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbYJBJzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 05:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYJBJy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 05:54:58 -0400
Received: from mail.bigtelecom.ru ([87.255.0.61]:50058 "EHLO
	mail.bigtelecom.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYJBJy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:54:58 -0400
Message-ID: <48E49A6C.9020803@bigtelecom.ru>
Date: Thu, 02 Oct 2008 13:54:52 +0400
From: Badalian Vyacheslav <slavon@bigtelecom.ru>
User-Agent: Thunderbird 2.0.0.17 (X11/20080929)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: NMI Watchdog detected LOCKUP on CPU3
References: <48E4701A.4010508@bigtelecom.ru> <20081002015532.8f132247.akpm@linux-foundation.org>
In-Reply-To: <20081002015532.8f132247.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Hello All. Please help cassify bug to report to bugzilla it!
>>
>> Look to my sysctl:
>>
>> # sysctl -a | grep panic
>> kernel.panic = 3
>> kernel.panic_on_oops = 1
>> kernel.unknown_nmi_panic = 1
>> kernel.panic_on_unrecovered_nmi = 1
>> vm.panic_on_oom = 0
>> # sysctl -a | grep nmi
>> kernel.unknown_nmi_panic = 1
>> kernel.nmi_watchdog = 1
>> kernel.panic_on_unrecovered_nmi = 1
>>
>> # sysctl -a | grep rq
>> kernel.sysrq = 1
>>
>> But computer do not reboot and ALT+SysRQ+B don't work...
>>     
>
> Is it repeatable?
>
>   

We have 10 equal server what do Trafiic Shape (tc (htb, u32, sfq) and
iptables) only. Few of them halt one times in week.
Timer settings in config:
HZ=300
NO_HZ=n
HIGH_RES_TIMERS = n

>> This i get by netconsole and on the screen:
>>
>>
>> [ 2251.728719] BUG: NMI Watchdog detected LOCKUP on CPU3, ip c01fafd4,
>> registers:
>> [ 2251.728719] Modules linked in: netconsole i2c_i801 i2c_core e1000e e1000
>> [ 2251.728719]
>> [ 2251.728719] Pid: 0, comm: swapper Not tainted (2.6.26.5-fw #1)
>> [ 2251.728719] EIP: 0060:[<c01fafd4>] EFLAGS: 00000082 CPU: 3
>> [ 2251.728719] EIP is at rb_insert_color+0x24/0xc0
>> [ 2251.728719] EAX: f6c134a4 EBX: f6c134a4 ECX: f6c134a4 EDX: f6c134a4
>> [ 2251.728719] ESI: f6c134a4 EDI: f6c134a4 EBP: c202d0d4 ESP: f7c5fcac
>> [ 2251.728719]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> [ 2251.728719] Process swapper (pid: 0, ti=f7c5e000 task=f7c32940
>> task.ti=f7c5e000)
>> [ 2251.728719] Stack: f6c134a4 00000000 c202d0cc c202d0d4 c013a8ff
>> f6c134a4 c202d0cc c20230cc
>> [ 2251.728719]        c04450a0 c013adea 00000000 f7c5fcfc 392e7c00
>> 0000020c 00000001 00000286
>> [ 2251.728719]        f6c13000 ffffffff 00000000 00000000 c02d15fe
>> 00000000 f6c13000 c02d6da6
>> [ 2251.728719] Call Trace:
>> [ 2251.728719]  [<c013a8ff>] enqueue_hrtimer+0x5f/0x80
>> [ 2251.728719]  [<c013adea>] hrtimer_start+0xaa/0x130
>> [ 2251.728719]  [<c02d15fe>] qdisc_watchdog_schedule+0x1e/0x30
>> [ 2251.728719]  [<c02d6da6>] htb_dequeue+0x6a6/0x810
>> [ 2251.728719]  [<c02d047c>] __qdisc_run+0x19c/0x1d0
>> [ 2251.728719]  [<c02d71c0>] htb_enqueue+0x0/0x1e0
>> [ 2251.728719]  [<c02c4cb7>] dev_queue_xmit+0x267/0x380
>> [ 2251.728719]  [<c02e6040>] ip_forward_finish+0x0/0x40
>> [ 2251.728719]  [<c02e8bef>] ip_finish_output+0x11f/0x280
>> [ 2251.728719]  [<c02e630f>] ip_forward+0x28f/0x2d0
>> [ 2251.728719]  [<c02e6065>] ip_forward_finish+0x25/0x40
>> [ 2251.728719]  [<c02e4ba2>] ip_rcv_finish+0x122/0x360
>> [ 2251.728719]  [<c016d7e9>] add_partial+0x19/0x60
>> [ 2251.728719]  [<c016e8d9>] __slab_free+0x169/0x290
>> [ 2251.728719]  [<c02e5020>] ip_rcv+0x0/0x290
>> [ 2251.728719]  [<c02c1b4b>] netif_receive_skb+0x26b/0x470
>> [ 2251.728719]  [<f886c74d>] e1000_receive_skb+0x4d/0x1b0 [e1000e]
>> [ 2251.728719]  [<f886f9bc>] e1000_clean_rx_irq+0x23c/0x300 [e1000e]
>> [ 2251.728719]  [<f886bf59>] e1000_clean+0x49/0x1f0 [e1000e]
>> [ 2251.728719]  [<c02c3f58>] net_rx_action+0xf8/0x1b0
>> [ 2251.728719]  [<c012a062>] __do_softirq+0x82/0x100
>> [ 2251.728719]  [<c012a117>] do_softirq+0x37/0x40
>> [ 2251.728719]  [<c0107120>] do_IRQ+0x40/0x80
>> [ 2251.728719]  [<c01055a3>] common_interrupt+0x23/0x28
>> [ 2251.728719]  [<c010a5e2>] mwait_idle+0x32/0x40
>> [ 2251.728719]  [<c010a5b0>] mwait_idle+0x0/0x40
>> [ 2251.728719]  [<c01036e8>] cpu_idle+0x48/0xc0
>> [ 2251.728719]  =======================
>> [ 2251.728719] Code: 8d bc 27 00 00 00 00 55 89 d5 57 89 c7 56 53 90 8d
>> b4 26 00 00 00 00 8b 1f 83 e3 fc 74 32 8b 03 89 d9 a8 01 75 2a 89 c6 83
>> e6 fc <8b> 56 08 39 d3 74 45 85 d2 74 25 8b 02 a8 01 75 1f 83 c8 01 89
>>     
>
> At a guess I'd say that the hrtimer data structures got wrecked.
>
> If possible, please see if we fixed it in 2.6.27-rc8.  If so, there
> might be a patch we need to backport (although is might have been
> backported into later 2.6.25.x's as well).
>   
Ok. I will try. Only one question - iTCO watchdog don't work on this
platform (but chip have it... ICH9R). How i can reboot server remotely
if it halt?

Thanks!
