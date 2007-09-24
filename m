Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbXIXIKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbXIXIKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 04:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbXIXIKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 04:10:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:22752 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbXIXIKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 04:10:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=PgpHV3l53O0MGsX2/tWaswN2Na0GMNIyMrefcZHdj+6qlVK5EghAGWa4A6fIrsBD7mSoXBj4UyzDCXyJVIrwIGNfKkSXV3LUremPM0z3PIEz4kYV8YH57U+Se95kDH2dAl1cgKj27WBBohVQe13r0AfO5jhDxTMvhfV2e/UkQRg=
Message-ID: <46F770E2.7070909@gmail.com>
Date: Mon, 24 Sep 2007 10:10:10 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Matt Mackall <mpm@selenic.com>, Dave Airlie <airlied@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <21d7e9970709191842h3111390cl8f09745bed6bd8f9@mail.gmail.com> <20070920220604.GA17536@waste.org> <10207.1190394975@turing-police.cc.vt.edu> <46F3FF9C.7040200@gmail.com> <4109.1190403228@turing-police.cc.vt.edu> <46F41DC0.9060407@gmail.com> <46F41ED8.3020301@gmail.com> <18727.1190604314@turing-police.cc.vt.edu>            <46F753F5.7060707@gmail.com> <4399.1190619431@turing-police.cc.vt.edu>
In-Reply-To: <4399.1190619431@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2007 09:37 AM, Valdis.Kletnieks@vt.edu wrote:
> (Interestingly, I can't find any of the 3 addresses listed in the 'list_add
> corruption' message anywhere *else* in the netconsole output, and the last thing
> we hear from before the kersplat is apparently an RCU callback in a softirq?)

Hmm, there must be somebody else who changes it under hands without list_add.
Any lru skin game in the mid-layer nvidia sources? Do slab and slub behave the same?

