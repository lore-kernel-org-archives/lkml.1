Return-Path: <linux-kernel-owner+w=401wt.eu-S935428AbZLGQpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935428AbZLGQpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935376AbZLGQpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:45:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935321AbZLGQpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:45:42 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] cfq-iosched: reduce write depth only if sync was delayed
References: <4b1a3d84.0d0db80a.39d0.ffff814a@mx.google.com>
	<4e5e476b0912050313k280caa8bjf7c2cf1c5d19c88c@mail.gmail.com>
	<4e5e476b0912060245x4d64300hb9689243bd712f2c@mail.gmail.com>
	<20091206104950.GN8742@kernel.dk>
	<x49iqciyis3.fsf@segfault.boston.devel.redhat.com>
	<20091207144149.GZ8742@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 07 Dec 2009 11:45:43 -0500
In-Reply-To: <20091207144149.GZ8742@kernel.dk> (Jens Axboe's message of "Mon,
	7 Dec 2009 15:41:50 +0100")
Message-ID: <x493a3mg2bs.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Mon, Dec 07 2009, Jeff Moyer wrote:
>> Jens Axboe <jens.axboe@oracle.com> writes:
>> 
>> > On Sun, Dec 06 2009, Corrado Zoccolo wrote:
>> >> Hi Jeff,
>> >> I remember you saw large performance drop on your SAN for sequential
>> >> writes with low_latency=1.  Can you test if Shaohua's and this patch
>> >> fix allow to recover some bandwidth?  I think that enabling the queue
>> >> depth ramp up only if a sync request was delayed should disable it for
>> >> fast hardware like yours, so you should not be seeing the slowdown any
>> >> more.
>> >
>> > I queued this up for post inclusion into 2.6.33, with the time_after()
>> > fixed.
>> >
>> > The patch was word-wrapped, btw.
>> 
>> So in what branch can I find this fix?  Once I know that I can queue up
>> some tests.
>
> It's in next-2.6.33

next-2.6.33 won't boot for me:

general protection fault: 0000 [#1] SMP
async/0 used greatest stack depth: 4256 bytes left

last sysfs file: /sys/class/firmware/timeout
CPU 1
Modules linked in: ata_piix pata_acpi libata sd_mod scsi_mod ext3 jbd mbcache uh
ci_hcd ohci_hcd ehci_hcd
Pid: 729, comm: async/1 Not tainted 2.6.32 #1 ProLiant DL320 G5p
RIP: 0010:[<ffffffff81199cee>]  [<ffffffff81199cee>] cfq_put_cfqg+0x0/0x91
RSP: 0018:ffff8801251b1d48  EFLAGS: 00010002
RAX: ffff880126dcdd28 RBX: ffff8801251fa158 RCX: 0000000000170001
RDX: ffff880125556700 RSI: ffff8801251fa158 RDI: 6b6b6b6b6b6b6b6b
RBP: ffff8801251b1d70 R08: ffff8801255a0448 R09: 000000000000005a
R10: ffff8801255a0448 R11: ffffffff818d6210 R12: ffff880126dcdb18
R13: ffff880126dcdb50 R14: 0000000000000286 R15: ffff880125556760
FS:  0000000000000000(0000) GS:ffff88002f200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 00000001256a5000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process async/1 (pid: 729, threadinfo ffff8801251b0000, task ffff880125556770)
Stack:
 ffffffff8119a856 0000000000000002 ffff880126dcdb18 ffff8801251fa158
<0> ffff880125210000 ffff8801251b1d90 ffffffff8119a9e5 ffff8801251f80d0
<0> ffff880126dcdb18 ffff8801251b1db0 ffffffff8119aa62 ffff880126dcdb18
Call Trace:
 [<ffffffff8119a856>] ? cfq_put_queue+0xfa/0x102
 [<ffffffff8119a9e5>] cfq_exit_cfqq+0x99/0x9e
 [<ffffffff8119aa62>] __cfq_exit_single_io_context+0x78/0x85
 [<ffffffff8119aaa9>] cfq_exit_single_io_context+0x3a/0x52
 [<ffffffff8119aa6f>] ? cfq_exit_single_io_context+0x0/0x52
 [<ffffffff8119b27b>] call_for_each_cic+0x56/0x7c
 [<ffffffff8119b225>] ? call_for_each_cic+0x0/0x7c
 [<ffffffff8119b2b1>] cfq_exit_io_context+0x10/0x12
 [<ffffffff81192d3b>] exit_io_context+0x93/0xbc
 [<ffffffff81192d03>] ? exit_io_context+0x5b/0xbc
 [<ffffffff810474e5>] do_exit+0x71a/0x747
 [<ffffffff810628f1>] ? async_thread+0x0/0x1fa
 [<ffffffff8105cd9e>] kthread_stop+0x0/0xb3
 [<ffffffff81033fa6>] ? complete+0x1c/0x4b
 [<ffffffff8100cafa>] child_rip+0xa/0x20
 [<ffffffff8103d667>] ? finish_task_switch+0x0/0xe3
 [<ffffffff8100c4bc>] ? restore_args+0x0/0x30
 [<ffffffff8105ccf8>] ? kthreadd+0xdf/0x100
 [<ffffffff8105cd19>] ? kthread+0x0/0x85
 [<ffffffff8100caf0>] ? child_rip+0x0/0x20
Code: 48 c7 43 38 00 00 00 00 48 c7 43 40 00 00 00 00 48 89 3e 48 8b 73 48 e8 fd 9e 00 00 eb 08 48 c7 43 48 00 00 00 00 5b 41 5c c9 c3 <8b> 87 d8 01 00 00 55 48 89 e5 85 c0 7f 04 0f 0b eb fe 48 8d 87
RIP  [<ffffffff81199cee>] cfq_put_cfqg+0x0/0x91
 RSP <ffff8801251b1d48>
---[ end trace ac909576caca45e8 ]---

