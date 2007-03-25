Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbXCYWE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbXCYWE5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 18:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXCYWE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 18:04:57 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59997 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbXCYWEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 18:04:55 -0400
Date: Sun, 25 Mar 2007 14:01:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Cc: "Con Kolivas" <kernel@kolivas.org>, "Andy Whitcroft" <apw@shadowen.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, "Steve Fox" <drfickle@us.ibm.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>
Subject: Re: debug rsdl 0.33
Message-Id: <20070325140131.ebc97e20.akpm@linux-foundation.org>
In-Reply-To: <64bb37e0703251128q3f9db894u24c4638dcf97224a@mail.gmail.com>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<4603C7EC.6030906@shadowen.org>
	<200703240845.30484.kernel@kolivas.org>
	<200703241026.57143.kernel@kolivas.org>
	<64bb37e0703251128q3f9db894u24c4638dcf97224a@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007 19:28:57 +0100 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:

> On 3/24/07, Con Kolivas <kernel@kolivas.org> wrote:
> >  kernel/sched.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 51 insertions(+)
> 
> 2.6.21-rc4-mm1 also fails for me.
> 
> I tried pure 2.6.21-rc4-mm1, +hotfixes, +hotfixes+rsdl33 and at last
> also added above debug patch.
> 
> The oops from with the debug-patch added:
> [   65.426126] Freeing unused kernel memory: 312k freed
> (on the console the system is starting up, getting until "Letting udev
> process events ...")
> [   66.665611] Unable to handle kernel NULL pointer dereference at
> 0000000000000020 RIP:
> [   66.682030]  [<ffffffff8026167c>] __sched_text_start+0x4dc/0xa0e
> [   66.707402] PGD 0
> [   66.713473] Oops: 0000 [1] SMP
> [   66.722968] last sysfs file:
> devices/pci0000:00/0000:00:05.0/host2/target2:0:0/2:0:0:0/type
> [   66.747954] CPU 0
> [   66.754025] Modules linked in:
> [   66.763209] Pid: 1200, comm: udevd Not tainted 2.6.21-rc4-mm1 #4
> [   66.781162] RIP: 0010:[<ffffffff8026167c>]  [<ffffffff8026167c>]
> __sched_text_start+0x4dc/0xa0e
> [   66.807236] RSP: 0018:ffff81007d38fe78  EFLAGS: 00010082
> [   66.823115] RAX: ffffffffffffffd0 RBX: 000000000000008c RCX: 000000000000058e
> [   66.844439] RDX: 0000000000000000 RSI: 000000000000000c RDI: 0000000000000000
> [   66.865767] RBP: ffff81007d38ff08 R08: 0000000000000064 R09: ffff810001014a58
> [   66.887092] R10: 000000000000001c R11: 0000000000000246 R12: ffff810001013700
> [   66.908418] R13: ffff810001014198 R14: 0000000000000001 R15: 0000000f859461fc
> [   66.929745] FS:  00002b67df90e6d0(0000) GS:ffffffff807aa000(0000)
> knlGS:0000000000000000
> [   66.953950] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   66.971126] CR2: 0000000000000020 CR3: 0000000000201000 CR4: 00000000000006e0
> [   66.992451] Process udevd (pid: 1200, threadinfo ffff81007d38e000,
> task ffff81007e354100)
> [   67.016915] Stack:  00000000000004b0 0000000000000000
> 0000000000000000 ffff81007e354100
> [   67.041097]  ffffffffffffffd0 ffff81007e354298 ffff81011d420680
> ffffffff802234b1
> [   67.063407]  0000000000000001 0000000000000000 0000000000000000
> 0000000000000246
> [   67.085149] Call Trace:
> [   67.093037]  [<ffffffff802234b1>] filp_close+0x71/0x90
> [   67.108397]  [<ffffffff80214d97>] do_exit+0x7e7/0x800
> [   67.123495]  [<ffffffff80248372>] do_group_exit+0x82/0x90
> [   67.139634]  [<ffffffff8025c1de>] system_call+0x7e/0x83
> [   67.155277]
> [   67.159739]
> [   67.159740] Code: 48 39 48 50 0f 84 8b 00 00 00 48 c7 40 40 00 00 00 00 8b 52
> [   67.186877] RIP  [<ffffffff8026167c>] __sched_text_start+0x4dc/0xa0e
> [   67.205919]  RSP <ffff81007d38fe78>
> [   67.216348] CR2: 0000000000000020
> [   67.226260] Fixing recursive fault but reboot is needed!

We've seen multiple reports of this.

For some reason we've managed to confuse kallsyms too.

> The system in x86_64, two 2218 on a MCP55 nvidia chipset.
> 
> 2.6.21-rc3-mm1 works fine.
> 
> (gdb) list *0xffffffff8026167c
> 0xffffffff8026167c is in schedule (kernel/sched.c:3619).
> 3614            /*
> 3615             * When the task is chosen it is checked to see if its
> quota has been
> 3616             * added to this runqueue level which is only performed once per
> 3617             * level per major rotation for each running task.
> 3618             */
> 3619            if (next->rotation != rq->prio_rotation) {
> 3620                            /* Task has moved during major rotation */
> 3621                            task_new_array(next, rq);
> 3622                            if (!entitled_slot(next->static_prio, idx))
> 3623                                    exchange_slot(next, rq);
> 
> 

Ah, that helps, thanks.