[...]
> [   48.222000] 
> [   48.297000] POISONS (ffff810001179148): ffff810006bbc000, ffff81000341bec0
> [   48.297000] 
> [   48.297000] Call Trace:
> [   48.297000]  <IRQ>  [<ffffffff803580aa>] __list_add+0xd7/0x138
> [   48.297000]  [<ffffffff80358117>] list_add+0xc/0x11
> [   48.297000]  [<ffffffff80270865>] free_hot_cold_page+0xe8/0x16d
> [   48.297000]  [<ffffffff8027093e>] free_hot_page+0xb/0xd
> [   48.297000]  [<ffffffff80270958>] __free_pages+0x18/0x21
> [   48.297000]  [<ffffffff80270990>] free_pages+0x2f/0x34
> [   48.297000]  [<ffffffff8028922d>] kmem_freepages+0xc5/0xce
> [   48.297000]  [<ffffffff8028957f>] slab_destroy+0x3c/0x53
> [   48.297000]  [<ffffffff80289663>] free_block+0xcd/0x110
> [   48.297000]  [<ffffffff80289345>] cache_flusharray+0x71/0xa7
> [   48.297000]  [<ffffffff802894c2>] kmem_cache_free+0x99/0xb2
> [   48.297000]  [<ffffffff8029d8b2>] __d_free+0x30/0x34
> [   48.297000]  [<ffffffff8029dcb6>] d_callback+0xd/0xf
> [   48.297000]  [<ffffffff802458e0>] __rcu_process_callbacks+0x143/0x1da
> [   48.297000]  [<ffffffff8024599a>] rcu_process_callbacks+0x23/0x44
> [   48.297000]  [<ffffffff802396d2>] tasklet_action+0x54/0x9e
> [   48.297000]  [<ffffffff802395ad>] __do_softirq+0x57/0xc7
> [   48.297000]  [<ffffffff802398e3>] ksoftirqd+0x0/0x148
> [   48.297000]  [<ffffffff8020d32c>] call_softirq+0x1c/0x28
> [   48.297000]  <EOI>  [<ffffffff8020e916>] do_softirq+0x34/0x87
> [   48.297000]  [<ffffffff80239956>] ksoftirqd+0x73/0x148
> [   48.297000]  [<ffffffff80247ddd>] kthread+0x49/0x78
> [   48.297000]  [<ffffffff8020cfc8>] child_rip+0xa/0x12
> [   48.297000]  [<ffffffff80247d94>] kthread+0x0/0x78
> [   48.297000]  [<ffffffff8020cfbe>] child_rip+0x0/0x12
> [   48.297000] 
> [   48.297000] list_add corruption. next->prev should be prev (ffffffff8067e050), but was ffff8100066d59c0. (next=ffff81000119e560).
> [   48.297000] ------------[ cut here ]------------
> [   48.297000] kernel BUG at lib/list_debug.c:46!
> [   48.297000] invalid opcode: 0000 [1] PREEMPT SMP 
> [   48.297000] last sysfs file: /devices/pci0000:00/0000:00:1e.0/0000:03:01.4/resource
> [   48.297000] CPU 1 
> [   48.297000] Modules linked in: irnet(U) ppp_generic(U) slhc(U) irtty_sir(U) sir_dev(U) ircomm_tty(U) ircomm(U) irda(U) crc_ccitt(U) coretemp(U) nf_conntrack_ftp(U) xt_pkttype(U) ipt_REJECT(U) ipt_osf(U) nf_conntrack_ipv4(U) xt_ipisforif(U) ipt_recent(U) ipt_LOG(U) xt_u32(U) iptable_filter(U) ip_tables(U) xt_tcpudp(U) nf_conntrack_ipv6(U) xt_state(U) nf_conntrack(U) nfnetlink(U) ip6t_LOG(U) xt_limit(U) ip6table_filter(U) ip6_tables(U) x_tables(U) sha256(U) aes(U) fan(U) container(U) bay(U) acpi_cpufreq(U) nvram(U) pcmcia(U) firmware_class(U) yenta_socket(U) ohci1394(U) rsrc_nonstatic(U) iTCO_wdt(U) iTCO_vendor_support(U) watchdog_core(U) nvidia(P)(U) thermal(U) ieee1394(U) pcmcia_core(U) watchdog_dev(U) processor(U) snd_hda_intel(U) intel_agp(U) ac(U) button(U) video(U) battery(U) power_supply(U) output(U) rtc(U)
> [   48.297000] Pid: 7, comm: ksoftirqd/1 Tainted: P        2.6.23-rc6-mm1 #8
> [   48.297000] RIP: 0010:[<ffffffff803580ce>]  [<ffffffff803580ce>] __list_add+0xfb/0x138
> [   48.297000] RSP: 0000:ffff81000349fd38  EFLAGS: 00010002
> [   48.297000] RAX: 0000000000000088 RBX: ffff810001179148 RCX: ffffffff8061dbbb
> [   48.297000] RDX: 0000000100000000 RSI: 0000000000000006 RDI: ffffffff80672620
> [   48.297000] RBP: ffff81000349fd58 R08: ffffffff80672628 R09: 0000000000000000
> [   48.297000] R10: 00000000e731ffa2 R11: ffff81000349fa98 R12: ffff81000119e560
> [   48.297000] R13: ffffffff8067e050 R14: ffffffff8067df80 R15: ffff81000346d128
> [   48.297000] FS:  0000000000000000(0000) GS:ffff8100034689c0(0000) knlGS:0000000000000000
> [   48.297000] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [   48.297000] CR2: 000000000049b9b0 CR3: 0000000004168000 CR4: 00000000000006e0
> [   48.297000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   48.297000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   48.297000] Process ksoftirqd/1 (pid: 7, threadinfo ffff810003494000, task ffff810003463810)
> [   48.297000] last branch before last exception/interrupt
> [   48.297000]  from  [<ffffffff80234989>] printk+0xa3/0xa4
> [   48.297000]  to  [<ffffffff803580c8>] __list_add+0xf5/0x138
> [   48.297000] Stack:  ffff81000349fe60 ffff810001179120 ffffffff8067e040 0000000000000002
> [   48.297000]  ffff81000349fd68 ffffffff80358117 ffff81000349fd98 ffffffff80270865
> [   48.297000]  ffff810001000000 0000000000000000 ffff81000341bec0 ffff810006bbc000
> [   48.297000] Call Trace:
> [   48.297000]  <IRQ>  [<ffffffff80358117>] list_add+0xc/0x11
> [   48.297000]  [<ffffffff80270865>] free_hot_cold_page+0xe8/0x16d
> [   48.297000]  [<ffffffff8027093e>] free_hot_page+0xb/0xd
> [   48.297000]  [<ffffffff80270958>] __free_pages+0x18/0x21
> [   48.297000]  [<ffffffff80270990>] free_pages+0x2f/0x34
> [   48.297000]  [<ffffffff8028922d>] kmem_freepages+0xc5/0xce
> [   48.297000]  [<ffffffff8028957f>] slab_destroy+0x3c/0x53
> [   48.297000]  [<ffffffff80289663>] free_block+0xcd/0x110
> [   48.297000]  [<ffffffff80289345>] cache_flusharray+0x71/0xa7
> [   48.297000]  [<ffffffff802894c2>] kmem_cache_free+0x99/0xb2
> [   48.297000]  [<ffffffff8029d8b2>] __d_free+0x30/0x34
> [   48.297000]  [<ffffffff8029dcb6>] d_callback+0xd/0xf
> [   48.297000]  [<ffffffff802458e0>] __rcu_process_callbacks+0x143/0x1da
> [   48.297000]  [<ffffffff8024599a>] rcu_process_callbacks+0x23/0x44
> [   48.297000]  [<ffffffff802396d2>] tasklet_action+0x54/0x9e
> [   48.297000]  [<ffffffff802395ad>] __do_softirq+0x57/0xc7
> [   48.297000]  [<ffffffff802398e3>] ksoftirqd+0x0/0x148
> [   48.297000]  [<ffffffff8020d32c>] call_softirq+0x1c/0x28
> [   48.297000]  <EOI>  [<ffffffff8020e916>] do_softirq+0x34/0x87
> [   48.297000]  [<ffffffff80239956>] ksoftirqd+0x73/0x148
> [   48.297000]  [<ffffffff80247ddd>] kthread+0x49/0x78
> [   48.297000]  [<ffffffff8020cfc8>] child_rip+0xa/0x12
> [   48.297000]  [<ffffffff80247d94>] kthread+0x0/0x78
> [   48.297000]  [<ffffffff8020cfbe>] child_rip+0x0/0x12
> [   48.297000] 
> [   48.297000] 
> [   48.297000] Code: 0f 0b eb fe 49 8b 55 00 4c 39 e2 74 18 4c 89 e9 4c 89 e6 48 
> [   48.297000] RIP  [<ffffffff803580ce>] __list_add+0xfb/0x138
> [   48.297000]  RSP <ffff81000349fd38>
> 


-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
