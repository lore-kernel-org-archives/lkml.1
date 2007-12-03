Return-Path: <linux-kernel-owner+w=401wt.eu-S1751433AbXLCU1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbXLCU1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 15:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbXLCU13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 15:27:29 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:63488 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbXLCU11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 15:27:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vyNDztEfGsdHlnL3XIpL1pt1f3nwG1xNvBKZHEUAYPginOqqGyLxia3GbqK+uBe1/emk7n9QD5nKe8Hd0jbotieprDJ6CGVAdB+3J71PYUFlTDc4/2AdJIZjB5lJOe/2Knl6vMJcyvqNt5uHnKIe6pInNIdomOlU7UBlTyLUVm0=
Message-ID: <64bb37e0712031227p4eac4f34x4b89047f75931000@mail.gmail.com>
Date: Mon, 3 Dec 2007 21:27:21 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc3-mm2
Cc: linux-kernel@vger.kernel.org, trond.myklebust@fys.uio.no,
       stefanr@s5r6.in-berlin.de, "J. Bruce Fields" <bfields@fieldses.org>
In-Reply-To: <20071129130756.7550ce13.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071128034140.648383f0.akpm@linux-foundation.org>
	 <64bb37e0711291258v1a51598bm36a1b953eab9fdd1@mail.gmail.com>
	 <20071129130756.7550ce13.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2007 10:07 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 29 Nov 2007 21:58:16 +0100
> "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
>
> > But after ~1h of usage I got two different crashes on my x86_64 box.
>
> Nice, thanks.  By finding these now you (hopefully) saved a whole lot of
> people a whole lot of grief a couple months from now.

Thats part of why I use/test the mm-kernels. :-)

> > I hope, the CC's are correct...
>
> Bruce works on NFS things too.
>
>
> > First crash:
> >
> > [ 1116.083651] Unable to handle kernel NULL pointer dereference at
> > 0000000000000378 RIP:
> > [ 1116.089216]  [<ffffffff8047cb88>] ether1394_dg_complete+0x28/0xa0
> > [ 1116.097883] PGD 51880067 PUD 4a08b067 PMD 0
> > [ 1116.102232] Oops: 0000 [1] SMP
> > [ 1116.105423] last sysfs file:
> > /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map

[snip]

> Yep, looks like a genuine 1394 bug.
> > I then change the network from ether1394 to a real network card, but
> > this also crashed:
> > [  602.464580] ------------[ cut here ]------------
> > [  602.469250] kernel BUG at lib/list_debug.c:33!
> > [  602.473731] invalid opcode: 0000 [1] SMP
> > [  602.477828] last sysfs file:
> > /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
[snip]
> > [  602.515102] Pid: 7452, comm: nfsv4-svc Not tainted 2.6.24-rc3-mm2 #1
[snip]
> > Both times the system hung with Caps Lock and Scroll Lock where blinking.
>
> And one in NFS.

I'm starting to think, I'm seeing "random" memory corruptions.
(But I do not think that this is hardware related, I would had
expected a warning of some kind, if my ECC-RAM really had gone bad...)

Yesterday the system worked a hole day perfectly, today it crashed again.
Again Caps Lock and Scroll Lock where blinking, but the crash was at
yet another subsystem.

