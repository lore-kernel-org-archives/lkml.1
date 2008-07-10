Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbYGJNR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbYGJNR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbYGJNRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:17:16 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:64411 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbYGJNRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:17:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZlSbKJZGptHoeykbh5wMhly8WOw+xF3CV/mzXa0LW/BCM34EkaCgw4kJkwssy++U1H
         D6XboJiI8VmDKHDrFcsPD9nc8MOTLNY/VjWyEachm6Gcu59MFAcHfqwU3H2kA3wEHowE
         gZKapiX3Aj5g11Er5a+XCtgCwOio70CrI1QLM=
Message-ID: <19f34abd0807100617m10338f97ic6fa7e74ddf2ac80@mail.gmail.com>
Date: Thu, 10 Jul 2008 15:17:09 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: v2.6.26-rc9: kernel BUG at kernel/sched.c:5858!
Cc: Yanmin <yanmin_zhang@linux.intel.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>, miaox@cn.fujitsu.com,
       "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Avi Kivity" <avi@qumranet.com>,
       linux-kernel@vger.kernel.org, "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <19f34abd0807100604p70c2fec6geca65b2ba772dea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710115954.GA3639@damson.getinternet.no>
	 <19f34abd0807100512y7fff3716r3ff37305e863f26@mail.gmail.com>
	 <b647ffbd0807100550l44fae9fate511dafbf87564a4@mail.gmail.com>
	 <19f34abd0807100604p70c2fec6geca65b2ba772dea@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 3:04 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> Does a patch from Miao Xie available via the link below makes this
>> problem disappear? Both bugs are likely to have the same cause.
>>
>> http://lkml.org/lkml/2008/7/7/75
>
> Yep, it does, nice, thanks!

I got something else now though:

Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 19762, comm: grep Not tainted (2.6.26-rc9-00059-gb190333 #5)
EIP: 0060:[<c01991c7>] EFLAGS: 00210203 CPU: 0
EIP is at kmem_cache_alloc+0xc7/0xe0
EAX: 00000000 EBX: f6c3d0f0 ECX: 1adabf16 EDX: 6b6b6b6b
ESI: 00200282 EDI: f6c44000 EBP: e7c2befc ESP: e7c2bedc
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process grep (pid: 19762, ti=e7c2a000 task=f7875fa0 task.ti=e7c2a000)
Stack: c02fabd5 f6ca2f20 c02fabd5 000080d0 c075a720 c06f8a4c f78a1000 c02fa7a0
       e7c2bf28 c02fabd5 00000001 c1c987ec 00000000 f5b55000 f6df5f58 f72ea548
       c06f8a4c fffffffb c02fab70 e7c2bf3c c02fa9b6 f6df5f20 c06f8a60 f727df78
Call Trace:
 [<c02fabd5>] ? show_uevent+0x65/0xe0
 [<c02fabd5>] ? show_uevent+0x65/0xe0
 [<c02fa7a0>] ? dev_uevent+0x0/0x1f0
 [<c02fabd5>] ? show_uevent+0x65/0xe0
 [<c02fab70>] ? show_uevent+0x0/0xe0
 [<c02fa9b6>] ? dev_attr_show+0x26/0x50
 [<c01dd1ec>] ? sysfs_read_file+0x7c/0x110
 [<c01a7015>] ? putname+0x25/0x40
 [<c019eec4>] ? vfs_read+0x94/0x130
 [<c01dd170>] ? sysfs_read_file+0x0/0x110
 [<c019f3ed>] ? sys_read+0x3d/0x70
 [<c0104ceb>] ? sysenter_past_esp+0x78/0xd1
 =======================
Code: b9 ff ff ff ff 8b 55 ec 89 7c 24 04 89 04 24 8b 45 f0 e8 4d f6 ff ff 89 c3
 eb a0 85 db 74 bc 8b 57 10 31 c0 89 df 89 d1 c1 e9 02 <f3> ab f6 c2 02 74 02 66
 ab f6 c2 01 74 01 aa eb 9f 90 8d b4 26
EIP: [<c01991c7>] kmem_cache_alloc+0xc7/0xe0 SS:ESP 0068:e7c2bedc
---[ end trace 348b87fe341cfd2d ]---
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1/1 ip 6000
Initializing CPU#1
list_add corruption. prev->next should be next (c0859130), but was 00000000. (pr
ev=f6c41f34).
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:33!
invalid opcode: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 9, comm: events/0 Tainted: G      D   (2.6.26-rc9-00059-gb190333 #5)
EIP: 0060:[<c0294b9c>] EFLAGS: 00010082 CPU: 0
EIP is at __list_add+0x5c/0x60
EAX: 00000061 EBX: f6c41f34 ECX: f7894000 EDX: 00000002
ESI: 00000000 EDI: c0858b80 EBP: f7895ed8 ESP: f7895ec0
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process events/0 (pid: 9, ti=f7894000 task=f7898ff0 task.ti=f7894000)
Stack: c067fd80 c0859130 00000000 f6c41f34 0000c3b1 f6e90154 f7895ee8 c013e276
       c0858b80 f6e90154 f7895f08 c013ec41 0000c3b1 00000000 00000096 00000000
       f6e90154 ffffffff f7895f20 c0145d6e ffffffff f6e90134 00000088 00000078
Call Trace:
 [<c013e276>] ? internal_add_timer+0x36/0xb0
 [<c013ec41>] ? __mod_timer+0x91/0xe0
 [<c0145d6e>] ? queue_delayed_work_on+0x8e/0xd0
 [<c0145f42>] ? queue_delayed_work+0x22/0x30
 [<c0145f61>] ? schedule_delayed_work+0x11/0x20
 [<c02d701c>] ? flush_to_ldisc+0x18c/0x1b0
 [<c014558b>] ? run_workqueue+0x15b/0x1f0
 [<c0145537>] ? run_workqueue+0x107/0x1f0
 [<c02d6e90>] ? flush_to_ldisc+0x0/0x1b0
 [<c0146009>] ? worker_thread+0x99/0xf0
 [<c0148b60>] ? autoremove_wake_function+0x0/0x50
 [<c0145f70>] ? worker_thread+0x0/0xf0
 [<c0148872>] ? kthread+0x42/0x70
 [<c0148830>] ? kthread+0x0/0x70
 [<c0105a63>] ? kernel_thread_helper+0x7/0x14
 =======================
Code: 5c 24 04 c7 04 24 30 fd 67 c0 e8 80 0c ea ff 0f 0b eb fe 89 5c 24 0c 89 74
 24 08 89 4c 24 04 c7 04 24 80 fd 67 c0 e8 64 0c ea ff <0f> 0b eb fe 8b 0a 55 89
 e5 e8 96 ff ff ff 5d c3 90 90 90 90 55
EIP: [<c0294b9c>] __list_add+0x5c/0x60 SS:ESP 0068:f7895ec0
---[ end trace 348b87fe341cfd2d ]---
note: events/0[9] exited with preempt_count 2

..and then it died.

This happened just as I killed syslog, does that seem related somehow?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
