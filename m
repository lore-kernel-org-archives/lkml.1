Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbYGWVWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbYGWVWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 17:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbYGWVWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 17:22:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:51361 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000AbYGWVWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:22:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pNmaG4j65dVxMIfiyaLO5cpoytSArvbkAdhd/6CsIuADvXR63HjG8XzHpPrxtcu1M+
         i/6HvbTfhNtcYZplC1a7E+LfpjvNs+BlDQLWtdl3/jnQwIVQJ0y5YInwGYC1nhBc7R5R
         w9JWP1i+UZEZNki1bD5RgcseGgy31vuUtkBZo=
Message-ID: <19f34abd0807231422m30dcdaf3ice9010aa8260ca50@mail.gmail.com>
Date: Wed, 23 Jul 2008 23:22:31 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: recent -git: BUG in free_thread_xstate
Cc: LKML <linux-kernel@vger.kernel.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Maxim Krasnyansky" <maxk@qualcomm.com>
In-Reply-To: <20080723203109.GH14380@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807231307y191c0ad7tfab4cda57ee88eb@mail.gmail.com>
	 <20080723203109.GH14380@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 10:31 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Wed, Jul 23, 2008 at 01:07:04PM -0700, Vegard Nossum wrote:
>> Hi,
>>
>> I just got this on c010b2f76c3032e48097a6eef291d8593d5d79a6 (-git from
>> yesterday):
>
> Do you see this in 2.6.26 aswell? I suspect it is coming from post 2.6.26
> changes.

Yep. Got this on 2.6.26 now:

BUG: unable to handle kernel paging request at 00664381
IP: [<c010b884>] free_thread_xstate+0x4/0x30
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 3796, comm: bash Not tainted (2.6.26 #1)
EIP: 0060:[<c010b884>] EFLAGS: 00210246 CPU: 0
EIP is at free_thread_xstate+0x4/0x30
EAX: 00664001 EBX: f3870000 ECX: 00000004 EDX: f4b544e8
ESI: f4bdef28 EDI: c07feda0 EBP: f5325bd0 ESP: f5325bcc
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process bash (pid: 3796, ti=f5324000 task=f4b53fc0 task.ti=f5324000)
Stack: f3870000 f5325bdc c010b8bd f4bddfa0 f5325be8 c0132b89 f4bddfa0 f5325bf4
       c0133fd1 f4b77e00 f5325bfc c01368a7 f5325c14 c0172b8c 00200282 c0752b40
       00000001 00000009 f5325c30 c0139cd3 c0803d00 c0803d00 c0803d00 00200046
Call Trace:
 [<c010b8bd>] ? free_thread_info+0xd/0x20
 [<c0132b89>] ? free_task+0x19/0x30
 [<c0133fd1>] ? __put_task_struct+0x51/0xa0
 [<c01368a7>] ? delayed_put_task_struct+0x27/0x30
 [<c0172b8c>] ? rcu_process_callbacks+0x6c/0xb0
 [<c0139cd3>] ? __do_softirq+0x83/0x100
 [<c0139df5>] ? do_softirq+0xa5/0xb0
 [<c0139f95>] ? irq_exit+0x95/0xa0
 [<c0107e4d>] ? do_IRQ+0x4d/0xa0
 [<c01057b2>] ? common_interrupt+0x2e/0x34
 [<c013549e>] ? vprintk+0x1be/0x420
 [<c010aea5>] ? native_sched_clock+0xb5/0x110
 [<c010aea5>] ? native_sched_clock+0xb5/0x110
 [<c013571b>] ? printk+0x1b/0x20
 [<c012cbec>] ? cpu_attach_domain+0x3ec/0x410
 [<c010aea5>] ? native_sched_clock+0xb5/0x110
 [<c01979e1>] ? check_bytes_and_report+0x21/0xc0
 [<c0197d8f>] ? check_object+0xdf/0x1f0
 [<c0126c17>] ? sd_free_ctl_entry+0x37/0x50
 [<c0157895>] ? mark_held_locks+0x65/0x80
 [<c0199055>] ? kfree+0xb5/0x120
 [<c0157a24>] ? trace_hardirqs_on+0xd4/0x160
 [<c0126c17>] ? sd_free_ctl_entry+0x37/0x50
 [<c0126c17>] ? sd_free_ctl_entry+0x37/0x50
 [<c0126c17>] ? sd_free_ctl_entry+0x37/0x50
 [<c012cc3e>] ? detach_destroy_domains+0x2e/0x50
 [<c012cc9b>] ? update_sched_domains+0x3b/0x50
 [<c014d467>] ? notifier_call_chain+0x37/0x70
 [<c014d4d9>] ? __raw_notifier_call_chain+0x19/0x20
 [<c055c858>] ? _cpu_down+0x78/0x240
 [<c015d92f>] ? cpu_maps_update_begin+0xf/0x20
 [<c055ca4b>] ? cpu_down+0x2b/0x40
 [<c055dc69>] ? store_online+0x39/0x80
 [<c055dc30>] ? store_online+0x0/0x80
 [<c02faf6b>] ? sysdev_store+0x2b/0x40
 [<c01dcdd2>] ? sysfs_write_file+0xa2/0x100
 [<c019eb76>] ? vfs_write+0x96/0x130
 [<c01dcd30>] ? sysfs_write_file+0x0/0x100
 [<c019f23d>] ? sys_write+0x3d/0x70
 [<c0104cdb>] ? sysenter_past_esp+0x78/0xd1
 =======================
Code: 04 00 00 00 00 c7 04 24 00 00 04 00 e8 96 f8 08 00 a3 b4 a5 80
c0 c9 c3 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90 90 55 89 e5 53 <8b>
90 80 03 00 00 89 c3 85 d2 74 14 a1 b4 a5 80 c0 e8 d6 e4 08
EIP: [<c010b884>] free_thread_xstate+0x4/0x30 SS:ESP 0068:f5325bcc
Kernel panic - not syncing: Fatal exception in interrupt

I'm not sure what to make of this. It looks related to the rebuilding
of sched domains that we saw earlier. But this reproduces on both
v2.6.26 and latest -git (though not with that backtrace).

Notice that the magic number is still the same -- 0x00664381. I'm curious.

Ah. The code decodes to:
         mov    0x380(%rax),%edx

so the "real" magic number must be the one in %rax, 0x00664001. This
looks slightly more like a magic number. The middle two bytes may be
character codes: "f@"

I'm adding some of the people from the whole sched domain thing thread to Cc.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