Todays stacktrace:
[ 1397.050713] Unable to handle kernel NULL pointer dereference at
0000000000000000 RIP:
[ 1397.052918]  [<ffffffff80297323>] kmem_cache_alloc_node+0x63/0x90
[ 1397.056357] PGD 115dd2067 PUD 115c1e067 PMD 0
[ 1397.058153] Oops: 0000 [1] SMP
[ 1397.059424] last sysfs file:
/sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
[ 1397.062560] CPU 3
[ 1397.063372] Modules linked in: radeon drm nfsd exportfs w83792d
ipv6 tuner tea5767 tda8290 tuner_xc2028 tda9887 tuner_simple mt20xx
tea5761 tvaudio msp3400 bttv ir_common compat_ioctl32 videobuf_dma_sg
videobuf_core btcx_risc tveeprom videodev usbhid v4l2_common
v4l1_compat hid i2c_nforce2 pata_amd sg
[ 1397.074283] Pid: 0, comm: swapper Not tainted 2.6.24-rc3-mm2 #2
[ 1397.076646] RIP: 0010:[<ffffffff80297323>]  [<ffffffff80297323>]
kmem_cache_alloc_node+0x63/0x90
[ 1397.080179] RSP: 0018:ffff81011ff7fb10  EFLAGS: 00010246
[ 1397.082301] RAX: 0000000000000000 RBX: ffff81008005e980 RCX: ffffffff8052e159
[ 1397.085164] RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffffffff807e7e80
[ 1397.088022] RBP: ffff81011ff7fb30 R08: 000000000029d8f0 R09: 000000000014ec78
[ 1397.090879] R10: 00000000000005a8 R11: 0000000000000001 R12: 00000000ffffffff
[ 1397.093732] R13: 0000000000000020 R14: 0000000000000020 R15: ffffffff807e7e80
[ 1397.096583] FS:  00007f064c8b9700(0000) GS:ffff81011ff23d00(0000)
knlGS:0000000000000000
[ 1397.099839] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 1397.102121] CR2: 0000000000000000 CR3: 0000000115dd0000 CR4: 00000000000006e0
[ 1397.104982] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1397.107835] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1397.110697] Process swapper (pid: 0, threadinfo FFFF81007FFAC000,
task FFFF81011FF72000)
[ 1397.113949] Stack:  0000000000000008 ffff810108c1e000
00000000ffffffff 00000000000000d0
[ 1397.117206]  ffff81011ff7fb70 ffffffff8052e159 000000001ff7fbd0
ffff810108c1e000
[ 1397.120185]  0000000000000000 ffff8100d61f2400 ffff8100d61f2438
0000000000000000
[ 1397.123116] Call Trace:
[ 1397.124171]  <IRQ>  [<ffffffff8052e159>] __alloc_skb+0x49/0x150
[ 1397.126557]  [<ffffffff805682be>] tcp_send_ack+0x2e/0x120
[ 1397.128725]  [<ffffffff8056524c>] __tcp_ack_snd_check+0x5c/0xa0
[ 1397.131093]  [<ffffffff80566b53>] tcp_rcv_established+0x3b3/0x800
[ 1397.133515]  [<ffffffff8056dfca>] tcp_v4_do_rcv+0x2da/0x6a0
[ 1397.135763]  [<ffffffff80570f48>] tcp_v4_rcv+0x978/0xac0
[ 1397.137904]  [<ffffffff805501b3>] ip_local_deliver_finish+0xd3/0x250
[ 1397.140440]  [<ffffffff8055079b>] ip_local_deliver+0x3b/0x90
[ 1397.142708]  [<ffffffff8054fde9>] ip_rcv_finish+0x119/0x410
[ 1397.144920]  [<ffffffff8025ac75>] __lock_acquire+0x725/0x1130
[ 1397.147229]  [<ffffffff8055068a>] ip_rcv+0x22a/0x300
[ 1397.149192]  [<ffffffff80533836>] netif_receive_skb+0x1d6/0x280
[ 1397.151556]  [<ffffffff8053649c>] process_backlog+0x7c/0xf0
[ 1397.153785]  [<ffffffff805364aa>] process_backlog+0x8a/0xf0
[ 1397.155997]  [<ffffffff80536126>] net_rx_action+0xb6/0x130
[ 1397.158209]  [<ffffffff8023bf54>] __do_softirq+0x84/0x110
[ 1397.160369]  [<ffffffff8020cf3c>] call_softirq+0x1c/0x30
[ 1397.162489]  [<ffffffff8020f155>] do_softirq+0x65/0xc0
[ 1397.164545]  [<ffffffff8023bec5>] irq_exit+0x95/0xa0
[ 1397.166527]  [<ffffffff8020f26f>] do_IRQ+0x8f/0x100
[ 1397.168470]  [<ffffffff8020ac80>] default_idle+0x0/0x60
[ 1397.170568]  [<ffffffff8020ac80>] default_idle+0x0/0x60
[ 1397.172650]  [<ffffffff8020c236>] ret_from_intr+0x0/0xf
[ 1397.174741]  <EOI>  [<ffffffff8020acb7>] default_idle+0x37/0x60
[ 1397.177131]  [<ffffffff8020acb5>] default_idle+0x35/0x60has
[ 1397.179266]  [<ffffffff8020ad4b>] cpu_idle+0x6b/0xa0
[ 1397.181236]  [<ffffffff8080a368>] start_secondary+0x2f8/0x430
[ 1397.183523]
[ 1397.184115] INFO: lockdep is turned off.
[ 1397.185691]
[ 1397.185691] Code: 4c 8b 04 c6 48 89 f0 4c 0f b1 03 48 39 f0 49 89
c4 75 b0 eb
[ 1397.189307] RIP  [<ffffffff80297323>] kmem_cache_alloc_node+0x63/0x90
[ 1397.191891]  RSP <ffff81011ff7fb10>
[ 1397.193305] CR2: 0000000000000000
[ 1397.194638] Kernel panic - not syncing: Aiee, killing interrupt handler!

I put some WARN_ON's into ether1394_dg_complete() to see what happened
there, but these never triggered.
Is "last sysfs file:
/sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map" relevant, or
just glibc checking for NUMA?

I don't know in what direction I should look to find the cause of this.
Using slub_debug=FZP?

I have:
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
Would an addition CONFIG_IOMMU_DEBUG (or something else) make sense?

Torsten
