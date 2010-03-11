Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab0CKUNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 15:13:54 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:35947 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756243Ab0CKUNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 15:13:53 -0500
Message-ID: <4B994EFE.70005@msgid.tls.msk.ru>
Date: Thu, 11 Mar 2010 23:13:50 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-aio@kvack.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: aio: compat_ioctl issue?
References: <4B956E5B.9020302@msgid.tls.msk.ru>	<x497hpm8p69.fsf@segfault.boston.devel.redhat.com>	<4B957122.4060007@msgid.tls.msk.ru>	<x49mxyi78ob.fsf@segfault.boston.devel.redhat.com>	<4B957AF3.6040801@msgid.tls.msk.ru>	<4B957D20.4010904@msgid.tls.msk.ru>	<x49wrxij11s.fsf@segfault.boston.devel.redhat.com>	<4B994022.6030703@msgid.tls.msk.ru>	<4B994888.8020007@msgid.tls.msk.ru> <x49eijqiqcd.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49eijqiqcd.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer wrote:
> Michael Tokarev <mjt@tls.msk.ru> writes:
[]
>> And when running real thing it crashes.   I tested it
>> on 2.6.32 (trivial corrections to the patch required).
> 
> Could you just post your version of the patch so I can have a look?

I think there's no need since in 2.6.33 (where your patch applies
without any offsets) it crashes in exactly the same way:

------
BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff810bbf37>] generic_segment_checks+0x17/0xd0
PGD 184f1c067 PUD 184cd1067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/input/mice/uevent
CPU 1
Pid: 5182, comm: kvm Not tainted 2.6.33-amd64 #2.6.33.0 M3A78-EM/System Product Name
RIP: 0010:[<ffffffff810bbf37>]  [<ffffffff810bbf37>] generic_segment_checks+0x17/0xd0
RSP: 0000:ffff880184d71d30  EFLAGS: 00010202
RAX: ffff88018f2eeed8 RBX: ffff880184d71da0 RCX: 0000000000000001
RDX: ffff880184d71dd0 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff880184d71dd0 R08: ffffffffffffffea R09: ffff88018f2eef08
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff88018cff3e00 R15: ffff880184c49b00
FS:  0000000000000000(0000) GS:ffff880028280000(0063) knlGS:00000000f6f75b70
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 0000000000000008 CR3: 0000000184e9b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kvm (pid: 5182, threadinfo ffff880184d70000, task ffff880184d6a080)
Stack:
 ffff88018f2eee80 ffff88018f2eee80 ffffffff810be7a2 ffff880184c90a70
<0> ffff88018f2eeed8 ffff880184c91680 ffff880184c91678 000000000000004f
<0> ffffffff81403680 fffffffe7ffbfeff 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff810be7a2>] ? generic_file_aio_read+0x52/0x620
 [<ffffffff810f3296>] ? cache_alloc_refill+0x96/0x5e0
 [<ffffffff810be750>] ? generic_file_aio_read+0x0/0x620
 [<ffffffff81135634>] ? aio_rw_vect_retry+0x74/0x1f0
 [<ffffffff81136e02>] ? aio_run_iocb+0x82/0x140
 [<ffffffff8113777c>] ? do_io_submit+0x2cc/0x7b0
 [<ffffffff81031412>] ? ia32_sysret+0x0/0x5
Code: 82 40 2c 40 81 c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 45 31 d2 48 89 d5 53 48 89 f3 48 8b 36 48 85 f6 0f 84 84 00 00 00 <4c> 8b 57 08 4d 85 d2 0f 88 8c 00 00 00 48 8b 07 65 4c 8b 04 25
RIP  [<ffffffff810bbf37>] generic_segment_checks+0x17/0xd0
 RSP <ffff880184d71d30>
CR2: 0000000000000008
---[ end trace 78b5aba2446c4209 ]---

For 2.6.32, the differences were all in fs/aio.c, in 2
places: include file (obvious),

 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
                          struct iocb *iocb, struct hlist_head *batch_hash)

in 2.6.32 it does not have the last 'batch_hash' parameter,
and the only caller of this routine in io_submit() down in
that file.  So the change is trivial and purely mechanical.

But it is not here yet.  I'm trying to dig further...

/mjt
