Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbXIAJPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbXIAJPj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 05:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbXIAJPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 05:15:18 -0400
Received: from doppler.zen.co.uk ([212.23.3.27]:41676 "EHLO doppler.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbXIAJPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 05:15:14 -0400
Date: Sat, 1 Sep 2007 10:11:10 +0100
From: Grant Wilson <grant.wilson@zen.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: Linux 2.6.23-rc5 - oops
Message-ID: <20070901101110.038835c2@worthy.swandive.local>
In-Reply-To: <alpine.LFD.0.999.0708312343440.27951@evo.linux-foundation.org>
References: <alpine.LFD.0.999.0708312343440.27951@evo.linux-foundation.org>
X-Mailer: Claws Mail 3.0.0-rc2 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-Rutherford-IP: [82.71.45.175]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007 23:52:36 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> I'm making ready to leave for the kernel summit (as are probably a
> lot of other core kernel people), and as part of that, there's a
> 2.6.23-rc5 out there now.
> 
> Hopefully we've addressed most regressions, so please do give it a
> good testing.
> 
[snip] 
> Tejun Heo (3):
>       ata_piix: add Satellite U200 to broken suspend list
>       libata: implement BROKEN_HPA horkage and apply it to affected
> drives ata_piix: implement IOCFG bit18 quirk

Hi,
Get an oops when booting this kernel:

[   49.178892] Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
[   49.178905]  [<ffffffff803af352>] strlen+0x2/0x20
[   49.180550] PGD 0
[   49.181368] Oops: 0000 [1] PREEMPT SMP
[   49.182189] CPU 0
[   49.182994] Modules linked in:
[   49.183805] Pid: 1, comm: swapper Not tainted 2.6.23-rc5 #2
[   49.184619] RIP: 0010:[<ffffffff803af352>]  [<ffffffff803af352>] strlen+0x2/0x20
[   49.185445] RSP: 0000:ffff8100cff27be0  EFLAGS: 00010246
[   49.186264] RAX: 0000000000000000 RBX: ffffffff809002c0 RCX: 0000000000000008
[   49.187101] RDX: 000000000000830f RSI: 0000000000000000 RDI: 0000000000000000
[   49.187947] RBP: ffff8100cff27c00 R08: 0000000000000009 R09: 0000000000000008
[   49.188804] R10: 00000000000000fa R11: 0000000000000000 R12: ffffffff80833778
[   49.189660] R13: 0000000000000000 R14: ffff8100cfe77070 R15: ffffffff8068cd20
[   49.190508] FS:  0000000000000000(0000) GS:ffffffff80881000(0000) knlGS:0000000000000000
[   49.191365] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   49.192230] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
[   49.193103] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   49.193988] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   49.194878] Process swapper (pid: 1, threadinfo ffff8100cff26000, task ffff8100cff24000)
[   49.195772] Stack:  ffffffff803af644 0000000000000000 ffffffff80833778 0000000000000000
[   49.196697]  ffff8100cff27c30 ffffffff804f3d96 ffff8100cfe77000 ffffffff8068d1a8
[   49.197620]  ffff8100cfe77000 ffff8100cff27c70 ffff8100cff27d40 ffffffff80491f04
[   49.197648] Call Trace:
[   49.199465]  [<ffffffff803af644>] strstr+0x24/0x80
[   49.200382]  [<ffffffff804f3d96>] dmi_check_system+0x46/0x90
[   49.201300]  [<ffffffff80491f04>] piix_init_one+0x184/0x630
[   49.202214]  [<ffffffff802d40d0>] sysfs_ilookup_test+0x0/0x20
[   49.203126]  [<ffffffff803c1a86>] pci_device_probe+0x76/0xa0
[   49.204033]  [<ffffffff8044e9a8>] driver_probe_device+0xa8/0x1b0
[   49.204941]  [<ffffffff8044ec85>] __driver_attach+0xe5/0xf0
[   49.205847]  [<ffffffff8044eba0>] __driver_attach+0x0/0xf0
[   49.206750]  [<ffffffff8044dbc3>] bus_for_each_dev+0x53/0x80
[   49.207648]  [<ffffffff8044e7dc>] driver_attach+0x1c/0x20
[   49.208542]  [<ffffffff8044dfd5>] bus_add_driver+0xa5/0x1e0
[   49.209430]  [<ffffffff8044eecd>] driver_register+0x4d/0x80
[   49.210307]  [<ffffffff803c1cb8>] __pci_register_driver+0x78/0xc0
[   49.211184]  [<ffffffff808ce089>] piix_init+0x19/0x30
[   49.212048]  [<ffffffff808b0774>] kernel_init+0x154/0x340
[   49.212905]  [<ffffffff80643714>] _spin_unlock_irq+0x14/0x40
[   49.213769]  [<ffffffff8020cb68>] child_rip+0xa/0x12
[   49.214621]  [<ffffffff808b0620>] kernel_init+0x0/0x340
[   49.215472]  [<ffffffff8020cb5e>] child_rip+0x0/0x12
[   49.216318]
[   49.217153]
[   49.217153] Code: 80 3f 00 55 48 89 e5 74 11 48 89 f8 66 90 48 83 c0 01 80 38
[   49.218908] RIP  [<ffffffff803af352>] strlen+0x2/0x20
[   49.219752]  RSP <ffff8100cff27be0>
[   49.220580] CR2: 0000000000000000
[   49.221451] Kernel panic - not syncing: Attempted to kill init!


Using git-bisect the faulty commit is

bad: [43a98f05d99205687ddf74089e79a8312c8c5f90] ata_piix: implement IOCFG bit18 quirk

Cheers,
Grant

