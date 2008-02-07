Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbYBGJff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbYBGJff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbYBGJfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:35:16 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:45970 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbYBGJfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:35:13 -0500
Message-ID: <47AAD0CB.3090305@linux.vnet.ibm.com>
Date: Thu, 07 Feb 2008 15:05:07 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.26-git0: IDE oops during boot
References: <20080206105334.GA3664@elf.ucw.cz> <20080206110805.GB3613@elf.ucw.cz> <200802062105.42929.bzolnier@gmail.com>
In-Reply-To: <200802062105.42929.bzolnier@gmail.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> On Wednesday 06 February 2008, Pavel Machek wrote:
>> On Wed 2008-02-06 11:53:34, Pavel Machek wrote:
>>> Hi!
>>>
>>> Trying to boot 2.6.25-git0 (few days old), I get
>>>
>>> BUG: unable to handle kernel paging request at ffff..ffb0
>>> IP at init_irq+0x42e
> 
> init_irq? hmm...
> 
>>> Call trace:
>>> ide_device_add_all
> 
> this comes from ide-generic
> (Generic IDE host driver)
> 
>>> ide_generic_init
>>> kernel_init
>>> child_rip
>>> vgacon_cursor
>>> kernel_init
>>> child_rip
>>>
>>> Excerpt from config:
>>>
>>> CONFIG_IDE=y
>>> CONFIG_BLK_DEV_IDE=y
>> Disabling CONFIG_IDE made my machine boot, as it was using libata
>> anyway.
> 
> Kamalesh/Pavel:
> 
> Could you try latest git and see if the OOPS is still there?
> 
> [ Yeah, I'm unable to reproduce it. :( ]
> 
> Thanks,
> Bart
Hi Bart,

The panic is reproducible with the 2.6.24-git16 kernel, the call trace is
similar to the previous one

BUG: unable to handle kernel paging request at ffffffffffffffa0
IP: [<ffffffff80415673>] init_irq+0x188/0x444
PGD 203067 PUD 204067 PMD 0 
Oops: 0000 [1] SMP 
CPU 3 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.24-git16 #1
RIP: 0010:[<ffffffff80415673>]  [<ffffffff80415673>] init_irq+0x188/0x444
RSP: 0000:ffff81022f093e00  EFLAGS: 00010282
RAX: ffffffffffffff80 RBX: ffffffff808ad200 RCX: 0000000000000000
RDX: 00000000ffffffff RSI: ffff81022fc039c0 RDI: ffffffff807512c0
RBP: ffff81022f093e30 R08: ffff81022f093d70 R09: 0000000000000002
R10: 0000000000000001 R11: ffff81022f093c00 R12: ffffffff808b4500
R13: ffffffff808b4510 R14: 0000000000000000 R15: ffffffffffffffff
FS:  0000000000000000(0000) GS:ffff81022f0e7ac0(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffffffffffffffa0 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81022f092000, task ffff81022f0797e0)
Stack:  ffff81022f093e30 0000000000000000 ffffffff808ad200 ffffffff808ad220
 ffffffff808add80 0000000000000000 ffff81022f093eb0 ffffffff8041648f
 ffff81022f093ec0 0000000000000000 0000000080751ee0 0000000000000246
Call Trace:
 [<ffffffff8041648f>] ide_device_add_all+0xb60/0xe54
 [<ffffffff807d6d48>] ide_generic_init+0x46/0x4a
 [<ffffffff807b873b>] kernel_init+0x175/0x2e7
 [<ffffffff8020bff8>] child_rip+0xa/0x12
 [<ffffffff8037476c>] acpi_ds_init_one_object+0x0/0x88
 [<ffffffff807b85c6>] kernel_init+0x0/0x2e7
 [<ffffffff8020bfee>] child_rip+0x0/0x12


Code: 89 03 49 8b 45 18 48 89 18 48 39 1b 75 04 0f 0b eb fe fe 05 20 71 38 00 fb eb 5b 48 8b 83 20 07 00 00 83 ca ff 48 83 c0 80 74 0e <48> 8b 40 20 48 8b 80 88 00 00 00 8b 50 04 48 8b 3d 48 11 30 00 
RIP  [<ffffffff80415673>] init_irq+0x188/0x444
 RSP <ffff81022f093e00>
CR2: ffffffffffffffa0
---[ end trace 165798c72d52c3e3 ]---


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
