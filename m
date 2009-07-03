Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbZGCI0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbZGCI0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbZGCI0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:26:02 -0400
Received: from mail-bw0-f207.google.com ([209.85.218.207]:38833 "EHLO
	mail-bw0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbZGCIZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:25:59 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jul 2009 04:25:59 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=NFCJfCgxZUhprRVLPz0Y8yGrwqStuik1DeC43mRDWpjbpva1i21e5xsKiXgq8yF/PM
         ObUhVlScpya6g8BP254YpwMMLMfEYVu7yui7WUWao59oOlr+asIAbncO0p/MaUiw3EWB
         BE7QTe9VEzXK0A36gwRS/c+SxjgR65+J5qV5M=
Message-ID: <4A4DBF16.1020509@gmail.com>
Date: Fri, 03 Jul 2009 10:19:34 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.7 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: BUG at mm/vmscan.c:904 [mmotm 2009-07-02-19-57]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I don't know what exactly lead to this, but I got it when installing a
kernel rpm (io load) in qemu:

------------[ cut here ]------------
kernel BUG at mm/vmscan.c:904!
invalid opcode: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:05.0/modalias
CPU 0
Modules linked in: e1000
Pid: 290, comm: kswapd0 Tainted: G       AW  2.6.31-rc1-mm1 #103
RIP: 0010:[<ffffffff81095c96>]  [<ffffffff81095c96>]
isolate_pages_global+0x196/0x260
RSP: 0018:ffff880011943c40  EFLAGS: 00010082
RAX: 00000000ffffffea RBX: ffffea0000050170 RCX: 0000000000000001
RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffea0000050170
RBP: ffff880011943cd0 R08: 0000000000000001 R09: ffffffff81668b00
R10: 00000000ffffffff R11: 0000000000000001 R12: ffffffff81669060
R13: ffffea0000050198 R14: ffff880011943d50 R15: ffffffff81668b00
FS:  0000000000000000(0000) GS:ffff88000176f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f5d32981000 CR3: 0000000011adb000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kswapd0 (pid: 290, threadinfo ffff880011942000, task
ffff88001254c840)
Stack:
 ffff880011943d68 0000000000000020 0000000000000030 000000020177f4b0
<0> 0000000000000003 000000008103329b 0000000000000001 ffffffffffffffff
<0> 0000000100000003 0000000000000000 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff81096ae6>] shrink_active_list+0xa6/0x330
 [<ffffffff81032fe8>] ? task_rq_lock+0x48/0x90
 [<ffffffff810985c0>] ? kswapd+0x0/0x770
 [<ffffffff81098ab5>] kswapd+0x4f5/0x770
 [<ffffffff81037177>] ? pick_next_task_fair+0xd7/0xf0
 [<ffffffff810985c0>] ? kswapd+0x0/0x770
 [<ffffffff81095b00>] ? isolate_pages_global+0x0/0x260
 [<ffffffff8103f1ed>] ? default_wake_function+0xd/0x10
 [<ffffffff8105aa30>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff813f9978>] ? preempt_schedule+0x38/0x60
 [<ffffffff813fbb40>] ? _spin_unlock_irqrestore+0x30/0x40
 [<ffffffff810985c0>] ? kswapd+0x0/0x770
 [<ffffffff8105a6b6>] kthread+0x96/0xa0
 [<ffffffff8100ceaa>] child_rip+0xa/0x20
 [<ffffffff8105a620>] ? kthread+0x0/0xa0
 [<ffffffff8100cea0>] ? child_rip+0x0/0x20
Code: 80 75 12 8b 55 bc 8b 75 b4 4c 89 ef e8 f4 f9 ff ff 85 c0 74 79 49
ff c7 49 83 c5 38 4c 39 7d 98 77 cf 48 ff 45 c8 e9 e9 fe ff ff <0f> 0b
eb fe 48 8b 53 30 48 8b 4b 28 48 8d 43 28 48 89 51 08 48
RIP  [<ffffffff81095c96>] isolate_pages_global+0x196/0x260
 RSP <ffff880011943c40>
---[ end trace fc1de39f3465335f ]---
note: kswapd0[290] exited with preempt_count 1
